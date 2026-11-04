Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.146
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793820096;
	b=zG6E2ommBVpF78PyaQHKytb6gW4CAVDXX1vjTC1mc27ChVPnlGayma2wK2MLzmD2vUbX
	 1FNlutrrtqH2As0ov0gmQKGCgLKwFLBa1n/ZzAuDjJ+rl5erKtpFf+m5m/1PfDG0PFIQg
	 W1NV5AYmTG/aDcJE4AxaKDCAbC6/KJxtCscUyY1LO+NnXpOrwENs/CHqBWgtg5QhsFK5Z
	 2MFsvIp+yRXarUOL+6vsehwcvYjvkfgYhPfhQg55wns9bNhpJmMMxLTAYVwQighhOzJO/
	 S4/tXBIx3xa/OZh7aHL3sHfZOQD/wDeBknv0oEx8Q3wTBTnL6T21h6ir6yQI5Ret0Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793820096;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=Q1vPwoXxLPvqpt/yG160N1FIY8mZvlrWq8/lCtnF8jM=;
	b=OXAIu6MYyQhc/CwGBglRwjXwrELPzyklMuHG7NEyfutRpIr3OhpbS3FCylSPEdG2tmtb
	 MgHwiRvCGSpfPbm92eD3euUqDsMqUEFWRiAlhBReYRMERNbsCoqsdoE7yKrOjx5mEl7Ra
	 EHjDOS9As6RWq51Fp1F6g/Armz+S2NJzjX/CnDJg9H7cxsaohy9sJ3KuXTUxOLVbpKIhs
	 kvlIOdul7EofQ2zq4ZJulFalSIUJlMgX9pnjjNFuJSlY3aArhmuqwujVpDFoPwlUHv0Vz
	 m+eFCbuNp8L1ufJzIA4smUh/QZ1qCnR8Z0Gja45b99mJOPceJIzHbOF7NCttkWIxo3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=OEvbcHUL;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=mUarms0y;
	arc=none smtp.remote-ip=202.12.124.146
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE786607524D
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 19:21:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE786607524D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=OEvbcHUL;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=mUarms0y
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id EB0581D0016C
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 14:21:34 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 04 Nov 2026 14:21:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1793820093; x=1793906493; bh=Q1vPwoXxLP
	vqpt/yG160N1FIY8mZvlrWq8/lCtnF8jM=; b=OEvbcHUL2VIgx8XqAFlceg7WUt
	g5R4VHY+hxSCJsvHQSUEnoeXCXpaLl31YcRDJ/03OR+j5U3V5tmXVZ0dtcCI1gOo
	hoEuKm0L5JGO0OTkI5jxtj1Dl1q+qBj5otDWmDolKw+h9kpOkt1RS3UDjTko8KlM
	RtPTgqhOnRNEGKmDDuA+Pc/yzYDimp/ByT2M7TVlAoOP7h755Uu/0nXRDQcVn33U
	XTgvjReb1Mb0AlWWbi1uY0Opm/xbhvoJ76yPVIzJI9Dwk+bitfzK+dJumJgsFA82
	ZajVtJHKrwYXc6hJihjgLNTHKo4S0mIBw4Vr+OjF7ItGO0anmqsYK16MiNWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1793820093; x=1793906493; bh=Q1vPwoXxLPvqpt/yG160N1FIY8mZvlrWq8/
	lCtnF8jM=; b=mUarms0ytOygf25iAj++XmxT06c1Jv4iHpW774H3UV1CAfxTSpd
	tM0ceqmpOHZlJ+kiBjFXU2K7S078F4STixs4+BH7wzUtHKWBFCWGSYaoB69FH4m2
	pChjITjqkgIyd/sesSQudUKxh5GArKsOd9vAQqvsLtAVnCkVASj1M/g7cOWlLHvr
	3kYCBdUJpBDexx43/reHVUZFAyeHW8G8nBLzNfRvrCgwbcZKLOHJyQT4yvQ4prUD
	9i3JbWeXbPwRLqwZNwFSKkSPwV8jRswC5bP51wYg9x54LIJSpBxlbmc5A8nUGsuz
	H7yLmrnqVjYTitDISO66/ID3yvwiUDiYKcQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793820093; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:fcp+hkFk+U5NmmBlvbjkB5NXKAMoCigqsWCfXlTF/PvMDng
	dF2In+bdNQtIzT/qHk/j6GhOFuGOtYe/NYIbPtGqDtoAh9/b+42i0wDHV8vbu+jO
	UtEF/TKFoPjWK5296QUg2QZ/zy6DX4I+MEzzmcUc3MNAaQBQCPJzforqu5ulDJnJ
	BUcJbPtRnC47fZyCeyEYKG8cuJMXMiNTPkI0VaMQ7jVWgdr2k4MfatqiNzB7UhR3
	aFjDqVB4OvETMgGcCcsAu5tI7kUFPMkVJv+ak1hUGKZp9eVI8nL1MmV7lZfkhHY9
	CoU+08hR6QRNp2VNzsxU/Y21ABo/CKA5VD1Syvw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:a6cmgIlVRVP25I65KfkHemtbXK/U87oa85Aur8W2VYw=:QRMSXiCEzW1EelBvEdFDJHL1vgjLvhRKZSkJ/CXCaxM=;
