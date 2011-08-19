From: Anand Jain <Anand.Jain@oracle.com>
Subject: btrfs and mainline and git
Date: Fri, 19 Aug 2011 14:46:26 +0800
Message-ID: <4E4E06C2.6090205@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Hello,

1.
  I normally copy btrfs into the mainline and run make,
  however with the recent btrfs release its failing with
  the following,  any idea. ?

---------------------------------------------
# make
scripts/kconfig/conf --silentoldconfig Kconfig
fs/btrfs/Kconfig:6: syntax error
fs/Kconfig:9: missing end statement for this entry
fs/Kconfig:5: missing end statement for this entry
fs/btrfs/Kconfig:5: invalid statement
arch/x86/Kconfig:253: recursive inclusion detected. Inclusion path:
   current file : 'arch/x86/Kconfig'
   included from: 'fs/btrfs/Kconfig:11'
   included from: 'fs/Kconfig:36'
   included from: 'arch/x86/Kconfig:2145'
make[2]: *** [silentoldconfig] Error 1
make[1]: *** [silentoldconfig] Error 2
make: *** No rule to make target `include/config/auto.conf', needed by 
`include/config/kernel.release'.  Stop.
#
---------------------------------------------


2.
  Looks like the official way is to use git merge. What are the
  recommended git (merge ?) steps, to integrate btrfs into the mainline
  ?

Thanks for your time,
-Anand
