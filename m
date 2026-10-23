Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792747326;
	b=JyVA8HV59JghMwNoe+iljv0/skb4UDoCGo5DEAMTFCH6ag0Px4MConU+8o4rbuL9YQXW
	 rh1QLI8LUzp11tyjO/xEuqb118y/ZRluowplzQNlUOxh7Pk1e3Ls3aeSLE13IzynNekiG
	 ew4h6Z9YSBeQ8xCnbDXqQAJ+V4YNDNwCLtp0wwcdG8vL4U+7fynsSD5xFHAckd8rg4g+v
	 tNQ7dkXyW8opUuoyIEQJb70sFNUSVAsllQ3bv8MG5bx5bTOi6SMctJFE3dXJ7867PqYvv
	 x5vtKkF392UoyvXzFJLtn3yOXhsfujxIG6XaeaUH7ddmuS+alCV8ZUxNGqkqkFmh6Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792747326;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=j6o7+7wNTBeEkS58yMzxDPgiWibIalxjUO/TmFdV7Ow=;
	b=3pT7D5dKBTLc6o4CyrlgeijpKAWBlS4t+ox+CI/ADxJHsU1ikwIw0SjFvFvUMyfp2ddz
	 MFvTZsu/FF8/KAzqaFrESGr8Sx1NBLn2ZSRyKMEtCjx5y0sE/VZeCndWIB0q3fIqhlRWS
	 ECLdXOj70Hu82IhOGIDyH0WCqRMQdzsJimNdisredaTsfoN9Fowe10Lx8LVXNmJ+UnibB
	 qgAhPTq0l06I0xwlyb5Emh6yapOVE0oDpLstiKXIXjaB+Ox7X65/PE/Bi3GSi1HOctP9e
	 uUyvAZFC+g/qatj6kdVpVx5AHJwjJf+5pX3mBIlRHZpydYCAbtyCBVpRMCPRfQBum0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=C8MRvkXn;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21057606A31D
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 09:22:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21057606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=C8MRvkXn
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a1e3098ee2so7433555e9.3
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 02:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792747324; x=1793352124; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=j6o7+7wNTBeEkS58yMzxDPgiWibIalxjUO/TmFdV7Ow=;
        b=C8MRvkXnUVpvXrK1hdiCE9xvgaKDIBam/dCjMlZkEMwUQuoQrlSOddGgsxQnkBdPor
         biUHjTLWVEdUNAVhIIXbzZp+8TnmpY/pUedbeorDXqyDtoBOqcqjWQSR+5uzJ0v9yJAn
         74q/JkEGjR1eQH+pyEq04b5ooyPaqnBgEbN5dydQIPhX7m+JsZLJYnQ3WOfSCjV5OTa8
         pV1Rg0H9hLJ/TFYsWr2Uv7e/W51gzPLHHGUit5l/Echp/vzGjXXSCrrJoFNkCdLzElsg
         8KEU5BZBxnnX2OVPMiTk6GXJUBvXN4DnQYHP/MIkL5wgDP+gtkWaaurAXwPXJNVexEjL
         +oEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792747324; x=1793352124;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j6o7+7wNTBeEkS58yMzxDPgiWibIalxjUO/TmFdV7Ow=;
        b=GkyV8813QafdwUotwo1ZofMACXtAxDKrhVGzRKZTlLXpG7golrFE0rie2+nmKB2NpD
         ZtiRe/e1N4k5N07xTArZFOHwoGVa20h2S/D68PDaZ7NXK2/iReJ3abhjj243oUd67bcT
         fjYp0QUoXfJoQ2My8PKQQZMp07KT23CBfnicCw4scFhzA9VDi+G/jMA5fU75HLS4fQzH
         /LzAuT7vabCeUykMHt3Upt+phR8gy+xI+D6i8QMt6yRpP6UMNQpWbzKnU/LjEcOIUzr0
         tyLT1rCMoabGfmBK/f7IW+Ykn+lR7sPCuboFG4aFu2OdNinNCWymWh27sGJeeCtHXr4Y
         qRag==
