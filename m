From: Andrew Lutomirski <andy@luto.us>
Subject: Re: 2.6.37: Multi-second I/O latency while untarring
Date: Fri, 11 Feb 2011 19:35:02 -0500
Message-ID: <AANLkTimLeCMFO++RYnCXOPSMeNzxf2SAovEZ-q-q5TzF@mail.gmail.com>
References: <AANLkTin4628kHMRogoAarDWyGGb8-6-BiixihJmy_AUj@mail.gmail.com> <1297438671-sup-21@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1297438671-sup-21@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 11, 2011 at 10:44 AM, Chris Mason <chris.mason@oracle.com> =
wrote:
> Excerpts from Andrew Lutomirski's message of 2011-02-11 10:08:52 -050=
0:
>> As I type this, I have an ssh process running that's dumping data in=
to
>> a fifo at high speed (maybe 500Mbps) and a tar process that's
>> untarring from the same fifo onto btrfs. =A0The btrfs fs is mounted =
-o
>> space_cache,compress. =A0This machine has 8GB ram, 8 logical cores, =
and
>> a fast (i7-2600) CPU, so it's not an issue with the machine struggli=
ng
>> under load.
>>
>> Every few tens of seconds, my system stalls for several seconds.
>> These stalls cause keyboard input to be lost, firefox to hang, etc.
>>
>> Setting tar's ionice priority to best effort / 7 or to idle makes no=
 difference.
>>
>> ionice idle and queue_depth =3D 1 on the disk (a slow 2TB WD) also m=
akes
>> no difference.
>>
>> max_sectors_kb =3D 64 in addition to the above doesn't help either.
>>
>> latencytop shows regular instances of 2-7 *second* latency, variousl=
y
>> in sync_page, start_transaction, btrfs_start_ordered_extent, and
>> do_get_write_access (from jbd2 on my ext4 root partition).
>>
>> echo 3 >drop_caches gave me 7 GB free RAM. =A0I still had stalls whe=
n
>> 4-5 GB were still free (so it shouldn't be a problem with important
>> pages being evicted).
>>
>> In case it matters, all of my partitions are on LVM on dm-crypt, but
>> this machine has AES-NI so the overhead from that should be minimal.
>> In fact, overall CPU usage is only about 10%.
>>
>> What gives? =A0I thought this stuff was supposed to be better on mod=
ern kernels.
>
> We can tell more if you post the full traces from latencytop. =A0I ha=
ve a
> patch here for latencytop that adds a -c mode, which dumps the traces
> out to a text files.
>
> http://oss.oracle.com/~mason/latencytop.patch
>
> Based on what you have here, I think it's probably a latency problem
> between btrfs and the dm-crypt stuff. =A0How easily can setup a test
> partition without dm-crypt?

Done, on the same physical disk as before.  The latency is just as
bad.  On this test, I wrote a total of 3.1G, which is under half of my
RAM.  That should rule out lots of VM issues.  latencytop trace below.

The impression I get (from watching the disk activity light) is that
the disk is mostly idle but every now and then writes out a ton of
data.  While it's writing, the system often becomes unusable.

P.S.  How bad is this?  I got it on both disks.
btrfs: free space inode generation (0) did not match free space cache
generation (11070) for block group 1103101952




=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D Fri Feb 11 19:30:57 2011
Globals: Cause Maximum Percentage
Writing a page to disk	2009.0 msec         19.7 %
fsync() on a file (type 'F' for details)	612.2 msec          5.0 %
synchronous write	573.6 msec          1.8 %
Page fault	 57.3 msec          0.7 %
Writing buffer to disk (synchronous)	 45.2 msec          0.1 %
Unlinking file	 12.6 msec          0.0 %
Waiting for event (select)	  5.0 msec         22.3 %
Reading from a pipe	  5.0 msec         29.9 %
Waiting for event (poll)	  5.0 msec         17.8 %
Process details:
Process kthreadd (2) Total:   1.9 msec
	kthreadd kernel thread	  1.9 msec        100.0 %
		kthreadd kernel_thread_helper
