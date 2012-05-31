Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757891Ab2EaOiC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 May 2012 10:38:02 -0400
Date: Thu, 31 May 2012 10:36:46 -0400
From: Josef Bacik <josef@redhat.com>
To: Sebastian Jensen <gonx@overclocked.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Task blocked, happens almost daily during heavy disk I/O
Message-ID: <20120531143646.GB2080@localhost.localdomain>
References: <CAOjO-iUKPthHN7bS-Hra45Q59kdTCOGueOpDc-vb58Mwvyksww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAOjO-iUKPthHN7bS-Hra45Q59kdTCOGueOpDc-vb58Mwvyksww@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 31, 2012 at 02:58:29AM +0200, Sebastian Jensen wrote:
> Hey guys,
> (first of all, please include me in the re as I am not subscribed to the list)
> 
> For the past few months, I've had issues with my two BTRFS drives
> during heavy disk I/O, often resulting in my server not being
> connectable via SSH and I have to reboot it manually by pulling the
> power plug.
> This is very annoying, and I fear for the almost 4TB data I have
> laying around on these 2 drives being lost some day, because I have to
> restart an unsynced fs.
> 
> Today I managed to grab a dmesg output, sometimes I get a task
> blocked, and sometimes I get a kernel BUG error in dmesg, although the
> former tends to be the most common. I've yet to be unable to grab a
> readable screencap of the BUG reports, so I'll follow up with that as
> soon as I get one of those - both incidents block writing to the FS.
> 
> Here is the output (as you can see the system has been running for
> less than half a day):
> 
> [37590.706230] INFO: task flush-btrfs-1:390 blocked for more than 120 seconds.
> [37590.706249] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [37590.706261] flush-btrfs-1   D ffff8801d32ffa18     0   390      2 0x00000000
> [37590.706267]  ffff8801d32ff970 0000000000000046 ffff8801d510d800
> ffff8801d32fffd8
> [37590.706273]  ffff8801d32fffd8 ffff8801d32fffd8 ffff8801d6439800
> ffff8801d510d800
> [37590.706278]  ffff8801d32ff940 ffffffffa00c39e1 0000000000000000
> ffff880100000050
> [37590.706283] Call Trace:
> [37590.706311]  [<ffffffffa00c39e1>] ? run_delalloc_range+0x191/0x3a0 [btrfs]
> [37590.706317]  [<ffffffff8101c979>] ? read_tsc+0x9/0x20
> [37590.706322]  [<ffffffff8109d2b0>] ? ktime_get_ts+0xb0/0xf0
> [37590.706327]  [<ffffffff8110a380>] ? __lock_page+0x70/0x70
> [37590.706332]  [<ffffffff8145e2df>] schedule+0x3f/0x60
> [37590.706336]  [<ffffffff8145e38f>] io_schedule+0x8f/0xd0
> [37590.706339]  [<ffffffff8110a38e>] sleep_on_page+0xe/0x20
> [37590.706343]  [<ffffffff8145beab>] __wait_on_bit_lock+0x5b/0xc0
> [37590.706347]  [<ffffffff8110a377>] __lock_page+0x67/0x70
> [37590.706353]  [<ffffffff81072590>] ? autoremove_wake_function+0x40/0x40
> [37590.706369]  [<ffffffffa00daf51>]
> extent_write_cache_pages.isra.22.constprop.35+0x221/0x3f0 [btrfs]
> [37590.706385]  [<ffffffffa00db375>] extent_writepages+0x45/0x60 [btrfs]
> [37590.706400]  [<ffffffffa00bf890>] ? btrfs_writepage+0x70/0x70 [btrfs]
> [37590.706405]  [<ffffffff810720b4>] ? bit_waitqueue+0x14/0xc0
> [37590.706420]  [<ffffffffa00be918>] btrfs_writepages+0x28/0x30 [btrfs]
> [37590.706424]  [<ffffffff81115f52>] do_writepages+0x22/0x50
> [37590.706430]  [<ffffffff81194533>] writeback_single_inode+0x113/0x3b0
> [37590.706435]  [<ffffffff81194bf2>] writeback_sb_inodes+0x1d2/0x2b0
> [37590.706440]  [<ffffffff81194d6f>] __writeback_inodes_wb+0x9f/0xd0
> [37590.706445]  [<ffffffff81196203>] wb_writeback+0x313/0x340
> [37590.706448]  [<ffffffff81196cc8>] wb_do_writeback+0x268/0x270
> [37590.706452]  [<ffffffff81196d63>] bdi_writeback_thread+0x93/0x2d0
> [37590.706456]  [<ffffffff81196cd0>] ? wb_do_writeback+0x270/0x270
> [37590.706460]  [<ffffffff81071bd3>] kthread+0x93/0xa0
> [37590.706465]  [<ffffffff81461424>] kernel_thread_helper+0x4/0x10
> [37590.706470]  [<ffffffff81071b40>] ? kthread_freezable_should_stop+0x70/0x70
> [37590.706473]  [<ffffffff81461420>] ? gs_change+0x13/0x13
> 
> uname -r:
> 3.3.7-1-ARCH
> 

Try btrfs-next and see if you can reproduce.  Thanks,

Josef
