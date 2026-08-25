Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6064457BA
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 12:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787661525; cv=none; b=m+tSaK/IQJWEF3kJpTpbStaTDeOjYDxV4Bhk5DrFcrFUGdHyBFuAP08Y0Y3vVjFJJL1nm5bCKxWKaHVT8/hYftOfnlPQjyQWQIwd/HPl7sK5J5hm0mU5kVLJKLKVmE3wyCq4hTA8Ox9F3bTwyDuK4JyGXQLSiP0//0BrpXaR/gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787661525; c=relaxed/simple;
	bh=e5VfQCwq9GBCjqpDP1UD7kqptylIcvfTkBZeXkmrPcE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gSbQCNVZp5Vaitg2OZvAquZbys9+T/3C+ipWCSmc+66Y3FyegUeTjqabQMMspKJBKMmgpbit7q4J05C1SBlZ1yW+oAc0ao7cVfYcKzhZbOd/EZsmQ8xFBlUJAViq++AOzo6KPhS4tUM7aK8bx09us4vV59iKdv5JiZYaWWSDclg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rVU/Nd0l; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rVU/Nd0l"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67PB1kqd709452;
	Tue, 25 Aug 2026 12:38:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ibvJ+L
	zbaMssY6z45HeZACqpvfiKOw36/o/hFfO+o8c=; b=rVU/Nd0lBt1VHrq5xsCWLj
	HwtVJ86PzdLejxPqivDlkIPAy9pfoxuIiBdX9U6p2q61vT0lwyTmZWg1Ui/N+UOv
	3WfS46PELvR1IWD/sII+PBYV4H07bm57FPHe6z9Sp+6t6uBdkEOY/B7SvUuIUaSm
	TRli8axr9aestT5bxoYVDEyQFqS4gMMAe0OkPzMNrL5549R5XaC4DhQ249r40iEy
	kS5Mo2qZLnepSmndfkfuXMuQPp6l8VT7YRJ1EnpysAGYlVEPV0WUK6WWj6sbWuhl
	/p4bplJTH00pS3rYxKeeYiT11JS7a6Va1IvwkYUiAzSjmX35+Hw9YeyyX30kTPYA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g73dx7vkp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Aug 2026 12:38:37 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67PCQNeV006864;
	Tue, 25 Aug 2026 12:38:36 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g7ragc2rf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Aug 2026 12:38:36 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67PCcZm346334390
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Aug 2026 12:38:35 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 006822004B;
	Tue, 25 Aug 2026 12:38:35 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 357ED20040;
	Tue, 25 Aug 2026 12:38:34 +0000 (GMT)
Received: from [9.124.215.149] (unknown [9.124.215.149])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 25 Aug 2026 12:38:33 +0000 (GMT)
Message-ID: <83cb7730-834b-401b-b4ad-182fe781295d@linux.ibm.com>
Date: Tue, 25 Aug 2026 18:08:32 +0530
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: do not force reloc root creation during
 qgroup_account_snapshot()
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <df20ed0596f010eebfd9ad33b8bb979e6304dbfb.1787216325.git.wqu@suse.com>
Content-Language: en-GB
From: Disha Goel <disgoel@linux.ibm.com>
In-Reply-To: <df20ed0596f010eebfd9ad33b8bb979e6304dbfb.1787216325.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI1MDEwNiBTYWx0ZWRfX9I/VyXYMZnhO
 F1Pj3eVhvBk2XKAw/fe0N+EOvu0tlfxqIiifvXQg478eGjtARexOKkdxIDcXFg+9ZSytVS7xFja
 cNMv8oR7JmuHu0KlZhxHQYP6os2zIFA=
X-Authority-Analysis: v=2.4 cv=AYuB2XXG c=1 sm=1 tr=0 ts=6a8d8ccd cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=sWKEhP36mHoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22
 a=iox4zFpeAAAA:8 a=VnNF1IyMAAAA:8 a=qtymSKf-mkg5aJxh0iwA:9 a=QEXdDO2ut3YA:10
 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-ORIG-GUID: LKxuNKuPsdbI67TgbN_9BOMXsq8OwslS
