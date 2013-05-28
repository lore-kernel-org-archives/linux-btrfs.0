Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:64318 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933952Ab3E1N2e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 May 2013 09:28:34 -0400
Received: by mail-ie0-f170.google.com with SMTP id e14so2799726iej.29
        for <linux-btrfs@vger.kernel.org>; Tue, 28 May 2013 06:28:33 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 28 May 2013 16:28:33 +0300
Message-ID: <CAOcd+r0Bx8Sd5WANPG3WfO0Q78eXj_A_MX5j6n6oZYgcy=6ksA@mail.gmail.com>
Subject: 
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,
I have the following unresponsive btrfs:

btrfs_end_transaction() is called and is stuck in btrfs_tree_lock():

May 27 16:13:55 vc kernel: [ 7130.421159] kworker/u:85    D
0000000000000000     0 19859      2 0x00000000
May 27 16:13:55 vc kernel: [ 7130.421159]  ffff880095335568
0000000000000046 000000010093cb38 ffff880083b11b48
May 27 16:13:55 vc kernel: [ 7130.421159]  ffff880095335fd8
ffff880095335fd8 ffff880095335fd8 0000000000013f40
May 27 16:13:55 vc kernel: [ 7130.421159]  ffff8800a1fddd00
ffff88008b1fc5c0 ffff880095335578 ffff880090f736d8
May 27 16:13:55 vc kernel: [ 7130.421159] Call Trace:
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffff816eb399>] schedule+0x29/0x70
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffffa03665ad>] btrfs_tree_lock+0xcd/0x250 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffff8107fcc0>] ?  add_wait_queue+0x60/0x60
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffffa031d558>] btrfs_init_new_buffer+0x68/0x140 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffffa031d70d>] btrfs_alloc_free_block+0xdd/0x460 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffff8113ff9b>] ?  __set_page_dirty_nobuffers+0x1b/0x20
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffffa0327b2e>] ?  btree_set_page_dirty+0xe/0x10 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffffa0307756>] __btrfs_cow_block+0x126/0x4f0 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffffa0307cc3>] btrfs_cow_block+0x123/0x1d0 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffffa030c281>] btrfs_search_slot+0x381/0x820 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffffa03138ce>] lookup_inline_extent_backref+0x8e/0x5b0 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffffa032b6e9>] ?  btrfs_mark_buffer_dirty+0x99/0xf0 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffffa031301e>] ?  setup_inline_extent_backref+0x18e/0x290 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffffa0313e53>] insert_inline_extent_backref+0x63/0x130 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffffa030677a>] ?  btrfs_alloc_path+0x1a/0x20 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffffa031486f>] __btrfs_inc_extent_ref+0x9f/0x240 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffffa0377aa9>] ?  btrfs_merge_delayed_refs+0x289/0x300 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffffa031b3a1>] run_clustered_refs+0x971/0xd00 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffffa030714d>] ?  btrfs_put_tree_mod_seq+0x10d/0x150 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffffa031f7f0>] btrfs_run_delayed_refs+0xd0/0x320 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffffa0330bf7>] __btrfs_end_transaction+0xf7/0x410 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffffa0330f60>] btrfs_end_transaction+0x10/0x20 [btrfs]

As a result, transaction cannot commit, it waits for all writers to
detach in the do-while loop.

