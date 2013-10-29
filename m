Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:44990 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab3J2EXA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Oct 2013 00:23:00 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 9077135C1AD
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Oct 2013 05:22:56 +0100 (CET)
Received: from localhost (e0109-106-188-70-246.uqwimax.jp [106.188.70.246])
	by mail.virtall.com (Postfix) with ESMTPSA id B439835C191
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Oct 2013 05:22:54 +0100 (CET)
Date: Tue, 29 Oct 2013 13:22:46 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: memory leak in <=3.11.6
Message-ID: <20131029132246.21258b95@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I probably have the same problem over here, after about 2 weeks of
> random read/write it seems my memory and swap get almost full and even
> after killing all process and getting in single user mode, memory
> won't free up.  Would you happen to have quota enabled too? Kernel is
> 3.11.4

I experience the same daily (out of memory, server dying); sometimes
several times daily.

It's a *big* downer.

I use 3.12-rc7, but I had this issue with earlier kernels, too.

Yes, I have qgroups enabled.


A bit desperate, I've started dumping various system parameters (free,
uptime, ps, top, /proc/meminfo etc.) every minute - memory usage can
jump from some 8 GB to 32 GB within one minute; a minute later the
system is no longer responsive and has to be hard resetted.


Example - free-2013-10-29-03:29:01

             total       used       free     shared    buffers     cached
Mem:      32638388   32484484     153904          0       4960   24122452
-/+ buffers/cache:    8357072   24281316
Swap:     16776116        132   16775984


free-2013-10-29-03:30:01

             total       used       free     shared    buffers     cached
Mem:      32638388   32473636     164752          0        544    1191896
-/+ buffers/cache:   31281196    1357192
Swap:     16776116        408   16775708



What would cause such a huge memory usage jump?

top for the same two minutes; no userspace process is using the memory.
First one - we're using ~8 GB RAM, the second one - all 32 GB is used.

top-2013-10-29-03:29:01:

top - 03:29:01 up  2:00,  1 user,  load average: 9.00, 8.48, 8.82
Tasks: 268 total,   1 running, 267 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.4 us,  0.9 sy,  0.2 ni, 77.2 id, 21.2 wa,  0.0 hi,  0.1 si,  0.0 st
KiB Mem:  32638388 total, 32485196 used,   153192 free,     4964 buffers
KiB Swap: 16776116 total,      132 used, 16775984 free, 24121388 cached

  PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM    TIME+  COMMAND
