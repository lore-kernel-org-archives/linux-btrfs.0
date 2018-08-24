Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:50904 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbeHXL2o (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Aug 2018 07:28:44 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id F26A0AC015F
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Aug 2018 16:55:12 +0900 (JST)
Subject: Re: [PATCH v2] btrfs: Always check nocow for quota enabled case to
 make sure we won't reserve unnecessary data space
To: Qu Wenruo <wqu@suse.de>, <linux-btrfs@vger.kernel.org>
References: <20180821054016.28058-1-wqu@suse.com>
 <afee4b2f-ee0b-8afb-b4d6-1fd8f5958e3a@jp.fujitsu.com>
 <662fd511-708f-5784-18f8-1282830d5730@suse.de>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <99167e75-351e-ac1d-1a13-97e7717b4a8a@jp.fujitsu.com>
Date: Fri, 24 Aug 2018 16:54:43 +0900
MIME-Version: 1.0
In-Reply-To: <662fd511-708f-5784-18f8-1282830d5730@suse.de>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/08/24 16:20, Qu Wenruo wrote:
> 
> 
> On 2018/8/24 下午3:14, Misono Tomohiro wrote:
>> Hi,
>>
>> On 2018/08/21 14:40, Qu Wenruo wrote:
>>> Commit c6887cd11149 ("Btrfs: don't do nocow check unless we have to")
>>> makes nocow check less frequent to improve performance.
>>>
>>> However for quota enabled case, such optimization could lead to extra
>>> unnecessary data reservation, which results failure for test case like
>>> btrfs/153 in fstests.
>>>
>>> Fix it by reverting to old behavior for quota enabled case.
>>>
>>> Fixes: c6887cd11149 ("Btrfs: don't do nocow check unless we have to")
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>> changelog
>>> v2:
>>>   Fix regression for quota+cow case. (Previously it will skip data
>>>   reservation if quota is enabled, causing regression for limit case.
>>>   Pointed out by Misono)
>>> ---
>>>  fs/btrfs/file.c | 18 +++++++++++++++++-
>>>  1 file changed, 17 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>>> index 2be00e873e92..183e5fb96f42 100644
>>> --- a/fs/btrfs/file.c
>>> +++ b/fs/btrfs/file.c
>>> @@ -1584,6 +1584,7 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
>>>  	int ret = 0;
>>>  	bool only_release_metadata = false;
>>>  	bool force_page_uptodate = false;
>>> +	bool quota_enabled = test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
>>>  
>>>  	nrptrs = min(DIV_ROUND_UP(iov_iter_count(i), PAGE_SIZE),
>>>  			PAGE_SIZE / (sizeof(struct page *)));
>>> @@ -1624,13 +1625,28 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
>>>  				fs_info->sectorsize);
>>>  
>>>  		extent_changeset_release(data_reserved);
>>> +
>>> +		/*
>>> +		 * If we have quota enabled, we must do the heavy lift nocow
>>> +		 * check here to avoid reserving data space, or we can hit
>>> +		 * limitation for NOCOW files.
>>> +		 */
>>> +		if (quota_enabled) {
>>> +			if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
>>> +						      BTRFS_INODE_PREALLOC)) &&
>>> +			    check_can_nocow(BTRFS_I(inode), pos,
>>> +					    &write_bytes) > 0)
>>> +				goto reserve_meta_only;
>>> +		}
>>>  		ret = btrfs_check_data_free_space(inode, &data_reserved, pos,
>>>  						  write_bytes);
>>>  		if (ret < 0) {
>>>  			if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
>>>  						      BTRFS_INODE_PREALLOC)) &&
>>>  			    check_can_nocow(BTRFS_I(inode), pos,
>>> -					&write_bytes) > 0) {
>>> +					&write_bytes) > 0 &&
>>
>>> +			    !quota_enabled) {
>>
>> (When we check this condition, quota_enabled must be false or otherwise
>> we have already goto reserve_meta_only. So it seems redundant.)
> 
> It's possible that we have quota enabled, and then
> btrfs_check_data_free_space() failed with -EDQUOT.
> 
> In that case, we need above !quota_enabled check to avoid unnecessary
> check and just go error branch.

So should quota_enabled be checked before check_can_nocow()?

> 
>>
>>> +reserve_meta_only:
>>>  				/*
>>>  				 * For nodata cow case, no need to reserve
>>>  				 * data space.
>>>
>>
>> I applied this patch on today's misc-next and it seems mostly ok, but
>> btrfs/022 sometimes gives following warning:
> 
> This looks like related to the regression caused by commit
> c4c129db5da8f070147f175 ("btrfs: drop unused
> parameter qgroup_reserved").
> 
> Would you please try reverting that patch?

I think above commit is fixed by commit eb27db470 ("btrfs: fix
qgroup_free wrong num_bytes in btrfs_subvolume_reserve_metadata") which
is already in misc-next too.

I reverted above two patch (and one more related patch 6b0cb14901
("btrfs: drop useless member qgroup_reserved of btrfs_pending_snapshot")),
but get the same result.

Thanks,
Misono

> 
> Thanks,
> Qu
> 
> 
>>
>> [80244.152130] WARNING: CPU: 5 PID: 14575 at fs/btrfs/extent-tree.c:9742 btrfs_free_block_groups+0x2d7/0x440 [btrfs]
>> [80244.152132] Modules linked in: btrfs(O) xor zstd_decompress zstd_compress xxhash raid6_pq xt_CHECKSUM ipt_MASQUERADE tun bridge stp llc xt_conntrack ip_set nfnetlink iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_raw iptable_security sunrpc intel_powerclamp kvm_intel kvm gpio_ich iTCO_wdt ipmi_ssif iTCO_vendor_support ipmi_si st irqbypass ipmi_devintf crct10dif_pclmul crc32_pclmul ipmi_msghandler ghash_clmulni_intel pcspkr acpi_power_meter i2c_i801 pcc_cpufreq i7core_edac lpc_ich acpi_cpufreq xfs libcrc32c mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm igb sr_mod hwmon uas ptp crc32c_intel cdrom usb_storage pps_core ata_generic megaraid_sas dca pata_acpi i2c_algo_bit ipv6 [last unloaded: xor]
>> [80244.152185] CPU: 5 PID: 14575 Comm: umount Tainted: G        W IO      4.18.0-rc8+ #98
>> [80244.152187] Hardware name: FUJITSU-SV                       PRIMERGY RX300 S6             /D2619, BIOS 6.00 Rev. 1.09.2619.N1           12/13/2010
>> [80244.152205] RIP: 0010:btrfs_free_block_groups+0x2d7/0x440 [btrfs]
>> [80244.152206] Code: 85 20 cb 00 00 48 39 c6 0f 84 b9 00 00 00 49 bf 00 01 00 00 00 00 ad de 48 8b 9d 20 cb 00 00 48 83 7b a0 00 0f 84 0d 01 00 00 <0f> 0b 48 8d 73 88 31 c9 31 d2 48 89 ef e8 27 7a ff ff 48 89 df e8
>> [80244.152235] RSP: 0018:ffff8ea10393fdb0 EFLAGS: 00010286
>> [80244.152237] RAX: ffff8c1025819e78 RBX: ffff8c1025819e78 RCX: 0000000000000000
>> [80244.152238] RDX: 0000000000000001 RSI: ffff8c115329cb20 RDI: ffff8c1025818e00
>> [80244.152239] RBP: ffff8c1153290000 R08: 0000000000000000 R09: 0000000000000000
>> [80244.152240] R10: ffff8c1025818e98 R11: 0000000000000002 R12: ffff8c11532900a0
>> [80244.152241] R13: 0000000000000000 R14: dead000000000200 R15: dead000000000100
>> [80244.152243] FS:  00007ff0cc3d8fc0(0000) GS:ffff8c1137d40000(0000) knlGS:0000000000000000
>> [80244.152244] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [80244.152245] CR2: 00007ffe75e53c88 CR3: 0000000235d16001 CR4: 00000000000206e0
>> [80244.152246] Call Trace:
>> [80244.152270]  close_ctree+0x146/0x320 [btrfs]
>> [80244.152276]  ? kthread_stop+0x42/0xf0
>> [80244.152280]  generic_shutdown_super+0x6c/0x110
>> [80244.152283]  kill_anon_super+0xe/0x20
>> [80244.152298]  btrfs_kill_super+0x13/0x100 [btrfs]
>> [80244.152301]  deactivate_locked_super+0x3f/0x70
>> [80244.152303]  cleanup_mnt+0x3b/0x70
>> [80244.152305]  task_work_run+0x84/0xa0
>> [80244.152308]  do_syscall_64+0x143/0x4cd
>> [80244.152311]  ? do_page_fault+0x31/0x130
>> [80244.152314]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> [80244.152316] RIP: 0033:0x7ff0cb43c1a7
>> [80244.152317] Code: ad 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c9 ac 2b 00 f7 d8 64 89 01 48
>> [80244.152346] RSP: 002b:00007ffe75e554b8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
>> [80244.152348] RAX: 0000000000000000 RBX: 0000563ccced82d0 RCX: 00007ff0cb43c1a7
>> [80244.152349] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000563ccced84b0
>> [80244.152350] RBP: 0000563ccced84b0 R08: 0000000000000005 R09: 0000563ccced84d0
>> [80244.152351] R10: 00007ff0cb4ba320 R11: 0000000000000246 R12: 00007ff0cc1d0184
>> [80244.152352] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>> [80244.152354] ---[ end trace b5975ec96174c60c ]---
>> [80244.152358] BTRFS info (device sdh2): space_info 1 has 1022132224 free, is not full
>> [80244.152360] BTRFS info (device sdh2): space_info total=1082130432, used=60039168, pinned=0, reserved=0, may_use=18446744073709510656, readonly=0
>>
>> Obviously, may_use value is underflowed.
>>
>> Thanks,
>> Misono
>>
>>
> 