May 27 16:13:55 vc kernel: [ 7130.419009] btrfs-transacti D 0000000000000000     0 15150      2 0x00000000
May 27 16:13:55 vc kernel: [ 7130.419012]  ffff88009f86bce8 0000000000000046 00000000032d032d 0000000000000000
May 27 16:13:55 vc kernel: [ 7130.419016]  ffff88009f86bfd8 ffff88009f86bfd8 ffff88009f86bfd8 0000000000013f40
May 27 16:13:55 vc kernel: [ 7130.419020]  ffff8800af1e9740 ffff8800a03f8000 0000000000000090 ffff88009693cb00
May 27 16:13:55 vc kernel: [ 7130.419023] Call Trace:
May 27 16:13:55 vc kernel: [ 7130.419027]  [<ffffffff816eb399>] schedule+0x29/0x70
May 27 16:13:55 vc kernel: [ 7130.419031]  [<ffffffff816e9b1d>] schedule_timeout+0x1ed/0x250
May 27 16:13:55 vc kernel: [ 7130.419055]  [<ffffffffa03497a3>] ?  btrfs_run_ordered_operations+0x2b3/0x2e0 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.419060]  [<ffffffff81045cd9>] ?  default_spin_lock_flags+0x9/0x10
May 27 16:13:55 vc kernel: [ 7130.419081]  [<ffffffffa0330388>] btrfs_commit_transaction+0x3b8/0xae0 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.419085]  [<ffffffff8107fcc0>] ?  add_wait_queue+0x60/0x60
May 27 16:13:55 vc kernel: [ 7130.419104]  [<ffffffffa0328525>] transaction_kthread+0x1b5/0x230 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.419124]  [<ffffffffa0328370>] ?  btree_invalidatepage+0x80/0x80 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.419128]  [<ffffffff8107f0d0>] kthread+0xc0/0xd0
May 27 16:13:55 vc kernel: [ 7130.419132]  [<ffffffff8107f010>] ?  flush_kthread_worker+0xb0/0xb0
May 27 16:13:55 vc kernel: [ 7130.419136]  [<ffffffff816f506c>] ret_from_fork+0x7c/0xb0
May 27 16:13:55 vc kernel: [ 7130.419140]  [<ffffffff8107f010>] ?  flush_kthread_worker+0xb0/0xb0

There is additional thread stuck in btrfs_tree_lock(), not sure how it
is related, perhaps there's some deadlock between the two?

May 27 16:13:55 vc kernel: [ 7130.421159] flush-btrfs-2   D 0000000000000001     0 18816      2 0x00000000
May 27 16:13:55 vc kernel: [ 7130.421159]  ffff88008b553948 0000000000000046 ffff880017991050 0000000000000000
May 27 16:13:55 vc kernel: [ 7130.421159]  ffff88008b553fd8 ffff88008b553fd8 ffff88008b553fd8 0000000000013f40
May 27 16:13:55 vc kernel: [ 7130.421159]  ffff880119b11740 ffff8800af860000 ffff88008b553958 ffff880090c9d988
May 27 16:13:55 vc kernel: [ 7130.421159] Call Trace:
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffff816eb399>] schedule+0x29/0x70
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffffa03665ad>] btrfs_tree_lock+0xcd/0x250 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffff8107fcc0>] ?  add_wait_queue+0x60/0x60
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffffa0350e8c>] btree_write_cache_pages+0x3bc/0x880 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffffa034a790>] ?  end_extent_buffer_writeback+0x30/0x30 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffffa0327b6b>] btree_writepages+0x3b/0x40 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffff81140cd0>] do_writepages+0x20/0x40
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffff811c312f>] __writeback_single_inode+0x3f/0x180
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffff811c3dbf>] writeback_sb_inodes+0x20f/0x3a0
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffff811c3fee>] __writeback_inodes_wb+0x9e/0xd0
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffff811c450b>] wb_writeback+0x28b/0x340
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffff811c70c0>] wb_do_writeback+0x190/0x1d0
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffff811c718b>] bdi_writeback_thread+0x8b/0x290
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffff811c7100>] ?  wb_do_writeback+0x1d0/0x1d0
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffff8107f0d0>] kthread+0xc0/0xd0
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffff8107f010>] ?  flush_kthread_worker+0xb0/0xb0
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffff816f506c>] ret_from_fork+0x7c/0xb0
May 27 16:13:55 vc kernel: [ 7130.421159]  [<ffffffff8107f010>] ?  flush_kthread_worker+0xb0/0xb0

btrfs_tree_lock+0xcd indicates:
    wait_event(eb->write_lock_wq, atomic_read(&eb->blocking_writers) == 0);

As a result, new transactions cannot be started, and create snapshot
calls are stuck:

