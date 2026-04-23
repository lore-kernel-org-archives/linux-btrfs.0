Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F743D567A
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 21:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776980688; cv=none; b=UK+8fmT7uGsb3q/AqZh2lrIrIaFzTqUrYQmlFBerB+bY2i1zl6Z3inIKcx2D0vOVded496M55XxjYm3kn3Kf5IaLlKKP9kIQjGs3vVmntZEKfrm1znV+N8Yseq4J7BOuVZ66H6z0SAxH81k30NKi9V3IH+7b1chTt3a+wEsiD3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776980688; c=relaxed/simple;
	bh=PjN3wm84sKtwrnuDcZgbRPX8dVc7bulDN++AX/t/L/c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pPfUYhOebTvGo2eGt4t4yA9fdFfcbXREUp3GlXm4ZvP1NrnZfGuyXzJGf59awsa8nemQwxWLguSedrVTIqxVTYSuIvOiXu9zKvSdUqlxZFHxrttzMr0CUuy9lb9eqEmehrXPHI4oUIzBU5eL3pT9WsZqVj1ddsYIyD1jFNkSsw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aUrCLZLM; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aUrCLZLM"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488b3f8fa2bso71683935e9.1
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 14:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776980685; x=1777585485; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=xCcF+ATPa+Tvzjsgj5AMdhMLGmqQXXnuvuEB2icsf/4=;
        b=aUrCLZLMURK2dLurxXZ04g53or9jo0f8cFMe40xMRKFdBtWW6DlgAdN/w/8YX42G+E
         r88QTMNyx8yFn1FRJ6+G0Ak6CGipPYjlophvgsE9c65ZrbRDKdCErVzhBCwKRj74uhd3
         SAq8ACjOh3UZTl95sZ13iujL2AeBOra392mRQGblmFK4iTP0P7zF8k08adLRs7m4lMG3
         Em9vwzPWxb5rc+2RWfaU+HgdF4X34ZVSw00d/0xavNRRYaPXGPVFLk1KlEorlXf7IbQX
         moP01ByEYIwiJu5hK2V6POcWr3gDtrNGhTjZ7owXARLWE5pEaHxhoO9hqNcCxVI7H1Db
         IkPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776980685; x=1777585485;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xCcF+ATPa+Tvzjsgj5AMdhMLGmqQXXnuvuEB2icsf/4=;
        b=QNJwu4p3fJ9LdL8yGPjRiyVLigPmmm34UezC+nDh8k6vXDrZ3mFZU0ddIzIybgqWWb
         l6ReU8uBHob8aMDJJsAUpLqWHfy3iOOtEZWaIGEQXMIkNt23HaggYn8dpLmUkUAtnlO2
         zKv5sJQDI0GOQgfuYcagxp4lDnRuFIywd4waWGww0C8+Dn+WKhm6MxVwmi9ibdZkWRdt
         +L7Acqwrbb5Nm1l8+3A5PIJwtRpZWHNnCHrumtG8dHvIv53g95HtzLOAIMOH8v5yNSIB
         6VlUSqFpXrCxx7oiNXylJJSD54X8Hkp9lB+/cfUHuluvsgcdju8zOiJICO8pkWHj2Rj9
         m19Q==
X-Forwarded-Encrypted: i=1; AFNElJ/J8CzcaJ7wrJdmbSa5Y6UrUIo5ZrjamGhyWaJ8KvY6b7Fe+wAzR8MfyBpBpDCVIEWRisN1Z1dBKtjfjQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzKRmonvCEJqFsLDQV3XnCjVgxS2GMPdoLKmH/deIrUtxu5aKHk
	SehIZTxfsfosQT6IGzpJ+zow53LvHsfsOtX0nDJ11/J2YI8o3dWLiMBBz+oXUiJkJ5w=
X-Gm-Gg: AeBDiesgo8LwUaQNB+yf1cjBDddTy8bCiDuZZY9leoUu1tPeDSoFyMOeTcBVaBN9ZJR
	K6mfGog/W0Ugu6yGh3MwYK+XE61XjZXF1PXyhM2HStmJHdf1n5HDyTXH+u0HTX+gIhRE8Zy7niS
	AcuVJKkDFQWvugoHXwDCO/68xwPiQcg+UwX1IBGnj44DoNxokP1KfC/m4ZVEUaHwtIHpW/7Y5Tr
	jyCGNr49ZDt3HwjPYdC3T+OdYSNdgIQ1vEqBoEEpTLomMugZs2p5geD5/fab5y8UsqxmcwSvVQ1
	fWA/H4+vt8sb/NlqXNQ6wHRkMFAy5u4qzr4eWgIAPAZorEO8Gi+SAd7IvUvyuyzwM1DlDjabDbP
	9w39XPfqCtoWEdssBSnLnJ3w5nHOG2+2PIm1z+uU752GlVxCfic/9ScU2+UAItBsRzE1tGjIKuh
	HCDep7rEAdLOxLiORb7Pt0VTCj6jeDaE2HYCHbUogo4vMYkXZ8wM8UuyQzC8KQmw==
