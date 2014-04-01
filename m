Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:63740 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbaDAWXM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Apr 2014 18:23:12 -0400
MIME-Version: 1.0
Date: Tue, 1 Apr 2014 18:23:11 -0400
Message-ID: <CA+5PVA787+k0TVFUuo6PxNWMwffWDKixmt2C+E4_9szUJatYkw@mail.gmail.com>
Subject: Btrfs lockdep with 3.15 merge window v3.14-751-g683b6c6f82a6
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Chris Mason <clm@fb.com>, jbacik@fb.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris and Josef,

Below is a lockdep spew I have on a local VM running Linus' tree as of
this afternoon.  The specific git commit is v3.14-751-g683b6c6f82a6.

I don't believe any btrfs commits have been merged for 3.15 in this
kernel.  The only related commits seem to be the merge of Ingo's
core/locking branch, which might have found a new lockdep issue/false
positive.  I might have reported a similar lockdep spew in 3.14, but I
can't recall at the moment.  The VM is very much hung though at this
point.  Hopefully this is helpful to you.

josh

[  295.348848] ========================================================
[  295.349016] [ INFO: posible irq lock invrsion dependency detected ]
[  25.349016] 3.15.0-.rc0.git2.1.fc21.x86_64 #1 Not tainted
[  295.34906] ---------------------------------------------------------
[  295.349016] kswapd0/47 just changed the state of lock:
[  295.349016]  (&delayed_node->mutex){+.+.-.}, at: [<ffffffffa019a90d>] __btrf]
[  295.349016] but this lock took another, RECLAIM_FS-unsafelock in the past:
                                                                             [ }

and interrupts could create inverse lock ordering between them.

[  295.349016]
[  295.349016] ther info that miht help us debug this:
[  295.349016]  Possible interrupt unsafe locking scenario:
[  295.349016]
[  295.349016]        CPU0                    CPU1
[  295.349016]        ----                    ----
[  295.349016]   lock(&found->groups_sem);
[  295.349016]                                local_irq_disable();
[  295.349016]                                lock(&delayed_node->mutex);
[  295.349016]                                lock(&found->groups_sem);
[  295.349016]   <Interrupt>
[  295.349016]     lock(&delayed_node->mutex);
[  29.349016]
[  295.349016]  *** DEADLOCK ***
[  295.349016]
[  295.349016] 2 locks held by kswapd0/47:
[  295.349016]  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff811c62ef>] shrink_0
[  295.349016]  #1:  (&type->s_umount_key#25){++++..}, at: [<ffffffff81238c14>]0
[  295.349016]
[  295.349016] the shorest dependencies etween 2nd lock and 1st lock:
[  29.349016]  -> (&ound->groups_sem){+++++.} ops: 1498 {
[  295.49016]     HARDIRQ-ON-W at:
  295.349016]                      [<fffffff810fabb0>] __loc_acquire+0x670/0x1c0