X-Proofpoint-GUID: LKxuNKuPsdbI67TgbN_9BOMXsq8OwslS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI1MDEwNiBTYWx0ZWRfX9p8Mw1hQfTpK
 KrDdx8Z6wloUpB4qK7itJeKIVnXl0GYkgPCn0ZDlbCKVIYUxy9C1fV3ak2eMtsngRPJZz2deusB
 2v//xuMnLmiQdFgwpjUXRAxtvlQu7rJpvF1aYGO9aK/vU0JOSynrzg4CZSf/h+p1avfQztVchDD
 FAX2OjFYre1jbF7/ZuUHTChtTXZZwgTi+86clobXgKhJpbscXmmtuOnICDUIzoE/RnxIr0vdWds
 XQ6ozp+pOItkzuFsd0BrMji8ynfojJ2bcIFwJA9/+gUgZW/foYxbhLKfg2f/lF3btDiQb/a4a7O
 SaYdI0dxrvJBzh6ewwhWm7cr0W661IC1glnH2vn+66nTXPOZcu4kqbjDfrolMHpliGpxkGH0i/N
 AAf0prQUTm8yIvi0aWthwHive17WTHzH1NQFO0FgeyB826w6AHDvwtmS4PITnzY54HBhfb9robU
 aY3BIo+of4Hz9WKYOsg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-25_03,2026-08-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 clxscore=1011 adultscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608250106

