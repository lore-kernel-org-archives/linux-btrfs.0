Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:34531 "EHLO
	mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbcETNdc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 May 2016 09:33:32 -0400
Received: by mail-vk0-f65.google.com with SMTP id v68so16715651vka.1
        for <linux-btrfs@vger.kernel.org>; Fri, 20 May 2016 06:33:32 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 20 May 2016 09:33:30 -0400
Message-ID: <CAJtFHUTF2OWpSD1jrjf=W3kX7up9gWjM_iohRsHQAYBdfux=BA@mail.gmail.com>
Subject: kernel 4.5.5 & space_cache=v2 early enospc, forced read-only
From: E V <eliventer@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just trying space_cache=v2 on my big backup btrfs, mounted via
space_cache=v2,enospc_debug,nofail,noatime,compress=zlib. Looks like
something got confused during an rsync  which then quickly propigated
up to forcing the fs read-only in the long stack traces below. I'll be
happy to test the new ENOSPC ticket system patches once they seem
ready if it will help. btrfs file usage:
Overall:
    Device size:                 249.22TiB
    Device allocated:            211.45TiB
    Device unallocated:           37.77TiB
    Device missing:                  0.00B
    Used:                        210.90TiB
    Free (estimated):             38.31TiB      (min: 19.43TiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:210.92TiB, Used:210.37TiB
   /dev/sdb       25.23TiB
   /dev/sdc       25.22TiB
   /dev/sdd       35.23TiB
   /dev/sde       35.23TiB
   /dev/sdf       22.50TiB
   /dev/sdg       22.50TiB
   /dev/sdh       22.50TiB
   /dev/sdi       22.50TiB

Metadata,RAID10: Size:274.00GiB, Used:272.47GiB
   /dev/sdb       34.25GiB
   /dev/sdc       34.25GiB
   /dev/sdd       34.25GiB
   /dev/sde       34.25GiB
   /dev/sdf       34.25GiB
   /dev/sdg       34.25GiB
   /dev/sdh       34.25GiB
   /dev/sdi       34.25GiB

System,RAID10: Size:64.00MiB, Used:28.09MiB
   /dev/sdb        8.00MiB
   /dev/sdc        8.00MiB
   /dev/sdd        8.00MiB
   /dev/sde        8.00MiB
   /dev/sdf        8.00MiB
   /dev/sdg        8.00MiB
   /dev/sdh        8.00MiB
   /dev/sdi        8.00MiB

Unallocated:
   /dev/sdb        4.75TiB
   /dev/sdc        4.75TiB
   /dev/sdd        4.75TiB
   /dev/sde        4.75TiB
   /dev/sdf        4.75TiB
   /dev/sdg        4.75TiB
   /dev/sdh        4.75TiB
   /dev/sdi        4.75TiB

[20581.396634] WARNING: CPU: 6 PID: 4639 at
fs/btrfs/extent-tree.c:7964 btrfs_alloc_tree_block+0xed/0x3e6
[btrfs]()
[20581.396684] BTRFS: block rsv returned -28
[20581.396686] Modules linked in: ipmi_si mpt3sas raid_class
scsi_transport_sas dell_rbu nfsv3 nfsv4 nfsd auth_rpcgss oid_registry
nfs_acl nfs lockd grace fscache sunrpc ext2 intel_powerclamp coretemp
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel sha256_generic hmac
drbg aesni_intel aes_x86_64 glue_helper lrw gf128mul joydev
ablk_helper cryptd iTCO_wdt iTCO_vendor_support evdev ipmi_devintf
dcdbas serio_raw pcspkr lpc_ich ipmi_msghandler mfd_core i7core_edac
edac_core acpi_power_meter button processor loop autofs4 ext4 crc16
mbcache jbd2 btrfs xor raid6_pq hid_generic usbhid hid sg sd_mod
crc32c_intel psmouse uhci_hcd ehci_pci ehci_hcd megaraid_sas ixgbe
mdio usbcore ptp usb_common pps_core scsi_mod bnx2 [last unloaded:
ipmi_si]
[20581.397148] CPU: 6 PID: 4639 Comm: kworker/u65:6 Tainted: G
 I     4.5.5 #1
[20581.397260] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[20581.397293]  0000000000000006 ffffffff811f4e82 ffff88081851fa80
0000000000000009
[20581.397346]  ffffffff810459cb ffffffffa016f717 ffff88081e8c4150
ffff88081851fad8
[20581.397400]  ffff88041e3d2800 ffff8806c7022840 ffffffff81045a23
ffffffffa01e5f8c
[20581.397453] Call Trace:
[20581.397481]  [<ffffffff811f4e82>] ? dump_stack+0x46/0x59
[20581.397512]  [<ffffffff810459cb>] ? warn_slowpath_common+0x94/0xa9
[20581.397558]  [<ffffffffa016f717>] ? btrfs_alloc_tree_block+0xed/0x3e6 [btrfs]
[20581.397589]  [<ffffffff81045a23>] ? warn_slowpath_fmt+0x43/0x4b
[20581.397632]  [<ffffffffa015b486>] ? unlock_up+0x89/0x103 [btrfs]
[20581.397678]  [<ffffffffa016f717>] ? btrfs_alloc_tree_block+0xed/0x3e6 [btrfs]
[20581.397728]  [<ffffffffa01ac095>] ? btrfs_tree_read_unlock+0x5c/0x5e [btrfs]
[20581.397774]  [<ffffffffa015da41>] ? __btrfs_cow_block+0xda/0x45f [btrfs]
[20581.397819]  [<ffffffffa015def6>] ? btrfs_cow_block+0xdd/0x144 [btrfs]
[20581.397863]  [<ffffffffa01609d4>] ? btrfs_search_slot+0x285/0x6d7 [btrfs]
[20581.397911]  [<ffffffffa01734d2>] ? btrfs_lookup_csum+0x39/0xcc [btrfs]
[20581.397959]  [<ffffffffa0174447>] ? btrfs_csum_file_blocks+0x6a/0x4e0 [btrfs]
[20581.398010]  [<ffffffffa01800cc>] ?
add_pending_csums.isra.42+0x42/0x5b [btrfs]
[20581.398075]  [<ffffffffa0185a3d>] ?
btrfs_finish_ordered_io+0x331/0x4cb [btrfs]
[20581.398141]  [<ffffffffa01a4986>] ? normal_work_helper+0xe2/0x21f [btrfs]
[20581.398174]  [<ffffffff810576e0>] ? process_one_work+0x177/0x2a9
[20581.398203]  [<ffffffff81057cc7>] ? worker_thread+0x1e9/0x292
[20581.398232]  [<ffffffff81057ade>] ? rescuer_thread+0x2a5/0x2a5
[20581.398262]  [<ffffffff8105b799>] ? kthread+0xa7/0xaf
[20581.398289]  [<ffffffff8105b6f2>] ? kthread_parkme+0x16/0x16
[20581.398321]  [<ffffffff813d4f9f>] ? ret_from_fork+0x3f/0x70
[20581.398349]  [<ffffffff8105b6f2>] ? kthread_parkme+0x16/0x16
[20581.398377] ---[ end trace 9a28cf840837b232 ]---
[20655.152170] use_block_rsv: 773 callbacks suppressed
[20655.152263] WARNING: CPU: 11 PID: 4814 at
fs/btrfs/extent-tree.c:7964 btrfs_alloc_tree_block+0xed/0x3e6
[btrfs]()
[20655.152313] BTRFS: block rsv returned -28
[20655.152808] CPU: 11 PID: 4814 Comm: kworker/u66:7 Tainted: G
W I     4.5.5 #1
[20655.152921] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[20655.152953]  0000000000000006 ffffffff811f4e82 ffff8801ad383a80
0000000000000009
[20655.153006]  ffffffff810459cb ffffffffa016f717 ffff88081e8c4150
ffff8801ad383ad8
[20655.153060]  ffff88041e3d2800 ffff8801cbea6020 ffffffff81045a23
ffffffffa01e5f8c
[20655.153114] Call Trace:
[20655.153143]  [<ffffffff811f4e82>] ? dump_stack+0x46/0x59
[20655.153173]  [<ffffffff810459cb>] ? warn_slowpath_common+0x94/0xa9
[20655.153219]  [<ffffffffa016f717>] ? btrfs_alloc_tree_block+0xed/0x3e6 [btrfs]
[20655.153251]  [<ffffffff81045a23>] ? warn_slowpath_fmt+0x43/0x4b
[20655.153296]  [<ffffffffa016f717>] ? btrfs_alloc_tree_block+0xed/0x3e6 [btrfs]
[20655.153328]  [<ffffffff810036c1>] ? __switch_to+0x1c0/0x36a
[20655.153371]  [<ffffffffa015da41>] ? __btrfs_cow_block+0xda/0x45f [btrfs]
[20655.153416]  [<ffffffffa015def6>] ? btrfs_cow_block+0xdd/0x144 [btrfs]
[20655.153460]  [<ffffffffa01609d4>] ? btrfs_search_slot+0x285/0x6d7 [btrfs]
[20655.153508]  [<ffffffffa01734d2>] ? btrfs_lookup_csum+0x39/0xcc [btrfs]
[20655.153556]  [<ffffffffa0174447>] ? btrfs_csum_file_blocks+0x6a/0x4e0 [btrfs]
[20655.153607]  [<ffffffffa01800cc>] ?
add_pending_csums.isra.42+0x42/0x5b [btrfs]
[20655.153672]  [<ffffffffa0185a3d>] ?
btrfs_finish_ordered_io+0x331/0x4cb [btrfs]
[20655.153738]  [<ffffffffa01a4986>] ? normal_work_helper+0xe2/0x21f [btrfs]
[20655.153770]  [<ffffffff810576e0>] ? process_one_work+0x177/0x2a9
[20655.153800]  [<ffffffff81057cc7>] ? worker_thread+0x1e9/0x292
[20655.153829]  [<ffffffff81057ade>] ? rescuer_thread+0x2a5/0x2a5
[20655.153858]  [<ffffffff8105b799>] ? kthread+0xa7/0xaf
[20655.153885]  [<ffffffff8105b6f2>] ? kthread_parkme+0x16/0x16
[20655.153915]  [<ffffffff813d4f9f>] ? ret_from_fork+0x3f/0x70
[20655.153943]  [<ffffffff8105b6f2>] ? kthread_parkme+0x16/0x16
[20655.153991] ---[ end trace 9a28cf840837b233 ]---
[20716.920258] use_block_rsv: 1669 callbacks suppressed
[20716.920348] WARNING: CPU: 12 PID: 4638 at
fs/btrfs/extent-tree.c:7964 btrfs_alloc_tree_block+0xed/0x3e6
[btrfs]()
[20716.920398] BTRFS: block rsv returned -28
[20716.920861] CPU: 12 PID: 4638 Comm: kworker/u65:5 Tainted: G
W I     4.5.5 #1
[20716.920974] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[20716.921007]  0000000000000006 ffffffff811f4e82 ffff88081851ba80
0000000000000009
[20716.921061]  ffffffff810459cb ffffffffa016f717 ffff88081e8c4150
ffff88081851bad8
[20716.921114]  ffff88041e3d2800 ffff8807fee69d40 ffffffff81045a23
ffffffffa01e5f8c
[20716.921168] Call Trace:
[20716.921195]  [<ffffffff811f4e82>] ? dump_stack+0x46/0x59
[20716.921226]  [<ffffffff810459cb>] ? warn_slowpath_common+0x94/0xa9
[20716.921272]  [<ffffffffa016f717>] ? btrfs_alloc_tree_block+0xed/0x3e6 [btrfs]
[20716.921304]  [<ffffffff81045a23>] ? warn_slowpath_fmt+0x43/0x4b
[20716.921349]  [<ffffffffa016f717>] ? btrfs_alloc_tree_block+0xed/0x3e6 [btrfs]
[20716.921400]  [<ffffffffa01ac095>] ? btrfs_tree_read_unlock+0x5c/0x5e [btrfs]
[20716.921445]  [<ffffffffa015da41>] ? __btrfs_cow_block+0xda/0x45f [btrfs]
[20716.921490]  [<ffffffffa015def6>] ? btrfs_cow_block+0xdd/0x144 [btrfs]
[20716.921535]  [<ffffffffa01609d4>] ? btrfs_search_slot+0x285/0x6d7 [btrfs]
[20716.921583]  [<ffffffffa01734d2>] ? btrfs_lookup_csum+0x39/0xcc [btrfs]
[20716.921631]  [<ffffffffa0174447>] ? btrfs_csum_file_blocks+0x6a/0x4e0 [btrfs]
[20716.921682]  [<ffffffffa01800cc>] ?
add_pending_csums.isra.42+0x42/0x5b [btrfs]
[20716.924319]  [<ffffffffa0185a3d>] ?
btrfs_finish_ordered_io+0x331/0x4cb [btrfs]
[20716.924387]  [<ffffffffa01a4986>] ? normal_work_helper+0xe2/0x21f [btrfs]
[20716.924421]  [<ffffffff810576e0>] ? process_one_work+0x177/0x2a9
[20716.924451]  [<ffffffff81057cc7>] ? worker_thread+0x1e9/0x292
[20716.924479]  [<ffffffff81057ade>] ? rescuer_thread+0x2a5/0x2a5
[20716.924509]  [<ffffffff8105b799>] ? kthread+0xa7/0xaf
[20716.924536]  [<ffffffff8105b6f2>] ? kthread_parkme+0x16/0x16
[20716.924568]  [<ffffffff813d4f9f>] ? ret_from_fork+0x3f/0x70
[20716.924596]  [<ffffffff8105b6f2>] ? kthread_parkme+0x16/0x16
[20716.924647] ---[ end trace 9a28cf840837b234 ]---
[20781.188808] use_block_rsv: 981 callbacks suppressed
[20781.188891] WARNING: CPU: 0 PID: 4793 at
fs/btrfs/extent-tree.c:7964 btrfs_alloc_tree_block+0xed/0x3e6
[btrfs]()
[20781.188939] BTRFS: block rsv returned -28
[20781.189392] CPU: 0 PID: 4793 Comm: kworker/u65:8 Tainted: G
W I     4.5.5 #1
[20781.189494] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[20781.189524]  0000000000000006 ffffffff811f4e82 ffff8807c374ba80
0000000000000009
[20781.189575]  ffffffff810459cb ffffffffa016f717 ffff88081e8c4150
ffff8807c374bad8
[20781.189625]  ffff88041e3d2800 ffff88063d9e3f20 ffffffff81045a23
ffffffffa01e5f8c
[20781.189676] Call Trace:
[20781.189702]  [<ffffffff811f4e82>] ? dump_stack+0x46/0x59
[20781.189733]  [<ffffffff810459cb>] ? warn_slowpath_common+0x94/0xa9
[20781.189770]  [<ffffffffa016f717>] ? btrfs_alloc_tree_block+0xed/0x3e6 [btrfs]
[20781.189800]  [<ffffffff81045a23>] ? warn_slowpath_fmt+0x43/0x4b
[20781.189837]  [<ffffffffa016f717>] ? btrfs_alloc_tree_block+0xed/0x3e6 [btrfs]
[20781.189875]  [<ffffffffa015da41>] ? __btrfs_cow_block+0xda/0x45f [btrfs]
[20781.189912]  [<ffffffffa015def6>] ? btrfs_cow_block+0xdd/0x144 [btrfs]
[20781.189949]  [<ffffffffa01609d4>] ? btrfs_search_slot+0x285/0x6d7 [btrfs]
[20781.189988]  [<ffffffffa01734d2>] ? btrfs_lookup_csum+0x39/0xcc [btrfs]
[20781.190026]  [<ffffffffa0174447>] ? btrfs_csum_file_blocks+0x6a/0x4e0 [btrfs]
[20781.190067]  [<ffffffffa01800cc>] ?
add_pending_csums.isra.42+0x42/0x5b [btrfs]
[20781.190122]  [<ffffffffa0185a3d>] ?
btrfs_finish_ordered_io+0x331/0x4cb [btrfs]
[20781.190178]  [<ffffffffa01a4986>] ? normal_work_helper+0xe2/0x21f [btrfs]
[20781.190209]  [<ffffffff810576e0>] ? process_one_work+0x177/0x2a9
[20781.190236]  [<ffffffff81057cc7>] ? worker_thread+0x1e9/0x292
[20781.190263]  [<ffffffff81057ade>] ? rescuer_thread+0x2a5/0x2a5
[20781.190291]  [<ffffffff8105b799>] ? kthread+0xa7/0xaf
[20781.190316]  [<ffffffff8105b6f2>] ? kthread_parkme+0x16/0x16
[20781.190346]  [<ffffffff813d4f9f>] ? ret_from_fork+0x3f/0x70
[20781.190372]  [<ffffffff8105b6f2>] ? kthread_parkme+0x16/0x16
[20781.190399] ---[ end trace 9a28cf840837b235 ]---
[20900.113099] use_block_rsv: 393 callbacks suppressed
[20900.113199] WARNING: CPU: 0 PID: 4796 at
fs/btrfs/extent-tree.c:7964 btrfs_alloc_tree_block+0xed/0x3e6
[btrfs]()
[20900.113251] BTRFS: block rsv returned -28
[20900.113820] CPU: 0 PID: 4796 Comm: kworker/u65:9 Tainted: G
W I     4.5.5 #1
[20900.113959] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[20900.113993]  0000000000000006 ffffffff811f4e82 ffff8807b6b67a80
0000000000000009
[20900.114051]  ffffffff810459cb ffffffffa016f717 ffff88081e8c4150
ffff8807b6b67ad8
[20900.114108]  ffff88041e3d2800 ffff8807feefc020 ffffffff81045a23
ffffffffa01e5f8c
[20900.114164] Call Trace:
[20900.114195]  [<ffffffff811f4e82>] ? dump_stack+0x46/0x59
[20900.114228]  [<ffffffff810459cb>] ? warn_slowpath_common+0x94/0xa9
[20900.114285]  [<ffffffffa016f717>] ? btrfs_alloc_tree_block+0xed/0x3e6 [btrfs]
[20900.114319]  [<ffffffff81045a23>] ? warn_slowpath_fmt+0x43/0x4b
[20900.114376]  [<ffffffffa016f717>] ? btrfs_alloc_tree_block+0xed/0x3e6 [btrfs]
[20900.114445]  [<ffffffffa01ac095>] ? btrfs_tree_read_unlock+0x5c/0x5e [btrfs]
[20900.114504]  [<ffffffffa015da41>] ? __btrfs_cow_block+0xda/0x45f [btrfs]
[20900.114563]  [<ffffffffa015def6>] ? btrfs_cow_block+0xdd/0x144 [btrfs]
[20900.114624]  [<ffffffffa01609d4>] ? btrfs_search_slot+0x285/0x6d7 [btrfs]
[20900.114684]  [<ffffffffa01734d2>] ? btrfs_lookup_csum+0x39/0xcc [btrfs]
[20900.114743]  [<ffffffffa0174447>] ? btrfs_csum_file_blocks+0x6a/0x4e0 [btrfs]
[20900.114805]  [<ffffffffa01800cc>] ?
add_pending_csums.isra.42+0x42/0x5b [btrfs]
[20900.114883]  [<ffffffffa0185a3d>] ?
btrfs_finish_ordered_io+0x331/0x4cb [btrfs]
[20900.114966]  [<ffffffffa01a4986>] ? normal_work_helper+0xe2/0x21f [btrfs]
[20900.115002]  [<ffffffff810576e0>] ? process_one_work+0x177/0x2a9
[20900.115034]  [<ffffffff81057cc7>] ? worker_thread+0x1e9/0x292
[20900.115064]  [<ffffffff81057ade>] ? rescuer_thread+0x2a5/0x2a5
[20900.115096]  [<ffffffff8105b799>] ? kthread+0xa7/0xaf
[20900.115125]  [<ffffffff8105b6f2>] ? kthread_parkme+0x16/0x16
[20900.115158]  [<ffffffff813d4f9f>] ? ret_from_fork+0x3f/0x70
[20900.115188]  [<ffffffff8105b6f2>] ? kthread_parkme+0x16/0x16
[20900.115218] ---[ end trace 9a28cf840837b236 ]---
[21117.654189] use_block_rsv: 1462 callbacks suppressed
[21117.654272] WARNING: CPU: 0 PID: 4743 at
fs/btrfs/extent-tree.c:7964 btrfs_alloc_tree_block+0xed/0x3e6
[btrfs]()
[21117.654320] BTRFS: block rsv returned -28
[21117.654823] CPU: 0 PID: 4743 Comm: kworker/u65:27 Tainted: G
W I     4.5.5 #1
[21117.654925] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[21117.654955]  0000000000000006 ffffffff811f4e82 ffff8807db087a80
0000000000000009
[21117.655006]  ffffffff810459cb ffffffffa016f717 ffff88081e8c4150
ffff8807db087ad8
[21117.655056]  ffff88041e3d2800 ffff8807fc6895c0 ffffffff81045a23
ffffffffa01e5f8c
[21117.655107] Call Trace:
[21117.655133]  [<ffffffff811f4e82>] ? dump_stack+0x46/0x59
[21117.655162]  [<ffffffff810459cb>] ? warn_slowpath_common+0x94/0xa9
[21117.655200]  [<ffffffffa016f717>] ? btrfs_alloc_tree_block+0xed/0x3e6 [btrfs]
[21117.655230]  [<ffffffff81045a23>] ? warn_slowpath_fmt+0x43/0x4b
[21117.655268]  [<ffffffffa016f717>] ? btrfs_alloc_tree_block+0xed/0x3e6 [btrfs]
[21117.655312]  [<ffffffffa01ac095>] ? btrfs_tree_read_unlock+0x5c/0x5e [btrfs]
[21117.655350]  [<ffffffffa015da41>] ? __btrfs_cow_block+0xda/0x45f [btrfs]
[21117.655387]  [<ffffffffa015def6>] ? btrfs_cow_block+0xdd/0x144 [btrfs]
[21117.655423]  [<ffffffffa01609d4>] ? btrfs_search_slot+0x285/0x6d7 [btrfs]
[21117.655462]  [<ffffffffa01734d2>] ? btrfs_lookup_csum+0x39/0xcc [btrfs]
[21117.655501]  [<ffffffffa0174447>] ? btrfs_csum_file_blocks+0x6a/0x4e0 [btrfs]
[21117.655542]  [<ffffffffa01800cc>] ?
add_pending_csums.isra.42+0x42/0x5b [btrfs]
[21117.655597]  [<ffffffffa0185a3d>] ?
btrfs_finish_ordered_io+0x331/0x4cb [btrfs]
[21117.655652]  [<ffffffffa01a4986>] ? normal_work_helper+0xe2/0x21f [btrfs]
[21117.655682]  [<ffffffff810576e0>] ? process_one_work+0x177/0x2a9
[21117.655710]  [<ffffffff81057cc7>] ? worker_thread+0x1e9/0x292
[21117.655737]  [<ffffffff81057ade>] ? rescuer_thread+0x2a5/0x2a5
[21117.655764]  [<ffffffff8105b799>] ? kthread+0xa7/0xaf
[21117.655789]  [<ffffffff8105b6f2>] ? kthread_parkme+0x16/0x16
[21117.655817]  [<ffffffff813d4f9f>] ? ret_from_fork+0x3f/0x70
[21117.655844]  [<ffffffff8105b6f2>] ? kthread_parkme+0x16/0x16
[21117.655870] ---[ end trace 9a28cf840837b237 ]---
[22069.690283] use_block_rsv: 7 callbacks suppressed
[22069.690381] WARNING: CPU: 12 PID: 4791 at
fs/btrfs/extent-tree.c:7964 btrfs_alloc_tree_block+0xed/0x3e6
[btrfs]()
[22069.690432] BTRFS: block rsv returned -28
[22069.690920] CPU: 12 PID: 4791 Comm: kworker/u65:4 Tainted: G
W I     4.5.5 #1
[22069.691040] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[22069.691073]  0000000000000006 ffffffff811f4e82 ffff8807c6f5ba80
0000000000000009
[22069.693761]  ffffffff810459cb ffffffffa016f717 ffff88081e8c4150
ffff8807c6f5bad8
[22069.693817]  ffff88041e3d2800 ffff88052f2dbca0 ffffffff81045a23
ffffffffa01e5f8c
[22069.693873] Call Trace:
[22069.693905]  [<ffffffff811f4e82>] ? dump_stack+0x46/0x59
[22069.693936]  [<ffffffff810459cb>] ? warn_slowpath_common+0x94/0xa9
[22069.693996]  [<ffffffffa016f717>] ? btrfs_alloc_tree_block+0xed/0x3e6 [btrfs]
[22069.694029]  [<ffffffff81045a23>] ? warn_slowpath_fmt+0x43/0x4b
[22069.694081]  [<ffffffffa016f717>] ? btrfs_alloc_tree_block+0xed/0x3e6 [btrfs]
[22069.694114]  [<ffffffff810036c1>] ? __switch_to+0x1c0/0x36a
[22069.694164]  [<ffffffffa015da41>] ? __btrfs_cow_block+0xda/0x45f [btrfs]
[22069.694214]  [<ffffffffa015def6>] ? btrfs_cow_block+0xdd/0x144 [btrfs]
[22069.694265]  [<ffffffffa01609d4>] ? btrfs_search_slot+0x285/0x6d7 [btrfs]
[22069.694320]  [<ffffffffa01734d2>] ? btrfs_lookup_csum+0x39/0xcc [btrfs]
[22069.694374]  [<ffffffffa0174447>] ? btrfs_csum_file_blocks+0x6a/0x4e0 [btrfs]
[22069.694432]  [<ffffffffa01800cc>] ?
add_pending_csums.isra.42+0x42/0x5b [btrfs]
[22069.694505]  [<ffffffffa0185a3d>] ?
btrfs_finish_ordered_io+0x331/0x4cb [btrfs]
[22069.694577]  [<ffffffffa01a4986>] ? normal_work_helper+0xe2/0x21f [btrfs]
[22069.694611]  [<ffffffff810576e0>] ? process_one_work+0x177/0x2a9
[22069.694642]  [<ffffffff81057cc7>] ? worker_thread+0x1e9/0x292
[22069.694672]  [<ffffffff81057ade>] ? rescuer_thread+0x2a5/0x2a5
[22069.694702]  [<ffffffff8105b799>] ? kthread+0xa7/0xaf
[22069.694730]  [<ffffffff8105b6f2>] ? kthread_parkme+0x16/0x16
[22069.694761]  [<ffffffff813d4f9f>] ? ret_from_fork+0x3f/0x70
[22069.694791]  [<ffffffff8105b6f2>] ? kthread_parkme+0x16/0x16
[22069.694848] ---[ end trace 9a28cf840837b238 ]---
[34479.060213] use_block_rsv: 238 callbacks suppressed
[34479.060300] WARNING: CPU: 0 PID: 5696 at
fs/btrfs/extent-tree.c:7964 btrfs_alloc_tree_block+0xed/0x3e6
[btrfs]()
[34479.060348] BTRFS: block rsv returned -28
[34479.060826] CPU: 0 PID: 5696 Comm: kworker/u65:14 Tainted: G
W I     4.5.5 #1
[34479.060932] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[34479.060963]  0000000000000006 ffffffff811f4e82 ffff8805aae3f920
0000000000000009
[34479.061015]  ffffffff810459cb ffffffffa016f717 ffff88081e8c4128
ffff8805aae3f978
[34479.061066]  ffff88041e3de800 ffff8807feca0200 ffffffff81045a23
ffffffffa01e5f8c
[34479.061118] Call Trace:
[34479.061144]  [<ffffffff811f4e82>] ? dump_stack+0x46/0x59
[34479.061174]  [<ffffffff810459cb>] ? warn_slowpath_common+0x94/0xa9
[34479.061215]  [<ffffffffa016f717>] ? btrfs_alloc_tree_block+0xed/0x3e6 [btrfs]
[34479.061245]  [<ffffffff81045a23>] ? warn_slowpath_fmt+0x43/0x4b
[34479.061286]  [<ffffffffa016f717>] ? btrfs_alloc_tree_block+0xed/0x3e6 [btrfs]
[34479.061319]  [<ffffffff81061e6c>] ? check_preempt_curr+0x41/0x63
[34479.061358]  [<ffffffffa015da41>] ? __btrfs_cow_block+0xda/0x45f [btrfs]
[34479.061399]  [<ffffffffa015def6>] ? btrfs_cow_block+0xdd/0x144 [btrfs]
[34479.061439]  [<ffffffffa01609d4>] ? btrfs_search_slot+0x285/0x6d7 [btrfs]
[34479.061481]  [<ffffffffa016579e>] ?
lookup_inline_extent_backref+0xf8/0x49b [btrfs]
[34479.061527]  [<ffffffff8111e795>] ? __cache_free.isra.50+0x1df/0x1ee
[34479.061568]  [<ffffffffa0167607>] ? __btrfs_free_extent+0xda/0x9fa [btrfs]
[34479.061598]  [<ffffffff8111e795>] ? __cache_free.isra.50+0x1df/0x1ee
[34479.061641]  [<ffffffffa01b8bcc>] ?
btrfs_merge_delayed_refs+0x5d/0x258 [btrfs]
[34479.061699]  [<ffffffffa016b605>] ?
__btrfs_run_delayed_refs+0xaf0/0xc8f [btrfs]
[34479.061757]  [<ffffffffa016cec8>] ? btrfs_run_delayed_refs+0x81/0x1d3 [btrfs]
[34479.061801]  [<ffffffffa016d04c>] ? delayed_ref_async_start+0x32/0x6e [btrfs]
[34479.061847]  [<ffffffffa01a4986>] ? normal_work_helper+0xe2/0x21f [btrfs]
[34479.061878]  [<ffffffff810576e0>] ? process_one_work+0x177/0x2a9
[34479.061906]  [<ffffffff81057cc7>] ? worker_thread+0x1e9/0x292
[34479.061934]  [<ffffffff81057ade>] ? rescuer_thread+0x2a5/0x2a5
[34479.061962]  [<ffffffff8105b799>] ? kthread+0xa7/0xaf
[34479.061989]  [<ffffffff8105b6f2>] ? kthread_parkme+0x16/0x16
[34479.062019]  [<ffffffff813d4f9f>] ? ret_from_fork+0x3f/0x70
[34479.062046]  [<ffffffff8105b6f2>] ? kthread_parkme+0x16/0x16
[34479.062146] ---[ end trace 9a28cf840837b239 ]---
[36489.749586] use_block_rsv: 4184 callbacks suppressed
[36489.749667] WARNING: CPU: 3 PID: 4117 at
fs/btrfs/extent-tree.c:7964 btrfs_alloc_tree_block+0xed/0x3e6
[btrfs]()
[36489.749715] BTRFS: block rsv returned -28
[36489.750138] CPU: 3 PID: 4117 Comm: btrfs-transacti Tainted: G
 W I     4.5.5 #1
[36489.750225]  0000000000000006 ffffffff811f4e82 ffff8803a1a57958
0000000000000009
[36489.750276]  ffffffff810459cb ffffffffa016f717 ffff88081e8c4128
ffff8803a1a579b0
[36489.750326]  ffff88041e3de800 ffff880181d55ac0 ffffffff81045a23
ffffffffa01e5f8c
[36489.750376] Call Trace:
[36489.750401]  [<ffffffff811f4e82>] ? dump_stack+0x46/0x59
[36489.750429]  [<ffffffff810459cb>] ? warn_slowpath_common+0x94/0xa9
[36489.750466]  [<ffffffffa016f717>] ? btrfs_alloc_tree_block+0xed/0x3e6 [btrfs]
[36489.750496]  [<ffffffff81045a23>] ? warn_slowpath_fmt+0x43/0x4b
[36489.750533]  [<ffffffffa016f717>] ? btrfs_alloc_tree_block+0xed/0x3e6 [btrfs]
[36489.750571]  [<ffffffffa015da41>] ? __btrfs_cow_block+0xda/0x45f [btrfs]
[36489.750608]  [<ffffffffa015def6>] ? btrfs_cow_block+0xdd/0x144 [btrfs]
[36489.750644]  [<ffffffffa01609d4>] ? btrfs_search_slot+0x285/0x6d7 [btrfs]
[36489.750682]  [<ffffffffa016579e>] ?
lookup_inline_extent_backref+0xf8/0x49b [btrfs]
[36489.750728]  [<ffffffff8111e795>] ? __cache_free.isra.50+0x1df/0x1ee
[36489.750764]  [<ffffffffa0167607>] ? __btrfs_free_extent+0xda/0x9fa [btrfs]
[36489.750793]  [<ffffffff8111e795>] ? __cache_free.isra.50+0x1df/0x1ee
[36489.750832]  [<ffffffffa01b8bcc>] ?
btrfs_merge_delayed_refs+0x5d/0x258 [btrfs]
[36489.750885]  [<ffffffffa016b605>] ?
__btrfs_run_delayed_refs+0xaf0/0xc8f [btrfs]
[36489.750938]  [<ffffffffa016cec8>] ? btrfs_run_delayed_refs+0x81/0x1d3 [btrfs]
[36489.750979]  [<ffffffffa017e33b>] ?
btrfs_commit_transaction+0x3bf/0x927 [btrfs]
[36489.751033]  [<ffffffffa017eb84>] ? start_transaction+0x2e1/0x46c [btrfs]
[36489.751073]  [<ffffffffa017a067>] ? transaction_kthread+0xe9/0x1bc [btrfs]
[36489.751113]  [<ffffffffa0179f7e>] ?
btrfs_cleanup_transaction+0x3f4/0x3f4 [btrfs]
[36489.751157]  [<ffffffff8105b799>] ? kthread+0xa7/0xaf
[36489.751182]  [<ffffffff8105b6f2>] ? kthread_parkme+0x16/0x16
[36489.751211]  [<ffffffff813d4f9f>] ? ret_from_fork+0x3f/0x70
[36489.751237]  [<ffffffff8105b6f2>] ? kthread_parkme+0x16/0x16
[36489.751276] ---[ end trace 9a28cf840837b23a ]---
[36489.751344] WARNING: CPU: 3 PID: 4117 at
fs/btrfs/extent-tree.c:6602 __btrfs_free_extent+0x9de/0x9fa [btrfs]()
[36489.751392] BTRFS: Transaction aborted (error -28)
[36489.751815] CPU: 3 PID: 4117 Comm: btrfs-transacti Tainted: G
 W I     4.5.5 #1
[36489.751902]  0000000000000006 ffffffff811f4e82 ffff8803a1a57be0
0000000000000009
[36489.751953]  ffffffff810459cb ffffffffa0167f0b 00000000ffffffe4
ffff8803a1a57c38
[36489.752003]  ffff88041e3de800 0003c0f73e4d4000 ffffffff81045a23
ffffffffa01e5c6b
[36489.752053] Call Trace:
[36489.752075]  [<ffffffff811f4e82>] ? dump_stack+0x46/0x59
[36489.752102]  [<ffffffff810459cb>] ? warn_slowpath_common+0x94/0xa9
[36489.752139]  [<ffffffffa0167f0b>] ? __btrfs_free_extent+0x9de/0x9fa [btrfs]
[36489.752169]  [<ffffffff81045a23>] ? warn_slowpath_fmt+0x43/0x4b
[36489.752205]  [<ffffffffa0167f0b>] ? __btrfs_free_extent+0x9de/0x9fa [btrfs]
[36489.752234]  [<ffffffff8111e795>] ? __cache_free.isra.50+0x1df/0x1ee
[36489.752273]  [<ffffffffa01b8bcc>] ?
btrfs_merge_delayed_refs+0x5d/0x258 [btrfs]
[36489.752328]  [<ffffffffa016b605>] ?
__btrfs_run_delayed_refs+0xaf0/0xc8f [btrfs]
[36489.752382]  [<ffffffffa016cec8>] ? btrfs_run_delayed_refs+0x81/0x1d3 [btrfs]
[36489.752423]  [<ffffffffa017e33b>] ?
btrfs_commit_transaction+0x3bf/0x927 [btrfs]
[36489.752480]  [<ffffffffa017eb84>] ? start_transaction+0x2e1/0x46c [btrfs]
[36489.752520]  [<ffffffffa017a067>] ? transaction_kthread+0xe9/0x1bc [btrfs]
[36489.752560]  [<ffffffffa0179f7e>] ?
btrfs_cleanup_transaction+0x3f4/0x3f4 [btrfs]
[36489.755180]  [<ffffffff8105b799>] ? kthread+0xa7/0xaf
[36489.755206]  [<ffffffff8105b6f2>] ? kthread_parkme+0x16/0x16
[36489.755232]  [<ffffffff813d4f9f>] ? ret_from_fork+0x3f/0x70
[36489.755258]  [<ffffffff8105b6f2>] ? kthread_parkme+0x16/0x16
[36489.755294] ---[ end trace 9a28cf840837b23b ]---
[36489.755335] BTRFS: error (device sdi) in __btrfs_free_extent:6602:
errno=-28 No space left
[36489.755382] BTRFS info (device sdi): forced readonly
[36489.755409] BTRFS: error (device sdi) in
btrfs_run_delayed_refs:2946: errno=-28 No space left
[36489.755456] BTRFS warning (device sdi): Skipping commit of aborted
transaction.
[36489.755499] BTRFS: error (device sdi) in cleanup_transaction:1764:
errno=-28 No space left
[87803.022910] BTRFS error (device sdi): cleaner transaction attach returned -30
