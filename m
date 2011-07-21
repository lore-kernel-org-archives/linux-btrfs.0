From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: new metadata reader/writer locks in integration-test
Date: Thu, 21 Jul 2011 09:48:23 +0900
Message-ID: <4E277757.9070504@jp.fujitsu.com>
References: <1311096438-sup-1263@shiny> <1311182478-sup-9986@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1311182478-sup-9986@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

(2011/07/21 2:21), Chris Mason wrote:
> Excerpts from Chris Mason's message of 2011-07-19 13:30:22 -0400:
>> Hi everyone,
>>
>> I've pushed out a new integration-test branch, and it includes a new
>> reader/writer locking scheme for the btree locks.
>>
>> We've seen a number of benchmarks dominated by contention on the root
>> node lock.  This changes our locks into a simple reader/writer lock.
>> They are based on mutexes so that we still take advantage of the mutex
>> adaptive spins for write locks (rwsemaphores were much slower).
>>
>> I'm also sending the individual commits, please do take a look.
> 
> Hi everyone,
> 
> I just rebased Josef's enospc fixes into integration-test, it should fix
> the warnings in extent-tree.c
> 

Unfortunately, I got the following messages.


Jul 21 09:41:22 luna kernel: ------------[ cut here ]------------
Jul 21 09:41:22 luna kernel: WARNING: at fs/btrfs/extent-tree.c:5564 btrfs_alloc_reserved_file_extent+0xf8/0x100 [btrfs]()
Jul 21 09:41:22 luna kernel: Hardware name: PRIMERGY
Jul 21 09:41:22 luna kernel: Modules linked in: btrfs zlib_deflate crc32c libcrc32c autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif sr_mod cdrom megaraid_sas floppy pata_acpi ata_generic ata_piix libata scsi_mod [last unloaded: microcode]
Jul 21 09:41:22 luna kernel: Pid: 5517, comm: btrfs-endio-wri Tainted: G        W   2.6.39btrfs-tc1+ #1
Jul 21 09:41:22 luna kernel: Call Trace:
Jul 21 09:41:22 luna kernel: [<ffffffff8106004f>] warn_slowpath_common+0x7f/0xc0
Jul 21 09:41:22 luna kernel: [<ffffffff810600aa>] warn_slowpath_null+0x1a/0x20
Jul 21 09:41:22 luna kernel: [<ffffffffa044a068>] btrfs_alloc_reserved_file_extent+0xf8/0x100 [btrfs]
Jul 21 09:41:22 luna kernel: [<ffffffffa0464121>] insert_reserved_file_extent.clone.0+0x201/0x270 [btrfs]
Jul 21 09:41:22 luna kernel: [<ffffffffa0468c0b>] btrfs_finish_ordered_io+0x2eb/0x360 [btrfs]
Jul 21 09:41:22 luna kernel: [<ffffffff8106fe23>] ? try_to_del_timer_sync+0x83/0xe0
Jul 21 09:41:22 luna kernel: [<ffffffffa0468cd0>] btrfs_writepage_end_io_hook+0x50/0xa0 [btrfs]
Jul 21 09:41:22 luna kernel: [<ffffffffa049a3c6>] end_compressed_bio_write+0x86/0xf0 [btrfs]
Jul 21 09:41:22 luna kernel: [<ffffffff8117f96d>] bio_endio+0x1d/0x40
Jul 21 09:41:22 luna kernel: [<ffffffffa0459d84>] end_workqueue_fn+0xf4/0x130 [btrfs]
Jul 21 09:41:22 luna kernel: [<ffffffffa048841e>] worker_loop+0x13e/0x540 [btrfs]
Jul 21 09:41:22 luna kernel: [<ffffffffa04882e0>] ? btrfs_queue_worker+0x2d0/0x2d0 [btrfs]
Jul 21 09:41:22 luna kernel: [<ffffffffa04882e0>] ? btrfs_queue_worker+0x2d0/0x2d0 [btrfs]
Jul 21 09:41:22 luna kernel: [<ffffffff81081756>] kthread+0x96/0xa0
Jul 21 09:41:22 luna kernel: [<ffffffff81486004>] kernel_thread_helper+0x4/0x10
Jul 21 09:41:22 luna kernel: [<ffffffff810816c0>] ? kthread_worker_fn+0x1a0/0x1a0
Jul 21 09:41:22 luna kernel: [<ffffffff81486000>] ? gs_change+0x13/0x13
Jul 21 09:41:22 luna kernel: ---[ end trace 02c1fa3044677043 ]---

