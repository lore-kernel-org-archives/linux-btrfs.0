From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: btrfs hung tasks
Date: Thu, 28 Jul 2011 09:46:47 +0100
Message-ID: <chaz20110728084647.GC967@seebyte.com>
References: <20110728062343.GA4656@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110728062343.GA4656@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-28 07:23:43 +0100, Stephane Chazelas:
> Hiya, I got below those last night. That was 3 minutes after a
> bunch of rsync and ntfsclone processes started.
> 
> It's the first time it happens. I upgraded from 3.0rc6 to 3.0
> yesterday.
[...]

And again this morning, though at that point only one ntfsclone
process was actively writing to the FS.

At this point, I can read directories and stat(2) files on that
FS, but reading or writing files hangs.

I'll try and revert to 3.0rc6 to see if that makes a difference.
call traces for some processes trying to read from the FS:

cat             D ffff8801424ee240     0  3478      1 0x00000005
 ffff8801424ee240 0000000000000086 ffff8801080497e8 ffff8800494322e0
 ffff8801461908b0 0000000000012800 ffff880108049fd8 ffff880108049fd8
 0000000000012800 ffff8801424ee240 0000000000012800 0000000000012800
Call Trace:
 [<ffffffff813367ec>] ? _raw_spin_lock_irqsave+0x9/0x25
 [<ffffffffa02d989c>] ? btrfs_tree_lock+0x9a/0xa7 [btrfs]
 [<ffffffffa02d9754>] ? btrfs_spin_on_block+0x49/0x49 [btrfs]
 [<ffffffffa0297edb>] ? btrfs_set_path_blocking+0x21/0x32 [btrfs]
 [<ffffffffa029ba81>] ? btrfs_search_slot+0x3c6/0x4d6 [btrfs]
 [<ffffffffa02a923a>] ? btrfs_lookup_csum+0x65/0x105 [btrfs]
 [<ffffffffa02c9bb2>] ? btrfs_lookup_ordered_extent+0x2b/0x69 [btrfs]
 [<ffffffffa02ca1fa>] ? btrfs_find_ordered_sum+0x34/0xcc [btrfs]
 [<ffffffffa02a9449>] ? __btrfs_lookup_bio_sums+0x16f/0x2ed [btrfs]
 [<ffffffffa02e3bb8>] ? btrfs_submit_compressed_read+0x3b7/0x42e [btrfs]
 [<ffffffffa02ca73b>] ? submit_one_bio+0x85/0xbc [btrfs]
 [<ffffffffa02cc880>] ? submit_extent_page.clone.16+0x118/0x1b9 [btrfs]
 [<ffffffffa02cc290>] ? check_page_uptodate+0x36/0x36 [btrfs]
 [<ffffffffa02ccda4>] ? __extent_read_full_page+0x463/0x4cc [btrfs]
 [<ffffffffa02cc290>] ? check_page_uptodate+0x36/0x36 [btrfs]
 [<ffffffffa02b4e09>] ? uncompress_inline.clone.32+0x117/0x117 [btrfs]
 [<ffffffffa02cd92b>] ? extent_readpages+0xb1/0xf6 [btrfs]
 [<ffffffffa02b4e09>] ? uncompress_inline.clone.32+0x117/0x117 [btrfs]
 [<ffffffff810be21b>] ? __do_page_cache_readahead+0x124/0x1c8
 [<ffffffff810be526>] ? ra_submit+0x1c/0x23
 [<ffffffff810b6e9e>] ? generic_file_aio_read+0x2a7/0x5c7
 [<ffffffff810fb5f1>] ? do_sync_read+0xb1/0xea
 [<ffffffff81336815>] ? _raw_spin_lock_irq+0xd/0x1a
 [<ffffffff810fbc10>] ? vfs_read+0x9f/0xf2
 [<ffffffff81012599>] ? syscall_trace_enter+0xb5/0x15d
 [<ffffffff810fbca8>] ? sys_read+0x45/0x6b
 [<ffffffff8133bca7>] ? tracesys+0xd9/0xde


wc              D ffff8801424ef710     0  3495      1 0x00000005
 ffff8801424ef710 0000000000000086 ffffffff811ab802 ffff88014951f5c0
 ffffffff8160b020 0000000000012800 ffff880109617fd8 ffff880109617fd8
 0000000000012800 ffff8801424ef710 0000000000012800 0000000000012800