Process ksoftirqd/0 (3) Total:  18.5 msec
	[run_ksoftirqd]	  4.0 msec        100.0 %
		run_ksoftirqd kthread kernel_thread_helper
Process ksoftirqd/1 (10) Total:  19.6 msec
	[run_ksoftirqd]	  4.9 msec        100.0 %
		run_ksoftirqd kthread kernel_thread_helper
Process kworker/0:1 (11) Total: 556.3 msec
	.	  5.0 msec        100.0 %
		worker_thread kthread kernel_thread_helper
Process ksoftirqd/2 (15) Total:   8.1 msec
	[run_ksoftirqd]	  2.9 msec        100.0 %
		run_ksoftirqd kthread kernel_thread_helper
Process ksoftirqd/4 (23) Total:  11.2 msec
	[run_ksoftirqd]	  4.3 msec        100.0 %
		run_ksoftirqd kthread kernel_thread_helper
Process scsi_eh_1 (62) Total:  38.8 msec
	SCSI error handler	  0.9 msec         39.9 %
		scsi_error_handler kthread kernel_thread_helper
	Executing internal ATA command	  0.7 msec         60.1 %
		ata_exec_internal_sg ata_exec_internal atapi_eh_request_sense
		ata_eh_link_autopsy ata_eh_autopsy sata_pmp_error_handler
		ahci_error_handler ata_scsi_error scsi_error_handler kthread
		kernel_thread_helper
Process kworker/u:4 (69) Total: 616.5 msec
	Creating block layer request	 54.9 msec         77.8 %
		get_request_wait __make_request generic_make_request
		kcryptd_crypt_write_io_submit kcryptd_crypt process_one_work
		worker_thread kthread kernel_thread_helper
	.	  5.0 msec         22.2 %
		worker_thread kthread kernel_thread_helper
Process kworker/u:5 (70) Total: 1712.3 msec
	Creating block layer request	492.8 msec         94.3 %
		get_request_wait __make_request generic_make_request
		kcryptd_io process_one_work worker_thread kthread
		kernel_thread_helper
	.	  4.9 msec          5.7 %
		worker_thread kthread kernel_thread_helper
Process kworker/7:1 (76) Total:   5.7 msec
	.	  4.8 msec        100.0 %
		worker_thread kthread kernel_thread_helper
Process kworker/5:1 (117) Total:  31.9 msec
	.	  4.9 msec        100.0 %
		worker_thread kthread kernel_thread_helper
Process kworker/6:1 (118) Total:  13.6 msec
	.	  4.9 msec        100.0 %
		worker_thread kthread kernel_thread_helper
Process kworker/1:1 (119) Total: 126.3 msec
	.	  4.9 msec        100.0 %
		worker_thread kthread kernel_thread_helper
Process kworker/4:1 (120) Total: 377.5 msec
	.	  5.0 msec        100.0 %
		worker_thread kthread kernel_thread_helper
Process kworker/2:1 (131) Total:  73.1 msec
	.	  4.9 msec        100.0 %
		worker_thread kthread kernel_thread_helper
Process kworker/3:1 (132) Total:  30.7 msec
	.	  4.9 msec        100.0 %
		worker_thread kthread kernel_thread_helper
Process jbd2/dm-1-8 (372) Total: 137.4 msec
	Writing buffer to disk (synchronous)	127.3 msec         92.8 %
		sync_buffer __wait_on_buffer wait_on_buffer
		jbd2_journal_commit_transaction kjournald2 kthread
		kernel_thread_helper
	Writing a page to disk	  9.9 msec          7.2 %
		sync_page wait_on_page_bit filemap_fdatawait_range
		filemap_fdatawait jbd2_journal_commit_transaction kjournald2
		kthread kernel_thread_helper