[  25.349016]                       [<fffffff810fca12>] lock_acquire+0xa2/0x1d0
[  295349016]                      [<ffffffff817dbd3e>] down_write+0x4e/0xc0
[  29.349016]                       [<fffffffa013187b>] _link_block_group+0x3b/]
[  25.349016]                       [<ffffffffa013375b>] btrfs_read_block_group]
[  25.349016]                      [<ffffffffa0142a31>] open_ctree+0x17f1/0x21d]
[  295.349016]                       [<ffffffffa0115c8e>] btrfs_mount+0x66e/0x8]
[  295.349016]                       [<ffffffff812395e9>] mount_fs+0x39/0x1b0
[  295.349016]                       [<ffffffff81259b6b>] vfs_kern_mount+0x6b/00
[  25.349016]                       [<ffffffffa01157a9>] btrfs_mount+0x189/0x85]
[  295.349016]                       [<fffffff812395e9>] mont_fs+0x39/0x1b0
[  295.349016]                       [<ffffffff81259bb>] vfs_kern_mount+0x6b/0x0
[  295.34901]                       [<fffffff8125ca7e>] do_mount+0x24e/0xbb0
[  295349016]                      [<fffffff8125d726>] SyS_mount0x96/0xf0
[  25.349016]                      [<ffffffff817e7be9>] system_call_fastpath+0xb
[  29.349016]     HARDIRQ-ON-R at:
[  295.349016]                       [<ffffffff810faa9a>] __lock_acquire+0x55a/0
[  295.34901]                      [<fffffff810fca12>] lock_acquire+0xa2/0x1d0
[  295.349016]                       [<ffffffff817bca1>] down_read+0x51/0xa0
[  29.349016]                       [<ffffffffa013e00d>] btrfs_calc_num_tolerat]
[  295.349016]                     [<ffffffffa142a4f>] open_ctree+0x180f/0x21d0]
[  295.349016]                       [<ffffffffa0115c8e>] btrfs_mount+0x66e/0x8]
[  295.349016                      [<ffffffff12395e9>] mount_fs+0x39/0x1b0
[  295.349016]                      [<ffffffff81259b6b>] vfs_kern_mount+0x6b/0x0
[  295.349016]                       [<ffffffff812395e9>] mount_fs+0x39/0x1b050]
[  295349016]                       [<fffffff81259b6b>] vfs_ken_mount+0x6b/0x150
[  295.34901]                       [<ffffffff8125ca7e>] do_mount+0x24e/0xbb0
[  295.349016]                      [<ffffffff8125d726>] SyS_mout+0x96/0xf0
[  295.349016]                       [<ffffffff817e7be9>] syste_call_fastpath+0b
[  295.349016]     SOFTIRQON-W at:
[  25.349016]                      [<ffffffff810facb>] __lock_acquire+0x58b/0x10
[  295349016]                       [<fffffff810fca12>] lock_acquire+0xa2/0x1d0
[  29.349016]                       [<fffffff817dbd3e>] downwrite+0x4e/0xc0
[  295.39016]                       [<fffffffa013187b>] __link_block_group+0x3b]
[  295.349016]                      [<ffffffffa013375b>] btrfs_read_block_groups
[  295.349016                       <ffffffffa0142a31>] open_ctree+0x17f1/0x21d]
[  295.39016]                       [<ffffffffa0115c8e>] btrfs_mount+0x66e/0x85]
[  295.349016]                       [ffffffff812395e9>] mount_fs+0x39/0x1b0
[  295.349016]                       [<ffffffff81259b6b>] vfs_kern_mount+0x6b/00
[  295.349016]                       [<ffffffffa1157a9>] btrfs_mont+0x189/0x850]
[  295.349016]                       [<fffffff812395e9>] mount_fs+0x39/0x1b0
[  29.349016]                       [<ffffffff8129b6b>] vfs_kern_mount+0x6b/0x10
[  25.349016]                       [<ffffffff8125ca7e>] do_mount+0x24e/0xbb0
[  295.349016]                       [<ffffffff8125d726>] SyS_mount+0x96/0xf0
[  295.34916]                       [<ffffffff817e7be9>] system_call_fastpath+0b
[  295.349016]     SOFTIRQ-ON-R at:
[  295.349016]                       [<ffffffff810faacb>] __lock_acquire+0x58b/0
[  295.49016]                      [<fffffff810fca12>] lock_acquire+0xa2/0x1d0
[  29.349016]                       [<ffffffff817dbca1>] down_read+0x51/0xa0
[  295.39016]                       [<fffffffa013e00d>] btfs_calc_num_tolerated]
[  295.34916]                       [<ffffffffa0142a4f>] open_ctree+0x180f/0x21]
[  295349016]                       [<ffffffffa0115c8e>] btrfs_mount+0x66e/0x85]
[  295.34016]                      [<fffffff812395e9>] mount_s+0x39/0x1b0
[  295.349016]                       [<ffffffff81259b6b>] vfs_kern_mount+0x6b/00
[  295.349016]                     [<ffffffffa01157a9>] btrfs_mount+0x189/0x850]
[  295.39016]                       [<fffffff812395e9>] mount_fs+0x39/0x1b0
[  95.349016]                      [<ffffffff81259b6b>] vfs_kern_mount+0x6b/0x10
[  295.34016]                       [<fffffff8125ca7e>] d_mount+0x24e/0xbb0
[  295349016]                       [<ffffffff8125d26>] SyS_mount+0x96/0xf0
                                                                           [  2b
[  295.349016]     RECLAIM_FS-ON-W at:
[  295.349016]                         [<ffffffff810f9f95>] mark_held_locks+0x70
[  25.349016]                         [<ffffffff810fd40a>] lockdep_trace_alloc+0
[  295.349016]                          [<fffffff812138df>] __kmalloc_track_cal0
[  295349016]                          [<ffffffff813d93d1>]kvasprintf+0x61/0xa0
[  295.349016]                          [<fffffff813cbb11>] kobject_set_name_va0
[  295.49016]                          [<ffffffff813cc5a2>] kobject_add0x62/0xd0
[  295.349016]                          [<fffffffa0131904>] __link_block_group+]
[  295.349016]                         [<ffffffffa013375b>] btrfs_read_block_gr]
[  295.349016]                          [<ffffffffa0142a31>] open_ctree+0x17f1/]
[  295.349016]                          [<ffffffffa0115c8e>] btrfs_mount+0x66e/]
[  295.349016]                          [<ffffffff812395e9>] mount_fs+0x39/0xb0
[  295.349016]                          [<ffffffff81259b6b>] vfs_kern_mount+0x60
                                                                               ]
