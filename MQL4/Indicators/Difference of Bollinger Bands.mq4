//+------------------------------------------------------------------+
//|                                   candlestick's_shadow_lines.mq4 |
//|                                 Copyright 2017, Keisuke Iwabuchi |
//|                                        https://order-button.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Keisuke Iwabuchi"
#property link      "https://order-button.com/"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 clrOrange
#property  indicator_width1 1
#property  indicator_style1 0


enum price_constants {
   CLOSE   = 0, // 終値
   OPEN    = 1, // 始値
   HIGH    = 2, // 高値
   LOW     = 3, // 安値
   MEDIAN  = 4, // 中央値(高値+安値)÷2
   TYPICAL = 5, // 代表値(高値+安値+終値)÷3
   WEGHTED = 6  // 加重終値(高値+安値+終値+終値)÷4
};


input int             period    = 20;    // period(期間)
input double          deviation = 2.0;   // deviation(偏差)
input price_constants price     = CLOSE; // price(適用価格)


double value[];


int OnInit()
{
   IndicatorBuffers(1);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, value);
   IndicatorDigits(Digits);
   
   return(INIT_SUCCEEDED);
}


int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   double upper, lower;
   int pt = price;
   int limit = Bars - IndicatorCounted();
   
   for(int i = limit - 1; i >= 0; i--){
      upper = iBands(_Symbol, 0, period, deviation, 0, pt, MODE_UPPER, i);
      lower = iBands(_Symbol, 0, period, deviation, 0, pt, MODE_LOWER, i);
      value[i] = upper - lower;
   }

   return(rates_total);
}

