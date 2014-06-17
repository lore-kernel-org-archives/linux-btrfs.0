Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail2.fujitsu.co.jp ([164.71.1.135]:55881 "EHLO
	fgwmail2.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbaFQDGh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 23:06:37 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail2.fujitsu.co.jp (Postfix) with ESMTP id 316613EE0CB
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 12:06:35 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 4FD54AC054C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 12:06:34 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id E71E31DB8037
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 12:06:33 +0900 (JST)
Message-ID: <539FB0AE.7010404@jp.fujitsu.com>
Date: Tue, 17 Jun 2014 12:06:22 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [3.16-rc1] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u25:4:5189]
References: <539E9026.1020406@jp.fujitsu.com> <539F2FEA.1060809@fb.com> <539F7D8E.9010608@jp.fujitsu.com> <539F8351.3010700@fb.com> <539F846A.4080608@jp.fujitsu.com> <539F9006.4090109@fb.com> <539FA395.5050704@jp.fujitsu.com>
In-Reply-To: <539FA395.5050704@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/06/17 11:10, Tsutomu Itoh wrote:
> On 2014/06/17 9:47, Chris Mason wrote:
>> On 06/16/2014 07:57 PM, Tsutomu Itoh wrote:
>>> On 2014/06/17 8:52, Chris Mason wrote:
>>>> On 06/16/2014 07:28 PM, Tsutomu Itoh wrote:
>>>>> Hi Chris,
>>>>>
>>>>> On 2014/06/17 2:56, Chris Mason wrote:
>>>>>> On 06/16/2014 02:35 AM, Tsutomu Itoh wrote:
>>>>>>> I encountered soft lockup when executing 'xfstests btrfs/042' on 3.16-rc1.
>>>>>>>
>>>>>>
>>>>>> Did we recover, or was it stuck forever?
>>>>>
>>>>> The following messages are repeatedly output.
>>>>> And stuck forever.
>>>>>
>>>>> [ 1147.942181] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u25:4:5189]
>>>>> [ 1147.967175] BUG: soft lockup - CPU#3 stuck for 23s! [kworker/u25:9:5194]
>>>>> [ 1147.979172] BUG: soft lockup - CPU#4 stuck for 23s! [kworker/u25:15:5200]
>>>>> [ 1147.991169] BUG: soft lockup - CPU#5 stuck for 23s! [kworker/u25:7:5192]
>>>>> [ 1148.064153] BUG: soft lockup - CPU#6 stuck for 23s! [kworker/u26:3:3182]
>>>>
>>>> Can you please capture a stack trace from all the cpus?
>>
>> Very strange, please try to reproduce again, I'll dig through things here.
> 
> I can reproduce it easily in my environment.

This is my reproducer.

===================
#! /bin/bash

export TEST_DIR=/test5
export TEST_DEV=/dev/sdb4
TEST_DEV2=/dev/sdc6

export SCRATCH_MNT=/test6
export SCRATCH_DEV=/dev/sdc5

export MKFS_OPTIONS=""
export MOUNT_OPTIONS=""

umount ${TEST_DIR} ${SCRATCH_MNT}

mkfs.btrfs -f ${TEST_DEV} ${TEST_DEV2}

for i in $(seq 1 10)
do
        ./check 'btrfs/042'
done

umount ${TEST_DIR} ${SCRATCH_MNT}
===================

Stack trace is here.

