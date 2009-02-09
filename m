From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: 2.6.29-rc4: possible circular locking dependency at
	btrfs_try_spin_lock
Date: Mon, 9 Feb 2009 16:48:13 +0300
Message-ID: <a4423d670902090548j53a87a3al93de57753f970d9a@mail.gmail.com>
References: <a4423d670902090443v2c0da60g9c8ac4792586b044@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a4423d670902090443v2c0da60g9c8ac4792586b044@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2009/2/9 Alexander Beregalov <a.beregalov@gmail.com>:
> Hi
> Is it false positive lockdep warning?
>
> [ INFO: possible circular locking dependency detected ]
> 2.6.29-rc4-00001-gd5b5623 #2
> -------------------------------------------------------

Another one with linux-next

[ INFO: possible circular locking dependency detected ]
2.6.29-rc4-next-20090209 #3
-------------------------------------------------------
dbench/31903 is trying to acquire lock:
 (&eb->lock#2/6){--..}, at: [<ffffffff80447bbd>]
btrfs_clear_lock_blocking+0x9d/0xb0

but task is already holding lock:
 (&eb->lock/7){--..}, at: [<ffffffff80447bbd>]
btrfs_clear_lock_blocking+0x9d/0xb0

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&eb->lock/7){--..}:
       [<ffffffff8026d3d3>] __lock_acquire+0xe23/0x1290
       [<ffffffff8026d8d1>] lock_acquire+0x91/0xc0
       [<ffffffff8062f8c6>] _spin_lock_nested+0x46/0x80
       [<ffffffff80447dbf>] btrfs_try_spin_lock+0x8f/0x1a0
       [<ffffffff80407f3e>] btrfs_search_slot+0x50e/0xb10
       [<ffffffff80414447>] btrfs_read_block_groups+0x67/0x390
       [<ffffffff8041eb98>] open_ctree+0xe18/0x1120
       [<ffffffff803fec78>] btrfs_get_sb+0x3a8/0x4b0
       [<ffffffff802c8468>] vfs_kern_mount+0x58/0xd0
       [<ffffffff802c854e>] do_kern_mount+0x4e/0x110
       [<ffffffff802e1981>] do_mount+0x291/0x880
       [<ffffffff802e2030>] sys_mount+0xc0/0x100
       [<ffffffff8020bc1b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&eb->lock#2/6){--..}:
       [<ffffffff8026d49a>] __lock_acquire+0xeea/0x1290
       [<ffffffff8026d8d1>] lock_acquire+0x91/0xc0
       [<ffffffff8062f8c6>] _spin_lock_nested+0x46/0x80
       [<ffffffff80447bbd>] btrfs_clear_lock_blocking+0x9d/0xb0
       [<ffffffff803ff992>] btrfs_clear_path_blocking+0x32/0x50
       [<ffffffff80407d81>] btrfs_search_slot+0x351/0xb10
       [<ffffffff80408b74>] btrfs_insert_empty_items+0xa4/0x4e0
       [<ffffffff8040df2a>] __btrfs_alloc_reserved_extent+0xea/0x330
       [<ffffffff804137de>] btrfs_alloc_extent+0x6e/0xb0
       [<ffffffff8041387c>] btrfs_alloc_free_block+0x5c/0x90
       [<ffffffff804020a6>] __btrfs_cow_block+0x746/0xb00
       [<ffffffff80402b62>] btrfs_cow_block+0x112/0x2d0
       [<ffffffff80407c53>] btrfs_search_slot+0x223/0xb10
       [<ffffffff80419b33>] btrfs_lookup_inode+0x33/0xb0
       [<ffffffff80423146>] btrfs_update_inode+0x46/0xd0
       [<ffffffff804243f5>] btrfs_dirty_inode+0x45/0x60
       [<ffffffff802e6615>] __mark_inode_dirty+0x35/0x1c0
       [<ffffffff802db3c8>] touch_atime+0xd8/0x140
       [<ffffffff802d5e56>] vfs_readdir+0xc6/0xd0
       [<ffffffff802d5fb7>] sys_getdents+0x87/0xe0
       [<ffffffff8020bc1b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

2 locks held by dbench/31903:
 #0:  (&type->i_mutex_dir_key#6){--..}, at: [<ffffffff802d5e04>]
vfs_readdir+0x74/0xd0
 #1:  (&eb->lock/7){--..}, at: [<ffffffff80447bbd>]
btrfs_clear_lock_blocking+0x9d/0xb0

stack backtrace:
Pid: 31903, comm: dbench Not tainted 2.6.29-rc4-next-20090209 #3
Call Trace:
 [<ffffffff8026b0ef>] print_circular_bug_tail+0x9f/0xf0
 [<ffffffff8026d49a>] __lock_acquire+0xeea/0x1290
 [<ffffffff8026d8d1>] lock_acquire+0x91/0xc0
 [<ffffffff80447bbd>] ? btrfs_clear_lock_blocking+0x9d/0xb0
 [<ffffffff80447bbd>] ? btrfs_clear_lock_blocking+0x9d/0xb0
 [<ffffffff8062f8c6>] _spin_lock_nested+0x46/0x80
 [<ffffffff80447bbd>] ? btrfs_clear_lock_blocking+0x9d/0xb0
 [<ffffffff80447bbd>] btrfs_clear_lock_blocking+0x9d/0xb0
 [<ffffffff803ff992>] btrfs_clear_path_blocking+0x32/0x50
 [<ffffffff80407d81>] btrfs_search_slot+0x351/0xb10
 [<ffffffff802191da>] ? save_stack_trace+0x2a/0x50
 [<ffffffff8040dea0>] ? __btrfs_alloc_reserved_extent+0x60/0x330
 [<ffffffff80408b74>] btrfs_insert_empty_items+0xa4/0x4e0
 [<ffffffff8026c2f2>] ? trace_hardirqs_on_caller+0x182/0x1e0
 [<ffffffff8026c35d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8040df2a>] __btrfs_alloc_reserved_extent+0xea/0x330
 [<ffffffff804137de>] btrfs_alloc_extent+0x6e/0xb0
 [<ffffffff8041387c>] btrfs_alloc_free_block+0x5c/0x90
 [<ffffffff804020a6>] __btrfs_cow_block+0x746/0xb00
 [<ffffffff80402b62>] btrfs_cow_block+0x112/0x2d0
 [<ffffffff80407c53>] btrfs_search_slot+0x223/0xb10
 [<ffffffff8026c056>] ? mark_held_locks+0x56/0xa0
 [<ffffffff802c2b45>] ? kmem_cache_alloc+0xb5/0x100
 [<ffffffff80419b33>] btrfs_lookup_inode+0x33/0xb0
 [<ffffffff80423146>] btrfs_update_inode+0x46/0xd0
 [<ffffffff802d5bd0>] ? filldir+0x0/0xe0
 [<ffffffff804243f5>] btrfs_dirty_inode+0x45/0x60
 [<ffffffff802e6615>] __mark_inode_dirty+0x35/0x1c0
 [<ffffffff802db3c8>] touch_atime+0xd8/0x140
 [<ffffffff802d5e56>] vfs_readdir+0xc6/0xd0
 [<ffffffff802d5fb7>] sys_getdents+0x87/0xe0
 [<ffffffff8020bc1b>] system_call_fastpath+0x16/0x1b
