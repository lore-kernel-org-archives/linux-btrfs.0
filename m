From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: WARNING: at fs/btrfs/extent-tree.c:5703
Date: Sun, 7 Aug 2011 17:02:16 -0500
Message-ID: <CAKcLGm9aeV7zkCd_HxOOA0w9=67YjufnSWV_DhW+hExRq7R8mQ@mail.gmail.com>
References: <4E3911F2.3090001@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E3911F2.3090001@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/8/3 Tsutomu Itoh <t-itoh@jp.fujitsu.com>:
> I ran subvol & balance test script at current for-linus branch, I got
> following warning messages.
>
> Thanks,
> Tsutomu
>
>
> Aug =A03 17:54:01 luna kernel: [21310.079308] ------------[ cut here =
]------------
> Aug =A03 17:54:01 luna kernel: [21310.079326] WARNING: at fs/btrfs/ex=
tent-tree.c:5703 btrfs_alloc_free_block+0xc4/0x286 [btrfs]()
> Aug =A03 17:54:01 luna kernel: [21310.079329] Hardware name: PRIMERGY
> Aug =A03 17:54:01 luna kernel: [21310.079331] Modules linked in: btrf=
s zlib_deflate crc32c libcrc32c autofs4 sunrpc 8021q garp stp llc cpufr=
eq_ondemand acpi_cpufreq freq_table mperf ipv6 ext3 jbd dm_mirror dm_re=
gion_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i=
2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3=
000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif sr_mod cdr=
om megaraid_sas pata_acpi ata_generic ata_piix libata scsi_mod floppy [=
last unloaded: microcode]
> Aug =A03 17:54:01 luna kernel: [21310.079374] Pid: 28048, comm: btrfs=
-freespace Tainted: G =A0 =A0 =A0 =A0W =A0 3.0.0test2+ #1
> Aug =A03 17:54:01 luna kernel: [21310.079377] Call Trace:
> Aug =A03 17:54:01 luna kernel: [21310.079383] =A0[<ffffffff81045426>]=
 warn_slowpath_common+0x85/0x9d
> Aug =A03 17:54:01 luna kernel: [21310.079387] =A0[<ffffffff81045458>]=
 warn_slowpath_null+0x1a/0x1c
> Aug =A03 17:54:01 luna kernel: [21310.079401] =A0[<ffffffffa037d63a>]=
 btrfs_alloc_free_block+0xc4/0x286 [btrfs]
> Aug =A03 17:54:01 luna kernel: [21310.079414] =A0[<ffffffffa0370ebc>]=
 split_leaf+0x2d2/0x52a [btrfs]
> Aug =A03 17:54:01 luna kernel: [21310.079427] =A0[<ffffffffa036e4be>]=
 ? btrfs_leaf_free_space+0x3a/0x7e [btrfs]
> Aug =A03 17:54:01 luna kernel: [21310.079439] =A0[<ffffffffa037224c>]=
 btrfs_search_slot+0x558/0x5fc [btrfs]
> Aug =A03 17:54:01 luna kernel: [21310.079455] =A0[<ffffffffa037fa42>]=
 btrfs_csum_file_blocks+0x20b/0x54f [btrfs]
> Aug =A03 17:54:01 luna kernel: [21310.079473] =A0[<ffffffffa038a430>]=
 add_pending_csums+0x3b/0x57 [btrfs]
> Aug =A03 17:54:01 luna kernel: [21310.079491] =A0[<ffffffffa0391a63>]=
 btrfs_finish_ordered_io+0x239/0x2bb [btrfs]
> Aug =A03 17:54:01 luna kernel: [21310.079509] =A0[<ffffffffa0391b44>]=
 btrfs_writepage_end_io_hook+0x5f/0x7a [btrfs]
> Aug =A03 17:54:01 luna kernel: [21310.079528] =A0[<ffffffffa03a05e2>]=
 end_bio_extent_writepage+0xae/0x159 [btrfs]
> Aug =A03 17:54:01 luna kernel: [21310.079545] =A0[<ffffffffa0383a23>]=
 ? end_workqueue_fn+0x106/0x120 [btrfs]
> Aug =A03 17:54:01 luna kernel: [21310.079549] =A0[<ffffffff811370e7>]=
 bio_endio+0x2d/0x2f
> Aug =A03 17:54:01 luna kernel: [21310.079564] =A0[<ffffffffa0383a2e>]=
 end_workqueue_fn+0x111/0x120 [btrfs]
> Aug =A03 17:54:01 luna kernel: [21310.079582] =A0[<ffffffffa03a8abf>]=
 worker_loop+0x18a/0x4bb [btrfs]
> Aug =A03 17:54:01 luna kernel: [21310.079600] =A0[<ffffffffa03a8935>]=
 ? btrfs_queue_worker+0x224/0x224 [btrfs]
