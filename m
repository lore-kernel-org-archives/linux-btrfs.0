Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12525 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751683AbbG2GTX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jul 2015 02:19:23 -0400
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: Georgi Georgiev <georgi-georgiev-btrfs@japannext.co.jp>,
        <linux-btrfs@vger.kernel.org>
References: <20150729054659.GD9039@jnext-0060.corp.japannext.co.jp>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55B87065.4060703@cn.fujitsu.com>
Date: Wed, 29 Jul 2015 14:19:17 +0800
MIME-Version: 1.0
In-Reply-To: <20150729054659.GD9039@jnext-0060.corp.japannext.co.jp>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Georgi Georgiev wrote on 2015/07/29 14:46 +0900:
> Using BTRFS on a very large filesystem, and as we put and more data to
> it, the time it takes to mount it grew to, presently, about 30 minutes.
> Is there something wrong with the filesystem? Is there a way to bring
> this time down?
>
> ...
>
> Here is a snippet from dmesg, showing how long it takes to mount (the
> EXT4-fs line is the filesystem mounted next in the boot sequence):
>
>    $ dmesg | grep -A1 btrfs
>    [   12.215764] TECH PREVIEW: btrfs may not be fully supported.
>    [   12.215766] Please review provided documentation for limitations.
>    --
>    [   12.220266] btrfs: use zlib compression
>    [   12.220815] btrfs: disk space caching is enabled
>    [   22.427258] btrfs: bdev /dev/mapper/datavg-backuplv errs: wr 0, rd 0, flush 0, corrupt 0, gen 0
>    [ 2022.397318] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts:
>
Quite common, especial when it grows large.
But it would be much better to use ftrace to show which btrfs operation 
takes the most time.

We have some guess on this, from reading space cache to reading chunk info.
But didn't know which takes the most of time.
> The btrfs filesystem is quite large:
>
>    $ sudo btrfs filesystem usage /dev/mapper/datavg-backuplv
>    Overall:
>        Device size:                  82.58TiB
>        Device allocated:             82.58TiB
>        Device unallocated:              0.00B
>        Device missing:                  0.00B
>        Used:                         62.01TiB
>        Free (estimated):             17.76TiB      (min: 17.76TiB)
>        Data ratio:                       1.00
>        Metadata ratio:                   2.00
>        Global reserve:                  0.00B      (used: 0.00B)
>
>    Data,single: Size:79.28TiB, Used:61.52TiB
>       /dev/mapper/datavg-backuplv    79.28TiB
>
>    Metadata,single: Size:8.00MiB, Used:0.00B
>       /dev/mapper/datavg-backuplv     8.00MiB
>
>    Metadata,DUP: Size:1.65TiB, Used:252.68GiB
>       /dev/mapper/datavg-backuplv     3.30TiB
>
>    System,single: Size:4.00MiB, Used:0.00B
>       /dev/mapper/datavg-backuplv     4.00MiB
>
>    System,DUP: Size:40.00MiB, Used:8.66MiB
>       /dev/mapper/datavg-backuplv    80.00MiB
>
>    Unallocated:
>       /dev/mapper/datavg-backuplv       0.00B
Wow, near 100T, that really huge now.
>
> Other info about the filesystem is that it has a rather large number of
> files and subvolumes and read only snapshots, which started from about
> zero in March, and grew over to the current state of 3000 snapshots and
> no idea how many files (filesystem usage is quite stable at the moment).
>
> I also noticed that while the machine is rebooted on a weekly basis, the
> time it takes to come up after a reboot has been growing. This is likely
> correlated to how long it takes to mount the filesystem, and maybe
> correlated to how much data there is on the filesystem.
>
> Reboot time used to be normally about 3 minutes, then it jumped to 8
> minutes on March 21 and the following weeks it went like this:
> 8 minutes, 11 minutes, 15 minutes...
> 19, 19, 19, 19, 23, 21, 22
> 32, 33, 36, 42, 46, 37, 30
>
> This is on CentOS 6.6, and while I understand that the version of btrfs
> is definitely oldish, even trying to mount the filesystem on a much more
> recent kernel (3.14.43) there is no improvement. Switching the regular
> OS kernel from the CentOS one (2.6.32-504.12.2.el6.x86_64) to something
> more recent is also feasible.
>
> I wanted to check the sytem for problems, so tried an offline "btrfs
> check" using the latest btrfs-progs (version 4.1.2 freshly compiled from
> source), but "btrfs check" ran out of memory after about 30 minutes.
>
> The only output I get is this (timestamps added by me):
>
>    2015-07-28 18:14:45 $ sudo btrfs check /dev/datavg/backuplv
>    2015-07-28 18:33:05 checking extents
>
> And at 19:04:55 btrfs was killed by OOM: (abbreviated log below,
> full excerpt as an attachment).
Not surprised at all.
As for extent/chunk tree checking, it will read all the the chunk and 
extents, and restore needed info into memory, and then do cross 
reference check.