May 27 16:13:55 vc kernel: [ 7130.418720] myapp      D 0000000000000001     0  3754      1 0x00000000
May 27 16:13:55 vc kernel: [ 7130.418723]  ffff8800bdb4fbb8 0000000000000086 0000000000120000 0000000000090000
May 27 16:13:55 vc kernel: [ 7130.418727]  ffff8800bdb4ffd8 ffff8800bdb4ffd8 ffff8800bdb4ffd8 0000000000013f40
May 27 16:13:55 vc kernel: [ 7130.418730]  ffff8801141b1740 ffff8801171a1740 ffff8800bdb4fbc8 ffff8800bdfc39e8
May 27 16:13:55 vc kernel: [ 7130.418734] Call Trace:
May 27 16:13:55 vc kernel: [ 7130.418738]  [<ffffffff816eb399>] schedule+0x29/0x70
May 27 16:13:55 vc kernel: [ 7130.418758]  [<ffffffffa032f8fd>] wait_current_trans.isra.29+0x9d/0x100 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.418762]  [<ffffffff8107fcc0>] ?  add_wait_queue+0x60/0x60
May 27 16:13:55 vc kernel: [ 7130.418783]  [<ffffffffa03310d9>] start_transaction+0x169/0x4f0 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.418787]  [<ffffffff8118538c>] ?  kmem_cache_alloc_trace+0x11c/0x140
May 27 16:13:55 vc kernel: [ 7130.418807]  [<ffffffffa0331788>] btrfs_start_transaction+0x18/0x20 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.418831]  [<ffffffffa0361cbc>] btrfs_mksubvol.isra.52+0x1cc/0x470 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.418855]  [<ffffffffa0362066>] btrfs_ioctl_snap_create_transid+0x106/0x1a0 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.418879]  [<ffffffffa03621c7>] ?  btrfs_ioctl_snap_create_v2+0x47/0x140 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.418903]  [<ffffffffa0362283>] btrfs_ioctl_snap_create_v2+0x103/0x140 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.418907]  [<ffffffff811aa003>] ?  path_openat+0xb3/0x4d0
May 27 16:13:55 vc kernel: [ 7130.418931]  [<ffffffffa036552b>] btrfs_ioctl+0xfeb/0x1b70 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.418935]  [<ffffffff8119f909>] ?  inode_get_bytes+0x49/0x60
May 27 16:13:55 vc kernel: [ 7130.418955]  [<ffffffffa0331d26>] ?  btrfs_getattr+0x56/0x90 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.418959]  [<ffffffff8119fb76>] ?  cp_new_stat+0x116/0x130
May 27 16:13:55 vc kernel: [ 7130.418962]  [<ffffffff811acbca>] do_vfs_ioctl+0x8a/0x340
May 27 16:13:55 vc kernel: [ 7130.418966]  [<ffffffff811a00aa>] ?  sys_newfstat+0x2a/0x40
May 27 16:13:55 vc kernel: [ 7130.418969]  [<ffffffff811acf11>] sys_ioctl+0x91/0xb0
May 27 16:13:55 vc kernel: [ 7130.418973]  [<ffffffff816f511d>] system_call_fastpath+0x1a/0x1f