X-Forwarded-Encrypted: i=1; AKwUvBxe6I1eP7GMH6kfj0XRCashv9EHGLvVrIb2IbNBUybVt7pFDRrPX27tuWy8eopGou0hdyvDBv68ktJZFA==@vger.kernel.org
X-Gm-Message-State: AFq9FYKrsHv6r2yrag6FJk1hdTADgbQIvMDUFxLQ4P1plYhXJqRprR18
	5QO1UQ49CIAMAEuP2npkgP5OFLC0R/GDoscQh1Pgtt34b/bpUn62gxH5pNFcpy/aoy/7EwYhpeV
	97bHleULlaA==
X-Gm-Gg: AYBFou2paA8msK470vsNC/QaVsBgzlJRVUjyfR1MdiNiYj60XCF/2LujEe6iSfLqtlU
	qp6e8928I1GYCCvgA736sv+A37YnTbxg/WyXU0Qo1bMxIKqbCaFkq9JFcictzBLLe4oG9192RrH
	pOgvgZFx315vTrLE2IOgs6IgZtCZzjoG4hbSXCoqpgbtxoMBEWQQazAnKJQYG3sYDc0+Y+coZxM
	vqA2En+nCUgBBAbrMmWZ+nPKif8E+6z4dO9Y031TqP2BxBA5oPy1avUcv9Xwmvl8YJV6imzU/rF
	GX4H6RNUBMav2oZcgBAFz/eo0gitrJ2pBJ5ocoiADVQ5FwCkWrPVH816zU09XAObRcWWWrv241u
	iOUeCmJuARbNukHF8MIc/zLYAC+/QfAmwll5kVyqfIYHGYrdM7eSty0BGAwM2tiSbu7I1V3L/c5
	k00Gy6iWAWvuM/m8LNqJX8LTGXqNySvtqo86+bENBrQQGU932Y1UJauNPeNnK5MC8u2Yy1FWR5P
	qDfPkJR+AZORz7SQNjKJSJLIVINdipcEmm7PcbIe3k7186l
X-Received: by 2002:a05:600c:37c6:b0:4a1:a45a:88f with SMTP id 5b1f17b1804b1-4a211f114aemr23640565e9.20.1792747324463;
        Fri, 23 Oct 2026 02:22:04 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8ba7d550dsm601773a12.1.2026.10.23.02.22.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 02:22:03 -0700 (PDT)
Message-ID: <b3992af0-36df-4c5b-b4d6-d33336cef51f@suse.com>
Date: Fri, 23 Oct 2026 19:51:59 +1030
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
Subject: Re: [PATCH v3] btrfs: send: fix missing hole punching during
 incremental send
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <25a6b104e8af433508c425cd7470426470f811f2.1792613378.git.fdmanana@suse.com>
 <84ee388d9368cddb21943a129af572685a7167c5.1792745199.git.fdmanana@suse.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
In-Reply-To: <84ee388d9368cddb21943a129af572685a7167c5.1792745199.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/23 19:21, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When using the no-holes feature (enabled by default since btrfs-progs
> v5.15) and doing an incremental send, we can miss issuing a hole punching
> command when the following conditions happen:
> 
> 1) A hole is punched in a tail section of a file extent item that happens
>     to be the last item in a leaf (for example the extent covers the file
>     range [1M, 3M) and a hole is punched in the range [2M, 3M)). Between
>     the end of this file extent item's range and the i_size, there are
>     other file extent items;
> 
> 2) The next leaf was not modified in the send snapshot, remaining shared
>     with the parent snapshot.
> 
> In this scenario we are unable to detect a hole was punched and never
> issue a hole punch command because with no-holes there we don't have an
> exlicit file extent item to mark a hole.

s/exlicit/explicit/

