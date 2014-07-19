Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47057 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbaGSB7A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jul 2014 21:59:00 -0400
Date: Fri, 18 Jul 2014 18:58:48 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>
Cc: Cody P Schafer <dev@codyps.com>, Chris Samuel <chris@csamuel.org>,
        linux-btrfs@vger.kernel.org
Message-ID: <20140719015848.GD11996@merlins.org>
References: <53B1ACAA.5040505@fb.com>
 <CAPoQQ-14VPzzwTDDXmLSmEUs2Rm_HyukoYjeFfOi9LOjqaRCWw@mail.gmail.com>
 <53B32275.6010200@fb.com>
 <CAPoQQ-3DmAg=s0eBKirGmkfMhaC1bEyJu8fSJc-6fV-EvUbmxQ@mail.gmail.com>
 <CAPoQQ-1kn+UNfcE4+qeO4yKaX43PenqxBtMXABuP=Ot8=ZB2Gw@mail.gmail.com>
 <53B40FEC.4030902@fb.com>
 <53B4140C.8060406@fb.com>
 <53C7CD0F.7070603@fb.com>
 <20140719003345.GB11996@merlins.org>
 <20140719004457.GC11996@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140719004457.GC11996@merlins.org>
Subject: Re: Blocked tasks on 3.15.1, raid1 btrfs is no ends of trouble for me
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

TL;DR: 3.15.5 (or .1 when I tried it) just hang over and over again in
multiple ways on my server.
They also hang on my laptop reliably if I enable kmemleak, but otherwise
my laptop mostly survives with 3.15.x without kmemleak (although it does
deadlock eventually, but that could be after days/weeks, not hours).

I reverted to 3.14 on that machine, and everything is good again.

As a note, this is the 3rd time I try to upgrade this server to 3.15 and
everything goes to crap. I then go back to 3.14 and things work again,
not great since btrfs has never been great and stable for me, but it
works well enough.

On Fri, Jul 18, 2014 at 05:44:57PM -0700, Marc MERLIN wrote:
> On Fri, Jul 18, 2014 at 05:33:45PM -0700, Marc MERLIN wrote:
> > Howver, I have found that btrfs raid 1 on top of dmcrypt has given me no ends of trouble.
> > I lost that filesystem twice due to corruption, and now it hangs my machine (strace finds
> > that df is hanging on that partition).
> > gargamel:~# btrfs fi df /mnt/btrfs_raid0
> > Data, RAID1: total=222.00GiB, used=221.61GiB
> > Data, single: total=8.00MiB, used=0.00
> > System, RAID1: total=8.00MiB, used=48.00KiB
> > System, single: total=4.00MiB, used=0.00
> > Metadata, RAID1: total=2.00GiB, used=1.10GiB
> > Metadata, single: total=8.00MiB, used=0.00
> > unknown, single: total=384.00MiB, used=0.00
> > gargamel:~# btrfs fi show /mnt/btrfs_raid0
> > Label: 'btrfs_raid0'  uuid: 74279e10-46e7-4ac4-8216-a291819a6691
> >         Total devices 2 FS bytes used 222.71GiB
> >         devid    1 size 836.13GiB used 224.03GiB path /dev/dm-3
> >         devid    2 size 836.13GiB used 224.01GiB path /dev/mapper/raid0d2
> > 
> > Btrfs v3.14.1
> > 
> > 
> > This is not encouraging, I think I'm going to stop using raid1 in btrfs :(
> 
> Sorry, this may be a bit misleading. I actually lost 2 filesystems that
> were raid0 on top of dmcrypt.
> This time it's raid1, and the data isn't lost, but btrfs is tripping all
> over itself and taking my whole system apparently because of that
> filesystem.

And just to say that I'm wrong at pinning this down, the same 3.15.5
with your patch locked up on my root filesystem on the next boot

This time sysrq-w worked for a change.
Excerpt:

31933	    03:54 btrfs_file_llseek		 tail -n 50 /var/local/src/misterhouse/data/logs/print.log
31960	    32:54 btrfs_file_llseek		 tail -n 50 /var/local/src/misterhouse/data/logs/print.log
32077	    18:54 btrfs_file_llseek		 tail -n 50 /var/local/src/misterhouse/data/logs/print.log