May 27 16:13:55 vc kernel: [ 7130.418457] myapp      D 0000000000000000     0  3753      1 0x00000000
May 27 16:13:55 vc kernel: [ 7130.418461]  ffff8800bdb3dbb8 0000000000000086 0000000000120000 0000000000090000
May 27 16:13:55 vc kernel: [ 7130.418465]  ffff8800bdb3dfd8 ffff8800bdb3dfd8 ffff8800bdb3dfd8 0000000000013f40
May 27 16:13:55 vc kernel: [ 7130.418468]  ffff88003a8dc5c0 ffff8801171a2e80 ffff8800bdb3dbc8 ffff8800bdfc39e8
May 27 16:13:55 vc kernel: [ 7130.418472] Call Trace:
May 27 16:13:55 vc kernel: [ 7130.418476]  [<ffffffff816eb399>] schedule+0x29/0x70
May 27 16:13:55 vc kernel: [ 7130.418496]  [<ffffffffa032f8fd>] wait_current_trans.isra.29+0x9d/0x100 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.418503]  [<ffffffff8107fcc0>] ?  add_wait_queue+0x60/0x60
May 27 16:13:55 vc kernel: [ 7130.418524]  [<ffffffffa03310d9>] start_transaction+0x169/0x4f0 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.418529]  [<ffffffff8118538c>] ?  kmem_cache_alloc_trace+0x11c/0x140
May 27 16:13:55 vc kernel: [ 7130.418550]  [<ffffffffa0331788>] btrfs_start_transaction+0x18/0x20 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.418574]  [<ffffffffa0361cbc>] btrfs_mksubvol.isra.52+0x1cc/0x470 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.418598]  [<ffffffffa0362066>] btrfs_ioctl_snap_create_transid+0x106/0x1a0 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.418622]  [<ffffffffa03621c7>] ?  btrfs_ioctl_snap_create_v2+0x47/0x140 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.418646]  [<ffffffffa0362283>] btrfs_ioctl_snap_create_v2+0x103/0x140 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.418650]  [<ffffffff811aa003>] ?  path_openat+0xb3/0x4d0
May 27 16:13:55 vc kernel: [ 7130.418674]  [<ffffffffa036552b>] btrfs_ioctl+0xfeb/0x1b70 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.418678]  [<ffffffff8119f909>] ?  inode_get_bytes+0x49/0x60
May 27 16:13:55 vc kernel: [ 7130.418699]  [<ffffffffa0331d26>] ?  btrfs_getattr+0x56/0x90 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.418703]  [<ffffffff8119fb76>] ?  cp_new_stat+0x116/0x130
May 27 16:13:55 vc kernel: [ 7130.418706]  [<ffffffff811acbca>] do_vfs_ioctl+0x8a/0x340
May 27 16:13:55 vc kernel: [ 7130.418710]  [<ffffffff811a00aa>] ?  sys_newfstat+0x2a/0x40
May 27 16:13:55 vc kernel: [ 7130.418713]  [<ffffffff811acf11>] sys_ioctl+0x91/0xb0
May 27 16:13:55 vc kernel: [ 7130.418717]  [<ffffffff816f511d>] system_call_fastpath+0x1a/0x1f

Snap destroy calls are also stuck  trying to take subvol_sem locked by
snap create calls, and the directory mutex, locked by the previous
snap destroy:

May 27 16:13:55 vc kernel: [ 7130.418154] myapp      D 0000000000000001     0  3750      1 0x00000000
May 27 16:13:55 vc kernel: [ 7130.418159]  ffff8800bda99c88 0000000000000086 ffff8800bda99cb8 ffffffffa033d0d1
May 27 16:13:55 vc kernel: [ 7130.418163]  ffff8800bda99fd8 ffff8800bda99fd8 ffff8800bda99fd8 0000000000013f40
May 27 16:13:55 vc kernel: [ 7130.418167]  ffff88008d6a45c0 ffff8801173d2e80 ffff8800bda99c68 ffff8801173d2e80
May 27 16:13:55 vc kernel: [ 7130.418171] Call Trace:
May 27 16:13:55 vc kernel: [ 7130.418214]  [<ffffffffa033d0d1>] ?  btrfs_lookup_dentry+0x201/0x4d0 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.418223]  [<ffffffff816eb399>] schedule+0x29/0x70
May 27 16:13:55 vc kernel: [ 7130.418227]  [<ffffffff816ec1ad>] rwsem_down_failed_common+0xcd/0x170
May 27 16:13:55 vc kernel: [ 7130.418231]  [<ffffffff816ec263>] rwsem_down_write_failed+0x13/0x20
May 27 16:13:55 vc kernel: [ 7130.418237]  [<ffffffff8135cd53>] call_rwsem_down_write_failed+0x13/0x20
May 27 16:13:55 vc kernel: [ 7130.418241]  [<ffffffff816ea682>] ?  down_write+0x32/0x40
May 27 16:13:55 vc kernel: [ 7130.418265]  [<ffffffffa0360aab>] btrfs_ioctl_snap_destroy+0x31b/0x520 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.418290]  [<ffffffffa0365328>] btrfs_ioctl+0xde8/0x1b70 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.418295]  [<ffffffff81097c83>] ?  update_curr+0x143/0x1f0
May 27 16:13:55 vc kernel: [ 7130.418301]  [<ffffffff811aa832>] ?  do_filp_open+0x42/0xa0
May 27 16:13:55 vc kernel: [ 7130.418304]  [<ffffffff811acbca>] do_vfs_ioctl+0x8a/0x340
May 27 16:13:55 vc kernel: [ 7130.418308]  [<ffffffff811a6356>] ?  final_putname+0x26/0x50
May 27 16:13:55 vc kernel: [ 7130.418331]  [<ffffffff811acf11>] sys_ioctl+0x91/0xb0
May 27 16:13:55 vc kernel: [ 7130.418338]  [<ffffffff816f511d>] system_call_fastpath+0x1a/0x1f

