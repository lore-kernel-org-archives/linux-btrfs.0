From: Josef Bacik <josef@redhat.com>
Subject: Re: [RFC] remove delalloc accounting for
	__btrfs_remove_ordered_extent
Date: Wed, 24 Feb 2010 11:09:33 -0500
Message-ID: <20100224160932.GD2257@localhost.localdomain>
References: <20100224071205.GA14237@sli10-desk.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Shaohua Li <shaohua.li@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100224071205.GA14237@sli10-desk.sh.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 24, 2010 at 03:12:05PM +0800, Shaohua Li wrote:
> I got below oops when doing file write with mount option max_extent=1M
> It appears the accouting is already done in set/clear/split/merge hooks and
> I don't see reason why we need do accouting in __btrfs_remove_ordered_extent
> again. Below patch makes my test work but please double check.
> 
> [  185.776309] Pid: 3368, comm: btrfs-endio-wri Not tainted 2.6.33-rc8-00165-g446ce07 #668 0M017G/Studio Slim 540s
> [  185.776353] RIP: 0010:[<ffffffffa000ca13>]  [<ffffffffa000ca13>] btrfs_unreserve_metadata_for_delalloc+0xc0/0x101 [btrfs]
> [  185.776427] RSP: 0018:ffff88012614bbd0  EFLAGS: 00010286
> [  185.776460] RAX: 00000000ffffffff RBX: ffff88012771c960 RCX: 0000000000000000
> [  185.776496] RDX: ffffffffa000c9dd RSI: ffff8801295d3800 RDI: 0000000000000001
> [  185.776532] RBP: ffff88012614bc00 R08: ffff88012614bb90 R09: 0000000000000000
> [  185.776568] R10: ffff88012614bbc0 R11: 0000000000000043 R12: ffff88012990a9b8
> [  185.776603] R13: 000000000001a000 R14: ffff88012990a900 R15: ffff88012771c950
> [  185.776640] FS:  0000000000000000(0000) GS:ffff880005880000(0000) knlGS:0000000000000000
> [  185.776678] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  185.776711] CR2: 0000003de9123f40 CR3: 00000001249b6000 CR4: 00000000000406e0
> [  185.776747] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  185.776795] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  185.776845] Process btrfs-endio-wri (pid: 3368, threadinfo ffff88012614a000, task ffff880128b34240)
> [  185.776910] Stack:
> [  185.776946]  ffff88012614bbf0 ffff88012771c960 ffff8801249d4840 ffff88012771c7c0
> [  185.777050] <0> ffff88012771c950 0000000100000000 ffff88012614bc30 ffffffffa003559e
> [  185.777203] <0> 0000000000000001 ffff8801249d4840 ffff88012771c960 0000000100000000
> [  185.777388] Call Trace:
> [  185.777438]  [<ffffffffa003559e>] __btrfs_remove_ordered_extent+0x72/0x126 [btrfs]
> [  185.777511]  [<ffffffffa003593f>] btrfs_ordered_update_i_size+0x2ed/0x33a [btrfs]
> [  185.777585]  [<ffffffffa0028c9e>] btrfs_finish_ordered_io+0x196/0x1d8 [btrfs]
> [  185.777636]  [<ffffffff810d39d1>] ? test_clear_page_writeback+0xfa/0x10c
> [  185.777695]  [<ffffffffa0028cfa>] btrfs_writepage_end_io_hook+0x1a/0x1c [btrfs]
> [  185.777765]  [<ffffffffa0039ef8>] end_bio_extent_writepage+0xae/0x159 [btrfs]
> [  185.777815]  [<ffffffff81130e56>] bio_endio+0x2b/0x2d
> [  185.777868]  [<ffffffffa001bcea>] end_workqueue_fn+0x111/0x120 [btrfs]
> [  185.777923]  [<ffffffffa00427e5>] worker_loop+0x1b9/0x547 [btrfs]
> [  185.777977]  [<ffffffffa004262c>] ? worker_loop+0x0/0x547 [btrfs]
> [  185.778024]  [<ffffffff8107f9b9>] kthread+0x7f/0x87
> [  185.778071]  [<ffffffff8102f954>] kernel_thread_helper+0x4/0x10
> [  185.778119]  [<ffffffff8105a8e1>] ? finish_task_switch+0x50/0xc2
> [  185.778166]  [<ffffffff8161a5a9>] ? _raw_spin_unlock_irq+0x1b/0x36
> [  185.778212]  [<ffffffff8161ae6d>] ? restore_args+0x0/0x30
> [  185.778257]  [<ffffffff8107f93a>] ? kthread+0x0/0x87
> [  185.778300]  [<ffffffff8102f950>] ? kernel_thread_helper+0x0/0x10
> [  185.778345] Code: 3b 43 f8 7f 12 4c 89 ff e8 cf db 60 e1 4c 89 e7 e8 c7 db 60 e1 eb 46 4c 89 ff e8 bd db 60 e1 8b 43 f4 ff c8 89 43 f4 85 c0 79 04 <0f> 0b eb fe 49 8b 46 48 4c 39 e8 73 0c 49 c7 46 48 00 00 00 00
> [  185.779620] RIP  [<ffffffffa000ca13>] btrfs_unreserve_metadata_for_delalloc+0xc0/0x101 [btrfs]
> [  185.779710]  RSP <ffff88012614bbd0>
> [  185.779765] ---[ end trace daf2ed048f53f7f0 ]---
> [  185.779812] note: btrfs-endio-wri[3368] exited with preempt_count
> 

How do you reproduce this problem?  I've been trying to but it's not reproducing
for me.  Thanks,

Josef