Jul 21 09:42:21 luna kernel: ------------[ cut here ]------------
Jul 21 09:42:21 luna kernel: WARNING: at fs/btrfs/extent-tree.c:3860 btrfs_free_block_groups+0x217/0x290 [btrfs]()
Jul 21 09:42:21 luna kernel: Hardware name: PRIMERGY
Jul 21 09:42:21 luna kernel: Modules linked in: btrfs zlib_deflate crc32c libcrc32c autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif sr_mod cdrom megaraid_sas floppy pata_acpi ata_generic ata_piix libata scsi_mod [last unloaded: microcode]
Jul 21 09:42:21 luna kernel: Pid: 26136, comm: umount Tainted: G        W   2.6.39btrfs-tc1+ #1
Jul 21 09:42:21 luna kernel: Call Trace:
Jul 21 09:42:21 luna kernel: [<ffffffff8106004f>] warn_slowpath_common+0x7f/0xc0
Jul 21 09:42:21 luna kernel: [<ffffffff810600aa>] warn_slowpath_null+0x1a/0x20
Jul 21 09:42:21 luna kernel: [<ffffffffa04493e7>] btrfs_free_block_groups+0x217/0x290 [btrfs]
Jul 21 09:42:21 luna kernel: [<ffffffffa045b069>] close_ctree+0x1e9/0x390 [btrfs]
Jul 21 09:42:21 luna kernel: [<ffffffff81168931>] ? dispose_list+0x41/0x60
Jul 21 09:42:21 luna kernel: [<ffffffff8147c5b6>] ? down_write+0x16/0x40
Jul 21 09:42:21 luna kernel: [<ffffffffa043a5dd>] btrfs_put_super+0x1d/0x30 [btrfs]
Jul 21 09:42:21 luna kernel: [<ffffffff81151d52>] generic_shutdown_super+0x72/0xf0
Jul 21 09:42:21 luna kernel: [<ffffffff81151e66>] kill_anon_super+0x16/0x60
Jul 21 09:42:21 luna kernel: [<ffffffff81152575>] deactivate_locked_super+0x45/0x70
Jul 21 09:42:21 luna kernel: [<ffffffff811531da>] deactivate_super+0x4a/0x70
Jul 21 09:42:21 luna kernel: [<ffffffff8116cadc>] mntput_no_expire+0x13c/0x1c0
Jul 21 09:42:21 luna kernel: [<ffffffff8116d2bb>] sys_umount+0x7b/0x3a0
Jul 21 09:42:21 luna kernel: [<ffffffff81484ec2>] system_call_fastpath+0x16/0x1b
Jul 21 09:42:21 luna kernel: ---[ end trace 02c1fa3044677044 ]---