May 27 16:13:55 vc kernel: [ 7130.418341] myapp      D 0000000000000000     0  3751      1 0x00000004
May 27 16:13:55 vc kernel: [ 7130.418344]  ffff8800bda9dcc8 0000000000000086 ffff8800bda9dc78 ffffffff812d8d19
May 27 16:13:55 vc kernel: [ 7130.418348]  ffff8800bda9dfd8 ffff8800bda9dfd8 ffff8800bda9dfd8 0000000000013f40
May 27 16:13:55 vc kernel: [ 7130.418352]  ffffffff81c15440 ffff8801173d5d00 ffff8800bda9df28 ffff88009b262678
May 27 16:13:55 vc kernel: [ 7130.418356] Call Trace:
May 27 16:13:55 vc kernel: [ 7130.418362]  [<ffffffff812d8d19>] ?  security_file_open+0x79/0x80
May 27 16:13:55 vc kernel: [ 7130.418366]  [<ffffffff816eb399>] schedule+0x29/0x70
May 27 16:13:55 vc kernel: [ 7130.418370]  [<ffffffff816eb64e>] schedule_preempt_disabled+0xe/0x10
May 27 16:13:55 vc kernel: [ 7130.418373]  [<ffffffff816ea2c7>] __mutex_lock_slowpath+0xd7/0x150
May 27 16:13:55 vc kernel: [ 7130.418379]  [<ffffffff811ba428>] ?  __mnt_want_write+0x58/0x70
May 27 16:13:55 vc kernel: [ 7130.418383]  [<ffffffff816e9eda>] mutex_lock+0x2a/0x50
May 27 16:13:55 vc kernel: [ 7130.418407]  [<ffffffffa0360879>] btrfs_ioctl_snap_destroy+0xe9/0x520 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.418431]  [<ffffffffa0365328>] btrfs_ioctl+0xde8/0x1b70 [btrfs]
May 27 16:13:55 vc kernel: [ 7130.418436]  [<ffffffff811a63b0>] ?  getname_flags.part.21+0x30/0x150
May 27 16:13:55 vc kernel: [ 7130.418440]  [<ffffffff811aa832>] ?  do_filp_open+0x42/0xa0
May 27 16:13:55 vc kernel: [ 7130.418444]  [<ffffffff811acbca>] do_vfs_ioctl+0x8a/0x340
May 27 16:13:55 vc kernel: [ 7130.418448]  [<ffffffff811a6356>] ?  final_putname+0x26/0x50
May 27 16:13:55 vc kernel: [ 7130.418451]  [<ffffffff811acf11>] sys_ioctl+0x91/0xb0
May 27 16:13:55 vc kernel: [ 7130.418455]  [<ffffffff816f511d>] system_call_fastpath+0x1a/0x1f

Kernel is 3.8.2.

Some investigation suggests that there are no pending IOs on the block
device level.
Can anybody advise what could have caused such a hang?

Thanks,
Alex.
