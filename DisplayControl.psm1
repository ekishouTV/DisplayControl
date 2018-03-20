# Source: http://qiita.com/sharow/items/ef78f2f5a8053f6a7a41#comment-2830a2c713d96f3c0281
# Source: http://www.powershellmagazine.com/2013/07/18/pstip-how-to-switch-off-display-with-powershell/
#         https://gist.github.com/oledid/fb02951b6b1848d1418d

# Turn display off by calling WindowsAPI.
 
# SendMessage(HWND_BROADCAST,WM_SYSCOMMAND, SC_MONITORPOWER, POWER_OFF)
# HWND_BROADCAST  0xffff
# WM_SYSCOMMAND   0x0112
# SC_MONITORPOWER 0xf170
# POWER_OFF       0x0002
 
Add-Type -TypeDefinition '
using System;
using System.Runtime.InteropServices;
 
namespace Utilities {
   public static class Display
   {
      [DllImport("user32.dll", CharSet = CharSet.Auto)]
      private static extern IntPtr SendNotifyMessage(
         IntPtr hWnd,
         UInt32 Msg,
         IntPtr wParam,
         IntPtr lParam
      );
 
      [DllImport("user32.dll", SetLastError = true)]
      private static extern bool LockWorkStation();

      public static void PowerOff ()
      {
         SendNotifyMessage(
            (IntPtr)0xffff, // HWND_BROADCAST
            0x0112,         // WM_SYSCOMMAND
            (IntPtr)0xf170, // SC_MONITORPOWER
            (IntPtr)0x0002  // POWER_OFF
         );
      }

      public static void Lock ()
      {
         LockWorkStation();
      }
   }
}
'

function Lock-Display
{
    [Utilities.Display]::Lock()
}

function TurnOff-Display
{
    param(
        [switch]$WithLock
    )

    [Utilities.Display]::PowerOff()
    if ($WithLock) {Lock-Display}
}
