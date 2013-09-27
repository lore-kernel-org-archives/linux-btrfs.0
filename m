Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:51972 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab3I0Xpv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 19:45:51 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1VPhjK-0004ht-Cz
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Sep 2013 16:45:50 -0700
Date: Fri, 27 Sep 2013 16:45:50 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs race conditions on snapshot delete/create
Message-ID: <20130927234550.GJ22921@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I had a cronjob that mistakenly created and deleted snapshots in the same
place at the same time.

Interesting output I got:
/var/local/scr/btrfs_snaps: line 23: 26017 Segmentation fault      (core dumped) /sbin/btrfs subvolume delete "$sub"

On ubuntu precise (i.e. super ancient), but I upgraded userland:
polgara:~$ btrfs --version
Btrfs v0.20-rc1
Kernel 3.2.5.


Sorry, aptport stole my crashes and apparently didn't give a backtrace, but
that's what I have if this helps:

ProblemType: Crash
Architecture: amd64
Date: Thu Sep 26 22:00:03 2013
DistroRelease: Ubuntu 12.04
ExecutablePath: /sbin/btrfs
ExecutableTimestamp: 1380251279
ProcCmdline: /sbin/btrfs subvolume delete google_hourly_20130926_19:00:01
ProcCwd: /mnt/btrfs_pool1
ProcEnviron:
 SHELL=/bin/sh
 PATH=(custom, no user)
ProcMaps:
 00400000-00442000 r-xp 00000000 fc:00 399893                             /sbin/btrfs
 00641000-00643000 r--p 00041000 fc:00 399893                             /sbin/btrfs
 00643000-00644000 rw-p 00043000 fc:00 399893                             /sbin/btrfs
 00644000-00646000 rw-p 00000000 00:00 0 
 01b05000-01b26000 rw-p 00000000 00:00 0                                  [heap]
 7fb153b8e000-7fb153d43000 r-xp 00000000 fc:00 2232563                    /lib/x86_64-linux-gnu/libc-2.15.so
 7fb153d43000-7fb153f42000 ---p 001b5000 fc:00 2232563                    /lib/x86_64-linux-gnu/libc-2.15.so
 7fb153f42000-7fb153f46000 r--p 001b4000 fc:00 2232563                    /lib/x86_64-linux-gnu/libc-2.15.so
 7fb153f46000-7fb153f48000 rw-p 001b8000 fc:00 2232563                    /lib/x86_64-linux-gnu/libc-2.15.so
 7fb153f48000-7fb153f4d000 rw-p 00000000 00:00 0 
 7fb153f4d000-7fb153f65000 r-xp 00000000 fc:00 2233530                    /lib/x86_64-linux-gnu/libpthread-2.15.so
 7fb153f65000-7fb154164000 ---p 00018000 fc:00 2233530                    /lib/x86_64-linux-gnu/libpthread-2.15.so
 7fb154164000-7fb154165000 r--p 00017000 fc:00 2233530                    /lib/x86_64-linux-gnu/libpthread-2.15.so
 7fb154165000-7fb154166000 rw-p 00018000 fc:00 2233530                    /lib/x86_64-linux-gnu/libpthread-2.15.so
 7fb154166000-7fb15416a000 rw-p 00000000 00:00 0 
 7fb15416a000-7fb15416d000 r-xp 00000000 fc:00 2228482                    /lib/x86_64-linux-gnu/libcom_err.so.2.1
 7fb15416d000-7fb15436c000 ---p 00003000 fc:00 2228482                    /lib/x86_64-linux-gnu/libcom_err.so.2.1
 7fb15436c000-7fb15436d000 r--p 00002000 fc:00 2228482                    /lib/x86_64-linux-gnu/libcom_err.so.2.1
 7fb15436d000-7fb15436e000 rw-p 00003000 fc:00 2228482                    /lib/x86_64-linux-gnu/libcom_err.so.2.1
 7fb15436e000-7fb15438e000 r-xp 00000000 fc:00 2232137                    /lib/liblzo2.so.2
 7fb15438e000-7fb15458d000 ---p 00020000 fc:00 2232137                    /lib/liblzo2.so.2
 7fb15458d000-7fb15458e000 rw-p 0001f000 fc:00 2232137                    /lib/liblzo2.so.2
 7fb15458e000-7fb1545a4000 r-xp 00000000 fc:00 2228617                    /lib/x86_64-linux-gnu/libz.so.1.2.3.4
 7fb1545a4000-7fb1547a3000 ---p 00016000 fc:00 2228617                    /lib/x86_64-linux-gnu/libz.so.1.2.3.4
 7fb1547a3000-7fb1547a4000 r--p 00015000 fc:00 2228617                    /lib/x86_64-linux-gnu/libz.so.1.2.3.4
 7fb1547a4000-7fb1547a5000 rw-p 00016000 fc:00 2228617                    /lib/x86_64-linux-gnu/libz.so.1.2.3.4
 7fb1547a5000-7fb1548a0000 r-xp 00000000 fc:00 2256906                    /lib/x86_64-linux-gnu/libm-2.15.so
 7fb1548a0000-7fb154a9f000 ---p 000fb000 fc:00 2256906                    /lib/x86_64-linux-gnu/libm-2.15.so
 7fb154a9f000-7fb154aa0000 r--p 000fa000 fc:00 2256906                    /lib/x86_64-linux-gnu/libm-2.15.so
 7fb154aa0000-7fb154aa1000 rw-p 000fb000 fc:00 2256906                    /lib/x86_64-linux-gnu/libm-2.15.so
 7fb154aa1000-7fb154ac3000 r-xp 00000000 fc:00 2228442                    /lib/x86_64-linux-gnu/libblkid.so.1.1.0
 7fb154ac3000-7fb154cc3000 ---p 00022000 fc:00 2228442                    /lib/x86_64-linux-gnu/libblkid.so.1.1.0
 7fb154cc3000-7fb154cc6000 r--p 00022000 fc:00 2228442                    /lib/x86_64-linux-gnu/libblkid.so.1.1.0
 7fb154cc6000-7fb154cc7000 rw-p 00025000 fc:00 2228442                    /lib/x86_64-linux-gnu/libblkid.so.1.1.0
 7fb154cc7000-7fb154ccb000 r-xp 00000000 fc:00 2228602                    /lib/x86_64-linux-gnu/libuuid.so.1.3.0
 7fb154ccb000-7fb154eca000 ---p 00004000 fc:00 2228602                    /lib/x86_64-linux-gnu/libuuid.so.1.3.0
 7fb154eca000-7fb154ecb000 r--p 00003000 fc:00 2228602                    /lib/x86_64-linux-gnu/libuuid.so.1.3.0
 7fb154ecb000-7fb154ecc000 rw-p 00004000 fc:00 2228602                    /lib/x86_64-linux-gnu/libuuid.so.1.3.0
 7fb154ecc000-7fb154eee000 r-xp 00000000 fc:00 2256912                    /lib/x86_64-linux-gnu/ld-2.15.so
 7fb1550c6000-7fb1550cb000 rw-p 00000000 00:00 0 
 7fb1550ec000-7fb1550ee000 rw-p 00000000 00:00 0 
 7fb1550ee000-7fb1550ef000 r--p 00022000 fc:00 2256912                    /lib/x86_64-linux-gnu/ld-2.15.so
 7fb1550ef000-7fb1550f1000 rw-p 00023000 fc:00 2256912                    /lib/x86_64-linux-gnu/ld-2.15.so
 7fffe703f000-7fffe7060000 rw-p 00000000 00:00 0                          [stack]
 7fffe70df000-7fffe70e0000 r-xp 00000000 00:00 0                          [vdso]
 ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]
