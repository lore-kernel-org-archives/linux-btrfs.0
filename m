Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.146
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793820527;
	b=REzTwbBzT4O6QHRSY7UyYpiEEbpInYCfXk7d83c7Pk97Fh4uGVAJF1tSn/6qs5OhbubX
	 sgyyrDwwRZyBTARtH2Uyni76kenesmtT/YrJ//2KwhnNz3+YQHfJKICnPOjzWuFwc0Q0h
	 jy9jYaopMaFhp7j7VKDUj4cBcRrcJ7MLjGf5NJJwt4eoflHXJNwlEeGShCUfS+es7uHQI
	 TaNcSvrCw6EbLCZM6+/v+D/EqmmDDIVL5TgDErvaH56nQ12YzgIrq3dtsLgWTcpoA5UYr
	 5JZJGnDCMskiAYQE8esHD7c9JXILQX1LrHvE7XGDDqdtlxnMypJbt5S4vEookEHsZBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793820527;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=xo7O7OZ9IoQt+9PPHhtslfdp1sVEzka18zv7uZU02m4=;
	b=2QAvxC7q5daMKjPYAyLNFOyWe09VBJ4lGyL1ykGhXEjUzlUkfJUxPrqMBm9F/F7gEJR4
	 3vq0J6R9fU7dUNH1v63SbMi595NlXXmuOTy7PRv/iD4YkCjs1ej4ez8HW85iVW9Cfrhye
	 bC1HHb952UvDY7W4TJdf6tVnyXA+sTBID1hfd4lnK3FAyohLTT8ofpzTTOeyfRcjg+XHG
	 aKS+eJ0baD1CcrkRxUqLj9Lgn46AIZ/brt7eoqvOWndKRHMXKwVLB5S9r33FtDPw9MUCi
	 w6GDY/yZs72rcOyCf8Jn0inUsJoZnE9Ghyx8OXwCj+/GjWgZhSkPQg0LE4LVtnFmxkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=DaaaknIo;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b="fsIj/cyv";
	arc=none smtp.remote-ip=202.12.124.146
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082316075273
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 19:28:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 082316075273
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=DaaaknIo;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=fsIj/cyv
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.stl.internal (Postfix) with ESMTP id 5924C1D00182
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 14:28:46 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Wed, 04 Nov 2026 14:28:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1793820525; x=1793906925; bh=xo7O7OZ9Io
	Qt+9PPHhtslfdp1sVEzka18zv7uZU02m4=; b=DaaaknIofdNz6tOS9AbKcML3RU
	NVHfd7/ul6uX4IX5K9tsiVbawWimrSKtNTfvw8O1Q+Y3GdzD9PMBGmDoVOKAvwJa
	20vJ68qltE7qRfST3XUDRbPsPyppQ7myIV8DPXhVo/ZkfQfgVc7qzgaBKz53+oyF
	DAZMYMv/FSjj/uv+JBcHt2i20UBQLxHYLl7zUcSpcdAzCMn3IEPZvV5gfFv8/QY+
	XnKkfa46tQAKUu+QcdGrt17NdqXJZ9secg0AbfSf5EvV5dHhSVqLlIIXo/lG/kSo
	X4yhFeyYc6nUxuNRKXOUpG+9cW1QAl8Gpn+xFH5eJPb/02udUMF5ko+nkYVg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1793820525; x=1793906925; bh=xo7O7OZ9IoQt+9PPHhtslfdp1sVEzka18zv
	7uZU02m4=; b=fsIj/cyvJSM/3CdgGEVk0v+q9kTgbuWg4xY+KLsPjV17UKoaa0a
	DMFYDdpC4And8jIlgwm024drU6lv33jxJa8EOt87Wlp2pIBRfE2nENyiP4ZEOFeT
	Cle6y8anHsuJA/mgiQDT5t9UGf/tLeCCMKM1Vpa0/zLnn6tzcKKev4SB0M5Z3v2Z
	kDlWH+KQsTlKf9BXCBdA+pn9l743DHzLxz9BtGbJMIKB4CxU4VC4ZCf+sISroJyA
	f2NqOzdA6wltnsr8JEz+nW+AhGPcQPPkzRB2tjBCQTbgNRGIrgFiQ6U7JRSKpe1Q
	ufG0jbpQpryNoSbFI5C2cycA6AsD5bXfbUw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793820525; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:Uw0pXZqQ22itN141trNTyOw7tceTAKGc0ZJSaTqcWji5t5y
	qpnsOJOQ1tvZuYaCWUl13N8c38Bg3ySJPMGUwkxzkxrfTuDXY1gkGbpH1cjH2Ljy
	t+yxLmoX8hMi8VjKLCU/0XiZBk1g6vq109JxCqXU6cYRAfgaMVaLdrDjxUEzJ/nj
	5Itmy7F3/btMPjQC03on3OljWMCyLX3xUMdc0W4Sy52gGVesk2Zrzzh9FfmHdwZ1
	TatfFazjAEZpKNA30lHfIpaWihURfRZMYCfHWJYHf224q1Q1S4SdXVADn7CVryIz
	k0USuRktfGrsC81LLXnR+yPXGonZHvV96YWPBOQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:8BF7drxOctqfl5h5+r9WUG2Zv6uBgKNCZ865yP9YMUw=:fyr48dxAe+omUVaoEPdG3rZeZQnPmzKwSeHf0bdmgYU=;