X-ME-Sender: <xms:vYXravAudD-EerjalZPhDTjOlcs4Rfm0jJEnmF9NW-p0OFu7rl38gA>
    <xme:vYXravi5zECS6_Ni_lqJsh5FPIf5Ml7P2WWNb8S2N5FAAGxy15foj0X3iYCsfagkt
    KQOROYAZ4vwHIBKTVh7fYz6xgt2ZK9IUM1XW8-vuevV9kEcewFtnA>
X-ME-Received: <xmr:vYXrahONHi8AoH4IqxvTwnT3rip_U5i9iRqfrpS-s4Ud0RWW8MNpre0Q>
X-ME-Proxy-Cause: dmFkZTGy31GP/KduaZWiKYgBvsauRY6luObGFvalVy6nExLlbSWZ6gm4DOjXH52CMooTLU
    v8znwKbr6Rap9jyw+h2xMJulQMZ7Z8O8ryBgevQHYMP6ujvxlH+195CuN8mUOPkrmkMkUh
    HwgygnA54qGK2vXhvKp2qcftEoF13cGvGGX9h0+wWuHr5Ym3tQjcyfU1CukrAgRdzmt+Cy
    Um/nVWsQFtfJHkq76nEX8kA5Dp5i2gVH/Jy0YYF+6+YGujVIbiL29ZJe+MbL+rsNGlAvgC
    hMLbYGeExM+D7NsL/0t8ukknVCGUVIe4RokuZ3Rt8kqDPOk8NruB1mJ64Qz5IPx59fU8s6
    1nwWIxubdq5ZeKCm0Y+0hTbZkCDZEKAAKcrWthW4e0dHFqi9ii/39w6SS6S6WT58aF5xXA
    0crJ3gEHQfeZtuukPQiDPusETssSKm2gc0o1Al41Lv5eItIcgGl/XHLyWbGO7uQxFJjvOj
    gnm29rpD9BcGYI9mHhZfruglP66KKtdH6bS3yZMTWe7kRkJl6ACxySMTRgF0UQlxt0KJH4
    j7wcwNzL3AJuP+hiCzYAZQhGlw7P2/6+Wqm8fmAaA+oYFnei5UYDkL74JU9fSYQm1OQOxz
    6UTWa8b3pvy8V12WQPXowSXHfDM842Jzq6SeZuQrqiCiWPe/hA+OFguaozDg
