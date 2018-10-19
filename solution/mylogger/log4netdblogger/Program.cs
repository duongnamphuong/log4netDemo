using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace log4netdblogger
{
    class Program
    {
        static void Main(string[] args)
        {
            LogUtil.Log4netLogger.Info("1");
            int divisor = 0, i = 1;
            try
            {
                var result = i / divisor;
            }
            catch (Exception e)
            {
                LogUtil.Log4netLogger.Error("Divided by 0.", e);
            }
        }
    }
}
