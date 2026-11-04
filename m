Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.153
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793820240;
	b=l7GoE29BDnIggUlN5yo7+1drEuNIyn8mNJuQoD3yfebT3JUvDNlDgNsCnRWSFV7U8CXb
	 kU6Cu5vw809wcB/yGW20v+ENyesa/WGZB97xpkthNFVqHqhGK9ES4PjIVbqlEuZY/cRC6
	 caESFXRFHF+jadru0/oOZwjyAD7jfn3OIQwKtile1tX8bAGgrZ0aDEfUXQBZouRFuzdu9
	 U3ol2G8gXisr0OBGORH3AD0TgcBROhLbPLTHeEszB9/8rGFFE4IdFgSxRuB1ZGSZSCMCH
	 H3fll4FJPjv5O5w8rArJ9xsYE8P5gVecoqjVH5Y8cGhmQ5Lr2KTuo/7G9pjm2/HK39g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793820240;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=Y9Jf8gsE97UgH7jSi9BOOwNNQGYIDukHjqYcCr4WfCU=;
	b=QPjoo6GS9hpF7ImkX1C/CVLmgs60bbgzfYGKBi2POMPKRkbj/w89pFlHGHKeryUV90HB
	 HQSyb/oSqKgoW4DHuxqNEY7wJGk3kGttQLcVKu3gqTc0/BTtFMo/1s6OFCbYVztL7Z9hI
	 zLukcHtIC8KsjaZkOU7SSYOgt+GrxfTHez5vlu79QpMPLwlKzT0rC96sbyMwWIm5/oiQ3
	 MtEmbnYjib8Pba3NDgowxtafdFr3ddEoNHgh5bCUDLYZUjy3y10oyrXtVITIQvR1ZMUsZ
	 KJK1TsNqyMU8hjHbUasuqvaOW4jJYrjDc6xqOYEx2SWz0vg6PWwFxfEi0AFZtIVjB7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=cp3P5522;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=PtEaNfOA;
	arc=none smtp.remote-ip=202.12.124.153
Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E521A606D837
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 19:23:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E521A606D837
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=cp3P5522;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=PtEaNfOA
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 481F47A0182
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 14:23:59 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Wed, 04 Nov 2026 14:23:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1793820238; x=1793906638; bh=Y9Jf8gsE97
	UgH7jSi9BOOwNNQGYIDukHjqYcCr4WfCU=; b=cp3P5522LnPlQYc4/jOdq5Axfx
	dk/1kHmwOwrmnyTaxd1fX5rnnxa92P8sJewuymBKjrWilAxfSkNsjYPr9zpMP6Ml
	hG8QIQK65b96KqfC1hp2Gh0btkbNZaZuR90cC44wk5xfKXpGqBfy+OVQHaCDP/0+
	NCrehDshkTzSE8IY3Htr/vYGkj8d/ggNwHisPk2md47KzANpxttLJMy7ijjE1km6
	JB6yZ+dyI6QPcr++YggA2ou+iKZ3bSiKSVC0t+rsPqQosnv3lxOE5IuKDmfT6o9d
	RUGeqrJbhfE45nUg1QBXv/985S92lyCjF0mOW3jiueSL3OSMZkOfCsORcrlQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1793820238; x=1793906638; bh=Y9Jf8gsE97UgH7jSi9BOOwNNQGYIDukHjqY
	cCr4WfCU=; b=PtEaNfOA6wl2WaQRtcFq3/fTc7nXE7EKoxlERl4zqDk4YLGAw/j
	zvlABFTuwaEfHvkJ/Id+C0lpJU/hCofDgoYqs9sdA0pVyXL45WHJGxPrOQ8IIE2h
	hBsgYYA/vnCu7mdom69WzzZfSWQeam1ifUqbq8mTZrUTWfY6whOwT73n4+RpysBd
	74eb5atWD3C//KSGayZ/jq2HT62gXhM8bGD2d8BfIi7bedXGGnwmiv93wo0++Bnw
	D5w/K0SWldWwBt3+n8yFQtHRyMoM9UXpfTiHxwoJo2zMnP6DtZc7b/84iHkXNyml
	5ddIKsixFB954s/YEX93PU0dnOm+cKG9kfQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793820238; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:VocjkLW6UmAJKb5SH6rBqVJMvxY9XPC/+zhgNejUiWY5sKz
	NDXuEqL0H2ve3eJjiiF4+r1vCAnS34Oz1V9eO8VPrz2GJ6mHZb1KFjlIzqfikuUM
	TlI5G6h4lyy/9rDOdN3yBHeCj2TP0RZTWSs6/boYmRoya0MukfDw9mnkAYmldhhl
	8zzvnyvvAQ4NhbYFwBNiZjdC5X5byE/xExZxwbiLZXUm9kjji43utjsPYdjsLetS
	GYcf4PGaf6ZwonWAVfKsPUueG8U9Xh8HYJyYMm+ESwc63JoOlnCar9wODVxCKUDj
	ie1an78KvX5tsStnGy0dp1cOnRblIa8IYtJ24lA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:X3N7vWbHgBlUjXSS/5bkc/gENMztfqbRwRAMB56lUmw=:VdrurHRSg1F9ZVa6disASsP5SQGO3olDOZmQvqVaU6E=;