Jul 21 09:42:21 luna kernel: ------------[ cut here ]------------
Jul 21 09:42:21 luna kernel: WARNING: at fs/btrfs/extent-tree.c:3861 btrfs_free_block_groups+0x285/0x290 [btrfs]()
Jul 21 09:42:21 luna kernel: Hardware name: PRIMERGY
Jul 21 09:42:21 luna kernel: Modules linked in: btrfs zlib_deflate crc32c libcrc32c autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif sr_mod cdrom megaraid_sas floppy pata_acpi ata_generic ata_piix libata scsi_mod [last unloaded: microcode]
Jul 21 09:42:21 luna kernel: Pid: 26136, comm: umount Tainted: G        W   2.6.39btrfs-tc1+ #1
Jul 21 09:42:21 luna kernel: Call Trace:
Jul 21 09:42:21 luna kernel: [<ffffffff8106004f>] warn_slowpath_common+0x7f/0xc0
Jul 21 09:42:21 luna kernel: [<ffffffff810600aa>] warn_slowpath_null+0x1a/0x20
Jul 21 09:42:21 luna kernel: [<ffffffffa0449455>] btrfs_free_block_groups+0x285/0x290 [btrfs]
Jul 21 09:42:21 luna kernel: [<ffffffffa045b069>] close_ctree+0x1e9/0x390 [btrfs]
Jul 21 09:42:21 luna kernel: [<ffffffff81168931>] ? dispose_list+0x41/0x60
Jul 21 09:42:21 luna kernel: [<ffffffff8147c5b6>] ? down_write+0x16/0x40
Jul 21 09:42:21 luna kernel: [<ffffffffa043a5dd>] btrfs_put_super+0x1d/0x30 [btrfs]
Jul 21 09:42:21 luna kernel: [<ffffffff81151d52>] generic_shutdown_super+0x72/0xf0
Jul 21 09:42:21 luna kernel: [<ffffffff81151e66>] kill_anon_super+0x16/0x60
Jul 21 09:42:21 luna kernel: [<ffffffff81152575>] deactivate_locked_super+0x45/0x70
Jul 21 09:42:21 luna kernel: [<ffffffff811531da>] deactivate_super+0x4a/0x70
Jul 21 09:42:21 luna kernel: [<ffffffff8116cadc>] mntput_no_expire+0x13c/0x1c0
Jul 21 09:42:21 luna kernel: [<ffffffff8116d2bb>] sys_umount+0x7b/0x3a0
Jul 21 09:42:21 luna kernel: [<ffffffff81484ec2>] system_call_fastpath+0x16/0x1b
Jul 21 09:42:21 luna kernel: ---[ end trace 02c1fa3044677045 ]---

Jul 21 09:42:21 luna kernel: ------------[ cut here ]------------
Jul 21 09:42:21 luna kernel: WARNING: at fs/btrfs/extent-tree.c:6923 btrfs_free_block_groups+0x1cb/0x290 [btrfs]()
Jul 21 09:42:21 luna kernel: Hardware name: PRIMERGY
Jul 21 09:42:21 luna kernel: Modules linked in: btrfs zlib_deflate crc32c libcrc32c autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif sr_mod cdrom megaraid_sas floppy pata_acpi ata_generic ata_piix libata scsi_mod [last unloaded: microcode]
Jul 21 09:42:21 luna kernel: Pid: 26136, comm: umount Tainted: G        W   2.6.39btrfs-tc1+ #1
Jul 21 09:42:21 luna kernel: Call Trace:
Jul 21 09:42:21 luna kernel: [<ffffffff8106004f>] warn_slowpath_common+0x7f/0xc0
Jul 21 09:42:21 luna kernel: [<ffffffff810600aa>] warn_slowpath_null+0x1a/0x20
Jul 21 09:42:21 luna kernel: [<ffffffffa044939b>] btrfs_free_block_groups+0x1cb/0x290 [btrfs]
Jul 21 09:42:21 luna kernel: [<ffffffffa045b069>] close_ctree+0x1e9/0x390 [btrfs]
Jul 21 09:42:21 luna kernel: [<ffffffff81168931>] ? dispose_list+0x41/0x60
Jul 21 09:42:21 luna kernel: [<ffffffff8147c5b6>] ? down_write+0x16/0x40
Jul 21 09:42:21 luna kernel: [<ffffffffa043a5dd>] btrfs_put_super+0x1d/0x30 [btrfs]
Jul 21 09:42:21 luna kernel: [<ffffffff81151d52>] generic_shutdown_super+0x72/0xf0
Jul 21 09:42:21 luna kernel: [<ffffffff81151e66>] kill_anon_super+0x16/0x60
Jul 21 09:42:21 luna kernel: [<ffffffff81152575>] deactivate_locked_super+0x45/0x70
Jul 21 09:42:21 luna kernel: [<ffffffff811531da>] deactivate_super+0x4a/0x70
Jul 21 09:42:21 luna kernel: [<ffffffff8116cadc>] mntput_no_expire+0x13c/0x1c0
Jul 21 09:42:21 luna kernel: [<ffffffff8116d2bb>] sys_umount+0x7b/0x3a0
Jul 21 09:42:21 luna kernel: [<ffffffff81484ec2>] system_call_fastpath+0x16/0x1b
Jul 21 09:42:21 luna kernel: ---[ end trace 02c1fa3044677046 ]---