The btrfsck process really takes a lot of memory.
Maybe 1/10 or more of the metadata space.
In your case, your metadata is about 250GB, so maybe 25GB memory is used 
to hold the needed info.

That's already known but we don't have some good idea or deveopler to 
reduce the space usage yet.

Maybe we can change the behavior to do chunk by chunk extent cross 
checking to reduce memory usage, but not now...

Thanks,
Qu
>
>    2015-07-28T19:04:55.224855+09:00 localhost kernel: [11689.692680] htop invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
>    ...
>    2015-07-28T19:04:55.225855+09:00 localhost kernel: [11689.801354] 631 total pagecache pages
>    2015-07-28T19:04:55.225857+09:00 localhost kernel: [11689.801829] 0 pages in swap cache
>    2015-07-28T19:04:55.225859+09:00 localhost kernel: [11689.802305] Swap cache stats: add 0, delete 0, find 0/0
>    2015-07-28T19:04:55.225861+09:00 localhost kernel: [11689.802781] Free swap  = 0kB
>    2015-07-28T19:04:55.225863+09:00 localhost kernel: [11689.803341] Total swap = 0kB
>    2015-07-28T19:04:55.225864+09:00 localhost kernel: [11689.946223] 16777215 pages RAM
>    2015-07-28T19:04:55.225867+09:00 localhost kernel: [11689.946724] 295175 pages reserved
>    2015-07-28T19:04:55.225869+09:00 localhost kernel: [11689.947223] 5173 pages shared
>    2015-07-28T19:04:55.225871+09:00 localhost kernel: [11689.947721] 16369184 pages non-shared
>    2015-07-28T19:04:55.225874+09:00 localhost kernel: [11689.948222] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
>    ...
>    2015-07-28T19:04:55.225970+09:00 localhost kernel: [11689.994240] [16291]     0 16291    47166      177  18       0             0 sudo
>    2015-07-28T19:04:55.225972+09:00 localhost kernel: [11689.995232] [16292]  1000 16292      981       20   3       0             0 tai64n
>    2015-07-28T19:04:55.225974+09:00 localhost kernel: [11689.996241] [16293]     0 16293    47166      177  22       0             0 sudo
>    2015-07-28T19:04:55.225978+09:00 localhost kernel: [11689.997230] [16294]  1000 16294     1018       21   1       0             0 tai64nlocal
>    2015-07-28T19:04:55.225993+09:00 localhost kernel: [11689.998227] [16295]     0 16295 16122385 16118611   7       0             0 btrfs
>    2015-07-28T19:04:55.225995+09:00 localhost kernel: [11689.999210] [16296]     0 16296    25228       25   5       0             0 tee
>    2015-07-28T19:04:55.225997+09:00 localhost kernel: [11690.000201] [16297]  1000 16297    27133      162   1       0             0 bash
>    ...
>    2015-07-28T19:04:55.226030+09:00 localhost kernel: [11690.008288] Out of memory: Kill process 16295 (btrfs) score 949 or sacrifice child
>    2015-07-28T19:04:55.226031+09:00 localhost kernel: [11690.009300] Killed process 16295, UID 0, (btrfs) total-vm:64489540kB, anon-rss:64474408kB, file-rss:36kB
>
> Thanks in advance for any advice,
>
