From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Subject: RE: [PATCH V3] btrfs: implement delayed inode items operation
Date: Thu, 10 Mar 2011 00:03:55 +0900
Message-ID: <20110310000355.f225f0d0.kitayama@cl.bb4u.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Miao,

My virtual machine hangs upon reboot.

INFO: task umount:1952 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
umount        D 00000000fffd44dc  3024  1952   1714 0x00000000
 ffff880051ea99e8 0000000000000046 ffff880000000000 ffff880051ea9fd8
 00000000001d4240 ffff88005cd958d0 ffff88005cd95e60 ffff88005cd95e58
 ffff880051ea8000 ffff880051ea9fd8 00000000001d4240 00000000001d4240
Call Trace:
 [<ffffffff811d2697>] ? start_transaction+0x7b/0x1f8
 [<ffffffff814b5593>] __mutex_lock_common+0x28c/0x444
 [<ffffffff811d2697>] ? start_transaction+0x7b/0x1f8
 [<ffffffff814b5800>] mutex_lock_nested+0x39/0x3e
 [<ffffffff811d2697>] start_transaction+0x7b/0x1f8
 [<ffffffff811d2857>] btrfs_join_transaction+0x15/0x17
 [<ffffffff8120e873>] btrfs_remove_delayed_node+0x36/0xa1
 [<ffffffff811d32ae>] btrfs_destroy_inode+0x2ae/0x2cc
 [<ffffffff8112d1c9>] destroy_inode+0x2f/0x45
 [<ffffffff8112da86>] iput+0x239/0x23e
 [<ffffffff811c7992>] btrfs_write_dirty_block_groups+0x22a/0x47c
 [<ffffffff811d0f46>] commit_cowonly_roots+0xd9/0x198
 [<ffffffff811d20fc>] btrfs_commit_transaction+0x3a0/0x658
 [<ffffffff814b5176>] ? __mutex_unlock_slowpath+0x129/0x13a
 [<ffffffff810603de>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff811cf152>] btrfs_commit_super+0x90/0xd9
 [<ffffffff811cf1e5>] close_ctree+0x4a/0x35c
 [<ffffffff810648f5>] ? up_write+0x23/0x3b
 [<ffffffff8112d83b>] ? invalidate_inodes+0x134/0x146
 [<ffffffff811b5989>] btrfs_put_super+0x1d/0x2c
 [<ffffffff8111c08d>] generic_shutdown_super+0x56/0xd7
 [<ffffffff8111c163>] kill_anon_super+0x16/0x54
 [<ffffffff8111b895>] ? deactivate_super+0x3d/0x4a
 [<ffffffff8111b405>] deactivate_locked_super+0x26/0x46
 [<ffffffff8111b89d>] deactivate_super+0x45/0x4a
 [<ffffffff81131d6a>] mntput_no_expire+0xd6/0x104
 [<ffffffff81132e8f>] sys_umount+0x2c1/0x2ec
 [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
INFO: lockdep is turned off.

btrfs_remove_delayed_node() is called while trans_mutex is held.

Itaru