On 20/08/26 2:28 pm, Qu Wenruo wrote:
> [BUG]
> When running btrfs/252 with quota enabled through MKFS_OPTIONS="-O
> quota", it has a high chance to trigger the following kernel warning and
> flips the fs RO:
> 
>   BTRFS info (device dm-2): relocating block group 30408704 flags metadata|dup
>   ------------[ cut here ]------------
>   WARNING: fs/btrfs/extent-tree.c:879 at lookup_inline_extent_backref+0x74b/0x960 [btrfs], CPU#4: btrfs/2173
>   CPU: 4 UID: 0 PID: 2173 Comm: btrfs Not tainted 7.2.0-rc6-custom+ #457 PREEMPT(full)  3adc6528fb66f7a55fe1095385818e742f200aab
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
>   RIP: 0010:lookup_inline_extent_backref+0x74b/0x960 [btrfs]
>   Call Trace:
>    <TASK>
>    insert_inline_extent_backref+0x7c/0x160 [btrfs 32f09462c54d9c922fca74a3e4866f4aa7737b72]
>    __btrfs_inc_extent_ref+0xa9/0x270 [btrfs 32f09462c54d9c922fca74a3e4866f4aa7737b72]
>    __btrfs_run_delayed_refs+0x4af/0x11c0 [btrfs 32f09462c54d9c922fca74a3e4866f4aa7737b72]
>    btrfs_run_delayed_refs+0x9d/0xf0 [btrfs 32f09462c54d9c922fca74a3e4866f4aa7737b72]
>    create_pending_snapshot+0x39d/0xf00 [btrfs 32f09462c54d9c922fca74a3e4866f4aa7737b72]
>    create_pending_snapshots+0x9b/0xc0 [btrfs 32f09462c54d9c922fca74a3e4866f4aa7737b72]
>    btrfs_commit_transaction+0x280/0xeb0 [btrfs 32f09462c54d9c922fca74a3e4866f4aa7737b72]
>    prepare_to_relocate+0x147/0x200 [btrfs 32f09462c54d9c922fca74a3e4866f4aa7737b72]
>    relocate_block_group+0x6b/0x5e0 [btrfs 32f09462c54d9c922fca74a3e4866f4aa7737b72]
>    btrfs_relocate_block_group+0x92c/0x2380 [btrfs 32f09462c54d9c922fca74a3e4866f4aa7737b72]
>    btrfs_relocate_chunk+0x3f/0x1a0 [btrfs 32f09462c54d9c922fca74a3e4866f4aa7737b72]
>    btrfs_balance+0xa2c/0x19c0 [btrfs 32f09462c54d9c922fca74a3e4866f4aa7737b72]
>    btrfs_ioctl+0x2839/0x2d30 [btrfs 32f09462c54d9c922fca74a3e4866f4aa7737b72]
>    __x64_sys_ioctl+0x416/0x9a0
>    do_syscall_64+0xe1/0x790
>    entry_SYSCALL_64_after_hwframe+0x4b/0x53
>    </TASK>
>   ---[ end trace 0000000000000000 ]---
>   BTRFS info (device dm-2): leaf 4593991680 gen 233 total ptrs 175 free space 5953 owner 2
>   BTRFS info (device dm-2): refs 3 lock_owner 2173 current 2173
>   	item 0 key (166772736 METADATA_ITEM 1) itemoff 16250 itemsize 33
>   		extent refs 1 gen 222 flags 2
>   		ref#0: tree block backref root 266
> 	[ Skip the tree dump ]
>   	item 174 key (263225344 METADATA_ITEM 0) itemoff 10328 itemsize 33
>   		extent refs 1 gen 162 flags 258
>   		ref#0: tree block backref root 267
>   BTRFS error (device dm-2): extent item not found for insert, bytenr 179847168 num_bytes 16384 parent 4594335744 root_objectid 273 owner 0 offset 0
>   BTRFS error (device dm-2): failed to run delayed ref for logical 179847168 num_bytes 16384 type 182 action 1 ref_mod 1: -117
> 
> [CAUSE]
> The above error is showing that there is a tree reference to an metadata
> extent that is no longer there.
> 
> With "ref_verify" mount option (requires CONFIG_BTRFS_DEBUG), there is
> some extra debug output:
> 
>   BTRFS error (device dm-2): dumping block entry [180961280 16384], num_refs 0, metadata 1, from disk 0
>   BTRFS error (device dm-2):   root entry 256, num_refs 18446744073709551615
>   BTRFS error (device dm-2):   root entry 273, num_refs 18446744073709551615
>   BTRFS error (device dm-2):   Ref action 3, root 273, ref_root 273, parent 0, owner 0, offset 0, num_refs 1
>      btrfs_force_cow_block+0x129/0x7d0 [btrfs]
>      btrfs_cow_block+0x10a/0x250 [btrfs]
>      btrfs_search_slot+0x5eb/0xf40 [btrfs]
>      btrfs_insert_empty_items+0x3a/0x70 [btrfs]
>      insert_with_overflow+0x53/0x130 [btrfs]
>      btrfs_insert_dir_item+0x125/0x290 [btrfs]
>      btrfs_add_link+0xaa/0x410 [btrfs]
>      btrfs_rename+0x5ea/0xcd0 [btrfs]
>      btrfs_rename2+0x28/0x60 [btrfs]
>      vfs_rename+0x5b2/0xe10
>      filename_renameat2+0x244/0x430
>      __x64_sys_rename+0x48/0x70
>      do_syscall_64+0xe1/0x790
>      entry_SYSCALL_64_after_hwframe+0x4b/0x53
>   BTRFS error (device dm-2):   Ref action 2, root 273, ref_root 273, parent 0, owner 0, offset 0, num_refs 18446744073709551615
>      btrfs_force_cow_block+0x327/0x7d0 [btrfs]
>      btrfs_cow_block+0x10a/0x250 [btrfs]
>      btrfs_search_slot+0x5eb/0xf40 [btrfs]
>      btrfs_lookup_file_extent+0x4d/0x70 [btrfs]
>      btrfs_drop_extents+0x151/0xf00 [btrfs]
>      insert_reserved_file_extent+0xfe/0x3e0 [btrfs]
>      btrfs_finish_one_ordered+0x549/0xc40 [btrfs]
>      btrfs_work_helper+0xde/0x350 [btrfs]
>      process_one_work+0x198/0x380
>      worker_thread+0x1c8/0x330
>      kthread+0xee/0x120
>      ret_from_fork+0x28f/0x310
>      ret_from_fork_asm+0x11/0x20
>   BTRFS error (device dm-2):   Ref action 1, root 273, ref_root 0, parent 4594335744, owner 0, offset 0, num_refs 1
>      __btrfs_mod_ref+0x1c5/0x2d0 [btrfs]
>      btrfs_copy_root+0x262/0x390 [btrfs]
>      create_reloc_root+0xb9/0x370 [btrfs]
>      btrfs_init_reloc_root+0xb0/0x1b0 [btrfs]
>      record_root_in_trans+0xa6/0xd0 [btrfs]
>      create_pending_snapshot+0x383/0xf00 [btrfs]
>      create_pending_snapshots+0x9b/0xc0 [btrfs]
>      btrfs_commit_transaction+0x280/0xeb0 [btrfs]
>      prepare_to_relocate+0x147/0x200 [btrfs]
>      relocate_block_group+0x6b/0x5e0 [btrfs]
>      btrfs_relocate_block_group+0x92c/0x2380 [btrfs]
>      btrfs_relocate_chunk+0x3f/0x1a0 [btrfs]
>      btrfs_balance+0xa2c/0x19c0 [btrfs]
>      btrfs_ioctl+0x2839/0x2d30 [btrfs]
>      __x64_sys_ioctl+0x416/0x9a0
>      do_syscall_64+0xe1/0x790
> 
> The above shows the direct cause, Ref action 3 is the oldest operation,
> which shows the tree block is created by COW.
> Then ref action 2 shows it's COWed away, by a metadata update, meaning
> the tree block is already released, should not be referred any more.
> 
> Then the final one, is trying to create a reloc tree for subvolume 273,
> and that reloc root creation is referring to the already dropped tree
> block.
> 
> The root cause is that, during qgroup_account_snapshot(), we are calling
> record_root_in_trans() with "force = true".
> So if the root has no reloc root, we will create one, but at that
> timing it's already too late.
> 
> Normally reloc root should be created before the commit and
> current roots diverge, to avoid the same problem we are hitting.
> 
> But during relocation initialization, we are committing the current
> running transaction, with a new reloc_control attached halfway.
> 
> And if qgroup is enabled, the record_root_in_trans() with "force = true"
> calls will force reloc root creation even if we do not and should not
> create reloc root at that timing.
> 
> [FIX]
> Do not force reloc root creation during record_root_in_trans() with
> "force = true" cases, which is only called by qgroup_account_snapshot().
> 
> If we're really under relocation, the reloc root should be created way
> early, before the commit and current root diverge.
> If the root has no reloc tree yet, it means we're still initializing the
> reloc, and do not need a reloc root.
> 
> So skipping the reloc tree creation in qgroup_account_snapshot() should
> be safe.
> 
> Link: https://bugzilla.suse.com/show_bug.cgi?id=1275740
> Assisted-by: LLM (initial analyze, but incorrect conclusion with too many burnt tokens)
> Fixes: 4d31778aa2fa ("btrfs: qgroup: Fix root item corruption when multiple same source snapshots are created with quota enabled")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---

