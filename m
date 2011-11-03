From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: WARNING: at fs/btrfs/free-space-cache.c:305
Date: Thu, 03 Nov 2011 10:25:23 +0900
Message-ID: <4EB1ED83.8010301@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: Chris Mason <chris.mason@Oracle.COM>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In integration-scrub branch, following warning messages were displayed by
running xfstests.

# btrfs fi sh /dev/sdd4
Label: none  uuid: 8f28d85c-e37c-4c1b-adef-2627ca59be78
        Total devices 2 FS bytes used 31.49MB
        devid    1 size 9.31GB used 9.31GB path /dev/sdd4
        devid    2 size 15.01GB used 9.29GB path /dev/sdc1

Btrfs Btrfs v0.19
# mount
...
/dev/sdd4 on /test7 type btrfs (rw,compress=lzo)
#

Thanks,
Tsutomu

====================================================================================

Nov  3 09:55:18 luna kernel: [  939.732044] device fsid 8f28d85c-e37c-4c1b-adef-2627ca59be78 devid 1 transid 20510 /dev/sdd4
Nov  3 09:55:18 luna kernel: [  939.732533] btrfs: use lzo compression
Nov  3 09:55:18 luna kernel: [  939.732536] btrfs: disk space caching is enabled
Nov  3 09:55:18 luna kernel: [  939.898190] ------------[ cut here ]------------
Nov  3 09:55:18 luna kernel: [  939.898223] WARNING: at fs/btrfs/free-space-cache.c:305 io_ctl_map_page+0x29/0x76 [btrfs]()
Nov  3 09:55:18 luna kernel: [  939.898227] Hardware name: PRIMERGY
Nov  3 09:55:18 luna kernel: [  939.898229] Modules linked in: btrfs zlib_deflate crc32c libcrc32c nfsd lockd nfs_acl auth_rpcgss autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf cachefiles fscache ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif megaraid_sas sr_mod cdrom floppy pata_acpi ata_generic ata_piix libata scsi_mod [last unloaded: microcode]
Nov  3 09:55:18 luna kernel: [  939.898291] Pid: 13337, comm: dd Not tainted 3.1.0integ-sc+ #1
Nov  3 09:55:18 luna kernel: [  939.898294] Call Trace:
Nov  3 09:55:18 luna kernel: [  939.898303]  [<ffffffff8104b6fe>] warn_slowpath_common+0x85/0x9d
Nov  3 09:55:18 luna kernel: [  939.898308]  [<ffffffff8104b730>] warn_slowpath_null+0x1a/0x1c
Nov  3 09:55:18 luna kernel: [  939.898328]  [<ffffffffa0477507>] io_ctl_map_page+0x29/0x76 [btrfs]
Nov  3 09:55:18 luna kernel: [  939.898349]  [<ffffffffa0477733>] io_ctl_check_crc+0x62/0xdd [btrfs]
Nov  3 09:55:18 luna kernel: [  939.898369]  [<ffffffffa0476051>] ? tree_insert_offset+0xa7/0xb2 [btrfs]
Nov  3 09:55:18 luna kernel: [  939.898389]  [<ffffffffa047917f>] __load_free_space_cache+0x457/0x509 [btrfs]
Nov  3 09:55:18 luna kernel: [  939.898410]  [<ffffffffa04793ca>] load_free_space_cache+0xca/0x168 [btrfs]
Nov  3 09:55:18 luna kernel: [  939.898427]  [<ffffffffa043cd12>] cache_block_group+0xa3/0x1f2 [btrfs]
Nov  3 09:55:18 luna kernel: [  939.898443]  [<ffffffffa043ec3d>] find_free_extent+0x478/0xa58 [btrfs]
Nov  3 09:55:18 luna kernel: [  939.898448]  [<ffffffff81014e61>] ? sched_clock+0x9/0xd
Nov  3 09:55:18 luna kernel: [  939.898454]  [<ffffffff8106c28d>] ? sched_clock_local+0x1c/0x82
Nov  3 09:55:18 luna kernel: [  939.898471]  [<ffffffffa043f2d2>] btrfs_reserve_extent+0xb5/0x1c4 [btrfs]
Nov  3 09:55:18 luna kernel: [  939.898487]  [<ffffffffa043f561>] btrfs_alloc_free_block+0x180/0x2a7 [btrfs]
Nov  3 09:55:18 luna kernel: [  939.898493]  [<ffffffff813a7e1d>] ? __wait_on_bit+0x69/0x7b
Nov  3 09:55:18 luna kernel: [  939.898507]  [<ffffffffa0431446>] __btrfs_cow_block+0x121/0x3f3 [btrfs]
Nov  3 09:55:18 luna kernel: [  939.898522]  [<ffffffffa0431c1b>] btrfs_cow_block+0x120/0x166 [btrfs]
Nov  3 09:55:18 luna kernel: [  939.898536]  [<ffffffffa04339ee>] btrfs_search_slot+0x2ea/0x743 [btrfs]
Nov  3 09:55:18 luna kernel: [  939.898552]  [<ffffffffa0437bae>] ? reserve_metadata_bytes+0xb8/0x599 [btrfs]
Nov  3 09:55:18 luna kernel: [  939.898557]  [<ffffffff810d3b02>] ? filemap_fdatawait_range+0x120/0x16b
Nov  3 09:55:18 luna kernel: [  939.898572]  [<ffffffffa0434a2d>] btrfs_insert_empty_items+0x6a/0xbc [btrfs]
Nov  3 09:55:18 luna kernel: [  939.898577]  [<ffffffff8110b3c9>] ? kmem_cache_alloc+0x31/0xec
Nov  3 09:55:18 luna kernel: [  939.898598]  [<ffffffffa0470a40>] btrfs_insert_orphan_item+0x5d/0x75 [btrfs]
Nov  3 09:55:18 luna kernel: [  939.898619]  [<ffffffffa0452474>] btrfs_orphan_add+0x107/0x124 [btrfs]
Nov  3 09:55:18 luna kernel: [  939.898640]  [<ffffffffa0453c6d>] btrfs_truncate+0x35d/0x51c [btrfs]
Nov  3 09:55:18 luna kernel: [  939.898661]  [<ffffffffa0453eb6>] btrfs_setsize+0x8a/0x99 [btrfs]
Nov  3 09:55:18 luna kernel: [  939.898682]  [<ffffffffa0453f26>] btrfs_setattr+0x61/0xa1 [btrfs]
Nov  3 09:55:18 luna kernel: [  939.898687]  [<ffffffff8112efdb>] notify_change+0x197/0x279
Nov  3 09:55:18 luna kernel: [  939.898692]  [<ffffffff81119646>] do_truncate+0x6a/0x87
Nov  3 09:55:18 luna kernel: [  939.898697]  [<ffffffff8112527c>] do_last+0x575/0x57a
Nov  3 09:55:18 luna kernel: [  939.898702]  [<ffffffff8112399e>] ? path_init+0xd1/0x2bc
Nov  3 09:55:18 luna kernel: [  939.898706]  [<ffffffff81125809>] path_openat+0xcf/0x313
Nov  3 09:55:18 luna kernel: [  939.898710]  [<ffffffff81125b46>] do_filp_open+0x3d/0x89
Nov  3 09:55:18 luna kernel: [  939.898716]  [<ffffffff811d105e>] ? strncpy_from_user+0x48/0x76
Nov  3 09:55:18 luna kernel: [  939.898721]  [<ffffffff8112fc9b>] ? alloc_fd+0x7b/0x123
Nov  3 09:55:18 luna kernel: [  939.898725]  [<ffffffff8111877f>] do_sys_open+0x73/0x105
Nov  3 09:55:18 luna kernel: [  939.898729]  [<ffffffff81118844>] sys_open+0x20/0x22
Nov  3 09:55:18 luna kernel: [  939.898734]  [<ffffffff813afac2>] system_call_fastpath+0x16/0x1b
Nov  3 09:55:18 luna kernel: [  939.898738] ---[ end trace d460dfa0e8887bca ]---
Nov  3 09:55:18 luna kernel: [  939.898758] btrfs: csum mismatch on free space cache
Nov  3 09:55:18 luna kernel: [  939.898814] btrfs: failed to load free space cache for block group 29360128

