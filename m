Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:40875 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaFQBgp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 21:36:45 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail.fujitsu.co.jp (Postfix) with ESMTP id 527F53EE0D1
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 10:36:43 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.nic.fujitsu.com [10.0.50.92])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 5FE77AC080E
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 10:36:42 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 115141DB803A
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 10:36:42 +0900 (JST)
Message-ID: <539F9B93.4090208@jp.fujitsu.com>
Date: Tue, 17 Jun 2014 10:36:19 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [3.16-rc1] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u25:4:5189]
References: <539E9026.1020406@jp.fujitsu.com> <539F2FEA.1060809@fb.com> <539F7D8E.9010608@jp.fujitsu.com> <539F8351.3010700@fb.com> <539F846A.4080608@jp.fujitsu.com> <539F95C6.8050809@fb.com>
In-Reply-To: <539F95C6.8050809@fb.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/06/17 10:11, Chris Mason wrote:
> 
> 
> On 06/16/2014 07:57 PM, Tsutomu Itoh wrote:
>> On 2014/06/17 8:52, Chris Mason wrote:
>>> On 06/16/2014 07:28 PM, Tsutomu Itoh wrote:
>>>> Hi Chris,
>>>>
>>>> On 2014/06/17 2:56, Chris Mason wrote:
>>>>> On 06/16/2014 02:35 AM, Tsutomu Itoh wrote:
>>>>>> I encountered soft lockup when executing 'xfstests btrfs/042' on 3.16-rc1.
>>>>>>
>>>>>
>>>>> Did we recover, or was it stuck forever?
>>>>
>>>> The following messages are repeatedly output.
>>>> And stuck forever.
>>>>
>>>> [ 1147.942181] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u25:4:5189]
>>>> [ 1147.967175] BUG: soft lockup - CPU#3 stuck for 23s! [kworker/u25:9:5194]
>>>> [ 1147.979172] BUG: soft lockup - CPU#4 stuck for 23s! [kworker/u25:15:5200]
>>>> [ 1147.991169] BUG: soft lockup - CPU#5 stuck for 23s! [kworker/u25:7:5192]
>>>> [ 1148.064153] BUG: soft lockup - CPU#6 stuck for 23s! [kworker/u26:3:3182]
>>>
>>> Can you please capture a stack trace from all the cpus?
>>>
>>
>> crash> log
>> ...
>> [ 1121.996312] BTRFS: creating UUID tree
>> [ 1122.050762] BTRFS info (device sdc5): qgroup scan completed
>> [ 1147.942181] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u25:4:5189]
>> [ 1147.949658] Modules linked in: loop ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables btrfs coretemp kvm_intel kvm xor raid6_pq crc32_pclmul crc32c_intel ghash_clmulni_intel nfsd igb microcode ptp pps_core dca iTCO_wdt shpchp auth_rpcgss iTCO_vendor_support i7core_edac pcspkr edac_core i2c_i801 lpc_ich mfd_core ipmi_si tpm_infineon ipmi_msghandler tpm_tis nfs_acl tpm acpi_power_meter lockd acpi_cpufreq sunrpc usb_storage mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm ata_generic pata_acpi drm megaraid_sas i2c_core ata_piix
>> [ 1147.949695] CPU: 0 PID: 5189 Comm: kworker/u25:4 Not tainted 3.16.0-rc1 #1
>> [ 1147.949696] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
>> [ 1147.949717] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
>> [ 1147.949718] task: ffff88007408b840 ti: ffff8800740e4000 task.ti: ffff8800740e4000
>> [ 1147.949720] RIP: 0010:[<ffffffff810ba858>]  [<ffffffff810ba858>] queue_read_lock_slowpath+0x68/0x90
>> [ 1147.949725] RSP: 0018:ffff8800740e7b08  EFLAGS: 00000202
>> [ 1147.949726] RAX: 00000000000000ee RBX: 0000000000000012 RCX: 0000000000000001
>> [ 1147.949727] RDX: 00000000000000ef RSI: 0000000000000004 RDI: ffff88003db221b0
>> [ 1147.949728] RBP: ffff8800740e7b08 R08: 0000000000000001 R09: ffff880071486b58
>> [ 1147.949729] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800715d1900
>> [ 1147.949730] R13: 0000000000000000 R14: 0000000000000003 R15: 0000000000000002
>> [ 1147.949732] FS:  0000000000000000(0000) GS:ffff88007dc00000(0000) knlGS:0000000000000000
>> [ 1147.949733] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [ 1147.949734] CR2: 00000036c97b9490 CR3: 0000000001c0e000 CR4: 00000000000007f0
>> [ 1147.949735] Stack:
>> [ 1147.949736]  ffff8800740e7b18 ffffffff8166bcbc ffff8800740e7b38 ffffffffa070ffe4
>> [ 1147.949738]  0000000000000001 ffffffffffffffe8 ffff8800740e7b58 ffffffffa06b0c2a
>> [ 1147.949740]  ffff8800719de360 0000000000000000 ffff8800740e7bf8 ffffffffa06b5e32
>> [ 1147.949742] Call Trace:
>> [ 1147.949748]  [<ffffffff8166bcbc>] _raw_read_lock+0x1c/0x30
>> [ 1147.949760]  [<ffffffffa070ffe4>] btrfs_clear_lock_blocking_rw+0x44/0x150 [btrfs]
>> [ 1147.949767]  [<ffffffffa06b0c2a>] btrfs_clear_path_blocking+0x3a/0x80 [btrfs]
>> [ 1147.949774]  [<ffffffffa06b5e32>] btrfs_search_slot+0x702/0xa10 [btrfs]
> 
> Also, which line of ctree.c is this call?

