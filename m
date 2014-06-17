Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19239 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753113AbaFQBG2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 21:06:28 -0400
Message-ID: <539F95C6.8050809@fb.com>
Date: Mon, 16 Jun 2014 21:11:34 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [3.16-rc1] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u25:4:5189]
References: <539E9026.1020406@jp.fujitsu.com> <539F2FEA.1060809@fb.com> <539F7D8E.9010608@jp.fujitsu.com> <539F8351.3010700@fb.com> <539F846A.4080608@jp.fujitsu.com>
In-Reply-To: <539F846A.4080608@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/16/2014 07:57 PM, Tsutomu Itoh wrote:
> On 2014/06/17 8:52, Chris Mason wrote:
>> On 06/16/2014 07:28 PM, Tsutomu Itoh wrote:
>>> Hi Chris,
>>>
>>> On 2014/06/17 2:56, Chris Mason wrote:
>>>> On 06/16/2014 02:35 AM, Tsutomu Itoh wrote:
>>>>> I encountered soft lockup when executing 'xfstests btrfs/042' on 3.16-rc1.
>>>>>
>>>>
>>>> Did we recover, or was it stuck forever?
>>>
>>> The following messages are repeatedly output.
>>> And stuck forever.
>>>
>>> [ 1147.942181] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u25:4:5189]
>>> [ 1147.967175] BUG: soft lockup - CPU#3 stuck for 23s! [kworker/u25:9:5194]
>>> [ 1147.979172] BUG: soft lockup - CPU#4 stuck for 23s! [kworker/u25:15:5200]
>>> [ 1147.991169] BUG: soft lockup - CPU#5 stuck for 23s! [kworker/u25:7:5192]
>>> [ 1148.064153] BUG: soft lockup - CPU#6 stuck for 23s! [kworker/u26:3:3182]
>>
>> Can you please capture a stack trace from all the cpus?
>>
> 
> crash> log
> ...
> [ 1121.996312] BTRFS: creating UUID tree
> [ 1122.050762] BTRFS info (device sdc5): qgroup scan completed
> [ 1147.942181] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u25:4:5189]
> [ 1147.949658] Modules linked in: loop ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables btrfs coretemp kvm_intel kvm xor raid6_pq crc32_pclmul crc32c_intel ghash_clmulni_intel nfsd igb microcode ptp pps_core dca iTCO_wdt shpchp auth_rpcgss iTCO_vendor_support i7core_edac pcspkr edac_core i2c_i801 lpc_ich mfd_core ipmi_si tpm_infineon ipmi_msghandler tpm_tis nfs_acl tpm acpi_power_meter lockd acpi_cpufreq sunrpc usb_storage mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm ata_generic pata_acpi drm megaraid_sas i2c_core ata_piix
> [ 1147.949695] CPU: 0 PID: 5189 Comm: kworker/u25:4 Not tainted 3.16.0-rc1 #1
> [ 1147.949696] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
> [ 1147.949717] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
> [ 1147.949718] task: ffff88007408b840 ti: ffff8800740e4000 task.ti: ffff8800740e4000
> [ 1147.949720] RIP: 0010:[<ffffffff810ba858>]  [<ffffffff810ba858>] queue_read_lock_slowpath+0x68/0x90
> [ 1147.949725] RSP: 0018:ffff8800740e7b08  EFLAGS: 00000202
> [ 1147.949726] RAX: 00000000000000ee RBX: 0000000000000012 RCX: 0000000000000001
> [ 1147.949727] RDX: 00000000000000ef RSI: 0000000000000004 RDI: ffff88003db221b0
> [ 1147.949728] RBP: ffff8800740e7b08 R08: 0000000000000001 R09: ffff880071486b58
> [ 1147.949729] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800715d1900
> [ 1147.949730] R13: 0000000000000000 R14: 0000000000000003 R15: 0000000000000002
> [ 1147.949732] FS:  0000000000000000(0000) GS:ffff88007dc00000(0000) knlGS:0000000000000000
> [ 1147.949733] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 1147.949734] CR2: 00000036c97b9490 CR3: 0000000001c0e000 CR4: 00000000000007f0
> [ 1147.949735] Stack:
> [ 1147.949736]  ffff8800740e7b18 ffffffff8166bcbc ffff8800740e7b38 ffffffffa070ffe4
> [ 1147.949738]  0000000000000001 ffffffffffffffe8 ffff8800740e7b58 ffffffffa06b0c2a
> [ 1147.949740]  ffff8800719de360 0000000000000000 ffff8800740e7bf8 ffffffffa06b5e32
> [ 1147.949742] Call Trace:
> [ 1147.949748]  [<ffffffff8166bcbc>] _raw_read_lock+0x1c/0x30
> [ 1147.949760]  [<ffffffffa070ffe4>] btrfs_clear_lock_blocking_rw+0x44/0x150 [btrfs]
> [ 1147.949767]  [<ffffffffa06b0c2a>] btrfs_clear_path_blocking+0x3a/0x80 [btrfs]
> [ 1147.949774]  [<ffffffffa06b5e32>] btrfs_search_slot+0x702/0xa10 [btrfs]

Also, which line of ctree.c is this call?

Thanks!

-chris
