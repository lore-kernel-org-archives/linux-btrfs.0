From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: 2.6.29-rc4: possible circular locking dependency at
	btrfs_try_spin_lock
Date: Mon, 9 Feb 2009 15:43:50 +0300
Message-ID: <a4423d670902090443v2c0da60g9c8ac4792586b044@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi
Is it false positive lockdep warning?

[ INFO: possible circular locking dependency detected ]
2.6.29-rc4-00001-gd5b5623 #2
-------------------------------------------------------
dbench/2193 is trying to acquire lock:
 (&eb->lock/7){--..}, at: [<ffffffff80448f1f>] btrfs_try_spin_lock+0x8f/0x1a0

but task is already holding lock:
 (&eb->lock#2/6){--..}, at: [<ffffffff80448df4>] btrfs_tree_lock+0xc4/0x160

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&eb->lock#2/6){--..}:
       [<ffffffff8026f3f3>] __lock_acquire+0xe23/0x1290
       [<ffffffff8026f8f1>] lock_acquire+0x91/0xc0
       [<ffffffff8062ed06>] _spin_lock_nested+0x46/0x80
       [<ffffffff80448d1d>] btrfs_clear_lock_blocking+0x9d/0xb0
       [<ffffffff80400b72>] btrfs_clear_path_blocking+0x32/0x50
       [<ffffffff804095b2>] btrfs_search_slot+0x9a2/0xb10
       [<ffffffff80409d54>] btrfs_insert_empty_items+0xa4/0x4e0
       [<ffffffff80423f26>] btrfs_new_inode+0x156/0x350
       [<ffffffff8042540f>] btrfs_mkdir+0x10f/0x210
       [<ffffffff802d1fdc>] vfs_mkdir+0x8c/0xd0
       [<ffffffff802d4156>] sys_mkdirat+0x106/0x120
       [<ffffffff802d4183>] sys_mkdir+0x13/0x20
       [<ffffffff8020be1b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&eb->lock/7){--..}:
       [<ffffffff8026f4ba>] __lock_acquire+0xeea/0x1290
       [<ffffffff8026f8f1>] lock_acquire+0x91/0xc0
       [<ffffffff8062ed06>] _spin_lock_nested+0x46/0x80
       [<ffffffff80448f1f>] btrfs_try_spin_lock+0x8f/0x1a0
       [<ffffffff8040911e>] btrfs_search_slot+0x50e/0xb10
       [<ffffffff80418b93>] btrfs_lookup_xattr+0x83/0x110
       [<ffffffff80438044>] __btrfs_getxattr+0x74/0x120
       [<ffffffff8044f37c>] btrfs_get_acl+0xbc/0x160
       [<ffffffff8044f62d>] btrfs_init_acl+0x9d/0x180
       [<ffffffff80422eec>] btrfs_init_inode_security+0x1c/0x40
       [<ffffffff80425458>] btrfs_mkdir+0x158/0x210
       [<ffffffff802d1fdc>] vfs_mkdir+0x8c/0xd0
       [<ffffffff802d4156>] sys_mkdirat+0x106/0x120
       [<ffffffff802d4183>] sys_mkdir+0x13/0x20
       [<ffffffff8020be1b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

2 locks held by dbench/2193:
 #0:  (&sb->s_type->i_mutex_key#12/1){--..}, at: [<ffffffff802d0c00>]
lookup_create+0x30/0xd0
 #1:  (&eb->lock#2/6){--..}, at: [<ffffffff80448df4>] btrfs_tree_lock+0xc4/0x160

stack backtrace:
Pid: 2193, comm: dbench Not tainted 2.6.29-rc4-00001-gd5b5623 #2
Call Trace:
 [<ffffffff8026cfa7>] print_circular_bug_tail+0xa7/0x100
 [<ffffffff8026f4ba>] __lock_acquire+0xeea/0x1290
 [<ffffffff8026f8f1>] lock_acquire+0x91/0xc0
 [<ffffffff80448f1f>] ? btrfs_try_spin_lock+0x8f/0x1a0
 [<ffffffff8062ed06>] _spin_lock_nested+0x46/0x80
 [<ffffffff80448f1f>] ? btrfs_try_spin_lock+0x8f/0x1a0
 [<ffffffff80448f1f>] btrfs_try_spin_lock+0x8f/0x1a0
 [<ffffffff8040911e>] btrfs_search_slot+0x50e/0xb10
 [<ffffffff8045eec5>] ? crypto_shash_update+0x25/0x30
 [<ffffffff8048150c>] ? crc32c+0x4c/0x60
 [<ffffffff80418b93>] btrfs_lookup_xattr+0x83/0x110
 [<ffffffff802c3885>] ? kmem_cache_alloc+0xb5/0x100
 [<ffffffff8026e37d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff80438044>] __btrfs_getxattr+0x74/0x120
 [<ffffffff8044f37c>] btrfs_get_acl+0xbc/0x160
 [<ffffffff8044f62d>] btrfs_init_acl+0x9d/0x180
 [<ffffffff8062cf59>] ? mutex_unlock+0x9/0x10
 [<ffffffff80422eec>] btrfs_init_inode_security+0x1c/0x40
 [<ffffffff80425458>] btrfs_mkdir+0x158/0x210
 [<ffffffff802d1fdc>] vfs_mkdir+0x8c/0xd0
 [<ffffffff802d4156>] sys_mkdirat+0x106/0x120
 [<ffffffff8020be4c>] ? sysret_check+0x27/0x62
 [<ffffffff8020be4c>] ? sysret_check+0x27/0x62
 [<ffffffff8026e312>] ? trace_hardirqs_on_caller+0x182/0x1e0
 [<ffffffff802d4183>] sys_mkdir+0x13/0x20
 [<ffffffff8020be1b>] system_call_fastpath+0x16/0x1b