Process btrfs-worker-0 (828) Total:   4.6 msec
	[worker_loop]	  2.2 msec        100.0 %
		worker_loop kthread kernel_thread_helper
Process btrfs-submit-0 (830) Total:   5.8 msec
	[worker_loop]	  2.3 msec        100.0 %
		worker_loop kthread kernel_thread_helper
Process btrfs-delalloc- (831) Total:   1.1 msec
	[worker_loop]	  1.1 msec        100.0 %
		worker_loop kthread kernel_thread_helper
Process btrfs-endio-0 (833) Total:  69.1 msec
	[worker_loop]	  4.7 msec        100.0 %
		worker_loop kthread kernel_thread_helper
Process btrfs-endio-met (834) Total:  56.0 msec
	[worker_loop]	  4.5 msec        100.0 %
		worker_loop kthread kernel_thread_helper
Process btrfs-endio-met (835) Total:  19.8 msec
	[worker_loop]	  4.8 msec        100.0 %
		worker_loop kthread kernel_thread_helper
Process btrfs-freespace (837) Total:  10.0 msec
	[worker_loop]	  1.4 msec        100.0 %
		worker_loop kthread kernel_thread_helper
Process btrfs-transacti (841) Total: 3271.2 msec
	Writing a page to disk	507.8 msec         89.5 %
		sync_page __lock_page lock_page
		extent_write_cache_pages.clone.11.clone.18 extent_writepages
		btrfs_writepages do_writepages __filemap_fdatawrite_range
		filemap_flush btrfs_run_ordered_operations
		btrfs_commit_transaction transaction_kthread
	Writing buffer to disk (synchronous)	305.5 msec         10.5 %
		sync_buffer __wait_on_buffer write_dev_supers write_all_supers
		write_ctree_super btrfs_commit_transaction transaction_kthread
		kthread kernel_thread_helper
Process hald-addon-inpu (1347) Total:   5.4 msec
	Waiting for event (poll)	  5.0 msec        100.0 %
		poll_schedule_timeout do_sys_poll sys_poll
		system_call_fastpath
Process hald-addon-stor (1362) Total:  48.2 msec
	Opening file	  3.5 msec         21.7 %
		bd_prepare_to_claim bd_start_claiming blkdev_open
		__dentry_open nameidata_to_filp do_last do_filp_open
		do_sys_open sys_open system_call_fastpath
	Executing raw SCSI command	  1.2 msec         38.7 %
		blk_execute_rq scsi_execute scsi_execute_req
		sr_test_unit_ready sr_drive_status cdrom_ioctl sr_block_ioctl
		__blkdev_driver_ioctl blkdev_ioctl block_ioctl do_vfs_ioctl
		sys_ioctl
	opening cdrom device	  1.2 msec         33.4 %
		blk_execute_rq scsi_execute scsi_execute_req
		sr_test_unit_ready sr_media_change media_changed
		cdrom_media_changed sr_block_media_changed check_disk_change
		cdrom_open sr_block_open __blkdev_get
	SCSI cdrom ioctl	  0.6 msec          6.2 %
		blk_execute_rq scsi_execute sr_do_ioctl sr_packet
		cdrom_get_media_event sr_drive_status cdrom_ioctl
		sr_block_ioctl __blkdev_driver_ioctl blkdev_ioctl block_ioctl
		do_vfs_ioctl
Process Xorg (1533) Total: 4718.6 msec
	Waiting for event (select)	  5.0 msec         93.8 %
		poll_schedule_timeout do_select core_sys_select sys_select
		system_call_fastpath
	[i915_do_wait_request]	  4.3 msec          3.5 %
		i915_do_wait_request i915_gem_object_wait_rendering
		i915_gem_do_execbuffer.clone.29 i915_gem_execbuffer2 drm_ioctl
		do_vfs_ioctl sys_ioctl system_call_fastpath
	[__mutex_fastpath_lock_retval]	  3.4 msec          2.7 %
		__mutex_fastpath_lock_retval i915_mutex_lock_interruptible
		i915_gem_pwrite_ioctl drm_ioctl do_vfs_ioctl sys_ioctl
		system_call_fastpath
	Waiting for TTY data	  0.3 msec          0.0 %
		flush_work flush_delayed_work tty_flush_to_ldisc
		input_available_p n_tty_poll tty_poll do_select
		core_sys_select sys_select system_call_fastpath