/Build/linux-3.16-rc1/fs/btrfs/ctree.c: 2898
0xffffffffa06b5e10 <btrfs_search_slot+0x6e0>:   mov    %rbx,%rdi
0xffffffffa06b5e13 <btrfs_search_slot+0x6e3>:   callq  0xffffffffa06b0b70 <btrfs_set_path_blocking>
/Build/linux-3.16-rc1/fs/btrfs/ctree.c: 2899
0xffffffffa06b5e18 <btrfs_search_slot+0x6e8>:   mov    -0x30(%rbp),%rdi
0xffffffffa06b5e1c <btrfs_search_slot+0x6ec>:   callq  0xffffffffa0710450 <btrfs_tree_lock>
/Build/linux-3.16-rc1/fs/btrfs/ctree.c: 2900
0xffffffffa06b5e21 <btrfs_search_slot+0x6f1>:   mov    -0x30(%rbp),%rsi
0xffffffffa06b5e25 <btrfs_search_slot+0x6f5>:   mov    $0x1,%edx
0xffffffffa06b5e2a <btrfs_search_slot+0x6fa>:   mov    %rbx,%rdi
0xffffffffa06b5e2d <btrfs_search_slot+0x6fd>:   callq  0xffffffffa06b0bf0 <btrfs_clear_path_blocking>
0xffffffffa06b5e32 <btrfs_search_slot+0x702>:   jmpq   0xffffffffa06b5b54 <btrfs_search_slot+0x424>
0xffffffffa06b5e37 <btrfs_search_slot+0x707>:   nopw   0x0(%rax,%rax,1)


2686 int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
2687                       *root, struct btrfs_key *key, struct btrfs_path *p, int
2688                       ins_len, int cow)
2689 {
2690         struct extent_buffer *b;
2691         int slot;
2692         int ret;
2693         int err;
2694         int level;
2695         int lowest_unlock = 1;
2696         int root_lock;
...
...
2892
2893                         if (!p->skip_locking) {
2894                                 level = btrfs_header_level(b);
2895                                 if (level <= write_lock_level) {
2896                                         err = btrfs_try_tree_write_lock(b);
2897                                         if (!err) {
2898                                                 btrfs_set_path_blocking(p);
2899                                                 btrfs_tree_lock(b);
2900                                                 btrfs_clear_path_blocking(p, b,    <----- here
2901                                                                   BTRFS_WRITE_LOCK);
2902                                         }
2903                                         p->locks[level] = BTRFS_WRITE_LOCK;
2904                                 } else {
2905                                         err = btrfs_try_tree_read_lock(b);
2906                                         if (!err) {
2907                                                 btrfs_set_path_blocking(p);
2908                                                 btrfs_tree_read_lock(b);
2909                                                 btrfs_clear_path_blocking(p, b,
2910                                                                   BTRFS_READ_LOCK);
2911                                         }


