Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50821 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752342AbcLOX1p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Dec 2016 18:27:45 -0500
MIME-Version: 1.0
Message-ID: <trinity-eae9d313-0a5c-4be2-a3f9-43445f5b59ec-1481844067295@3capp-mailcom-bs09>
From: "Xin Zhou" <xin.zhou@gmx.com>
To: =?UTF-8?Q?=22=D0=9A=D1=80=D0=B0=D0=B2=D1=86=D0=BE?=
         =?UTF-8?Q?=D0=B2_=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD?=
         =?UTF-8?Q?_=D0=92=D0=BB=D0=B0=D0=B4=D0=B8=D0=BC?=
         =?UTF-8?Q?=D0=B8=D1=80=D0=BE=D0=B2=D0=B8=D1=87=22?=
        <r.kravtsov@sigm
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Server hangs when mount BTRFS filesystem.
Content-Type: text/plain; charset=UTF-8
Date: Fri, 16 Dec 2016 00:21:07 +0100
In-Reply-To: <aa202cef-db37-5ed2-b48e-a76d65462f47@sigma-it.ru>
References: <aa202cef-db37-5ed2-b48e-a76d65462f47@sigma-it.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Кравцов,

>From the log message, it seems dm-22 has been running out space, probably some checksum did not get committed to disk.
And when trying to repair, it reports checksum missing.


merge_reloc_roots:2426: errno=-28 No space left
Dec 15 00:05:47 OraCI2 kernel: BTRFS warning (device dm-22): Skipping
commit of aborted transaction.
Dec 15 00:05:47 OraCI2 kernel: BTRFS: error (device dm-22) in
cleanup_transaction:1854: errno=-28 No space left
Dec 15 00:05:57 OraCI2 kernel: pending csums is 34287616

...
ERROR: errors found in extent allocation tree or chunk allocation
Fixed 0 roots.
checking free space cache [.]
root 5 inode 28350 errors 1000, some csum missing
root 5 inode 28351 errors 1000, some csum missing

Thanks,
Xin
 
 

Sent: Thursday, December 15, 2016 at 12:58 AM
From: "Кравцов Роман Владимирович" <r.kravtsov@sigma-it.ru>
To: linux-btrfs@vger.kernel.org
Subject: Server hangs when mount BTRFS filesystem.
Hello.

First, server is hangs when btrfs balance working (see logs below).
After server reset can't mount filesystem.

When trying to execute command

# mount -t btrfs /dev/OraCI2/pes.isuse_bp.stands
/var/lib/docker/db/pes.isuse_bp.stands/pes.isuse_bp.standby.base/

server hangs without any messages and log records.


# btrfs --version
btrfs-progs v4.8.3

# btrfs fi show /dev/mapper/OraCI2-pes.isuse_bp.stands
Label: 'pes.isuse_bp.stands' uuid: ada5d777-565b-48e7-87dc-c58c8ad13466
Total devices 1 FS bytes used 2.24TiB
devid 1 size 3.49TiB used 2.35TiB path
/dev/mapper/OraCI2-pes.isuse_bp.stands



# btrfsck --repair -p /dev/OraCI2/pes.isuse_bp.stands
enabling repair mode
Checking filesystem on /dev/OraCI2/pes.isuse_bp.stands
UUID: ada5d777-565b-48e7-87dc-c58c8ad13466
parent transid verify failed on 2651226128384 wanted 136007 found 136176
parent transid verify failed on 2651226128384 wanted 136007 found 136176
Ignoring transid failure
leaf parent key incorrect 2651226128384
bad block 2651226128384