Process gnome-settings- (1857) Total:  18.1 msec
	Waiting for event (poll)	  3.9 msec        100.0 %
		poll_schedule_timeout do_sys_poll sys_poll
		system_call_fastpath
Process flush-btrfs-1 (1865) Total:   0.7 msec
	Writing a page to disk	  0.1 msec        100.0 %
		sync_page __lock_page lock_page
		extent_write_cache_pages.clone.11.clone.18 extent_writepages
		btrfs_writepages do_writepages writeback_single_inode
		writeback_sb_inodes writeback_inodes_wb wb_writeback
		wb_do_writeback
Process nautilus (1884) Total:   0.5 msec
	Waiting for event (poll)	  0.2 msec        100.0 %
		poll_schedule_timeout do_sys_poll sys_poll
		system_call_fastpath
Process compiz (1893) Total: 650.6 msec
	Waiting for event (poll)	  5.0 msec         79.4 %
		poll_schedule_timeout do_sys_poll sys_poll
		system_call_fastpath
	[i915_do_wait_request]	  2.5 msec         20.2 %
		i915_do_wait_request i915_gem_object_wait_rendering
		i915_gem_do_execbuffer.clone.29 i915_gem_execbuffer2 drm_ioctl
		do_vfs_ioctl sys_ioctl system_call_fastpath
	[__mutex_fastpath_lock_retval]	  1.0 msec          0.4 %
		__mutex_fastpath_lock_retval i915_mutex_lock_interruptible
		i915_gem_set_domain_ioctl drm_ioctl do_vfs_ioctl sys_ioctl
		system_call_fastpath
Process wnck-applet (1927) Total:   2.6 msec
	Waiting for event (poll)	  0.7 msec        100.0 %
		poll_schedule_timeout do_sys_poll sys_poll
		system_call_fastpath
Process udisks-daemon (2005) Total:  24.1 msec
	Opening file	  3.3 msec         53.0 %
		bd_prepare_to_claim bd_start_claiming blkdev_open
		__dentry_open nameidata_to_filp do_last do_filp_open
		do_sys_open sys_open system_call_fastpath
	opening cdrom device	  1.2 msec         41.6 %
		blk_execute_rq scsi_execute scsi_execute_req
		sr_test_unit_ready sr_media_change media_changed
		cdrom_media_changed sr_block_media_changed check_disk_change
		cdrom_open sr_block_open __blkdev_get
	Executing raw SCSI command	  0.4 msec          5.4 %
		blk_execute_rq scsi_execute scsi_execute_req
		ioctl_internal_command.clone.3 scsi_set_medium_removal
		sr_lock_door cdrom_release sr_block_release __blkdev_put
		blkdev_put blkdev_close fput
Process btrfs-worker-3 (2097) Total:   1.1 msec
	[worker_loop]	  0.6 msec        100.0 %
		worker_loop kthread kernel_thread_helper
Process btrfs-worker-4 (2098) Total:   0.4 msec
	[worker_loop]	  0.2 msec        100.0 %
		worker_loop kthread kernel_thread_helper
Process gtk-window-deco (2133) Total:  69.0 msec
	Page fault	 57.3 msec         83.1 %
		sync_page wait_on_page_bit wait_on_page_locked
		__lock_page_or_retry filemap_fault __do_fault handle_mm_fault
		do_page_fault page_fault
	Waiting for event (poll)	  3.8 msec         16.9 %
		poll_schedule_timeout do_sys_poll sys_poll
		system_call_fastpath
