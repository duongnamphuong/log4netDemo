using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace log4netdblogger
{
    class Program
    {
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        static void Main(string[] args)
        {
            log.Info("1");
            int divisor = 0, i = 1;
            try
            {
                var result = i / divisor;
            }
            catch (Exception e)
            {
                log.Error("Divided by 0.", e);
            }
        }
    }
}