> 
> Fix this by teaching maybe_send_hole() to detect such case.
> A test case for fstests will follow soon.
> 
> Reported-by: Tristan Elvers <tristanelvers@gmail.com>
> Link: https://lore.kernel.org/linux-btrfs/CAFoLKK+aErV4p6ZJPnVeH5SHQ5++0f=8ZgxPWe-E-CkeKBs8PA@mail.gmail.com/
> Fixes: 16e7549f045d ("Btrfs: incompatible format change to remove hole extents")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> 
> V3: Avoid tree searches in case the i_size is in the last file extent
>      item and in case there is no hole between the last file extent
>      item and the first one in the next leaf.
> 
> V2: Address a couple issues pointed by sashiko, simplify a few things.
> 
>   fs/btrfs/send.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 65 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index c523bf950c89..1b903e75cec0 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -6371,6 +6371,9 @@ static int range_is_hole_in_parent(struct send_ctx *sctx,
>   static int maybe_send_hole(struct send_ctx *sctx, struct btrfs_path *path,
>   			   struct btrfs_key *key)
>   {
> +	BTRFS_PATH_AUTO_FREE(next_path);
> +	const u64 cur_extent_end = btrfs_file_extent_end(path);
> +	u64 next_offset;
>   	int ret = 0;
>   
>   	if (sctx->cur_ino != key->objectid || !need_send_hole(sctx))
> @@ -6397,14 +6400,72 @@ static int maybe_send_hole(struct send_ctx *sctx, struct btrfs_path *path,
>   		ret = range_is_hole_in_parent(sctx,
>   					      sctx->cur_inode_last_extent,
>   					      key->offset);
> +		if (ret == 0)
> +			ret = send_hole(sctx, key->offset);
> +		else if (ret == 1)
> +			ret = 0;
> +
>   		if (ret < 0)
>   			return ret;
> -		else if (ret == 0)
> -			ret = send_hole(sctx, key->offset);
> +	}
> +	sctx->cur_inode_last_extent = cur_extent_end;
> +
> +	/*
> +	 * If we are the last file extent item in a leaf, we may have had a tail
> +	 * section that got a hole punched or the extent replaced with a smaller
> +	 * one, and if there is no change in the next leaf, we must find out if
> +	 * we have such a hole and punch it.
> +	 */
> +	if (!btrfs_fs_incompat(sctx->send_root->fs_info, NO_HOLES) ||
> +	    (sctx->cur_inode_size <= cur_extent_end) ||
> +	    (path->slots[0] != btrfs_header_nritems(path->nodes[0]) - 1))
> +		return 0;
> +
> +	next_path = alloc_path_for_send();
> +	if (!next_path)
> +		return -ENOMEM;
> +
> +	ret = btrfs_search_slot(NULL, sctx->send_root, key, next_path, 0, 0);
> +	if (ret < 0)
> +		return ret;
> +	if (WARN_ON(ret != 0))
> +		return -EUCLEAN;
> +
> +	ret = btrfs_next_leaf(sctx->send_root, next_path);
> +	if (ret < 0) {
> +		return ret;
> +	} else if (ret > 0) {
> +		/*
> +		 * No next leaf, must punch hole to i_size and set the path back
> +		 * to where it was before.
> +		 */
> +		next_offset = sctx->cur_inode_size;
> +	} else {
> +		struct btrfs_key next_key;
> +
> +		btrfs_item_key_to_cpu(next_path->nodes[0], &next_key,
> +				      next_path->slots[0]);
> +		if (next_key.objectid != key->objectid ||
> +		    next_key.type != BTRFS_EXTENT_DATA_KEY)
> +			next_offset = sctx->cur_inode_size;
>   		else
> -			ret = 0;
> +			next_offset = next_key.offset;
>   	}
> -	sctx->cur_inode_last_extent = btrfs_file_extent_end(path);
> +
> +	if (next_offset == cur_extent_end)
> +		return 0;
> +
> +	btrfs_free_path(next_path);
> +	next_path = NULL;
> +
> +	ret = range_is_hole_in_parent(sctx, sctx->cur_inode_last_extent, next_offset);
> +	if (ret == 0)
> +		ret = send_hole(sctx, next_offset);
> +	else if (ret == 1)
> +		ret = 0;
> +
> +	sctx->cur_inode_last_extent = next_offset;
> +
>   	return ret;
>   }
>   

