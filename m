Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f173.google.com ([209.85.128.173]:37680 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab3LNUag (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Dec 2013 15:30:36 -0500
Received: by mail-ve0-f173.google.com with SMTP id oz11so2352311veb.32
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Dec 2013 12:30:36 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 14 Dec 2013 21:30:36 +0100
Message-ID: <CAD_cGvFdrhwC2erqYTMjPRG7Y=69tsT2O+S-GHYK7+wpBwFSFQ@mail.gmail.com>
Subject: Blocket for more than 120 seconds
From: Hans-Kristian Bakke <hkbakke@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

During high disk loads, like backups combinded with lot of writers,
rsync at high speed locally or btrfs defrag I always get these
messages, and everything grinds to a halt on the btrfs filesystem:

[ 3123.062229] INFO: task rtorrent:8431 blocked for more than 120 seconds.
[ 3123.062251]       Not tainted 3.12.4 #1
[ 3123.062263] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3123.062284] rtorrent        D ffff88043fc12e80     0  8431   8429 0x00000000
[ 3123.062287]  ffff8804289d07b0 0000000000000082 ffffffff81610440
ffffffff810408ff
[ 3123.062290]  0000000000012e80 ffff88035f433fd8 ffff88035f433fd8
ffff8804289d07b0
[ 3123.062293]  0000000000000246 ffff88034bda8068 ffff8800ba5a39e8
ffff88035f433740
[ 3123.062295] Call Trace:
[ 3123.062302]  [<ffffffff810408ff>] ? detach_if_pending+0x18/0x6c
[ 3123.062331]  [<ffffffffa0193545>] ?
wait_current_trans.isra.30+0xbc/0x117 [btrfs]
[ 3123.062334]  [<ffffffff810515a1>] ? wake_up_atomic_t+0x22/0x22
[ 3123.062346]  [<ffffffffa0194ef4>] ? start_transaction+0x1d1/0x46b [btrfs]
[ 3123.062359]  [<ffffffffa0199537>] ? btrfs_dirty_inode+0x25/0xa6 [btrfs]
[ 3123.062362]  [<ffffffff8111afe2>] ? file_update_time+0x95/0xb5
[ 3123.062374]  [<ffffffffa01a08a0>] ? btrfs_page_mkwrite+0x68/0x2bc [btrfs]
[ 3123.062377]  [<ffffffff810c3e06>] ? filemap_fault+0x1fa/0x36e
[ 3123.062379]  [<ffffffff810dec6f>] ? __do_fault+0x15b/0x360
[ 3123.062382]  [<ffffffff810e0ffe>] ? handle_mm_fault+0x22c/0x8aa
[ 3123.062385]  [<ffffffff812c6445>] ? dev_hard_start_xmit+0x271/0x3ec
[ 3123.062388]  [<ffffffff81380c2a>] ? __do_page_fault+0x38d/0x3d7
[ 3123.062393]  [<ffffffffa04eeb2e>] ? br_dev_queue_push_xmit+0x9d/0xa1 [bridge]
[ 3123.062397]  [<ffffffffa04ed4b3>] ? br_dev_xmit+0x1c3/0x1e0 [bridge]
[ 3123.062400]  [<ffffffff81060eaa>] ? update_group_power+0xb7/0x1b9
[ 3123.062403]  [<ffffffff811c3456>] ? cpumask_next_and+0x2a/0x3a
[ 3123.062405]  [<ffffffff8106114f>] ? update_sd_lb_stats+0x1a3/0x35a
[ 3123.062407]  [<ffffffff8137e172>] ? page_fault+0x22/0x30
[ 3123.062410]  [<ffffffff811ccc80>] ? copy_user_generic_string+0x30/0x40
[ 3123.062413]  [<ffffffff811d101b>] ? memcpy_toiovec+0x2f/0x5c
[ 3123.062417]  [<ffffffff812bcc5a>] ? skb_copy_datagram_iovec+0x76/0x20d
[ 3123.062419]  [<ffffffff8137dc08>] ? _raw_spin_lock_bh+0xe/0x1c
[ 3123.062422]  [<ffffffff81059ad3>] ? should_resched+0x5/0x23
[ 3123.062426]  [<ffffffff812fa113>] ? tcp_recvmsg+0x72e/0xaa3
[ 3123.062428]  [<ffffffff810615dc>] ? load_balance+0x12c/0x6b5
[ 3123.062431]  [<ffffffff813170b1>] ? inet_recvmsg+0x5a/0x6e
[ 3123.062434]  [<ffffffff810015dc>] ? __switch_to+0x1b1/0x3c4
[ 3123.062437]  [<ffffffff812b32d9>] ? sock_recvmsg+0x54/0x71
[ 3123.062440]  [<ffffffff81139d43>] ? ep_item_poll+0x16/0x1b
[ 3123.062442]  [<ffffffff81139e6f>] ? ep_pm_stay_awake+0xf/0xf
[ 3123.062445]  [<ffffffff8111c81a>] ? fget_light+0x6b/0x7c
[ 3123.062447]  [<ffffffff812b33c0>] ? SYSC_recvfrom+0xca/0x12e
[ 3123.062449]  [<ffffffff8105c309>] ? try_to_wake_up+0x190/0x190
[ 3123.062452]  [<ffffffff81109189>] ? fput+0xf/0x9d
[ 3123.062454]  [<ffffffff8113b4b8>] ? SyS_epoll_wait+0x9c/0xc7
[ 3123.062457]  [<ffffffff81382d62>] ? system_call_fastpath+0x16/0x1b
[ 3123.062462] INFO: task kworker/u16:0:21158 blocked for more than 120 seconds.
[ 3123.062491]       Not tainted 3.12.4 #1
[ 3123.062513] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3123.062557] kworker/u16:0   D ffff88043fcd2e80     0 21158      2 0x00000000
[ 3123.062561] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-1)
[ 3123.062562]  ffff88026a163830 0000000000000046 ffff88042f0c67b0
0000001000011210
[ 3123.062565]  0000000000012e80 ffff88027067bfd8 ffff88027067bfd8
ffff88026a163830
[ 3123.062567]  0000000000000246 ffff88034bda8068 ffff8800ba5a39e8
ffff88027067b750
[ 3123.062569] Call Trace:
[ 3123.062581]  [<ffffffffa0193545>] ?
wait_current_trans.isra.30+0xbc/0x117 [btrfs]
[ 3123.062584]  [<ffffffff810515a1>] ? wake_up_atomic_t+0x22/0x22
[ 3123.062596]  [<ffffffffa0194ef4>] ? start_transaction+0x1d1/0x46b [btrfs]
[ 3123.062608]  [<ffffffffa019a114>] ? run_delalloc_nocow+0x9c/0x752 [btrfs]
[ 3123.062621]  [<ffffffffa019a82e>] ? run_delalloc_range+0x64/0x333 [btrfs]
[ 3123.062635]  [<ffffffffa01a936c>] ? free_extent_state+0x12/0x21 [btrfs]
[ 3123.062648]  [<ffffffffa01ac32f>] ? __extent_writepage+0x1e5/0x62a [btrfs]
[ 3123.062659]  [<ffffffffa018f5c8>] ? btree_submit_bio_hook+0x7e/0xd7 [btrfs]
[ 3123.062662]  [<ffffffff810c20d1>] ? find_get_pages_tag+0x66/0x121
[ 3123.062675]  [<ffffffffa01ac8be>] ?
extent_write_cache_pages.isra.23.constprop.47+0x14a/0x255 [btrfs]
[ 3123.062688]  [<ffffffffa01acc5c>] ? extent_writepages+0x49/0x60 [btrfs]
[ 3123.062700]  [<ffffffffa0198017>] ? btrfs_submit_direct+0x412/0x412 [btrfs]
[ 3123.062703]  [<ffffffff8112660b>] ? __writeback_single_inode+0x6d/0x1e8
[ 3123.062705]  [<ffffffff8112746a>] ? writeback_sb_inodes+0x1f0/0x322
[ 3123.062707]  [<ffffffff81127605>] ? __writeback_inodes_wb+0x69/0xab
[ 3123.062709]  [<ffffffff8112777d>] ? wb_writeback+0x136/0x292
[ 3123.062712]  [<ffffffff810fbffb>] ? __cache_free.isra.46+0x178/0x187
[ 3123.062714]  [<ffffffff81127a6d>] ? bdi_writeback_workfn+0xc1/0x2fe
[ 3123.062716]  [<ffffffff8105a469>] ? resched_task+0x35/0x5d
[ 3123.062718]  [<ffffffff8105a83d>] ? ttwu_do_wakeup+0xf/0xc1
[ 3123.062721]  [<ffffffff8105c2f7>] ? try_to_wake_up+0x17e/0x190
[ 3123.062723]  [<ffffffff8104bca7>] ? process_one_work+0x191/0x294
[ 3123.062725]  [<ffffffff8104c159>] ? worker_thread+0x121/0x1e7
[ 3123.062726]  [<ffffffff8104c038>] ? rescuer_thread+0x269/0x269
[ 3123.062729]  [<ffffffff81050c01>] ? kthread+0x81/0x89
[ 3123.062731]  [<ffffffff81050b80>] ? __kthread_parkme+0x5d/0x5d
[ 3123.062733]  [<ffffffff81382cbc>] ? ret_from_fork+0x7c/0xb0
[ 3123.062736]  [<ffffffff81050b80>] ? __kthread_parkme+0x5d/0x5d

These are repeated for several processes trying to do something.

I have had no data  losses, only availability issues during high load.
The surest way to trigger these messages is for me to start a copy
from my other local array while doing something like heavy torrenting
at the same time.

Smartd have not reported any disk issues and iostat -d only indicates
a lot of disk activity at the limits of the drives with no drive
seeminlig behaving any different than others (until the error hit,
where the activity goes to zero)

Mount options is default kernel 3.12.4 with compress=lzo. I have 16 GB
ECC RAM and a Quad core Xeon CPU.

I am running this on a 8 disk WD SE 4TB btrfs RAID10 system with a
single snapshot.

I have no expectations of btrfs delivering stellar performance during
heavy IOPs load on ordinary 7200rpm drives, but I do expect it to just
be slow until the load is removed, not more or less completely stall
the entire server.

The filesystem have used about 26TB of the available 29TB (real
available data), and some of the files on it are heavily fragmented
(around 100 000 extents at about 25GB)

Regards,

Hans-Kristian Bakke