ProcStatus:
 Name:	btrfs
 State:	S (sleeping)
 Tgid:	31926
 Pid:	31926
 PPid:	31856
 TracerPid:	0
 Uid:	0	0	0	0
 Gid:	0	0	0	0
 FDSize:	256
 Groups:	0 128 71252 
 VmPeak:	   20440 kB
 VmSize:	   20436 kB
 VmLck:	       0 kB
 VmPin:	       0 kB
 VmHWM:	     824 kB
 VmRSS:	     824 kB
 VmData:	     208 kB
 VmStk:	     136 kB
 VmExe:	     264 kB
 VmLib:	    3364 kB
 VmPTE:	      64 kB
 VmSwap:	       0 kB
 Threads:	1
 SigQ:	8/514713
 SigPnd:	0000000000000000
 ShdPnd:	0000000000000000
 SigBlk:	0000000000000000
 SigIgn:	0000000000000000
 SigCgt:	0000000180000000
 CapInh:	0000000000000000
 CapPrm:	ffffffffffffffff
 CapEff:	ffffffffffffffff
 CapBnd:	ffffffffffffffff
 Cpus_allowed:	ffffffff
 Cpus_allowed_list:	0-31
 Mems_allowed:	00000000,00000003
 Mems_allowed_list:	0-1
 voluntary_ctxt_switches:	3
 nonvoluntary_ctxt_switches:	1
Signal: 11
Uname: Linux 3.2.5-gg1336 x86_64
UserGroups: pkcs11 root root

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
