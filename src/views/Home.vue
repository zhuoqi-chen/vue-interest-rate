<template>
  <div class="home">
    <h2>贷款实时利率计算器</h2>
    <el-row :gutter="20">
      <el-col :xs="24" :md="12">
        <el-input type="number" v-model="borrow" placeholder="单位:元">
            <template slot="prepend">贷款总额</template>
        </el-input>
        <el-input type="number" v-model="stages" placeholder="单位:月">
            <template slot="prepend">分期数</template>
        </el-input>
        <el-input type="number" v-model="serviceCharge" placeholder="单位:元">
            <template slot="prepend">每期手续费</template>
        </el-input>
        <table>
          <tr>
            <th>总利息</th>
            <td>{{interestTotal}}</td>
          </tr>
          <tr>
            <th>总利率(单利)</th>
            <td>{{interestRateTotal | percent}}</td>
          </tr>
          <tr>
            <th>月利率(单利)</th>
            <td>{{interestRateMonthly | percent}}</td>
          </tr>
        </table>
      </el-col>
      <el-col :xs="24" :md="12">
        <el-table
              :data="tableData"
              stripe
              height="600"
              style="width: 100%">
              <el-table-column
                prop="month"
                label="月"
                width="50"
                >
              </el-table-column>
              <el-table-column
                prop="capitalMonthly"
                label="当月还款">
                <template slot-scope="scope">
                    <span>{{ scope.row.capitalMonthly | baoliu}}</span>
                </template>
              </el-table-column>
              <el-table-column
                prop="shengYuBenjing"
                label="剩余本金">
                <template slot-scope="scope">
                    <span>{{ scope.row.shengYuBenjing | baoliu}}</span>
                </template>
              </el-table-column>
              <el-table-column
                prop="trueInterestRateyearly"
                label="实时年利率">
              <template slot-scope="scope">
                    <span>{{ scope.row.trueInterestRateyearly | percent}}</span>
              </template>
              </el-table-column>
              <el-table-column
                prop="trueInterestRateMonthly"
                label="实时月利率">
                <template slot-scope="scope">
                    <span>{{ scope.row.trueInterestRateMonthly | percent}}</span>
                </template>
              </el-table-column>
        </el-table>
      </el-col>
    </el-row>
    
  </div>
</template>

<script>
export default {
  name: "home",
  data() {
    return {
      borrow: 100000, //借款数
      stages: 60, //分期数
      serviceCharge: 260
    };
  },
  computed: {
    interestTotal() {
      return this.stages * this.serviceCharge;
    },
    interestRateTotal() {
      return this.interestTotal / this.borrow;
    },
    interestRateMonthly() {
      return this.interestRateTotal / this.stages;
    },
    capitalMonthly() {
      return this.borrow / this.stages;
    },
    tableData() {
      let arr = [];
      if (!this.stages || !this.borrow) {
        return arr;
      }
      for (
        let month = 1, shengYuBenjing = this.borrow;
        shengYuBenjing > 0.1;
        month++
      ) {
        shengYuBenjing = shengYuBenjing - this.capitalMonthly;
        const trueInterestRateMonthly =
          this.serviceCharge / (shengYuBenjing + this.capitalMonthly);
        const trueInterestRateyearly = trueInterestRateMonthly * 12;
        arr.push({
          month,
          shengYuBenjing,
          capitalMonthly: this.capitalMonthly,
          trueInterestRateMonthly,
          trueInterestRateyearly
        });
      }
      return arr;
    }
  },
  filters: {
    percent(value) {
      return (value * 100).toFixed(4) + "%";
    },
    baoliu(value) {
      return value.toFixed(2);
    }
  }
};
</script>
<style lang="scss">
.el-input .el-input-group__prepend {
  width: 5em;
}
</style>
