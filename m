From: Jacek Luczak <difrost.kernel@gmail.com>
Subject: WARNING: at fs/btrfs/extent-tree.c:5985
Date: Tue, 6 Mar 2012 22:14:40 +0100
Message-ID: <CADDYkjRAUxA7n2zv1H8dfbLd29n+sZGVaRBVcTr23j_QubbJoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

I've noticed today below WARN_ON from btrfs. Google shows hits in the
same place ([1] and [2]) but the path is different. It could happen
when svn checout or few rsyncs were running - now I'm not able to put
in correct timings. There's  btrfs_item_offset() in backtrace and I
was not able to find it from btrfs kernel code - there's _nr instead.
Am I blind?

I will try to reproduce this. Any hints based on code path how could
it be triggered?

Cheers,
-Jacek

[1] http://www.spinics.net/lists/linux-btrfs/msg15229.html
[2] https://bugzilla.redhat.com/show_bug.cgi?id=789632

------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:5985
btrfs_alloc_free_block+0xc5/0x292 [btrfs]()
Hardware name: ProLiant BL460c G6
Modules linked in: btrfs zlib_deflate lzo_compress ext4 jbd2 crc16
ipmi_devintf autofs4 be2iscsi iscsi_boot_sysfs ib_iser rdma_cm ib_cm
iw_cm ib_sa ib_mad ib_addr iscsi_tcp bnx2i cnic uio ipv6 cxgb3i
libcxgbi iw_cxgb3 ib_core cxgb3 libiscsi_tcp libiscsi
scsi_transport_iscsi dm_mirror dm_region_hash dm_log dm_multipath
video battery acpi_pad acpi_ipmi ac parport usbhid evdev
acpi_power_meter radeon ttm drm_kms_helper drm hwmon backlight
i2c_algo_bit ipmi_si bnx2x ipmi_msghandler i2c_core hpilo hpwdt
psmouse mdio ehci_hcd uhci_hcd
Pid: 4865, comm: flush-btrfs-11 Tainted: G        W    3.2.7 #2
Call Trace:
 [<ffffffffa038461f>] ? btrfs_alloc_free_block+0xc5/0x292 [btrfs]
 [<ffffffff8106901d>] ? warn_slowpath_common+0x78/0x8d
 [<ffffffffa038461f>] ? btrfs_alloc_free_block+0xc5/0x292 [btrfs]
 [<ffffffffa039ebad>] ? btrfs_item_offset+0x2c/0x61 [btrfs]
 [<ffffffffa03737dc>] ? leaf_space_used+0x86/0xb5 [btrfs]
 [<ffffffffa0377a7a>] ? split_leaf+0x2d9/0x632 [btrfs]
 [<ffffffffa0379261>] ? btrfs_search_slot+0x6c1/0x75a [btrfs]
 [<ffffffffa0379e6e>] ? btrfs_insert_empty_items+0x61/0xab [btrfs]
 [<ffffffffa039507c>] ? insert_inline_extent+0xea/0x2d4 [btrfs]
 [<ffffffffa0395389>] ? cow_file_range_inline+0x123/0x163 [btrfs]
 [<ffffffffa038fc2c>] ? start_transaction+0x1d5/0x205 [btrfs]
 [<ffffffffa0397137>] ? cow_file_range+0x113/0x337 [btrfs]
 [<ffffffffa0379653>] ? btrfs_next_leaf+0x359/0x36a [btrfs]
 [<ffffffffa0397d7b>] ? run_delalloc_nocow+0x5d9/0x673 [btrfs]
 [<ffffffffa0397e8b>] ? run_delalloc_range+0x76/0x338 [btrfs]
 [<ffffffff811ef37c>] ? blk_queue_bio+0x2db/0x2fb
 [<ffffffffa03a9367>] ? __extent_writepage+0x259/0x689 [btrfs]
 [<ffffffff811eef50>] ? generic_make_request+0x90/0xde
 [<ffffffff811ef06a>] ? submit_bio+0xcc/0xd5
 [<ffffffffa03a4fcc>] ? extent_writepages+0x1cc/0x2d5 [btrfs]
 [<ffffffffa0398ed4>] ? uncompress_inline+0x141/0x141 [btrfs]
 [<ffffffff81137956>] ? writeback_single_inode+0x109/0x291
 [<ffffffff81137fde>] ? writeback_sb_inodes+0x156/0x1fe
 [<ffffffff81138461>] ? wb_writeback+0x10a/0x1f8
 [<ffffffff81073b4b>] ? lock_timer_base+0x26/0x4b
 [<ffffffff811385bb>] ? wb_do_writeback+0x6c/0x1c1
 [<ffffffff813e2e22>] ? schedule_timeout+0x1d6/0x1f4
 [<ffffffff81073c7b>] ? msleep+0x1e/0x1e
 [<ffffffff81138802>] ? bdi_writeback_thread+0x7d/0x1c1
 [<ffffffff81138785>] ? wakeup_flusher_threads+0x75/0x75
 [<ffffffff810822aa>] ? kthread+0x7e/0x86
 [<ffffffff813e6a74>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff8108222c>] ? kthread_stop+0xa8/0xa8
 [<ffffffff813e6a70>] ? gs_change+0x13/0x13
---[ end trace 1547a049b7c6896a ]---
use_block_rsv: 11 callbacks suppressed
btrfs: block rsv returned -28
------------[ cut here ]------------