[ 2176.230211] tail	       D ffff8801b3a567c0     0 25396  22031 0x20020080
[ 2176.252788]	ffff88006fed3e20 0000000000000082 00000000000000a8 ffff88006fed3fd8
[ 2176.276039]	ffff8801a542a3d0 00000000000141c0 ffff88020c374e10 ffff88020c374e14
[ 2176.299273]	ffff8801a542a3d0 ffff88020c374e18 00000000ffffffff ffff88006fed3e30
[ 2176.322515] Call Trace:
[ 2176.330739]	[<ffffffff8161fa5e>] schedule+0x73/0x75
[ 2176.346527]	[<ffffffff8161fd1f>] schedule_preempt_disabled+0x18/0x24
[ 2176.367208]	[<ffffffff81620e42>] __mutex_lock_slowpath+0x160/0x1d7
[ 2176.386946]	[<ffffffff81620ed0>] mutex_lock+0x17/0x27
[ 2176.403727]	[<ffffffff8123a33a>] btrfs_file_llseek+0x40/0x205
[ 2176.422603]	[<ffffffff810be59a>] ? from_kgid_munged+0x12/0x1e
[ 2176.441015]	[<ffffffff810482f1>] ? cp_stat64+0x50/0x20b
[ 2176.457841]	[<ffffffff81156627>] vfs_llseek+0x2e/0x30
[ 2176.474606]	[<ffffffff81156c32>] SyS_llseek+0x5b/0xaa
[ 2176.490895]	[<ffffffff8162ab2c>] sysenter_dispatch+0x7/0x21

Full log:
http://marc.merlins.org/tmp/btrfs_hang3.txt

After reboot, it's now hanging on this:
[  362.811392] INFO: task kworker/u8:0:6 blocked for more than 120 seconds.
[  362.831717]       Not tainted 3.15.5-amd64-i915-preempt-20140714cm1 #1
[  362.851516] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  362.875213] kworker/u8:0    D ffff88021265a800     0     6      2 0x00000000
[  362.896672] Workqueue: btrfs-flush_delalloc normal_work_helper
[  362.914260]  ffff8802148cbb60 0000000000000046 ffff8802148cbb30 ffff8802148cbfd8
[  362.936741]  ffff8802148c4150 00000000000141c0 ffff88021f3941c0 ffff8802148c4150
[  362.959195]  ffff8802148cbc00 0000000000000002 ffffffff810fdda8 ffff8802148cbb70
[  362.981602] Call Trace:
[  362.988972]  [<ffffffff810fdda8>] ? wait_on_page_read+0x3c/0x3c
[  363.006769]  [<ffffffff8161fa5e>] schedule+0x73/0x75
[  363.021704]  [<ffffffff8161fc03>] io_schedule+0x60/0x7a
[  363.037414]  [<ffffffff810fddb6>] sleep_on_page+0xe/0x12
[  363.053416]  [<ffffffff8161ff93>] __wait_on_bit_lock+0x46/0x8a
[  363.070980]  [<ffffffff810fde71>] __lock_page+0x69/0x6b
[  363.086722]  [<ffffffff810848d1>] ? autoremove_wake_function+0x34/0x34
[  363.106373]  [<ffffffff81242ab0>] lock_page+0x1e/0x21
[  363.121585]  [<ffffffff812465bb>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
[  363.148103]  [<ffffffff81246a19>] extent_writepages+0x4b/0x5c
[  363.166792]  [<ffffffff81230ce4>] ? btrfs_submit_direct+0x3f4/0x3f4
[  363.187074]  [<ffffffff810765ec>] ? get_parent_ip+0xc/0x3c
[  363.204975]  [<ffffffff8122f3fc>] btrfs_writepages+0x28/0x2a
[  363.223367]  [<ffffffff8110873d>] do_writepages+0x1e/0x2c
[  363.240980]  [<ffffffff810ff507>] __filemap_fdatawrite_range+0x55/0x57
[  363.261985]  [<ffffffff810fff50>] filemap_flush+0x1c/0x1e
[  363.279628]  [<ffffffff81231921>] btrfs_run_delalloc_work+0x32/0x69
[  363.299893]  [<ffffffff81252438>] normal_work_helper+0xfe/0x240
[  363.319143]  [<ffffffff81065e29>] process_one_work+0x195/0x2d2
[  363.338123]  [<ffffffff810660cb>] worker_thread+0x136/0x205
[  363.356348]  [<ffffffff81065f95>] ? process_scheduled_works+0x2f/0x2f
[  363.377203]  [<ffffffff8106b564>] kthread+0xae/0xb6
[  363.393396]  [<ffffffff8106b4b6>] ? __kthread_parkme+0x61/0x61
[  363.412469]  [<ffffffff81628d7c>] ret_from_fork+0x7c/0xb0
[  363.430228]  [<ffffffff8106b4b6>] ? __kthread_parkme+0x61/0x61

In the end, I went back to 3.14, and things work again.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
