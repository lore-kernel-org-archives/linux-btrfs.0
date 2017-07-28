Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.arhont.com ([178.248.108.132]:34407 "EHLO mail.arhont.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752484AbdG1Qrl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2017 12:47:41 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail1.arhont.com (Postfix) with ESMTP id A74C4980853
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jul 2017 17:40:51 +0100 (BST)
Received: from mail.arhont.com ([127.0.0.1])
        by localhost (mail1.arhont.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id BKFn2VGn63nu for <linux-btrfs@vger.kernel.org>;
        Fri, 28 Jul 2017 17:40:51 +0100 (BST)
Received: from localhost (localhost [127.0.0.1])
        by mail1.arhont.com (Postfix) with ESMTP id 76547980855
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jul 2017 17:40:51 +0100 (BST)
Received: from mail.arhont.com ([127.0.0.1])
        by localhost (mail1.arhont.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id WC9r-DW766_s for <linux-btrfs@vger.kernel.org>;
        Fri, 28 Jul 2017 17:40:51 +0100 (BST)
Received: from mail1.arhont.com (mail1.arhont.com [178.248.108.132])
        by mail1.arhont.com (Postfix) with ESMTP id 45A08980853
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jul 2017 17:40:51 +0100 (BST)
Date: Fri, 28 Jul 2017 17:40:50 +0100 (BST)
From: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>
To: linux-btrfs@vger.kernel.org
Message-ID: <8446582.541.1501260065690.JavaMail.gkos@dynomob>
In-Reply-To: <33040946.535.1501254718807.JavaMail.gkos@dynomob>
Subject: Btrfs + compression = slow performance and high cpu usage
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list, 

I am stuck with a problem of btrfs slow performance when using compression.

when the compress-force=lzo mount flag is enabled, the performance drops to 30-40 mb/s and one of the btrfs processes utilises 100% cpu time.
mount options: btrfs relatime,discard,autodefrag,compress=lzo,compress-force,space_cache=v2,commit=10

The command I am testing the write throughput is

# pv -tpreb /dev/sdb | dd of=./testfile bs=1M oflag=direct

# top -d 1 
top - 15:49:13 up  1:52,  2 users,  load average: 5.28, 2.32, 1.39
Tasks: 320 total,   2 running, 318 sleeping,   0 stopped,   0 zombie
%Cpu0  :  0.0 us,  2.0 sy,  0.0 ni, 77.0 id, 21.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu1  :  0.0 us,  1.0 sy,  0.0 ni, 90.0 id,  9.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu2  :  0.0 us,  1.0 sy,  0.0 ni, 72.0 id, 27.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu3  :  0.0 us,100.0 sy,  0.0 ni,  0.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu4  :  0.0 us,  1.0 sy,  0.0 ni, 57.0 id, 42.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu5  :  0.0 us,  0.0 sy,  0.0 ni, 96.0 id,  4.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu6  :  0.0 us,  0.0 sy,  0.0 ni, 94.0 id,  6.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu7  :  0.0 us,  1.0 sy,  0.0 ni, 95.1 id,  3.9 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu8  :  1.0 us,  2.0 sy,  0.0 ni, 24.0 id, 73.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu9  :  0.0 us,  0.0 sy,  0.0 ni, 81.8 id, 18.2 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu10 :  1.0 us,  0.0 sy,  0.0 ni, 98.0 id,  1.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu11 :  0.0 us,  2.0 sy,  0.0 ni, 83.3 id, 14.7 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem : 32934136 total, 10137496 free,   602244 used, 22194396 buff/cache
KiB Swap:        0 total,        0 free,        0 used. 30525664 avail Mem 

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND                                                                                                                               
37017 root      20   0       0      0      0 R 100.0  0.0   0:32.42 kworker/u49:8                                                                                                                         
36732 root      20   0       0      0      0 D   4.0  0.0   0:02.40 btrfs-transacti                                                                                                                       
40105 root      20   0    8388   3040   2000 D   4.0  0.0   0:02.88 dd       


The keyworker process that causes the high cpu usage is  most likely searching for the free space.

# echo l > /proc/sysrq-trigger

# dmest -T
Fri Jul 28 15:57:51 2017] CPU: 1 PID: 36430 Comm: kworker/u49:2 Not tainted 4.10.0-28-generic #32~16.04.2-Ubuntu
[Fri Jul 28 15:57:51 2017] Hardware name: Supermicro X8DTL/X8DTL, BIOS 2.1b       11/16/2012
[Fri Jul 28 15:57:51 2017] Workqueue: btrfs-delalloc btrfs_delalloc_helper [btrfs]
[Fri Jul 28 15:57:51 2017] task: ffff9ddce6206a40 task.stack: ffffaa9121f6c000
[Fri Jul 28 15:57:51 2017] RIP: 0010:rb_next+0x1e/0x40
[Fri Jul 28 15:57:51 2017] RSP: 0018:ffffaa9121f6fb40 EFLAGS: 00000282
[Fri Jul 28 15:57:51 2017] RAX: ffff9dddc34df1b0 RBX: 0000000000010000 RCX: 0000000000001000
[Fri Jul 28 15:57:51 2017] RDX: ffff9dddc34df708 RSI: ffff9ddccaf470a4 RDI: ffff9dddc34df2d0
[Fri Jul 28 15:57:51 2017] RBP: ffffaa9121f6fb40 R08: 0000000000000001 R09: 0000000000003000
[Fri Jul 28 15:57:51 2017] R10: 0000000000000000 R11: 0000000000020000 R12: ffff9ddccaf47080
[Fri Jul 28 15:57:51 2017] R13: 0000000000001000 R14: ffffaa9121f6fc50 R15: ffff9dddc34df2d0
[Fri Jul 28 15:57:51 2017] FS:  0000000000000000(0000) GS:ffff9ddcefa40000(0000) knlGS:0000000000000000
[Fri Jul 28 15:57:51 2017] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Fri Jul 28 15:57:51 2017] Call Trace:_space_for_alloc+0xde/0x270 [btrfs]
[Fri Jul 28 15:57:51 2017]  btrfs_find_space_for_alloc+0xde/0x270 [btrfs]
[Fri Jul 28 15:57:51 2017]  find_free_extent.isra.68+0x3c6/0x1040 [btrfs]s]
[Fri Jul 28 15:57:51 2017]  btrfs_reserve_extent+0xab/0x210 [btrfs]btrfs]
[Fri Jul 28 15:57:51 2017]  submit_compressed_extents+0x154/0x580 [btrfs]s]
[Fri Jul 28 15:57:51 2017]  ? submit_compressed_extents+0x580/0x580 [btrfs]
[Fri Jul 28 15:57:51 2017]  async_cow_submit+0x82/0x90 [btrfs]00 [btrfs]
[Fri Jul 28 15:57:51 2017]  btrfs_scrubparity_helper+0x1fe/0x300 [btrfs]
[Fri Jul 28 15:57:51 2017]  btrfs_delalloc_helper+0xe/0x10 [btrfs]
[Fri Jul 28 15:57:51 2017]  process_one_work+0x16b/0x4a0a0
[Fri Jul 28 15:57:51 2017]  worker_thread+0x4b/0x500+0x60/0x60
[Fri Jul 28 15:57:51 2017]  kthread+0x109/0x1400x4a0/0x4a0