ERROR: errors found in extent allocation tree or chunk allocation
Fixed 0 roots.
checking free space cache [.]
root 5 inode 28350 errors 1000, some csum missing
root 5 inode 28351 errors 1000, some csum missing
root 5 inode 28354 errors 1000, some csum missing
root 5 inode 28358 errors 1000, some csum missing
root 5 inode 28360 errors 1000, some csum missing
root 5 inode 28361 errors 1000, some csum missing
root 5 inode 28368 errors 1000, some csum missing
root 5 inode 28369 errors 1000, some csum missing
root 5 inode 28370 errors 1000, some csum missing
root 5 inode 28371 errors 1000, some csum missing
root 5 inode 28372 errors 1000, some csum missing
root 5 inode 28373 errors 1000, some csum missing
root 5 inode 28376 errors 1000, some csum missing
root 5 inode 28377 errors 1000, some csum missing
root 5 inode 28378 errors 1000, some csum missing
root 5 inode 28379 errors 1000, some csum missing
root 5 inode 28380 errors 1000, some csum missing
root 5 inode 28381 errors 1000, some csum missing
root 5 inode 28382 errors 1000, some csum missing
root 5 inode 28383 errors 1000, some csum missing
root 5 inode 28384 errors 1000, some csum missing
root 5 inode 28385 errors 1000, some csum missing
root 5 inode 28386 errors 1000, some csum missing
root 5 inode 28387 errors 1000, some csum missing
root 5 inode 28388 errors 1000, some csum missing
root 5 inode 28389 errors 1000, some csum missing
root 5 inode 28390 errors 1000, some csum missing
root 5 inode 28391 errors 1000, some csum missing
root 5 inode 28392 errors 1000, some csum missing
root 5 inode 28393 errors 1000, some csum missing
root 5 inode 28394 errors 1000, some csum missing
root 5 inode 28395 errors 1000, some csum missing
root 5 inode 28396 errors 1000, some csum missing
root 5 inode 55108 errors 1000, some csum missing
root 5 inode 55313 errors 1000, some csum missing
root 5 inode 55314 errors 1000, some csum missing
root 5 inode 55315 errors 1000, some csum missing
root 5 inode 55316 errors 1000, some csum missing
root 5 inode 55317 errors 1000, some csum missing
root 5 inode 55318 errors 1000, some csum missing

checking csums
checking root refs
Recowing metadata block 2651226128384
found 2462630760448 bytes used err is 0
total csum bytes: 2398866488
total tree bytes: 5910593536
total fs tree bytes: 1679392768
total extent tree bytes: 1436450816
btree space waste bytes: 887715010
file data blocks allocated: 459312458981376
referenced 2199769403392
extent buffer leak: start 2651226128384 len 16384