Process gvfsd-trash (2152) Total: 495.5 msec
	Waiting for event (poll)	  5.0 msec        100.0 %
		poll_schedule_timeout do_sys_poll sys_poll
		system_call_fastpath
Process gnome-terminal (2185) Total: 483.3 msec
	Waiting for event (poll)	  4.0 msec        100.0 %
		poll_schedule_timeout do_sys_poll sys_poll
		system_call_fastpath
Process firefox (2426) Total: 5028.3 msec
	Writing a page to disk	867.7 msec         48.5 %
		sync_page wait_on_page_bit read_extent_buffer_pages
		btree_read_extent_buffer_pages.clone.56 read_tree_block
		read_block_for_search.clone.38 btrfs_search_slot
		btrfs_lookup_csum __btrfs_lookup_bio_sums
		btrfs_lookup_bio_sums btrfs_submit_bio_hook submit_one_bio

	fsync() on a file (type 'F' for details)	612.2 msec         24.4 %
		sync_page __lock_page lock_page
		extent_write_cache_pages.clone.11.clone.18 extent_writepages
		btrfs_writepages do_writepages __filemap_fdatawrite_range
		filemap_write_and_wait_range vfs_fsync_range vfs_fsync
		do_fsync
	synchronous write	573.6 msec         11.4 %
		start_transaction btrfs_join_transaction btrfs_dirty_inode
		__mark_inode_dirty file_update_time btrfs_file_aio_write
		do_sync_write vfs_write sys_write system_call_fastpath

	Page fault	 57.0 msec          2.9 %
		sync_page wait_on_page_bit wait_on_page_locked
		__lock_page_or_retry filemap_fault __do_fault handle_mm_fault
		do_page_fault page_fault
	Writing buffer to disk (synchronous)	 45.2 msec          0.9 %
		sync_buffer __wait_on_buffer ext4_find_entry ext4_lookup
		d_alloc_and_lookup do_lookup do_last do_filp_open do_sys_open
		sys_open system_call_fastpath
	Unlinking file	 12.6 msec          0.3 %
		btrfs_tree_lock btrfs_search_slot btrfs_insert_empty_items
		run_clustered_refs btrfs_run_delayed_refs
		__btrfs_end_transaction btrfs_end_transaction_throttle
		__unlink_end_trans btrfs_unlink vfs_unlink do_unlinkat
		sys_unlink
	Waiting for event (poll)	  4.9 msec          5.9 %
		poll_schedule_timeout do_sys_poll sys_poll
		system_call_fastpath
	Userspace lock contention	  4.9 msec          5.7 %
		futex_wait_queue_me futex_wait do_futex sys_futex
		system_call_fastpath
Process btrfs-delalloc- (2453) Total:   1.8 msec
	[worker_loop]	  1.1 msec        100.0 %
		worker_loop kthread kernel_thread_helper
Process btrfs-endio-wri (2454) Total:  44.7 msec
	Writing a page to disk	 31.1 msec         98.1 %
		sync_page wait_on_page_bit read_extent_buffer_pages
		btree_read_extent_buffer_pages.clone.56 read_tree_block
		read_block_for_search.clone.38 btrfs_search_slot
		btrfs_insert_empty_items alloc_reserved_file_extent.clone.57
		run_clustered_refs btrfs_run_delayed_refs
		__btrfs_end_transaction
	[worker_loop]	  0.7 msec          1.9 %
		worker_loop kthread kernel_thread_helper
Process btrfs-endio-wri (2460) Total: 819.2 msec
	Writing a page to disk	532.4 msec         99.8 %
		sync_page __lock_page lock_page read_extent_buffer_pages
		btree_read_extent_buffer_pages.clone.56 read_tree_block
		reada_for_balance btrfs_search_slot btrfs_csum_file_blocks
		add_pending_csums.clone.29 btrfs_finish_ordered_io
		btrfs_writepage_end_io_hook
	[worker_loop]	  0.8 msec          0.2 %
		worker_loop kthread kernel_thread_helper