[  295.349016]                          [<ffffffff812395e9>] mount_fs+x39/0x1b0
[  295.39016]                          [<ffffffff81259b6b>] vfs_kern_munt+0x6b/0
[  295.349016]                        [<ffffffff825ca7e>] do_mount+0x24e/0xbb0
[  295.349016]                         [<ffffffff825d726>] SyS_mount+0x96/0xf0
[  295.349016]                          [<ffffffff817e7be9>] system_call_fastpab
[  295.349016]     INITIAL USE at:
[  295.349016]                      [<fffffff810fa84a>] __lock_acquire+0x30a/0x0
[  295349016]                      [<ffffffff810ca12>] lock_acquire+0xa2/0x1d0
[  295.34016]                     [<fffffff817dbd3e>] down_write+0x4e/0xc0
[  295.349016]                      [<ffffffffa013187b>] __link_block_group+0x3]
[  295349016]                      [<ffffffffa013375b>] btrfs_read_block_groups]
[  295.34916]                      [<ffffffffa0142a31>] open_ctree+0x17f1/0x21d]
[  295.349016]                     [<fffffffa0115c8e>] brfs_mount+0x66e/0x850 []
[  295.349016]                      [<fffffff812395e9>] mount_fs+0x39/0x1b0
[  29.349016]                      [<ffffffff81259b6b>] vfs_kern_mount+0x6b/0x10
[  29.349016]                     [<fffffffa01157a9>] btrfs_mount+0x189/0x850 []
[  295.34016]                      [<ffffffff81235e9>] mount_fs+0x39/0x1b0
[  29.349016]                      [<fffffff81259b6b>] vfs_kern_mount+0x6b/0x150
[  25.349016]                     [<ffffffff8125ca7e>] do_mount+0x24e/0xbb0
[  295.34016]                     [<ffffffff8125d726>] SyS_mount+0x96/0xf0
[  295.349016]                      [<ffffffff817e7be9>] system_call_fastpath+0b
[  295.349016]
[  295.349016]   ... key      at: [<fffffffa01d67e0>] _key.42607+0x0/0xffffffff]
[  29.349016]   ... acquired at:
[  295.49016]    [<ffffffff810fca12>] lock_acquire+0xa2/0x1d0
[  295.349016]    [<ffffffff817dbca1] down_read+0x51/0xa0
[  95.349016]    [<fffffffa01311ab>] find_free_extent+0x80b/0xea0 [btrfs]
[  295.34016]    [<ffffffffa01319f8>] btrfs_reserve_extent+0xa8/0x140 [btrfs]
[  295.349016]    [<ffffffffa0131d0e>] btrfs_alloc_free_block+0xfe/0x480 [btrfs]
[  295.34016]    [<fffffffa011b234>] __btrfs_cow_block+0x134/0x550 [btrfs]
[  295.49016]    [<ffffffffa011b7e6>] btrfs_cow_block+0x116/0x270 [btrfs]
[  295.34916]    [<ffffffffa011f670>] btrfs_search_slot+0x1e0/0xa30 [btrfs]
[  25.349016]    [<ffffffffa013a01e>] btrfs_lookup_inode+0x3e/0xc0 [btrfs]
[  295.349016]    [ffffffffa019c1d2>] btrfs_commit_inode_delayed_inode+0x132/0x]
[  295.349016]    <ffffffffa0150fc4>] btrfs_evict_inode+0x24/0x5d0 [btrfs]
[  295.349016]   [<ffffffff8124733>] evict+0xa3/0x1a0
[  29.349016]    [<ffffffff81255025>] iput+0xf5/0x180
[  295.39016]    [<fffffff81244a03>] do_unlinkat+0x1b3/0x2c0
[  295.349016]    [<fffffff812482c6>] SyS_unink+0x16/0x20
[  295.34016]    [<fffffff817e7be9>] system_call_fastpath+0x16/0x1b
[  295.49016]
[  295349016] -> (&delayed_node->mutx){+.+.-.} ops: 10973 {
[  295.349016]    HARDIRQ-ON-W at:
[  295.349016]                     [<ffffffff810fabb0>] __lock_acquire+0x670/0x0
[  295.349016]                     [<ffffffff810fca12>] lock_acquire+0xa2/0x1d0
[  295.349016]                     [<ffffffff817d9567>] mtex_lock_nested+0x87/00
[  295.349016]                     [<ffffffffa019cc95>] btrfs_delayed_update_in]
[  25.349016]                    [<fffffffa014b8dc>] btrfs_update_inode+0x5c/0x]
[  295.349016]                     [<fffffffa01814e2>] lnk_to_fixup_dir+0xe2/0x]
[  295.349016]                     [<ffffffffa0185f18>] replay_one_bffer+0x1e8/]
[  295.49016]                     [<ffffffffa0180e0d>] walk_up_log_tree+0xcd/0x]
[  295.349016]                     [<fffffffa018100b>] walk_log_tree+0xab/0x1d0]
[  295.39016]                     [<fffffffa018827d>] btrfs_recver_log_trees+0x]
[  295.349016]                     [<ffffffffa0142c2a>] open_ctree+0x19ea/0x21d]
[  295.349016]                     [<ffffffffa0115c8e>] btrfs_mount+0x66e/0x850]
[  295.349016]                     [<ffffffff12395e9>] mount_s+0x39/0x1b0
[  295.349016]                     [<ffffffff81259b6b>] vfs_kernmount+0x6b/0x150
[  295.349016]                     [<ffffffffa01157a9>] btrfs_mount+0x189/0x850]
[  295.349016]                    [<fffffff812395e9>] mount_fs+0x39/0x1b0
[  295.349016]                    [<fffffff81259b6b>] vfs_kern_mont+0x6b/0x150
                                                                              [0
[  295.349016]                     [<fffffff8125d726>] SyS_ount+0x96/0xf0
[  295.34916]                     [<ffffffff817e7e9>] system_call_fastpath+0x1/b
[  295.39016]    SOFTIRQ-ON-W at:
                                 [  295.349016]                    [<fffffff8100
[  295.349016]                     [<ffffffff810fca12>] lok_acquire+0xa2/0xd0
[  295.34906]                     [<ffffffff817d9567>] mutex_lock_nested+0x87/00
[  295349016]                     [<ffffffffa019cc95>] btrfs_delayed_update_ino]
[  25.349016]                     [<ffffffffa014b8dc>] btrfs_update_inode+0x5c/]
[  295.349016]                     [<ffffffffa01814e2>] link_to_fixup_dir+0xe2/]
[  295349016]                    [<ffffffffa0185f18>] replay_one_buffer+0x1e8/0]
[  295.34016]                     [<ffffffffa0180e0d>] walk_up_log_tree+0xcd/0x]
[  295.349016]                     [<fffffffa018100b>] wlk_log_tree+0xab/0x1d0 ]
[  295.349016]                     [<ffffffffa018827d>] btrfs_recover_log_trees]
[  29.349016]                     [<ffffffffa0142c2a>] open_ctree+0x19ea/0x21d0]
[  295349016]                     [<ffffffffa0115c8e>] btrfs_mount+0x66e/0x850 ]
[  295.349016]                    [<ffffffff812395e9>] mount_fs+0x39/0x1b0
[  295.39016]                     [<ffffffff81259b6b] vfs_kern_mount+0x6b/0x150
[  295.49016]                    [<ffffffffa01157a9>] btrfs_mount+0x189/0x850 []
[  29.349016]                    [<fffffff812395e9>] mount_fs+0x39/0x1b0
[  295.349016]                     [<ffffffff81259b6b>] vfs_kern_mount+0x6b/0x10
[  295.349016]                     [<fffffff8125ca7e>] d_mount+0x24e/0xbb0
[  295349016]                     [<ffffffff8125d726>] SyS_mount+0x96/0xf0
[  295.349016]                     [<fffffff817e7be9>] system_cal_fastpath+0x16b
[  295.349016]    IN-RECLAIM_FS-W at:
[  295.34016]                       [<ffffffff810faa2c>] __lockacquire+0x4ec/0x0
[  295.34906]                       [<fffffff810fca12>] lock_acquire+0xa2/0x1d0
[  29.349016]                        [<ffffffff817d9567] mutex_lock_nested+0x870
[  25.349016]                        [<ffffffffa019a90>] __btrfs_release_delaye]
[  295.349016]                        [<ffffffffa019c204>] btrfs_remove_delayed]
[  295.349016]                       [<ffffffffa0150eae>] btrfs_evict_iode+0x1a]
[  295.349016]                        [<ffffffff81254733>] evic+0xa3/0x1a0
[  295.349016]                        [<ffffffff812548e>] dispose_list+0x3e/0x5
[  295.349016]                        [<ffffffff1255886>] prune_icache_sb+0x56/0
[  295.34916]                       [<fffffff81238e78>] super_cache_scan+0x108/0
[  295.349016]                        [<ffffffff811c5f9b>] shrink_slab_node+0140
[  295.349016]                        [<ffffffff811c633e>] shrink_slab+0x8e/0x10
[  295.349016]                       [<fffffff811c91ed>] kswapdshrink_zone+0x140
[  295.349016]                       [<ffffffff81cadd0>] kswapd+0x4b0/0xa60
[  295.349016]                        [<ffffffff810c472f>] kthread+0xff/0x120
[  295.349016]                        [<ffffffff81e7b3c>] ret_from_fork+0xc/0xb0
[  295.49016]    INITIAL USE a:
[  295.34901]                    [<ffffffff810fa84a>] __lock_acquire+0x30a/0x1c0
[  295.34916]                    [<ffffffff810fca2>] lock_acquire+0xa2/0x1d0
[  295.349016]                    [<ffffffff817d9567>] mutex_lock_nested+0x87/00
[  295.349016]                    [<fffffffa019cc95>] brfs_delayed_update_inode]
[  295349016]                    [<ffffffffa014b8dc>] btrf_update_inode+0x5/0xd]
[  295.34916]                    [<fffffffa01814e2>] link_to_fixup_dir+0xe2/0x1]
[  295.349016]                    [<ffffffffa0185f18>] replay_one_buffer+0x1e8/]
[  295.34016]                    [<ffffffffa0180e0d>] walk_up_log_tree+0xcd/0x2]
[  295.349016]                    [<ffffffffa018100b>] walk_log_tree+0xab/0x1d0]
[  295.349016]                    [<ffffffffa018827d>] btrfs_recover_log_trees+]
[  295.349016]                   [<ffffffffa0142c2a>] open_ctree+0x19ea/0x21d0 ]
[  295.349016]                    [<ffffffffa01158e>] btrfs_mount+x66e/0x850 [b]
[  295.349016]                    [<ffffffff812395e9>] mount_fs+0x39/0x1b0
[  295.349016]                    [<ffffffff81259b6b>] vfs_kern_mount+0x6b/0x150
[  295.349016]                    [<ffffffffa01157a9>] btrfs_moun+0x189/0x850 []
[  295.34906]                    [<ffffffff812395e9>] mount_fs+0x39/0x1b0
[  295.349016]                    [<ffffffff81259b6b>] vfs_kern_mount+0x6b/0x150
[  29.349016]                    [<ffffffff8125ca7e>] do_mount+0x24e/0xbb0
[  295.349016]                    [<ffffffff8125d726>] SyS_mount+0x96/0xf0
[  295.349016                    [<ffffffff817e7be9>] system_call_fastpath+0x16b
[  295.349016]  }
[  295.349016]  ... key      at: [<ffffffffa01da738>] __key.37615+0x0/0xfffffff]
[  295.349016]  ... acquired at:
[  295.349016]    [<ffffffff810f95aa>] check_usage_forwards+0x16a/0x180
[  295.349016]    [<ffffffff810f9e17>] mark_lock+0x1a7/0x2b0
[  295.349016]    [<ffffffff810faa2c>] __lock_acquire+0x4ec/0x1ce0
  295.349016]    [<fffffff810fca12>] lock_acquire+0xa2/0x1d0