When the compression is turned off, I am able to get the maximum 500-600 mb/s write speed on this disk (raid array) with minimal cpu usage.

mount options: relatime,discard,autodefrag,space_cache=v2,commit=10

# iostat -m 1 
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.08    0.00    7.74   10.77    0.00   81.40

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sda            2376.00         0.00       594.01          0        594


I have tried deleting mounting with nospace_cache, clear_cache, and then rebuilding with space_cache=v2
but it doesn't make any difference. The same sluggish performance is experienced when I try to write over the NFS.

Any ideas why the compression makes such a big difference and causes a bottleneck?





# uname -a
Linux backup1 4.10.0-28-generic #32~16.04.2-Ubuntu SMP Thu Jul 20 10:19:48 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

# btrfs --version
btrfs-progs v4.8.1

# cat /etc/issue
Ubuntu 16.04.2 LTS \n \l

# btrfs fi show
Label: none  uuid: f56bdc4a-239d-4268-81d8-01cdd7a3c1c9
        Total devices 1 FS bytes used 9.32TiB
        devid    2 size 21.83TiB used 9.33TiB path /dev/sda

# btrfs fi df /mnt/arh-backup1/
Data, single: total=9.28TiB, used=9.28TiB
System, single: total=32.00MiB, used=1.00MiB
Metadata, single: total=46.00GiB, used=44.20GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


# btrfs device usage /mnt/arh-backup1/
/dev/sda, ID: 2
   Device size:            21.83TiB
   Device slack:              0.00B
   Data,single:             9.29TiB
   Metadata,single:        46.00GiB
   System,single:          32.00MiB
   Unallocated:            12.49TiB


thanks in advance.
kos