X-ME-Sender: <xms:TYbrajcSuwO6dCMPYZ_qB3QNY1juShclIP5qsGk8Qrn2xawwBUj54w>
    <xme:TYbrajNJoZo8eV6iA86XEpEfhYX-00QVlwHhvRhm3JebRRQh0ocdeuTkV1wiS3zfX
    bXk--pNGSPyoHM578NMinrT0Df5CZXYkdKAjzh0QBl3y_UlH88ngZRj>
X-ME-Received: <xmr:TYbrajKLspvZd0iA9QvU9KlNalxtVoBKEPR6nnd32uklcU7EytGywhhv>
X-ME-Proxy-Cause: dmFkZTEQ3qYdXHFTIZGeadzcrreMOjaOaREO5XS6pTV42Wh53MDHib3sq60Ws4Lz1r7e4Z
    6BHWJ8fJYzy2ayWd3aOn6lf4RnzPXz+8r2BFYJ3l/KiCctvIAy+EOgWG4PqUp31wg2p8aq
    dGuxoFK89azDuBYdwbMGs0fnpEKqLzcGF7b2E0b5Q9czE69CnANHt9i3jU18gFRhskWR86
    21ZHVdRhM8BbqpQprwGPFWRweAuXPmCWpvWcxLd2Jxt/GcvizjqLnemL8ScCdy34PyCH8G
    ywwm7tM4UthuQfQaesOxuwGxtfsGBuA2Cti1DUXK8e9z+5EDgmj39svqewfJysynpFosn8
    /U2jXgMckjnTmiPNqrTnH5VewT8YTkbJsfB8ElH+9Y8JyNNmcXtlJYjhVy/jz4nw03f8jl
    6i0AIFIXA18wObOSb1QIXKoqULMi7yza590EBonBVKqVasWfFyAJLqfZN7FilxPpQNBM65
    uJ8PMnE50PiSAW9kyuAhYm0npvCTQ50/WLN+I3y0eaLFoESLmesixVsguevO+mO3ZU3gUO
    xKCgcEWUP/kJt0nhPre7sNSSxZBiAa57fSXWSsZD/Ro57BfbfwwaYDoBv2lujyNbmKtoMQ
    IVUU+kxbX0eHTsN0Z6IMEOr4YCniSR1Ca+xZc+ttQ3u7eAe0+bFWIyaFtEhw
X-ME-Proxy: <xmx:TYbrajIu5EKBnzHvxjwPkpgrQdqYMprLNfMhzlK8nts3GWcxY5pvtQ>
    <xmx:TYbrat7ng_HEEsUYQQxxxD52h7UMLBb0Rn5knshpB3UkZx5HDx2Emg>
    <xmx:TYbratcN187FBvREJ1oz95zBISJnHdkhhv-woNAuABaJgQ60b6-kpQ>
    <xmx:TYbraoHjUQMLtC0OecxzJlyrEDQ5odRLV-JFZ1UCGCL0s96yyUPBjg>
    <xmx:Tobraj4V1-JDeVVX96bd4k03VK11d0-xX7fj5i3O-nL-wcR8_7GTwbHP>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 14:23:57 -0500 (EST)
