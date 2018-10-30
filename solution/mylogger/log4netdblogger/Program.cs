using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace log4netdblogger
{
    class Program
    {
        static void Main(string[] args)
        {
            LogUtil.Log4netLogger.Info(MethodBase.GetCurrentMethod().DeclaringType, "1");
            LogUtil.Log4netLogger.Debug(MethodBase.GetCurrentMethod().DeclaringType, "1");
            LogUtil.Log4netLogger.Warn(MethodBase.GetCurrentMethod().DeclaringType, "1");
            LogUtil.Log4netLogger.Fatal(MethodBase.GetCurrentMethod().DeclaringType, "1");
            int divisor = 0, i = 1;
            try
            {
                var result = i / divisor;
            }
            catch (Exception e)
            {
                LogUtil.Log4netLogger.Error(MethodBase.GetCurrentMethod().DeclaringType, "Divided by 0.", e);
            }
        }
    }
}
