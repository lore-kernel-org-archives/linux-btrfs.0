Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792703354;
	b=l9cL8vschwiaWEJah/Ab6Dpe0NokyEKw9Fjcondgs9c0Mu/aQSB8UMy9+OLc9oQGmHZ3
	 k6j/rSmdinxg3lIW28Lgi9zIkbhDSjBFOlk5L4NXjGGWkGGb1y1Zbz9Ot4nBwe9eETyr8
	 stbYy2bOkLdcqGmdrEY4lIVvk+dh5weyJebJM1WerqfegQtFtC4oQEUPu0qujfrYqnGY6
	 auUlU/BSOwivFF9M6UUpFrSZbsmLtxhM0ixWDstwribVUPB/yhEqMrZgvFvuqN7fcsTBk
	 Us6jcoqCYiEWXQb/nilDdDcF7avQrKoMBarFkI7SQwrkFLxDYW/+MN4qGshyxaK1MDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792703354;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=/MoPhxmuBTX/nkM9O9OkXWHrhwCGyk4Eag55ozVLSjA=;
	b=2yY5lQXgK7RpmwB93HO8IuUGbeANh6DOIGBLVybJN6YyoPNrVw+J4uB5CzHV3N9DPRKa
	 QOri+Q5ihI4NMzbLJen7PRfZHs6C5dOZkEgjaQ1KVijUQhL9UnSddzuQgyhA1PklnQuTv
	 BHBG1/8fQrrm3Oy4BvgHfxxXJWFyx20EJl3EBvGXpjmw3NwXUI5vzv9zvcp/AbTA2EnxN
	 ijASyLczAEL9h+dmtAZLZ8+ZisdJ8cKOAhFwon6nBDNtiuan9zFQolIcNHVvYRac59hUw
	 C4DkUXmQGcXr1XOuFaaJlC+sAEzYaPATgQp2RrYQmaW6PqY+W98G+zzlHI6L0XYWklQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Yunal8tP;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2E9606A31A
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 21:09:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED2E9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Yunal8tP
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a1e477fe16so1843265e9.1
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 14:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792703352; x=1793308152; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/MoPhxmuBTX/nkM9O9OkXWHrhwCGyk4Eag55ozVLSjA=;
        b=Yunal8tPdJa3OqXcayMeG2ymUs3uNJlobjH6KD4SdUVnpSa+W9ZyoRSq3o8Ba0hNo7
         YwcFnJmUIYJvpQB6iMvlbLsS3EqLpP6FxFGanh/8EdjIwWNyHHRvZPAmIvO1uD9jGqac
         /70jAMD8FYE55LA8brg/5WEYNRv5/F3TIge8dvCzrIKId+EXExddZdjZAtaMOjoFc7+f
         RmBtuu8NhjnL7DKUCDRZ9r+QjlYTzdWU9t7Rx/0/yk1iXkjwe7+thhwqbiqp6+GlWOxH
         cneRzq06zpGXJaSiciZ/PivP1PkujLaJ2stwCuScSU+/7EeV2e6haU+ZmdRyw0Bg6Kk0
         zfhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792703352; x=1793308152;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/MoPhxmuBTX/nkM9O9OkXWHrhwCGyk4Eag55ozVLSjA=;
        b=ezGRmXwl5jRD2wWTZTDghp3YD9KkcuHxUMl+RDG0qUIhjiR9Ut/Jp2DKZ+WjU6v88g
         GLHEQCmt44dmdIgi8Alv4Zdxxw3AjaanpBLaUBxfCslHu7pBHqFSHVZS2Gt2Q2Wq/GGj
         VRtDsA1UAAYrK8GTtnjxhUMrYFHs4qGeYUVf6ZlmsVj6wCm/NzXhxa4uW0aQhgU9j1SS
         +FjLgu5AvQe5HW6CyFSIYsKLbJ4nJMJMOv3xz35X2lhOkaHxLVz/1kuof5jNfk8kfBte
         Nd2LpSVTbI+4zygLKH6jklkmPrgPNBhh03IE/1tqSBsSvgxeMX4WqnkBh/ULA5sClt1K
         yTag==
X-Forwarded-Encrypted: i=1; AKwUvBx/TQVJbrLjlw0CfTOTebwrcwE+6US4EO1JZZ+85wnCZUCPGRbpKfUUa7qyz2T26pfCA7pL/kDIdNphjQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIvE6S00m5KQz6actgACTQLWwhPBMrlMC1Dof+0p089nmuH8HbP
	t5juHofBfAiggM2ziZpBBVnmmeY1HjhsyrmPbdinKdIJvaAzXdyNDYNxE+xg+c/6t1gRTAsY7Ad
	QWAzGVl57kg==