15568 root      20   0 99220  71m 1144 D   6.3  0.2   0:27.59 rsync --exclude=/
16384 root      20   0     0    0    0 S   6.3  0.0   0:11.12 [btrfs-endio-met]
17016 root      20   0     0    0    0 S   6.3  0.0   0:02.89 [btrfs-endio-met]
19956 root      20   0  147m  46m  984 D   6.3  0.1   0:19.60 rsync --delete --
21798 root      20   0 48268  13m 1132 D   6.3  0.0   0:07.61 rsync --exclude=/
21824 root      20   0 24696 1568 1096 R   6.3  0.0   0:00.01 top -b -c -n 1
    1 root      20   0 10644  912  764 S   0.0  0.0   0:00.46 init [2]
    2 root      20   0     0    0    0 S   0.0  0.0   0:00.03 [kthreadd]
    3 root      20   0     0    0    0 S   0.0  0.0   0:00.22 [ksoftirqd/0]
    4 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [kworker/0:0]
    5 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [kworker/0:0H]
    6 root      20   0     0    0    0 S   0.0  0.0   0:04.01 [kworker/u16:0]
    7 root      rt   0     0    0    0 S   0.0  0.0   0:00.43 [migration/0]
    8 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [rcu_bh]
    9 root      20   0     0    0    0 S   0.0  0.0   0:09.07 [rcu_sched]
   10 root      rt   0     0    0    0 S   0.0  0.0   0:00.02 [watchdog/0]
   11 root      rt   0     0    0    0 S   0.0  0.0   0:00.03 [watchdog/1]
   12 root      rt   0     0    0    0 S   0.0  0.0   0:00.00 [migration/1]
   13 root      20   0     0    0    0 S   0.0  0.0   0:00.10 [ksoftirqd/1]
   14 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [kworker/1:0]
   15 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [kworker/1:0H]
   16 root      rt   0     0    0    0 S   0.0  0.0   0:00.03 [watchdog/2]
   17 root      rt   0     0    0    0 S   0.0  0.0   0:00.00 [migration/2]
   18 root      20   0     0    0    0 S   0.0  0.0   0:00.09 [ksoftirqd/2]
   20 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [kworker/2:0H]
   21 root      rt   0     0    0    0 S   0.0  0.0   0:00.02 [watchdog/3]
   22 root      rt   0     0    0    0 S   0.0  0.0   0:00.01 [migration/3]
   23 root      20   0     0    0    0 S   0.0  0.0   0:00.10 [ksoftirqd/3]
   24 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [kworker/3:0]
   25 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [kworker/3:0H]
   26 root      rt   0     0    0    0 S   0.0  0.0   0:00.03 [watchdog/4]
   27 root      rt   0     0    0    0 S   0.0  0.0   0:00.02 [migration/4]
   28 root      20   0     0    0    0 S   0.0  0.0   0:00.01 [ksoftirqd/4]
   29 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [kworker/4:0]
   30 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [kworker/4:0H]
   31 root      rt   0     0    0    0 S   0.0  0.0   0:00.02 [watchdog/5]
   32 root      rt   0     0    0    0 S   0.0  0.0   0:00.02 [migration/5]
   33 root      20   0     0    0    0 S   0.0  0.0   0:00.01 [ksoftirqd/5]
   34 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [kworker/5:0]
   35 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [kworker/5:0H]
   36 root      rt   0     0    0    0 S   0.0  0.0   0:00.02 [watchdog/6]
   37 root      rt   0     0    0    0 S   0.0  0.0   0:00.02 [migration/6]
   38 root      20   0     0    0    0 S   0.0  0.0   0:00.02 [ksoftirqd/6]
   39 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [kworker/6:0]
   40 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [kworker/6:0H]
   41 root      rt   0     0    0    0 S   0.0  0.0   0:00.02 [watchdog/7]
   42 root      rt   0     0    0    0 S   0.0  0.0   0:00.02 [migration/7]
   43 root      20   0     0    0    0 S   0.0  0.0   0:00.01 [ksoftirqd/7]
   44 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [kworker/7:0]
   45 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [kworker/7:0H]
   46 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [khelper]
   47 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [netns]
  196 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [writeback]
  198 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [bioset]
  199 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [kblockd]
  350 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [khubd]
  357 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [md]
  496 root      20   0     0    0    0 S   0.0  0.0   0:00.02 [khungtaskd]
  505 root      20   0     0    0    0 D   0.0  0.0   0:02.02 [kswapd0]
  572 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [fsnotify_mark]
  578 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [crypto]
  601 root      20   0     0    0    0 S   0.0  0.0   0:05.46 [kworker/0:1]
  603 root      20   0     0    0    0 S   0.0  0.0   0:05.86 [kworker/1:1]
  605 root      20   0     0    0    0 S   0.0  0.0   0:05.92 [kworker/2:1]
  607 root      20   0     0    0    0 S   0.0  0.0   0:05.83 [kworker/3:1]
  609 root      20   0     0    0    0 S   0.0  0.0   0:04.66 [kworker/4:1]
  612 root      20   0     0    0    0 S   0.0  0.0   0:04.50 [kworker/6:1]
  614 root      20   0     0    0    0 S   0.0  0.0   0:04.49 [kworker/7:1]
  672 root     -51   0     0    0    0 S   0.0  0.0   0:00.00 [irq/41-mei_me]
  685 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [kpsmoused]
  688 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [kworker/2:2]
  730 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [deferwq]
  864 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [ata_sff]
  867 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [scsi_eh_0]
  868 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [scsi_eh_1]
  869 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [scsi_eh_2]
  870 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [scsi_eh_3]
  871 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [scsi_eh_4]
  872 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [scsi_eh_5]
  887 root       0 -20     0    0    0 S   0.0  0.0   0:05.10 [kworker/0:1H]
  889 root       0 -20     0    0    0 S   0.0  0.0   0:00.51 [kworker/1:1H]
  892 root       0 -20     0    0    0 S   0.0  0.0   0:00.38 [kworker/4:1H]
  912 root       0 -20     0    0    0 S   0.0  0.0   0:00.09 [kworker/5:1H]
  922 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [bioset]
  923 root      20   0     0    0    0 S   0.0  0.0   0:00.01 [md0_raid1]
  926 root       0 -20     0    0    0 S   0.0  0.0   0:00.39 [kworker/2:1H]
  931 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [bioset]
  932 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [md1_raid1]
  939 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [bioset]
  940 root      20   0     0    0    0 S   0.0  0.0   0:00.09 [md2_raid1]
  954 root      20   0     0    0    0 S   0.0  0.0   0:00.10 [jbd2/md2-8]
  955 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [ext4-rsv-conver]
 1059 root       0 -20     0    0    0 S   0.0  0.0   0:00.20 [kworker/3:1H]
 1060 root       0 -20     0    0    0 S   0.0  0.0   0:00.06 [kworker/7:1H]
 1143 root      20   0 21480 1492  784 S   0.0  0.0   0:00.04 udevd --daemon
 1222 root       0 -20     0    0    0 S   0.0  0.0   0:00.08 [kworker/6:1H]
 1514 root      20   0     0    0    0 S   0.0  0.0   0:04.60 [kworker/5:2]
 2240 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [jbd2/md1-8]
 2241 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [ext4-rsv-conver]
 2247 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [bioset]
 2249 root      20   0     0    0    0 S   0.0  0.0   0:00.02 [btrfs-genwork-1]
 2250 root      20   0     0    0    0 S   0.0  0.0   0:00.24 [btrfs-submit-1]
 2252 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-fixup-1]
 2255 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-rmw-1]
 2256 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-endio-rai]
 2257 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-endio-met]
 2259 root      20   0     0    0    0 S   0.0  0.0   0:00.04 [btrfs-freespace]
 2261 root      20   0     0    0    0 S   0.0  0.0   0:00.03 [btrfs-cache-1]
 2262 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-readahead]
 2264 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-qgroup-re]
 2347 root      20   0     0    0    0 S   0.0  0.0   0:00.05 [btrfs-cleaner]
 2348 root      20   0     0    0    0 D   0.0  0.0   0:06.76 [btrfs-transacti]
 2353 root      20   0     0    0    0 S   0.0  0.0   0:00.03 [btrfs-genwork-1]
 2354 root      20   0     0    0    0 S   0.0  0.0   0:06.67 [btrfs-submit-1]
 2356 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-fixup-1]
 2359 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-rmw-1]
 2360 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-endio-rai]
 2361 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-endio-met]
 2363 root      20   0     0    0    0 S   0.0  0.0   0:00.03 [btrfs-freespace]
 2364 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-delayed-m]
 2365 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-cache-1]
 2366 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-readahead]
 2368 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-qgroup-re]
 2387 root      20   0     0    0    0 S   0.0  0.0   0:00.17 [btrfs-cleaner]
 2388 root      20   0     0    0    0 S   0.0  0.0   0:02.94 [btrfs-transacti]
 2682 root      20   0 21492 1040  332 S   0.0  0.0   0:00.00 udevd --daemon
 2683 root      20   0 21476 1044  340 S   0.0  0.0   0:00.00 udevd --daemon
 2824 root      20   0 49848 1184  572 S   0.0  0.0   0:00.06 /usr/sbin/sshd
 3067 root      20   0  115m 1808 1136 S   0.0  0.0   0:00.91 /usr/sbin/rsyslog
 3068 root      20   0  6696  624  500 S   0.0  0.0   0:00.20 /usr/sbin/vnstatd
 3193 root      20   0  4112  648  500 S   0.0  0.0   0:00.00 /usr/sbin/acpid
 3211 root      20   0 51712 9.8m 2060 S   0.0  0.0   0:00.31 munin-node
 3407 root      20   0 91712 4640 2252 S   0.0  0.0   0:00.18 /usr/sbin/apache2
 3483 root      20   0 91768 2816  404 S   0.0  0.0   0:00.00 /usr/sbin/apache2
 3484 root      20   0 91768 2816  404 S   0.0  0.0   0:00.01 /usr/sbin/apache2
 3485 root      20   0 91768 2816  404 S   0.0  0.0   0:00.00 /usr/sbin/apache2
 3486 root      20   0 91768 2816  404 S   0.0  0.0   0:00.00 /usr/sbin/apache2
 3487 root      20   0 91768 2816  404 S   0.0  0.0   0:00.00 /usr/sbin/apache2
 3528 root      20   0 21804 1088  832 S   0.0  0.0   0:00.01 /usr/sbin/cron
 3678 root      20   0 13048  696  484 S   0.0  0.0   0:00.00 /sbin/mdadm --mon
 3744 root      39  19 10788  940  792 S   0.0  0.0   0:00.00 /usr/bin/rsync --
 3770 ntp       20   0 38988 2392 1756 S   0.0  0.0   0:00.33 /usr/sbin/ntpd -p
 4058 root      20   0 37788 2488 1936 S   0.0  0.0   0:00.03 /usr/lib/postfix/
 4107 proftpd   20   0 96636 2056  632 S   0.0  0.0   0:00.02 proftpd: (accepti
 4122 postfix   20   0 40016 2656 2084 S   0.0  0.0   0:00.01 qmgr -l -t fifo -
 4194 root      20   0 27312 1140  856 S   0.0  0.0   0:00.00 lxc-start -n inte
 4196 root      20   0 17652  932  780 S   0.0  0.0   0:00.00 /sbin/getty 38400
 4197 root      20   0 17652  940  780 S   0.0  0.0   0:00.00 /sbin/getty 38400
 4198 root      20   0 17652  940  780 S   0.0  0.0   0:00.00 /sbin/getty 38400
 4199 root      20   0 17652  940  780 S   0.0  0.0   0:00.00 /sbin/getty 38400
 4200 root      20   0 17652  940  780 S   0.0  0.0   0:00.00 /sbin/getty 38400
 4201 root      20   0 17652  936  780 S   0.0  0.0   0:00.00 /sbin/getty 38400
 4220 root      20   0 10648  848  712 S   0.0  0.0   0:00.06 init [3]
 5262 root      20   0  6696  624  500 S   0.0  0.0   0:00.17 /usr/sbin/vnstatd
 5289 root      20   0 76056 3156 1464 S   0.0  0.0   0:00.18 /usr/sbin/apache2
 5292 www-data  20   0 75788 2256  596 S   0.0  0.0   0:00.00 /usr/sbin/apache2
 5293 www-data  20   0  292m 2656  748 S   0.0  0.0   0:00.00 /usr/sbin/apache2
 5294 www-data  20   0  292m 2656  748 S   0.0  0.0   0:00.00 /usr/sbin/apache2
 5402 root      20   0 20404 1020  780 S   0.0  0.0   0:00.00 /usr/sbin/cron
 5424 ntp       20   0 29800  464  216 S   0.0  0.0   0:00.00 /usr/bin/dbus-dae
 5431 root      20   0 49848 1128  520 S   0.0  0.0   0:00.00 /usr/sbin/sshd
 5488 root      20   0 37788 2396 1872 S   0.0  0.0   0:00.02 /usr/lib/postfix/
 5497 sshd      20   0 39908 2364 1832 S   0.0  0.0   0:00.00 qmgr -l -t fifo -
 5500 root      20   0  393m  43m 5228 S   0.0  0.1   0:17.90 /root/.dropbox-di
 5529 root      20   0  4096  572  480 S   0.0  0.0   0:00.00 startpar -f -- rc
 5530 root      20   0 14572  848  696 S   0.0  0.0   0:00.00 /sbin/getty 38400
 5531 root      20   0 14572  852  700 S   0.0  0.0   0:00.00 /sbin/getty 38400
 5532 root      20   0 14572  852  700 S   0.0  0.0   0:00.00 /sbin/getty 38400
 5533 root      20   0 14572  852  700 S   0.0  0.0   0:00.00 /sbin/getty 38400
 5534 root      20   0 14572  848  700 S   0.0  0.0   0:00.00 /sbin/getty 38400
 5540 root      20   0     0    0    0 S   0.0  0.0   0:03.97 [btrfs-endio-wri]
12798 root      20   0 91768 2816  404 S   0.0  0.0   0:00.00 /usr/sbin/apache2
13421 root      20   0 75292 3900 3072 S   0.0  0.0   0:00.26 sshd: root@pts/5
13423 root      20   0 22920 4408 1800 S   0.0  0.0   0:00.06 -bash
15427 root      20   0 26152 1700 1152 D   0.0  0.0   0:00.82 tmux
15428 root      20   0 22940 4304 1676 S   0.0  0.0   0:00.04 -bash
15473 root      20   0 12172 1416 1200 S   0.0  0.0   0:00.00 bash -x /opt/snap
15478 root      20   0 12192 1484 1252 S   0.0  0.0   0:00.00 /bin/bash /opt/sn
15569 root      20   0 46736 6472 2496 S   0.0  0.0   0:03.70 ssh -p 24761 -i /
15579 root      20   0  118m  60m  804 S   0.0  0.2   0:03.58 rsync --exclude=/
15582 root      20   0 22940 4300 1676 S   0.0  0.0   0:00.03 -bash
15629 root      20   0 12164 1388 1176 S   0.0  0.0   0:00.00 bash -x /opt/snap
15649 root      20   0     0    0    0 S   0.0  0.0   0:04.17 [btrfs-endio-wri]
15650 root      20   0     0    0    0 S   0.0  0.0   0:03.99 [btrfs-endio-wri]
15651 root      20   0     0    0    0 S   0.0  0.0   0:03.95 [btrfs-endio-wri]
15652 root      20   0     0    0    0 S   0.0  0.0   0:04.07 [btrfs-endio-wri]
15653 root      20   0     0    0    0 S   0.0  0.0   0:03.86 [btrfs-endio-wri]
15654 root      20   0     0    0    0 S   0.0  0.0   0:03.87 [btrfs-endio-wri]
15655 root      20   0     0    0    0 S   0.0  0.0   0:03.88 [btrfs-endio-wri]
15666 root      20   0     0    0    0 S   0.0  0.0   0:26.38 [btrfs-delalloc-]
16336 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-flush_del]
16342 root      20   0     0    0    0 S   0.0  0.0   0:25.83 [btrfs-delalloc-]
17037 root      20   0     0    0    0 S   0.0  0.0   0:00.54 [btrfs-endio-wri]
17676 root      20   0     0    0    0 S   0.0  0.0   0:19.29 [btrfs-delalloc-]
17677 root      20   0     0    0    0 S   0.0  0.0   0:19.84 [btrfs-delalloc-]
17679 root      20   0     0    0    0 S   0.0  0.0   0:20.29 [btrfs-delalloc-]
17681 root      20   0     0    0    0 S   0.0  0.0   0:19.53 [btrfs-delalloc-]
18676 postfix   20   0 39856 2512 1956 S   0.0  0.0   0:00.00 pickup -l -t fifo
19054 root      20   0     0    0    0 S   0.0  0.0   0:00.53 [btrfs-endio-wri]
19055 root      20   0     0    0    0 S   0.0  0.0   0:00.39 [btrfs-endio-wri]
19057 root      20   0     0    0    0 S   0.0  0.0   0:01.34 [btrfs-endio-5]
19059 root      20   0     0    0    0 S   0.0  0.0   0:00.62 [btrfs-endio-wri]
19060 root      20   0     0    0    0 S   0.0  0.0   0:00.56 [btrfs-endio-wri]
19061 root      20   0     0    0    0 S   0.0  0.0   0:00.54 [btrfs-endio-wri]
19063 root      20   0     0    0    0 S   0.0  0.0   0:00.62 [btrfs-endio-wri]
19064 root      20   0     0    0    0 S   0.0  0.0   0:00.49 [btrfs-endio-wri]
19076 sshd      20   0 39856 2332 1808 S   0.0  0.0   0:00.00 pickup -l -t fifo
19743 root      20   0     0    0    0 S   0.0  0.0   0:01.77 [btrfs-endio-7]
19751 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-flush_del]
19837 root      20   0 43892 4132 2656 S   0.0  0.0   0:00.03 /usr/bin/mc -P /t
19839 root      20   0 21816 3112 1608 S   0.0  0.0   0:00.01 bash -rcfile .bas
19915 root      20   0 12192 1476 1248 S   0.0  0.0   0:00.00 /bin/bash /opt/sn
19918 root      20   0 12188 1484 1252 S   0.0  0.0   0:00.00 /bin/bash /opt/sn
19939 root      20   0  126m  24m 1140 D   0.0  0.1   0:12.57 rsync --exclude=/
19941 root      20   0 46348 5940 2504 S   0.0  0.0   0:02.84 ssh -p 22521 -i /
19957 root      20   0 43704 5148 2420 S   0.0  0.0   0:04.90 ssh -p 22 -i /etc
19962 root      20   0  192m  39m  464 S   0.0  0.1   0:01.90 rsync --delete --
19963 root      20   0  158m  18m  784 S   0.0  0.1   0:03.26 rsync --exclude=/
19965 root      20   0     0    0    0 S   0.0  0.0   0:01.58 [btrfs-delalloc-]
19967 root      20   0     0    0    0 S   0.0  0.0   0:01.02 [btrfs-delalloc-]
19971 root      20   0     0    0    0 S   0.0  0.0   0:00.04 [btrfs-worker-4]
20008 root      20   0     0    0    0 S   0.0  0.0   0:00.88 [kworker/u16:3]
20010 root      20   0     0    0    0 S   0.0  0.0   0:00.06 [btrfs-delayed-m]
20309 root      20   0     0    0    0 S   0.0  0.0   0:01.33 [btrfs-endio-3]
20334 root      20   0     0    0    0 S   0.0  0.0   0:01.82 [btrfs-delalloc-]
20341 root      20   0     0    0    0 S   0.0  0.0   0:00.75 [btrfs-endio-7]
20384 root      20   0     0    0    0 S   0.0  0.0   0:00.67 [btrfs-endio-4]
21004 root      20   0     0    0    0 S   0.0  0.0   0:00.47 [btrfs-endio-6]
21017 root      20   0     0    0    0 S   0.0  0.0   0:03.79 [btrfs-endio-met]
21042 root      20   0     0    0    0 S   0.0  0.0   0:00.01 [kworker/u16:1]
21054 root      20   0     0    0    0 S   0.0  0.0   0:00.21 [btrfs-endio-7]
21055 root      20   0     0    0    0 S   0.0  0.0   0:00.34 [btrfs-endio-8]
21078 root      20   0 40656 1180  840 S   0.0  0.0   0:00.00 /USR/SBIN/CRON
21083 munin     20   0  4176  576  484 S   0.0  0.0   0:00.00 /bin/sh -c if [ -
21085 munin     20   0  4176  576  488 S   0.0  0.0   0:00.00 /bin/sh /usr/bin/
21247 root      20   0     0    0    0 S   0.0  0.0   0:00.72 [btrfs-endio-2]
21710 munin     30  10  141m  24m 5940 D   0.0  0.1   0:04.60 /usr/bin/perl -T
21711 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [kworker/u16:2]
21713 root      20   0     0    0    0 S   0.0  0.0   0:00.65 [btrfs-endio-3]
21714 root      20   0     0    0    0 S   0.0  0.0   0:00.79 [btrfs-endio-4]
21715 root      20   0     0    0    0 S   0.0  0.0   0:00.65 [btrfs-endio-5]
21717 root      20   0     0    0    0 S   0.0  0.0   0:00.74 [btrfs-endio-7]
21718 root      20   0     0    0    0 S   0.0  0.0   0:00.76 [btrfs-endio-8]
21719 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-endio-met]
21722 root      20   0     0    0    0 S   0.0  0.0   0:00.04 [btrfs-worker-4]
21727 root      20   0     0    0    0 S   0.0  0.0   0:00.50 [btrfs-delalloc-]
21728 root      20   0     0    0    0 S   0.0  0.0   0:00.44 [btrfs-delalloc-]
21729 root      20   0     0    0    0 S   0.0  0.0   0:00.28 [btrfs-delalloc-]
21730 root      20   0     0    0    0 S   0.0  0.0   0:00.64 [btrfs-delalloc-]
21731 root      20   0     0    0    0 S   0.0  0.0   0:00.37 [btrfs-delalloc-]
21743 root      20   0     0    0    0 D   0.0  0.0   0:00.02 [md0_resync]
21744 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-delayed-m]
21762 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-flush_del]
21763 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-flush_del]
21764 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-flush_del]
21765 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-flush_del]
21766 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-flush_del]
21767 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-flush_del]
21768 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-flush_del]
21769 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-endio-met]
21782 root      20   0 12192 1492 1252 S   0.0  0.0   0:00.00 /bin/bash /opt/sn
21799 root      20   0 44172 3820 2500 S   0.0  0.0   0:00.31 ssh -p 6253 -i /e
21800 root      20   0 68320  12m  780 S   0.0  0.0   0:00.41 rsync --exclude=/
21801 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-endio-met]
21802 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-endio-met]
21814 root      20   0 40656 1180  840 S   0.0  0.0   0:00.00 /USR/SBIN/CRON
21815 root      20   0  4176  580  484 S   0.0  0.0   0:00.00 /bin/sh -c /root/
21816 root      20   0 12152 1400 1200 S   0.0  0.0   0:00.00 /bin/bash /root/s