X-ME-Sender: <xms:bYfrapMsnb6-givm3XrBhCxtdU3qEMG5wDSvbspPrT1BalmKogwkxg>
    <xme:bYfral8qZWW2S0043deHw-7-PgLfPnUxxVxQ18bJjXJEhjHIKDThkHDUFigO4IxHl
    4aQ7D79baSPqys0K-YmyYUSHx3lzdy_qAyXJIhC4M552RdR1L_tWvt9>
X-ME-Received: <xmr:bYfrau7y9qlO-5Lafs6zyxzURzEilUGxdxEPMxfIlTRI801DhEqLTsTX>
X-ME-Proxy-Cause: dmFkZTEQ3qYdXHFTIZGeadzcrreMOjaOaREO5XS6pTV42Wh53MDHib3sq60Ws4Lz1r7e4Z
    6BHWJ8fJYzy2ayWd3aOn6lf4RnzPXz+8r2BFYJ3l/KiCctvIAy+EOgWG4PqUp31wg2p8aq
    dGuxoFK89azDuBYdwbMGs0fnpEKqLzcGF7b2E0b5Q9czE69CnANHt9i3jU18gFRhskWR86
    21ZHVdRhM8BbqpQprwGPFWRweAuXPmCWpvWcxLd2Jxt/GcvizjqLnemL8ScCdy34PyCH8G
    ywwm7tM4UthuQfQaesOxuwGxtfsGBuA2Cti1DUXK8e9z+5EDgmj39svqewfJysynpFosi/
    uVDcUB9yy0x9iqhbHsxL8HXGXXFA9dhdSJF1PNwXV+JUXEfNHz1K6aXOdCLx5iPgEeG0bg
    4IPEOZQft8rD9A78Ydzd5HRkd1vyJyHxg/4DlVWZ4pTZhamYUwm9ERxFSdaLk6W+WTyPvp
    w0/bD8xamTL3AxW01sljgCom8oQaQ1PZDClnlH5gDB41ZBsm95rnYZcDcW2atckh8zOxi8
    QOt0jAD+eqCu8XBomY+URpwq5Oc+qUF+NViBkWBVJDE+Gw+ivzAcXhoZy+t/Fe7TOgebRJ
    OcSelIynEihFhOJUWCWk9Nc9tR6Q+zE9WmP4kHcC10gkYcVrhdv2wvx/7AkQ
X-ME-Proxy: <xmx:bYfraj5Bh3RrBHr3jb3nE7b4b5423uuACGUJap0uXyguJwFo6zkMlw>
    <xmx:bYfravrLH44qYcViIlm89zpJZUlged1-H7v5RN6qjBefFwjihVVFJw>
    <xmx:bYfrasNV-B1pubh-1J36QYth410FSRDf9uHLEjyVl6lNTSfXIVhhkQ>
    <xmx:bYfrav2Kq5B2F2jwrT_R23FpAMWOMjuKtVFUX2IRLkonQ-PGrR4L1A>
    <xmx:bYfrajo6hG4Oc8wCSC9tQOxhY4EPkVNbJmyBrVJAx5J31BYfpanSXgo3>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 14:28:44 -0500 (EST)
Date: Wed, 4 Nov 2026 11:29:02 -0800
From: Boris Burkov <boris@bur.io>
To: Siddharth Mishra <smish149@asu.edu>
Cc: dsterba@suse.com, wqu@suse.com, josef@toxicpanda.com, fdmanana@suse.com,
	mason@kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] btrfs: tree-checker: reject keyed refs not matching
 the extent type
Message-ID: <20261104192902.GE3301639@zen.localdomain>
References: <20261104102323.4090290-1-smish149@asu.edu>
 <20261104102323.4090290-4-smish149@asu.edu>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104102323.4090290-4-smish149@asu.edu>

