Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-me1aus01on0071.outbound.protection.outlook.com ([104.47.116.71]:58708
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751376AbdKNDIT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Nov 2017 22:08:19 -0500
From: Ben Hooper <ben@ayrton.com.au>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: btrfs check fails with: btrfs_alloc_chunk: BUG_ON `ret` triggered,
 value -28
Date: Tue, 14 Nov 2017 03:08:14 +0000
Message-ID: <SY3PR01MB1465C3E1A99997C75685BE0FF9280@SY3PR01MB1465.ausprd01.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Received another balance error which made the fileyetem RO.

Running btrfs check errors out with:

        volumes.c:1035: btrfs_alloc_chunk: BUG_ON `ret` triggered, value -28

I am still able to mount the filesystem RW but it takes over 10 minutes to mount.

So far I have tried different kernel versions (4.9, 4.13, 4.14) and adding additional disks but I still can't get the balance operation to complete.

Any suggestions on how to get this filesystem balanced? Or should I just invest in a new filesystem and transfer the data over?

# ./btrfs check --repair --progress /dev/sda
enabling repair mode
Checking filesystem on /dev/sda
UUID: 3742056f-7ff0-4ce1-9131-ab2cfd7b8736
checking extents [o]
Fixed 0 roots.
cache and super generation don't match, space cache will be invalidated
checking fs roots [O]


volumes.c:1035: btrfs_alloc_chunk: BUG_ON `ret` triggered, value -28
./btrfs[0x424b3a]
./btrfs(btrfs_alloc_chunk+0x982)[0x4262f2]
./btrfs[0x41b08d]
./btrfs(btrfs_reserve_extent+0x142)[0x41b2cb]
./btrfs(btrfs_alloc_free_block+0x55)[0x41bd3b]
./btrfs(__btrfs_cow_block+0xdd)[0x40c62d]
./btrfs(btrfs_cow_block+0x124)[0x40d12e]
./btrfs(btrfs_search_slot+0x1cf)[0x40fa58]
./btrfs(btrfs_insert_empty_items+0xcf)[0x411390]
./btrfs(btrfs_insert_file_extent+0xa1)[0x421358]
./btrfs(btrfs_punch_hole+0x79)[0x43721f]
./btrfs[0x456a3a]
./btrfs(cmd_check+0x2c08)[0x45fb44]
./btrfs(main+0x15d)[0x40b514]
/lib64/libc.so.6(__libc_start_main+0xf5)[0x7f0c376e9c05]
./btrfs[0x40afe9]
Aborted


# ./btrfs --version
btrfs-progs v4.13.3


# uname -a
Linux nas 4.14.0-rc7+ #1 SMP Thu Nov 2 00:35:35 HKT 2017 x86_64 x86_64 x86_64 GNU/Linux


[28205.406171] ------------[ cut here ]------------
[28205.406214] BTRFS: error (device sdl) in btrfs_create_pending_block_groups:10254: errno=-27 unknown
[28205.406216] BTRFS info (device sdl): forced readonly
[28205.407857] BTRFS info (device sdl): 2 enospc errors during balance
[28205.410456] WARNING: CPU: 13 PID: 10879 at fs/btrfs/extent-tree.c:10254 btrfs_create_pending_block_groups+0x250/0x260 [btrfs]
[28205.411485] Modules linked in: ipt_REJECT nf_reject_ipv4 xt_conntrack ip_set nfnetlink iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw iptable_filter veth w83795 jc42 ext4 mbcache jbd2 intel_powerclamp coretemp kvm_intel kvm iTCO_wdt gpio_ich iTCO_vendor_support irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc btrfs aesni_intel crypto_simd glue_helper cryptd intel_cstate xor zstd_decompress zstd_compress xxhash ipmi_si ipmi_devintf pcspkr ipmi_msghandler input_leds i2c_i801 lpc_ich mfd_core ioatdma i7core_edac i5500_temp dca ses enclosure raid6_pq sg shpchp acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod ata_generic mgag200 pata_acpi i2c_algo_bit crc32c_intel drm_kms_helper
[28205.419253]  syscopyarea sysfillrect sysimgblt fb_sys_fops ata_piix serio_raw ttm e1000e mpt3sas drm libata ptp raid_class pps_core scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod dax
[28205.421641] CPU: 13 PID: 10879 Comm: kworker/u49:14 Not tainted 4.14.0-rc7+ #1
[28205.422815] Hardware name: Penguin Computing Relion 4724/X8DT6, BIOS 2.0c    05/15/2012
[28205.424058] Workqueue: events_unbound btrfs_async_reclaim_metadata_space [btrfs]
[28205.425297] task: ffff880620912c00 task.stack: ffffc900277f4000
[28205.426533] RIP: 0010:btrfs_create_pending_block_groups+0x250/0x260 [btrfs]
[28205.427773] RSP: 0018:ffffc900277f7c50 EFLAGS: 00010246
[28205.429020] RAX: 0000000000000026 RBX: 00000000ffffffe5 RCX: 0000000000000000
[28205.430248] RDX: 0000000000000000 RSI: ffff880627bce098 RDI: ffff880627bce098
[28205.431450] RBP: ffffc900277f7cd0 R08: 0000000000000000 R09: 0000000000000892
[28205.432665] R10: 0000000000000007 R11: 0000000000000891 R12: ffff8805c52948e8
[28205.433856] R13: ffff8801d243e400 R14: ffff8801d2438400 R15: ffff8801d243e520
[28205.435048] FS:  0000000000000000(0000) GS:ffff880627bc0000(0000) knlGS:0000000000000000
[28205.436279] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[28205.437462] CR2: 00007f5985a7fff0 CR3: 0000000001c09004 CR4: 00000000000206e0
[28205.438648] Call Trace:
[28205.439875]  __btrfs_end_transaction+0x93/0x2f0 [btrfs]
[28205.441106]  btrfs_end_transaction+0x10/0x20 [btrfs]
[28205.442327]  flush_space+0x137/0x550 [btrfs]
[28205.443519]  ? pick_next_task_fair+0x48b/0x5d0
[28205.444706]  ? __switch_to+0x1ff/0x440
[28205.445892]  btrfs_async_reclaim_metadata_space+0xfc/0x4b0 [btrfs]
[28205.447079]  process_one_work+0x149/0x360
[28205.448285]  worker_thread+0x4d/0x3e0
[28205.449441]  kthread+0x109/0x140
[28205.450586]  ? rescuer_thread+0x380/0x380
[28205.451741]  ? kthread_park+0x60/0x60
[28205.452906]  ret_from_fork+0x25/0x30
[28205.454029] Code: 79 ff ff ff 49 8b 7c 24 60 89 da 48 c7 c6 68 c7 be a0 31 c0 e8 12 4e fe ff eb 9b 89 de 48 c7 c7 38 c7 be a0 31 c0 e8 53 11 5a e0 <0f> ff eb 87 66 90 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90
[28205.456407] ---[ end trace 77358f42ce65a0d0 ]---
[28205.457579] BTRFS: error (device sdl) in btrfs_create_pending_block_groups:10254: errno=-27 unknown
[28206.172366] BTRFS: error (device sdl) in btrfs_create_pending_block_groups:10254: errno=-27 unknown
[28206.178599] BTRFS warning (device sdl): Skipping commit of aborted transaction.
[28206.179840] BTRFS: error (device sdl) in cleanup_transaction:1873: errno=-5 IO failure
[28206.256720] BTRFS error (device sdl): pending csums is 1368064


# time mount /dev/sda /data
0.00user 82.94system 12:07.80elapsed 11%CPU (0avgtext+0avgdata 3828maxresident)k
1972232inputs+41429536outputs (0major+397minor)pagefaults 0swaps


# ./btrfs filesystem show /data
Label: 'data'  uuid: 3742056f-7ff0-4ce1-9131-ab2cfd7b8736
        Total devices 24 FS bytes used 60.28TiB
        devid    2 size 7.28TiB used 1.92TiB path /dev/sdk
        devid    3 size 7.28TiB used 1.91TiB path /dev/sdj
        devid    5 size 3.64TiB used 3.64TiB path /dev/sdo
        devid    7 size 2.73TiB used 2.73TiB path /dev/sdr
        devid   11 size 3.64TiB used 3.64TiB path /dev/sdm
        devid   12 size 3.64TiB used 3.64TiB path /dev/sdn
        devid   13 size 3.64TiB used 3.64TiB path /dev/sdp
        devid   14 size 3.64TiB used 3.64TiB path /dev/sdq
        devid   15 size 3.64TiB used 3.64TiB path /dev/sdw
        devid   16 size 3.64TiB used 3.64TiB path /dev/sdx
        devid   17 size 7.28TiB used 7.28TiB path /dev/sdv
        devid   18 size 7.28TiB used 7.28TiB path /dev/sdu
        devid   19 size 7.28TiB used 7.28TiB path /dev/sda
        devid   20 size 7.28TiB used 7.28TiB path /dev/sdt
        devid   21 size 7.28TiB used 7.28TiB path /dev/sdc
        devid   22 size 7.28TiB used 7.28TiB path /dev/sdd
        devid   23 size 7.28TiB used 7.28TiB path /dev/sds
        devid   24 size 7.28TiB used 7.28TiB path /dev/sde
        devid   25 size 7.28TiB used 7.28TiB path /dev/sdl
        devid   26 size 7.28TiB used 7.28TiB path /dev/sdh
        devid   27 size 7.28TiB used 7.28TiB path /dev/sdi
        devid   28 size 7.28TiB used 6.96TiB path /dev/sdb
        devid   29 size 7.28TiB used 796.36GiB path /dev/sdg
        devid   30 size 7.28TiB used 796.36GiB path /dev/sdf


# ./btrfs filesystem df /data
Data, RAID10: total=60.20TiB, used=60.18TiB
System, RAID10: total=176.00MiB, used=161.53MiB
Metadata, RAID10: total=98.39GiB, used=97.15GiB
GlobalReserve, single: total=512.00MiB, used=40.70MiB


# ./btrfs filesystem  usage /data
Overall:
    Device size:                 144.64TiB
    Device allocated:            120.60TiB
    Device unallocated:           24.04TiB
    Device missing:                  0.00B
    Used:                        120.56TiB
    Free (estimated):             12.04TiB      (min: 12.04TiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 25.09MiB)


Data,RAID10: Size:60.20TiB, Used:60.18TiB
   /dev/sda        3.63TiB
   /dev/sdb        3.48TiB
   /dev/sdc        3.63TiB
   /dev/sdd        3.63TiB
   /dev/sde        3.63TiB
   /dev/sdf      396.92GiB
   /dev/sdg      396.92GiB
   /dev/sdh        3.63TiB
   /dev/sdi        3.63TiB
   /dev/sdj      975.13GiB
   /dev/sdk      984.29GiB
   /dev/sdl        3.63TiB
   /dev/sdm        1.81TiB
   /dev/sdn        1.81TiB
   /dev/sdo        1.81TiB
   /dev/sdp        1.81TiB
   /dev/sdq        1.81TiB
   /dev/sdr        1.36TiB
   /dev/sds        3.63TiB
   /dev/sdt        3.63TiB
   /dev/sdu        3.63TiB
   /dev/sdv        3.63TiB
   /dev/sdw        1.81TiB
   /dev/sdx        1.81TiB


Metadata,RAID10: Size:98.39GiB, Used:97.15GiB
   /dev/sda        7.31GiB
   /dev/sdb        3.66GiB
   /dev/sdc        3.51GiB
   /dev/sdd        3.51GiB
   /dev/sde        3.53GiB
   /dev/sdf        1.25GiB
   /dev/sdg        1.25GiB
   /dev/sdh        3.64GiB
   /dev/sdi        3.64GiB
   /dev/sdj        1.26GiB
   /dev/sdk        1.26GiB
   /dev/sdl        3.64GiB
   /dev/sdm        4.52GiB
   /dev/sdn        4.43GiB
   /dev/sdo        4.55GiB
   /dev/sdp        4.77GiB
   /dev/sdq        4.46GiB
   /dev/sdr        2.84GiB
   /dev/sds        3.51GiB
   /dev/sdt        7.35GiB
   /dev/sdu        7.35GiB
   /dev/sdv        7.35GiB
   /dev/sdw        4.80GiB
   /dev/sdx        4.97GiB


System,RAID10: Size:176.00MiB, Used:161.53MiB
   /dev/sda        8.00MiB
   /dev/sdb        8.00MiB
   /dev/sdc        8.00MiB
   /dev/sdd        8.00MiB
   /dev/sde        8.00MiB
   /dev/sdh        8.00MiB
   /dev/sdi        8.00MiB
   /dev/sdj        8.00MiB
   /dev/sdk        8.00MiB
   /dev/sdl        8.00MiB
   /dev/sdm        8.00MiB
   /dev/sdn        8.00MiB
   /dev/sdo        8.00MiB
   /dev/sdp        8.00MiB
   /dev/sdq        8.00MiB
   /dev/sdr        8.00MiB
   /dev/sds        8.00MiB
   /dev/sdt        8.00MiB
   /dev/sdu        8.00MiB
   /dev/sdv        8.00MiB
   /dev/sdw        8.00MiB
   /dev/sdx        8.00MiB


Unallocated:
   /dev/sda        3.64TiB
   /dev/sdb        3.79TiB
   /dev/sdc        3.64TiB
   /dev/sdd        3.64TiB
   /dev/sde        3.64TiB
   /dev/sdf        6.89TiB
   /dev/sdg        6.89TiB
   /dev/sdh        3.64TiB
   /dev/sdi        3.64TiB
   /dev/sdj        6.32TiB
   /dev/sdk        6.31TiB
   /dev/sdl        3.64TiB
   /dev/sdm        1.82TiB
   /dev/sdn        1.82TiB
   /dev/sdo        1.82TiB
   /dev/sdp        1.82TiB
   /dev/sdq        1.82TiB
   /dev/sdr        1.36TiB
   /dev/sds        3.64TiB
   /dev/sdt        3.64TiB
   /dev/sdu        3.64TiB
   /dev/sdv        3.64TiB
   /dev/sdw        1.82TiB
   /dev/sdx        1.82TiB




# ./btrfs device usage /data
/dev/sda, ID: 19
   Device size:             7.28TiB
   Device slack:              0.00B
   Data,RAID10:           752.26GiB
   Data,RAID10:           198.46GiB
   Data,RAID10:           159.09GiB
   Data,RAID10:             9.32GiB
   Data,RAID10:             1.11TiB
   Data,RAID10:           447.50GiB
   Data,RAID10:           682.29GiB
   Data,RAID10:           173.50GiB
   Data,RAID10:           144.36GiB
   Data,RAID10:            13.87GiB
   Data,RAID10:           556.09MiB
   Metadata,RAID10:         4.21GiB
   Metadata,RAID10:         1.00GiB
   Metadata,RAID10:        72.72MiB
   Metadata,RAID10:         2.12MiB
   Metadata,RAID10:         1.97GiB
   Metadata,RAID10:        56.09MiB
   Metadata,RAID10:         1.19MiB
   Metadata,RAID10:         3.94MiB
   Metadata,RAID10:       448.00KiB
   System,RAID10:           8.00MiB
   Unallocated:             3.64TiB


/dev/sdb, ID: 28
   Device size:             7.28TiB
   Device slack:              0.00B
   Data,RAID10:             1.20TiB
   Data,RAID10:           447.54GiB
   Data,RAID10:           686.89GiB
   Data,RAID10:             8.18GiB
   Data,RAID10:           378.22GiB
   Data,RAID10:           173.50GiB
   Data,RAID10:           144.37GiB
   Data,RAID10:            14.38GiB
   Data,RAID10:           438.87GiB
   Data,RAID10:            37.02GiB
   Data,RAID10:           556.09MiB
   Metadata,RAID10:       113.16MiB
   Metadata,RAID10:         2.12MiB
   Metadata,RAID10:         1.97GiB
   Metadata,RAID10:        56.09MiB
   Metadata,RAID10:         1.38GiB
   Metadata,RAID10:         1.28MiB
   Metadata,RAID10:         3.94MiB
   Metadata,RAID10:         1.12MiB
   Metadata,RAID10:       128.84MiB
   Metadata,RAID10:        13.84MiB
   System,RAID10:           8.00MiB
   Unallocated:             3.79TiB


/dev/sdc, ID: 21
   Device size:             7.28TiB
   Device slack:              0.00B
   Data,RAID10:             1.61TiB
   Data,RAID10:           222.57GiB
   Data,RAID10:           254.47GiB
   Data,RAID10:           677.03GiB
   Data,RAID10:           113.23GiB
   Data,RAID10:           328.12GiB
   Data,RAID10:             1.98GiB
   Data,RAID10:            13.59GiB
   Data,RAID10:           437.12GiB
   Data,RAID10:            27.83GiB
   Data,RAID10:           556.09MiB
   Metadata,RAID10:       113.16MiB
   Metadata,RAID10:         2.12MiB
   Metadata,RAID10:         1.97GiB
   Metadata,RAID10:        56.09MiB
   Metadata,RAID10:         1.38GiB
   Metadata,RAID10:         1.28MiB
   Metadata,RAID10:         3.94MiB
   Metadata,RAID10:       416.00KiB
   System,RAID10:           8.00MiB
   Unallocated:             3.64TiB


/dev/sdd, ID: 22
   Device size:             7.28TiB
   Device slack:              0.00B
   Data,RAID10:             1.61TiB
   Data,RAID10:           222.59GiB
   Data,RAID10:           253.53GiB
   Data,RAID10:           676.58GiB
   Data,RAID10:           108.78GiB
   Data,RAID10:           333.74GiB
   Data,RAID10:             1.23GiB
   Data,RAID10:            13.60GiB
   Data,RAID10:           438.05GiB
   Data,RAID10:            27.85GiB
   Data,RAID10:           556.09MiB
   Metadata,RAID10:       107.72MiB
   Metadata,RAID10:         2.12MiB
   Metadata,RAID10:         1.97GiB
   Metadata,RAID10:        56.09MiB
   Metadata,RAID10:         1.38GiB
   Metadata,RAID10:         1.28MiB
   Metadata,RAID10:         3.94MiB
   Metadata,RAID10:       448.00KiB
   Metadata,RAID10:         4.56MiB
   System,RAID10:           8.00MiB
   Unallocated:             3.64TiB


/dev/sde, ID: 24
   Device size:             7.28TiB
   Device slack:              0.00B
   Data,RAID10:             1.61TiB
   Data,RAID10:           222.84GiB
   Data,RAID10:           256.66GiB
   Data,RAID10:           684.28GiB
   Data,RAID10:            94.79GiB
   Data,RAID10:           342.07GiB
   Data,RAID10:             5.70GiB
   Data,RAID10:            13.60GiB
   Data,RAID10:           438.74GiB
   Data,RAID10:            17.08GiB
   Data,RAID10:           556.09MiB
   Metadata,RAID10:       113.16MiB
   Metadata,RAID10:         2.12MiB
   Metadata,RAID10:         1.97GiB
   Metadata,RAID10:        56.09MiB
   Metadata,RAID10:         1.38GiB
   Metadata,RAID10:         1.28MiB
   Metadata,RAID10:         3.94MiB
   Metadata,RAID10:       512.00KiB
   Metadata,RAID10:        13.69MiB
   System,RAID10:           8.00MiB
   Unallocated:             3.64TiB


/dev/sdf, ID: 30
   Device size:             7.28TiB
   Device slack:              0.00B
   Data,RAID10:            12.45GiB
   Data,RAID10:           165.89GiB
   Data,RAID10:           826.41MiB
   Data,RAID10:           179.91MiB
   Data,RAID10:           361.84MiB
   Data,RAID10:            27.63GiB
   Data,RAID10:            10.73GiB
   Data,RAID10:           556.09MiB
   Data,RAID10:            28.41GiB
   Data,RAID10:             6.18GiB
   Data,RAID10:           143.75GiB
   Metadata,RAID10:         3.94MiB
   Metadata,RAID10:        64.00KiB
   Metadata,RAID10:       704.00KiB
   Metadata,RAID10:       224.00KiB
   Metadata,RAID10:        32.00KiB
   Metadata,RAID10:         1.50MiB
   Metadata,RAID10:         1.12MiB
   Metadata,RAID10:       128.84MiB
   Metadata,RAID10:       109.91MiB
   Metadata,RAID10:        13.84MiB
   Metadata,RAID10:         1.00GiB
   Unallocated:             6.89TiB


/dev/sdg, ID: 29
   Device size:             7.28TiB
   Device slack:              0.00B
   Data,RAID10:            12.45GiB
   Data,RAID10:           165.89GiB
   Data,RAID10:           826.41MiB
   Data,RAID10:           179.91MiB
   Data,RAID10:           361.84MiB
   Data,RAID10:            27.63GiB
   Data,RAID10:            10.73GiB
   Data,RAID10:           556.09MiB
   Data,RAID10:            28.41GiB
   Data,RAID10:             6.18GiB
   Data,RAID10:           143.75GiB
   Metadata,RAID10:         3.94MiB
   Metadata,RAID10:        64.00KiB
   Metadata,RAID10:       704.00KiB
   Metadata,RAID10:       224.00KiB
   Metadata,RAID10:        32.00KiB
   Metadata,RAID10:         1.50MiB
   Metadata,RAID10:         1.12MiB
   Metadata,RAID10:       128.84MiB
   Metadata,RAID10:       109.91MiB
   Metadata,RAID10:        13.84MiB
   Metadata,RAID10:         1.00GiB
   Unallocated:             6.89TiB


/dev/sdh, ID: 26
   Device size:             7.28TiB
   Device slack:              0.00B
   Data,RAID10:           334.81GiB
   Data,RAID10:             1.10TiB
   Data,RAID10:           447.54GiB
   Data,RAID10:           679.22GiB
   Data,RAID10:           357.15GiB
   Data,RAID10:           173.50GiB
   Data,RAID10:           144.36GiB
   Data,RAID10:            13.96GiB
   Data,RAID10:           429.38GiB
   Data,RAID10:            10.42GiB
   Data,RAID10:           556.09MiB
   Metadata,RAID10:       113.16MiB
   Metadata,RAID10:         2.12MiB
   Metadata,RAID10:         1.97GiB
   Metadata,RAID10:        56.09MiB
   Metadata,RAID10:         1.38GiB
   Metadata,RAID10:         1.28MiB
   Metadata,RAID10:         3.94MiB
   Metadata,RAID10:         1.12MiB
   Metadata,RAID10:       127.38MiB
   System,RAID10:           8.00MiB
   Unallocated:             3.64TiB


/dev/sdi, ID: 27
   Device size:             7.28TiB
   Device slack:              0.00B
   Data,RAID10:           334.81GiB
   Data,RAID10:             1.10TiB
   Data,RAID10:           447.50GiB
   Data,RAID10:           679.23GiB
   Data,RAID10:           357.14GiB
   Data,RAID10:           173.50GiB
   Data,RAID10:           144.37GiB
   Data,RAID10:            14.01GiB
   Data,RAID10:           429.38GiB
   Data,RAID10:            10.39GiB
   Data,RAID10:           556.09MiB
   Metadata,RAID10:       113.16MiB
   Metadata,RAID10:         2.12MiB
   Metadata,RAID10:         1.97GiB
   Metadata,RAID10:        56.09MiB
   Metadata,RAID10:         1.38GiB
   Metadata,RAID10:         1.28MiB
   Metadata,RAID10:         3.94MiB
   Metadata,RAID10:         1.12MiB
   Metadata,RAID10:       127.22MiB
   Metadata,RAID10:       160.00KiB
   System,RAID10:           8.00MiB
   Unallocated:             3.64TiB


/dev/sdj, ID: 3
   Device size:             7.28TiB
   Device slack:              0.00B
   Data,RAID10:            99.95GiB
   Data,RAID10:           564.06GiB
   Data,RAID10:           148.59GiB
   Data,RAID10:             7.34GiB
   Data,RAID10:           242.06MiB
   Data,RAID10:           556.09MiB
   Data,RAID10:           143.75GiB
   Data,RAID10:             7.81GiB
   Data,RAID10:             1.24GiB
   Data,RAID10:           497.31MiB
   Data,RAID10:             1.12GiB
   Metadata,RAID10:       113.16MiB
   Metadata,RAID10:         3.94MiB
   Metadata,RAID10:        64.00KiB
   Metadata,RAID10:       704.00KiB
   Metadata,RAID10:       224.00KiB
   Metadata,RAID10:        32.00KiB
   Metadata,RAID10:         1.50MiB
   Metadata,RAID10:         1.12MiB
   Metadata,RAID10:       128.84MiB
   Metadata,RAID10:        13.84MiB
   Metadata,RAID10:         1.00GiB
   System,RAID10:           8.00MiB
   Unallocated:             6.32TiB


/dev/sdk, ID: 2
   Device size:             7.28TiB
   Device slack:              0.00B
   Data,RAID10:            98.63GiB
   Data,RAID10:           635.62GiB
   Data,RAID10:           150.94GiB
   Data,RAID10:            11.54GiB
   Data,RAID10:           556.09MiB
   Data,RAID10:             2.11GiB
   Data,RAID10:             9.47GiB
   Data,RAID10:             3.77GiB
   Data,RAID10:            27.94GiB
   Data,RAID10:            43.00GiB
   Data,RAID10:           737.72MiB
   Metadata,RAID10:       113.16MiB
   Metadata,RAID10:         3.94MiB
   Metadata,RAID10:        64.00KiB
   Metadata,RAID10:       704.00KiB
   Metadata,RAID10:       224.00KiB
   Metadata,RAID10:        32.00KiB
   Metadata,RAID10:         1.50MiB
   Metadata,RAID10:         1.12MiB
   Metadata,RAID10:       128.84MiB
   Metadata,RAID10:        13.84MiB
   Metadata,RAID10:         1.00GiB
   System,RAID10:           8.00MiB
   Unallocated:             6.31TiB


/dev/sdl, ID: 25
   Device size:             7.28TiB
   Device slack:              0.00B
   Data,RAID10:           334.81GiB
   Data,RAID10:             1.10TiB
   Data,RAID10:           447.54GiB
   Data,RAID10:           679.20GiB
   Data,RAID10:           357.16GiB
   Data,RAID10:           173.50GiB
   Data,RAID10:           144.36GiB
   Data,RAID10:            13.92GiB
   Data,RAID10:           429.38GiB
   Data,RAID10:            10.47GiB
   Data,RAID10:           556.09MiB
   Metadata,RAID10:       113.16MiB
   Metadata,RAID10:         2.12MiB
   Metadata,RAID10:         1.97GiB
   Metadata,RAID10:        56.09MiB
   Metadata,RAID10:         1.38GiB
   Metadata,RAID10:         1.28MiB
   Metadata,RAID10:         3.94MiB
   Metadata,RAID10:         1.12MiB
   Metadata,RAID10:       127.38MiB
   System,RAID10:           8.00MiB
   Unallocated:             3.64TiB


/dev/sdm, ID: 11
   Device size:             3.64TiB
   Device slack:              0.00B
   Data,RAID10:           314.67GiB
   Data,RAID10:           145.96GiB
   Data,RAID10:            89.84MiB
   Data,RAID10:           402.85GiB
   Data,RAID10:           677.12GiB
   Data,RAID10:           173.06GiB
   Data,RAID10:           143.39GiB
   Data,RAID10:           812.25MiB
   Data,RAID10:           556.09MiB
   Metadata,RAID10:         2.84GiB
   Metadata,RAID10:       113.16MiB
   Metadata,RAID10:         2.09MiB
   Metadata,RAID10:         1.57GiB
   Metadata,RAID10:         3.94MiB
   System,RAID10:           8.00MiB
   Unallocated:             1.82TiB


/dev/sdn, ID: 12
   Device size:             3.64TiB
   Device slack:              0.00B
   Data,RAID10:           314.78GiB
   Data,RAID10:           145.98GiB
   Data,RAID10:            36.94MiB
   Data,RAID10:           401.43GiB
   Data,RAID10:           676.85GiB
   Data,RAID10:           718.41MiB
   Data,RAID10:           173.41GiB
   Data,RAID10:           143.81GiB
   Data,RAID10:             1.03GiB
   Data,RAID10:           556.09MiB
   Metadata,RAID10:         2.84GiB
   Metadata,RAID10:       113.16MiB
   Metadata,RAID10:         2.06MiB
   Metadata,RAID10:         1.48GiB
   Metadata,RAID10:         1.06MiB
   Metadata,RAID10:        96.00KiB
   Metadata,RAID10:         3.94MiB
   System,RAID10:           8.00MiB
   Unallocated:             1.82TiB


/dev/sdo, ID: 5
   Device size:             3.64TiB
   Device slack:              0.00B
   Data,RAID10:           314.80GiB
   Data,RAID10:           146.27GiB
   Data,RAID10:            40.91MiB
   Data,RAID10:           256.00KiB
   Data,RAID10:           402.14GiB
   Data,RAID10:           676.76GiB
   Data,RAID10:           173.30GiB
   Data,RAID10:           143.69GiB
   Data,RAID10:           917.16MiB
   Data,RAID10:           556.09MiB
   Metadata,RAID10:         2.84GiB
   Metadata,RAID10:       113.12MiB
   Metadata,RAID10:         2.06MiB
   Metadata,RAID10:         1.60GiB
   Metadata,RAID10:         3.94MiB
   System,RAID10:           8.00MiB
   Unallocated:             1.82TiB


/dev/sdp, ID: 13
   Device size:             3.64TiB
   Device slack:              0.00B
   Data,RAID10:           314.76GiB
   Data,RAID10:           146.03GiB
   Data,RAID10:            22.66MiB
   Data,RAID10:           402.40GiB
   Data,RAID10:           676.36GiB
   Data,RAID10:           222.78MiB
   Data,RAID10:           173.38GiB
   Data,RAID10:           143.53GiB
   Data,RAID10:          1012.56MiB
   Data,RAID10:           556.09MiB
   Metadata,RAID10:         2.84GiB
   Metadata,RAID10:        49.16MiB
   Metadata,RAID10:         2.12MiB
   Metadata,RAID10:         1.82GiB
   Metadata,RAID10:        55.97MiB
   Metadata,RAID10:         1.25MiB
   Metadata,RAID10:         3.94MiB
   System,RAID10:           8.00MiB
   Unallocated:             1.82TiB


/dev/sdq, ID: 14
   Device size:             3.64TiB
   Device slack:              0.00B
   Data,RAID10:           314.69GiB
   Data,RAID10:           145.85GiB
   Data,RAID10:            39.56MiB
   Data,RAID10:           402.61GiB
   Data,RAID10:           677.01GiB
   Data,RAID10:           173.26GiB
   Data,RAID10:           143.64GiB
   Data,RAID10:           926.91MiB
   Data,RAID10:           556.09MiB
   Metadata,RAID10:         2.84GiB
   Metadata,RAID10:       113.16MiB
   Metadata,RAID10:         2.12MiB
   Metadata,RAID10:         1.51GiB
   Metadata,RAID10:         1.06MiB
   Metadata,RAID10:        32.00KiB
   Metadata,RAID10:         3.94MiB
   System,RAID10:           8.00MiB
   Unallocated:             1.82TiB


/dev/sdr, ID: 7
   Device size:             2.73TiB
   Device slack:              0.00B
   Data,RAID10:           314.71GiB
   Data,RAID10:           120.72GiB
   Data,RAID10:           674.29GiB
   Data,RAID10:            56.00MiB
   Data,RAID10:           171.72GiB
   Data,RAID10:           112.30GiB
   Data,RAID10:             6.38MiB
   Data,RAID10:            57.69MiB
   Data,RAID10:           556.09MiB
   Data,RAID10:           320.00KiB
   Metadata,RAID10:         2.84GiB
   Metadata,RAID10:         3.25MiB
   Metadata,RAID10:         2.06MiB
   Metadata,RAID10:         3.94MiB
   System,RAID10:           8.00MiB
   Unallocated:             1.36TiB


/dev/sds, ID: 23
   Device size:             7.28TiB
   Device slack:              0.00B
   Data,RAID10:             1.61TiB
   Data,RAID10:           222.60GiB
   Data,RAID10:           251.27GiB
   Data,RAID10:           677.15GiB
   Data,RAID10:            80.11GiB
   Data,RAID10:           347.19GiB
   Data,RAID10:             8.14GiB
   Data,RAID10:            13.61GiB
   Data,RAID10:           438.87GiB
   Data,RAID10:            37.00GiB
   Data,RAID10:           556.09MiB
   Metadata,RAID10:       113.16MiB
   Metadata,RAID10:         2.12MiB
   Metadata,RAID10:         1.97GiB
   Metadata,RAID10:        56.09MiB
   Metadata,RAID10:         1.38GiB
   Metadata,RAID10:         1.28MiB
   Metadata,RAID10:         3.94MiB
   Metadata,RAID10:       480.00KiB
   System,RAID10:           8.00MiB
   Unallocated:             3.64TiB


/dev/sdt, ID: 20
   Device size:             7.28TiB
   Device slack:              0.00B
   Data,RAID10:           752.26GiB
   Data,RAID10:           198.82GiB
   Data,RAID10:           159.09GiB
   Data,RAID10:             8.84GiB
   Data,RAID10:             1.11TiB
   Data,RAID10:           447.50GiB
   Data,RAID10:           682.27GiB
   Data,RAID10:           173.50GiB
   Data,RAID10:           144.37GiB
   Data,RAID10:            13.97GiB
   Data,RAID10:           556.09MiB
   Metadata,RAID10:         4.21GiB
   Metadata,RAID10:         1.00GiB
   Metadata,RAID10:       113.16MiB
   Metadata,RAID10:         2.12MiB
   Metadata,RAID10:         1.97GiB
   Metadata,RAID10:        56.06MiB
   Metadata,RAID10:         1.22MiB
   Metadata,RAID10:         3.94MiB
   System,RAID10:           8.00MiB
   Unallocated:             3.64TiB


/dev/sdu, ID: 18
   Device size:             7.28TiB
   Device slack:              0.00B
   Data,RAID10:           752.34GiB
   Data,RAID10:           197.75GiB
   Data,RAID10:           159.11GiB
   Data,RAID10:             9.80GiB
   Data,RAID10:             1.11TiB
   Data,RAID10:           447.50GiB
   Data,RAID10:           682.29GiB
   Data,RAID10:           173.50GiB
   Data,RAID10:           144.33GiB
   Data,RAID10:            14.00GiB
   Data,RAID10:           556.09MiB
   Metadata,RAID10:         4.21GiB
   Metadata,RAID10:         1.00GiB
   Metadata,RAID10:       113.16MiB
   Metadata,RAID10:         2.12MiB
   Metadata,RAID10:         1.97GiB
   Metadata,RAID10:        56.06MiB
   Metadata,RAID10:         1.28MiB
   Metadata,RAID10:         3.94MiB
   System,RAID10:           8.00MiB
   Unallocated:             3.64TiB


/dev/sdv, ID: 17
   Device size:             7.28TiB
   Device slack:              0.00B
   Data,RAID10:           752.26GiB
   Data,RAID10:           198.10GiB
   Data,RAID10:           159.09GiB
   Data,RAID10:             9.63GiB
   Data,RAID10:             1.11TiB
   Data,RAID10:           447.51GiB
   Data,RAID10:           682.23GiB
   Data,RAID10:           173.50GiB
   Data,RAID10:           144.36GiB
   Data,RAID10:            13.93GiB
   Data,RAID10:           556.09MiB
   Metadata,RAID10:         4.21GiB
   Metadata,RAID10:         1.00GiB
   Metadata,RAID10:       113.16MiB
   Metadata,RAID10:         2.12MiB
   Metadata,RAID10:         1.97GiB
   Metadata,RAID10:        56.06MiB
   Metadata,RAID10:         1.25MiB
   Metadata,RAID10:         3.94MiB
   System,RAID10:           8.00MiB
   Unallocated:             3.64TiB


/dev/sdw, ID: 15
   Device size:             3.64TiB
   Device slack:              0.00B
   Data,RAID10:           315.83GiB
   Data,RAID10:           136.74GiB
   Data,RAID10:           106.75MiB
   Data,RAID10:             8.84GiB
   Data,RAID10:           402.49GiB
   Data,RAID10:           675.85GiB
   Data,RAID10:           173.30GiB
   Data,RAID10:           143.54GiB
   Data,RAID10:           982.12MiB
   Data,RAID10:           556.09MiB
   Metadata,RAID10:         2.84GiB
   Metadata,RAID10:       113.16MiB
   Metadata,RAID10:         2.09MiB
   Metadata,RAID10:         1.85GiB
   Metadata,RAID10:         3.94MiB
   System,RAID10:           8.00MiB
   Unallocated:             1.82TiB


/dev/sdx, ID: 16
   Device size:             3.64TiB
   Device slack:              0.00B
   Data,RAID10:           317.16GiB
   Data,RAID10:           144.32GiB
   Data,RAID10:           109.75MiB
   Data,RAID10:             8.84GiB
   Data,RAID10:           390.83GiB
   Data,RAID10:           677.23GiB
   Data,RAID10:           173.40GiB
   Data,RAID10:           143.58GiB
   Data,RAID10:             2.01GiB
   Data,RAID10:           556.09MiB
   Metadata,RAID10:         2.84GiB
   Metadata,RAID10:       113.16MiB
   Metadata,RAID10:         2.12MiB
   Metadata,RAID10:         1.97GiB
   Metadata,RAID10:        56.06MiB
   Metadata,RAID10:         1.06MiB
   Metadata,RAID10:         3.94MiB
   System,RAID10:           8.00MiB
   Unallocated:             1.82TiB






