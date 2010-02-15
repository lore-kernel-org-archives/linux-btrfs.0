From: Ed Tomlinson <edt@aei.ca>
Subject: [LOCKING] 2.6.33-rc8 btrfs vs java
Date: Sun, 14 Feb 2010 19:14:50 -0500
Message-ID: <201002141914.50955.edt@aei.ca>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Found this in my log for 2.6.33-rc8.  Figgured it might be interesting since .33 is close.

Thanks,
Ed

[102331.564869]                                                                                                                              
[102331.564871] =======================================================                                                                      
[102331.565770] [ INFO: possible circular locking dependency detected ]                                                                      
[102331.565770] 2.6.32.8-crc #104                                                                                                            
[102331.580954] -------------------------------------------------------                                                                      
[102331.580954] java/8004 is trying to acquire lock:                                                                                         
[102331.580954]  (btrfs-extent-01){+.+...}, at: [<ffffffffa04e9110>] btrfs_try_spin_lock+0x70/0xa0 [btrfs]                                   
[102331.580954]                                                                                                                              
[102331.580954] but task is already holding lock:                                                                                            
[102331.580954]  (&eb->lock){+.+...}, at: [<ffffffffa04e9160>] btrfs_clear_lock_blocking+0x20/0x30 [btrfs]                                   
[102331.580954]                                                                                                                              
[102331.580954] which lock already depends on the new lock.                                                                                  
[102331.580954]                                                                                                                              
[102331.580954]                                                                                                                              
[102331.580954] the existing dependency chain (in reverse order) is:                                                                         
[102331.580954]                                                                                                                              
[102331.580954] -> #1 (&eb->lock){+.+...}:                                                                                                   
[102331.580954]        [<ffffffff81091b95>] __lock_acquire+0xfc5/0x1550                                                                      
[102331.580954]        [<ffffffff810921bc>] lock_acquire+0x9c/0x140                                                                          
[102331.580954]        [<ffffffff814ac11b>] _spin_lock+0x3b/0x50                                                                             
[102331.580954]        [<ffffffffa04e9110>] btrfs_try_spin_lock+0x70/0xa0 [btrfs]                                                            
[102331.580954]        [<ffffffffa04a016d>] btrfs_search_slot+0x81d/0x860 [btrfs]                                                            
[102331.670534]        [<ffffffffa04b267f>] btrfs_lookup_inode+0x2f/0xb0 [btrfs]                                                             
[102331.670534]        [<ffffffffa04bcd3e>] btrfs_update_inode+0x6e/0x100 [btrfs]                                                            
[102331.670534]        [<ffffffffa04bd469>] btrfs_dirty_inode+0x49/0x70 [btrfs]                                                              
[102331.670534]        [<ffffffff8115beeb>] __mark_inode_dirty+0x3b/0x1a0                                                                    
[102331.670534]        [<ffffffff8114e1fb>] file_update_time+0xfb/0x180                                                                      
[102331.706273]        [<ffffffffa04c7114>] btrfs_file_write+0x384/0x920 [btrfs]                                                             
[102331.706273]        [<ffffffff8113333c>] vfs_write+0x11c/0x1e0                                                                            
[102331.706273]        [<ffffffff8113464a>] sys_pwrite64+0xaa/0xb0                                                                           
[102331.706273]        [<ffffffff8100ba1b>] system_call_fastpath+0x16/0x1b
[102331.706273]
[102331.706273] -> #0 (btrfs-extent-01){+.+...}:
[102331.737064]        [<ffffffff81091fe8>] __lock_acquire+0x1418/0x1550
[102331.737064]        [<ffffffff810921bc>] lock_acquire+0x9c/0x140
[102331.753738]        [<ffffffff814ac11b>] _spin_lock+0x3b/0x50
[102331.753738]        [<ffffffffa04e9110>] btrfs_try_spin_lock+0x70/0xa0 [btrfs]
[102331.753738]        [<ffffffffa04a016d>] btrfs_search_slot+0x81d/0x860 [btrfs]
[102331.753738]        [<ffffffffa04b0fd3>] btrfs_lookup_csum+0x93/0x160 [btrfs]
[102331.753738]        [<ffffffffa04b1a7d>] btrfs_lookup_bio_sums+0x19d/0x380 [btrfs]
[102331.753738]        [<ffffffffa04bc125>] btrfs_submit_bio_hook+0x95/0x120 [btrfs]
[102331.753738]        [<ffffffffa04d661a>] submit_one_bio+0x5a/0x90 [btrfs]
[102331.753738]        [<ffffffffa04d9f76>] extent_read_full_page+0x46/0x50 [btrfs]
[102331.753738]        [<ffffffffa04bcc53>] btrfs_readpage+0x23/0x30 [btrfs]
[102331.753738]        [<ffffffffa04c74c6>] btrfs_file_write+0x736/0x920 [btrfs]
[102331.753738]        [<ffffffff8113333c>] vfs_write+0x11c/0x1e0
[102331.753738]        [<ffffffff8113464a>] sys_pwrite64+0xaa/0xb0
[102331.753738]        [<ffffffff8100ba1b>] system_call_fastpath+0x16/0x1b
[102331.753738]
[102331.753738] other info that might help us debug this:
[102331.753738]
[102331.753738] 2 locks held by java/8004:
[102331.753738]  #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffffa04c6ec6>] btrfs_file_write+0x136/0x920 [btrfs]
[102331.753738]  #1:  (&eb->lock){+.+...}, at: [<ffffffffa04e9160>] btrfs_clear_lock_blocking+0x20/0x30 [btrfs]
[102331.753738]
[102331.753738] stack backtrace:
[102331.753738] Pid: 8004, comm: java Not tainted 2.6.32.8-crc #104
[102331.753738] Call Trace:
[102331.753738]  [<ffffffff8108f679>] print_circular_bug+0xe9/0xf0
[102331.753738]  [<ffffffff81091fe8>] __lock_acquire+0x1418/0x1550
[102331.753738]  [<ffffffff814afa4e>] ? sub_preempt_count+0xe/0x60
[102331.753738]  [<ffffffff810921bc>] lock_acquire+0x9c/0x140
[102331.753738]  [<ffffffffa04e9110>] ? btrfs_try_spin_lock+0x70/0xa0 [btrfs]
[102331.753738]  [<ffffffff814ac11b>] _spin_lock+0x3b/0x50
[102331.753738]  [<ffffffffa04e9110>] ? btrfs_try_spin_lock+0x70/0xa0 [btrfs]
[102331.753738]  [<ffffffffa04e9110>] btrfs_try_spin_lock+0x70/0xa0 [btrfs]
[102331.753738]  [<ffffffffa04a016d>] btrfs_search_slot+0x81d/0x860 [btrfs]
[102331.753738]  [<ffffffff81090655>] ? trace_hardirqs_on_caller+0x145/0x190
[102331.753738]  [<ffffffffa04b0fd3>] btrfs_lookup_csum+0x93/0x160 [btrfs]
[102331.753738]  [<ffffffffa04b1a7d>] btrfs_lookup_bio_sums+0x19d/0x380 [btrfs]
[102331.753738]  [<ffffffffa04b4f49>] ? btrfs_bio_wq_end_io+0x59/0x140 [btrfs]
[102331.753738]  [<ffffffffa04bc125>] btrfs_submit_bio_hook+0x95/0x120 [btrfs]
[102331.753738]  [<ffffffffa04d661a>] submit_one_bio+0x5a/0x90 [btrfs]
[102331.753738]  [<ffffffffa04d9f76>] extent_read_full_page+0x46/0x50 [btrfs]
[102331.753738]  [<ffffffffa04bcc53>] btrfs_readpage+0x23/0x30 [btrfs]
[102331.753738]  [<ffffffffa04c74c6>] btrfs_file_write+0x736/0x920 [btrfs]
[102331.753738]  [<ffffffff81223206>] ? security_file_permission+0x16/0x20
[102331.753738]  [<ffffffff811331ad>] ? rw_verify_area+0xed/0x160
[102331.753738]  [<ffffffff8113333c>] vfs_write+0x11c/0x1e0
[102331.753738]  [<ffffffff8113464a>] sys_pwrite64+0xaa/0xb0
[102331.753738]  [<ffffffff8100ba1b>] system_call_fastpath+0x16/0x1b
