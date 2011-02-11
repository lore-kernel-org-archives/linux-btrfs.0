From: Andrew Lutomirski <andy@luto.us>
Subject: Re: 2.6.37: Multi-second I/O latency while untarring
Date: Fri, 11 Feb 2011 14:56:00 -0500
Message-ID: <AANLkTinj-Nn-j9t0+bSWc=gD+M+zeyeN52LPCZEe4466@mail.gmail.com>
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

Big dump at end of email from latencytop git + your patch.

>
> Based on what you have here, I think it's probably a latency problem
> between btrfs and the dm-crypt stuff. =A0How easily can setup a test
> partition without dm-crypt?

Not so easily on that disk.  I left some space inside the LVM to play
with but none outside.

I'll try hooking up another disk over eSATA l (on a Cougar Point 3Gbps
controller, so it might blow up).


And here's the dump:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D Fri Feb 11 14:44:07 2011
Globals: Cause Maximum Percentage
synchronous write	4249.1 msec         35.5 %
Writing to a pipe	4248.5 msec         35.5 %
Writing a page to disk	105.9 msec          2.1 %
Page fault	 23.7 msec          0.2 %
Reading from a pipe	  4.7 msec         19.8 %
Waiting for event (select)	  4.6 msec          6.4 %
Waiting for event (poll)	  1.3 msec          0.0 %
Executing raw SCSI command	  1.3 msec          0.2 %
opening cdrom device	  1.3 msec          0.3 %
Process details:
Process ksoftirqd/1 (10) Total:  50.0 msec
	[run_ksoftirqd]	  4.8 msec        100.0 %
		run_ksoftirqd kthread kernel_thread_helper
Process ksoftirqd/2 (15) Total:   8.7 msec
	[run_ksoftirqd]	  4.9 msec        100.0 %
		run_ksoftirqd kthread kernel_thread_helper
Process ksoftirqd/3 (19) Total:   2.9 msec
	[run_ksoftirqd]	  2.9 msec        100.0 %
		run_ksoftirqd kthread kernel_thread_helper
Process ksoftirqd/5 (27) Total:  80.6 msec
	[run_ksoftirqd]	  5.0 msec        100.0 %
		run_ksoftirqd kthread kernel_thread_helper
Process scsi_eh_1 (62) Total:  45.0 msec
	Executing internal ATA command	  0.7 msec         62.3 %
		ata_exec_internal_sg ata_exec_internal atapi_eh_request_sense
		ata_eh_link_autopsy ata_eh_autopsy sata_pmp_error_handler
		ahci_error_handler ata_scsi_error scsi_error_handler kthread
		kernel_thread_helper
	SCSI error handler	  0.6 msec         37.7 %
		scsi_error_handler kthread kernel_thread_helper
Process kworker/7:1 (76) Total:   8.7 msec
	.	  3.9 msec        100.0 %
		worker_thread kthread kernel_thread_helper
Process kworker/4:1 (139) Total: 124.0 msec
	.	  4.9 msec        100.0 %
		worker_thread kthread kernel_thread_helper
Process kworker/6:1 (140) Total:  11.7 msec
	.	  3.8 msec        100.0 %
		worker_thread kthread kernel_thread_helper
Process kworker/5:1 (141) Total:  12.5 msec
	.	  4.9 msec        100.0 %
		worker_thread kthread kernel_thread_helper
Process kworker/2:1 (142) Total:  26.1 msec
	.	  4.9 msec        100.0 %
		worker_thread kthread kernel_thread_helper
Process kworker/1:1 (143) Total:  47.1 msec
	.	  4.9 msec        100.0 %
		worker_thread kthread kernel_thread_helper
Process kworker/3:1 (150) Total:   4.6 msec
	.	  3.1 msec        100.0 %
		worker_thread kthread kernel_thread_helper
Process jbd2/dm-1-8 (376) Total:  66.7 msec
	Writing buffer to disk (synchronous)	 66.7 msec        100.0 %
		sync_buffer __wait_on_buffer wait_on_buffer
		jbd2_journal_commit_transaction kjournald2 kthread
		kernel_thread_helper
