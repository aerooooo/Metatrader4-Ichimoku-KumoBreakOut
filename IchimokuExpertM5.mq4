//+------------------------------------------------------------------+
//|                                             IchimokuExpertM5.mq4 |
//|                     Copyright 2017, investdata.000webhostapp.com |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, investdata.000webhostapp.com"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   EventSetTimer(10);

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
double open_arrayM5[];
double high_arrayM5[];
double low_arrayM5[];
double close_arrayM5[];

bool first_run_done=false;
static datetime LastBarTime[];//=-1;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {

   if(first_run_done==false)
     {
      int stotal=SymbolsTotal(true); // seulement les symboles dans le marketwatch (false)

      ArrayResize(LastBarTime,stotal);

      //initialisation de tout le tableau à false car sinon la première valeur vaut true par défaut (bug?).
      for(int sindex=0; sindex<stotal; sindex++)
        {
         LastBarTime[sindex]=-1;
        }

      first_run_done=true;
     }

   int stotal=SymbolsTotal(true); // seulement les symboles dans le marketwatch (false)

   for(int sindex=0; sindex<stotal; sindex++)
     {
      string sname=SymbolName(sindex,true);
      //printf("processing "+sname);

      datetime ThisBarTime=(datetime)SeriesInfoInteger(sname,PERIOD_M5,SERIES_LASTBAR_DATE);
      if(ThisBarTime==LastBarTime[sindex])
        {
         //printf("Same bar time ("+sname+")");
        }
      else
        {
         if(LastBarTime[sindex]==-1)
           {
            //printf("First bar ("+sname+")");
            LastBarTime[sindex]=ThisBarTime;
           }
         else
           {
            //printf("New bar time ("+sname+")");
            LastBarTime[sindex]=ThisBarTime;

            ArraySetAsSeries(open_arrayM5,true);
            int numO=CopyOpen(sname,PERIOD_M5,0,32,open_arrayM5);
            ArraySetAsSeries(high_arrayM5,true);
            int numH=CopyHigh(sname,PERIOD_M5,0,32,high_arrayM5);
            ArraySetAsSeries(low_arrayM5,true);
            int numL=CopyLow(sname,PERIOD_M5,0,32,low_arrayM5);
            ArraySetAsSeries(close_arrayM5,true);
            int numC=CopyClose(sname,PERIOD_M5,0,32,close_arrayM5);

            //printf(sname+" : jcs(-1) open = "+DoubleToString(open_arrayM1[1]));
            //printf(sname+" : jcs(-1) close = "+DoubleToString(close_arrayM1[1]));

            double tenkan_sen=iIchimoku(sname,PERIOD_M5,9,26,52,MODE_TENKANSEN,1);
            double kijun_sen=iIchimoku(sname,PERIOD_M5,9,26,52,MODE_KIJUNSEN,1);
            //printf(sname+" : tenkan sen = "+DoubleToString(tenkan_sen));
            //printf(sname+" : kijun sen = "+DoubleToString(kijun_sen));

            if(open_arrayM5[1]<kijun_sen && close_arrayM5[1]>kijun_sen)
              {
               SendNotification(sname+" : jcs(m5(-1)) has crossed kijun while up.");
              }

           }
        }

     }
  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   double ret=0.0;
//---

//---
   return(ret);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---

  }
//+------------------------------------------------------------------+
