Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:57933 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaFPX6H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 19:58:07 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail.fujitsu.co.jp (Postfix) with ESMTP id BE1993EE0C5
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 08:58:04 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.nic.fujitsu.com [10.0.50.92])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id E9C84AC05A0
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 08:58:03 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 9569F1DB803E
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 08:58:03 +0900 (JST)
Message-ID: <539F846A.4080608@jp.fujitsu.com>
Date: Tue, 17 Jun 2014 08:57:30 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [3.16-rc1] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u25:4:5189]
References: <539E9026.1020406@jp.fujitsu.com> <539F2FEA.1060809@fb.com> <539F7D8E.9010608@jp.fujitsu.com> <539F8351.3010700@fb.com>
In-Reply-To: <539F8351.3010700@fb.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/06/17 8:52, Chris Mason wrote:
> On 06/16/2014 07:28 PM, Tsutomu Itoh wrote:
>> Hi Chris,
>>
>> On 2014/06/17 2:56, Chris Mason wrote:
>>> On 06/16/2014 02:35 AM, Tsutomu Itoh wrote:
>>>> I encountered soft lockup when executing 'xfstests btrfs/042' on 3.16-rc1.
>>>>
>>>
>>> Did we recover, or was it stuck forever?
>>
>> The following messages are repeatedly output.
>> And stuck forever.
>>
>> [ 1147.942181] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u25:4:5189]
>> [ 1147.967175] BUG: soft lockup - CPU#3 stuck for 23s! [kworker/u25:9:5194]
>> [ 1147.979172] BUG: soft lockup - CPU#4 stuck for 23s! [kworker/u25:15:5200]
>> [ 1147.991169] BUG: soft lockup - CPU#5 stuck for 23s! [kworker/u25:7:5192]
>> [ 1148.064153] BUG: soft lockup - CPU#6 stuck for 23s! [kworker/u26:3:3182]
> 
> Can you please capture a stack trace from all the cpus?
> 