Date: Wed, 4 Nov 2026 11:24:15 -0800
From: Boris Burkov <boris@bur.io>
To: Siddharth Mishra <smish149@asu.edu>
Cc: dsterba@suse.com, wqu@suse.com, josef@toxicpanda.com, fdmanana@suse.com,
	mason@kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] btrfs: tree-checker: reject inline refs not matching
 the extent type
Message-ID: <20261104192415.GD3301639@zen.localdomain>
References: <20261104102323.4090290-1-smish149@asu.edu>
 <20261104102323.4090290-3-smish149@asu.edu>
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
In-Reply-To: <20261104102323.4090290-3-smish149@asu.edu>

On Wed, Nov 04, 2026 at 03:23:20AM -0700, Siddharth Mishra wrote:
> [BACKGROUND]
> An extent item is either for a tree block or for data, and each kind
> only gets its own inline ref types:
> 
>   TREE_BLOCK: TREE_BLOCK_REF, SHARED_BLOCK_REF
>   DATA:       EXTENT_OWNER_REF, EXTENT_DATA_REF, SHARED_DATA_REF
> 
> Readers rely on this.  btrfs_get_extent_owner_root() only looks for an
> owner ref on data extents, and btrfs_get_extent_inline_ref_type() warns
> when a caller that expects a tree block ref or a data ref gets the
> other kind.
> 
> [CAUSE]
> check_extent_item() verifies each inline ref on its own, but never
> checks that its type matches the TREE_BLOCK or DATA flag of the extent
> item.  So a data ref or an owner ref on a tree block, or a tree block
> ref on a data extent, passes the tree-checker.  For example this tree
> block has an owner ref instead of its tree block ref:
> 
> 	item 9 key (30478336 METADATA_ITEM 0) itemoff 3636 itemsize 33
> 		refs 1 gen 13 flags TREE_BLOCK
> 		tree block skinny level 0
> 		(172 0x5) extent owner root 5
> 		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 

I assume this was crafted manually, not via btrfs operations with
squotas enabled, right?

> The leaf is accepted.  When the tree block is freed later,
> lookup_inline_extent_backref() skips the owner ref, finds no tree block
> ref, and the transaction aborts:
> 
>   WARNING: fs/btrfs/extent-tree.c:3418 at __btrfs_free_extent
>   BTRFS error (device vda state A): Transaction 14 aborted (-EUCLEAN)
>   BTRFS info (device vda state EA): forced readonly

This part is not that interesting, kinda garbage in garbage out

> 
> [ENHANCEMENT]
> Reject an inline ref whose type does not match the extent flags with
> -EUCLEAN, so the leaf is refused when it is read:
> 
>   BTRFS critical (device vda): corrupt leaf: block=30441472 slot=9
>   extent bytenr=30478336 len=4096 inline ref type 172 does not match
>   extent flags 0x2

but of course nice to catch more corrupt leaves

> 
> Signed-off-by: Siddharth Mishra <smish149@asu.edu>
> ---
>  fs/btrfs/tree-checker.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index f021ac14b..db446c8af 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -1790,6 +1790,14 @@ static int check_extent_item(struct extent_buffer *leaf,
>  				   inline_type);
>  			return -EUCLEAN;
>  		}

Logic itself is maybe too clever but at least quite compact. LGTM
Reviewed-by: Boris Burkov <boris@bur.io>

> +		if (unlikely(is_tree_block !=
> +			     (inline_type == BTRFS_TREE_BLOCK_REF_KEY ||
> +			      inline_type == BTRFS_SHARED_BLOCK_REF_KEY))) {
> +			extent_err(leaf, slot,
> +			"inline ref type %u does not match extent flags 0x%llx",
> +				   inline_type, flags);
> +			return -EUCLEAN;
> +		}
>  		if (unlikely(inline_type < last_type)) {
>  			extent_err(leaf, slot,
>  				   "inline ref out-of-order: has type %u, prev type %u",
> -- 
> 2.54.0
> 