X-Gm-Gg: AYBFou13DMgMbAhbM9zy2dUfiBs2S8nVSKIu1irM8qbyRLpLv/iUoTgmLJY8pReFLim
	yHlM60N8eqHb707JzGTh1dXgbDjF7DIQf4Ct4WG5zJJS9D7zWqjyo1GNkiEpSCoYtMrTwk2LQft
	Z3CLwGP8a64VJtwDJSUTl7XL39hk8zLUks/U9WA6aRw+f5kx0q9iOIv3d/Yb8Dyp0s7AliFwmP9
	2Sn7kmhtLMbnSyHWSnEEevZEOHEZcbpi0F6Sx57lW569WC3j5lUdRchi8BNnYLIf9EX6xgn7KwS
	q8booimj2DJQTd2CKHN2AdukMkhz1h/DjNP3Ztl5BQ/1koVwv+ajD6VTLQdhyDs8/GIHWm6eZTN
	+0DHj4qhwHgR3/tW3QzvBJv0xBi8I1pwvwbqox0M0RvVRudxu47cy4Hm7uRmfeG+1o8zCz2j27V
	jOWaniphikeZ0yDiNZs0QQeG0Ud52bKoJeL3TEz3Krx7L4LpvU0EYrA9GOtSnYMxLQLRI+PnZVW
	l8B9xIiogtPhJozbaKJ5srSTUbY19tqtdctJbIJy/mWtrlE
X-Received: by 2002:a05:600c:354c:b0:4a2:1197:1de0 with SMTP id 5b1f17b1804b1-4a211cb23f3mr4361985e9.19.1792703352332;
        Thu, 22 Oct 2026 14:09:12 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea7b3e03e4sm2864405ad.64.2026.10.22.14.09.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 14:09:10 -0700 (PDT)
Message-ID: <b1fb920a-681b-455e-a50d-e6cc2bebc729@suse.com>
Date: Fri, 23 Oct 2026 07:39:05 +1030
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
Cc: Damien Le Moal <dlemoal@kernel.org>, Filipe Manana <fdmanana@suse.com>,
 Naohiro Aota <naohiro.aota@wdc.com>
References: <20261022090653.2584545-1-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
In-Reply-To: <20261022090653.2584545-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/22 19:36, Johannes Thumshirn 写道:
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

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> 
> Changes to v1:
> - Don't just fix the fast fsync
> 
>   fs/btrfs/tree-log.c | 31 +++++++++++++++++++++++++++++++
>   1 file changed, 31 insertions(+)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 1d9dfb63fc5a..e50f924bca59 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -30,6 +30,8 @@
>   #include "print-tree.h"
>   #include "tree-checker.h"
>   #include "delayed-inode.h"
> +#include "volumes.h"
> +#include "raid-stripe-tree.h"
>   
>   #define MAX_CONFLICT_INODES 10
>   
> @@ -4741,6 +4743,24 @@ static int log_csums(struct btrfs_trans_handle *trans,
>   	return ret;
>   }
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
>   static noinline int copy_items(struct btrfs_trans_handle *trans,
>   			       struct btrfs_inode *inode,
>   			       struct btrfs_path *dst_path,
> @@ -4847,6 +4867,14 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
>   		    inode->last_reflink_trans < trans->transid)
>   			continue;
>   
> +		if (!is_old_extent &&
> +		    btrfs_file_extent_type(src, extent) != BTRFS_FILE_EXTENT_INLINE) {
> +			u64 bytenr = btrfs_file_extent_disk_bytenr(src, extent);
> +
> +			if (log_extent_needs_stripe_tree(trans->fs_info, bytenr))
> +				return BTRFS_LOG_FORCE_COMMIT;
> +		}
> +
>   		if (skip_csum)
>   			goto add_to_batch;
>   
> @@ -5124,6 +5152,9 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
>   	u64 block_len;
>   	int ret;
>   
> +	if (log_extent_needs_stripe_tree(inode->root->fs_info, em->disk_bytenr))
> +		return BTRFS_LOG_FORCE_COMMIT;
> +
>   	btrfs_set_stack_file_extent_generation(&fi, trans->transid);
>   	if (em->flags & EXTENT_FLAG_PREALLOC)
>   		btrfs_set_stack_file_extent_type(&fi, BTRFS_FILE_EXTENT_PREALLOC);