Process btrfs-submit-0 (829) Total: 1719.4 msec
	[worker_loop]	  2.2 msec        100.0 %
		worker_loop kthread kernel_thread_helper
Process btrfs-endio-met (833) Total: 540.5 msec
	[worker_loop]	  4.8 msec        100.0 %
		worker_loop kthread kernel_thread_helper
Process btrfs-freespace (836) Total:  31.7 msec
	[worker_loop]	  1.8 msec        100.0 %
		worker_loop kthread kernel_thread_helper
Process btrfs-transacti (838) Total: 5567.3 msec
	Writing buffer to disk (synchronous)	352.5 msec          6.8 %
		sync_buffer __wait_on_buffer write_dev_supers write_all_supers
		write_ctree_super btrfs_commit_transaction transaction_kthread
		kthread kernel_thread_helper
	Writing a page to disk	 91.4 msec         93.2 %
		sync_page wait_on_page_bit read_extent_buffer_pages
		btree_read_extent_buffer_pages.clone.56 read_tree_block
		read_block_for_search.clone.38 btrfs_search_slot
		lookup_inline_extent_backref __btrfs_free_extent
		run_clustered_refs btrfs_run_delayed_refs
		btrfs_commit_transaction
Process hald-addon-stor (1349) Total:  39.5 msec
	Executing raw SCSI command	  1.3 msec         49.1 %
		blk_execute_rq scsi_execute scsi_execute_req
		sr_test_unit_ready sr_drive_status cdrom_ioctl sr_block_ioctl
		__blkdev_driver_ioctl blkdev_ioctl block_ioctl do_vfs_ioctl
		sys_ioctl
	opening cdrom device	  1.3 msec         43.4 %
		blk_execute_rq scsi_execute scsi_execute_req
		sr_test_unit_ready sr_media_change media_changed
		cdrom_media_changed sr_block_media_changed check_disk_change
		cdrom_open sr_block_open __blkdev_get
	SCSI cdrom ioctl	  0.6 msec          7.5 %
		blk_execute_rq scsi_execute sr_do_ioctl sr_packet
		cdrom_get_media_event sr_drive_status cdrom_ioctl
		sr_block_ioctl __blkdev_driver_ioctl blkdev_ioctl block_ioctl
		do_vfs_ioctl
Process gdm-binary (1486) Total:   0.3 msec
	Waiting for event (poll)	  0.3 msec        100.0 %
		poll_schedule_timeout do_sys_poll sys_poll
		system_call_fastpath
Process Xorg (1520) Total:   0.9 msec
	[i915_do_wait_request]	  0.3 msec         70.7 %
		i915_do_wait_request i915_gem_object_wait_rendering
		i915_gem_object_set_to_gtt_domain i915_gem_set_domain_ioctl
		drm_ioctl do_vfs_ioctl sys_ioctl system_call_fastpath
Process upowerd (1645) Total:   0.2 msec
	Waiting for event (poll)	  0.2 msec        100.0 %
		poll_schedule_timeout do_sys_poll sys_poll
		system_call_fastpath
Process gnome-session (1752) Total:   0.1 msec
	Waiting for event (poll)	  0.1 msec        100.0 %
		poll_schedule_timeout do_sys_poll sys_poll
		system_call_fastpath
Process udisks-daemon (1880) Total:   0.1 msec
	Waiting for event (poll)	  0.1 msec        100.0 %
		poll_schedule_timeout do_sys_poll sys_poll
		system_call_fastpath
Process udisks-daemon (1881) Total:  19.2 msec
	opening cdrom device	  1.2 msec         88.1 %
		blk_execute_rq scsi_execute scsi_execute_req
		sr_test_unit_ready sr_media_change media_changed
		cdrom_media_changed sr_block_media_changed check_disk_change
		cdrom_open sr_block_open __blkdev_get
	Executing raw SCSI command	  0.5 msec         11.9 %
		blk_execute_rq scsi_execute scsi_execute_req
		ioctl_internal_command.clone.3 scsi_set_medium_removal
		sr_lock_door cdrom_release sr_block_release __blkdev_put
		blkdev_put blkdev_close fput
Process bluetooth-apple (1915) Total:   0.2 msec
	Waiting for event (poll)	  0.2 msec        100.0 %
		poll_schedule_timeout do_sys_poll sys_poll
		system_call_fastpath