> Aug =A03 17:54:01 luna kernel: [21310.079618] =A0[<ffffffffa03a8935>]=
 ? btrfs_queue_worker+0x224/0x224 [btrfs]
> Aug =A03 17:54:01 luna kernel: [21310.079621] =A0[<ffffffff810608ac>]=
 kthread+0x82/0x8a
> Aug =A03 17:54:01 luna kernel: [21310.079625] =A0[<ffffffff813ac2a4>]=
 kernel_thread_helper+0x4/0x10
> Aug =A03 17:54:01 luna kernel: [21310.079629] =A0[<ffffffff8106082a>]=
 ? kthread_worker_fn+0x14a/0x14a
> Aug =A03 17:54:01 luna kernel: [21310.079633] =A0[<ffffffff813ac2a0>]=
 ? gs_change+0x13/0x13
> Aug =A03 17:54:01 luna kernel: [21310.079635] ---[ end trace f6966ebb=
fde87a2f ]---
>
>
> [fs/btrfs/extent-tree.c]
> 5699 =A0 =A0 =A0 =A0 ret =3D block_rsv_use_bytes(block_rsv, blocksize=
);
> 5700 =A0 =A0 =A0 =A0 if (!ret)
> 5701 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return block_rsv;
> 5702 =A0 =A0 =A0 =A0 if (ret) {
> 5703 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(1);
> 5704 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D reserve_metadata_bytes(t=
rans, root, block_rsv, blocksize,
> 5705 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A00);
> 5706 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ret) {
>
>

I have also run across this WARNING.

The backtrace is slightly different, but the WARNING was at the same
point in extent-tree.c

[  306.932565] ------------[ cut here ]------------
[  306.932581] WARNING: at fs/btrfs/extent-tree.c:5703
btrfs_alloc_free_block+0x9d/0x460()
[  306.932584] Hardware name:
[  306.932585] Modules linked in: nvidia(P) snd_intel8x0 forcedeth
i2c_nforce2 snd_ac97_codec ac97_bus
[  306.932596] Pid: 3088, comm: btrfs-freespace Tainted: P        W
3.0.0-git-local-v2+ #1
[  306.932599] Call Trace:
[  306.932607]  [<c1031222>] warn_slowpath_common+0x72/0xa0
[  306.932611]  [<c12e867d>] ? btrfs_alloc_free_block+0x9d/0x460
[  306.932615]  [<c12e867d>] ? btrfs_alloc_free_block+0x9d/0x460
[  306.932619]  [<c1031272>] warn_slowpath_null+0x22/0x30
[  306.932623]  [<c12e867d>] btrfs_alloc_free_block+0x9d/0x460
[  306.932629]  [<c13180d7>] ? map_private_extent_buffer+0x77/0x110
[  306.932633]  [<c130d3fd>] ? btrfs_item_offset+0x3d/0x80
[  306.932640]  [<c12d60b5>] ? leaf_space_used+0x85/0xb0
[  306.932645]  [<c12da942>] split_leaf+0x102/0x680
[  306.932650]  [<c12db801>] btrfs_search_slot+0x731/0x7b0
[  306.932656]  [<c12ee260>] btrfs_csum_file_blocks+0x4a0/0x600
[  306.932660]  [<c131249c>] ? free_extent_state+0x2c/0x40
[  306.932664]  [<c1312a37>] ? clear_extent_bit+0x107/0x4f0
[  306.932669]  [<c12f91cd>] add_pending_csums.clone.30+0x3d/0x60
[  306.932673]  [<c12fcfe8>] btrfs_finish_ordered_io+0x278/0x3b0
[  306.932678]  [<c12fd163>] btrfs_writepage_end_io_hook+0x43/0xa0
[  306.932682]  [<c1312fa1>] end_bio_extent_writepage+0x181/0x1c0
[  306.932688]  [<c103d5bd>] ? lock_timer_base.clone.26+0x1d/0x40
[  306.932692]  [<c12fd120>] ? btrfs_finish_ordered_io+0x3b0/0x3b0
[  306.932699]  [<c1103959>] bio_endio+0x19/0x30
[  306.932703]  [<c12f03f5>] end_workqueue_fn+0x125/0x180
[  306.932707]  [<c103d590>] ? cascade+0x80/0x80
[  306.932712]  [<c131fe01>] worker_loop+0x91/0x350
[  306.932717]  [<c1022238>] ? __wake_up_common+0x48/0x70
[  306.932733]  [<c131fd70>] ? btrfs_queue_worker+0x240/0x240
[  306.932740]  [<c104c094>] kthread+0x74/0x80
[  306.932744]  [<c104c020>] ? kthread_worker_fn+0x110/0x110
[  306.932752]  [<c170b2f6>] kernel_thread_helper+0x6/0x10
[  306.932754] ---[ end trace 2304d1d1bfe7619c ]---
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