Call Trace:
 [<ffffffff811ab802>] ? delay_tsc+0x2b/0x68
 [<ffffffff813367ec>] ? _raw_spin_lock_irqsave+0x9/0x25
 [<ffffffffa02d989c>] ? btrfs_tree_lock+0x9a/0xa7 [btrfs]
 [<ffffffffa02d9754>] ? btrfs_spin_on_block+0x49/0x49 [btrfs]
 [<ffffffffa02ce989>] ? map_private_extent_buffer+0xa3/0xc4 [btrfs]
 [<ffffffffa029816d>] ? btrfs_lock_root_node+0x1d/0x3f [btrfs]
 [<ffffffffa029b7a1>] ? btrfs_search_slot+0xe6/0x4d6 [btrfs]
 [<ffffffffa02ac5a1>] ? btrfs_header_generation.clone.17+0xf/0x14 [btrfs]
 [<ffffffffa02a923a>] ? btrfs_lookup_csum+0x65/0x105 [btrfs]
 [<ffffffffa02c9bb2>] ? btrfs_lookup_ordered_extent+0x2b/0x69 [btrfs]
 [<ffffffffa02ca1fa>] ? btrfs_find_ordered_sum+0x34/0xcc [btrfs]
 [<ffffffffa02a9449>] ? __btrfs_lookup_bio_sums+0x16f/0x2ed [btrfs]
 [<ffffffffa02b3226>] ? btrfs_submit_bio_hook+0xa4/0x129 [btrfs]
 [<ffffffffa02ca73b>] ? submit_one_bio+0x85/0xbc [btrfs]
 [<ffffffffa02cc880>] ? submit_extent_page.clone.16+0x118/0x1b9 [btrfs]
 [<ffffffffa02cc290>] ? check_page_uptodate+0x36/0x36 [btrfs]
 [<ffffffffa02ccda4>] ? __extent_read_full_page+0x463/0x4cc [btrfs]
 [<ffffffffa02cc290>] ? check_page_uptodate+0x36/0x36 [btrfs]
 [<ffffffffa02b4e09>] ? uncompress_inline.clone.32+0x117/0x117 [btrfs]
 [<ffffffffa02cd92b>] ? extent_readpages+0xb1/0xf6 [btrfs]
 [<ffffffffa02b4e09>] ? uncompress_inline.clone.32+0x117/0x117 [btrfs]
 [<ffffffff810be21b>] ? __do_page_cache_readahead+0x124/0x1c8
 [<ffffffff810be526>] ? ra_submit+0x1c/0x23
 [<ffffffff810b6e62>] ? generic_file_aio_read+0x26b/0x5c7
 [<ffffffff810fb5f1>] ? do_sync_read+0xb1/0xea
 [<ffffffff81336815>] ? _raw_spin_lock_irq+0xd/0x1a
 [<ffffffff810fbc10>] ? vfs_read+0x9f/0xf2
 [<ffffffff81012599>] ? syscall_trace_enter+0xb5/0x15d
 [<ffffffff810fbca8>] ? sys_read+0x45/0x6b
 [<ffffffff8133bca7>] ? tracesys+0xd9/0xde


tail            D ffff88014651b750     0  3442   1844 0x00000004
 ffff88014651b750 0000000000000082 ffff880147b06508 ffffffff00000000
 ffff8801495660c0 0000000000012800 ffff88010e05dfd8 ffff88010e05dfd8
 0000000000012800 ffff88014651b750 0000000000012800 0000000000012800
Call Trace:
 [<ffffffff81335e18>] ? __mutex_lock_common.clone.5+0x114/0x179
 [<ffffffff81335cf1>] ? mutex_lock+0x1a/0x2d
 [<ffffffff810fb6d8>] ? generic_file_llseek+0x21/0x52
 [<ffffffff810fb745>] ? sys_lseek+0x3c/0x59
 [<ffffffff8133ba92>] ? system_call_fastpath+0x16/0x1b


rm              D ffff8801424bd060     0  3504      1 0x00000005
 ffff8801424bd060 0000000000000086 0000000000000000 0000000000000001
 ffff8801495660c0 0000000000012800 ffff880118b21fd8 ffff880118b21fd8
 0000000000012800 ffff8801424bd060 0000000000012800 0000000000012800
