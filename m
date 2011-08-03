From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: WARNING: at fs/btrfs/extent-tree.c:5703
Date: Wed, 03 Aug 2011 18:16:34 +0900
Message-ID: <4E3911F2.3090001@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: Chris Mason <chris.mason@Oracle.COM>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I ran subvol & balance test script at current for-linus branch, I got
following warning messages.

Thanks,
Tsutomu


Aug  3 17:54:01 luna kernel: [21310.079308] ------------[ cut here ]------------
Aug  3 17:54:01 luna kernel: [21310.079326] WARNING: at fs/btrfs/extent-tree.c:5703 btrfs_alloc_free_block+0xc4/0x286 [btrfs]()
Aug  3 17:54:01 luna kernel: [21310.079329] Hardware name: PRIMERGY
Aug  3 17:54:01 luna kernel: [21310.079331] Modules linked in: btrfs zlib_deflate crc32c libcrc32c autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif sr_mod cdrom megaraid_sas pata_acpi ata_generic ata_piix libata scsi_mod floppy [last unloaded: microcode]
Aug  3 17:54:01 luna kernel: [21310.079374] Pid: 28048, comm: btrfs-freespace Tainted: G        W   3.0.0test2+ #1
Aug  3 17:54:01 luna kernel: [21310.079377] Call Trace:
Aug  3 17:54:01 luna kernel: [21310.079383]  [<ffffffff81045426>] warn_slowpath_common+0x85/0x9d
Aug  3 17:54:01 luna kernel: [21310.079387]  [<ffffffff81045458>] warn_slowpath_null+0x1a/0x1c
Aug  3 17:54:01 luna kernel: [21310.079401]  [<ffffffffa037d63a>] btrfs_alloc_free_block+0xc4/0x286 [btrfs]
Aug  3 17:54:01 luna kernel: [21310.079414]  [<ffffffffa0370ebc>] split_leaf+0x2d2/0x52a [btrfs]
Aug  3 17:54:01 luna kernel: [21310.079427]  [<ffffffffa036e4be>] ? btrfs_leaf_free_space+0x3a/0x7e [btrfs]
Aug  3 17:54:01 luna kernel: [21310.079439]  [<ffffffffa037224c>] btrfs_search_slot+0x558/0x5fc [btrfs]
Aug  3 17:54:01 luna kernel: [21310.079455]  [<ffffffffa037fa42>] btrfs_csum_file_blocks+0x20b/0x54f [btrfs]
Aug  3 17:54:01 luna kernel: [21310.079473]  [<ffffffffa038a430>] add_pending_csums+0x3b/0x57 [btrfs]
Aug  3 17:54:01 luna kernel: [21310.079491]  [<ffffffffa0391a63>] btrfs_finish_ordered_io+0x239/0x2bb [btrfs]
Aug  3 17:54:01 luna kernel: [21310.079509]  [<ffffffffa0391b44>] btrfs_writepage_end_io_hook+0x5f/0x7a [btrfs]
Aug  3 17:54:01 luna kernel: [21310.079528]  [<ffffffffa03a05e2>] end_bio_extent_writepage+0xae/0x159 [btrfs]
Aug  3 17:54:01 luna kernel: [21310.079545]  [<ffffffffa0383a23>] ? end_workqueue_fn+0x106/0x120 [btrfs]
Aug  3 17:54:01 luna kernel: [21310.079549]  [<ffffffff811370e7>] bio_endio+0x2d/0x2f
Aug  3 17:54:01 luna kernel: [21310.079564]  [<ffffffffa0383a2e>] end_workqueue_fn+0x111/0x120 [btrfs]
Aug  3 17:54:01 luna kernel: [21310.079582]  [<ffffffffa03a8abf>] worker_loop+0x18a/0x4bb [btrfs]
Aug  3 17:54:01 luna kernel: [21310.079600]  [<ffffffffa03a8935>] ? btrfs_queue_worker+0x224/0x224 [btrfs]
Aug  3 17:54:01 luna kernel: [21310.079618]  [<ffffffffa03a8935>] ? btrfs_queue_worker+0x224/0x224 [btrfs]
Aug  3 17:54:01 luna kernel: [21310.079621]  [<ffffffff810608ac>] kthread+0x82/0x8a
Aug  3 17:54:01 luna kernel: [21310.079625]  [<ffffffff813ac2a4>] kernel_thread_helper+0x4/0x10
Aug  3 17:54:01 luna kernel: [21310.079629]  [<ffffffff8106082a>] ? kthread_worker_fn+0x14a/0x14a
Aug  3 17:54:01 luna kernel: [21310.079633]  [<ffffffff813ac2a0>] ? gs_change+0x13/0x13
Aug  3 17:54:01 luna kernel: [21310.079635] ---[ end trace f6966ebbfde87a2f ]---


[fs/btrfs/extent-tree.c]
5699         ret = block_rsv_use_bytes(block_rsv, blocksize);
5700         if (!ret)
5701                 return block_rsv;
5702         if (ret) {
5703                 WARN_ON(1);
5704                 ret = reserve_metadata_bytes(trans, root, block_rsv, blocksize,
5705                                              0);
5706                 if (!ret) {