crash> log
...
[ 1121.996312] BTRFS: creating UUID tree
[ 1122.050762] BTRFS info (device sdc5): qgroup scan completed
[ 1147.942181] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u25:4:5189]
[ 1147.949658] Modules linked in: loop ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables btrfs coretemp kvm_intel kvm xor raid6_pq crc32_pclmul crc32c_intel ghash_clmulni_intel nfsd igb microcode ptp pps_core dca iTCO_wdt shpchp auth_rpcgss iTCO_vendor_support i7core_edac pcspkr edac_core i2c_i801 lpc_ich mfd_core ipmi_si tpm_infineon ipmi_msghandler tpm_tis nfs_acl tpm acpi_power_meter lockd acpi_cpufreq sunrpc usb_storage mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm ata_generic pata_acpi drm megaraid_sas i2c_core ata_piix
[ 1147.949695] CPU: 0 PID: 5189 Comm: kworker/u25:4 Not tainted 3.16.0-rc1 #1
[ 1147.949696] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[ 1147.949717] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[ 1147.949718] task: ffff88007408b840 ti: ffff8800740e4000 task.ti: ffff8800740e4000
[ 1147.949720] RIP: 0010:[<ffffffff810ba858>]  [<ffffffff810ba858>] queue_read_lock_slowpath+0x68/0x90
[ 1147.949725] RSP: 0018:ffff8800740e7b08  EFLAGS: 00000202
[ 1147.949726] RAX: 00000000000000ee RBX: 0000000000000012 RCX: 0000000000000001
[ 1147.949727] RDX: 00000000000000ef RSI: 0000000000000004 RDI: ffff88003db221b0
[ 1147.949728] RBP: ffff8800740e7b08 R08: 0000000000000001 R09: ffff880071486b58
[ 1147.949729] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800715d1900
[ 1147.949730] R13: 0000000000000000 R14: 0000000000000003 R15: 0000000000000002
[ 1147.949732] FS:  0000000000000000(0000) GS:ffff88007dc00000(0000) knlGS:0000000000000000
[ 1147.949733] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1147.949734] CR2: 00000036c97b9490 CR3: 0000000001c0e000 CR4: 00000000000007f0
[ 1147.949735] Stack:
[ 1147.949736]  ffff8800740e7b18 ffffffff8166bcbc ffff8800740e7b38 ffffffffa070ffe4
[ 1147.949738]  0000000000000001 ffffffffffffffe8 ffff8800740e7b58 ffffffffa06b0c2a
[ 1147.949740]  ffff8800719de360 0000000000000000 ffff8800740e7bf8 ffffffffa06b5e32
[ 1147.949742] Call Trace:
[ 1147.949748]  [<ffffffff8166bcbc>] _raw_read_lock+0x1c/0x30
[ 1147.949760]  [<ffffffffa070ffe4>] btrfs_clear_lock_blocking_rw+0x44/0x150 [btrfs]
[ 1147.949767]  [<ffffffffa06b0c2a>] btrfs_clear_path_blocking+0x3a/0x80 [btrfs]
[ 1147.949774]  [<ffffffffa06b5e32>] btrfs_search_slot+0x702/0xa10 [btrfs]
[ 1147.949783]  [<ffffffffa06cbe2e>] btrfs_lookup_csum+0x5e/0x180 [btrfs]
[ 1147.949792]  [<ffffffffa06cd19c>] btrfs_csum_file_blocks+0xbc/0x680 [btrfs]
[ 1147.949798]  [<ffffffffa06b0d46>] ? btrfs_free_path+0x26/0x30 [btrfs]
[ 1147.949809]  [<ffffffffa06db1e0>] add_pending_csums.isra.42+0x50/0x80 [btrfs]
[ 1147.949819]  [<ffffffffa06e1410>] btrfs_finish_ordered_io+0x470/0x570 [btrfs]
[ 1147.949830]  [<ffffffffa06e1785>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1147.949841]  [<ffffffffa0706b3c>] normal_work_helper+0xbc/0x290 [btrfs]
[ 1147.949844]  [<ffffffff8108ab95>] process_one_work+0x175/0x430
[ 1147.949846]  [<ffffffff8108b23b>] worker_thread+0x11b/0x520
[ 1147.949848]  [<ffffffff8108b120>] ? rescuer_thread+0x2d0/0x2d0
[ 1147.949851]  [<ffffffff81091712>] kthread+0xd2/0xf0
[ 1147.949853]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1147.949855]  [<ffffffff8166c23c>] ret_from_fork+0x7c/0xb0
[ 1147.949857]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1147.949858] Code: 00 00 00 f3 90 8b 07 84 c0 75 f8 b8 00 01 00 00 f0 0f c1 07 3c ff 75 0b 0f 1f 00 f3 90 8b 07 3c ff 74 f8 80 47 04 01 5d c3 f3 90 <0f> b6 47 04 38 c2 75 f6 eb bf 8b 07 3c ff 75 ec f3 90 8b 07 3c
[ 1147.949877] Kernel panic - not syncing: softlockup: hung tasks
[ 1147.956981] CPU: 0 PID: 5189 Comm: kworker/u25:4 Not tainted 3.16.0-rc1 #1
[ 1147.965228] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[ 1147.967175] BUG: soft lockup - CPU#3 stuck for 23s! [kworker/u25:9:5194]
[ 1147.967194] Modules linked in: loop ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables btrfs coretemp kvm_intel kvm xor raid6_pq crc32_pclmul crc32c_intel ghash_clmulni_intel nfsd igb microcode ptp pps_core dca iTCO_wdt shpchp auth_rpcgss iTCO_vendor_support i7core_edac pcspkr edac_core i2c_i801 lpc_ich mfd_core ipmi_si tpm_infineon ipmi_msghandler tpm_tis nfs_acl tpm acpi_power_meter lockd acpi_cpufreq sunrpc usb_storage mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm ata_generic pata_acpi drm megaraid_sas i2c_core ata_piix
[ 1147.967195] CPU: 3 PID: 5194 Comm: kworker/u25:9 Not tainted 3.16.0-rc1 #1
[ 1147.967196] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[ 1147.967209] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[ 1147.967210] task: ffff88007408aee0 ti: ffff88007ba88000 task.ti: ffff88007ba88000
[ 1147.967212] RIP: 0010:[<ffffffff810ba7c2>]  [<ffffffff810ba7c2>] queue_write_lock_slowpath+0x62/0x90
[ 1147.967213] RSP: 0018:ffff88007ba8bae0  EFLAGS: 00000206
[ 1147.967214] RAX: 0000000000000101 RBX: 0000000000000000 RCX: 0000000000000101
[ 1147.967214] RDX: 00000000000000ff RSI: 0000000000000202 RDI: ffff88003db221b0
[ 1147.967215] RBP: ffff88007ba8bae0 R08: ffff88007ba8bb18 R09: 0000000000000001
[ 1147.967216] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88007dcd2e80
[ 1147.967216] R13: 0000000000000000 R14: ffff88007408b3d0 R15: 0000000300000000
[ 1147.967217] FS:  0000000000000000(0000) GS:ffff88007dcc0000(0000) knlGS:0000000000000000
[ 1147.967218] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1147.967218] CR2: 000000000136e000 CR3: 0000000001c0e000 CR4: 00000000000007e0
[ 1147.967219] Stack:
[ 1147.967220]  ffff88007ba8baf0 ffffffff8166bc51 ffff88007ba8bb50 ffffffffa0710519
[ 1147.967221]  0000000000000000 ffff88007408aee0 ffffffff810b4840 ffff88007ba8bb18
[ 1147.967222]  ffff88007ba8bb18 ffff88003db22140 ffff880072435000 ffff880000000000
[ 1147.967223] Call Trace:
[ 1147.967226]  [<ffffffff8166bc51>] _raw_write_lock+0x21/0x30
[ 1147.967237]  [<ffffffffa0710519>] btrfs_tree_lock+0xc9/0x1d0 [btrfs]
[ 1147.967240]  [<ffffffff810b4840>] ? abort_exclusive_wait+0xb0/0xb0
[ 1147.967246]  [<ffffffffa06b0e3b>] btrfs_lock_root_node+0x3b/0x50 [btrfs]
[ 1147.967252]  [<ffffffffa06b6029>] btrfs_search_slot+0x8f9/0xa10 [btrfs]
[ 1147.967258]  [<ffffffffa06b0ba9>] ? btrfs_set_path_blocking+0x39/0x80 [btrfs]
[ 1147.967265]  [<ffffffffa06b7970>] btrfs_insert_empty_items+0x70/0xc0 [btrfs]
[ 1147.967273]  [<ffffffffa06cd3b9>] btrfs_csum_file_blocks+0x2d9/0x680 [btrfs]
[ 1147.967279]  [<ffffffffa06b0d46>] ? btrfs_free_path+0x26/0x30 [btrfs]
[ 1147.967289]  [<ffffffffa06db1e0>] add_pending_csums.isra.42+0x50/0x80 [btrfs]
[ 1147.967298]  [<ffffffffa06e1410>] btrfs_finish_ordered_io+0x470/0x570 [btrfs]
[ 1147.967300]  [<ffffffff810a702f>] ? set_next_entity+0x5f/0x80
[ 1147.967310]  [<ffffffffa06e1785>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1147.967321]  [<ffffffffa0706b3c>] normal_work_helper+0xbc/0x290 [btrfs]
[ 1147.967322]  [<ffffffff8108ab95>] process_one_work+0x175/0x430
[ 1147.967323]  [<ffffffff8108b23b>] worker_thread+0x11b/0x520
[ 1147.967325]  [<ffffffff8108b120>] ? rescuer_thread+0x2d0/0x2d0
[ 1147.967326]  [<ffffffff81091712>] kthread+0xd2/0xf0
[ 1147.967328]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1147.967329]  [<ffffffff8166c23c>] ret_from_fork+0x7c/0xb0
[ 1147.967331]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1147.967342] Code: 2e 0f 1f 84 00 00 00 00 00 f3 90 8b 17 84 d2 75 f8 89 d1 89 d0 83 c9 01 f0 0f b1 0f 39 d0 75 e9 ba ff 00 00 00 eb 04 66 90 f3 90 <8b> 07 83 f8 01 75 f7 f0 0f b1 17 83 f8 01 75 ee eb bc f3 90 0f
[ 1147.979172] BUG: soft lockup - CPU#4 stuck for 23s! [kworker/u25:15:5200]
[ 1147.979190] Modules linked in: loop ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables btrfs coretemp kvm_intel kvm xor raid6_pq crc32_pclmul crc32c_intel ghash_clmulni_intel nfsd igb microcode ptp pps_core dca iTCO_wdt shpchp auth_rpcgss iTCO_vendor_support i7core_edac pcspkr edac_core i2c_i801 lpc_ich mfd_core ipmi_si tpm_infineon ipmi_msghandler tpm_tis nfs_acl tpm acpi_power_meter lockd acpi_cpufreq sunrpc usb_storage mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm ata_generic pata_acpi drm megaraid_sas i2c_core ata_piix
[ 1147.979191] CPU: 4 PID: 5200 Comm: kworker/u25:15 Not tainted 3.16.0-rc1 #1
[ 1147.979192] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[ 1147.979204] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[ 1147.979205] task: ffff88007bc4b840 ti: ffff8800755a0000 task.ti: ffff8800755a0000
[ 1147.979207] RIP: 0010:[<ffffffff810ba858>]  [<ffffffff810ba858>] queue_read_lock_slowpath+0x68/0x90
[ 1147.979208] RSP: 0018:ffff8800755a3ac8  EFLAGS: 00000212
[ 1147.979209] RAX: 00000000000000ee RBX: 0000000000000000 RCX: 000000000000000d
[ 1147.979209] RDX: 00000000000000f6 RSI: 000000000000000d RDI: ffff88003db221b0
[ 1147.979210] RBP: ffff8800755a3ac8 R08: ffff88003db22174 R09: 0000000000000000
[ 1147.979210] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000001000
[ 1147.979211] R13: 0000000000000000 R14: ffff88007b68f000 R15: ffffffffa06b60a1
[ 1147.979212] FS:  0000000000000000(0000) GS:ffff88007dd00000(0000) knlGS:0000000000000000
[ 1147.979213] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1147.979213] CR2: 00000000014b6000 CR3: 0000000001c0e000 CR4: 00000000000007e0
[ 1147.979214] Stack:
[ 1147.979215]  ffff8800755a3ad8 ffffffff8166bcbc ffff8800755a3b38 ffffffffa0710140
[ 1147.979216]  0000000000000084 0000000000000035 0000000000000000 ffff8800755a3b58
[ 1147.979217]  ffffffffa06ae81f ffff88003db22140 ffff880072435000 ffff880000000000
[ 1147.979218] Call Trace:
[ 1147.979220]  [<ffffffff8166bcbc>] _raw_read_lock+0x1c/0x30
[ 1147.979231]  [<ffffffffa0710140>] btrfs_tree_read_lock+0x50/0x100 [btrfs]
[ 1147.979237]  [<ffffffffa06ae81f>] ? leaf_space_used+0xcf/0x110 [btrfs]
[ 1147.979243]  [<ffffffffa06b0deb>] btrfs_read_lock_root_node+0x3b/0x50 [btrfs]
[ 1147.979249]  [<ffffffffa06b5c3e>] btrfs_search_slot+0x50e/0xa10 [btrfs]
[ 1147.979260]  [<ffffffffa0720ee4>] ? btrfs_add_delayed_data_ref+0x114/0x180 [btrfs]
[ 1147.979268]  [<ffffffffa06cbe2e>] btrfs_lookup_csum+0x5e/0x180 [btrfs]
[ 1147.979277]  [<ffffffffa06cd19c>] btrfs_csum_file_blocks+0xbc/0x680 [btrfs]
[ 1147.979283]  [<ffffffffa06b0d46>] ? btrfs_free_path+0x26/0x30 [btrfs]
[ 1147.979292]  [<ffffffffa06db1e0>] add_pending_csums.isra.42+0x50/0x80 [btrfs]
[ 1147.979302]  [<ffffffffa06e1410>] btrfs_finish_ordered_io+0x470/0x570 [btrfs]
[ 1147.979304]  [<ffffffff8109ea79>] ? ttwu_do_wakeup+0x19/0xc0
[ 1147.979314]  [<ffffffffa06e1785>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1147.979325]  [<ffffffffa0706b3c>] normal_work_helper+0xbc/0x290 [btrfs]
[ 1147.979327]  [<ffffffff8108ab95>] process_one_work+0x175/0x430
[ 1147.979328]  [<ffffffff8108b23b>] worker_thread+0x11b/0x520
[ 1147.979329]  [<ffffffff8108b120>] ? rescuer_thread+0x2d0/0x2d0
[ 1147.979331]  [<ffffffff81091712>] kthread+0xd2/0xf0
[ 1147.979332]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1147.979334]  [<ffffffff8166c23c>] ret_from_fork+0x7c/0xb0
[ 1147.979335]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1147.979346] Code: 00 00 00 f3 90 8b 07 84 c0 75 f8 b8 00 01 00 00 f0 0f c1 07 3c ff 75 0b 0f 1f 00 f3 90 8b 07 3c ff 74 f8 80 47 04 01 5d c3 f3 90 <0f> b6 47 04 38 c2 75 f6 eb bf 8b 07 3c ff 75 ec f3 90 8b 07 3c
[ 1147.991169] BUG: soft lockup - CPU#5 stuck for 23s! [kworker/u25:7:5192]
[ 1147.991187] Modules linked in: loop ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables btrfs coretemp kvm_intel kvm xor raid6_pq crc32_pclmul crc32c_intel ghash_clmulni_intel nfsd igb microcode ptp pps_core dca iTCO_wdt shpchp auth_rpcgss iTCO_vendor_support i7core_edac pcspkr edac_core i2c_i801 lpc_ich mfd_core ipmi_si tpm_infineon ipmi_msghandler tpm_tis nfs_acl tpm acpi_power_meter lockd acpi_cpufreq sunrpc usb_storage mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm ata_generic pata_acpi drm megaraid_sas i2c_core ata_piix
[ 1147.991188] CPU: 5 PID: 5192 Comm: kworker/u25:7 Not tainted 3.16.0-rc1 #1
[ 1147.991189] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[ 1147.991201] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[ 1147.991202] task: ffff8800740892c0 ti: ffff880036238000 task.ti: ffff880036238000
[ 1147.991204] RIP: 0010:[<ffffffff810ba858>]  [<ffffffff810ba858>] queue_read_lock_slowpath+0x68/0x90
[ 1147.991205] RSP: 0018:ffff88003623bac8  EFLAGS: 00000216
[ 1147.991206] RAX: 00000000000000ee RBX: 0000000000000000 RCX: 0000000000000008
[ 1147.991206] RDX: 00000000000000f1 RSI: 0000000000000008 RDI: ffff88003db221b0
[ 1147.991207] RBP: ffff88003623bac8 R08: ffff88003db22174 R09: 0000000000000000
[ 1147.991208] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000001000
[ 1147.991208] R13: 0000000000000000 R14: ffff880037e1f000 R15: ffffffffa06b60a1
[ 1147.991209] FS:  0000000000000000(0000) GS:ffff88007dd40000(0000) knlGS:0000000000000000
[ 1147.991210] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1147.991210] CR2: 00000036c97b9490 CR3: 0000000001c0e000 CR4: 00000000000007e0
[ 1147.991211] Stack:
[ 1147.991212]  ffff88003623bad8 ffffffff8166bcbc ffff88003623bb38 ffffffffa0710140
[ 1147.991213]  0000000000000084 0000000000000035 0000000000000000 ffff88003623bb58
[ 1147.991214]  ffffffffa06ae81f ffff88003db22140 ffff880072435000 ffff880000000000
[ 1147.991215] Call Trace:
[ 1147.991217]  [<ffffffff8166bcbc>] _raw_read_lock+0x1c/0x30
[ 1147.991228]  [<ffffffffa0710140>] btrfs_tree_read_lock+0x50/0x100 [btrfs]
[ 1147.991234]  [<ffffffffa06ae81f>] ? leaf_space_used+0xcf/0x110 [btrfs]
[ 1147.991240]  [<ffffffffa06b0deb>] btrfs_read_lock_root_node+0x3b/0x50 [btrfs]
[ 1147.991246]  [<ffffffffa06b5c3e>] btrfs_search_slot+0x50e/0xa10 [btrfs]
[ 1147.991257]  [<ffffffffa0720ee4>] ? btrfs_add_delayed_data_ref+0x114/0x180 [btrfs]
[ 1147.991265]  [<ffffffffa06cbe2e>] btrfs_lookup_csum+0x5e/0x180 [btrfs]
[ 1147.991274]  [<ffffffffa06cd19c>] btrfs_csum_file_blocks+0xbc/0x680 [btrfs]
[ 1147.991280]  [<ffffffffa06b0d46>] ? btrfs_free_path+0x26/0x30 [btrfs]
[ 1147.991289]  [<ffffffffa06db1e0>] add_pending_csums.isra.42+0x50/0x80 [btrfs]
[ 1147.991299]  [<ffffffffa06e1410>] btrfs_finish_ordered_io+0x470/0x570 [btrfs]
[ 1147.991301]  [<ffffffff8109ea79>] ? ttwu_do_wakeup+0x19/0xc0
[ 1147.991310]  [<ffffffffa06e1785>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1147.991321]  [<ffffffffa0706b3c>] normal_work_helper+0xbc/0x290 [btrfs]
[ 1147.991323]  [<ffffffff8108ab95>] process_one_work+0x175/0x430
[ 1147.991324]  [<ffffffff8108b23b>] worker_thread+0x11b/0x520
[ 1147.991325]  [<ffffffff8108b120>] ? rescuer_thread+0x2d0/0x2d0
[ 1147.991327]  [<ffffffff81091712>] kthread+0xd2/0xf0
[ 1147.991328]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1147.991330]  [<ffffffff8166c23c>] ret_from_fork+0x7c/0xb0
[ 1147.991331]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1147.991342] Code: 00 00 00 f3 90 8b 07 84 c0 75 f8 b8 00 01 00 00 f0 0f c1 07 3c ff 75 0b 0f 1f 00 f3 90 8b 07 3c ff 74 f8 80 47 04 01 5d c3 f3 90 <0f> b6 47 04 38 c2 75 f6 eb bf 8b 07 3c ff 75 ec f3 90 8b 07 3c
[ 1148.064153] BUG: soft lockup - CPU#6 stuck for 23s! [kworker/u26:3:3182]
[ 1148.064174] Modules linked in: loop ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables btrfs coretemp kvm_intel kvm xor raid6_pq crc32_pclmul crc32c_intel ghash_clmulni_intel nfsd igb microcode ptp pps_core dca iTCO_wdt shpchp auth_rpcgss iTCO_vendor_support i7core_edac pcspkr edac_core i2c_i801 lpc_ich mfd_core ipmi_si tpm_infineon ipmi_msghandler tpm_tis nfs_acl tpm acpi_power_meter lockd acpi_cpufreq sunrpc usb_storage mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm ata_generic pata_acpi drm megaraid_sas i2c_core ata_piix
[ 1148.064176] CPU: 6 PID: 3182 Comm: kworker/u26:3 Not tainted 3.16.0-rc1 #1
[ 1148.064176] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[ 1148.064192] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[ 1148.064193] task: ffff880132520960 ti: ffff8801385b0000 task.ti: ffff8801385b0000
[ 1148.064197] RIP: 0010:[<ffffffff810ba85c>]  [<ffffffff810ba85c>] queue_read_lock_slowpath+0x6c/0x90
[ 1148.064198] RSP: 0018:ffff8801385b3ac8  EFLAGS: 00000212
[ 1148.064198] RAX: 00000000000000ee RBX: 0000000000000000 RCX: 000000000000000c
[ 1148.064199] RDX: 00000000000000f5 RSI: 000000000000000c RDI: ffff88003db221b0
[ 1148.064199] RBP: ffff8801385b3ac8 R08: ffff88003db22174 R09: 0000000000000000
[ 1148.064200] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000001000
[ 1148.064200] R13: 0000000000000000 R14: ffff8800b7e1e000 R15: ffffffffa06b60a1
[ 1148.064201] FS:  0000000000000000(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
[ 1148.064202] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1148.064203] CR2: 00000036cac4b8d8 CR3: 0000000001c0e000 CR4: 00000000000007e0
[ 1148.064203] Stack:
[ 1148.064204]  ffff8801385b3ad8 ffffffff8166bcbc ffff8801385b3b38 ffffffffa0710140
[ 1148.064205]  0000000000000085 0000000000000035 0000000000000000 ffff8801385b3b58
[ 1148.064206]  ffffffffa06ae81f ffff88003db22140 ffff880072435000 ffff880000000000
[ 1148.064207] Call Trace:
[ 1148.064211]  [<ffffffff8166bcbc>] _raw_read_lock+0x1c/0x30
[ 1148.064221]  [<ffffffffa0710140>] btrfs_tree_read_lock+0x50/0x100 [btrfs]
[ 1148.064226]  [<ffffffffa06ae81f>] ? leaf_space_used+0xcf/0x110 [btrfs]
[ 1148.064231]  [<ffffffffa06b0deb>] btrfs_read_lock_root_node+0x3b/0x50 [btrfs]
[ 1148.064236]  [<ffffffffa06b5c3e>] btrfs_search_slot+0x50e/0xa10 [btrfs]
[ 1148.064245]  [<ffffffffa0720ee4>] ? btrfs_add_delayed_data_ref+0x114/0x180 [btrfs]
[ 1148.064252]  [<ffffffffa06cbe2e>] btrfs_lookup_csum+0x5e/0x180 [btrfs]
[ 1148.064259]  [<ffffffffa06cd19c>] btrfs_csum_file_blocks+0xbc/0x680 [btrfs]
[ 1148.064264]  [<ffffffffa06b0d46>] ? btrfs_free_path+0x26/0x30 [btrfs]
[ 1148.064272]  [<ffffffffa06db1e0>] add_pending_csums.isra.42+0x50/0x80 [btrfs]
[ 1148.064280]  [<ffffffffa06e1410>] btrfs_finish_ordered_io+0x470/0x570 [btrfs]
[ 1148.064283]  [<ffffffff810a702f>] ? set_next_entity+0x5f/0x80
[ 1148.064291]  [<ffffffffa06e1785>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1148.064300]  [<ffffffffa0706b3c>] normal_work_helper+0xbc/0x290 [btrfs]
[ 1148.064302]  [<ffffffff8108ab95>] process_one_work+0x175/0x430
[ 1148.064303]  [<ffffffff8108b23b>] worker_thread+0x11b/0x520
[ 1148.064304]  [<ffffffff8108b120>] ? rescuer_thread+0x2d0/0x2d0
[ 1148.064305]  [<ffffffff81091712>] kthread+0xd2/0xf0
[ 1148.064306]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1148.064308]  [<ffffffff8166c23c>] ret_from_fork+0x7c/0xb0
[ 1148.064309]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1148.064318] Code: 90 8b 07 84 c0 75 f8 b8 00 01 00 00 f0 0f c1 07 3c ff 75 0b 0f 1f 00 f3 90 8b 07 3c ff 74 f8 80 47 04 01 5d c3 f3 90 0f b6 47 04 <38> c2 75 f6 eb bf 8b 07 3c ff 75 ec f3 90 8b 07 3c ff 74 f8 5d
[ 1148.076150] BUG: soft lockup - CPU#7 stuck for 23s! [kworker/u26:8:30979]
[ 1148.076165] Modules linked in: loop ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables btrfs coretemp kvm_intel kvm xor raid6_pq crc32_pclmul crc32c_intel ghash_clmulni_intel nfsd igb microcode ptp pps_core dca iTCO_wdt shpchp auth_rpcgss iTCO_vendor_support i7core_edac pcspkr edac_core i2c_i801 lpc_ich mfd_core ipmi_si tpm_infineon ipmi_msghandler tpm_tis nfs_acl tpm acpi_power_meter lockd acpi_cpufreq sunrpc usb_storage mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm ata_generic pata_acpi drm megaraid_sas i2c_core ata_piix
[ 1148.076166] CPU: 7 PID: 30979 Comm: kworker/u26:8 Not tainted 3.16.0-rc1 #1
[ 1148.076167] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[ 1148.076177] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[ 1148.076178] task: ffff88013c030000 ti: ffff88013465c000 task.ti: ffff88013465c000
[ 1148.076180] RIP: 0010:[<ffffffff810ba85c>]  [<ffffffff810ba85c>] queue_read_lock_slowpath+0x6c/0x90
[ 1148.076181] RSP: 0018:ffff88013465fac8  EFLAGS: 00000216
[ 1148.076181] RAX: 00000000000000ee RBX: 0000000000000000 RCX: 000000000000000b
[ 1148.076182] RDX: 00000000000000f4 RSI: 000000000000000b RDI: ffff88003db221b0
[ 1148.076182] RBP: ffff88013465fac8 R08: ffff88003db22174 R09: 0000000000000000
[ 1148.076183] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000001000
[ 1148.076183] R13: 0000000000000000 R14: ffff8800b4ba1000 R15: ffffffffa06b60a1
[ 1148.076184] FS:  0000000000000000(0000) GS:ffff88013fc40000(0000) knlGS:0000000000000000
[ 1148.076185] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1148.076185] CR2: 0000000000d36000 CR3: 0000000001c0e000 CR4: 00000000000007e0
[ 1148.076186] Stack:
[ 1148.076187]  ffff88013465fad8 ffffffff8166bcbc ffff88013465fb38 ffffffffa0710140
[ 1148.076188]  0000000000000088 0000000000000035 0000000000000000 ffff88013465fb58
[ 1148.076189]  ffffffffa06ae81f ffff88003db22140 ffff880072435000 ffff880000000000
[ 1148.076189] Call Trace:
[ 1148.076191]  [<ffffffff8166bcbc>] _raw_read_lock+0x1c/0x30
[ 1148.076200]  [<ffffffffa0710140>] btrfs_tree_read_lock+0x50/0x100 [btrfs]
[ 1148.076205]  [<ffffffffa06ae81f>] ? leaf_space_used+0xcf/0x110 [btrfs]
[ 1148.076210]  [<ffffffffa06b0deb>] btrfs_read_lock_root_node+0x3b/0x50 [btrfs]
[ 1148.076215]  [<ffffffffa06b5c3e>] btrfs_search_slot+0x50e/0xa10 [btrfs]
[ 1148.076224]  [<ffffffffa0720ee4>] ? btrfs_add_delayed_data_ref+0x114/0x180 [btrfs]
[ 1148.076231]  [<ffffffffa06cbe2e>] btrfs_lookup_csum+0x5e/0x180 [btrfs]
[ 1148.076238]  [<ffffffffa06cd19c>] btrfs_csum_file_blocks+0xbc/0x680 [btrfs]
[ 1148.076243]  [<ffffffffa06b0d46>] ? btrfs_free_path+0x26/0x30 [btrfs]
[ 1148.076251]  [<ffffffffa06db1e0>] add_pending_csums.isra.42+0x50/0x80 [btrfs]
[ 1148.076259]  [<ffffffffa06e1410>] btrfs_finish_ordered_io+0x470/0x570 [btrfs]
[ 1148.076268]  [<ffffffffa06e1785>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1148.076277]  [<ffffffffa0706b3c>] normal_work_helper+0xbc/0x290 [btrfs]
[ 1148.076278]  [<ffffffff8108ab95>] process_one_work+0x175/0x430
[ 1148.076279]  [<ffffffff8108b23b>] worker_thread+0x11b/0x520
[ 1148.076280]  [<ffffffff8108b120>] ? rescuer_thread+0x2d0/0x2d0
[ 1148.076281]  [<ffffffff81091712>] kthread+0xd2/0xf0
[ 1148.076283]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1148.076284]  [<ffffffff8166c23c>] ret_from_fork+0x7c/0xb0
[ 1148.076285]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1148.076295] Code: 90 8b 07 84 c0 75 f8 b8 00 01 00 00 f0 0f c1 07 3c ff 75 0b 0f 1f 00 f3 90 8b 07 3c ff 74 f8 80 47 04 01 5d c3 f3 90 0f b6 47 04 <38> c2 75 f6 eb bf 8b 07 3c ff 75 ec f3 90 8b 07 3c ff 74 f8 5d
[ 1148.088148] BUG: soft lockup - CPU#8 stuck for 23s! [kworker/u26:4:3183]
[ 1148.088162] Modules linked in: loop ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables btrfs coretemp kvm_intel kvm xor raid6_pq crc32_pclmul crc32c_intel ghash_clmulni_intel nfsd igb microcode ptp pps_core dca iTCO_wdt shpchp auth_rpcgss iTCO_vendor_support i7core_edac pcspkr edac_core i2c_i801 lpc_ich mfd_core ipmi_si tpm_infineon ipmi_msghandler tpm_tis nfs_acl tpm acpi_power_meter lockd acpi_cpufreq sunrpc usb_storage mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm ata_generic pata_acpi drm megaraid_sas i2c_core ata_piix
[ 1148.088164] CPU: 8 PID: 3183 Comm: kworker/u26:4 Not tainted 3.16.0-rc1 #1
[ 1148.088164] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[ 1148.088175] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[ 1148.088175] task: ffff8801325212c0 ti: ffff88013bdf0000 task.ti: ffff88013bdf0000
[ 1148.088178] RIP: 0010:[<ffffffff810ba858>]  [<ffffffff810ba858>] queue_read_lock_slowpath+0x68/0x90
[ 1148.088178] RSP: 0018:ffff88013bdf3ac8  EFLAGS: 00000212
[ 1148.088179] RAX: 00000000000000ee RBX: 0000000000000000 RCX: 0000000000000007
[ 1148.088180] RDX: 00000000000000f0 RSI: 0000000000000007 RDI: ffff88003db221b0
[ 1148.088180] RBP: ffff88013bdf3ac8 R08: ffff88003db22174 R09: 0000000000000000
[ 1148.088181] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000001000
[ 1148.088181] R13: 0000000000000000 R14: ffff8800b4ba1000 R15: ffffffffa06b60a1
[ 1148.088182] FS:  0000000000000000(0000) GS:ffff88013fc80000(0000) knlGS:0000000000000000
[ 1148.088183] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1148.088183] CR2: 0000000000cb9000 CR3: 0000000001c0e000 CR4: 00000000000007e0
[ 1148.088184] Stack:
[ 1148.088185]  ffff88013bdf3ad8 ffffffff8166bcbc ffff88013bdf3b38 ffffffffa0710140
[ 1148.088186]  0000000000000087 0000000000000035 0000000000000000 ffff88013bdf3b58
[ 1148.088187]  ffffffffa06ae81f ffff88003db22140 ffff880072435000 ffff880000000000
[ 1148.088187] Call Trace:
[ 1148.088189]  [<ffffffff8166bcbc>] _raw_read_lock+0x1c/0x30
[ 1148.088199]  [<ffffffffa0710140>] btrfs_tree_read_lock+0x50/0x100 [btrfs]
[ 1148.088203]  [<ffffffffa06ae81f>] ? leaf_space_used+0xcf/0x110 [btrfs]
[ 1148.088208]  [<ffffffffa06b0deb>] btrfs_read_lock_root_node+0x3b/0x50 [btrfs]
[ 1148.088214]  [<ffffffffa06b5c3e>] btrfs_search_slot+0x50e/0xa10 [btrfs]
[ 1148.088223]  [<ffffffffa0720ee4>] ? btrfs_add_delayed_data_ref+0x114/0x180 [btrfs]
[ 1148.088229]  [<ffffffffa06cbe2e>] btrfs_lookup_csum+0x5e/0x180 [btrfs]
[ 1148.088236]  [<ffffffffa06cd19c>] btrfs_csum_file_blocks+0xbc/0x680 [btrfs]
[ 1148.088241]  [<ffffffffa06b0d46>] ? btrfs_free_path+0x26/0x30 [btrfs]
[ 1148.088249]  [<ffffffffa06db1e0>] add_pending_csums.isra.42+0x50/0x80 [btrfs]
[ 1148.088257]  [<ffffffffa06e1410>] btrfs_finish_ordered_io+0x470/0x570 [btrfs]
[ 1148.088266]  [<ffffffffa06e1785>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1148.088275]  [<ffffffffa0706b3c>] normal_work_helper+0xbc/0x290 [btrfs]
[ 1148.088276]  [<ffffffff8108ab95>] process_one_work+0x175/0x430
[ 1148.088277]  [<ffffffff8108b23b>] worker_thread+0x11b/0x520
[ 1148.088278]  [<ffffffff8108b120>] ? rescuer_thread+0x2d0/0x2d0
[ 1148.088280]  [<ffffffff81091712>] kthread+0xd2/0xf0
[ 1148.088281]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1148.088282]  [<ffffffff8166c23c>] ret_from_fork+0x7c/0xb0
[ 1148.088284]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1148.088293] Code: 00 00 00 f3 90 8b 07 84 c0 75 f8 b8 00 01 00 00 f0 0f c1 07 3c ff 75 0b 0f 1f 00 f3 90 8b 07 3c ff 74 f8 80 47 04 01 5d c3 f3 90 <0f> b6 47 04 38 c2 75 f6 eb bf 8b 07 3c ff 75 ec f3 90 8b 07 3c
[ 1148.100145] BUG: soft lockup - CPU#9 stuck for 23s! [kworker/u26:16:23157]
[ 1148.100160] Modules linked in: loop ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables btrfs coretemp kvm_intel kvm xor raid6_pq crc32_pclmul crc32c_intel ghash_clmulni_intel nfsd igb microcode ptp pps_core dca iTCO_wdt shpchp auth_rpcgss iTCO_vendor_support i7core_edac pcspkr edac_core i2c_i801 lpc_ich mfd_core ipmi_si tpm_infineon ipmi_msghandler tpm_tis nfs_acl tpm acpi_power_meter lockd acpi_cpufreq sunrpc usb_storage mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm ata_generic pata_acpi drm megaraid_sas i2c_core ata_piix
[ 1148.100161] CPU: 9 PID: 23157 Comm: kworker/u26:16 Not tainted 3.16.0-rc1 #1
[ 1148.100162] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[ 1148.100172] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[ 1148.100173] task: ffff8800b795e720 ti: ffff8800b44fc000 task.ti: ffff8800b44fc000
[ 1148.100175] RIP: 0010:[<ffffffff810ba858>]  [<ffffffff810ba858>] queue_read_lock_slowpath+0x68/0x90
[ 1148.100176] RSP: 0018:ffff8800b44ffac8  EFLAGS: 00000212
[ 1148.100176] RAX: 00000000000000ee RBX: ffff88007d84bf00 RCX: 0000000000000009
[ 1148.100177] RDX: 00000000000000f2 RSI: 0000000000000009 RDI: ffff88003db221b0
[ 1148.100177] RBP: ffff8800b44ffac8 R08: ffff88003db22174 R09: 0000000000000000
[ 1148.100178] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8800b795e720
[ 1148.100178] R13: ffffffff8119da74 R14: ffff8800b44ffa68 R15: ffff8800b795e720
[ 1148.100179] FS:  0000000000000000(0000) GS:ffff88013fcc0000(0000) knlGS:0000000000000000
[ 1148.100180] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1148.100180] CR2: 000000000243b000 CR3: 0000000001c0e000 CR4: 00000000000007e0
[ 1148.100180] Stack:
[ 1148.100182]  ffff8800b44ffad8 ffffffff8166bcbc ffff8800b44ffb38 ffffffffa0710140
[ 1148.100182]  ffffffff00000000 ffffe8ff00000000 ffffffffa0720e54 0000005000000002
[ 1148.100183]  0000000000000296 ffff88003db22140 ffff880072435000 ffff880000000000
[ 1148.100184] Call Trace:
[ 1148.100186]  [<ffffffff8166bcbc>] _raw_read_lock+0x1c/0x30
[ 1148.100195]  [<ffffffffa0710140>] btrfs_tree_read_lock+0x50/0x100 [btrfs]
[ 1148.100204]  [<ffffffffa0720e54>] ? btrfs_add_delayed_data_ref+0x84/0x180 [btrfs]
[ 1148.100209]  [<ffffffffa06b0deb>] btrfs_read_lock_root_node+0x3b/0x50 [btrfs]
[ 1148.100215]  [<ffffffffa06b5c3e>] btrfs_search_slot+0x50e/0xa10 [btrfs]
[ 1148.100224]  [<ffffffffa0720ee4>] ? btrfs_add_delayed_data_ref+0x114/0x180 [btrfs]
[ 1148.100230]  [<ffffffffa06cbe2e>] btrfs_lookup_csum+0x5e/0x180 [btrfs]
[ 1148.100237]  [<ffffffffa06cd19c>] btrfs_csum_file_blocks+0xbc/0x680 [btrfs]
[ 1148.100242]  [<ffffffffa06b0d46>] ? btrfs_free_path+0x26/0x30 [btrfs]
[ 1148.100250]  [<ffffffffa06db1e0>] add_pending_csums.isra.42+0x50/0x80 [btrfs]
[ 1148.100258]  [<ffffffffa06e1410>] btrfs_finish_ordered_io+0x470/0x570 [btrfs]
[ 1148.100260]  [<ffffffff810a702f>] ? set_next_entity+0x5f/0x80
[ 1148.100268]  [<ffffffffa06e1785>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1148.100277]  [<ffffffffa0706b3c>] normal_work_helper+0xbc/0x290 [btrfs]
[ 1148.100278]  [<ffffffff8108ab95>] process_one_work+0x175/0x430
[ 1148.100279]  [<ffffffff8108b23b>] worker_thread+0x11b/0x520
[ 1148.100280]  [<ffffffff8108b120>] ? rescuer_thread+0x2d0/0x2d0
[ 1148.100282]  [<ffffffff81091712>] kthread+0xd2/0xf0
[ 1148.100283]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1148.100284]  [<ffffffff8166c23c>] ret_from_fork+0x7c/0xb0
[ 1148.100285]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1148.100295] Code: 00 00 00 f3 90 8b 07 84 c0 75 f8 b8 00 01 00 00 f0 0f c1 07 3c ff 75 0b 0f 1f 00 f3 90 8b 07 3c ff 74 f8 80 47 04 01 5d c3 f3 90 <0f> b6 47 04 38 c2 75 f6 eb bf 8b 07 3c ff 75 ec f3 90 8b 07 3c
[ 1148.113142] BUG: soft lockup - CPU#10 stuck for 23s! [kworker/u26:5:13041]
[ 1148.113156] Modules linked in: loop ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables btrfs coretemp kvm_intel kvm xor raid6_pq crc32_pclmul crc32c_intel ghash_clmulni_intel nfsd igb microcode ptp pps_core dca iTCO_wdt shpchp auth_rpcgss iTCO_vendor_support i7core_edac pcspkr edac_core i2c_i801 lpc_ich mfd_core ipmi_si tpm_infineon ipmi_msghandler tpm_tis nfs_acl tpm acpi_power_meter lockd acpi_cpufreq sunrpc usb_storage mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm ata_generic pata_acpi drm megaraid_sas i2c_core ata_piix
[ 1148.113158] CPU: 10 PID: 13041 Comm: kworker/u26:5 Not tainted 3.16.0-rc1 #1
[ 1148.113158] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[ 1148.113169] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[ 1148.113169] task: ffff8800ba7bcb00 ti: ffff8800b58a8000 task.ti: ffff8800b58a8000
[ 1148.113172] RIP: 0010:[<ffffffff810ba832>]  [<ffffffff810ba832>] queue_read_lock_slowpath+0x42/0x90
[ 1148.113172] RSP: 0018:ffff8800b58abae0  EFLAGS: 00000286
[ 1148.113173] RAX: 00000000000000ff RBX: ffff8800b58abb80 RCX: 0000000000000001
[ 1148.113174] RDX: 0000000000000015 RSI: 00000000b98af000 RDI: ffff8800715d1970
[ 1148.113174] RBP: ffff8800b58abae0 R08: 0000000000000001 R09: ffff880071486b58
[ 1148.113174] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffa06d2f56
[ 1148.113175] R13: ffff8800b58aba78 R14: 0000000000000001 R15: 0000000000000012
[ 1148.113176] FS:  0000000000000000(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
[ 1148.113176] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1148.113177] CR2: 0000000001945000 CR3: 0000000001c0e000 CR4: 00000000000007e0
[ 1148.113177] Stack:
[ 1148.113178]  ffff8800b58abaf0 ffffffff8166bcbc ffff8800b58abb10 ffffffffa0710221
[ 1148.113179]  ffff8800b658f750 0000000000000000 ffff8800b58abbb0 ffffffffa06b5c95
[ 1148.113180]  ffff8800b658f750 0000000000000000 0000000000000000 ffff8800b58abb58
[ 1148.113180] Call Trace:
[ 1148.113182]  [<ffffffff8166bcbc>] _raw_read_lock+0x1c/0x30
[ 1148.113192]  [<ffffffffa0710221>] btrfs_try_tree_read_lock+0x31/0x60 [btrfs]
[ 1148.113197]  [<ffffffffa06b5c95>] btrfs_search_slot+0x565/0xa10 [btrfs]
[ 1148.113203]  [<ffffffffa06b8eb8>] btrfs_next_old_leaf+0x218/0x4b0 [btrfs]
[ 1148.113209]  [<ffffffffa06b9160>] btrfs_next_leaf+0x10/0x20 [btrfs]
[ 1148.113215]  [<ffffffffa06cd44b>] btrfs_csum_file_blocks+0x36b/0x680 [btrfs]
[ 1148.113220]  [<ffffffffa06b0d46>] ? btrfs_free_path+0x26/0x30 [btrfs]
[ 1148.113228]  [<ffffffffa06db1e0>] add_pending_csums.isra.42+0x50/0x80 [btrfs]
[ 1148.113237]  [<ffffffffa06e1410>] btrfs_finish_ordered_io+0x470/0x570 [btrfs]
[ 1148.113245]  [<ffffffffa06e1785>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1148.113254]  [<ffffffffa0706b3c>] normal_work_helper+0xbc/0x290 [btrfs]
[ 1148.113255]  [<ffffffff8108ab95>] process_one_work+0x175/0x430
[ 1148.113256]  [<ffffffff8108b23b>] worker_thread+0x11b/0x520
[ 1148.113257]  [<ffffffff8108b120>] ? rescuer_thread+0x2d0/0x2d0
[ 1148.113258]  [<ffffffff81091712>] kthread+0xd2/0xf0
[ 1148.113260]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1148.113261]  [<ffffffff8166c23c>] ret_from_fork+0x7c/0xb0
[ 1148.113263]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1148.113272] Code: 5a f0 81 2f 00 01 00 00 b8 00 01 00 00 f0 66 0f c1 47 04 0f b6 d4 38 c2 75 37 8b 07 84 c0 74 11 66 0f 1f 84 00 00 00 00 00 f3 90 <8b> 07 84 c0 75 f8 b8 00 01 00 00 f0 0f c1 07 3c ff 75 0b 0f 1f
[ 1148.125139] BUG: soft lockup - CPU#11 stuck for 23s! [kworker/u26:6:30977]
[ 1148.125154] Modules linked in: loop ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables btrfs coretemp kvm_intel kvm xor raid6_pq crc32_pclmul crc32c_intel ghash_clmulni_intel nfsd igb microcode ptp pps_core dca iTCO_wdt shpchp auth_rpcgss iTCO_vendor_support i7core_edac pcspkr edac_core i2c_i801 lpc_ich mfd_core ipmi_si tpm_infineon ipmi_msghandler tpm_tis nfs_acl tpm acpi_power_meter lockd acpi_cpufreq sunrpc usb_storage mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm ata_generic pata_acpi drm megaraid_sas i2c_core ata_piix
[ 1148.125156] CPU: 11 PID: 30977 Comm: kworker/u26:6 Not tainted 3.16.0-rc1 #1
[ 1148.125156] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[ 1148.125167] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[ 1148.125167] task: ffff88013c032ee0 ti: ffff8801362fc000 task.ti: ffff8801362fc000
[ 1148.125170] RIP: 0010:[<ffffffff810ba858>]  [<ffffffff810ba858>] queue_read_lock_slowpath+0x68/0x90
[ 1148.125170] RSP: 0018:ffff8801362ffac8  EFLAGS: 00000216
[ 1148.125171] RAX: 00000000000000ee RBX: 0000000000000000 RCX: 000000000000000a
[ 1148.125171] RDX: 00000000000000f3 RSI: 000000000000000a RDI: ffff88003db221b0
[ 1148.125172] RBP: ffff8801362ffac8 R08: ffff88003db22174 R09: 0000000000000000
[ 1148.125172] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000001000
[ 1148.125173] R13: 0000000000000000 R14: ffff8800b593e000 R15: ffffffffa06b60a1
[ 1148.125173] FS:  0000000000000000(0000) GS:ffff88013fd40000(0000) knlGS:0000000000000000
[ 1148.125174] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1148.125175] CR2: 000000000131e000 CR3: 0000000001c0e000 CR4: 00000000000007e0
[ 1148.125175] Stack:
[ 1148.125176]  ffff8801362ffad8 ffffffff8166bcbc ffff8801362ffb38 ffffffffa0710140
[ 1148.125177]  0000000000000087 0000000000000035 0000000000000000 ffff8801362ffb58
[ 1148.125178]  ffffffffa06ae81f ffff88003db22140 ffff880072435000 ffff880000000000
[ 1148.125178] Call Trace:
[ 1148.125180]  [<ffffffff8166bcbc>] _raw_read_lock+0x1c/0x30
[ 1148.125190]  [<ffffffffa0710140>] btrfs_tree_read_lock+0x50/0x100 [btrfs]
[ 1148.125194]  [<ffffffffa06ae81f>] ? leaf_space_used+0xcf/0x110 [btrfs]
[ 1148.125199]  [<ffffffffa06b0deb>] btrfs_read_lock_root_node+0x3b/0x50 [btrfs]
[ 1148.125205]  [<ffffffffa06b5c3e>] btrfs_search_slot+0x50e/0xa10 [btrfs]
[ 1148.125214]  [<ffffffffa0720ee4>] ? btrfs_add_delayed_data_ref+0x114/0x180 [btrfs]
[ 1148.125220]  [<ffffffffa06cbe2e>] btrfs_lookup_csum+0x5e/0x180 [btrfs]
[ 1148.125227]  [<ffffffffa06cd19c>] btrfs_csum_file_blocks+0xbc/0x680 [btrfs]
[ 1148.125232]  [<ffffffffa06b0d46>] ? btrfs_free_path+0x26/0x30 [btrfs]
[ 1148.125240]  [<ffffffffa06db1e0>] add_pending_csums.isra.42+0x50/0x80 [btrfs]
[ 1148.125249]  [<ffffffffa06e1410>] btrfs_finish_ordered_io+0x470/0x570 [btrfs]
[ 1148.125251]  [<ffffffff8109ea79>] ? ttwu_do_wakeup+0x19/0xc0
[ 1148.125259]  [<ffffffffa06e1785>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1148.125268]  [<ffffffffa0706b3c>] normal_work_helper+0xbc/0x290 [btrfs]
[ 1148.125269]  [<ffffffff8108ab95>] process_one_work+0x175/0x430
[ 1148.125270]  [<ffffffff8108b23b>] worker_thread+0x11b/0x520
[ 1148.125271]  [<ffffffff8108b120>] ? rescuer_thread+0x2d0/0x2d0
[ 1148.125272]  [<ffffffff81091712>] kthread+0xd2/0xf0
[ 1148.125274]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1148.125275]  [<ffffffff8166c23c>] ret_from_fork+0x7c/0xb0
[ 1148.125276]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1148.125285] Code: 00 00 00 f3 90 8b 07 84 c0 75 f8 b8 00 01 00 00 f0 0f c1 07 3c ff 75 0b 0f 1f 00 f3 90 8b 07 3c ff 74 f8 80 47 04 01 5d c3 f3 90 <0f> b6 47 04 38 c2 75 f6 eb bf 8b 07 3c ff 75 ec f3 90 8b 07 3c
[ 1151.904945] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[ 1151.912879]  0000000000000416 ffff88007dc03e28 ffffffff81664f20 ffffffff81a1008f
[ 1151.922093]  ffff88007dc03ea0 ffffffff81660ab5 0000000000000008 ffff88007dc03eb0
[ 1151.931277]  ffff88007dc03e50 00000000000000c5 0000000000000046 0000000000000007
[ 1151.940446] Call Trace:
[ 1151.944023]  <IRQ>  [<ffffffff81664f20>] dump_stack+0x45/0x56
[ 1151.951312]  [<ffffffff81660ab5>] panic+0xc8/0x1fc
[ 1151.957504]  [<ffffffff81110605>] watchdog_timer_fn+0x165/0x170
[ 1151.964952]  [<ffffffff810949d5>] __run_hrtimer+0x75/0x1d0
[ 1151.971894]  [<ffffffff811104a0>] ? watchdog_cleanup+0x10/0x10
[ 1151.979219]  [<ffffffff81094dc7>] hrtimer_interrupt+0xf7/0x240
[ 1151.986525]  [<ffffffff810328f7>] local_apic_timer_interrupt+0x37/0x60
[ 1151.994615]  [<ffffffff8166e7cf>] smp_apic_timer_interrupt+0x3f/0x60
[ 1152.002514]  [<ffffffff8166d16d>] apic_timer_interrupt+0x6d/0x80
[ 1152.010020]  <EOI>  [<ffffffff810ba858>] ? queue_read_lock_slowpath+0x68/0x90
[ 1152.018830]  [<ffffffffa0710519>] ? btrfs_tree_lock+0xc9/0x1d0 [btrfs]
[ 1152.026939]  [<ffffffff8166bcbc>] _raw_read_lock+0x1c/0x30
[ 1152.033890]  [<ffffffffa070ffe4>] btrfs_clear_lock_blocking_rw+0x44/0x150 [btrfs]
[ 1152.043070]  [<ffffffffa06b0c2a>] btrfs_clear_path_blocking+0x3a/0x80 [btrfs]
[ 1152.051856]  [<ffffffffa06b5e32>] btrfs_search_slot+0x702/0xa10 [btrfs]
[ 1152.060056]  [<ffffffffa06cbe2e>] btrfs_lookup_csum+0x5e/0x180 [btrfs]
[ 1152.068148]  [<ffffffffa06cd19c>] btrfs_csum_file_blocks+0xbc/0x680 [btrfs]
[ 1152.076719]  [<ffffffffa06b0d46>] ? btrfs_free_path+0x26/0x30 [btrfs]
[ 1152.084709]  [<ffffffffa06db1e0>] add_pending_csums.isra.42+0x50/0x80 [btrfs]
[ 1152.093472]  [<ffffffffa06e1410>] btrfs_finish_ordered_io+0x470/0x570 [btrfs]
[ 1152.102235]  [<ffffffffa06e1785>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1152.110222]  [<ffffffffa0706b3c>] normal_work_helper+0xbc/0x290 [btrfs]
[ 1152.118392]  [<ffffffff8108ab95>] process_one_work+0x175/0x430
[ 1152.125686]  [<ffffffff8108b23b>] worker_thread+0x11b/0x520
[ 1152.132686]  [<ffffffff8108b120>] ? rescuer_thread+0x2d0/0x2d0
[ 1152.139972]  [<ffffffff81091712>] kthread+0xd2/0xf0
[ 1152.146182]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1152.153754]  [<ffffffff8166c23c>] ret_from_fork+0x7c/0xb0
[ 1152.160547]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
crash>


