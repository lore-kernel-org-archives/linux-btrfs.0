Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from b.mail.japannext.co.jp ([106.186.104.146]:52844 "EHLO
	b.mail.japannext.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbbG2FxT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jul 2015 01:53:19 -0400
Received: from localhost (localhost [127.0.0.1])
	by b.mail.japannext.co.jp (Postfix) with ESMTP id 20551A044A
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jul 2015 14:47:00 +0900 (JST)
Received: from b.mx.japannext.co.jp ([127.0.0.1])
	by localhost (mzmx02.tk.japannext.co.jp [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NDVYcJsZW-WH for <linux-btrfs@vger.kernel.org>;
	Wed, 29 Jul 2015 14:46:59 +0900 (JST)
Received: from mmimap02.tk.japannext.co.jp (mmimap02.tk.japannext.co.jp [10.67.16.67])
	by b.mx.japannext.co.jp (Postfix) with ESMTP
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jul 2015 14:46:59 +0900 (JST)
Date: Wed, 29 Jul 2015 14:46:59 +0900
From: Georgi Georgiev <georgi-georgiev-btrfs@japannext.co.jp>
To: linux-btrfs@vger.kernel.org
Cc: Georgi Georgiev <georgi-georgiev-btrfs@japannext.co.jp>
Subject: mount btrfs takes 30 minutes, btrfs check runs out of memory
Message-ID: <20150729054659.GD9039@jnext-0060.corp.japannext.co.jp>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tThc/1wpZn/ma/RB"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Using BTRFS on a very large filesystem, and as we put and more data to
it, the time it takes to mount it grew to, presently, about 30 minutes.
Is there something wrong with the filesystem? Is there a way to bring
this time down?

...

Here is a snippet from dmesg, showing how long it takes to mount (the
EXT4-fs line is the filesystem mounted next in the boot sequence):

  $ dmesg | grep -A1 btrfs
  [   12.215764] TECH PREVIEW: btrfs may not be fully supported.
  [   12.215766] Please review provided documentation for limitations.
  --
  [   12.220266] btrfs: use zlib compression
  [   12.220815] btrfs: disk space caching is enabled
  [   22.427258] btrfs: bdev /dev/mapper/datavg-backuplv errs: wr 0, rd 0, flush 0, corrupt 0, gen 0
  [ 2022.397318] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: 

The btrfs filesystem is quite large:

  $ sudo btrfs filesystem usage /dev/mapper/datavg-backuplv
  Overall:
      Device size:                  82.58TiB
      Device allocated:             82.58TiB
      Device unallocated:              0.00B
      Device missing:                  0.00B
      Used:                         62.01TiB
      Free (estimated):             17.76TiB      (min: 17.76TiB)
      Data ratio:                       1.00
      Metadata ratio:                   2.00
      Global reserve:                  0.00B      (used: 0.00B)
  
  Data,single: Size:79.28TiB, Used:61.52TiB
     /dev/mapper/datavg-backuplv    79.28TiB
  
  Metadata,single: Size:8.00MiB, Used:0.00B
     /dev/mapper/datavg-backuplv     8.00MiB
  
  Metadata,DUP: Size:1.65TiB, Used:252.68GiB
     /dev/mapper/datavg-backuplv     3.30TiB
  
  System,single: Size:4.00MiB, Used:0.00B
     /dev/mapper/datavg-backuplv     4.00MiB
  
  System,DUP: Size:40.00MiB, Used:8.66MiB
     /dev/mapper/datavg-backuplv    80.00MiB
  
  Unallocated:
     /dev/mapper/datavg-backuplv       0.00B

Other info about the filesystem is that it has a rather large number of
files and subvolumes and read only snapshots, which started from about
zero in March, and grew over to the current state of 3000 snapshots and
no idea how many files (filesystem usage is quite stable at the moment).

I also noticed that while the machine is rebooted on a weekly basis, the
time it takes to come up after a reboot has been growing. This is likely
correlated to how long it takes to mount the filesystem, and maybe
correlated to how much data there is on the filesystem.

Reboot time used to be normally about 3 minutes, then it jumped to 8
minutes on March 21 and the following weeks it went like this:
8 minutes, 11 minutes, 15 minutes...
19, 19, 19, 19, 23, 21, 22
32, 33, 36, 42, 46, 37, 30

This is on CentOS 6.6, and while I understand that the version of btrfs
is definitely oldish, even trying to mount the filesystem on a much more
recent kernel (3.14.43) there is no improvement. Switching the regular
OS kernel from the CentOS one (2.6.32-504.12.2.el6.x86_64) to something
more recent is also feasible.

I wanted to check the sytem for problems, so tried an offline "btrfs
check" using the latest btrfs-progs (version 4.1.2 freshly compiled from
source), but "btrfs check" ran out of memory after about 30 minutes.

The only output I get is this (timestamps added by me):

  2015-07-28 18:14:45 $ sudo btrfs check /dev/datavg/backuplv
  2015-07-28 18:33:05 checking extents

And at 19:04:55 btrfs was killed by OOM: (abbreviated log below,
full excerpt as an attachment).

  2015-07-28T19:04:55.224855+09:00 localhost kernel: [11689.692680] htop invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
  ...
  2015-07-28T19:04:55.225855+09:00 localhost kernel: [11689.801354] 631 total pagecache pages
  2015-07-28T19:04:55.225857+09:00 localhost kernel: [11689.801829] 0 pages in swap cache
  2015-07-28T19:04:55.225859+09:00 localhost kernel: [11689.802305] Swap cache stats: add 0, delete 0, find 0/0
  2015-07-28T19:04:55.225861+09:00 localhost kernel: [11689.802781] Free swap  = 0kB
  2015-07-28T19:04:55.225863+09:00 localhost kernel: [11689.803341] Total swap = 0kB
  2015-07-28T19:04:55.225864+09:00 localhost kernel: [11689.946223] 16777215 pages RAM
  2015-07-28T19:04:55.225867+09:00 localhost kernel: [11689.946724] 295175 pages reserved
  2015-07-28T19:04:55.225869+09:00 localhost kernel: [11689.947223] 5173 pages shared
  2015-07-28T19:04:55.225871+09:00 localhost kernel: [11689.947721] 16369184 pages non-shared
  2015-07-28T19:04:55.225874+09:00 localhost kernel: [11689.948222] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
  ...
  2015-07-28T19:04:55.225970+09:00 localhost kernel: [11689.994240] [16291]     0 16291    47166      177  18       0             0 sudo
  2015-07-28T19:04:55.225972+09:00 localhost kernel: [11689.995232] [16292]  1000 16292      981       20   3       0             0 tai64n
  2015-07-28T19:04:55.225974+09:00 localhost kernel: [11689.996241] [16293]     0 16293    47166      177  22       0             0 sudo
  2015-07-28T19:04:55.225978+09:00 localhost kernel: [11689.997230] [16294]  1000 16294     1018       21   1       0             0 tai64nlocal
  2015-07-28T19:04:55.225993+09:00 localhost kernel: [11689.998227] [16295]     0 16295 16122385 16118611   7       0             0 btrfs
  2015-07-28T19:04:55.225995+09:00 localhost kernel: [11689.999210] [16296]     0 16296    25228       25   5       0             0 tee
  2015-07-28T19:04:55.225997+09:00 localhost kernel: [11690.000201] [16297]  1000 16297    27133      162   1       0             0 bash
  ...
  2015-07-28T19:04:55.226030+09:00 localhost kernel: [11690.008288] Out of memory: Kill process 16295 (btrfs) score 949 or sacrifice child
  2015-07-28T19:04:55.226031+09:00 localhost kernel: [11690.009300] Killed process 16295, UID 0, (btrfs) total-vm:64489540kB, anon-rss:64474408kB, file-rss:36kB

Thanks in advance for any advice,
-- 
Georgi

--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="oom.log"

2015-07-28T19:04:55.224855+09:00 localhost kernel: [11689.692680] htop invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
2015-07-28T19:04:55.225076+09:00 localhost kernel: [11689.693636] htop cpuset=/ mems_allowed=0-1
2015-07-28T19:04:55.225269+09:00 localhost kernel: [11689.694114] Pid: 16323, comm: htop Tainted: G           ---------------  T 2.6.32-504.12.2.el6.x86_64 #1
2015-07-28T19:04:55.225274+09:00 localhost kernel: [11689.695062] Call Trace:
2015-07-28T19:04:55.225278+09:00 localhost kernel: [11689.695551]  [<ffffffff810d40c1>] ? cpuset_print_task_mems_allowed+0x91/0xb0
2015-07-28T19:04:55.225281+09:00 localhost kernel: [11689.696045]  [<ffffffff81127300>] ? dump_header+0x90/0x1b0
2015-07-28T19:04:55.225283+09:00 localhost kernel: [11689.696534]  [<ffffffff8122eb5c>] ? security_real_capable_noaudit+0x3c/0x70
2015-07-28T19:04:55.225285+09:00 localhost kernel: [11689.697021]  [<ffffffff81127782>] ? oom_kill_process+0x82/0x2a0
2015-07-28T19:04:55.225288+09:00 localhost kernel: [11689.697507]  [<ffffffff811276c1>] ? select_bad_process+0xe1/0x120
2015-07-28T19:04:55.225290+09:00 localhost kernel: [11689.697991]  [<ffffffff81127bc0>] ? out_of_memory+0x220/0x3c0
2015-07-28T19:04:55.225292+09:00 localhost kernel: [11689.698479]  [<ffffffff811344df>] ? __alloc_pages_nodemask+0x89f/0x8d0
2015-07-28T19:04:55.225295+09:00 localhost kernel: [11689.698967]  [<ffffffff8116c69a>] ? alloc_pages_current+0xaa/0x110
2015-07-28T19:04:55.225297+09:00 localhost kernel: [11689.699451]  [<ffffffff811246f7>] ? __page_cache_alloc+0x87/0x90
2015-07-28T19:04:55.225300+09:00 localhost kernel: [11689.699929]  [<ffffffff811240de>] ? find_get_page+0x1e/0xa0
2015-07-28T19:04:55.225302+09:00 localhost kernel: [11689.700413]  [<ffffffff81125697>] ? filemap_fault+0x1a7/0x500
2015-07-28T19:04:55.225305+09:00 localhost kernel: [11689.700896]  [<ffffffff8114eae4>] ? __do_fault+0x54/0x530
2015-07-28T19:04:55.225307+09:00 localhost kernel: [11689.701377]  [<ffffffff8114f0b7>] ? handle_pte_fault+0xf7/0xb00
2015-07-28T19:04:55.225310+09:00 localhost kernel: [11689.701862]  [<ffffffff811b07e0>] ? mntput_no_expire+0x30/0x110
2015-07-28T19:04:55.225314+09:00 localhost kernel: [11689.702348]  [<ffffffff8118b18f>] ? __dentry_open+0x23f/0x360
2015-07-28T19:04:55.225316+09:00 localhost kernel: [11689.702827]  [<ffffffff8122e6ff>] ? security_inode_permission+0x1f/0x30
2015-07-28T19:04:55.225318+09:00 localhost kernel: [11689.703308]  [<ffffffff8114fcea>] ? handle_mm_fault+0x22a/0x300
2015-07-28T19:04:55.225321+09:00 localhost kernel: [11689.703873]  [<ffffffff8104d0d8>] ? __do_page_fault+0x138/0x480
2015-07-28T19:04:55.225323+09:00 localhost kernel: [11689.704357]  [<ffffffff8129901b>] ? strncpy_from_user+0x5b/0x90
2015-07-28T19:04:55.225325+09:00 localhost kernel: [11689.704842]  [<ffffffff8153003e>] ? do_page_fault+0x3e/0xa0
2015-07-28T19:04:55.225328+09:00 localhost kernel: [11689.705329]  [<ffffffff8152d3f5>] ? page_fault+0x25/0x30
2015-07-28T19:04:55.225331+09:00 localhost kernel: [11689.705807] Mem-Info:
2015-07-28T19:04:55.225333+09:00 localhost kernel: [11689.706280] Node 0 DMA per-cpu:
2015-07-28T19:04:55.225336+09:00 localhost kernel: [11689.706756] CPU    0: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225338+09:00 localhost kernel: [11689.707233] CPU    1: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225341+09:00 localhost kernel: [11689.707709] CPU    2: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225344+09:00 localhost kernel: [11689.708190] CPU    3: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225347+09:00 localhost kernel: [11689.708667] CPU    4: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225349+09:00 localhost kernel: [11689.709144] CPU    5: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225352+09:00 localhost kernel: [11689.709622] CPU    6: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225354+09:00 localhost kernel: [11689.710100] CPU    7: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225357+09:00 localhost kernel: [11689.710577] CPU    8: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225359+09:00 localhost kernel: [11689.711052] CPU    9: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225361+09:00 localhost kernel: [11689.711531] CPU   10: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225364+09:00 localhost kernel: [11689.712005] CPU   11: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225366+09:00 localhost kernel: [11689.712485] CPU   12: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225368+09:00 localhost kernel: [11689.712959] CPU   13: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225371+09:00 localhost kernel: [11689.713440] CPU   14: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225373+09:00 localhost kernel: [11689.713912] CPU   15: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225376+09:00 localhost kernel: [11689.714392] CPU   16: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225379+09:00 localhost kernel: [11689.714868] CPU   17: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225381+09:00 localhost kernel: [11689.715350] CPU   18: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225383+09:00 localhost kernel: [11689.715830] CPU   19: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225386+09:00 localhost kernel: [11689.716310] CPU   20: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225388+09:00 localhost kernel: [11689.716788] CPU   21: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225390+09:00 localhost kernel: [11689.717267] CPU   22: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225393+09:00 localhost kernel: [11689.717838] CPU   23: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225396+09:00 localhost kernel: [11689.718314] CPU   24: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225398+09:00 localhost kernel: [11689.718787] CPU   25: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225401+09:00 localhost kernel: [11689.719264] CPU   26: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225403+09:00 localhost kernel: [11689.719741] CPU   27: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225406+09:00 localhost kernel: [11689.720217] CPU   28: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225408+09:00 localhost kernel: [11689.720698] CPU   29: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225411+09:00 localhost kernel: [11689.721177] CPU   30: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225413+09:00 localhost kernel: [11689.721655] CPU   31: hi:    0, btch:   1 usd:   0
2015-07-28T19:04:55.225416+09:00 localhost kernel: [11689.722136] Node 0 DMA32 per-cpu:
2015-07-28T19:04:55.225418+09:00 localhost kernel: [11689.722616] CPU    0: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225421+09:00 localhost kernel: [11689.723095] CPU    1: hi:  186, btch:  31 usd:  30
2015-07-28T19:04:55.225422+09:00 localhost kernel: [11689.734923] CPU    2: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225425+09:00 localhost kernel: [11689.735406] CPU    3: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225427+09:00 localhost kernel: [11689.735880] CPU    4: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225429+09:00 localhost kernel: [11689.736359] CPU    5: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225431+09:00 localhost kernel: [11689.736834] CPU    6: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225433+09:00 localhost kernel: [11689.737312] CPU    7: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225436+09:00 localhost kernel: [11689.737793] CPU    8: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225438+09:00 localhost kernel: [11689.738275] CPU    9: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225440+09:00 localhost kernel: [11689.738755] CPU   10: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225443+09:00 localhost kernel: [11689.739233] CPU   11: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225445+09:00 localhost kernel: [11689.739713] CPU   12: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225448+09:00 localhost kernel: [11689.740192] CPU   13: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225451+09:00 localhost kernel: [11689.740670] CPU   14: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225454+09:00 localhost kernel: [11689.741264] CPU   15: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225469+09:00 localhost kernel: [11689.741744] CPU   16: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225471+09:00 localhost kernel: [11689.742224] CPU   17: hi:  186, btch:  31 usd:  31
2015-07-28T19:04:55.225473+09:00 localhost kernel: [11689.742701] CPU   18: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225476+09:00 localhost kernel: [11689.743178] CPU   19: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225478+09:00 localhost kernel: [11689.743654] CPU   20: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225480+09:00 localhost kernel: [11689.744131] CPU   21: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225483+09:00 localhost kernel: [11689.744610] CPU   22: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225485+09:00 localhost kernel: [11689.745088] CPU   23: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225488+09:00 localhost kernel: [11689.745572] CPU   24: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225490+09:00 localhost kernel: [11689.746144] CPU   25: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225493+09:00 localhost kernel: [11689.746618] CPU   26: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225495+09:00 localhost kernel: [11689.747089] CPU   27: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225498+09:00 localhost kernel: [11689.747570] CPU   28: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225501+09:00 localhost kernel: [11689.748051] CPU   29: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225503+09:00 localhost kernel: [11689.748531] CPU   30: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225505+09:00 localhost kernel: [11689.749007] CPU   31: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225507+09:00 localhost kernel: [11689.749489] Node 0 Normal per-cpu:
2015-07-28T19:04:55.225509+09:00 localhost kernel: [11689.749965] CPU    0: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225510+09:00 localhost kernel: [11689.750444] CPU    1: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225512+09:00 localhost kernel: [11689.750921] CPU    2: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225514+09:00 localhost kernel: [11689.751405] CPU    3: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225517+09:00 localhost kernel: [11689.751886] CPU    4: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225532+09:00 localhost kernel: [11689.752368] CPU    5: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225534+09:00 localhost kernel: [11689.752849] CPU    6: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225536+09:00 localhost kernel: [11689.753329] CPU    7: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225538+09:00 localhost kernel: [11689.753808] CPU    8: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225540+09:00 localhost kernel: [11689.754291] CPU    9: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225543+09:00 localhost kernel: [11689.754770] CPU   10: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225545+09:00 localhost kernel: [11689.755250] CPU   11: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225548+09:00 localhost kernel: [11689.755731] CPU   12: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225550+09:00 localhost kernel: [11689.756214] CPU   13: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225552+09:00 localhost kernel: [11689.756692] CPU   14: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225554+09:00 localhost kernel: [11689.757174] CPU   15: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225556+09:00 localhost kernel: [11689.757652] CPU   16: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225558+09:00 localhost kernel: [11689.758129] CPU   17: hi:  186, btch:  31 usd:   5
2015-07-28T19:04:55.225561+09:00 localhost kernel: [11689.758607] CPU   18: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225563+09:00 localhost kernel: [11689.759081] CPU   19: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225570+09:00 localhost kernel: [11689.759559] CPU   20: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225573+09:00 localhost kernel: [11689.760038] CPU   21: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225575+09:00 localhost kernel: [11689.760608] CPU   22: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225578+09:00 localhost kernel: [11689.761082] CPU   23: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225580+09:00 localhost kernel: [11689.761562] CPU   24: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225582+09:00 localhost kernel: [11689.762040] CPU   25: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225584+09:00 localhost kernel: [11689.762519] CPU   26: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225585+09:00 localhost kernel: [11689.762998] CPU   27: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225587+09:00 localhost kernel: [11689.763481] CPU   28: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225589+09:00 localhost kernel: [11689.763961] CPU   29: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225591+09:00 localhost kernel: [11689.764442] CPU   30: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225593+09:00 localhost kernel: [11689.764921] CPU   31: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225595+09:00 localhost kernel: [11689.765402] Node 1 Normal per-cpu:
2015-07-28T19:04:55.225597+09:00 localhost kernel: [11689.765882] CPU    0: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225599+09:00 localhost kernel: [11689.766365] CPU    1: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225601+09:00 localhost kernel: [11689.766839] CPU    2: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225603+09:00 localhost kernel: [11689.767316] CPU    3: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225605+09:00 localhost kernel: [11689.767791] CPU    4: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225607+09:00 localhost kernel: [11689.768268] CPU    5: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225609+09:00 localhost kernel: [11689.768746] CPU    6: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225611+09:00 localhost kernel: [11689.769228] CPU    7: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225614+09:00 localhost kernel: [11689.769708] CPU    8: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225616+09:00 localhost kernel: [11689.770187] CPU    9: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225618+09:00 localhost kernel: [11689.770665] CPU   10: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225620+09:00 localhost kernel: [11689.771145] CPU   11: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225622+09:00 localhost kernel: [11689.771624] CPU   12: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225625+09:00 localhost kernel: [11689.772105] CPU   13: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225774+09:00 localhost kernel: [11689.772585] CPU   14: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225777+09:00 localhost kernel: [11689.773063] CPU   15: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225780+09:00 localhost kernel: [11689.773545] CPU   16: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225782+09:00 localhost kernel: [11689.774023] CPU   17: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225784+09:00 localhost kernel: [11689.774506] CPU   18: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225786+09:00 localhost kernel: [11689.775078] CPU   19: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225789+09:00 localhost kernel: [11689.775557] CPU   20: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225792+09:00 localhost kernel: [11689.776031] CPU   21: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225794+09:00 localhost kernel: [11689.776511] CPU   22: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225796+09:00 localhost kernel: [11689.776986] CPU   23: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225797+09:00 localhost kernel: [11689.777469] CPU   24: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225799+09:00 localhost kernel: [11689.777948] CPU   25: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225802+09:00 localhost kernel: [11689.778429] CPU   26: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225804+09:00 localhost kernel: [11689.778906] CPU   27: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225806+09:00 localhost kernel: [11689.779386] CPU   28: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225808+09:00 localhost kernel: [11689.779861] CPU   29: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225810+09:00 localhost kernel: [11689.780343] CPU   30: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225813+09:00 localhost kernel: [11689.780823] CPU   31: hi:  186, btch:  31 usd:   0
2015-07-28T19:04:55.225815+09:00 localhost kernel: [11689.781309] active_anon:16209682 inactive_anon:26 isolated_anon:0
2015-07-28T19:04:55.225817+09:00 localhost kernel: [11689.781309]  active_file:124 inactive_file:123 isolated_file:0
2015-07-28T19:04:55.225819+09:00 localhost kernel: [11689.781310]  unevictable:0 dirty:3 writeback:0 unstable:0
2015-07-28T19:04:55.225822+09:00 localhost kernel: [11689.781311]  free:98591 slab_reclaimable:4276 slab_unreclaimable:15061
2015-07-28T19:04:55.225824+09:00 localhost kernel: [11689.781311]  mapped:202 shmem:132 pagetables:32940 bounce:0
2015-07-28T19:04:55.225827+09:00 localhost kernel: [11689.783710] Node 0 DMA free:15740kB min:60kB low:72kB high:88kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15348kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
2015-07-28T19:04:55.225830+09:00 localhost kernel: [11689.786576] lowmem_reserve[]: 0 2955 32245 32245
2015-07-28T19:04:55.225832+09:00 localhost kernel: [11689.787078] Node 0 DMA32 free:129148kB min:11992kB low:14988kB high:17988kB active_anon:2270248kB inactive_anon:0kB active_file:76kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3026080kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:1268kB slab_unreclaimable:1140kB kernel_stack:0kB pagetables:4288kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:124 all_unreclaimable? yes
2015-07-28T19:04:55.225835+09:00 localhost kernel: [11689.790032] lowmem_reserve[]: 0 0 29290 29290
2015-07-28T19:04:55.225837+09:00 localhost kernel: [11689.790536] Node 0 Normal free:118632kB min:118892kB low:148612kB high:178336kB active_anon:29973164kB inactive_anon:40kB active_file:0kB inactive_file:108kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:29992960kB mlocked:0kB dirty:0kB writeback:0kB mapped:4kB shmem:232kB slab_reclaimable:8184kB slab_unreclaimable:35756kB kernel_stack:4992kB pagetables:61180kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:168 all_unreclaimable? yes
2015-07-28T19:04:55.225839+09:00 localhost kernel: [11689.793404] lowmem_reserve[]: 0 0 0 0
2015-07-28T19:04:55.225841+09:00 localhost kernel: [11689.793904] Node 1 Normal free:130844kB min:131192kB low:163988kB high:196788kB active_anon:32595316kB inactive_anon:64kB active_file:420kB inactive_file:484kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:33095680kB mlocked:0kB dirty:12kB writeback:0kB mapped:804kB shmem:296kB slab_reclaimable:7652kB slab_unreclaimable:23348kB kernel_stack:376kB pagetables:66292kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1426 all_unreclaimable? yes
2015-07-28T19:04:55.225844+09:00 localhost kernel: [11689.796784] lowmem_reserve[]: 0 0 0 0
2015-07-28T19:04:55.225846+09:00 localhost kernel: [11689.797286] Node 0 DMA: 3*4kB 0*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15740kB
2015-07-28T19:04:55.225848+09:00 localhost kernel: [11689.798302] Node 0 DMA32: 348*4kB 323*8kB 294*16kB 230*32kB 189*64kB 145*128kB 92*256kB 47*512kB 26*1024kB 4*2048kB 0*4096kB = 129128kB
2015-07-28T19:04:55.225850+09:00 localhost kernel: [11689.799321] Node 0 Normal: 30009*4kB 1*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 120044kB
2015-07-28T19:04:55.225852+09:00 localhost kernel: [11689.800336] Node 1 Normal: 32983*4kB 11*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 132036kB
2015-07-28T19:04:55.225855+09:00 localhost kernel: [11689.801354] 631 total pagecache pages
2015-07-28T19:04:55.225857+09:00 localhost kernel: [11689.801829] 0 pages in swap cache
2015-07-28T19:04:55.225859+09:00 localhost kernel: [11689.802305] Swap cache stats: add 0, delete 0, find 0/0
2015-07-28T19:04:55.225861+09:00 localhost kernel: [11689.802781] Free swap  = 0kB
2015-07-28T19:04:55.225863+09:00 localhost kernel: [11689.803341] Total swap = 0kB
2015-07-28T19:04:55.225864+09:00 localhost kernel: [11689.946223] 16777215 pages RAM
2015-07-28T19:04:55.225867+09:00 localhost kernel: [11689.946724] 295175 pages reserved
2015-07-28T19:04:55.225869+09:00 localhost kernel: [11689.947223] 5173 pages shared
2015-07-28T19:04:55.225871+09:00 localhost kernel: [11689.947721] 16369184 pages non-shared
2015-07-28T19:04:55.225874+09:00 localhost kernel: [11689.948222] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
2015-07-28T19:04:55.225876+09:00 localhost kernel: [11689.949309] [ 1327]     0  1327     2874      317   1     -17         -1000 udevd
2015-07-28T19:04:55.225879+09:00 localhost kernel: [11689.950308] [ 3227]     0  3227    25814       77   0       0             0 lvmetad
2015-07-28T19:04:55.225881+09:00 localhost kernel: [11689.951302] [ 8574]     0  8574     6899       61   5     -17         -1000 auditd
2015-07-28T19:04:55.225883+09:00 localhost kernel: [11689.952296] [ 8594]     0  8594   125317      287   3       0             0 rsyslogd
2015-07-28T19:04:55.225886+09:00 localhost kernel: [11689.953289] [ 8718]     0  8718    40367      243   0       0             0 pbx_exchange
2015-07-28T19:04:55.225888+09:00 localhost kernel: [11689.954284] [ 8730]    81  8730     5358       63   1       0             0 dbus-daemon
2015-07-28T19:04:55.225890+09:00 localhost kernel: [11689.955281] [ 8768]     0  8768    63314    14236  16       0             0 snmpd
2015-07-28T19:04:55.225892+09:00 localhost kernel: [11689.956277] [ 8785]     0  8785    16554      178   0     -17         -1000 sshd
2015-07-28T19:04:55.225894+09:00 localhost kernel: [11689.957265] [ 8796]     0  8796     5429       59   1       0             0 xinetd
2015-07-28T19:04:55.225897+09:00 localhost kernel: [11689.958259] [ 8823]    38  8823     6627      147   0       0             0 ntpd
2015-07-28T19:04:55.225899+09:00 localhost kernel: [11689.959254] [ 8902]     0  8902    20214      226  21       0             0 master
2015-07-28T19:04:55.225901+09:00 localhost kernel: [11689.960325] [ 8912]     0  8912    29216      156  16       0             0 crond
2015-07-28T19:04:55.225903+09:00 localhost kernel: [11689.961316] [ 8914]    89  8914    20277      238   1       0             0 qmgr
2015-07-28T19:04:55.225906+09:00 localhost kernel: [11689.962315] [ 8935]     0  8935     5276       45   1       0             0 atd
2015-07-28T19:04:55.225908+09:00 localhost kernel: [11689.963310] [ 9141]     0  9141   257570     5334   0       0             0 dsm_sa_datamgrd
2015-07-28T19:04:55.225910+09:00 localhost kernel: [11689.964305] [ 9334]     0  9334    73207      203  17       0             0 dsm_sa_eventmgr
2015-07-28T19:04:55.225913+09:00 localhost kernel: [11689.977183] [ 9347]     0  9347   125807     2198  20       0             0 dsm_sa_snmpd
2015-07-28T19:04:55.225915+09:00 localhost kernel: [11689.978202] [ 9381]     0  9381    33145      113   3       0             0 dsm_om_connsvcd
2015-07-28T19:04:55.225929+09:00 localhost kernel: [11689.979228] [ 9382]     0  9382   889850    61373  19       0             0 dsm_om_connsvcd
2015-07-28T19:04:55.225931+09:00 localhost kernel: [11689.980218] [ 9414]     0  9414   189407     5176   0       0             0 dsm_sa_datamgrd
2015-07-28T19:04:55.225934+09:00 localhost kernel: [11689.981215] [ 9435]     0  9435   159830     1217   1       0             0 dsm_om_shrsvcd
2015-07-28T19:04:55.225936+09:00 localhost kernel: [11689.982216] [10192]     0 10192     1016       20   9       0             0 mingetty
2015-07-28T19:04:55.225938+09:00 localhost kernel: [11689.983201] [10194]     0 10194     1016       21  19       0             0 mingetty
2015-07-28T19:04:55.225940+09:00 localhost kernel: [11689.984202] [10196]     0 10196     1016       21  19       0             0 mingetty
2015-07-28T19:04:55.225942+09:00 localhost kernel: [11689.985201] [10200]     0 10200     1016       21  27       0             0 mingetty
2015-07-28T19:04:55.225944+09:00 localhost kernel: [11689.986180] [10202]     0 10202     1016       22  25       0             0 mingetty
2015-07-28T19:04:55.225946+09:00 localhost kernel: [11689.987176] [13176]  1000 13176     7468     1112  21       0             0 tmux
2015-07-28T19:04:55.225949+09:00 localhost kernel: [11689.988269] [13177]  1000 13177    27187      201   1       0             0 bash
2015-07-28T19:04:55.225951+09:00 localhost kernel: [11689.989268] [13242]     0 13242     1016       21   0       0             0 mingetty
2015-07-28T19:04:55.225961+09:00 localhost kernel: [11689.990262] [15161]     0 15161     2663      109   5     -17         -1000 udevd
2015-07-28T19:04:55.225964+09:00 localhost kernel: [11689.991245] [15179]     0 15179     2661      104   2     -17         -1000 udevd
2015-07-28T19:04:55.225966+09:00 localhost kernel: [11689.992266] [15471]  1000 15471    27133      168   0       0             0 bash
2015-07-28T19:04:55.225968+09:00 localhost kernel: [11689.993246] [15577]    89 15577    20234      218   1       0             0 pickup
2015-07-28T19:04:55.225970+09:00 localhost kernel: [11689.994240] [16291]     0 16291    47166      177  18       0             0 sudo
2015-07-28T19:04:55.225972+09:00 localhost kernel: [11689.995232] [16292]  1000 16292      981       20   3       0             0 tai64n
2015-07-28T19:04:55.225974+09:00 localhost kernel: [11689.996241] [16293]     0 16293    47166      177  22       0             0 sudo
2015-07-28T19:04:55.225978+09:00 localhost kernel: [11689.997230] [16294]  1000 16294     1018       21   1       0             0 tai64nlocal
2015-07-28T19:04:55.225993+09:00 localhost kernel: [11689.998227] [16295]     0 16295 16122385 16118611   7       0             0 btrfs
2015-07-28T19:04:55.225995+09:00 localhost kernel: [11689.999210] [16296]     0 16296    25228       25   5       0             0 tee
2015-07-28T19:04:55.225997+09:00 localhost kernel: [11690.000201] [16297]  1000 16297    27133      162   1       0             0 bash
2015-07-28T19:04:55.225999+09:00 localhost kernel: [11690.001179] [16322]     0 16322    47166      178  19       0             0 sudo
2015-07-28T19:04:55.226015+09:00 localhost kernel: [11690.002167] [16323]     0 16323    28411      433   1       0             0 htop
2015-07-28T19:04:55.226020+09:00 localhost kernel: [11690.003270] [16329]  1000 16329    25240       38   0       0             0 iostat
2015-07-28T19:04:55.226022+09:00 localhost kernel: [11690.004244] [16436]     0 16436    24490      233   0       0             0 sshd
2015-07-28T19:04:55.226024+09:00 localhost kernel: [11690.005229] [16454]  1000 16454    24490      237   2       0             0 sshd
2015-07-28T19:04:55.226026+09:00 localhost kernel: [11690.006230] [16455]  1000 16455    27142      178  16       0             0 bash
2015-07-28T19:04:55.226028+09:00 localhost kernel: [11690.007272] [16481]  1000 16481     5925       82  18       0             0 tmux
2015-07-28T19:04:55.226030+09:00 localhost kernel: [11690.008288] Out of memory: Kill process 16295 (btrfs) score 949 or sacrifice child
2015-07-28T19:04:55.226031+09:00 localhost kernel: [11690.009300] Killed process 16295, UID 0, (btrfs) total-vm:64489540kB, anon-rss:64474408kB, file-rss:36kB

--tThc/1wpZn/ma/RB--
