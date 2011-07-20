From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: new metadata reader/writer locks in integration-test
Date: Wed, 20 Jul 2011 11:08:38 +0900
Message-ID: <4E2638A6.2070404@jp.fujitsu.com>
References: <1311096438-sup-1263@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1311096438-sup-1263@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

(2011/07/20 2:30), Chris Mason wrote:
> Hi everyone,
> 
> I've pushed out a new integration-test branch, and it includes a new
> reader/writer locking scheme for the btree locks.
> 
> We've seen a number of benchmarks dominated by contention on the root
> node lock.  This changes our locks into a simple reader/writer lock.
> They are based on mutexes so that we still take advantage of the mutex
> adaptive spins for write locks (rwsemaphores were much slower).
> 
> I'm also sending the individual commits, please do take a look.

I pulled the new integration-test branch, and I got the following
warning messages.

Jul 20 10:03:30 luna kernel: ------------[ cut here ]------------
Jul 20 10:03:30 luna kernel: WARNING: at fs/btrfs/extent-tree.c:5704 btrfs_alloc_free_block+0x178/0x340 [btrfs]()
Jul 20 10:03:30 luna kernel: Hardware name: PRIMERGY
Jul 20 10:03:30 luna kernel: Modules linked in: btrfs zlib_deflate crc32c libcrc32c autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif sr_mod cdrom megaraid_sas pata_acpi ata_generic ata_piix libata scsi_mod floppy [last unloaded: microcode]
Jul 20 10:03:30 luna kernel: Pid: 8311, comm: btrfs-endio-wri Tainted: G        W   2.6.39btrfs-tc1+ #1
Jul 20 10:03:30 luna kernel: Call Trace:
Jul 20 10:03:30 luna kernel: [<ffffffff8106004f>] warn_slowpath_common+0x7f/0xc0
Jul 20 10:03:30 luna kernel: [<ffffffff810600aa>] warn_slowpath_null+0x1a/0x20
Jul 20 10:03:30 luna kernel: [<ffffffffa0455468>] btrfs_alloc_free_block+0x178/0x340 [btrfs]
Jul 20 10:03:30 luna kernel: [<ffffffffa047f377>] ? read_extent_buffer+0xb7/0x190 [btrfs]
Jul 20 10:03:30 luna kernel: [<ffffffffa04469ba>] split_leaf+0x14a/0x8c0 [btrfs]
Jul 20 10:03:30 luna kernel: [<ffffffffa044292a>] ? btrfs_leaf_free_space+0x8a/0xe0 [btrfs]
Jul 20 10:03:30 luna kernel: [<ffffffffa0447abc>] btrfs_search_slot+0x98c/0x9f0 [btrfs]
Jul 20 10:03:30 luna kernel: [<ffffffffa04730e4>] ? btrfs_drop_extents+0x7c4/0xa40 [btrfs]
Jul 20 10:03:30 luna kernel: [<ffffffffa0448aed>] btrfs_insert_empty_items+0x8d/0xf0 [btrfs]
Jul 20 10:03:30 luna kernel: [<ffffffffa047fdad>] ? set_extent_bit+0x22d/0x5d0 [btrfs]
Jul 20 10:03:30 luna kernel: [<ffffffffa0466f1e>] insert_reserved_file_extent.clone.0+0xbe/0x270 [btrfs]
Jul 20 10:03:30 luna kernel: [<ffffffffa046bb4b>] btrfs_finish_ordered_io+0x2eb/0x360 [btrfs]
Jul 20 10:03:30 luna kernel: [<ffffffffa046bc10>] btrfs_writepage_end_io_hook+0x50/0xa0 [btrfs]
Jul 20 10:03:30 luna kernel: [<ffffffffa049d306>] end_compressed_bio_write+0x86/0xf0 [btrfs]
Jul 20 10:03:30 luna kernel: [<ffffffff8117f96d>] bio_endio+0x1d/0x40
Jul 20 10:03:30 luna kernel: [<ffffffffa045ccd4>] end_workqueue_fn+0xf4/0x130 [btrfs]
Jul 20 10:03:30 luna kernel: [<ffffffffa048b35e>] worker_loop+0x13e/0x540 [btrfs]
Jul 20 10:03:30 luna kernel: [<ffffffffa048b220>] ? btrfs_queue_worker+0x2d0/0x2d0 [btrfs]
Jul 20 10:03:30 luna kernel: [<ffffffffa048b220>] ? btrfs_queue_worker+0x2d0/0x2d0 [btrfs]
Jul 20 10:03:30 luna kernel: [<ffffffff81081756>] kthread+0x96/0xa0
Jul 20 10:03:30 luna kernel: [<ffffffff81486004>] kernel_thread_helper+0x4/0x10
Jul 20 10:03:30 luna kernel: [<ffffffff810816c0>] ? kthread_worker_fn+0x1a0/0x1a0
Jul 20 10:03:30 luna kernel: [<ffffffff81486000>] ? gs_change+0x13/0x13
Jul 20 10:03:30 luna kernel: ---[ end trace c52e468b5140fdf0 ]---