Tested on ppc64le, btrfs/252 with -O quota no longer triggers extent
tree corruption after applying this patch.

Feel free to add
Tested-by: Disha Goel <disgoel@linux.ibm.com>

>   fs/btrfs/transaction.c | 13 ++++++++++++-
>   1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 13a7e5f4e08c..59e246467272 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -458,8 +458,19 @@ static int record_root_in_trans(struct btrfs_trans_handle *trans,
>   		 * through btrfs_record_root_in_trans without having to take the
>   		 * lock.  smp_wmb() makes sure that all the writes above are
>   		 * done before we pop in the zero below
> +		 *
> +		 * If @force is true, it means the call is from
> +		 * qgroup_account_snapshot(), which only requires radix tree
> +		 * tracking.
> +		 * We should not force reloc root creation here, as the root
> +		 * may have already been modified, and in that case
> +		 * root->commit_root has already been dropped.
> +		 *
> +		 * Using that commit root will cause the reloc root to refer
> +		 * to a deleted extent, causing extent tree corruption.
>   		 */
> -		ret = btrfs_init_reloc_root(trans, root);
> +		if (!force)
> +			ret = btrfs_init_reloc_root(trans, root);
>   		smp_mb__before_atomic();
>   		clear_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state);
>   	}

-- 
Regards,
Disha