==================
[ 1631.835052] BUG: soft lockup - CPU#0 stuck for 22s! [kworker/u25:1:193]
[ 1631.835053] BUG: soft lockup - CPU#1 stuck for 22s! [kworker/u25:3:3174]
[ 1631.835074] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables btrfs coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel nfsd xor raid6_pq igb microcode ptp pps_core dca iTCO_wdt auth_rpcgss shpchp iTCO_vendor_support nfs_acl i7core_edac pcspkr edac_core lpc_ich i2c_i801 mfd_core acpi_power_meter tpm_infineon tpm_tis tpm ipmi_si lockd ipmi_msghandler acpi_cpufreq sunrpc usb_storage mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm drm ata_generic pata_acpi megaraid_sas i2c_core ata_piix
[ 1631.835076] CPU: 1 PID: 3174 Comm: kworker/u25:3 Not tainted 3.16.0-rc1 #1
[ 1631.835076] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[ 1631.835094] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[ 1631.835094] task: ffff880073d60000 ti: ffff88007188c000 task.ti: ffff88007188c000
[ 1631.835097] RIP: 0010:[<ffffffff810ba858>]  [<ffffffff810ba858>] queue_read_lock_slowpath+0x68/0x90
[ 1631.835098] RSP: 0018:ffff88007188fac8  EFLAGS: 00000206
[ 1631.835098] RAX: 0000000000000033 RBX: 0000000000000000 RCX: 000000000000000a
[ 1631.835099] RDX: 0000000000000039 RSI: 000000000000000a RDI: ffff8801356755b0
[ 1631.835099] RBP: ffff88007188fac8 R08: ffff880135675574 R09: 0000000000000000
[ 1631.835100] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000001000
[ 1631.835100] R13: 0000000000000000 R14: ffff8800766d3000 R15: ffffffffa05800a1
[ 1631.835101] FS:  0000000000000000(0000) GS:ffff88007dc40000(0000) knlGS:0000000000000000
[ 1631.835101] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1631.835102] CR2: 0000000001858000 CR3: 0000000001c0e000 CR4: 00000000000007e0
[ 1631.835102] Stack:
[ 1631.835103]  ffff88007188fad8 ffffffff8166bcbc ffff88007188fb38 ffffffffa05da140
[ 1631.835104]  0000000000000069 0000000000000035 0000000000000000 ffff88007188fb58
[ 1631.835105]  ffffffffa057881f ffff880135675540 ffff8800b7117800 ffff880000000000
[ 1631.835105] Call Trace:
[ 1631.835109]  [<ffffffff8166bcbc>] _raw_read_lock+0x1c/0x30
[ 1631.835119]  [<ffffffffa05da140>] btrfs_tree_read_lock+0x50/0x100 [btrfs]
[ 1631.835124]  [<ffffffffa057881f>] ? leaf_space_used+0xcf/0x110 [btrfs]
[ 1631.835129]  [<ffffffffa057adeb>] btrfs_read_lock_root_node+0x3b/0x50 [btrfs]
[ 1631.835134]  [<ffffffffa057fc3e>] btrfs_search_slot+0x50e/0xa10 [btrfs]
[ 1631.835143]  [<ffffffffa05eaee4>] ? btrfs_add_delayed_data_ref+0x114/0x180 [btrfs]
[ 1631.835150]  [<ffffffffa0595e2e>] btrfs_lookup_csum+0x5e/0x180 [btrfs]
[ 1631.835157]  [<ffffffffa059719c>] btrfs_csum_file_blocks+0xbc/0x680 [btrfs]
[ 1631.835162]  [<ffffffffa057ad46>] ? btrfs_free_path+0x26/0x30 [btrfs]
[ 1631.835170]  [<ffffffffa05a51e0>] add_pending_csums.isra.42+0x50/0x80 [btrfs]
[ 1631.835178]  [<ffffffffa05ab410>] btrfs_finish_ordered_io+0x470/0x570 [btrfs]
[ 1631.835187]  [<ffffffffa05ab785>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1631.835196]  [<ffffffffa05d0b3c>] normal_work_helper+0xbc/0x290 [btrfs]
[ 1631.835198]  [<ffffffff8108ab95>] process_one_work+0x175/0x430
[ 1631.835199]  [<ffffffff8108b23b>] worker_thread+0x11b/0x520
[ 1631.835200]  [<ffffffff8108b120>] ? rescuer_thread+0x2d0/0x2d0
[ 1631.835201]  [<ffffffff81091712>] kthread+0xd2/0xf0
[ 1631.835203]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1631.835204]  [<ffffffff8166c23c>] ret_from_fork+0x7c/0xb0
[ 1631.835205]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1631.835215] Code: 00 00 00 f3 90 8b 07 84 c0 75 f8 b8 00 01 00 00 f0 0f c1 07 3c ff 75 0b 0f 1f 00 f3 90 8b 07 3c ff 74 f8 80 47 04 01 5d c3 f3 90 <0f> b6 47 04 38 c2 75 f6 eb bf 8b 07 3c ff 75 ec f3 90 8b 07 3c
[ 1631.849920] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables btrfs coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel nfsd xor raid6_pq igb microcode ptp pps_core dca iTCO_wdt auth_rpcgss shpchp iTCO_vendor_support nfs_acl i7core_edac pcspkr edac_core lpc_ich i2c_i801 mfd_core acpi_power_meter tpm_infineon tpm_tis tpm ipmi_si lockd ipmi_msghandler acpi_cpufreq sunrpc usb_storage mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm drm ata_generic pata_acpi megaraid_sas i2c_core ata_piix
[ 1631.849942] CPU: 0 PID: 193 Comm: kworker/u25:1 Not tainted 3.16.0-rc1 #1
[ 1631.849943] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[ 1631.849953] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[ 1631.849954] task: ffff880036a40960 ti: ffff88003695c000 task.ti: ffff88003695c000
[ 1631.849955] RIP: 0010:[<ffffffff810ba7c2>]  [<ffffffff810ba7c2>] queue_write_lock_slowpath+0x62/0x90
[ 1631.849957] RSP: 0018:ffff88003695fae0  EFLAGS: 00000206
[ 1631.849958] RAX: 0000000000000101 RBX: 00000000000000cf RCX: 0000000000000101
[ 1631.849959] RDX: 00000000000000ff RSI: 0000000000000283 RDI: ffff8801356755b0
[ 1631.849960] RBP: ffff88003695fae0 R08: ffff88003695fb18 R09: 0000000000000000
[ 1631.849961] R10: 0000000000000000 R11: 0000000000000001 R12: ffffffffa059cf56
[ 1631.849962] R13: ffff88003695fa78 R14: 0000000000000001 R15: 0000000000000012
[ 1631.849963] FS:  0000000000000000(0000) GS:ffff88007dc00000(0000) knlGS:0000000000000000
[ 1631.849964] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1631.849965] CR2: 000000000173e000 CR3: 0000000001c0e000 CR4: 00000000000007f0
[ 1631.849966] Stack:
[ 1631.849967]  ffff88003695faf0 ffffffff8166bc51 ffff88003695fb50 ffffffffa05da519
[ 1631.849968]  0000000000000000 ffff880036a40960 ffffffff810b4840 ffff88003695fb18
[ 1631.849970]  ffff88003695fb18 ffff880135675540 ffff8800b7117800 ffff880000000000
[ 1631.849971] Call Trace:
[ 1631.849974]  [<ffffffff8166bc51>] _raw_write_lock+0x21/0x30
[ 1631.849984]  [<ffffffffa05da519>] btrfs_tree_lock+0xc9/0x1d0 [btrfs]
[ 1631.849986]  [<ffffffff810b4840>] ? abort_exclusive_wait+0xb0/0xb0
[ 1631.849992]  [<ffffffffa057ae3b>] btrfs_lock_root_node+0x3b/0x50 [btrfs]
[ 1631.849998]  [<ffffffffa0580029>] btrfs_search_slot+0x8f9/0xa10 [btrfs]
[ 1631.850003]  [<ffffffffa057aba9>] ? btrfs_set_path_blocking+0x39/0x80 [btrfs]
[ 1631.850009]  [<ffffffffa0581970>] btrfs_insert_empty_items+0x70/0xc0 [btrfs]
[ 1631.850016]  [<ffffffffa05973b9>] btrfs_csum_file_blocks+0x2d9/0x680 [btrfs]
[ 1631.850022]  [<ffffffffa057ad46>] ? btrfs_free_path+0x26/0x30 [btrfs]
[ 1631.850030]  [<ffffffffa05a51e0>] add_pending_csums.isra.42+0x50/0x80 [btrfs]
[ 1631.850039]  [<ffffffffa05ab410>] btrfs_finish_ordered_io+0x470/0x570 [btrfs]
[ 1631.850048]  [<ffffffffa05ab785>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1631.850057]  [<ffffffffa05d0b3c>] normal_work_helper+0xbc/0x290 [btrfs]
[ 1631.850059]  [<ffffffff8108ab95>] process_one_work+0x175/0x430
[ 1631.850060]  [<ffffffff8108b23b>] worker_thread+0x11b/0x520
[ 1631.850062]  [<ffffffff8108b120>] ? rescuer_thread+0x2d0/0x2d0
[ 1631.850064]  [<ffffffff81091712>] kthread+0xd2/0xf0
[ 1631.850066]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1631.850067]  [<ffffffff8166c23c>] ret_from_fork+0x7c/0xb0
[ 1631.850069]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1631.850070] Code: 2e 0f 1f 84 00 00 00 00 00 f3 90 8b 17 84 d2 75 f8 89 d1 89 d0 83 c9 01 f0 0f b1 0f 39 d0 75 e9 ba ff 00 00 00 eb 04 66 90 f3 90 <8b> 07 83 f8 01 75 f7 f0 0f b1 17 83 f8 01 75 ee eb bc f3 90 0f
[ 1631.860046] BUG: soft lockup - CPU#3 stuck for 22s! [kworker/u25:4:3175]
[ 1631.868742] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables btrfs coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel nfsd xor raid6_pq igb microcode ptp pps_core dca iTCO_wdt auth_rpcgss shpchp iTCO_vendor_support nfs_acl i7core_edac pcspkr edac_core lpc_ich i2c_i801 mfd_core acpi_power_meter tpm_infineon tpm_tis tpm ipmi_si lockd ipmi_msghandler acpi_cpufreq sunrpc usb_storage mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm drm ata_generic pata_acpi megaraid_sas i2c_core ata_piix
[ 1631.868763] CPU: 3 PID: 3175 Comm: kworker/u25:4 Not tainted 3.16.0-rc1 #1
[ 1631.868764] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[ 1631.868774] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[ 1631.868775] task: ffff880073d60960 ti: ffff88007bde0000 task.ti: ffff88007bde0000
[ 1631.868776] RIP: 0010:[<ffffffff810ba858>]  [<ffffffff810ba858>] queue_read_lock_slowpath+0x68/0x90
[ 1631.868778] RSP: 0018:ffff88007bde3ac8  EFLAGS: 00000206
[ 1631.868779] RAX: 0000000000000033 RBX: 0000000000000000 RCX: 0000000000000007
[ 1631.868780] RDX: 0000000000000036 RSI: 0000000000000007 RDI: ffff8801356755b0
[ 1631.868781] RBP: ffff88007bde3ac8 R08: ffff880135675574 R09: 0000000000000000
[ 1631.868782] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000001000
[ 1631.868783] R13: 0000000000000000 R14: ffff88007385f000 R15: ffffffffa05800a1
[ 1631.868784] FS:  0000000000000000(0000) GS:ffff88007dcc0000(0000) knlGS:0000000000000000
[ 1631.868785] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1631.868786] CR2: 0000000000d6e000 CR3: 0000000001c0e000 CR4: 00000000000007e0
[ 1631.868787] Stack:
[ 1631.868788]  ffff88007bde3ad8 ffffffff8166bcbc ffff88007bde3b38 ffffffffa05da140
[ 1631.868789]  0000000000000068 0000000000000035 0000000000000000 ffff88007bde3b58
[ 1631.868791]  ffffffffa057881f ffff880135675540 ffff8800b7117800 ffff880000000000
[ 1631.868792] Call Trace:
[ 1631.868795]  [<ffffffff8166bcbc>] _raw_read_lock+0x1c/0x30
[ 1631.868804]  [<ffffffffa05da140>] btrfs_tree_read_lock+0x50/0x100 [btrfs]
[ 1631.868810]  [<ffffffffa057881f>] ? leaf_space_used+0xcf/0x110 [btrfs]
[ 1631.868815]  [<ffffffffa057adeb>] btrfs_read_lock_root_node+0x3b/0x50 [btrfs]
[ 1631.868821]  [<ffffffffa057fc3e>] btrfs_search_slot+0x50e/0xa10 [btrfs]
[ 1631.868830]  [<ffffffffa05eaee4>] ? btrfs_add_delayed_data_ref+0x114/0x180 [btrfs]
[ 1631.868837]  [<ffffffffa0595e2e>] btrfs_lookup_csum+0x5e/0x180 [btrfs]
[ 1631.868845]  [<ffffffffa059719c>] btrfs_csum_file_blocks+0xbc/0x680 [btrfs]
[ 1631.868850]  [<ffffffffa057ad46>] ? btrfs_free_path+0x26/0x30 [btrfs]
[ 1631.868859]  [<ffffffffa05a51e0>] add_pending_csums.isra.42+0x50/0x80 [btrfs]
[ 1631.868867]  [<ffffffffa05ab410>] btrfs_finish_ordered_io+0x470/0x570 [btrfs]
[ 1631.868869]  [<ffffffff810a702f>] ? set_next_entity+0x5f/0x80
[ 1631.868878]  [<ffffffffa05ab785>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1631.868887]  [<ffffffffa05d0b3c>] normal_work_helper+0xbc/0x290 [btrfs]
[ 1631.868889]  [<ffffffff8108ab95>] process_one_work+0x175/0x430
[ 1631.868891]  [<ffffffff8108b23b>] worker_thread+0x11b/0x520
[ 1631.868892]  [<ffffffff8108b120>] ? rescuer_thread+0x2d0/0x2d0
[ 1631.868894]  [<ffffffff81091712>] kthread+0xd2/0xf0
[ 1631.868896]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1631.868898]  [<ffffffff8166c23c>] ret_from_fork+0x7c/0xb0
[ 1631.868899]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1631.868900] Code: 00 00 00 f3 90 8b 07 84 c0 75 f8 b8 00 01 00 00 f0 0f c1 07 3c ff 75 0b 0f 1f 00 f3 90 8b 07 3c ff 74 f8 80 47 04 01 5d c3 f3 90 <0f> b6 47 04 38 c2 75 f6 eb bf 8b 07 3c ff 75 ec f3 90 8b 07 3c
[ 1631.872043] BUG: soft lockup - CPU#4 stuck for 22s! [kworker/u25:6:3177]
[ 1631.880892] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables btrfs coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel nfsd xor raid6_pq igb microcode ptp pps_core dca iTCO_wdt auth_rpcgss shpchp iTCO_vendor_support nfs_acl i7core_edac pcspkr edac_core lpc_ich i2c_i801 mfd_core acpi_power_meter tpm_infineon tpm_tis tpm ipmi_si lockd ipmi_msghandler acpi_cpufreq sunrpc usb_storage mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm drm ata_generic pata_acpi megaraid_sas i2c_core ata_piix
[ 1631.880913] CPU: 4 PID: 3177 Comm: kworker/u25:6 Not tainted 3.16.0-rc1 #1
[ 1631.880914] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[ 1631.880924] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[ 1631.880926] task: ffff880073d61c20 ti: ffff880073d70000 task.ti: ffff880073d70000
[ 1631.880927] RIP: 0010:[<ffffffff810ba85c>]  [<ffffffff810ba85c>] queue_read_lock_slowpath+0x6c/0x90
[ 1631.880929] RSP: 0018:ffff880073d73ac8  EFLAGS: 00000202
[ 1631.880930] RAX: 0000000000000033 RBX: 0000000000000000 RCX: 000000000000000c
[ 1631.880931] RDX: 000000000000003b RSI: 000000000000000c RDI: ffff8801356755b0
[ 1631.880932] RBP: ffff880073d73ac8 R08: ffff880135675574 R09: 0000000000000000
[ 1631.880933] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000001000
[ 1631.880934] R13: 0000000000000000 R14: ffff8800718af000 R15: ffffffffa05800a1
[ 1631.880935] FS:  0000000000000000(0000) GS:ffff88007dd00000(0000) knlGS:0000000000000000
[ 1631.880936] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1631.880937] CR2: 0000000000c98000 CR3: 0000000001c0e000 CR4: 00000000000007e0
[ 1631.880938] Stack:
[ 1631.880938]  ffff880073d73ad8 ffffffff8166bcbc ffff880073d73b38 ffffffffa05da140
[ 1631.880940]  0000000000000068 0000000000000035 0000000000000000 ffff880073d73b58
[ 1631.880941]  ffffffffa057881f ffff880135675540 ffff8800b7117800 ffff880000000000
[ 1631.880943] Call Trace:
[ 1631.880945]  [<ffffffff8166bcbc>] _raw_read_lock+0x1c/0x30
[ 1631.880955]  [<ffffffffa05da140>] btrfs_tree_read_lock+0x50/0x100 [btrfs]
[ 1631.880960]  [<ffffffffa057881f>] ? leaf_space_used+0xcf/0x110 [btrfs]
[ 1631.880966]  [<ffffffffa057adeb>] btrfs_read_lock_root_node+0x3b/0x50 [btrfs]
[ 1631.880972]  [<ffffffffa057fc3e>] btrfs_search_slot+0x50e/0xa10 [btrfs]
[ 1631.880981]  [<ffffffffa05eaee4>] ? btrfs_add_delayed_data_ref+0x114/0x180 [btrfs]
[ 1631.880988]  [<ffffffffa0595e2e>] btrfs_lookup_csum+0x5e/0x180 [btrfs]
[ 1631.880996]  [<ffffffffa059719c>] btrfs_csum_file_blocks+0xbc/0x680 [btrfs]
[ 1631.881001]  [<ffffffffa057ad46>] ? btrfs_free_path+0x26/0x30 [btrfs]
[ 1631.881010]  [<ffffffffa05a51e0>] add_pending_csums.isra.42+0x50/0x80 [btrfs]
[ 1631.881018]  [<ffffffffa05ab410>] btrfs_finish_ordered_io+0x470/0x570 [btrfs]
[ 1631.881021]  [<ffffffff8109ea79>] ? ttwu_do_wakeup+0x19/0xc0
[ 1631.881029]  [<ffffffffa05ab785>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1631.881039]  [<ffffffffa05d0b3c>] normal_work_helper+0xbc/0x290 [btrfs]
[ 1631.881040]  [<ffffffff8108ab95>] process_one_work+0x175/0x430
[ 1631.881042]  [<ffffffff8108b23b>] worker_thread+0x11b/0x520
[ 1631.881043]  [<ffffffff8108b120>] ? rescuer_thread+0x2d0/0x2d0
[ 1631.881045]  [<ffffffff81091712>] kthread+0xd2/0xf0
[ 1631.881047]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1631.881049]  [<ffffffff8166c23c>] ret_from_fork+0x7c/0xb0
[ 1631.881051]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1631.881051] Code: 90 8b 07 84 c0 75 f8 b8 00 01 00 00 f0 0f c1 07 3c ff 75 0b 0f 1f 00 f3 90 8b 07 3c ff 74 f8 80 47 04 01 5d c3 f3 90 0f b6 47 04 <38> c2 75 f6 eb bf 8b 07 3c ff 75 ec f3 90 8b 07 3c ff 74 f8 5d
[ 1631.884041] BUG: soft lockup - CPU#5 stuck for 22s! [kworker/u25:5:3176]
[ 1631.893041] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables btrfs coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel nfsd xor raid6_pq igb microcode ptp pps_core dca iTCO_wdt auth_rpcgss shpchp iTCO_vendor_support nfs_acl i7core_edac pcspkr edac_core lpc_ich i2c_i801 mfd_core acpi_power_meter tpm_infineon tpm_tis tpm ipmi_si lockd ipmi_msghandler acpi_cpufreq sunrpc usb_storage mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm drm ata_generic pata_acpi megaraid_sas i2c_core ata_piix
[ 1631.893063] CPU: 5 PID: 3176 Comm: kworker/u25:5 Not tainted 3.16.0-rc1 #1
[ 1631.893064] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[ 1631.893074] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[ 1631.893075] task: ffff880073d612c0 ti: ffff880073d5c000 task.ti: ffff880073d5c000
[ 1631.893076] RIP: 0010:[<ffffffff810ba858>]  [<ffffffff810ba858>] queue_read_lock_slowpath+0x68/0x90
[ 1631.893078] RSP: 0018:ffff880073d5fac8  EFLAGS: 00000206
[ 1631.893079] RAX: 0000000000000033 RBX: 0000000000000000 RCX: 0000000000000009
[ 1631.893080] RDX: 0000000000000038 RSI: 0000000000000009 RDI: ffff8801356755b0
[ 1631.893081] RBP: ffff880073d5fac8 R08: ffff880135675574 R09: 0000000000000000
[ 1631.893082] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000001000
[ 1631.893083] R13: 0000000000001000 R14: ffff88007c65a000 R15: ffffffffa05800a1
[ 1631.893084] FS:  0000000000000000(0000) GS:ffff88007dd40000(0000) knlGS:0000000000000000
[ 1631.893085] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1631.893086] CR2: 0000000001c95000 CR3: 0000000001c0e000 CR4: 00000000000007e0
[ 1631.893087] Stack:
[ 1631.893088]  ffff880073d5fad8 ffffffff8166bcbc ffff880073d5fb38 ffffffffa05da140
[ 1631.893089]  00000000000000cc 00000000000000a0 0000000000000000 ffff880073d5fb58
[ 1631.893091]  ffffffffa057881f ffff880135675540 ffff8800b7117800 ffff880000000000
[ 1631.893092] Call Trace:
[ 1631.893095]  [<ffffffff8166bcbc>] _raw_read_lock+0x1c/0x30
[ 1631.893104]  [<ffffffffa05da140>] btrfs_tree_read_lock+0x50/0x100 [btrfs]
[ 1631.893110]  [<ffffffffa057881f>] ? leaf_space_used+0xcf/0x110 [btrfs]
[ 1631.893115]  [<ffffffffa057adeb>] btrfs_read_lock_root_node+0x3b/0x50 [btrfs]
[ 1631.893121]  [<ffffffffa057fc3e>] btrfs_search_slot+0x50e/0xa10 [btrfs]
[ 1631.893130]  [<ffffffffa05eaee4>] ? btrfs_add_delayed_data_ref+0x114/0x180 [btrfs]
[ 1631.893138]  [<ffffffffa0595e2e>] btrfs_lookup_csum+0x5e/0x180 [btrfs]
[ 1631.893145]  [<ffffffffa059719c>] btrfs_csum_file_blocks+0xbc/0x680 [btrfs]
[ 1631.893151]  [<ffffffffa057ad46>] ? btrfs_free_path+0x26/0x30 [btrfs]
[ 1631.893159]  [<ffffffffa05a51e0>] add_pending_csums.isra.42+0x50/0x80 [btrfs]
[ 1631.893168]  [<ffffffffa05ab410>] btrfs_finish_ordered_io+0x470/0x570 [btrfs]
[ 1631.893169]  [<ffffffff8109ea79>] ? ttwu_do_wakeup+0x19/0xc0
[ 1631.893178]  [<ffffffffa05ab785>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1631.893188]  [<ffffffffa05d0b3c>] normal_work_helper+0xbc/0x290 [btrfs]
[ 1631.893189]  [<ffffffff8108ab95>] process_one_work+0x175/0x430
[ 1631.893191]  [<ffffffff8108b23b>] worker_thread+0x11b/0x520
[ 1631.893192]  [<ffffffff8108b120>] ? rescuer_thread+0x2d0/0x2d0
[ 1631.893194]  [<ffffffff81091712>] kthread+0xd2/0xf0
[ 1631.893196]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1631.893198]  [<ffffffff8166c23c>] ret_from_fork+0x7c/0xb0
[ 1631.893199]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1631.893200] Code: 00 00 00 f3 90 8b 07 84 c0 75 f8 b8 00 01 00 00 f0 0f c1 07 3c ff 75 0b 0f 1f 00 f3 90 8b 07 3c ff 74 f8 80 47 04 01 5d c3 f3 90 <0f> b6 47 04 38 c2 75 f6 eb bf 8b 07 3c ff 75 ec f3 90 8b 07 3c
[ 1631.969022] BUG: soft lockup - CPU#7 stuck for 22s! [kworker/u26:6:3182]
[ 1631.976495] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables btrfs coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel nfsd xor raid6_pq igb microcode ptp pps_core dca iTCO_wdt auth_rpcgss shpchp iTCO_vendor_support nfs_acl i7core_edac pcspkr edac_core lpc_ich i2c_i801 mfd_core acpi_power_meter tpm_infineon tpm_tis tpm ipmi_si lockd ipmi_msghandler acpi_cpufreq sunrpc usb_storage mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm drm ata_generic pata_acpi megaraid_sas i2c_core ata_piix
[ 1631.976516] CPU: 7 PID: 3182 Comm: kworker/u26:6 Not tainted 3.16.0-rc1 #1
[ 1631.976517] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[ 1631.976527] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[ 1631.976528] task: ffff8800ba65e720 ti: ffff880134714000 task.ti: ffff880134714000
[ 1631.976529] RIP: 0010:[<ffffffff810ba858>]  [<ffffffff810ba858>] queue_read_lock_slowpath+0x68/0x90
[ 1631.976531] RSP: 0018:ffff880134717ac8  EFLAGS: 00000202
[ 1631.976532] RAX: 0000000000000033 RBX: 0000000000000000 RCX: 0000000000000008
[ 1631.976533] RDX: 0000000000000037 RSI: 0000000000000008 RDI: ffff8801356755b0
[ 1631.976534] RBP: ffff880134717ac8 R08: ffff880135675574 R09: 0000000000000000
[ 1631.976535] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000001000
[ 1631.976536] R13: 0000000000001000 R14: ffff880075cd5000 R15: ffffffffa05800a1
[ 1631.976537] FS:  0000000000000000(0000) GS:ffff88013fc40000(0000) knlGS:0000000000000000
[ 1631.976538] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1631.976539] CR2: 0000000000715000 CR3: 0000000001c0e000 CR4: 00000000000007e0
[ 1631.976540] Stack:
[ 1631.976540]  ffff880134717ad8 ffffffff8166bcbc ffff880134717b38 ffffffffa05da140
[ 1631.976542]  00000000000000ce 00000000000000a0 0000000000000000 ffff880134717b58
[ 1631.976544]  ffffffffa057881f ffff880135675540 ffff8800b7117800 ffff880000000000
[ 1631.976545] Call Trace:
[ 1631.976547]  [<ffffffff8166bcbc>] _raw_read_lock+0x1c/0x30
[ 1631.976557]  [<ffffffffa05da140>] btrfs_tree_read_lock+0x50/0x100 [btrfs]
[ 1631.976562]  [<ffffffffa057881f>] ? leaf_space_used+0xcf/0x110 [btrfs]
[ 1631.976568]  [<ffffffffa057adeb>] btrfs_read_lock_root_node+0x3b/0x50 [btrfs]
[ 1631.976573]  [<ffffffffa057fc3e>] btrfs_search_slot+0x50e/0xa10 [btrfs]
[ 1631.976583]  [<ffffffffa05eaee4>] ? btrfs_add_delayed_data_ref+0x114/0x180 [btrfs]
[ 1631.976590]  [<ffffffffa0595e2e>] btrfs_lookup_csum+0x5e/0x180 [btrfs]
[ 1631.976598]  [<ffffffffa059719c>] btrfs_csum_file_blocks+0xbc/0x680 [btrfs]
[ 1631.976603]  [<ffffffffa057ad46>] ? btrfs_free_path+0x26/0x30 [btrfs]
[ 1631.976611]  [<ffffffffa05a51e0>] add_pending_csums.isra.42+0x50/0x80 [btrfs]
[ 1631.976620]  [<ffffffffa05ab410>] btrfs_finish_ordered_io+0x470/0x570 [btrfs]
[ 1631.976622]  [<ffffffff810a702f>] ? set_next_entity+0x5f/0x80
[ 1631.976630]  [<ffffffffa05ab785>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1631.976640]  [<ffffffffa05d0b3c>] normal_work_helper+0xbc/0x290 [btrfs]
[ 1631.976641]  [<ffffffff8108ab95>] process_one_work+0x175/0x430
[ 1631.976643]  [<ffffffff8108b23b>] worker_thread+0x11b/0x520
[ 1631.976644]  [<ffffffff8108b120>] ? rescuer_thread+0x2d0/0x2d0
[ 1631.976646]  [<ffffffff81091712>] kthread+0xd2/0xf0
[ 1631.976648]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1631.976650]  [<ffffffff8166c23c>] ret_from_fork+0x7c/0xb0
[ 1631.976651]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1631.976652] Code: 00 00 00 f3 90 8b 07 84 c0 75 f8 b8 00 01 00 00 f0 0f c1 07 3c ff 75 0b 0f 1f 00 f3 90 8b 07 3c ff 74 f8 80 47 04 01 5d c3 f3 90 <0f> b6 47 04 38 c2 75 f6 eb bf 8b 07 3c ff 75 ec f3 90 8b 07 3c
[ 1631.981019] BUG: soft lockup - CPU#8 stuck for 22s! [kworker/u26:3:3179]
[ 1631.989015] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables btrfs coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel nfsd xor raid6_pq igb microcode ptp pps_core dca iTCO_wdt auth_rpcgss shpchp iTCO_vendor_support nfs_acl i7core_edac pcspkr edac_core lpc_ich i2c_i801 mfd_core acpi_power_meter tpm_infineon tpm_tis tpm ipmi_si lockd ipmi_msghandler acpi_cpufreq sunrpc usb_storage mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm drm ata_generic pata_acpi megaraid_sas i2c_core ata_piix
[ 1631.989036] CPU: 8 PID: 3179 Comm: kworker/u26:3 Not tainted 3.16.0-rc1 #1
[ 1631.989037] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[ 1631.989047] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[ 1631.989048] task: ffff8800b7b13840 ti: ffff880137774000 task.ti: ffff880137774000
[ 1631.989049] RIP: 0010:[<ffffffff810ba858>]  [<ffffffff810ba858>] queue_read_lock_slowpath+0x68/0x90
[ 1631.989051] RSP: 0018:ffff880137777b08  EFLAGS: 00000202
[ 1631.989052] RAX: 0000000000000033 RBX: 0000000000000012 RCX: 0000000000000001
[ 1631.989053] RDX: 0000000000000035 RSI: 0000000000000004 RDI: ffff8801356755b0
[ 1631.989054] RBP: ffff880137777b08 R08: 0000000000000001 R09: ffff8801357a0490
[ 1631.989055] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880135675680
[ 1631.989056] R13: 0000000000000000 R14: 0000000000000003 R15: 0000000000000002
[ 1631.989057] FS:  0000000000000000(0000) GS:ffff88013fc80000(0000) knlGS:0000000000000000
[ 1631.989058] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1631.989059] CR2: 0000000001945000 CR3: 0000000001c0e000 CR4: 00000000000007e0
[ 1631.989060] Stack:
[ 1631.989060]  ffff880137777b18 ffffffff8166bcbc ffff880137777b38 ffffffffa05d9fe4
[ 1631.989062]  0000000000000001 ffffffffffffffe8 ffff880137777b58 ffffffffa057ac2a
[ 1631.989063]  ffff8801357bee10 0000000000000000 ffff880137777bf8 ffffffffa057fe32
[ 1631.989065] Call Trace:
[ 1631.989067]  [<ffffffff8166bcbc>] _raw_read_lock+0x1c/0x30
[ 1631.989077]  [<ffffffffa05d9fe4>] btrfs_clear_lock_blocking_rw+0x44/0x150 [btrfs]
[ 1631.989082]  [<ffffffffa057ac2a>] btrfs_clear_path_blocking+0x3a/0x80 [btrfs]
[ 1631.989088]  [<ffffffffa057fe32>] btrfs_search_slot+0x702/0xa10 [btrfs]
[ 1631.989095]  [<ffffffffa0595e2e>] btrfs_lookup_csum+0x5e/0x180 [btrfs]
[ 1631.989102]  [<ffffffffa059719c>] btrfs_csum_file_blocks+0xbc/0x680 [btrfs]
[ 1631.989108]  [<ffffffffa057ad46>] ? btrfs_free_path+0x26/0x30 [btrfs]
[ 1631.989116]  [<ffffffffa05a51e0>] add_pending_csums.isra.42+0x50/0x80 [btrfs]
[ 1631.989125]  [<ffffffffa05ab410>] btrfs_finish_ordered_io+0x470/0x570 [btrfs]
[ 1631.989127]  [<ffffffff8109ea79>] ? ttwu_do_wakeup+0x19/0xc0
[ 1631.989135]  [<ffffffffa05ab785>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1631.989145]  [<ffffffffa05d0b3c>] normal_work_helper+0xbc/0x290 [btrfs]
[ 1631.989147]  [<ffffffff8108ab95>] process_one_work+0x175/0x430
[ 1631.989148]  [<ffffffff8108b23b>] worker_thread+0x11b/0x520
[ 1631.989150]  [<ffffffff8108b120>] ? rescuer_thread+0x2d0/0x2d0
[ 1631.989151]  [<ffffffff81091712>] kthread+0xd2/0xf0
[ 1631.989153]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1631.989155]  [<ffffffff8166c23c>] ret_from_fork+0x7c/0xb0
[ 1631.989157]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1631.989158] Code: 00 00 00 f3 90 8b 07 84 c0 75 f8 b8 00 01 00 00 f0 0f c1 07 3c ff 75 0b 0f 1f 00 f3 90 8b 07 3c ff 74 f8 80 47 04 01 5d c3 f3 90 <0f> b6 47 04 38 c2 75 f6 eb bf 8b 07 3c ff 75 ec f3 90 8b 07 3c
[ 1631.994016] BUG: soft lockup - CPU#9 stuck for 22s! [kworker/u26:0:3178]
[ 1632.002726] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables btrfs coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel nfsd xor raid6_pq igb microcode ptp pps_core dca iTCO_wdt auth_rpcgss shpchp iTCO_vendor_support nfs_acl i7core_edac pcspkr edac_core lpc_ich i2c_i801 mfd_core acpi_power_meter tpm_infineon tpm_tis tpm ipmi_si lockd ipmi_msghandler acpi_cpufreq sunrpc usb_storage mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm drm ata_generic pata_acpi megaraid_sas i2c_core ata_piix
[ 1632.002747] CPU: 9 PID: 3178 Comm: kworker/u26:0 Not tainted 3.16.0-rc1 #1
[ 1632.002748] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[ 1632.002758] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[ 1632.002759] task: ffff8800b7b15dc0 ti: ffff88013397c000 task.ti: ffff88013397c000
[ 1632.002760] RIP: 0010:[<ffffffff810ba7a4>]  [<ffffffff810ba7a4>] queue_write_lock_slowpath+0x44/0x90
[ 1632.002762] RSP: 0018:ffff88013397fb30  EFLAGS: 00000286
[ 1632.002763] RAX: 00000000000000ff RBX: ffff880135675680 RCX: 0000000000000001
[ 1632.002764] RDX: 00000000000000ff RSI: 0000000137fb4000 RDI: ffff8801356756f0
[ 1632.002765] RBP: ffff88013397fb30 R08: 0000000000000001 R09: ffff8801357a0490
[ 1632.002766] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000086
[ 1632.002767] R13: ffffffffa059cf56 R14: ffff88013397fac0 R15: 0000000000000001
[ 1632.002768] FS:  0000000000000000(0000) GS:ffff88013fcc0000(0000) knlGS:0000000000000000
[ 1632.002769] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1632.002770] CR2: 00000036c97b9490 CR3: 0000000001c0e000 CR4: 00000000000007e0
[ 1632.002771] Stack:
[ 1632.002771]  ffff88013397fb40 ffffffff8166bc51 ffff88013397fb58 ffffffffa05da279
[ 1632.002773]  ffff880135765750 ffff88013397fbf8 ffffffffa057fb4c 0000000000000001
[ 1632.002774]  ffff88013a9df320 ffff88013a9df1e0 ffff88013397fbc0 ffff88013a9df1e0
[ 1632.002776] Call Trace:
[ 1632.002778]  [<ffffffff8166bc51>] _raw_write_lock+0x21/0x30
[ 1632.002788]  [<ffffffffa05da279>] btrfs_try_tree_write_lock+0x29/0x80 [btrfs]
[ 1632.002793]  [<ffffffffa057fb4c>] btrfs_search_slot+0x41c/0xa10 [btrfs]
[ 1632.002801]  [<ffffffffa0595e2e>] btrfs_lookup_csum+0x5e/0x180 [btrfs]
[ 1632.002808]  [<ffffffffa059719c>] btrfs_csum_file_blocks+0xbc/0x680 [btrfs]
[ 1632.002814]  [<ffffffffa057ad46>] ? btrfs_free_path+0x26/0x30 [btrfs]
[ 1632.002822]  [<ffffffffa05a51e0>] add_pending_csums.isra.42+0x50/0x80 [btrfs]
[ 1632.002831]  [<ffffffffa05ab410>] btrfs_finish_ordered_io+0x470/0x570 [btrfs]
[ 1632.002839]  [<ffffffffa05ab785>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1632.002849]  [<ffffffffa05d0b3c>] normal_work_helper+0xbc/0x290 [btrfs]
[ 1632.002851]  [<ffffffff8108ab95>] process_one_work+0x175/0x430
[ 1632.002852]  [<ffffffff8108b23b>] worker_thread+0x11b/0x520
[ 1632.002854]  [<ffffffff8108b120>] ? rescuer_thread+0x2d0/0x2d0
[ 1632.002855]  [<ffffffff81091712>] kthread+0xd2/0xf0
[ 1632.002857]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1632.002859]  [<ffffffff8166c23c>] ret_from_fork+0x7c/0xb0
[ 1632.002861]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1632.002862] Code: 75 5b 8b 07 85 c0 75 21 ba ff 00 00 00 f0 0f b1 17 85 c0 75 14 66 90 80 47 04 01 5d c3 66 2e 0f 1f 84 00 00 00 00 00 f3 90 8b 17 <84> d2 75 f8 89 d1 89 d0 83 c9 01 f0 0f b1 0f 39 d0 75 e9 ba ff
[ 1632.006013] BUG: soft lockup - CPU#10 stuck for 22s! [kworker/u26:1:88]
[ 1632.014778] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables btrfs coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel nfsd xor raid6_pq igb microcode ptp pps_core dca iTCO_wdt auth_rpcgss shpchp iTCO_vendor_support nfs_acl i7core_edac pcspkr edac_core lpc_ich i2c_i801 mfd_core acpi_power_meter tpm_infineon tpm_tis tpm ipmi_si lockd ipmi_msghandler acpi_cpufreq sunrpc usb_storage mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm drm ata_generic pata_acpi megaraid_sas i2c_core ata_piix
[ 1632.014799] CPU: 10 PID: 88 Comm: kworker/u26:1 Not tainted 3.16.0-rc1 #1
[ 1632.014800] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[ 1632.014810] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[ 1632.014811] task: ffff88013bb68000 ti: ffff88013bb5c000 task.ti: ffff88013bb5c000
[ 1632.014812] RIP: 0010:[<ffffffff810ba858>]  [<ffffffff810ba858>] queue_read_lock_slowpath+0x68/0x90
[ 1632.014814] RSP: 0018:ffff88013bb5fac8  EFLAGS: 00000202
[ 1632.014815] RAX: 0000000000000033 RBX: 0000000000000000 RCX: 000000000000000b
[ 1632.014816] RDX: 000000000000003a RSI: 000000000000000b RDI: ffff8801356755b0
[ 1632.014817] RBP: ffff88013bb5fac8 R08: ffff880135675574 R09: 0000000000000000
[ 1632.014818] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000001000
[ 1632.014819] R13: 0000000000000000 R14: ffff88013b9bd000 R15: ffffffffa05800a1
[ 1632.014820] FS:  0000000000000000(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
[ 1632.014821] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1632.014822] CR2: 0000000000715000 CR3: 0000000001c0e000 CR4: 00000000000007e0
[ 1632.014823] Stack:
[ 1632.014824]  ffff88013bb5fad8 ffffffff8166bcbc ffff88013bb5fb38 ffffffffa05da140
[ 1632.014825]  0000000000000069 0000000000000035 0000000000000000 ffff88013bb5fb58
[ 1632.014827]  ffffffffa057881f ffff880135675540 ffff8800b7117800 ffff880000000000
[ 1632.014828] Call Trace:
[ 1632.014830]  [<ffffffff8166bcbc>] _raw_read_lock+0x1c/0x30
[ 1632.014840]  [<ffffffffa05da140>] btrfs_tree_read_lock+0x50/0x100 [btrfs]
[ 1632.014845]  [<ffffffffa057881f>] ? leaf_space_used+0xcf/0x110 [btrfs]
[ 1632.014851]  [<ffffffffa057adeb>] btrfs_read_lock_root_node+0x3b/0x50 [btrfs]
[ 1632.014856]  [<ffffffffa057fc3e>] btrfs_search_slot+0x50e/0xa10 [btrfs]
[ 1632.014866]  [<ffffffffa05eaee4>] ? btrfs_add_delayed_data_ref+0x114/0x180 [btrfs]
[ 1632.014873]  [<ffffffffa0595e2e>] btrfs_lookup_csum+0x5e/0x180 [btrfs]
[ 1632.014880]  [<ffffffffa059719c>] btrfs_csum_file_blocks+0xbc/0x680 [btrfs]
[ 1632.014886]  [<ffffffffa057ad46>] ? btrfs_free_path+0x26/0x30 [btrfs]
[ 1632.014894]  [<ffffffffa05a51e0>] add_pending_csums.isra.42+0x50/0x80 [btrfs]
[ 1632.014903]  [<ffffffffa05ab410>] btrfs_finish_ordered_io+0x470/0x570 [btrfs]
[ 1632.014905]  [<ffffffff8109ea79>] ? ttwu_do_wakeup+0x19/0xc0
[ 1632.014913]  [<ffffffffa05ab785>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1632.014923]  [<ffffffffa05d0b3c>] normal_work_helper+0xbc/0x290 [btrfs]
[ 1632.014925]  [<ffffffff8108ab95>] process_one_work+0x175/0x430
[ 1632.014926]  [<ffffffff8108b23b>] worker_thread+0x11b/0x520
[ 1632.014928]  [<ffffffff8108b120>] ? rescuer_thread+0x2d0/0x2d0
[ 1632.014929]  [<ffffffff81091712>] kthread+0xd2/0xf0
[ 1632.014931]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1632.014933]  [<ffffffff8166c23c>] ret_from_fork+0x7c/0xb0
[ 1632.014935]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1632.014936] Code: 00 00 00 f3 90 8b 07 84 c0 75 f8 b8 00 01 00 00 f0 0f c1 07 3c ff 75 0b 0f 1f 00 f3 90 8b 07 3c ff 74 f8 80 47 04 01 5d c3 f3 90 <0f> b6 47 04 38 c2 75 f6 eb bf 8b 07 3c ff 75 ec f3 90 8b 07 3c
[ 1632.018011] BUG: soft lockup - CPU#11 stuck for 22s! [kworker/u26:7:3183]
[ 1632.027027] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables btrfs coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel nfsd xor raid6_pq igb microcode ptp pps_core dca iTCO_wdt auth_rpcgss shpchp iTCO_vendor_support nfs_acl i7core_edac pcspkr edac_core lpc_ich i2c_i801 mfd_core acpi_power_meter tpm_infineon tpm_tis tpm ipmi_si lockd ipmi_msghandler acpi_cpufreq sunrpc usb_storage mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm drm ata_generic pata_acpi megaraid_sas i2c_core ata_piix
[ 1632.027048] CPU: 11 PID: 3183 Comm: kworker/u26:7 Not tainted 3.16.0-rc1 #1
[ 1632.027049] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[ 1632.027059] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[ 1632.027061] task: ffff8800ba65b840 ti: ffff88013a714000 task.ti: ffff88013a714000
[ 1632.027061] RIP: 0010:[<ffffffff810ba858>]  [<ffffffff810ba858>] queue_read_lock_slowpath+0x68/0x90
[ 1632.027064] RSP: 0018:ffff88013a717a80  EFLAGS: 00000202
[ 1632.027065] RAX: 0000000000000033 RBX: 0000000000000000 RCX: 0000000000000006
[ 1632.027066] RDX: 0000000000000034 RSI: 0000000000000006 RDI: ffff8801356755b0
[ 1632.027066] RBP: ffff88013a717a80 R08: ffff880135675574 R09: 0000000000000000
[ 1632.027067] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[ 1632.027068] R13: ffff8801355f0870 R14: ffffffff00000000 R15: ffff8801355f0870
[ 1632.027069] FS:  0000000000000000(0000) GS:ffff88013fd40000(0000) knlGS:0000000000000000
[ 1632.027070] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1632.027071] CR2: 0000000000b55000 CR3: 0000000001c0e000 CR4: 00000000000007e0
[ 1632.027072] Stack:
[ 1632.027073]  ffff88013a717a90 ffffffff8166bcbc ffff88013a717af0 ffffffffa05da140
[ 1632.027074]  ffffffff810b4178 00000000000000cf ffff88013a717b48 ffffffffa057d07d
[ 1632.027076]  ffff88013a717bc0 ffff880135675540 ffff8800b7117800 ffff880000000000
[ 1632.027077] Call Trace:
[ 1632.027080]  [<ffffffff8166bcbc>] _raw_read_lock+0x1c/0x30
[ 1632.027090]  [<ffffffffa05da140>] btrfs_tree_read_lock+0x50/0x100 [btrfs]
[ 1632.027091]  [<ffffffff810b4178>] ? __wake_up_common+0x58/0x90
[ 1632.027097]  [<ffffffffa057d07d>] ? generic_bin_search.constprop.35+0x8d/0x1a0 [btrfs]
[ 1632.027103]  [<ffffffffa057adeb>] btrfs_read_lock_root_node+0x3b/0x50 [btrfs]
[ 1632.027108]  [<ffffffffa057fc3e>] btrfs_search_slot+0x50e/0xa10 [btrfs]
[ 1632.027118]  [<ffffffffa05c38ef>] ? free_extent_buffer+0x4f/0xb0 [btrfs]
[ 1632.027124]  [<ffffffffa0582eb8>] btrfs_next_old_leaf+0x218/0x4b0 [btrfs]
[ 1632.027130]  [<ffffffffa0583160>] btrfs_next_leaf+0x10/0x20 [btrfs]
[ 1632.027137]  [<ffffffffa059744b>] btrfs_csum_file_blocks+0x36b/0x680 [btrfs]
[ 1632.027143]  [<ffffffffa057ad46>] ? btrfs_free_path+0x26/0x30 [btrfs]
[ 1632.027151]  [<ffffffffa05a51e0>] add_pending_csums.isra.42+0x50/0x80 [btrfs]
[ 1632.027160]  [<ffffffffa05ab410>] btrfs_finish_ordered_io+0x470/0x570 [btrfs]
[ 1632.027168]  [<ffffffffa05ab785>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1632.027178]  [<ffffffffa05d0b3c>] normal_work_helper+0xbc/0x290 [btrfs]
[ 1632.027180]  [<ffffffff8108ab95>] process_one_work+0x175/0x430
[ 1632.027181]  [<ffffffff8108b23b>] worker_thread+0x11b/0x520
[ 1632.027183]  [<ffffffff8108b120>] ? rescuer_thread+0x2d0/0x2d0
[ 1632.027184]  [<ffffffff81091712>] kthread+0xd2/0xf0
[ 1632.027186]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1632.027188]  [<ffffffff8166c23c>] ret_from_fork+0x7c/0xb0
[ 1632.027190]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1632.027191] Code: 00 00 00 f3 90 8b 07 84 c0 75 f8 b8 00 01 00 00 f0 0f c1 07 3c ff 75 0b 0f 1f 00 f3 90 8b 07 3c ff 74 f8 80 47 04 01 5d c3 f3 90 <0f> b6 47 04 38 c2 75 f6 eb bf 8b 07 3c ff 75 ec f3 90 8b 07 3c

> 
> Thanks,
> Tsutomu
> 
> ==========
> Message from syslogd@luna at Jun 17 11:06:33 ...
>   kernel:[  560.076282] BUG: soft lockup - CPU#0 stuck for 22s! [kworker/u25:1:193]
> 
> Message from syslogd@luna at Jun 17 11:06:33 ...
>   kernel:[  560.076283] BUG: soft lockup - CPU#1 stuck for 22s! [kworker/u25:3:3174]
> 
> Message from syslogd@luna at Jun 17 11:06:33 ...
>   kernel:[  560.101276] BUG: soft lockup - CPU#3 stuck for 22s! [kworker/u25:4:3175]
> 
> Message from syslogd@luna at Jun 17 11:06:33 ...
>   kernel:[  560.113274] BUG: soft lockup - CPU#4 stuck for 22s! [kworker/u25:6:3177]
> 
> Message from syslogd@luna at Jun 17 11:06:33 ...
>   kernel:[  560.125271] BUG: soft lockup - CPU#5 stuck for 22s! [kworker/u25:5:3176]
> 