Process gpk-update-icon (1942) Total:   0.2 msec
	Waiting for event (poll)	  0.2 msec        100.0 %
		poll_schedule_timeout do_sys_poll sys_poll
		system_call_fastpath
Process gnome-screensav (2040) Total:   0.3 msec
	Waiting for event (poll)	  0.2 msec        100.0 %
		poll_schedule_timeout do_sys_poll sys_poll
		system_call_fastpath
Process flush-btrfs-1 (2120) Total: 173.3 msec
	Writing a page to disk	161.4 msec        100.0 %
		sync_page __lock_page lock_page
		extent_write_cache_pages.clone.11.clone.18 extent_writepages
		btrfs_writepages do_writepages writeback_single_inode
		writeback_sb_inodes writeback_inodes_wb wb_writeback
		wb_do_writeback
Process btrfs-delalloc- (2402) Total:   0.2 msec
	[worker_loop]	  0.2 msec        100.0 %
		worker_loop kthread kernel_thread_helper
Process btrfs-endio-met (2408) Total:  52.1 msec
	[worker_loop]	  2.5 msec        100.0 %
		worker_loop kthread kernel_thread_helper
Process btrfs-endio-wri (2768) Total: 1561.5 msec
	[worker_loop]	  4.1 msec        100.0 %
		worker_loop kthread kernel_thread_helper
Process compiz (6845) Total:   0.8 msec
	Waiting for event (poll)	  0.2 msec        100.0 %
		poll_schedule_timeout do_sys_poll sys_poll
		system_call_fastpath
Process clock-applet (6928) Total:   1.4 msec
	Waiting for event (poll)	  1.3 msec        100.0 %
		poll_schedule_timeout do_sys_poll sys_poll
		system_call_fastpath
Process kworker/0:0 (20743) Total: 1867.9 msec
	.	  5.0 msec        100.0 %
		worker_thread kthread kernel_thread_helper
Process tar (22372) Total: 6614.1 msec
	synchronous write	4249.1 msec         64.2 %
		btrfs_throttle btrfs_file_aio_write do_sync_write vfs_write
		sys_write system_call_fastpath
	Reading from a pipe	  4.7 msec         35.8 %
		pipe_wait pipe_read do_sync_read vfs_read sys_read
		system_call_fastpath
Process ssh (22533) Total: 4974.4 msec
	Writing to a pipe	4248.5 msec         85.4 %
		start_transaction btrfs_join_transaction btrfs_dirty_inode
		__mark_inode_dirty file_update_time pipe_write do_sync_write
		vfs_write sys_write system_call_fastpath
	Waiting for event (select)	  4.6 msec         14.6 %
		poll_schedule_timeout do_select core_sys_select sys_select
		system_call_fastpath
Process kworker/u:3 (23092) Total: 1901.4 msec
	Creating block layer request	 14.7 msec         84.7 %
		get_request_wait __make_request generic_make_request
		kcryptd_crypt_write_io_submit kcryptd_crypt process_one_work
		worker_thread kthread kernel_thread_helper
	.	  4.7 msec         15.3 %
		worker_thread kthread kernel_thread_helper
Process kworker/u:0 (23763) Total: 2108.1 msec
	.	  5.0 msec        100.0 %
		worker_thread kthread kernel_thread_helper
Process packagekitd (24691) Total:   0.2 msec
	Waiting for event (poll)	  0.2 msec        100.0 %
		poll_schedule_timeout do_sys_poll sys_poll
		system_call_fastpath
Process sshd (24718) Total:  35.8 msec
	Waiting for event (select)	  3.1 msec         99.9 %
		poll_schedule_timeout do_select core_sys_select sys_select
		system_call_fastpath
Process bash (24719) Total:   5.1 msec
	Reading from a pipe	  1.0 msec         82.5 %
		pipe_wait pipe_read do_sync_read vfs_read sys_read
		system_call_fastpath
	Waiting for a process to die	  0.9 msec         17.5 %
		do_wait sys_wait4 system_call_fastpath


It seems a little sad that ssh took a big latency hit just marking the
fifo dirty.

--Andy