X-ME-Proxy: <xmx:vYXrav8g_eo4MPGePD2nR-sa91AqG4hVZF6cUfApQH0wl7wI3gMr9Q>
    <xmx:vYXraid3Q4lZ_7Fq8IZhzzJfffkR8h8bBFxNqGYJC9nhwpwTsCI28Q>
    <xmx:vYXrauylbutvgfL6rVWD12-Ju30Al2UkuVtx2N0555zrJCv_8kp2_Q>
    <xmx:vYXranKC3MuJQgmH6xG0OS1uYpQwuYfuamzERxx4kv6Ymm5w0rMDgg>
    <xmx:vYXras8WaErX8DIcVjHg_ExEVQh8VOsV5EMtqdHLvEmsEAeW_m-Ep2IY>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 14:21:33 -0500 (EST)
Date: Wed, 4 Nov 2026 11:21:51 -0800
From: Boris Burkov <boris@bur.io>
To: Siddharth Mishra <smish149@asu.edu>
Cc: dsterba@suse.com, wqu@suse.com, josef@toxicpanda.com, fdmanana@suse.com,
	mason@kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] btrfs-progs: check: count non-skinny tree blocks in
 simple quotas
Message-ID: <20261104192151.GC3301639@zen.localdomain>
References: <20261104102323.4090290-1-smish149@asu.edu>
 <20261104102323.4090290-5-smish149@asu.edu>
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
In-Reply-To: <20261104102323.4090290-5-smish149@asu.edu>

On Wed, Nov 04, 2026 at 03:23:22AM -0700, Siddharth Mishra wrote:
> [BUG]
> On a filesystem without skinny-metadata, mkfs with simple quotas writes
> a qgroup that does not count the tree block of the fs tree:
> 
>   $ mkfs.btrfs -O squota,^skinny-metadata $dev
>   $ btrfs inspect-internal dump-tree -t quota $dev
> 	item 1 key (0 QGROUP_INFO 0/5) itemoff 16203 itemsize 40
> 		generation 11
> 		referenced 0 referenced_compressed 0
> 		^^^^^^^^^^^^
> 		exclusive 0 exclusive_compressed 0
> 
> The kernel then warns about a squota underflow when the block is freed,
> and "btrfs check" reports no error, because it uses the same code.
> 
> [CAUSE]
> simple_quota_account_extent() treats an extent as a tree block only if
> its key is METADATA_ITEM. Without skinny-metadata a tree block is an
> EXTENT_ITEM with the TREE_BLOCK flag, so it is handled like data: its
> first inline ref is a TREE_BLOCK_REF, not an owner ref, and the block is
> not counted. mkfs fills the qgroups with the same code.
> 
> [FIX]
> Also treat an extent item with the TREE_BLOCK flag as a tree block, and
> take its owner from the tree block header.
> 
> Fixes: 5bd97022f384 ("btrfs-progs: check: add support for squota")
> Signed-off-by: Siddharth Mishra <smish149@asu.edu>
> ---
>  check/qgroup-verify.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/check/qgroup-verify.c b/check/qgroup-verify.c
> index b58ef366..d6681653 100644
> --- a/check/qgroup-verify.c
> +++ b/check/qgroup-verify.c
> @@ -1046,8 +1046,9 @@ static int simple_quota_account_extent(struct btrfs_fs_info *info,
>  	if (generation < counts.enable_gen)
>  		return 0;
>  
> -	type = btrfs_extent_inline_ref_type(leaf, iref);
> -	if (!meta_item) {
> +	if (!meta_item &&
> +	    !(btrfs_extent_flags(leaf, ei) & BTRFS_EXTENT_FLAG_TREE_BLOCK)) {

I sort of think lifting this higher to make simple_quota_account_extent
check for "is metadata" vs "is metadata item" makes a bit more sense.

Either way,
Reviewed-by: Boris Burkov <boris@bur.io>

> +		type = btrfs_extent_inline_ref_type(leaf, iref);
>  		if (type == BTRFS_EXTENT_OWNER_REF_KEY) {
>  			struct btrfs_extent_owner_ref *oref;
>  
> -- 
> 2.54.0
> 
