Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.seidel.me ([130.255.72.11]:59396 "EHLO mx.seidel.me"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbaGWGq6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 02:46:58 -0400
Content-Type: multipart/mixed; boundary="Apple-Mail=_EBC593D1-4B0B-4994-8C4F-3B339A22EC2A"
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: Blocked tasks on 3.15.1
From: Felix Seidel <felix@seidel.me>
In-Reply-To: <CAGfcS_==i3_6AeqBKefJgQC+nuGerwKxd5uNAhvu0SZZdZwYKA@mail.gmail.com>
Date: Wed, 23 Jul 2014 08:38:03 +0200
Cc: Chris Mason <clm@fb.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <D882015C-3772-468C-9FD5-E71E3F424B0E@seidel.me>
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com> <53C7CD0F.7070603@fb.com> <CAPoQQ-1PcyPgJ4eoicP4xM8RShA2qo77fM7kqU5eKKUM2cmuUQ@mail.gmail.com> <1745216.hDa4tC2HJJ@merkaba> <53CE7ACF.7070109@fb.com> <CAGfcS_==i3_6AeqBKefJgQC+nuGerwKxd5uNAhvu0SZZdZwYKA@mail.gmail.com>
To: Rich Freeman <r-btrfs@thefreemanclan.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_EBC593D1-4B0B-4994-8C4F-3B339A22EC2A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

On 23 Jul 2014, at 03:06, Rich Freeman <r-btrfs@thefreemanclan.net> =
wrote:
> I disabled lzo and haven't had problems since.  I'm now running
> on mainline without issue, but I think I did see the hang on mainline
> when I tried enabling lzo again briefly.

Can confirm. I=92m running mainline 3.16rc5 and was experiencing =
deadlocks
when having LZO enabled.=20
Disabled it, now all seems ok.

Using btrfs RAID1 -> dm-crypt -> SATA.

I=92ve attached some more dmesg =93blocked=94 messages using kernel =
versions
3.15.5, 3.14.6 and 3.16rc5 just in case it helps anyone.


--Apple-Mail=_EBC593D1-4B0B-4994-8C4F-3B339A22EC2A
Content-Disposition: attachment;
	filename=dmesg.txt
Content-Type: text/plain;
	name="dmesg.txt"
Content-Transfer-Encoding: quoted-printable

Jul 18 23:36:58 nas kernel: INFO: task sudo:1214 blocked for more than =
120 seconds.
Jul 18 23:36:58 nas kernel:       Tainted: G           O  3.15.5-2-ARCH =
#1
Jul 18 23:36:58 nas kernel: "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 18 23:36:58 nas kernel: sudo            D 0000000000000000     0  =
1214      1 0x00000004
Jul 18 23:36:58 nas kernel:  ffff88001d0ebc20 0000000000000086 =
ffff88002cca5bb0 0000000000014700
Jul 18 23:36:58 nas kernel:  ffff88001d0ebfd8 0000000000014700 =
ffff88002cca5bb0 0000000000000000
Jul 18 23:36:58 nas kernel:  ffff880028ee4000 0000000000000003 =
00000000284e0d53 0000000000000002
Jul 18 23:36:58 nas kernel: Call Trace:
Jul 18 23:36:58 nas kernel:  [<ffffffff815110dc>] ? =
__do_page_fault+0x2ec/0x600
Jul 18 23:36:58 nas kernel:  [<ffffffff81509fa9>] schedule+0x29/0x70
Jul 18 23:36:58 nas kernel:  [<ffffffff8150a426>] =
schedule_preempt_disabled+0x16/0x20
Jul 18 23:36:58 nas kernel:  [<ffffffff8150bda5>] =
__mutex_lock_slowpath+0xe5/0x230
Jul 18 23:36:58 nas kernel:  [<ffffffff8150bf07>] mutex_lock+0x17/0x30
Jul 18 23:36:58 nas kernel:  [<ffffffff811bfa24>] lookup_slow+0x34/0xc0
Jul 18 23:36:58 nas kernel:  [<ffffffff811c1b73>] =
path_lookupat+0x723/0x880
Jul 18 23:36:58 nas kernel:  [<ffffffff8114f111>] ? =
release_pages+0xc1/0x280
Jul 18 23:36:58 nas kernel:  [<ffffffff811bfd97>] ? =
getname_flags+0x37/0x130
Jul 18 23:36:58 nas kernel:  [<ffffffff811c1cf6>] =
filename_lookup.isra.30+0x26/0x80
Jul 18 23:36:58 nas kernel:  [<ffffffff811c4fd7>] =
user_path_at_empty+0x67/0xd0
Jul 18 23:36:58 nas kernel:  [<ffffffff81172b52>] ? =
unmap_region+0xe2/0x130
Jul 18 23:36:58 nas kernel:  [<ffffffff811c5051>] user_path_at+0x11/0x20
Jul 18 23:36:58 nas kernel:  [<ffffffff811b979a>] vfs_fstatat+0x6a/0xd0
Jul 18 23:36:58 nas kernel:  [<ffffffff811b981b>] vfs_stat+0x1b/0x20
Jul 18 23:36:58 nas kernel:  [<ffffffff811b9df9>] SyS_newstat+0x29/0x60
Jul 18 23:36:58 nas kernel:  [<ffffffff8117501c>] ? vm_munmap+0x4c/0x60
Jul 18 23:36:58 nas kernel:  [<ffffffff81175f92>] ? SyS_munmap+0x22/0x30
Jul 18 23:36:58 nas kernel:  [<ffffffff81515fa9>] =
system_call_fastpath+0x16/0x1b
---
Jul 19 18:34:17 nas kernel: INFO: task rsync:4900 blocked for more than =
120 seconds.
Jul 19 18:34:17 nas kernel:       Tainted: G           O  3.15.5-2-ARCH =
#1
Jul 19 18:34:17 nas kernel: "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 19 18:34:17 nas kernel: rsync           D 0000000000000000     0  =
4900   4899 0x00000000
Jul 19 18:34:17 nas kernel:  ffff880005947c20 0000000000000082 =
ffff880034aa4750 0000000000014700
Jul 19 18:34:17 nas kernel:  ffff880005947fd8 0000000000014700 =
ffff880034aa4750 ffffffff810a5995
Jul 19 18:34:17 nas kernel:  ffff88011fc14700 ffff8800dd828a30 =
ffff8800cece6a00 ffff880005947bd8
Jul 19 18:34:17 nas kernel: Call Trace:
Jul 19 18:34:17 nas kernel:  [<ffffffff810a5995>] ? =
set_next_entity+0x95/0xb0
Jul 19 18:34:17 nas kernel:  [<ffffffff810ac0be>] ? =
pick_next_task_fair+0x46e/0x550
Jul 19 18:34:17 nas kernel:  [<ffffffff810136c1>] ? =
__switch_to+0x1f1/0x540
Jul 19 18:34:17 nas kernel:  [<ffffffff81509fa9>] schedule+0x29/0x70
Jul 19 18:34:17 nas kernel:  [<ffffffff8150a426>] =
schedule_preempt_disabled+0x16/0x20
Jul 19 18:34:17 nas kernel:  [<ffffffff8150bda5>] =
__mutex_lock_slowpath+0xe5/0x230
Jul 19 18:34:17 nas kernel:  [<ffffffff8150bf07>] mutex_lock+0x17/0x30
Jul 19 18:34:17 nas kernel:  [<ffffffff811bfa24>] lookup_slow+0x34/0xc0
Jul 19 18:34:17 nas kernel:  [<ffffffff811c1b73>] =
path_lookupat+0x723/0x880
Jul 19 18:34:17 nas kernel:  [<ffffffff8150a2bf>] ? =
io_schedule+0xbf/0xf0
Jul 19 18:34:17 nas kernel:  [<ffffffff8150a7d1>] ? =
__wait_on_bit_lock+0x91/0xb0
Jul 19 18:34:17 nas kernel:  [<ffffffff811bfd97>] ? =
getname_flags+0x37/0x130
Jul 19 18:34:17 nas kernel:  [<ffffffff811c1cf6>] =
filename_lookup.isra.30+0x26/0x80
Jul 19 18:34:17 nas kernel:  [<ffffffff811c4fd7>] =
user_path_at_empty+0x67/0xd0
Jul 19 18:34:17 nas kernel:  [<ffffffff811c5051>] user_path_at+0x11/0x20
Jul 19 18:34:17 nas kernel:  [<ffffffff811b979a>] vfs_fstatat+0x6a/0xd0
Jul 19 18:34:17 nas kernel:  [<ffffffff811d4414>] ? mntput+0x24/0x40
Jul 19 18:34:17 nas kernel:  [<ffffffff811b983e>] vfs_lstat+0x1e/0x20
Jul 19 18:34:17 nas kernel:  [<ffffffff811b9e59>] SyS_newlstat+0x29/0x60
Jul 19 18:34:17 nas kernel:  [<ffffffff8108a3c4>] ? =
task_work_run+0xa4/0xe0
Jul 19 18:34:17 nas kernel:  [<ffffffff8150e939>] ? =
do_device_not_available+0x19/0x20
Jul 19 18:34:17 nas kernel:  [<ffffffff8151760e>] ? =
device_not_available+0x1e/0x30
Jul 19 18:34:17 nas kernel:  [<ffffffff81515fa9>] =
system_call_fastpath+0x16/0x1b
---
Jul 19 23:58:39 nas kernel: INFO: task rsync:3407 blocked for more than =
120 seconds.
Jul 19 23:58:39 nas kernel:       Not tainted 3.14.6-1-ARCH #1
Jul 19 23:58:39 nas kernel: "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 19 23:58:39 nas kernel: rsync           D ffff8800cd9e3110     0  =
3407   3405 0x00000000
Jul 19 23:58:39 nas kernel:  ffff8800a2f21bc0 0000000000000086 =
ffff8800a2f21b10 ffff8800cd9e3110
Jul 19 23:58:39 nas kernel:  00000000000146c0 ffff8800a2f21fd8 =
00000000000146c0 ffff8800cd9e3110
Jul 19 23:58:39 nas kernel:  00000000ffffffef ffff8800dd51bf60 =
ffffffffa02f4c5c ffff8800a2f21b28
Jul 19 23:58:39 nas kernel: Call Trace:
Jul 19 23:58:39 nas kernel:  [<ffffffffa02f4c5c>] ? =
__set_extent_bit+0x45c/0x550 [btrfs]
Jul 19 23:58:39 nas kernel:  [<ffffffffa02f4263>] ? =
free_extent_state+0x43/0xc0 [btrfs]
Jul 19 23:58:39 nas kernel:  [<ffffffffa02f4c5c>] ? =
__set_extent_bit+0x45c/0x550 [btrfs]
Jul 19 23:58:39 nas kernel:  [<ffffffff8150bb09>] schedule+0x29/0x70
Jul 19 23:58:39 nas kernel:  [<ffffffffa02f5b72>] =
lock_extent_bits+0x152/0x1e0 [btrfs]
Jul 19 23:58:39 nas kernel:  [<ffffffff810b3ec0>] ? =
__wake_up_sync+0x20/0x20
Jul 19 23:58:39 nas kernel:  [<ffffffffa02e39b9>] =
btrfs_evict_inode+0x139/0x520 [btrfs]
Jul 19 23:58:39 nas kernel:  [<ffffffff811d5ac0>] evict+0xb0/0x1c0
Jul 19 23:58:39 nas kernel:  [<ffffffff811d6375>] iput+0xf5/0x1a0
Jul 19 23:58:39 nas kernel:  [<ffffffff811d1bc0>] =
dentry_kill+0x240/0x290
Jul 19 23:58:39 nas kernel:  [<ffffffff811d1c8b>] dput+0x7b/0x120
Jul 19 23:58:39 nas kernel:  [<ffffffff811cc0da>] =
SyS_renameat+0x2ca/0x400
Jul 19 23:58:39 nas kernel:  [<ffffffff811bd001>] ? =
__sb_end_write+0x31/0x60
Jul 19 23:58:39 nas kernel:  [<ffffffff811d9111>] ? =
mnt_drop_write+0x31/0x50
Jul 19 23:58:39 nas kernel:  [<ffffffff811b81c3>] ? =
chmod_common+0xe3/0x160
Jul 19 23:58:39 nas kernel:  [<ffffffff811da334>] ? mntput+0x24/0x40
Jul 19 23:58:39 nas kernel:  [<ffffffff811c478e>] ? path_put+0x1e/0x30
Jul 19 23:58:39 nas kernel:  [<ffffffff811b96e2>] ? =
SyS_fchmodat+0x62/0xc0
Jul 19 23:58:39 nas kernel:  [<ffffffff811cc22b>] SyS_rename+0x1b/0x20
Jul 19 23:58:39 nas kernel:  [<ffffffff81517b29>] =
system_call_fastpath+0x16/0x1b
---
Jul 21 22:31:02 nas kernel: INFO: task kworker/u8:1:12866 blocked for =
more than 120 seconds.
Jul 21 22:31:02 nas kernel:       Not tainted 3.16.0-1-mainline #1
Jul 21 22:31:02 nas kernel: "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 21 22:31:02 nas kernel: kworker/u8:1    D 0000000000000000     0 =
12866      2 0x00000000
Jul 21 22:31:02 nas kernel: Workqueue: btrfs-delalloc normal_work_helper =
[btrfs]
Jul 21 22:31:02 nas kernel:  ffff88010760f5d8 0000000000000046 =
ffff8800d293bd20 00000000000145c0
Jul 21 22:31:02 nas kernel:  ffff88010760ffd8 00000000000145c0 =
ffff8800d293bd20 0000000000000001
Jul 21 22:31:02 nas kernel:  ffffffff810b6c30 ffff88010760f5c8 =
ffff88010d4bc2e8 ffff8800a45b4000
Jul 21 22:31:02 nas kernel: Call Trace:
Jul 21 22:31:02 nas kernel:  [<ffffffff810b6c30>] ? =
__wake_up_sync+0x20/0x20
Jul 21 22:31:02 nas kernel:  [<ffffffffa0357406>] ? =
btrfs_bio_counter_dec+0x26/0x60 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffffa0312665>] ? =
btrfs_map_bio+0x4b5/0x520 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffff8114b750>] ? =
filemap_fdatawait+0x30/0x30
Jul 21 22:31:02 nas kernel:  [<ffffffff8151e919>] schedule+0x29/0x70
Jul 21 22:31:02 nas kernel:  [<ffffffff8151ebf4>] io_schedule+0x94/0xf0
Jul 21 22:31:02 nas kernel:  [<ffffffff8114b75e>] sleep_on_page+0xe/0x20
Jul 21 22:31:02 nas kernel:  [<ffffffff8151f014>] =
__wait_on_bit+0x64/0x90
Jul 21 22:31:02 nas kernel:  [<ffffffff8114b509>] =
wait_on_page_bit+0x89/0xa0
Jul 21 22:31:02 nas kernel:  [<ffffffff810b6c70>] ? =
autoremove_wake_function+0x40/0x40
Jul 21 22:31:02 nas kernel:  [<ffffffffa030943a>] =
read_extent_buffer_pages+0x30a/0x350 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffffa02dc1e0>] ? =
free_root_pointers+0x60/0x60 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffffa02ddd01>] =
btree_read_extent_buffer_pages.constprop.45+0xb1/0x110 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffffa02de378>] =
read_tree_block+0x38/0x60 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffffa02be770>] =
read_block_for_search.isra.29+0x160/0x3b0 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffffa02c429a>] =
btrfs_next_old_leaf+0x26a/0x460 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffffa02c44a0>] =
btrfs_next_leaf+0x10/0x20 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffffa030e924>] =
find_free_dev_extent+0xc4/0x360 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffffa030ed8a>] =
__btrfs_alloc_chunk+0x1ca/0x810 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffffa03119b4>] =
btrfs_alloc_chunk+0x34/0x40 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffffa02cc82e>] =
do_chunk_alloc+0x1de/0x3d0 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffffa02d1e65>] =
find_free_extent+0xbd5/0xe00 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffffa02d2268>] =
btrfs_reserve_extent+0x68/0x160 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffffa02ec36b>] =
cow_file_range+0x13b/0x430 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffffa02ed715>] =
submit_compressed_extents+0x215/0x4a0 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffffa02ed9a0>] ? =
submit_compressed_extents+0x4a0/0x4a0 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffffa02eda26>] =
async_cow_submit+0x86/0x90 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffffa0316735>] =
normal_work_helper+0x205/0x350 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffff8108afd8>] =
process_one_work+0x168/0x450
Jul 21 22:31:02 nas kernel:  [<ffffffff8108b79c>] =
worker_thread+0x1fc/0x550
Jul 21 22:31:02 nas kernel:  [<ffffffff8108b5a0>] ? =
init_pwq.part.22+0x10/0x10
Jul 21 22:31:02 nas kernel:  [<ffffffff81091d1a>] kthread+0xea/0x100
Jul 21 22:31:02 nas kernel:  [<ffffffff81091c30>] ? =
kthread_create_on_node+0x1b0/0x1b0
Jul 21 22:31:02 nas kernel:  [<ffffffff8152277c>] =
ret_from_fork+0x7c/0xb0
Jul 21 22:31:02 nas kernel:  [<ffffffff81091c30>] ? =
kthread_create_on_node+0x1b0/0x1b0
---
Jul 21 22:31:02 nas kernel: INFO: task afpd:15988 blocked for more than =
120 seconds.
Jul 21 22:31:02 nas kernel:       Not tainted 3.16.0-1-mainline #1
Jul 21 22:31:02 nas kernel: "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 21 22:31:02 nas kernel: afpd            D 0000000000000001     0 =
15988  11686 0x00000004
Jul 21 22:31:02 nas kernel:  ffff88010d083c48 0000000000000086 =
ffff8800d8d88000 00000000000145c0
Jul 21 22:31:02 nas kernel:  ffff88010d083fd8 00000000000145c0 =
ffff8800d8d88000 ffff8800a4505000
Jul 21 22:31:02 nas kernel:  0000000000000002 00000000000a6fff =
ffff88010d083c28 ffffffffa02ed342
Jul 21 22:31:02 nas kernel: Call Trace:
Jul 21 22:31:02 nas kernel:  [<ffffffffa02ed342>] ? =
run_delalloc_range+0x192/0x350 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffff8114b750>] ? =
filemap_fdatawait+0x30/0x30
Jul 21 22:31:02 nas kernel:  [<ffffffff8151e919>] schedule+0x29/0x70
Jul 21 22:31:02 nas kernel:  [<ffffffff8151ebf4>] io_schedule+0x94/0xf0
Jul 21 22:31:02 nas kernel:  [<ffffffff8114b75e>] sleep_on_page+0xe/0x20
Jul 21 22:31:02 nas kernel:  [<ffffffff8151f138>] =
__wait_on_bit_lock+0x48/0xb0
Jul 21 22:31:02 nas kernel:  [<ffffffff8114b8b8>] __lock_page+0x78/0x90
Jul 21 22:31:02 nas kernel:  [<ffffffff810b6c70>] ? =
autoremove_wake_function+0x40/0x40
Jul 21 22:31:02 nas kernel:  [<ffffffffa0305a18>] =
extent_write_cache_pages.isra.28.constprop.43+0x2d8/0x410 [btr
Jul 21 22:31:02 nas kernel:  [<ffffffffa0307cec>] =
extent_writepages+0x5c/0x90 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffffa02e9780>] ? =
btrfs_direct_IO+0x350/0x350 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffffa02e8518>] =
btrfs_writepages+0x28/0x30 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffff8115913e>] =
do_writepages+0x1e/0x30
Jul 21 22:31:02 nas kernel:  [<ffffffff8114d22d>] =
__filemap_fdatawrite_range+0x5d/0x80
Jul 21 22:31:02 nas kernel:  [<ffffffff8114d313>] =
filemap_fdatawrite_range+0x13/0x20
Jul 21 22:31:02 nas kernel:  [<ffffffffa02f68ad>] =
btrfs_sync_file+0x5d/0x320 [btrfs]
Jul 21 22:31:02 nas kernel:  [<ffffffff811f1e11>] do_fsync+0x51/0x80
Jul 21 22:31:02 nas kernel:  [<ffffffff811f20c0>] SyS_fsync+0x10/0x20
Jul 21 22:31:02 nas kernel:  [<ffffffff81522829>] =
system_call_fastpath+0x16/0x1b
---
Jul 21 22:33:02 nas kernel: INFO: task btrfs-transacti:921 blocked for =
more than 120 seconds.
Jul 21 22:33:02 nas kernel:       Not tainted 3.16.0-1-mainline #1
Jul 21 22:33:02 nas kernel: "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 21 22:33:02 nas kernel: btrfs-transacti D 0000000000000000     0   =
921      2 0x00000000
Jul 21 22:33:02 nas kernel:  ffff8800d27dbe00 0000000000000046 =
ffff8800d28d5bb0 00000000000145c0
Jul 21 22:33:02 nas kernel:  ffff8800d27dbfd8 00000000000145c0 =
ffff8800d28d5bb0 ffff880101f72480
Jul 21 22:33:02 nas kernel:  ffffffffa033b5a6 ffff8800d27dbda8 =
ffffffffa033b864 ffff8800d18f95a0
Jul 21 22:33:02 nas kernel: Call Trace:
Jul 21 22:33:02 nas kernel:  [<ffffffffa033b5a6>] ? =
btrfs_release_delayed_inode+0x46/0x60 [btrfs]
Jul 21 22:33:02 nas kernel:  [<ffffffffa033b864>] ? =
__btrfs_update_delayed_inode+0x1a4/0x210 [btrfs]
Jul 21 22:33:02 nas kernel:  [<ffffffff811a570a>] ? =
kmem_cache_alloc+0x16a/0x170
Jul 21 22:33:02 nas kernel:  [<ffffffffa02bb89a>] ? =
btrfs_alloc_path+0x1a/0x20 [btrfs]
Jul 21 22:33:02 nas kernel:  [<ffffffffa034344a>] ? =
btrfs_scrub_pause+0xea/0x110 [btrfs]
Jul 21 22:33:02 nas kernel:  [<ffffffff8151e919>] schedule+0x29/0x70
Jul 21 22:33:02 nas kernel:  [<ffffffffa02e5745>] =
btrfs_commit_transaction+0x405/0xa50 [btrfs]
Jul 21 22:33:02 nas kernel:  [<ffffffff810b6c30>] ? =
__wake_up_sync+0x20/0x20
Jul 21 22:33:02 nas kernel:  [<ffffffffa02e1275>] =
transaction_kthread+0x1e5/0x250 [btrfs]
Jul 21 22:33:02 nas kernel:  [<ffffffffa02e1090>] ? =
btrfs_cleanup_transaction+0x5a0/0x5a0 [btrfs]
Jul 21 22:33:02 nas kernel:  [<ffffffff81091d1a>] kthread+0xea/0x100
Jul 21 22:33:02 nas kernel:  [<ffffffff81090000>] ? =
parse_args+0x4b0/0x4e0
Jul 21 22:33:02 nas kernel:  [<ffffffff81091c30>] ? =
kthread_create_on_node+0x1b0/0x1b0
Jul 21 22:33:02 nas kernel:  [<ffffffff8152277c>] =
ret_from_fork+0x7c/0xb0
Jul 21 22:33:02 nas kernel:  [<ffffffff81091c30>] ? =
kthread_create_on_node+0x1b0/0x1b0=

--Apple-Mail=_EBC593D1-4B0B-4994-8C4F-3B339A22EC2A--
