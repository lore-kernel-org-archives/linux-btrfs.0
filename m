From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: task imap:2958 blocked for more than 120 seconds
Date: Sun, 10 Jan 2010 21:05:46 +0100
Message-ID: <201001102105.47192.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753211Ab0AJUFz@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've observed this hanging task now several times. Not sure when this started, 
but 2.6.32 is affected too, IIRC. I don't have a test pattern for this. Dovecot 
imap triggers this from time to time. I've enabled CONFIG_DETECT_HUNG_TASK now 
and got this two tasks which hang:

INFO: task imap:2958 blocked for more than 120 seconds.                                                                                    
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.                                                                  
imap          D 0000000000000000     0  2958   2653 0x00000000                                                                             
 ffff88008caf5a28 0000000000000046 0000000000000000 ffffffff810544cf                                                                       
 ffff88008caf5998 0000000000000001 ffff88008caf5fd8 ffff88008caf9530                                                                       
 000000000000de78 00000000001d2700 00000000001d2700 ffff88008caf9530                                                                       
Call Trace:                                                                                                                                
 [<ffffffff810544cf>] ? trace_hardirqs_off+0xd/0xf                                                                                         
 [<ffffffff8105613b>] ? trace_hardirqs_on_caller+0x10c/0x130                                                                               
 [<ffffffff81071262>] ? sync_page+0x0/0x48                                                                                                 
 [<ffffffff8138b46a>] io_schedule+0x38/0x4d                                                                                                
 [<ffffffff810712a6>] sync_page+0x44/0x48                                                                                                  
 [<ffffffff8138b99a>] __wait_on_bit_lock+0x41/0x8a                                                                                         
 [<ffffffff8107124e>] __lock_page+0x61/0x68                                                                                                
 [<ffffffff810475a3>] ? wake_bit_function+0x0/0x2e                                                                                         
 [<ffffffff810718c6>] filemap_fault+0xea/0x345                                                                                             
 [<ffffffff81084022>] __do_fault+0x50/0x3d3                                                                                                
 [<ffffffff81086077>] handle_mm_fault+0x32f/0x65d                                                                                          
 [<ffffffff8102039d>] ? do_page_fault+0xf4/0x26f                                                                                           
 [<ffffffff811cacb4>] ? __down_read_trylock+0x46/0x4e                                                                                      
 [<ffffffff8104b0f3>] ? down_read_trylock+0x3f/0x49                                                                                        
 [<ffffffff8102039d>] ? do_page_fault+0xf4/0x26f                                                                                           
 [<ffffffff81020500>] do_page_fault+0x257/0x26f                                                                                            
 [<ffffffff8138e2ff>] page_fault+0x1f/0x30                                                                                                 
 [<ffffffff81083a13>] ? might_fault+0x57/0xa7                                                                                              
 [<ffffffff811746e2>] ? btrfs_copy_from_user+0x4f/0x113                                                                                    
 [<ffffffff81174771>] ? btrfs_copy_from_user+0xde/0x113                                                                                    
 [<ffffffff81174cd0>] btrfs_file_write+0x439/0x6fe                                                                                         
 [<ffffffff810a5c34>] vfs_write+0xad/0x14e                                                                                                 
 [<ffffffff8105613b>] ? trace_hardirqs_on_caller+0x10c/0x130                                                                               
 [<ffffffff810a5d2a>] sys_pwrite64+0x55/0x74                                                                                               
 [<ffffffff81001eeb>] system_call_fastpath+0x16/0x1b                                                                                       
2 locks held by imap/2958:                                                                                                                 
 #0:  (&sb->s_type->i_mutex_key#4){+.+.+.}, at: [<ffffffff81174a00>] 
btrfs_file_write+0x169/0x6fe                                          
 #1:  (&mm->mmap_sem){++++++}, at: [<ffffffff8102039d>] do_page_fault+0xf4/0x26f                                                           
INFO: task flush-btrfs-2:2783 blocked for more than 120 seconds.                                                                           
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.                                                                  
flush-btrfs-2 D 0000000000000000     0  2783      2 0x00000000                                                                             
 ffff88010cdcf9d0 0000000000000046 0000000000000000 ffffffff810544cf                                                                       
 ffff88010cdcf940 0000000000000000 ffff88010cdcffd8 ffff88010cd18290                                                                       
 000000000000de78 00000000001d2700 00000000001d2700 ffff88010cd18290                                                                       
Call Trace:                                                                                                                                
 [<ffffffff810544cf>] ? trace_hardirqs_off+0xd/0xf                                                                                         
 [<ffffffff8105613b>] ? trace_hardirqs_on_caller+0x10c/0x130                                                                               
 [<ffffffff81071262>] ? sync_page+0x0/0x48                                                                                                 
 [<ffffffff8138b46a>] io_schedule+0x38/0x4d                                                                                                
 [<ffffffff810712a6>] sync_page+0x44/0x48                                                                                                  
 [<ffffffff8138b99a>] __wait_on_bit_lock+0x41/0x8a                                                                                         
 [<ffffffff81070ce1>] ? find_get_pages_tag+0x0/0x130                                                                                       
 [<ffffffff8107124e>] __lock_page+0x61/0x68                                                                                                
 [<ffffffff810475a3>] ? wake_bit_function+0x0/0x2e                                                                                         
 [<ffffffff811871f6>] T.858+0xf1/0x2cd                                                                                                     
 [<ffffffff8104c4f9>] ? sched_clock_cpu+0xc6/0xd4                                                                                          
 [<ffffffff8104c3cd>] ? sched_clock_local+0x1c/0x82                                                                                        
 [<ffffffff8104c4f9>] ? sched_clock_cpu+0xc6/0xd4                                                                                          
 [<ffffffff810544cf>] ? trace_hardirqs_off+0xd/0xf                                                                                         
 [<ffffffff811874d3>] extent_writepages+0x3f/0x54                                                                                          
 [<ffffffff8116dbd5>] ? btrfs_get_extent+0x0/0x7ee                                                                                         
 [<ffffffff8116da7e>] btrfs_writepages+0x22/0x24                                                                                           
 [<ffffffff81077d12>] do_writepages+0x1f/0x28                                                                                              
 [<ffffffff810c0233>] writeback_single_inode+0xf1/0x2f0                                                                                    
 [<ffffffff810c0f57>] writeback_inodes_wb+0x3a9/0x4b2                                                                                      
 [<ffffffff810c118b>] wb_writeback+0x12b/0x1af                                                                                             
 [<ffffffff810c1436>] wb_do_writeback+0x17f/0x195                                                                                          
 [<ffffffff810c1342>] ? wb_do_writeback+0x8b/0x195                                                                                         
 [<ffffffff810c1477>] bdi_writeback_task+0x2b/0x84                                                                                         
 [<ffffffff81082a45>] ? bdi_start_fn+0x0/0xcf                                                                                              
 [<ffffffff81082ab6>] bdi_start_fn+0x71/0xcf                                                                                               
 [<ffffffff81082a45>] ? bdi_start_fn+0x0/0xcf
 [<ffffffff81047197>] kthread+0x7a/0x82
 [<ffffffff81002c94>] kernel_thread_helper+0x4/0x10
 [<ffffffff8138e0fc>] ? restore_args+0x0/0x30
 [<ffffffff8104711d>] ? kthread+0x0/0x82
 [<ffffffff81002c90>] ? kernel_thread_helper+0x0/0x10
1 lock held by flush-btrfs-2/2783:
 #0:  (&type->s_umount_key#20){++++..}, at: [<ffffffff810c0e82>] 
writeback_inodes_wb+0x2d4/0x4b2

regards,
  Johannes