[  295.349016]    [<ffffffff817d9567>] mutex_lock_nested+0x87/0x430
[  295.349016]    [<ffffffffa019a90d>] __btrfs_rlease_delayed_nod+0x3d/0x1f0 [b]
[  295.349016]    [<ffffffffa019c204>] btrfs_remove_delayed_node+0x4/0x30 [btrf]
[  295.349016]    [<ffffffffa0150eae>] btrfs_evict_inode+0x1ae/0x5d0 [btrfs]
[  295.349016]    [<fffffff81254733>] eict+0xa3/0x1a0
[  295.349016]    [<ffffffff8125486e>] dispose_list+0x3e/0x50
[  295.349016]    [<ffffffff81255886>] prune_icache_sb+0x56/0x8
[  295.349016]    [<ffffffff81238e78>] super_cache_scan+0x108/0x180
[  295.349016]    [<ffffffff811c5f9b>] shrink_slab_node+0x14b/0x430
[  295.349016    [<ffffffff811c633e>] shrink_slab+0x8e/0x180
[  295.349016]    [<ffffffff811c91ed>] kswapd_shrink_zone+0x14d/0x1f0
[  295.349016]    [<ffffffff811cadd0>] kswapd+0x4b0/0xa60
[  295.349016]    [<ffffffff810c472f>] kthread+0xff/0x120
[  295.349016]    [<ffffffff817e7b3c>] ret_from_fork+0x7c/0xb0
[  295.349016]
[  295.349016]
[  295.349016] stack backtrace:
[  295.349016] CPU: 0 PI: 47 Comm: kswapd0 Not tainted 3.15.0-0.rc0.git2.1.fc211
[  295.349016] Hardware name:Bochs Bochs, BIOS Bochs 01/01/2011
[  295.349016]  000000000000000 0000000014706e17 ffff8803855f718 ffffffff817d3e7
[  295.349016]  ffffffff829ed980 ffff88003855f758 ffffffff817cf4cc ffffffff81a42
[  295.349016]  0000000000000000 ffff8800385a4168 ffff8800385[  295.349016] Cal:
[  295.349016]  [<ffffffff817d3e37>] dump_stack+0x4d/0x66
[  295.349016]  [<ffffffff817cf4cc>] print_irq_inversion_bug.part.42+0x1ac/0x1b8
[  295.349016]  [<ffffffff810f95aa>] check_usage_forwards+0x16a/0x180
[  295.349016]  [<ffffffff810f9440>] ? check_usage_backwards+0x180/0x180
[  295.349016]  [<ffffffff810f9e17>] mark_lock+0x1a7/0x2b0
[  295.349016]  [<ffffffff810faa2c>] __lock_acquire+0x4ec/0x1ce0
[  295.349016]  [<ffffffff810248a9>] ? sched_clock+0x9/0x10
[  295.349016]  [<ffffffff810dd8ad>] ? sched_clock_local+0x1d/0x80
[  295.349016]  [<ffffffff810fca12>] lock_acquire+0xa2/0x1d0
[  295.349016]  [<ffffffffa019a90d>] ? __btrfs_release_delayed_node+0x3d/0x1f0 ]
[  25.349016]  [<ffffffff817d9567>] mutex_lock_nested+0x87/0x430
[  295.349016]  [<ffffffffa019a90d>] ? __btrfs_release_delayed_node+0x3d/0x1f0 ]
[  295.349016]  [<ffffffff810dd8ad>] ? sched_clock_local+0x1d/0x80
[  295.349016]  [<ffffffffa019a90d>] ? __btrfs_release_delayed_node+0x3d/0x1f0 ]
[  295.349016]  [<ffffffffa0150e8>] ? btrfs_evict_inde+0x185/0x5d0 [btfs]
[  295.34916]  [<ffffffff810ddaf8>] ? sched_clock_cpu+0xa8/0xd0
[  295.349016]  [<ffffffff810ddb76>] ? local_clock+0x16/0x30
[  25.349016]  [<fffffffa019a90d>] __btrfs_release_delayed_node+0x3d/0x1f0 [btr]
[  25.349016]  [<fffffffa019c204>] btrfs_remove_delayed_node+0x24/0x30 [btrfs]
[  295.49016]  [<ffffffffa0150eae>] btrfs_evict_inode+0x1ae/0x5d0 [btrfs]
[  295.349016]  [<ffffffff81254733>] evict+0xa3/0x1a0
[  295.349016  [<ffffffff8125486e>] dispose_list+0x3e/0x50
[  295.349016] [<ffffffff81255886>] prune_icache_sb+0x56/0x80
[  295.349016]  [<ffffffff81238e78>] super_cache_scan+0x108/0x180
[  295.349016]  [<ffffffff811c5f9b>] shrink_slab_node+0x14b/0x430
[  295.349016]  [<ffffffff811c62ef>] ? shrink_slab+0x3f/0x180
[  25.349016]  [<fffffff811c633e>] shrink_slab+0x8e/0x180
[  295.349016]  [<ffffffff811c91ed>] kswapd_shrink_zone+0x14d/0x1f0
[  295.349016]  [<ffffffff811cadd0>] kswapd+0x4b0/0xa60
[  295.349016]  [<ffffffff811ca920>]? mem_cgroup_shrink_nde_zone+0x2f0/0x2f0
[  295.349016]  [<ffffffff810c472f>] kthread+0xff/0x120
[  295.349016]  [<ffffffff810c4630>] ? insert_kthread_work+0x80/0x80
[  295.349016]  [<ffffffff817e7b3c>] ret_from_fork+0x7c/0xb0
[  295.349016]  [<ffffffff81c4630>] ? insert_kthread_work+0x80/0x0
