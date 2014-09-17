Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52346 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622AbaIQPAF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 11:00:05 -0400
Date: Wed, 17 Sep 2014 08:00:02 -0700
From: Marc MERLIN <marc@merlins.org>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Subject: Re: NOCOW on VM images causes extreme btrfs slowdowns, memory leaks, and deadlocks
Message-ID: <20140917150002.GA12223@merlins.org>
References: <20140908015124.GA21441@merlins.org> <CAL3q7H70SGvWamdeuvF1id-pnP0o4PskgJMb7qE+CfGBB5vd1w@mail.gmail.com> <20140915001836.GU8530@merlins.org> <20140915175747.GZ8530@merlins.org> <20140916235742.GG8530@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140916235742.GG8530@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kernel: 3.16.2

On Tue, Sep 16, 2014 at 04:57:42PM -0700, Marc MERLIN wrote:
> I have a filtered log showing any system call that took more than 1 sec,
> that list is small:
> http://marc.merlins.org/tmp/btrfs_receive.log
> 
> Most of the time is apparently just death by a thousand cuts of many
> many system calls spent around receiving my virtual images that didn't
> change.
> 
> Here's the full strace log if you wish
> http://marc.merlins.org/tmp/btrfs_receive.log.xz

Ok, so while debugging this further, I found out that my VM images were
not NOCOW anymore (they used to be, but this must have been lost during a
restore).

Problems:
filefrag on my vbox file took all of my RAM and swap (32GB) and killed my
machine without being able to finish.

Moving the dir to +C and copying the vbox image from backup (having deleted
the fragmented one) took much longer to start than it should have
(destination had a filesize of 0 for a long time), but finished overnight.

The next morning (now), I see multiple of my CPUs deadlocked and a kworker
at the top of the list:
INFO: task kworker/u16:6:21880 blocked for more than 120 seconds.
      Tainted: G           O  3.16.2-amd64-i915-preempt-20140714 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u16:6   D 0000000000000000     0 21880      2 0x00000080
Workqueue: writeback bdi_writeback_workfn (flush-btrfs-2)
 ffff88012f87b9d0 0000000000000046 ffff88012f87b9a0 ffff88012f87bfd8
 ffff8800139c0490 00000000000140c0 ffff88041d2140c0 ffff8800139c0490
 ffff88012f87ba70 0000000000000002 ffffffff81106441 ffff88012f87b9e0
Call Trace:
 [<ffffffff81106441>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8163a889>] schedule+0x6e/0x70
 [<ffffffff8163aa2b>] io_schedule+0x60/0x7a
 [<ffffffff8110644f>] sleep_on_page+0xe/0x12
 [<ffffffff8163adbb>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff8110650a>] __lock_page+0x69/0x6b
 [<ffffffff81087ba4>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff8124aead>] lock_page+0x1e/0x21
 [<ffffffff8124ecb9>] extent_write_cache_pages.isra.16.constprop.31+0x10e/0x2c3
 [<ffffffff8124f2a2>] extent_writepages+0x4b/0x5c
 [<ffffffff81238e7c>] ? btrfs_submit_direct+0x3f9/0x3f9
 [<ffffffff81079658>] ? preempt_count_add+0x78/0x8d
 [<ffffffff81237568>] btrfs_writepages+0x28/0x2a
 [<ffffffff81110efe>] do_writepages+0x1e/0x2c
 [<ffffffff811814db>] __writeback_single_inode+0x7d/0x238
 [<ffffffff81182213>] writeback_sb_inodes+0x1eb/0x339
 [<ffffffff811823d5>] __writeback_inodes_wb+0x74/0xb7
 [<ffffffff81182550>] wb_writeback+0x138/0x293
 [<ffffffff81182b88>] bdi_writeback_workfn+0x19a/0x329
 [<ffffffff81068bf7>] process_one_work+0x195/0x2d2
 [<ffffffff81068fd8>] worker_thread+0x275/0x352
 [<ffffffff81068d63>] ? process_scheduled_works+0x2f/0x2f
 [<ffffffff8106e3a9>] kthread+0xae/0xb6
 [<ffffffff8106e2fb>] ? __kthread_parkme+0x61/0x61
 [<ffffffff8163d8fc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106e2fb>] ? __kthread_parkme+0x61/0x61

Hung tasks (sysrq-w) are here: 
http://marc.merlins.org/tmp/btrfs_hang-3.16.2.txt

I'm going to purge that fragmented vbox image from all my snapshots and reboot,
but clearly there are things that are going wrong.

Filipe, sorry for the initial bad problem report. While I can't exactly see
how it's related, it looks like btrfs receive of a heavily fragmented files
can take 12h or more.
It may not be that important to fix compared to the main problem heavy fragmentation
causes to btrfs still

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
