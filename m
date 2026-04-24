Received: from mail-pj1-f65.google.com (mail-pj1-f65.google.com [209.85.216.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5248030AACD
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 03:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777000553; cv=none; b=idRQegFUXNBG6MFUWtaqDWmb9kEAn67zSWu/Qj64IG+NOXchIgCgJMO9T6Dnwd8GxpSjwUknTMc/k/7Rd+JwQKNJEOCr92YIOWm9MQQX9ateUzYXOPw3DCoqR9nhmPzYBf86Xnn97KVSigtqZtvsMXPf9cFNCXkGJAo8X/zdCAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777000553; c=relaxed/simple;
	bh=mPVKdKpz9BO/gCiRdRt0H00tlRRMG7TxH+GCqKY/8bY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZtgYFDvqufQqENrxv0bpncHdpGW1ZjkbcI0FeWzVQ85YHOhLef4L9KADpqv8WjC849+/JhLS9LA3pGcRhxvsDm7eJGFbP9ZQT1do2hKQlYaXrXyHYzphbCJ+Llpi7u9cCrem+BojedEqoTP1cGquGW+NmZ9TrpasbwLfOphhMZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=STm7imL1; arc=none smtp.client-ip=209.85.216.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="STm7imL1"
Received: by mail-pj1-f65.google.com with SMTP id 98e67ed59e1d1-3597822d6d8so1184796a91.3
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 20:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777000552; x=1777605352; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JtcfylJwVG7Dbdzmf3H+BUTszD3cZ07rl1Uyc26BUio=;
        b=STm7imL12lu9wLjOyubjfc7Ng4nymY8Nl3tjgM9unMk2XkwLMTprRgOjh0vf9r+sJD
         JJ2b+kbSzbmIr+hu+GOUJsFUcJKA+1GATjyyNwwjOhr/+M9eqH498nOCf6mnmTaoQnal
         ebhAUzrTyL2hrWCoSU5FKRO405rOtOLNHStx4BFUglnYmxCzvbpOqUEs6lA0nYMX8hOA
         qdVqr29DTfr6Jwj6KO7XYtVTXPkUvAu8VKp0UUPKGJ+glBFYxkuRCHcN0gDyUjvnVEG6
         TOruIk0juEFSNGloSUN4T03xoOEThpJv52/lDXfU5IDp4GBaK62npK1L6e3eR49eq2gC
         86QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777000552; x=1777605352;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JtcfylJwVG7Dbdzmf3H+BUTszD3cZ07rl1Uyc26BUio=;
        b=YIvdNdwshX9Byl9sF12eSGhGgMr5xRl7At9WpIbZSATlDsSWuzSq/0ufHt3u79R7yH
         BTGNM/WhcSekX4DyyP8qdesouDw3G1F5wL8MgIYUKRFMi7VYTtYBupii1+kVX8tJjxHe
         u/pyS0RykICEoPPoxoSm0jlQy0OZFA+atNZTBdDLJRYXnuyR+zQqCn/VsM7PrE5EOdRB
         QPmhR5FMVAEa9X6vvvj9BPHGBRUvERrDdHD1mRUYbwIujpFMyEVuUiWf6Br0addi2dSS
         GWmknkAkil5FzSSFXWtfqYD3ry9EZkLj87mRsbjVTpz+gCDmFM7ChG5B+Hln4NXDZ+L9
         lhwQ==
X-Forwarded-Encrypted: i=1; AFNElJ9tTC6eX40xXtS+uZdaZtjiwiyHS8pKgmSj5wLKE+3tHaUin5KT80blK0btxIwh3KzYQz3swyHDYJG3Cw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyb3LnpE0S0e7wlegdTjL2xd6yg2r7vHjOkAAwUbktRCIkIaPsS
	DKLEpwj8SJkWv0NdkrdFs9SWNUhq0ngYcIKtDKZJhVIS5EbkKtNohvVl
X-Gm-Gg: AeBDievuBa/JTbvXeiRUwMwJE9s1aBwSpfWO1tuSNdoVCocWp5NgUrS0f22RZtZkeeP
	T2x9SGgHos+gqXgzT7PDkZMRt6tr/6maxhJC4C8n1HGwLPHJs4sQW11dmNV2Fkvbvx6PXNL1uzV
	HzRGq1dW3AbaTKmpOQ88RKLEJKVKwGcDWOxTdDtIEZinmYck/0tifUQ/Qw0pGFT+KoBjpcRKSCA
	ziJJqJatYMIiMrsnEYX/bZQl6Ek+h88Sv19ofLRYDexFkRfmM3qOd1wGhlAFkBa8R5miONGij8y
	SvE/5FWH7xjSZKBAhfXDXnkGXRiXAmS0h6A9+QwwT9L0fIaFcw0vGp2EpOXRJDVSohgC3wpDkUQ
	pFOzne8P/47sWh+Dn8XLv1BcTxhz3MyrFGf+RBVAHfLRopIFMApooQ6a9DflPq3GGBHg8LJULIr
	QcE43EzSctim+WfIlEHlgKVzrPMLLvKC8vWcrPBf808Ewi39jZMV0jaiPMZNgOw9JAT/J4CoZBy
	TrgKCTxk+gR2/NW
X-Received: by 2002:a17:90b:4c8c:b0:35d:9d38:5363 with SMTP id 98e67ed59e1d1-36140465c9amr18629455a91.5.1777000551658;
        Thu, 23 Apr 2026 20:15:51 -0700 (PDT)
Received: from ?IPV6:2408:8239:502:5512:180c:86b4:d220:939b? ([151.241.129.36])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c797702fbfcsm16620534a12.22.2026.04.23.20.15.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 20:15:51 -0700 (PDT)
Message-ID: <2c18476d-e75c-4451-8912-b8c783852923@gmail.com>
Date: Fri, 24 Apr 2026 11:15:48 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] btrfs: don't finalize fs roots during qgroup snapshot
 accounting
To: Leo Martins <loemra.dev@gmail.com>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
References: <cover.1776899536.git.loemra.dev@gmail.com>
 <3d60d1354b7f564568532085656a1989d4faa171.1776899536.git.loemra.dev@gmail.com>
Content-Language: en-US
From: Sun YangKai <sunk67188@gmail.com>
In-Reply-To: <3d60d1354b7f564568532085656a1989d4faa171.1776899536.git.loemra.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Thank you for your work on this — much appreciated.

I am not very familiar with this part of the codebase, so please take my 
comments with that in mind.

That said, I have a few minor inline suggestions regarding some of the 
implementation details. Nothing major — just small things I noticed 
while reading through. Hope they help. Please see below.

On 2026/4/24 06:43, Leo Martins wrote:
> qgroup_account_snapshot() calls commit_fs_roots() to persist root
> items for consistent qgroup accounting. However, commit_fs_roots()
> is a transaction finalization function that also clears
> BTRFS_ROOT_FORCE_COW, frees log trees, clears BTRFS_ROOT_TRANS_TAG,
> and frees qgroup metadata reservations. These are all premature
> since the transaction is still in progress and create_pending_snapshot()
> will modify the source root's tree afterward.
> 
> Currently this is harmless because should_cow_block() always COWs
> WRITTEN extent buffers regardless of FORCE_COW state. But clearing
> FORCE_COW mid-transaction leaves roots in an incorrect state:
> blocks may be shared with a snapshot (via btrfs_copy_root) while
> FORCE_COW no longer reflects that. Any future optimization that
> relies on FORCE_COW to decide whether COW can be skipped would
> silently corrupt snapshots.
> 
> Extract prepare_root_item() as a helper that updates a root's
> root_item and writes it to the tree root. This is the only part of
> commit_fs_roots() that qgroup accounting needs. Add
> qgroup_commit_fs_roots() which iterates dirty roots calling only
> prepare_root_item(), without finalization side effects. It iterates
> using an advancing index instead of clearing tags, so roots remain
> tagged for the real commit_fs_roots() call later, eliminating the
> record_root_in_trans() re-tagging that was previously needed.
> 
> Signed-off-by: Leo Martins <loemra.dev@gmail.com>
> ---
>   fs/btrfs/transaction.c | 105 +++++++++++++++++++++++++++++------------
>   1 file changed, 75 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 55791bb100a22..5b362f2680200 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1477,8 +1477,66 @@ void btrfs_add_dead_root(struct btrfs_root *root)
>   }
>   
>   /*
> - * Update each subvolume root and its relocation root, if it exists, in the tree
> - * of tree roots. Also free log roots if they exist.
> + * Update the root_item for @root to point at the current root->node
> + * and write it to the tree root.
> + */
> +static int prepare_root_item(struct btrfs_trans_handle *trans,
> +			   struct btrfs_root *root)
> +{
> +	if (root->commit_root != root->node) {
> +		list_add_tail(&root->dirty_list,
> +			      &trans->transaction->switch_commits);
> +		btrfs_set_root_node(&root->root_item, root->node);
> +	}
> +
> +	return btrfs_update_root(trans, trans->fs_info->tree_root,
> +				 &root->root_key, &root->root_item);
> +}
> +
> +/*
> + * Update root items for all dirty fs roots without the finalization
> + * side effects of commit_fs_roots() (clearing FORCE_COW, freeing
> + * logs, clearing trans tags, etc.). Tags are preserved so
> + * commit_fs_roots() can still find these roots later.
> + */
> +static int qgroup_commit_fs_roots(struct btrfs_trans_handle *trans)
> +{
> +	struct btrfs_fs_info *fs_info = trans->fs_info;
> +	struct btrfs_root *gang[8];
> +	unsigned long index = 0;
> +	int i;
> +	int ret;

I wonder if it would be better to use unsigned int for ret since it only 
set by radix_tree_gang_lookup_tag which returns unsigned int.

And I wonder if ret is a good name since we never return ret.

> +
> +	spin_lock(&fs_info->fs_roots_radix_lock);
> +	while (1) {
> +		ret = radix_tree_gang_lookup_tag(&fs_info->fs_roots_radix,
> +						 (void **)gang, index,
> +						 ARRAY_SIZE(gang),
> +						 BTRFS_ROOT_TRANS_TAG);
> +		if (ret == 0)
> +			break;

I assume `ret > ARRAAY_SIZE(gang)` should never happen here so maybe we 
could have `index=btrfs_root_id(gang[ret-1]) + 1;` here.

> +		for (i = 0; i < ret; i++) {
> +			struct btrfs_root *root = gang[i];
> +			int ret2;
> +
> +			index = btrfs_root_id(root) + 1;

index seems not used inside this for loop, so maybe we can update it 
outside the loop to make it looks better.

Thanks again for the patch.
Regards,
Sun YangKai

> +			spin_unlock(&fs_info->fs_roots_radix_lock);
> +
> +			ret2 = prepare_root_item(trans, root);
> +			if (unlikely(ret2))
> +				return ret2;
> +
> +			spin_lock(&fs_info->fs_roots_radix_lock);
> +		}
> +	}
> +	spin_unlock(&fs_info->fs_roots_radix_lock);
> +	return 0;
> +}
> +
> +/*
> + * Finalize each dirty subvolume root: free log trees, update relocation
> + * roots, clear BTRFS_ROOT_FORCE_COW, persist root items, and clear
> + * BTRFS_ROOT_TRANS_TAG.
>    */
>   static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
>   {
> @@ -1535,16 +1593,7 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
>   			clear_bit(BTRFS_ROOT_FORCE_COW, &root->state);
>   			smp_mb__after_atomic();
>   
> -			if (root->commit_root != root->node) {
> -				list_add_tail(&root->dirty_list,
> -					&trans->transaction->switch_commits);
> -				btrfs_set_root_node(&root->root_item,
> -						    root->node);
> -			}
> -
> -			ret2 = btrfs_update_root(trans, fs_info->tree_root,
> -						&root->root_key,
> -						&root->root_item);
> +			ret2 = prepare_root_item(trans, root);
>   			if (unlikely(ret2))
>   				return ret2;
>   			spin_lock(&fs_info->fs_roots_radix_lock);
> @@ -1604,7 +1653,13 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
>   		return ret;
>   	}
>   
> -	ret = commit_fs_roots(trans);
> +	/*
> +	 * Use qgroup_commit_fs_roots() instead of commit_fs_roots()
> +	 * because the transaction is still in progress and we must not
> +	 * clear FORCE_COW on roots whose blocks are shared with a
> +	 * snapshot.
> +	 */
> +	ret = qgroup_commit_fs_roots(trans);
>   	if (ret)
>   		return ret;
>   	ret = btrfs_qgroup_account_extents(trans);
> @@ -1618,16 +1673,12 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
>   		return ret;
>   
>   	/*
> -	 * Now we do a simplified commit transaction, which will:
> -	 * 1) commit all subvolume and extent tree
> -	 *    To ensure all subvolume and extent tree have a valid
> -	 *    commit_root to accounting later insert_dir_item()
> -	 * 2) write all btree blocks onto disk
> -	 *    This is to make sure later btree modification will be cowed
> -	 *    Or commit_root can be populated and cause wrong qgroup numbers
> -	 * In this simplified commit, we don't really care about other trees
> -	 * like chunk and root tree, as they won't affect qgroup.
> -	 * And we don't write super to avoid half committed status.
> +	 * Simplified commit for qgroup accounting:
> +	 * 1) commit cow-only roots (extent tree, etc.) for consistent
> +	 *    commit_root pointers
> +	 * 2) write all btree blocks to disk so subsequent modifications
> +	 *    are properly COW'd
> +	 * We don't write the super to avoid a half-committed state.
>   	 */
>   	ret = commit_cowonly_roots(trans);
>   	if (ret)
> @@ -1640,13 +1691,7 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
>   		return ret;
>   	}
>   
> -	/*
> -	 * Force parent root to be updated, as we recorded it before so its
> -	 * last_trans == cur_transid.
> -	 * Or it won't be committed again onto disk after later
> -	 * insert_dir_item()
> -	 */
> -	return record_root_in_trans(trans, parent, true);
> +	return 0;
>   }
>   
>   /*