The system is dying here - top-2013-10-29-03:30:01.log:

top - 03:30:02 up  2:01,  1 user,  load average: 12.71, 9.70, 9.22
Tasks: 261 total,   1 running, 260 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.4 us,  1.0 sy,  0.2 ni, 76.9 id, 21.4 wa,  0.0 hi,  0.1 si,  0.0 st
KiB Mem:  32638388 total, 32460108 used,   178280 free,      556 buffers
KiB Swap: 16776116 total,      440 used, 16775676 free,  1135812 cached

  PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM    TIME+  COMMAND
  614 root      20   0     0    0    0 S  25.8  0.0   0:04.82 [kworker/7:1]
  601 root      20   0     0    0    0 S  12.9  0.0   0:06.03 [kworker/0:1]
17676 root      20   0     0    0    0 S  12.9  0.0   0:19.63 [btrfs-delalloc-]
15654 root      20   0     0    0    0 S   6.4  0.0   0:03.91 [btrfs-endio-wri]
15666 root      20   0     0    0    0 S   6.4  0.0   0:26.69 [btrfs-delalloc-]
16342 root      20   0     0    0    0 S   6.4  0.0   0:26.19 [btrfs-delalloc-]
21825 root      20   0     0    0    0 S   6.4  0.0   0:00.33 [btrfs-delalloc-]
21826 root      20   0     0    0    0 S   6.4  0.0   0:00.30 [btrfs-delalloc-]
21838 munin     20   0 35804 7888 2060 D   6.4  0.0   0:00.06 /usr/bin/perl /us
21846 root      20   0 24696 1592 1096 R   6.4  0.0   0:00.01 top -b -c -n 1
    1 root      20   0 10644  756  676 S   0.0  0.0   0:00.46 init [2]
    2 root      20   0     0    0    0 S   0.0  0.0   0:00.03 [kthreadd]
    3 root      20   0     0    0    0 S   0.0  0.0   0:00.23 [ksoftirqd/0]
    4 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [kworker/0:0]
    5 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [kworker/0:0H]
    6 root      20   0     0    0    0 S   0.0  0.0   0:04.01 [kworker/u16:0]
    7 root      rt   0     0    0    0 S   0.0  0.0   0:05.36 [migration/0]
    8 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [rcu_bh]
    9 root      20   0     0    0    0 S   0.0  0.0   0:09.24 [rcu_sched]
   10 root      rt   0     0    0    0 S   0.0  0.0   0:00.02 [watchdog/0]
   11 root      rt   0     0    0    0 S   0.0  0.0   0:00.03 [watchdog/1]
   12 root      rt   0     0    0    0 S   0.0  0.0   0:04.57 [migration/1]
   13 root      20   0     0    0    0 S   0.0  0.0   0:00.11 [ksoftirqd/1]
   14 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [kworker/1:0]
   15 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [kworker/1:0H]
   16 root      rt   0     0    0    0 S   0.0  0.0   0:00.03 [watchdog/2]
   17 root      rt   0     0    0    0 S   0.0  0.0   0:02.73 [migration/2]
   18 root      20   0     0    0    0 S   0.0  0.0   0:00.10 [ksoftirqd/2]
   20 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [kworker/2:0H]
   21 root      rt   0     0    0    0 S   0.0  0.0   0:00.02 [watchdog/3]
   22 root      rt   0     0    0    0 S   0.0  0.0   0:00.91 [migration/3]
   23 root      20   0     0    0    0 S   0.0  0.0   0:00.11 [ksoftirqd/3]
   24 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [kworker/3:0]
   25 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [kworker/3:0H]
   26 root      rt   0     0    0    0 S   0.0  0.0   0:00.03 [watchdog/4]
   27 root      rt   0     0    0    0 S   0.0  0.0   0:01.44 [migration/4]
   28 root      20   0     0    0    0 S   0.0  0.0   0:00.02 [ksoftirqd/4]
   29 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [kworker/4:0]
   30 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [kworker/4:0H]
   31 root      rt   0     0    0    0 S   0.0  0.0   0:00.02 [watchdog/5]
   32 root      rt   0     0    0    0 S   0.0  0.0   0:00.52 [migration/5]
   33 root      20   0     0    0    0 S   0.0  0.0   0:00.02 [ksoftirqd/5]
   34 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [kworker/5:0]
   35 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [kworker/5:0H]
   36 root      rt   0     0    0    0 S   0.0  0.0   0:00.02 [watchdog/6]
   37 root      rt   0     0    0    0 S   0.0  0.0   0:00.47 [migration/6]
   38 root      20   0     0    0    0 S   0.0  0.0   0:00.02 [ksoftirqd/6]
   39 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [kworker/6:0]
   40 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [kworker/6:0H]
   41 root      rt   0     0    0    0 S   0.0  0.0   0:00.02 [watchdog/7]
   42 root      rt   0     0    0    0 S   0.0  0.0   0:00.11 [migration/7]
   43 root      20   0     0    0    0 S   0.0  0.0   0:00.02 [ksoftirqd/7]
   44 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [kworker/7:0]
   45 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [kworker/7:0H]
   46 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [khelper]
   47 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [netns]
  196 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [writeback]
  198 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [bioset]
  199 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [kblockd]
  350 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [khubd]
  357 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [md]
  496 root      20   0     0    0    0 S   0.0  0.0   0:00.02 [khungtaskd]
  505 root      20   0     0    0    0 D   0.0  0.0   0:07.52 [kswapd0]
  572 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [fsnotify_mark]
  578 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [crypto]
  603 root      20   0     0    0    0 S   0.0  0.0   0:06.35 [kworker/1:1]
  605 root      20   0     0    0    0 S   0.0  0.0   0:06.35 [kworker/2:1]
  607 root      20   0     0    0    0 S   0.0  0.0   0:06.23 [kworker/3:1]
  609 root      20   0     0    0    0 S   0.0  0.0   0:05.16 [kworker/4:1]
  612 root      20   0     0    0    0 S   0.0  0.0   0:04.92 [kworker/6:1]
  672 root     -51   0     0    0    0 S   0.0  0.0   0:00.00 [irq/41-mei_me]
  685 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [kpsmoused]
  688 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [kworker/2:2]
  730 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [deferwq]
  864 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [ata_sff]
  867 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [scsi_eh_0]
  868 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [scsi_eh_1]
  869 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [scsi_eh_2]
  870 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [scsi_eh_3]
  871 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [scsi_eh_4]
  872 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [scsi_eh_5]
  887 root       0 -20     0    0    0 S   0.0  0.0   0:05.17 [kworker/0:1H]
  889 root       0 -20     0    0    0 S   0.0  0.0   0:00.54 [kworker/1:1H]
  892 root       0 -20     0    0    0 S   0.0  0.0   0:00.39 [kworker/4:1H]
  912 root       0 -20     0    0    0 S   0.0  0.0   0:00.10 [kworker/5:1H]
  922 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [bioset]
  923 root      20   0     0    0    0 S   0.0  0.0   0:00.01 [md0_raid1]
  926 root       0 -20     0    0    0 S   0.0  0.0   0:00.39 [kworker/2:1H]
  931 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [bioset]
  932 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [md1_raid1]
  939 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [bioset]
  940 root      20   0     0    0    0 S   0.0  0.0   0:00.09 [md2_raid1]
  954 root      20   0     0    0    0 S   0.0  0.0   0:00.10 [jbd2/md2-8]
  955 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [ext4-rsv-conver]
 1059 root       0 -20     0    0    0 S   0.0  0.0   0:00.20 [kworker/3:1H]
 1060 root       0 -20     0    0    0 S   0.0  0.0   0:00.06 [kworker/7:1H]
 1143 root      20   0 21480 1288  664 S   0.0  0.0   0:00.04 udevd --daemon
 1222 root       0 -20     0    0    0 S   0.0  0.0   0:00.08 [kworker/6:1H]
 1514 root      20   0     0    0    0 S   0.0  0.0   0:05.08 [kworker/5:2]
 2240 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [jbd2/md1-8]
 2241 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [ext4-rsv-conver]
 2247 root       0 -20     0    0    0 S   0.0  0.0   0:00.00 [bioset]
 2249 root      20   0     0    0    0 S   0.0  0.0   0:00.02 [btrfs-genwork-1]
 2250 root      20   0     0    0    0 S   0.0  0.0   0:00.26 [btrfs-submit-1]
 2252 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-fixup-1]
 2255 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-rmw-1]
 2256 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-endio-rai]
 2257 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-endio-met]
 2259 root      20   0     0    0    0 S   0.0  0.0   0:00.04 [btrfs-freespace]
 2261 root      20   0     0    0    0 S   0.0  0.0   0:00.03 [btrfs-cache-1]
 2262 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-readahead]
 2264 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-qgroup-re]
 2347 root      20   0     0    0    0 D   0.0  0.0   0:00.06 [btrfs-cleaner]
 2348 root      20   0     0    0    0 S   0.0  0.0   0:07.01 [btrfs-transacti]
 2353 root      20   0     0    0    0 S   0.0  0.0   0:00.03 [btrfs-genwork-1]
 2354 root      20   0     0    0    0 S   0.0  0.0   0:06.72 [btrfs-submit-1]
 2356 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-fixup-1]
 2359 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-rmw-1]
 2360 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-endio-rai]
 2361 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-endio-met]
 2363 root      20   0     0    0    0 S   0.0  0.0   0:00.04 [btrfs-freespace]
 2364 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-delayed-m]
 2365 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-cache-1]
 2366 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-readahead]
 2368 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-qgroup-re]
 2387 root      20   0     0    0    0 S   0.0  0.0   0:00.20 [btrfs-cleaner]
 2388 root      20   0     0    0    0 S   0.0  0.0   0:03.03 [btrfs-transacti]
 2682 root      20   0 21492  848  216 S   0.0  0.0   0:00.00 udevd --daemon
 2683 root      20   0 21476  852  224 S   0.0  0.0   0:00.00 udevd --daemon
 2824 root      20   0 49848 1092  480 S   0.0  0.0   0:00.06 /usr/sbin/sshd
 3067 root      20   0  115m 1524  852 S   0.0  0.0   0:00.92 /usr/sbin/rsyslog
 3068 root      20   0  6696  596  472 S   0.0  0.0   0:00.20 /usr/sbin/vnstatd
 3193 root      20   0  4112  552  404 S   0.0  0.0   0:00.00 /usr/sbin/acpid
 3211 root      20   0 51712 8920  968 S   0.0  0.0   0:00.31 munin-node
 3407 root      20   0 91712 3652 1264 S   0.0  0.0   0:00.18 /usr/sbin/apache2
 3483 root      20   0 91768 2524  112 S   0.0  0.0   0:00.00 /usr/sbin/apache2
 3484 root      20   0 91768 2544  132 S   0.0  0.0   0:00.01 /usr/sbin/apache2
 3485 root      20   0 91768 2552  140 S   0.0  0.0   0:00.00 /usr/sbin/apache2
 3486 root      20   0 91768 2552  140 S   0.0  0.0   0:00.00 /usr/sbin/apache2
 3487 root      20   0 91768 2552  140 S   0.0  0.0   0:00.00 /usr/sbin/apache2
 3528 root      20   0 21804  980  724 S   0.0  0.0   0:00.02 /usr/sbin/cron
 3678 root      20   0 13048  624  412 S   0.0  0.0   0:00.00 /sbin/mdadm --mon
 3744 root      39  19 10788  916  768 S   0.0  0.0   0:00.00 /usr/bin/rsync --
 3770 ntp       20   0 38988 2180 1544 S   0.0  0.0   0:00.37 /usr/sbin/ntpd -p
 4058 root      20   0 37788 1976 1424 S   0.0  0.0   0:00.03 /usr/lib/postfix/
 4107 proftpd   20   0 96636 1872  448 S   0.0  0.0   0:00.02 proftpd: (accepti
 4122 postfix   20   0 40016 2104 1532 S   0.0  0.0   0:00.01 qmgr -l -t fifo -
 4194 root      20   0 27312  940  656 S   0.0  0.0   0:00.00 lxc-start -n inte
 4196 root      20   0 17652  864  712 S   0.0  0.0   0:00.00 /sbin/getty 38400
 4197 root      20   0 17652  872  712 S   0.0  0.0   0:00.00 /sbin/getty 38400
 4198 root      20   0 17652  872  712 S   0.0  0.0   0:00.00 /sbin/getty 38400
 4199 root      20   0 17652  872  712 S   0.0  0.0   0:00.00 /sbin/getty 38400
 4200 root      20   0 17652  872  712 S   0.0  0.0   0:00.00 /sbin/getty 38400
 4201 root      20   0 17652  868  712 S   0.0  0.0   0:00.00 /sbin/getty 38400
 4220 root      20   0 10648  752  712 S   0.0  0.0   0:00.06 init [3]
 5262 root      20   0  6696  572  500 S   0.0  0.0   0:00.19 /usr/sbin/vnstatd
 5289 root      20   0 76056 3156 1464 S   0.0  0.0   0:00.19 /usr/sbin/apache2
 5292 www-data  20   0 75788 2256  596 S   0.0  0.0   0:00.00 /usr/sbin/apache2
 5293 www-data  20   0  292m 2656  748 S   0.0  0.0   0:00.00 /usr/sbin/apache2
 5294 www-data  20   0  292m 2656  748 S   0.0  0.0   0:00.00 /usr/sbin/apache2
 5402 root      20   0 20404 1020  780 S   0.0  0.0   0:00.00 /usr/sbin/cron
 5424 ntp       20   0 29800  464  216 S   0.0  0.0   0:00.00 /usr/bin/dbus-dae
 5431 root      20   0 49848 1128  520 S   0.0  0.0   0:00.00 /usr/sbin/sshd
 5488 root      20   0 37788 2396 1872 S   0.0  0.0   0:00.02 /usr/lib/postfix/
 5497 sshd      20   0 39908 2364 1832 S   0.0  0.0   0:00.00 qmgr -l -t fifo -
 5500 root      20   0  393m  43m 5228 S   0.0  0.1   0:17.91 /root/.dropbox-di
 5529 root      20   0  4096  572  480 S   0.0  0.0   0:00.00 startpar -f -- rc
 5530 root      20   0 14572  848  696 S   0.0  0.0   0:00.00 /sbin/getty 38400
 5531 root      20   0 14572  852  700 S   0.0  0.0   0:00.00 /sbin/getty 38400
 5532 root      20   0 14572  852  700 S   0.0  0.0   0:00.00 /sbin/getty 38400
 5533 root      20   0 14572  852  700 S   0.0  0.0   0:00.00 /sbin/getty 38400
 5534 root      20   0 14572  848  700 S   0.0  0.0   0:00.00 /sbin/getty 38400
 5540 root      20   0     0    0    0 S   0.0  0.0   0:04.01 [btrfs-endio-wri]
12798 root      20   0 91768 2552  140 S   0.0  0.0   0:00.00 /usr/sbin/apache2
13421 root      20   0 75292 3244 2416 S   0.0  0.0   0:00.26 sshd: root@pts/5
13423 root      20   0 22920 4068 1460 S   0.0  0.0   0:00.06 -bash
15427 root      20   0 26148 1452  904 S   0.0  0.0   0:01.40 tmux
15428 root      20   0 22940 4072 1444 S   0.0  0.0   0:00.04 -bash
15473 root      20   0 12172 1416 1200 S   0.0  0.0   0:00.00 bash -x /opt/snap
15478 root      20   0 12192 1484 1252 S   0.0  0.0   0:00.00 /bin/bash /opt/sn
15568 root      20   0 99220  71m 1136 D   0.0  0.2   0:28.24 rsync --exclude=/
15569 root      20   0 46736 6412 2436 S   0.0  0.0   0:03.77 ssh -p 24761 -i /
15579 root      20   0  118m  60m  796 S   0.0  0.2   0:03.71 rsync --exclude=/
15582 root      20   0 22940 4064 1440 S   0.0  0.0   0:00.03 -bash
15629 root      20   0 12164 1388 1176 S   0.0  0.0   0:00.00 bash -x /opt/snap
15649 root      20   0     0    0    0 S   0.0  0.0   0:04.20 [btrfs-endio-wri]
15650 root      20   0     0    0    0 S   0.0  0.0   0:04.04 [btrfs-endio-wri]
15651 root      20   0     0    0    0 S   0.0  0.0   0:04.00 [btrfs-endio-wri]
15652 root      20   0     0    0    0 S   0.0  0.0   0:04.10 [btrfs-endio-wri]
15653 root      20   0     0    0    0 S   0.0  0.0   0:03.90 [btrfs-endio-wri]
15655 root      20   0     0    0    0 S   0.0  0.0   0:03.92 [btrfs-endio-wri]
16336 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-flush_del]
16384 root      20   0     0    0    0 S   0.0  0.0   0:11.54 [btrfs-endio-met]
17016 root      20   0     0    0    0 S   0.0  0.0   0:02.95 [btrfs-endio-met]
17037 root      20   0     0    0    0 S   0.0  0.0   0:00.56 [btrfs-endio-wri]
17677 root      20   0     0    0    0 S   0.0  0.0   0:20.16 [btrfs-delalloc-]
17679 root      20   0     0    0    0 S   0.0  0.0   0:20.69 [btrfs-delalloc-]
17681 root      20   0     0    0    0 S   0.0  0.0   0:19.94 [btrfs-delalloc-]
18676 postfix   20   0 39856 2004 1448 S   0.0  0.0   0:00.00 pickup -l -t fifo
19054 root      20   0     0    0    0 S   0.0  0.0   0:00.56 [btrfs-endio-wri]
19055 root      20   0     0    0    0 S   0.0  0.0   0:00.41 [btrfs-endio-wri]
19057 root      20   0     0    0    0 S   0.0  0.0   0:01.38 [btrfs-endio-5]
19059 root      20   0     0    0    0 S   0.0  0.0   0:00.67 [btrfs-endio-wri]
19060 root      20   0     0    0    0 S   0.0  0.0   0:00.63 [btrfs-endio-wri]
19061 root      20   0     0    0    0 S   0.0  0.0   0:00.57 [btrfs-endio-wri]
19063 root      20   0     0    0    0 D   0.0  0.0   0:05.32 [btrfs-endio-wri]
19064 root      20   0     0    0    0 S   0.0  0.0   0:00.53 [btrfs-endio-wri]
19076 sshd      20   0 39856 2332 1808 S   0.0  0.0   0:00.00 pickup -l -t fifo
19743 root      20   0     0    0    0 S   0.0  0.0   0:02.17 [btrfs-endio-7]
19751 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-flush_del]
19837 root      20   0 43892 2476 1000 S   0.0  0.0   0:00.03 /usr/bin/mc -P /t
19839 root      20   0 21816 2912 1408 S   0.0  0.0   0:00.01 bash -rcfile .bas
19915 root      20   0 12192 1476 1248 S   0.0  0.0   0:00.00 /bin/bash /opt/sn
19918 root      20   0 12188 1484 1252 S   0.0  0.0   0:00.00 /bin/bash /opt/sn
19939 root      20   0  126m  24m 1132 D   0.0  0.1   0:12.93 rsync --exclude=/
19941 root      20   0 46348 5880 2444 S   0.0  0.0   0:03.17 ssh -p 22521 -i /
19956 root      20   0  147m  46m  976 D   0.0  0.1   0:20.57 rsync --delete --
19957 root      20   0 43704 5088 2360 S   0.0  0.0   0:05.12 ssh -p 22 -i /etc
19962 root      20   0  192m  40m  456 S   0.0  0.1   0:02.22 rsync --delete --
19963 root      20   0  158m  19m  776 S   0.0  0.1   0:03.55 rsync --exclude=/
19965 root      20   0     0    0    0 S   0.0  0.0   0:01.66 [btrfs-delalloc-]
19967 root      20   0     0    0    0 S   0.0  0.0   0:01.12 [btrfs-delalloc-]
19971 root      20   0     0    0    0 S   0.0  0.0   0:00.04 [btrfs-worker-4]
20008 root      20   0     0    0    0 S   0.0  0.0   0:00.93 [kworker/u16:3]
20010 root      20   0     0    0    0 S   0.0  0.0   0:00.06 [btrfs-delayed-m]
20309 root      20   0     0    0    0 S   0.0  0.0   0:01.42 [btrfs-endio-3]
20334 root      20   0     0    0    0 S   0.0  0.0   0:01.98 [btrfs-delalloc-]
20341 root      20   0     0    0    0 S   0.0  0.0   0:00.79 [btrfs-endio-7]
20384 root      20   0     0    0    0 S   0.0  0.0   0:00.69 [btrfs-endio-4]
21004 root      20   0     0    0    0 S   0.0  0.0   0:00.56 [btrfs-endio-6]
21017 root      20   0     0    0    0 S   0.0  0.0   0:03.79 [btrfs-endio-met]
21042 root      20   0     0    0    0 S   0.0  0.0   0:00.04 [kworker/u16:1]
21054 root      20   0     0    0    0 S   0.0  0.0   0:00.21 [btrfs-endio-7]
21055 root      20   0     0    0    0 S   0.0  0.0   0:00.51 [btrfs-endio-8]
21247 root      20   0     0    0    0 S   0.0  0.0   0:01.05 [btrfs-endio-2]
21711 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [kworker/u16:2]
21713 root      20   0     0    0    0 S   0.0  0.0   0:01.05 [btrfs-endio-3]
21714 root      20   0     0    0    0 S   0.0  0.0   0:01.11 [btrfs-endio-4]
21715 root      20   0     0    0    0 S   0.0  0.0   0:01.11 [btrfs-endio-5]
21717 root      20   0     0    0    0 S   0.0  0.0   0:01.08 [btrfs-endio-7]
21718 root      20   0     0    0    0 S   0.0  0.0   0:01.10 [btrfs-endio-8]
21722 root      20   0     0    0    0 S   0.0  0.0   0:00.04 [btrfs-worker-4]
21727 root      20   0     0    0    0 S   0.0  0.0   0:00.62 [btrfs-delalloc-]
21728 root      20   0     0    0    0 S   0.0  0.0   0:00.79 [btrfs-delalloc-]
21729 root      20   0     0    0    0 S   0.0  0.0   0:00.34 [btrfs-delalloc-]
21730 root      20   0     0    0    0 S   0.0  0.0   0:00.90 [btrfs-delalloc-]
21731 root      20   0     0    0    0 S   0.0  0.0   0:00.44 [btrfs-delalloc-]
21743 root      20   0     0    0    0 D   0.0  0.0   0:00.03 [md0_resync]
21782 root      20   0 12192 1492 1252 S   0.0  0.0   0:00.00 /bin/bash /opt/sn
21798 root      20   0 51600  14m 1124 S   0.0  0.0   0:09.30 rsync --exclude=/
21799 root      20   0 46576 6260 2440 D   0.0  0.0   0:01.09 ssh -p 6253 -i /e
21800 root      20   0 68320  12m  772 S   0.0  0.0   0:02.55 rsync --exclude=/
21827 root      20   0     0    0    0 S   0.0  0.0   0:00.26 [btrfs-endio-8]
21828 root      20   0     0    0    0 S   0.0  0.0   0:00.00 [btrfs-delayed-m]
21829 root      20   0     0    0    0 S   0.0  0.0   0:00.04 [btrfs-endio-8]
21830 root      20   0 40656 1180  840 S   0.0  0.0   0:00.00 /USR/SBIN/CRON
21831 root      20   0 40656 1180  840 S   0.0  0.0   0:00.00 /USR/SBIN/CRON
21833 munin     20   0  4176  576  484 S   0.0  0.0   0:00.00 /bin/sh -c if [ -
21834 root      20   0  4176  580  484 S   0.0  0.0   0:00.00 /bin/sh -c /root/
21836 root      20   0 12152 1396 1200 S   0.0  0.0   0:00.00 /bin/bash /root/s
21837 munin     20   0  4176  576  488 S   0.0  0.0   0:00.00 /bin/sh /usr/bin/


-- 
Tomasz Chmielewski
http://wpkg.org
