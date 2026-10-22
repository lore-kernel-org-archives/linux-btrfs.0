Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792661965;
	b=V2O5ud1I4zduEr/UJMNFZNpgo2T1Cms38y1b7GqFThZ7YDV11pteOMfCsVWAIgUd0CyH
	 wwX93T3QUDaunt5KMe67r9R78cmEO+NAaZ514a2hq7E1zDDyvUP3U36Wv3DMsmoZhEzIW
	 LTlWXEq6s1hToqVk1BySKbRuZy5aZsy5BY0nOTugPwZr0uWLlIoNnynY+KyZ3DbmN5Y74
	 pARG37Q6KnF7+vFMEzsqCZlQu7mugodLsLPNSG84FxeGjS7Y/Fn6q7CBEiFanTw9dAqim
	 jboNnwUEEZA04TcRLoCdDi+aA2LqZ8uslx/mqTwfZZwDEL3EtUkS3xIsZTkq9gDv2Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792661965;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Q3Jw2IVlMQbxrgQXCVi2zeCoUNd4kj2Owtygekj1CXg=;
	b=XriG0oXCTrmMzl8DWmhIuW08K0GHbTaay8qNdEW+UefiQXhBdPGv4imrvoAObW95P+FT
	 QDUWS/zjcRaIZ5qTAK9r9Rnc5jufG1nYt5SqQIhXwoMWr5D4oe4o7YU2PpK4YIQuCv/Mp
	 B1aSXfGfMES02ipTKXynyxFwGL5irFLrGaeuGppiEq+AYtMIFgmurjoj51HM0uLSn3RiN
	 Vt32BXK7V1uSQ1ztlAx5FAvpdSv2Zbv+rsb0Lu64VIZhJuh+RJ8jWG+noCXiEEiJKgbLh
	 91OFsQIkiZkoGaZ+5B4HDh04GIAz3kttv0zDrpmdPHvBucPAV+MZE5LvVzp4LfViXjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VMvwGQHh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFA660A2619
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 09:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VMvwGQHh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45971F000C8;
	Thu, 22 Oct 2026 09:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792661964;
	bh=Q3Jw2IVlMQbxrgQXCVi2zeCoUNd4kj2Owtygekj1CXg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VMvwGQHhmJf7iTp3ujVHmQGKS66Q1UHvKpmDXD20sCohtoMcdKUHhVWRfmCHCD82w
	 e2HlqQoA1ctEwVe6EV9oM2+sMm5mAF9rgw4f6Wct8CloLaTKFYqYh4YxYs6w0VHNF7
	 6B3NSm/uAc0EBkqhxXIQrkgbRLDya1gEdxKskCP/ePCk0YSGpz9aOLJ2zSw/MFwiu4
	 gLMpKa0kNfvjksZ/uXFXe0THIPGOhtpBhR4YK4kt3qBl5JzY1CNF3HZi+kEy8NQTgM
	 +ZIkgVP+8tzFbLC3wPBmY4VcshyBpd1k5RAud624IgYhRxW56h3+4bHxvJ7nwIteHx
	 t1RGkHGW+X+OA==
Message-ID: <25d90c45-fe4f-4e2b-8a24-0aa772bec4d9@kernel.org>
Date: Thu, 22 Oct 2026 11:39:22 +0200
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: force a transaction commit when fsyncing
 stripe-tree extents
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>
References: <20261022090653.2584545-1-johannes.thumshirn@wdc.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261022090653.2584545-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/22 11:06, Johannes Thumshirn wrote:
> An extent in a block-group that uses the RAID stripe-tree has its logical
> to physical mapping stored in that tree, which only becomes persistent
> when the stripe-tree is written out at transaction commit. But the RAID
> stripe-tree is not logged in the log tree.
> 
> A fsync therefore logs a file-extent item whose logical range cannot be
> resolved after a crash. Replay restores the file-extent item and the
> file has the correct size, but reading it fails with EIO and nothing is
> reported.
> 
> Force a full commit when logging such an extent. Extents reach the log
> both from log_one_extent() and from copy_items(), so check in both.
> copy_items() skips extents from a past transaction, their mapping is
> already committed, the same reason their checksums are not logged.
> 
> Fixes: 02c372e1f016 ("btrfs: add support for inserting raid stripe extents")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
> 
> Changes to v1:
> - Don't just fix the fast fsync
> 
>  fs/btrfs/tree-log.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 1d9dfb63fc5a..e50f924bca59 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -30,6 +30,8 @@
>  #include "print-tree.h"
>  #include "tree-checker.h"
>  #include "delayed-inode.h"
> +#include "volumes.h"
> +#include "raid-stripe-tree.h"
>  
>  #define MAX_CONFLICT_INODES 10
>  
> @@ -4741,6 +4743,24 @@ static int log_csums(struct btrfs_trans_handle *trans,
>  	return ret;
>  }
>  
> +static bool log_extent_needs_stripe_tree(struct btrfs_fs_info *fs_info,
> +					 u64 disk_bytenr)
> +{
> +	struct btrfs_chunk_map *map __free(btrfs_free_chunk_map) = NULL;
> +
> +	if (!btrfs_fs_incompat(fs_info, RAID_STRIPE_TREE))
> +		return false;
> +
> +	if (disk_bytenr == 0 || disk_bytenr >= EXTENT_MAP_LAST_BYTE)
> +		return false;
> +
> +	map = btrfs_find_chunk_map(fs_info, disk_bytenr, 1);
> +	if (!map)
> +		return false;
> +
> +	return btrfs_need_stripe_tree_update(fs_info, map->type);
> +}
> +
>  static noinline int copy_items(struct btrfs_trans_handle *trans,
>  			       struct btrfs_inode *inode,
>  			       struct btrfs_path *dst_path,
> @@ -4847,6 +4867,14 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
>  		    inode->last_reflink_trans < trans->transid)
>  			continue;
>  
> +		if (!is_old_extent &&
> +		    btrfs_file_extent_type(src, extent) != BTRFS_FILE_EXTENT_INLINE) {
> +			u64 bytenr = btrfs_file_extent_disk_bytenr(src, extent);
> +
> +			if (log_extent_needs_stripe_tree(trans->fs_info, bytenr))
> +				return BTRFS_LOG_FORCE_COMMIT;
> +		}

Might be good to add a test on

btrfs_fs_incompat(fs_info, RAID_STRIPE_TREE)

as the first condition in the first if to avoid doing all the tests and calls in
the regular (no RAID) case, no?

But if this is not the hot path, maybe it doe not matter.

> +
>  		if (skip_csum)
>  			goto add_to_batch;
>  
> @@ -5124,6 +5152,9 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
>  	u64 block_len;
>  	int ret;
>  
> +	if (log_extent_needs_stripe_tree(inode->root->fs_info, em->disk_bytenr))
> +		return BTRFS_LOG_FORCE_COMMIT;
> +
>  	btrfs_set_stack_file_extent_generation(&fi, trans->transid);
>  	if (em->flags & EXTENT_FLAG_PREALLOC)
>  		btrfs_set_stack_file_extent_type(&fi, BTRFS_FILE_EXTENT_PREALLOC);


-- 
Damien Le Moal
Western Digital Research
