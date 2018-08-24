Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:21055 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbeHXLne (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Aug 2018 07:43:34 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id D6ED8AC00B8
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Aug 2018 17:09:55 +0900 (JST)
Subject: Re: [PATCH v2] btrfs: Always check nocow for quota enabled case to
 make sure we won't reserve unnecessary data space
To: Qu Wenruo <wqu@suse.de>, <linux-btrfs@vger.kernel.org>
References: <20180821054016.28058-1-wqu@suse.com>
 <afee4b2f-ee0b-8afb-b4d6-1fd8f5958e3a@jp.fujitsu.com>
 <662fd511-708f-5784-18f8-1282830d5730@suse.de>
 <99167e75-351e-ac1d-1a13-97e7717b4a8a@jp.fujitsu.com>
 <2c3f3e97-06db-4bbb-59d9-c2880190a5a5@suse.de>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <821fe1eb-cade-ed16-5154-b9f8381d0ca4@jp.fujitsu.com>
Date: Fri, 24 Aug 2018 17:09:50 +0900
MIME-Version: 1.0
In-Reply-To: <2c3f3e97-06db-4bbb-59d9-c2880190a5a5@suse.de>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/08/24 16:58, Qu Wenruo wrote:
> 
> 
> On 2018/8/24 下午3:54, Misono Tomohiro wrote:
>> On 2018/08/24 16:20, Qu Wenruo wrote:
>>>
>>>
>>> On 2018/8/24 下午3:14, Misono Tomohiro wrote:
>>>> Hi,
>>>>
>>>> On 2018/08/21 14:40, Qu Wenruo wrote:
>>>>> Commit c6887cd11149 ("Btrfs: don't do nocow check unless we have to")
>>>>> makes nocow check less frequent to improve performance.
>>>>>
>>>>> However for quota enabled case, such optimization could lead to extra
>>>>> unnecessary data reservation, which results failure for test case like
>>>>> btrfs/153 in fstests.
>>>>>
>>>>> Fix it by reverting to old behavior for quota enabled case.
>>>>>
>>>>> Fixes: c6887cd11149 ("Btrfs: don't do nocow check unless we have to")
>>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>>> ---
>>>>> changelog
>>>>> v2:
>>>>>   Fix regression for quota+cow case. (Previously it will skip data
>>>>>   reservation if quota is enabled, causing regression for limit case.
>>>>>   Pointed out by Misono)
>>>>> ---
>>>>>  fs/btrfs/file.c | 18 +++++++++++++++++-
>>>>>  1 file changed, 17 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>>>>> index 2be00e873e92..183e5fb96f42 100644
>>>>> --- a/fs/btrfs/file.c
>>>>> +++ b/fs/btrfs/file.c
>>>>> @@ -1584,6 +1584,7 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
>>>>>  	int ret = 0;
>>>>>  	bool only_release_metadata = false;
>>>>>  	bool force_page_uptodate = false;
>>>>> +	bool quota_enabled = test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
>>>>>  
>>>>>  	nrptrs = min(DIV_ROUND_UP(iov_iter_count(i), PAGE_SIZE),
>>>>>  			PAGE_SIZE / (sizeof(struct page *)));
>>>>> @@ -1624,13 +1625,28 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
>>>>>  				fs_info->sectorsize);
>>>>>  
>>>>>  		extent_changeset_release(data_reserved);
>>>>> +
>>>>> +		/*
>>>>> +		 * If we have quota enabled, we must do the heavy lift nocow
>>>>> +		 * check here to avoid reserving data space, or we can hit
>>>>> +		 * limitation for NOCOW files.
>>>>> +		 */
>>>>> +		if (quota_enabled) {
>>>>> +			if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
>>>>> +						      BTRFS_INODE_PREALLOC)) &&
>>>>> +			    check_can_nocow(BTRFS_I(inode), pos,
>>>>> +					    &write_bytes) > 0)
>>>>> +				goto reserve_meta_only;
>>>>> +		}
>>>>>  		ret = btrfs_check_data_free_space(inode, &data_reserved, pos,
>>>>>  						  write_bytes);
>>>>>  		if (ret < 0) {
>>>>>  			if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
>>>>>  						      BTRFS_INODE_PREALLOC)) &&
>>>>>  			    check_can_nocow(BTRFS_I(inode), pos,
>>>>> -					&write_bytes) > 0) {
>>>>> +					&write_bytes) > 0 &&
>>>>
>>>>> +			    !quota_enabled) {
>>>>
>>>> (When we check this condition, quota_enabled must be false or otherwise
>>>> we have already goto reserve_meta_only. So it seems redundant.)
>>>
>>> It's possible that we have quota enabled, and then
>>> btrfs_check_data_free_space() failed with -EDQUOT.
>>>
>>> In that case, we need above !quota_enabled check to avoid unnecessary
>>> check and just go error branch.
>>
>> So should quota_enabled be checked before check_can_nocow()?
> 
> Oh, yes, it should be put before nocow check.
> 
>>
>>>
>>>>
>>>>> +reserve_meta_only:
>>>>>  				/*
>>>>>  				 * For nodata cow case, no need to reserve
>>>>>  				 * data space.
>>>>>
>>>>
>>>> I applied this patch on today's misc-next and it seems mostly ok, but
>>>> btrfs/022 sometimes gives following warning:
>>>
>>> This looks like related to the regression caused by commit
>>> c4c129db5da8f070147f175 ("btrfs: drop unused
>>> parameter qgroup_reserved").
>>>
>>> Would you please try reverting that patch?
>>
>> I think above commit is fixed by commit eb27db470 ("btrfs: fix
>> qgroup_free wrong num_bytes in btrfs_subvolume_reserve_metadata") which
>> is already in misc-next too.
>>
>> I reverted above two patch (and one more related patch 6b0cb14901
>> ("btrfs: drop useless member qgroup_reserved of btrfs_pending_snapshot")),
>> but get the same result.
> 
> So something really goes wrong.
> I assume it's some error handler which double freed, but a quick glance
> nor my initial test run doesn't show something obvious.
> 
> BTW, what's the possibility of such problem in your test environment?

It's like one in several times.
It may depend on hardware performance? (the machine is not so fast),

I also noticed following warning happens too (not always):

[84089.286669] WARNING: CPU: 4 PID: 19255 at fs/btrfs/extent-tree.c:4277 btrfs_free_reserved_data_space_noquota+0xd2/0xf0 [btrfs]
[84089.286670] Modules linked in: btrfs(O) xor zstd_decompress zstd_compress xxhash raid6_pq dm_thin_pool dm_persistent_data dm_bio_prison loop dm_flakey xt_CHECKSUM ipt_MASQUERADE tun bridge stp llc xt_conntrack ip_set nfnetlink iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_raw iptable_security sunrpc intel_powerclamp kvm_intel kvm gpio_ich iTCO_wdt ipmi_ssif iTCO_vendor_support ipmi_si st irqbypass ipmi_devintf crct10dif_pclmul crc32_pclmul ipmi_msghandler ghash_clmulni_intel pcspkr acpi_power_meter i2c_i801 pcc_cpufreq i7core_edac lpc_ich acpi_cpufreq xfs libcrc32c mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm igb sr_mod hwmon uas ptp crc32c_intel cdrom usb_storage pps_core ata_generic megaraid_sas dca pata_acpi
[84089.286708]  i2c_algo_bit ipv6 [last unloaded: xor]
[84089.286712] CPU: 4 PID: 19255 Comm: kworker/u25:1 Tainted: G        W IO      4.18.0-rc8+ #98
[84089.286713] Hardware name: FUJITSU-SV                       PRIMERGY RX300 S6             /D2619, BIOS 6.00 Rev. 1.09.2619.N1           12/13/2010
[84089.286717] Workqueue: writeback wb_workfn (flush-btrfs-474)
[84089.286731] RIP: 0010:btrfs_free_reserved_data_space_noquota+0xd2/0xf0 [btrfs]
[84089.286731] Code: 49 89 d8 4c 89 f1 4c 89 fa 4c 89 e6 e8 27 51 d1 d2 48 8b 45 00 48 85 c0 75 db 41 c6 45 00 00 5b 5d 41 5c 41 5d 41 5e 41 5f c3 <0f> 0b 49 c7 45 28 00 00 00 00 e9 79 ff ff ff 0f 1f 44 00 00 66 2e
[84089.286752] RSP: 0018:ffff8ea1043176e0 EFLAGS: 00010287
[84089.286754] RAX: 0000000000004000 RBX: 0000000000005000 RCX: ffff8c1151e8cae8
[84089.286755] RDX: 0000000000000001 RSI: 00000000000c3000 RDI: ffff8c106602fa00
[84089.286755] RBP: ffffffffffffb000 R08: 0000000000000000 R09: 0000000000000143
[84089.286756] R10: ffff8c11dd95d000 R11: 00000000ffffff01 R12: ffff8c1151e80000
[84089.286757] R13: ffff8c106602fa00 R14: ffff8ea1043177e4 R15: ffff8c1151e80000
[84089.286758] FS:  0000000000000000(0000) GS:ffff8c1137d00000(0000) knlGS:0000000000000000
[84089.286759] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[84089.286760] CR2: 00007fcbb3a26000 CR3: 000000019400a002 CR4: 00000000000206e0
[84089.286761] Call Trace:
[84089.286779]  btrfs_clear_bit_hook+0x1a2/0x3f0 [btrfs]
[84089.286796]  clear_state_bit+0x51/0x1b0 [btrfs]
[84089.286812]  __clear_extent_bit+0x364/0x3c0 [btrfs]
[84089.286841]  extent_clear_unlock_delalloc+0x43/0x70 [btrfs]
[84089.286868]  run_delalloc_nocow+0x930/0xa60 [btrfs]
[84089.286897]  run_delalloc_range+0x19c/0x370 [btrfs]
[84089.286926]  writepage_delalloc+0xcf/0x180 [btrfs]
[84089.286955]  __extent_writepage+0x17a/0x310 [btrfs]
[84089.286984]  extent_write_cache_pages+0x131/0x390 [btrfs]
[84089.287012]  ? btrfs_i_callback+0x20/0x20 [btrfs]
[84089.287040]  extent_writepages+0x50/0x80 [btrfs]
[84089.287045]  do_writepages+0x4b/0xe0
[84089.287073]  ? btrfs_get_token_32+0x6b/0x130 [btrfs]
[84089.287077]  ? __writeback_single_inode+0x3d/0x320
[84089.287079]  __writeback_single_inode+0x3d/0x320
[84089.287082]  writeback_sb_inodes+0x19f/0x460
[84089.287086]  wb_writeback+0x107/0x300
[84089.287090]  ? wb_workfn+0xdf/0x410
[84089.287093]  ? current_is_workqueue_rescuer+0x27/0x40
[84089.287095]  wb_workfn+0xdf/0x410
[84089.287099]  ? put_prev_entity+0x20/0x100
[84089.287103]  process_one_work+0x18f/0x370
[84089.287106]  worker_thread+0x30/0x380
[84089.287109]  ? process_one_work+0x370/0x370
[84089.287112]  kthread+0x113/0x130
[84089.287115]  ? kthread_create_worker_on_cpu+0x70/0x70
[84089.287119]  ret_from_fork+0x35/0x40
[84089.287122] ---[ end trace b5975ec96174c615 ]---


> 
> Thanks,
> Qu
> 
>>
>> Thanks,
>> Misono
>>
>>>
>>> Thanks,
>>> Qu
>>>
>>>
>>>>
>>>> [80244.152130] WARNING: CPU: 5 PID: 14575 at fs/btrfs/extent-tree.c:9742 btrfs_free_block_groups+0x2d7/0x440 [btrfs]
>>>> [80244.152132] Modules linked in: btrfs(O) xor zstd_decompress zstd_compress xxhash raid6_pq xt_CHECKSUM ipt_MASQUERADE tun bridge stp llc xt_conntrack ip_set nfnetlink iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_raw iptable_security sunrpc intel_powerclamp kvm_intel kvm gpio_ich iTCO_wdt ipmi_ssif iTCO_vendor_support ipmi_si st irqbypass ipmi_devintf crct10dif_pclmul crc32_pclmul ipmi_msghandler ghash_clmulni_intel pcspkr acpi_power_meter i2c_i801 pcc_cpufreq i7core_edac lpc_ich acpi_cpufreq xfs libcrc32c mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm igb sr_mod hwmon uas ptp crc32c_intel cdrom usb_storage pps_core ata_generic megaraid_sas dca pata_acpi i2c_algo_bit ipv6 [last unloaded: xor]
>>>> [80244.152185] CPU: 5 PID: 14575 Comm: umount Tainted: G        W IO      4.18.0-rc8+ #98
>>>> [80244.152187] Hardware name: FUJITSU-SV                       PRIMERGY RX300 S6             /D2619, BIOS 6.00 Rev. 1.09.2619.N1           12/13/2010
>>>> [80244.152205] RIP: 0010:btrfs_free_block_groups+0x2d7/0x440 [btrfs]
>>>> [80244.152206] Code: 85 20 cb 00 00 48 39 c6 0f 84 b9 00 00 00 49 bf 00 01 00 00 00 00 ad de 48 8b 9d 20 cb 00 00 48 83 7b a0 00 0f 84 0d 01 00 00 <0f> 0b 48 8d 73 88 31 c9 31 d2 48 89 ef e8 27 7a ff ff 48 89 df e8
>>>> [80244.152235] RSP: 0018:ffff8ea10393fdb0 EFLAGS: 00010286
>>>> [80244.152237] RAX: ffff8c1025819e78 RBX: ffff8c1025819e78 RCX: 0000000000000000
>>>> [80244.152238] RDX: 0000000000000001 RSI: ffff8c115329cb20 RDI: ffff8c1025818e00
>>>> [80244.152239] RBP: ffff8c1153290000 R08: 0000000000000000 R09: 0000000000000000
>>>> [80244.152240] R10: ffff8c1025818e98 R11: 0000000000000002 R12: ffff8c11532900a0
>>>> [80244.152241] R13: 0000000000000000 R14: dead000000000200 R15: dead000000000100
>>>> [80244.152243] FS:  00007ff0cc3d8fc0(0000) GS:ffff8c1137d40000(0000) knlGS:0000000000000000
>>>> [80244.152244] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> [80244.152245] CR2: 00007ffe75e53c88 CR3: 0000000235d16001 CR4: 00000000000206e0
>>>> [80244.152246] Call Trace:
>>>> [80244.152270]  close_ctree+0x146/0x320 [btrfs]
>>>> [80244.152276]  ? kthread_stop+0x42/0xf0
>>>> [80244.152280]  generic_shutdown_super+0x6c/0x110
>>>> [80244.152283]  kill_anon_super+0xe/0x20
>>>> [80244.152298]  btrfs_kill_super+0x13/0x100 [btrfs]
>>>> [80244.152301]  deactivate_locked_super+0x3f/0x70
>>>> [80244.152303]  cleanup_mnt+0x3b/0x70
>>>> [80244.152305]  task_work_run+0x84/0xa0
>>>> [80244.152308]  do_syscall_64+0x143/0x4cd
>>>> [80244.152311]  ? do_page_fault+0x31/0x130
>>>> [80244.152314]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>> [80244.152316] RIP: 0033:0x7ff0cb43c1a7
>>>> [80244.152317] Code: ad 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c9 ac 2b 00 f7 d8 64 89 01 48
>>>> [80244.152346] RSP: 002b:00007ffe75e554b8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
>>>> [80244.152348] RAX: 0000000000000000 RBX: 0000563ccced82d0 RCX: 00007ff0cb43c1a7
>>>> [80244.152349] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000563ccced84b0
>>>> [80244.152350] RBP: 0000563ccced84b0 R08: 0000000000000005 R09: 0000563ccced84d0
>>>> [80244.152351] R10: 00007ff0cb4ba320 R11: 0000000000000246 R12: 00007ff0cc1d0184
>>>> [80244.152352] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>>>> [80244.152354] ---[ end trace b5975ec96174c60c ]---
>>>> [80244.152358] BTRFS info (device sdh2): space_info 1 has 1022132224 free, is not full
>>>> [80244.152360] BTRFS info (device sdh2): space_info total=1082130432, used=60039168, pinned=0, reserved=0, may_use=18446744073709510656, readonly=0
>>>>
>>>> Obviously, may_use value is underflowed.
>>>>
>>>> Thanks,
>>>> Misono
>>>>
>>>>
>>>
>>
> 