# cat /var/log/messages | grep 'Dec 15 00'
Dec 15 00:02:35 OraCI2 kernel: BTRFS info (device dm-22): found 41156
extents
Dec 15 00:02:35 OraCI2 kernel: BTRFS info (device dm-22): relocating
block group 2568411414528 flags 1
Dec 15 00:02:37 OraCI2 kernel: BTRFS info (device dm-22): found 34939
extents
Dec 15 00:05:47 OraCI2 kernel: use_block_rsv: 20 callbacks suppressed
Dec 15 00:05:47 OraCI2 kernel: ------------[ cut here ]------------
Dec 15 00:05:47 OraCI2 kernel: WARNING: CPU: 35 PID: 30215 at
fs/btrfs/extent-tree.c:8321 btrfs_alloc_tree_block+0x3b1/0x4c0 [btrfs]
Dec 15 00:05:47 OraCI2 kernel: Modules linked in: xt_nat veth
binfmt_misc dccp_diag dccp tcp_diag udp_diag inet_diag unix_diag
xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter
nf_nat nf_conntrack bonding sb_edac edac_core x86_pkg_temp_thermal
coretemp kvm_intel kvm dm_thin_pool irqbypass dm_persistent_data
dm_bio_prison dm_bufio crct10dif_pclmul crc32_pclmul btrfs
ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper
cryptd intel_cstate intel_rapl_perf xor ses enclosure joydev mei_me
ipmi_devintf scsi_transport_sas iTCO_wdt pcspkr mxm_wmi
iTCO_vendor_support input_leds mei sg raid6_pq i2c_i801 lpc_ich
i2c_smbus mfd_core ipmi_si ipmi_msghandler shpchp ioatdma wmi acpi_pad
acpi_power_meter ip_tables xfs libcrc32c sd_mod
Dec 15 00:05:47 OraCI2 kernel: crc32c_intel ast drm_kms_helper
syscopyarea nvme sysfillrect sysimgblt aacraid fb_sys_fops nvme_core ttm
ahci ixgbe libahci igb mdio drm ptp pps_core libata i2c_algo_bit dca
fjes dm_mirror dm_region_hash dm_log dm_mod
Dec 15 00:05:47 OraCI2 kernel: CPU: 35 PID: 30215 Comm: btrfs-transacti
Tainted: G W 4.8.11-1.el7.elrepo.x86_64 #1
Dec 15 00:05:47 OraCI2 kernel: Hardware name: Supermicro X10DRi/X10DRi,
BIOS 2.0 12/28/2015
Dec 15 00:05:47 OraCI2 kernel: 0000000000000286 00000000ada48348
ffff881d00aeb7f0 ffffffff8135cc9c
Dec 15 00:05:47 OraCI2 kernel: ffff881d00aeb840 0000000000000000
ffff881d00aeb830 ffffffff810817b1
Dec 15 00:05:47 OraCI2 kernel: 0000208100aeb810 ffff880e10f3c000
0000000000004000 ffff8801f3172000
Dec 15 00:05:47 OraCI2 kernel: Call Trace:
Dec 15 00:05:47 OraCI2 kernel: [<ffffffff8135cc9c>] dump_stack+0x63/0x87
Dec 15 00:05:47 OraCI2 kernel: [<ffffffff810817b1>] __warn+0xd1/0xf0
Dec 15 00:05:47 OraCI2 kernel: [<ffffffff8108182f>]
warn_slowpath_fmt+0x5f/0x80
Dec 15 00:05:47 OraCI2 kernel: [<ffffffff8136359c>] ? ___ratelimit+0x8c/0xf0
Dec 15 00:05:47 OraCI2 kernel: [<ffffffffa0736a41>]
btrfs_alloc_tree_block+0x3b1/0x4c0 [btrfs]
Dec 15 00:05:47 OraCI2 kernel: [<ffffffffa076fb58>] ?
read_extent_buffer+0xb8/0x110 [btrfs]
Dec 15 00:05:47 OraCI2 kernel: [<ffffffffa071cc8b>]
__btrfs_cow_block+0x12b/0x5c0 [btrfs]
Dec 15 00:05:47 OraCI2 kernel: [<ffffffffa071d2bf>]
btrfs_cow_block+0x11f/0x1f0 [btrfs]
Dec 15 00:05:47 OraCI2 kernel: [<ffffffffa0720f13>]
btrfs_search_slot+0x1e3/0x990 [btrfs]
Dec 15 00:05:47 OraCI2 kernel: [<ffffffffa07273ce>]
lookup_inline_extent_backref+0xee/0x5a0 [btrfs]
Dec 15 00:05:47 OraCI2 kernel: [<ffffffffa0742aaa>] ?
btrfs_mark_buffer_dirty+0x8a/0xc0 [btrfs]
Dec 15 00:05:47 OraCI2 kernel: [<ffffffffa07278e8>]
insert_inline_extent_backref+0x68/0xf0 [btrfs]
Dec 15 00:05:47 OraCI2 kernel: [<ffffffffa071c02a>] ?
btrfs_alloc_path+0x1a/0x20 [btrfs]
Dec 15 00:05:47 OraCI2 kernel: [<ffffffffa0727a0c>]
__btrfs_inc_extent_ref.isra.55+0x9c/0x260 [btrfs]
Dec 15 00:05:47 OraCI2 kernel: [<ffffffffa072ec92>]
__btrfs_run_delayed_refs.constprop.78+0x942/0x1250 [btrfs]
Dec 15 00:05:47 OraCI2 kernel: [<ffffffff811fde01>] ? __slab_free+0xe1/0x280
Dec 15 00:05:47 OraCI2 kernel: [<ffffffffa073246e>]
btrfs_run_delayed_refs+0x8e/0x2c0 [btrfs]
Dec 15 00:05:47 OraCI2 kernel: [<ffffffffa0749965>]
btrfs_commit_transaction+0x465/0xa70 [btrfs]
Dec 15 00:05:47 OraCI2 kernel: [<ffffffffa0743df2>]
transaction_kthread+0x1d2/0x200 [btrfs]
Dec 15 00:05:47 OraCI2 kernel: [<ffffffffa0743c20>] ?
btrfs_cleanup_transaction+0x580/0x580 [btrfs]
Dec 15 00:05:47 OraCI2 kernel: [<ffffffff810a1168>] kthread+0xd8/0xf0
Dec 15 00:05:47 OraCI2 kernel: [<ffffffff817453ff>] ret_from_fork+0x1f/0x40
Dec 15 00:05:47 OraCI2 kernel: [<ffffffff810a1090>] ? kthread_park+0x60/0x60
Dec 15 00:05:47 OraCI2 kernel: ---[ end trace 0eaaeed132c15765 ]---
Dec 15 00:05:47 OraCI2 kernel: ------------[ cut here ]------------
Dec 15 00:05:47 OraCI2 kernel: WARNING: CPU: 35 PID: 30215 at
fs/btrfs/extent-tree.c:2960 btrfs_run_delayed_refs+0x28f/0x2c0 [btrfs]
Dec 15 00:05:47 OraCI2 kernel: Modules linked in: xt_nat veth
binfmt_misc dccp_diag dccp tcp_diag udp_diag inet_diag unix_diag
xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter
nf_nat nf_conntrack bonding sb_edac edac_core x86_pkg_temp_thermal
coretemp kvm_intel kvm dm_thin_pool irqbypass dm_persistent_data
dm_bio_prison dm_bufio crct10dif_pclmul crc32_pclmul btrfs
ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper
cryptd intel_cstate intel_rapl_perf xor ses enclosure joydev mei_me
ipmi_devintf scsi_transport_sas iTCO_wdt pcspkr mxm_wmi
iTCO_vendor_support input_leds mei sg raid6_pq i2c_i801 lpc_ich
i2c_smbus mfd_core ipmi_si ipmi_msghandler shpchp ioatdma wmi acpi_pad
acpi_power_meter ip_tables xfs libcrc32c sd_mod
Dec 15 00:05:47 OraCI2 kernel: crc32c_intel ast drm_kms_helper
syscopyarea nvme sysfillrect sysimgblt aacraid fb_sys_fops nvme_core ttm
ahci ixgbe libahci igb mdio drm ptp pps_core libata i2c_algo_bit dca
fjes dm_mirror dm_region_hash dm_log dm_mod
Dec 15 00:05:47 OraCI2 kernel: CPU: 35 PID: 30215 Comm: btrfs-transacti
Tainted: G W 4.8.11-1.el7.elrepo.x86_64 #1
Dec 15 00:05:47 OraCI2 kernel: Hardware name: Supermicro X10DRi/X10DRi,
BIOS 2.0 12/28/2015
Dec 15 00:05:47 OraCI2 kernel: 0000000000000286 00000000ada48348
ffff881d00aebd08 ffffffff8135cc9c
Dec 15 00:05:47 OraCI2 kernel: ffff881d00aebd58 0000000000000000
ffff881d00aebd48 ffffffff810817b1
Dec 15 00:05:47 OraCI2 kernel: 00000b900005676b ffff8826573f4c80
ffff883ecd9aa9f0 ffff882396858000
Dec 15 00:05:47 OraCI2 kernel: Call Trace:
Dec 15 00:05:47 OraCI2 kernel: [<ffffffff8135cc9c>] dump_stack+0x63/0x87
Dec 15 00:05:47 OraCI2 kernel: [<ffffffff810817b1>] __warn+0xd1/0xf0
Dec 15 00:05:47 OraCI2 kernel: [<ffffffff8108182f>]
warn_slowpath_fmt+0x5f/0x80
Dec 15 00:05:47 OraCI2 kernel: [<ffffffffa073266f>]
btrfs_run_delayed_refs+0x28f/0x2c0 [btrfs]
Dec 15 00:05:47 OraCI2 kernel: [<ffffffffa0749965>]
btrfs_commit_transaction+0x465/0xa70 [btrfs]
Dec 15 00:05:47 OraCI2 kernel: [<ffffffffa0743df2>]
transaction_kthread+0x1d2/0x200 [btrfs]
Dec 15 00:05:47 OraCI2 kernel: [<ffffffffa0743c20>] ?
btrfs_cleanup_transaction+0x580/0x580 [btrfs]
Dec 15 00:05:47 OraCI2 kernel: [<ffffffff810a1168>] kthread+0xd8/0xf0
Dec 15 00:05:47 OraCI2 kernel: [<ffffffff817453ff>] ret_from_fork+0x1f/0x40
Dec 15 00:05:47 OraCI2 kernel: [<ffffffff810a1090>] ? kthread_park+0x60/0x60
Dec 15 00:05:47 OraCI2 kernel: ---[ end trace 0eaaeed132c15766 ]---
Dec 15 00:05:47 OraCI2 kernel: BTRFS: error (device dm-22) in
btrfs_run_delayed_refs:2960: errno=-28 No space left
Dec 15 00:05:47 OraCI2 kernel: BTRFS: error (device dm-22) in
btrfs_drop_snapshot:9389: errno=-28 No space left
Dec 15 00:05:47 OraCI2 kernel: BTRFS info (device dm-22): forced readonly
Dec 15 00:05:47 OraCI2 kernel: BTRFS: error (device dm-22) in
merge_reloc_roots:2426: errno=-28 No space left
Dec 15 00:05:47 OraCI2 kernel: BTRFS warning (device dm-22): Skipping
commit of aborted transaction.
Dec 15 00:05:47 OraCI2 kernel: BTRFS: error (device dm-22) in
cleanup_transaction:1854: errno=-28 No space left
Dec 15 00:05:57 OraCI2 kernel: pending csums is 34287616




WBR,
Roman Kravtsov

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at http://vger.kernel.org/majordomo-info.html