Process btrfs-endio-met (2464) Total: 146.5 msec
	[worker_loop]	  4.7 msec        100.0 %
		worker_loop kthread kernel_thread_helper
Process btrfs-genwork-0 (2573) Total:   2.1 msec
	[worker_loop]	  1.8 msec         87.6 %
		worker_loop kthread kernel_thread_helper
	[kthread_create]	  0.1 msec         12.4 %
		kthread_create __btrfs_start_workers btrfs_start_workers
		start_new_worker_func worker_loop kthread kernel_thread_helper

Process btrfs-submit-0 (2574) Total: 2797.6 msec
	Creating block layer request	484.7 msec         99.9 %
		get_request_wait __make_request generic_make_request
		submit_bio run_scheduled_bios pending_bios_fn worker_loop
		kthread kernel_thread_helper
	[worker_loop]	  0.1 msec          0.1 %
		worker_loop kthread kernel_thread_helper
Process btrfs-endio-met (2579) Total:   5.1 msec
	[worker_loop]	  1.9 msec        100.0 %
		worker_loop kthread kernel_thread_helper
Process btrfs-endio-wri (2580) Total: 146.3 msec
	[worker_loop]	  5.0 msec        100.0 %
		worker_loop kthread kernel_thread_helper
Process btrfs-freespace (2581) Total:   0.4 msec
	[worker_loop]	  0.4 msec        100.0 %
		worker_loop kthread kernel_thread_helper
Process btrfs-transacti (2583) Total: 479.7 msec
	Writing buffer to disk (synchronous)	466.0 msec         97.2 %
		sync_buffer __wait_on_buffer write_dev_supers write_all_supers
		write_ctree_super btrfs_commit_transaction transaction_kthread
		kthread kernel_thread_helper
	Writing a page to disk	  6.4 msec          2.8 %
		sync_page wait_on_page_bit filemap_fdatawait_range
		filemap_fdatawait filemap_write_and_wait btrfs_write_out_cache
		btrfs_write_dirty_block_groups commit_cowonly_roots
		btrfs_commit_transaction transaction_kthread kthread
		kernel_thread_helper
Process ssh (2659) Total: 2559.8 msec
	Waiting for event (select)	  4.9 msec        100.0 %
		poll_schedule_timeout do_select core_sys_select sys_select
		system_call_fastpath
Process tar (2662) Total: 9364.3 msec
	Reading from a pipe	  5.0 msec        100.0 %
		pipe_wait pipe_read do_sync_read vfs_read sys_read
		system_call_fastpath
Process btrfs-endio-wri (2741) Total:   1.1 msec
	[worker_loop]	  1.0 msec         97.6 %
		worker_loop kthread kernel_thread_helper
Process btrfs-endio-met (2742) Total:   2.4 msec
	[worker_loop]	  1.8 msec         99.1 %
		worker_loop kthread kernel_thread_helper
Process btrfs-endio-met (2743) Total:   2.3 msec
	[worker_loop]	  1.8 msec         99.9 %
		worker_loop kthread kernel_thread_helper
Process bash (2753) Total: 483.3 msec
	Waiting for event (poll)	  4.0 msec        100.0 %
		poll_schedule_timeout do_sys_poll sys_poll
		system_call_fastpath
Process btrfs-endio-wri (2790) Total:   1.9 msec
	kthreadd kernel thread	  1.9 msec        100.0 %
		kthreadd kernel_thread_helper
Process sudo (2792) Total: 483.3 msec
	Waiting for event (poll)	  4.0 msec        100.0 %
		poll_schedule_timeout do_sys_poll sys_poll
		system_call_fastpath
Process latencytop (2798) Total: 486.0 msec
	Waiting for event (poll)	  4.0 msec         99.4 %
		poll_schedule_timeout do_sys_poll sys_poll
		system_call_fastpath
	Waiting for a process to die	  2.1 msec          0.6 %
		do_wait sys_wait4 system_call_fastpath