On Wed, Nov 04, 2026 at 03:23:21AM -0700, Siddharth Mishra wrote:
> [BACKGROUND]
> When the refs of an extent do not fit into its extent item, the others
> are stored as keyed ref items with the same objectid, right after the
> extent item:
> 
>   TREE_BLOCK:  TREE_BLOCK_REF and SHARED_BLOCK_REF items
>   DATA:        EXTENT_DATA_REF and SHARED_DATA_REF items
> 
> [CAUSE]
> check_simple_keyed_refs() and check_extent_data_ref() only verify the
> keyed ref itself.  Nothing checks that its type matches the extent it
> belongs to, so a tree block ref for a data extent, or a data ref for a
> tree block, passes the tree-checker.  For example this data extent is
> followed by a keyed tree block ref:
> 
> 	item 0 key (13631488 EXTENT_ITEM 32768) itemoff 3797 itemsize 198
> 		refs 41 gen 9 flags DATA
> 		(178 0xdea30debbf5f519) extent data backref root 256
> 		objectid 258 offset 0 count 1
> 		...
> 	item 1 key (13631488 TREE_BLOCK_REF 5) itemoff 3797 itemsize 0
> 	           ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 		tree block backref
> 
> The leaf is accepted.  When the extent is freed later, the refs do not
> add up and the transaction aborts:
> 
>   WARNING: fs/btrfs/extent-tree.c:3418 at __btrfs_free_extent
>   BTRFS error (device vda state A): Transaction 35 aborted (-EUCLEAN)
>   BTRFS info (device vda state EA): forced readonly
> 
> [ENHANCEMENT]
> Check each keyed ref against the item right before it.  Keyed refs sort
> right after their extent item, so that item is either the extent item
> or another keyed ref of the same extent, and both must be of the same
> kind.  Reject a mismatch with -EUCLEAN, so the leaf is refused when it
> is read:
> 
>   BTRFS critical (device vda): corrupt leaf: block=31678464 slot=1
>   extent bytenr=13631488 len=4096 keyed ref type 176 does not match the
>   extent type
> 
> This is the keyed counterpart of the inline ref check.
> 
> If the item before a keyed ref belongs to another extent, its extent
> item is in another leaf and the keyed ref cannot be checked by the
> tree-checker.
> 

This one seems the most "juice not worth the squeeze" out of these
patches, but I think the analogy to inline refs is good enough for me to
justify it.

Reviewed-by: Boris Burkov <boris@bur.io>

> Signed-off-by: Siddharth Mishra <smish149@asu.edu>
> ---
>  fs/btrfs/tree-checker.c | 48 +++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 46 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index db446c8af..d966243c9 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -1854,6 +1854,50 @@ static int check_extent_item(struct extent_buffer *leaf,
>  	return 0;
>  }
>  
> +static int check_keyed_ref_extent_type(const struct extent_buffer *leaf,
> +				       const struct btrfs_key *key, int slot)
> +{
> +	const bool is_tree_block_ref = (key->type == BTRFS_TREE_BLOCK_REF_KEY ||
> +					key->type == BTRFS_SHARED_BLOCK_REF_KEY);
> +	struct btrfs_key prev_key;
> +	bool prev_is_tree_block;
> +
> +	if (slot == 0)
> +		return 0;
> +	btrfs_item_key_to_cpu(leaf, &prev_key, slot - 1);
> +	if (prev_key.objectid != key->objectid)
> +		return 0;
> +
> +	switch (prev_key.type) {
> +	case BTRFS_EXTENT_ITEM_KEY:
> +	case BTRFS_METADATA_ITEM_KEY: {
> +		struct btrfs_extent_item *ei;
> +
> +		ei = btrfs_item_ptr(leaf, slot - 1, struct btrfs_extent_item);
> +		prev_is_tree_block = (btrfs_extent_flags(leaf, ei) &
> +				      BTRFS_EXTENT_FLAG_TREE_BLOCK);
> +		break;
> +	}
> +	case BTRFS_TREE_BLOCK_REF_KEY:
> +	case BTRFS_SHARED_BLOCK_REF_KEY:
> +		prev_is_tree_block = true;
> +		break;
> +	case BTRFS_EXTENT_DATA_REF_KEY:
> +	case BTRFS_SHARED_DATA_REF_KEY:
> +		prev_is_tree_block = false;
> +		break;
> +	default:
> +		return 0;
> +	}
> +	if (unlikely(prev_is_tree_block != is_tree_block_ref)) {
> +		extent_err(leaf, slot,
> +			   "keyed ref type %u does not match the extent type",
> +			   key->type);
> +		return -EUCLEAN;
> +	}
> +	return 0;
> +}
> +
>  static int check_simple_keyed_refs(struct extent_buffer *leaf,
>  				   struct btrfs_key *key, int slot)
>  {
> @@ -1892,7 +1936,7 @@ static int check_simple_keyed_refs(struct extent_buffer *leaf,
>  			   key->offset, leaf->fs_info->sectorsize);
>  		return -EUCLEAN;
>  	}
> -	return 0;
> +	return check_keyed_ref_extent_type(leaf, key, slot);
>  }
>  
>  static int check_extent_data_ref(struct extent_buffer *leaf,
> @@ -1953,7 +1997,7 @@ static int check_extent_data_ref(struct extent_buffer *leaf,
>  			return -EUCLEAN;
>  		}
>  	}
> -	return 0;
> +	return check_keyed_ref_extent_type(leaf, key, slot);
>  }
>  
>  #define inode_ref_err(eb, slot, fmt, args...)			\
> -- 
> 2.54.0
> 