Call Trace:
 [<ffffffff813367ec>] ? _raw_spin_lock_irqsave+0x9/0x25
 [<ffffffffa02b0b91>] ? wait_current_trans.clone.22+0xa1/0xd0 [btrfs]
 [<ffffffff81060083>] ? wake_up_bit+0x23/0x23
 [<ffffffffa02b1d3f>] ? start_transaction+0xd9/0x227 [btrfs]
 [<ffffffffa02b2a3d>] ? __unlink_start_trans+0x52/0x399 [btrfs]
 [<ffffffff8103840a>] ? should_resched+0x5/0x24
 [<ffffffff8133565f>] ? _cond_resched+0x9/0x20
 [<ffffffff811038d1>] ? generic_permission+0xe/0x9b
 [<ffffffffa02b898f>] ? btrfs_unlink+0x1e/0xa4 [btrfs]
 [<ffffffff81104706>] ? vfs_unlink+0x65/0xbe
 [<ffffffff811068e3>] ? do_unlinkat+0xc6/0x14d
 [<ffffffff81011968>] ? ptrace_report_syscall.clone.8+0x27/0x4f
 [<ffffffff81012599>] ? syscall_trace_enter+0xb5/0x15d
 [<ffffffff8133bca7>] ? tracesys+0xd9/0xde


tee             D ffff88013d9d4140     0  3506      1 0x00000005
 ffff88013d9d4140 0000000000000082 ffff880142634c40 ffff880142634730
 ffffffff8160b020 0000000000012800 ffff88007e18bfd8 ffff88007e18bfd8
 0000000000012800 ffff88013d9d4140 0000000000012800 0000000000012800
Call Trace:
 [<ffffffff8103b012>] ? perf_event_task_sched_out+0x48/0x54
 [<ffffffff81335e18>] ? __mutex_lock_common.clone.5+0x114/0x179
 [<ffffffff81103865>] ? exec_permission+0x1f/0x7d
 [<ffffffff81335cf1>] ? mutex_lock+0x1a/0x2d
 [<ffffffff8110558f>] ? do_last+0x19b/0x584
 [<ffffffff81106bea>] ? path_openat+0xc7/0x349
 [<ffffffff81336815>] ? _raw_spin_lock_irq+0xd/0x1a
 [<ffffffff81106e98>] ? do_filp_open+0x2c/0x72
 [<ffffffff8133565f>] ? _cond_resched+0x9/0x20
 [<ffffffff811ac741>] ? __strncpy_from_user+0x19/0x4a
 [<ffffffff81110208>] ? alloc_fd+0x69/0x110
 [<ffffffff810fb138>] ? do_sys_open+0x5f/0xe6
 [<ffffffff8133bca7>] ? tracesys+0xd9/0xde


ntfsclone       D ffff88013e4fd160     0  2757   2601 0x00000004
 ffff88013e4fd160 0000000000000082 ffff88013f390710 ffffffff81023145
 ffff8801495660c0 0000000000012800 ffff8801094f1fd8 ffff8801094f1fd8
 0000000000012800 ffff88013e4fd160 0000000000012800 0000000000012800
Call Trace:
 [<ffffffff81023145>] ? _flat_send_IPI_mask+0x6a/0x7c
 [<ffffffff8100e342>] ? read_tsc+0x5/0x14
 [<ffffffff81066feb>] ? timekeeping_get_ns+0xd/0x2a
 [<ffffffff810b5c70>] ? lock_page+0x20/0x20
 [<ffffffff813354f3>] ? io_schedule+0x5b/0x75
 [<ffffffff810b5c79>] ? sleep_on_page+0x9/0x10
 [<ffffffff81335b74>] ? __wait_on_bit+0x3e/0x71
 [<ffffffff8103840a>] ? should_resched+0x5/0x24
 [<ffffffff8133565f>] ? _cond_resched+0x9/0x20
 [<ffffffff810b5e11>] ? wait_on_page_bit+0x6a/0x70
 [<ffffffff810600ad>] ? autoremove_wake_function+0x2a/0x2a
 [<ffffffffa02bd29e>] ? prepare_pages.clone.12+0x15b/0x2fd [btrfs]
 [<ffffffffa02bda5a>] ? __btrfs_buffered_write.clone.14+0x132/0x29a [btrfs]
 [<ffffffff81117b72>] ? inode_to_bdi+0x20/0x42
 [<ffffffffa02bdf5d>] ? btrfs_file_aio_write+0x39b/0x435 [btrfs]
 [<ffffffff810fb507>] ? do_sync_write+0xb1/0xea
 [<ffffffff81126459>] ? fsnotify+0x23d/0x24f
 [<ffffffff811650d9>] ? security_file_permission+0x18/0x33
 [<ffffffff810fbb1e>] ? vfs_write+0xa6/0xf9
 [<ffffffff810fbd13>] ? sys_write+0x45/0x6b
 [<ffffffff8133ba92>] ? system_call_fastpath+0x16/0x1b


Best regards,
Stephane