X-Received: by 2002:a05:600c:321a:b0:488:fbf6:ea59 with SMTP id 5b1f17b1804b1-488fbf6ed4amr250603925e9.12.1776980684972;
        Thu, 23 Apr 2026 14:44:44 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab288aesm194459075ad.65.2026.04.23.14.44.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 14:44:43 -0700 (PDT)
Message-ID: <a9198462-3ea3-4ca5-97b2-cc9362856173@suse.com>
Date: Fri, 24 Apr 2026 07:14:34 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: add missing unlikely to if branches leading to a
 DEBUG_WARN()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <3eb99befd57ed1a4df3c6d52b426bed2c5b2f1c5.1776944354.git.fdmanana@suse.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <3eb99befd57ed1a4df3c6d52b426bed2c5b2f1c5.1776944354.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/23 21:09, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If statement branches that lead to a DEBUG_WARN() are unexpected to happen
> and in most places we surround their expressions with the unlikely tag,
> however a few places are missing. Add the unlikely tag to those missing
> places to make it explicit to a reader that it's not expected and to allow
> a compiler to generate better code.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/block-group.c     |  2 +-
>   fs/btrfs/disk-io.c         |  2 +-
>   fs/btrfs/extent-tree.c     |  2 +-
>   fs/btrfs/free-space-tree.c |  2 +-
>   fs/btrfs/inode.c           |  2 +-
>   fs/btrfs/qgroup.c          | 16 ++++++++--------
>   fs/btrfs/volumes.c         |  8 ++++----
>   7 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index 015603070143..a0cb0db68c9a 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -4117,7 +4117,7 @@ int btrfs_force_chunk_alloc(struct btrfs_trans_handle *trans, u64 type)
>   	struct btrfs_space_info *space_info;
>   
>   	space_info = btrfs_find_space_info(trans->fs_info, type);
> -	if (!space_info) {
> +	if (unlikely(!space_info)) {
>   		DEBUG_WARN();
>   		return -EINVAL;
>   	}
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index c67faf61ed9a..2020351e715b 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4398,7 +4398,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
>   	ASSERT(list_empty(&fs_info->delayed_iputs));
>   	set_bit(BTRFS_FS_CLOSING_DONE, &fs_info->flags);
>   
> -	if (btrfs_check_quota_leak(fs_info)) {
> +	if (unlikely(btrfs_check_quota_leak(fs_info))) {
>   		DEBUG_WARN("qgroup reserved space leaked");
>   		btrfs_err(fs_info, "qgroup reserved space leaked");
>   	}
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 420d52b097d9..ecc1acb1e340 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6655,7 +6655,7 @@ static int btrfs_trim_free_extents_throttle(struct btrfs_device *device,
>   		start = max(start, cur_start);
>   
>   		/* Check if there are any CHUNK_* bits left */
> -		if (start > device->total_bytes) {
> +		if (unlikely(start > device->total_bytes)) {
>   			DEBUG_WARN();
>   			btrfs_warn(fs_info,
>   "ignoring attempt to trim beyond device size: offset %llu length %llu device %s device size %llu",
> diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
> index 472b3060e5ac..556622625412 100644
> --- a/fs/btrfs/free-space-tree.c
> +++ b/fs/btrfs/free-space-tree.c
> @@ -109,7 +109,7 @@ struct btrfs_free_space_info *btrfs_search_free_space_info(
>   	ret = btrfs_search_slot(trans, root, &key, path, 0, cow);
>   	if (ret < 0)
>   		return ERR_PTR(ret);
> -	if (ret != 0) {
> +	if (unlikely(ret != 0)) {
>   		btrfs_warn(fs_info, "missing free space info for %llu",
>   			   block_group->start);
>   		DEBUG_WARN();
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 059e78ae248f..54ab104195ec 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -806,7 +806,7 @@ static inline int inode_need_compress(struct btrfs_inode *inode, u64 start,
>   {
>   	struct btrfs_fs_info *fs_info = inode->root->fs_info;
>   
> -	if (!btrfs_inode_can_compress(inode)) {
> +	if (unlikely(!btrfs_inode_can_compress(inode))) {
>   		DEBUG_WARN("BTRFS: unexpected compression for ino %llu", btrfs_ino(inode));
>   		return 0;
>   	}
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index cdf736d3a4e5..0511b6dc72b0 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1836,9 +1836,9 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
>   	 * Thus its reserved space should all be zero, no matter if qgroup
>   	 * is consistent or the mode.
>   	 */
> -	if (qgroup->rsv.values[BTRFS_QGROUP_RSV_DATA] ||
> -	    qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PREALLOC] ||
> -	    qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PERTRANS]) {
> +	if (unlikely(qgroup->rsv.values[BTRFS_QGROUP_RSV_DATA] ||
> +		     qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PREALLOC] ||
> +		     qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PERTRANS])) {
>   		DEBUG_WARN();
>   		btrfs_warn_rl(fs_info,
>   "to be deleted qgroup %u/%llu has non-zero numbers, data %llu meta prealloc %llu meta pertrans %llu",
> @@ -1857,8 +1857,8 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
>   	 */
>   	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_FULL &&
>   	    !(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT)) {
> -		if (qgroup->rfer || qgroup->excl ||
> -		    qgroup->rfer_cmpr || qgroup->excl_cmpr) {
> +		if (unlikely(qgroup->rfer || qgroup->excl ||
> +			     qgroup->rfer_cmpr || qgroup->excl_cmpr)) {
>   			DEBUG_WARN();
>   			qgroup_mark_inconsistent(fs_info,
>   				"to be deleted qgroup %u/%llu has non-zero numbers, rfer %llu rfer_cmpr %llu excl %llu excl_cmpr %llu",
> @@ -4800,9 +4800,9 @@ int btrfs_qgroup_add_swapped_blocks(struct btrfs_root *subvol_root,
>   
>   		entry = rb_entry(node, struct btrfs_qgroup_swapped_block, node);
>   
> -		if (entry->subvol_generation != block->subvol_generation ||
> -		    entry->reloc_bytenr != block->reloc_bytenr ||
> -		    entry->reloc_generation != block->reloc_generation) {
> +		if (unlikely(entry->subvol_generation != block->subvol_generation ||
> +			     entry->reloc_bytenr != block->reloc_bytenr ||
> +			     entry->reloc_generation != block->reloc_generation)) {
>   			/*
>   			 * Duplicated but mismatch entry found.  Shouldn't happen.
>   			 * Marking qgroup inconsistent should be enough for end
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 0dd86589ed0f..579c6a116710 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6081,7 +6081,7 @@ struct btrfs_block_group *btrfs_create_chunk(struct btrfs_trans_handle *trans,
>   
>   	lockdep_assert_held(&info->chunk_mutex);
>   
> -	if (!alloc_profile_is_valid(type, 0)) {
> +	if (unlikely(!alloc_profile_is_valid(type, 0))) {
>   		DEBUG_WARN("invalid alloc profile for type %llu", type);
>   		return ERR_PTR(-EINVAL);
>   	}
> @@ -6092,7 +6092,7 @@ struct btrfs_block_group *btrfs_create_chunk(struct btrfs_trans_handle *trans,
>   		return ERR_PTR(-ENOSPC);
>   	}
>   
> -	if (!(type & BTRFS_BLOCK_GROUP_TYPE_MASK)) {
> +	if (unlikely(!(type & BTRFS_BLOCK_GROUP_TYPE_MASK))) {
>   		btrfs_err(info, "invalid chunk type 0x%llx requested", type);
>   		DEBUG_WARN();
>   		return ERR_PTR(-EINVAL);
> @@ -6262,7 +6262,7 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans)
>   
>   	alloc_profile = btrfs_metadata_alloc_profile(fs_info);
>   	meta_space_info = btrfs_find_space_info(fs_info, alloc_profile);
> -	if (!meta_space_info) {
> +	if (unlikely(!meta_space_info)) {
>   		DEBUG_WARN();
>   		return -EINVAL;
>   	}
> @@ -6272,7 +6272,7 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans)
>   
>   	alloc_profile = btrfs_system_alloc_profile(fs_info);
>   	sys_space_info = btrfs_find_space_info(fs_info, alloc_profile);
> -	if (!sys_space_info) {
> +	if (unlikely(!sys_space_info)) {
>   		DEBUG_WARN();
>   		return -EINVAL;
>   	}