Jul 20 10:07:27 luna kernel: ------------[ cut here ]------------
Jul 20 10:07:27 luna kernel: WARNING: at fs/btrfs/extent-tree.c:3860 btrfs_free_block_groups+0x217/0x290 [btrfs]()
Jul 20 10:07:27 luna kernel: Hardware name: PRIMERGY
Jul 20 10:07:27 luna kernel: Modules linked in: btrfs zlib_deflate crc32c libcrc32c autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif sr_mod cdrom megaraid_sas pata_acpi ata_generic ata_piix libata scsi_mod floppy [last unloaded: microcode]
Jul 20 10:07:27 luna kernel: Pid: 12632, comm: umount Tainted: G        W   2.6.39btrfs-tc1+ #1
Jul 20 10:07:27 luna kernel: Call Trace:
Jul 20 10:07:27 luna kernel: [<ffffffff8106004f>] warn_slowpath_common+0x7f/0xc0
Jul 20 10:07:27 luna kernel: [<ffffffff810600aa>] warn_slowpath_null+0x1a/0x20
Jul 20 10:07:27 luna kernel: [<ffffffffa044c3e7>] btrfs_free_block_groups+0x217/0x290 [btrfs]
Jul 20 10:07:27 luna kernel: [<ffffffffa045dfb9>] close_ctree+0x1e9/0x390 [btrfs]
Jul 20 10:07:27 luna kernel: [<ffffffff81168931>] ? dispose_list+0x41/0x60
Jul 20 10:07:27 luna kernel: [<ffffffff8147c5b6>] ? down_write+0x16/0x40
Jul 20 10:07:27 luna kernel: [<ffffffffa043d5dd>] btrfs_put_super+0x1d/0x30 [btrfs]
Jul 20 10:07:27 luna kernel: [<ffffffff81151d52>] generic_shutdown_super+0x72/0xf0
Jul 20 10:07:27 luna kernel: [<ffffffff81151e66>] kill_anon_super+0x16/0x60
Jul 20 10:07:27 luna kernel: [<ffffffff81152575>] deactivate_locked_super+0x45/0x70
Jul 20 10:07:27 luna kernel: [<ffffffff811531da>] deactivate_super+0x4a/0x70
Jul 20 10:07:27 luna kernel: [<ffffffff8116cadc>] mntput_no_expire+0x13c/0x1c0
Jul 20 10:07:27 luna kernel: [<ffffffff8116d2bb>] sys_umount+0x7b/0x3a0
Jul 20 10:07:27 luna kernel: [<ffffffff81484ec2>] system_call_fastpath+0x16/0x1b
Jul 20 10:07:27 luna kernel: ---[ end trace c52e468b5140fdf1 ]---

