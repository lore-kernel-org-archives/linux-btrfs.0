Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.sigma-it.ru ([212.65.87.1]:42975 "EHLO mail.sigma-it.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756715AbcKKOLT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Nov 2016 09:11:19 -0500
Subject: Re: Deletion of the CoW snapshots causes BTRFS ENOSPC error.
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <8dbbf4f2-9770-ea4d-00b7-768cee84ddc1@sigma-it.ru>
 <1e110719-e7f1-6004-d3dc-dbc7b09e7397@cn.fujitsu.com>
From: =?UTF-8?B?0JrRgNCw0LLRhtC+0LIg0KDQvtC80LDQvSDQktC70LDQtNC40LzQuNGA0L4=?=
         =?UTF-8?B?0LLQuNGH?= <r.kravtsov@sigma-it.ru>
Message-ID: <281b8254-7aed-941c-f6f9-09ba143b8b42@sigma-it.ru>
Date: Fri, 11 Nov 2016 17:11:14 +0300
MIME-Version: 1.0
In-Reply-To: <1e110719-e7f1-6004-d3dc-dbc7b09e7397@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Qu.

After applying the patch https://patchwork.kernel.org/patch/9319179/, 
the NOSPC error is repeated on the same scenario.

We also noticed that the error appears when the "Data, single: 
used=4.39TiB" is reached.


Details:

[root@OraCI2 ~]# uname -a
Linux OraCI2.sigma-it.local 4.8.6-1.Sigma_LLC.el7.centos.x86_64 #1 SMP 
Thu Nov 10 15:50:51 MSK 2016 x86_64 x86_64 x86_64 GNU/Linux

[root@OraCI2 ~]# btrfs fi df /var/lib/docker/db/STANDS
Data, single: total=4.94TiB, used=4.39TiB
System, DUP: total=8.00MiB, used=608.00KiB
Metadata, DUP: total=39.00GiB, used=25.29GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
[root@OraCI2 ~]#

Nov 11 16:48:53 OraCI2 kernel: ------------[ cut here ]------------
Nov 11 16:48:53 OraCI2 kernel: WARNING: CPU: 29 PID: 25579 at 
fs/btrfs/extent-tree.c:8321 btrfs_alloc_tree_block+0x3b1/0x4c0 [btrfs]
Nov 11 16:48:53 OraCI2 kernel: Modules linked in: xt_nat veth 
binfmt_misc xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype 
iptable_filter ip_tables nf_nat nf_conntrack bonding sb_edac edac_core 
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm 
dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio irqbypass 
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel lrw 
gf128mul glue_helper ablk_helper btrfs cryptd intel_cstate 
intel_rapl_perf xor ipmi_devintf iTCO_wdt iTCO_vendor_support mxm_wmi 
joydev input_leds ses i2c_i801 enclosure pcspkr mei_me 
scsi_transport_sas ipmi_si lpc_ich raid6_pq sg mei i2c_smbus mfd_core 
ioatdma ipmi_msghandler shpchp wmi acpi_power_meter acpi_pad xfs 
libcrc32c sd_mod crc32c_intel ast drm_kms_helper nvme
Nov 11 16:48:53 OraCI2 kernel: syscopyarea aacraid sysfillrect nvme_core 
sysimgblt fb_sys_fops ttm ahci libahci drm ixgbe igb mdio libata ptp 
i2c_algo_bit pps_core dca fjes dm_mirror dm_region_hash dm_log dm_mod
Nov 11 16:48:53 OraCI2 kernel: CPU: 29 PID: 25579 Comm: rm Not tainted 
4.8.6-1.Sigma_LLC.el7.centos.x86_64 #1
Nov 11 16:48:53 OraCI2 kernel: Hardware name: Supermicro X10DRi/X10DRi, 
BIOS 2.0 12/28/2015
Nov 11 16:48:53 OraCI2 kernel: 0000000000000286 00000000f727a709 
ffff88129532f748 ffffffff8135409f
Nov 11 16:48:53 OraCI2 kernel: ffff88129532f798 0000000000000000 
ffff88129532f788 ffffffff810817b1
Nov 11 16:48:53 OraCI2 kernel: 00002081f2350000 ffff883fe39f0800 
0000000000004000 ffff883ff2350000
Nov 11 16:48:53 OraCI2 kernel: Call Trace:
Nov 11 16:48:53 OraCI2 kernel: [<ffffffff8135409f>] dump_stack+0x63/0x84
Nov 11 16:48:53 OraCI2 kernel: [<ffffffff810817b1>] __warn+0xd1/0xf0
Nov 11 16:48:53 OraCI2 kernel: [<ffffffff8108182f>] 
warn_slowpath_fmt+0x5f/0x80
Nov 11 16:48:53 OraCI2 kernel: [<ffffffff8135a99c>] ? ___ratelimit+0x8c/0xf0
Nov 11 16:48:53 OraCI2 kernel: [<ffffffffa06a5a41>] 
btrfs_alloc_tree_block+0x3b1/0x4c0 [btrfs]
Nov 11 16:48:53 OraCI2 kernel: [<ffffffffa06deb58>] ? 
read_extent_buffer+0xb8/0x110 [btrfs]
Nov 11 16:48:53 OraCI2 kernel: [<ffffffffa068bc8b>] 
__btrfs_cow_block+0x12b/0x5c0 [btrfs]
Nov 11 16:48:53 OraCI2 kernel: [<ffffffffa068c2bf>] 
btrfs_cow_block+0x11f/0x1f0 [btrfs]
Nov 11 16:48:53 OraCI2 kernel: [<ffffffffa068ff13>] 
btrfs_search_slot+0x1e3/0x990 [btrfs]
Nov 11 16:48:53 OraCI2 kernel: [<ffffffffa06963ce>] 
lookup_inline_extent_backref+0xee/0x5a0 [btrfs]
Nov 11 16:48:53 OraCI2 kernel: [<ffffffffa068b02a>] ? 
btrfs_alloc_path+0x1a/0x20 [btrfs]
Nov 11 16:48:53 OraCI2 kernel: [<ffffffffa0698cca>] 
__btrfs_free_extent.isra.69+0x10a/0xca0 [btrfs]
Nov 11 16:48:53 OraCI2 kernel: [<ffffffffa069d7b7>] 
__btrfs_run_delayed_refs.constprop.78+0x467/0x1250 [btrfs]
Nov 11 16:48:53 OraCI2 kernel: [<ffffffffa06a146e>] 
btrfs_run_delayed_refs+0x8e/0x2c0 [btrfs]
Nov 11 16:48:53 OraCI2 kernel: [<ffffffffa06b8556>] 
btrfs_commit_transaction+0x56/0xa70 [btrfs]
Nov 11 16:48:53 OraCI2 kernel: [<ffffffffa06c590a>] 
btrfs_evict_inode+0x4aa/0x600 [btrfs]
Nov 11 16:48:53 OraCI2 kernel: [<ffffffff8123868a>] evict+0xba/0x1a0
Nov 11 16:48:53 OraCI2 kernel: [<ffffffff81239327>] iput+0x197/0x200
Nov 11 16:48:53 OraCI2 kernel: [<ffffffff8122c8e3>] do_unlinkat+0x1a3/0x2c0
Nov 11 16:48:53 OraCI2 kernel: [<ffffffff8122d52b>] SyS_unlinkat+0x1b/0x30
Nov 11 16:48:53 OraCI2 kernel: [<ffffffff81003a47>] do_syscall_64+0x67/0x160
Nov 11 16:48:53 OraCI2 kernel: [<ffffffff8173ac21>] 
entry_SYSCALL64_slow_path+0x25/0x25
Nov 11 16:48:53 OraCI2 kernel: ---[ end trace ab5b7522c4dc250b ]---
Nov 11 16:48:53 OraCI2 kernel: ------------[ cut here ]------------
Nov 11 16:48:53 OraCI2 kernel: WARNING: CPU: 29 PID: 25579 at 
fs/btrfs/extent-tree.c:6954 __btrfs_free_extent.isra.69+0x2ac/0xca0 [btrfs]
Nov 11 16:48:53 OraCI2 kernel: Modules linked in: xt_nat veth 
binfmt_misc xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype 
iptable_filter ip_tables nf_nat nf_conntrack bonding sb_edac edac_core 
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm 
dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio irqbypass 
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel lrw 
gf128mul glue_helper ablk_helper btrfs cryptd intel_cstate 
intel_rapl_perf xor ipmi_devintf iTCO_wdt iTCO_vendor_support mxm_wmi 
joydev input_leds ses i2c_i801 enclosure pcspkr mei_me 
scsi_transport_sas ipmi_si lpc_ich raid6_pq sg mei i2c_smbus mfd_core 
ioatdma ipmi_msghandler shpchp wmi acpi_power_meter acpi_pad xfs 
libcrc32c sd_mod crc32c_intel ast drm_kms_helper nvme
Nov 11 16:48:53 OraCI2 kernel: syscopyarea aacraid sysfillrect nvme_core 
sysimgblt fb_sys_fops ttm ahci libahci drm ixgbe igb mdio libata ptp 
i2c_algo_bit pps_core dca fjes dm_mirror dm_region_hash dm_log dm_mod
Nov 11 16:48:53 OraCI2 kernel: CPU: 29 PID: 25579 Comm: rm Tainted: 
G        W       4.8.6-1.Sigma_LLC.el7.centos.x86_64 #1
Nov 11 16:48:53 OraCI2 kernel: Hardware name: Supermicro X10DRi/X10DRi, 
BIOS 2.0 12/28/2015
Nov 11 16:48:53 OraCI2 kernel: 0000000000000286 00000000f727a709 
ffff88129532fa28 ffffffff8135409f
Nov 11 16:48:53 OraCI2 kernel: ffff88129532fa78 0000000000000000 
ffff88129532fa68 ffffffff810817b1
Nov 11 16:48:53 OraCI2 kernel: 00001b2a9532fa60 ffff8813aa4975b0 
000002ae72f02000 00000000ffffffe4
Nov 11 16:48:53 OraCI2 kernel: Call Trace:
Nov 11 16:48:53 OraCI2 kernel: [<ffffffff8135409f>] dump_stack+0x63/0x84
Nov 11 16:48:53 OraCI2 kernel: [<ffffffff810817b1>] __warn+0xd1/0xf0
Nov 11 16:48:53 OraCI2 kernel: [<ffffffff8108182f>] 
warn_slowpath_fmt+0x5f/0x80
Nov 11 16:48:53 OraCI2 kernel: [<ffffffffa0698e6c>] 
__btrfs_free_extent.isra.69+0x2ac/0xca0 [btrfs]
Nov 11 16:48:53 OraCI2 kernel: [<ffffffffa069d7b7>] 
__btrfs_run_delayed_refs.constprop.78+0x467/0x1250 [btrfs]
Nov 11 16:48:53 OraCI2 kernel: [<ffffffffa06a146e>] 
btrfs_run_delayed_refs+0x8e/0x2c0 [btrfs]
Nov 11 16:48:53 OraCI2 kernel: [<ffffffffa06b8556>] 
btrfs_commit_transaction+0x56/0xa70 [btrfs]
Nov 11 16:48:53 OraCI2 kernel: [<ffffffffa06c590a>] 
btrfs_evict_inode+0x4aa/0x600 [btrfs]
Nov 11 16:48:53 OraCI2 kernel: [<ffffffff8123868a>] evict+0xba/0x1a0
Nov 11 16:48:53 OraCI2 kernel: [<ffffffff81239327>] iput+0x197/0x200
Nov 11 16:48:53 OraCI2 kernel: [<ffffffff8122c8e3>] do_unlinkat+0x1a3/0x2c0
Nov 11 16:48:53 OraCI2 kernel: [<ffffffff8122d52b>] SyS_unlinkat+0x1b/0x30
Nov 11 16:48:53 OraCI2 kernel: [<ffffffff81003a47>] do_syscall_64+0x67/0x160
Nov 11 16:48:53 OraCI2 kernel: [<ffffffff8173ac21>] 
entry_SYSCALL64_slow_path+0x25/0x25
Nov 11 16:48:53 OraCI2 kernel: ---[ end trace ab5b7522c4dc250c ]---
Nov 11 16:48:53 OraCI2 kernel: BTRFS: error (device dm-3) in 
__btrfs_free_extent:6954: errno=-28 No space left
Nov 11 16:48:53 OraCI2 kernel: BTRFS info (device dm-3): forced readonly
Nov 11 16:48:53 OraCI2 kernel: BTRFS: error (device dm-3) in 
btrfs_run_delayed_refs:2960: errno=-28 No space left

С уважением,
Роман Кравцов
Техническая дирекция, Департамент системной интеграции, ведущий инженер эксперт
ООО "СИГМА"
Тел: +7 812 602 2772 доб. 166
Факс: +7 812 602 2770
Веб-сайт: www.sigma-it.ru

10.11.2016 12:18, Qu Wenruo пишет:
>
> This seems to be a known bug.
>
> Would you please try the follow patch?
> https://patchwork.kernel.org/patch/9319179/
>
>

