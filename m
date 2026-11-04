Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.146
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793819924;
	b=oP6RbMl5njRncFotwggyeKeOQE4nL9/1DUxQPST5BM9ZnpRWe1+k9q2nZ7quveE+vWPO
	 TSN/eRFsWT6SVbb3H4vIvS2FePIZCXe1Fg/lMoHlc6+F6qg00es1ILNxU/005nlw3Qg6o
	 YLXL9ZCTvej4MP8YCuWdUGP3I5Z/nBN8ksB1OLROswPzYZd6Wwj9C5KRxWfN9N1zkSRb2
	 RyLfWOA4FGo32kvXIDzVON8rUxcCjye/4VDKIc6wGk7ntaRsASVHa8i87GRV2jLFAJQqH
	 8yzdv5v3Fo2zvm1in7Z5+vEFVkJ97l0fHj3aKlN/OejL2NuLxzPWF/+jNokYe13NuRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793819924;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=JxfhIPeIxkFAdErKoQ6yrSuREA1j/dL5rTygCr1xWj8=;
	b=q8Pbs2QXylUoIpHNbdvidmUwuetU/CzxU9jRssSOktOsciB5ICKwtT8Zqmc0ZvghYKrH
	 Y8JwEdStkIoNWCOs5pPji+Zke7aMabILu1D+qXyIn7QCg5smmeDjgLUiEyoQI6Z8bo+Zx
	 P4Ipog9hTQWdgRPkIIRWoprNy9seg28qpVN1LVnv1wuUszS1IlnoZKpoStNOoqWTfA7fb
	 mhJeFSW6DL62VrRaDfN8DZTYGxtk2V/CkLacgLtGIoxuFRuKNpXVRHIa1p/9XDkL8R2pN
	 ZpM1HJXrN4kjZEDvA+Z6iyBSVrIgN9TZ8swwUMTl+pmbLrhP0Y1QKLQECQrge2H0MRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=WI0CQ4Sq;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=nMOZ9alc;
	arc=none smtp.remote-ip=202.12.124.146
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72EA6083622
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 19:18:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A72EA6083622
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=WI0CQ4Sq;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=nMOZ9alc
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id C6E7F1D00115
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 14:18:42 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 04 Nov 2026 14:18:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1793819921; x=1793906321; bh=JxfhIPeIxk
	FAdErKoQ6yrSuREA1j/dL5rTygCr1xWj8=; b=WI0CQ4Sq7MEAF8ttKIivcXxdhH
	8ziGaIM4TGsOJ7vUIA8v83YsQkPIPRZk/4EhtC7CnUjsSKIiGXa6JgmLnNULxOWw
	WxtmNZdodJtPAUVddoDTOf8LGdfwE6872pYgDH8YlwDlKCG8ThqU0OU/PH+QL0TX
	a5I57zgsSO9YJjLJKiCzdXCM1R1jyLrx0/uNWpNaxeoz9a+tsv4hqpeZ5iqKAxAq
	HwJPOjvGxkElyhFQXW+caDrhRUD3zzcS2yOAJ0ZQ/1/lD9+0EbFmUN78Ki+nxcqQ
	y0IFYCVzNS8JPB7RNMxuEt5v5n7PB3/9etp68Npi/CnPP6C31betueTU3dMg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1793819921; x=1793906321; bh=JxfhIPeIxkFAdErKoQ6yrSuREA1j/dL5rTy
	gCr1xWj8=; b=nMOZ9alc9DM9NvHnGx8vLdb+MWdOpbhc03Vd5YSDXqOjsh8yRKV
	UiXfQ7gCGj0TtFPvc1nwvG1oA3WK91ecO/WK0Ff00hejZA4ZEqG8nwfITa9/IsPs
	fAr8cKYImOmr/2dsEx1RHz5UC8leAm6KnO7bWvg6SwZILVtCvmNmkE+jBmTkkfFs
	bF4kx/S9085nh6HWAdOECOryQudxVNzI8jlmIcvlCOrv0L7ozKZkqAt/LWPnUmfJ
	oLs5sPkaMZXO8HHBggpL1HSXomEeEytQ4Q3aC4DEynY4dGfAQLqiFs0D8qOIlLcS
	71jsgv13M8UwxYCHwyHD3RrakiOXmSr9RUA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793819921; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:J4qszeRfe+d2XhbTnEzJQ2MgO7Wh7wAZJdjrbjmGFThCdHP
	P6LDG6+9+4M1oFtFAUwI0wu7dnDCkWpjFfD2LSGnEN+P86LsRSuo74AggbJA+qRk
	e+cegSbk6kcp4XeFHIja75iGdStX9PefHI259dnGzrujuBaeCQCqxP1RoVrh0BaV
	QoL5JmuyR0s9ehNKjEN4evg1yz9vdezCMaFhje82ARIn7g0e9eLyYn/DwsyoKqgK
	W2zO524nlQYdK8SmB4jHyU7warfGPnSJ+euPJTZCbgApbu+91ZzU6I88Uf2zBA/c
	qfnZQRA32UpDafR9uI14sHL0/u2FaPbM0qn2sGQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:vmR69CKoQvJ4bZoQC2FHgm6lcS1lA/fTwjtOmspRMeA=:ROuSBoRkH+KGDcPKIGGhvwJkrol1DQhhQ/RIzlUcuZk=;
X-ME-Sender: <xms:EYXrau6exnkFenBHAWTNHPd1xy5OgV6f1nRE4ZWcgEKG0MmvSOymtQ>
    <xme:EYXrah6drKguWU2fYEimDh6wbZVnHGZSFaodVd0mP9rDSgNIgyVs0QpCTn6zmIFxU
    QOBVzgZ4fgBrL9EwqCAqbgvUMzcDbyhG5R-OxyKmzisLea99vr-THU>
X-ME-Received: <xmr:EYXrakFojupWDdGWQp0ftKYh-B5KwJxQ5xtyYHdnAGE3tIBJBzkhuYq_>
X-ME-Proxy-Cause: dmFkZTEJ9AEUj3zvDx+Ww7+k50LadtebgOG0HFBgjaCqCpB/SFTcQixmu2fpsdzet5RKBT
    sgYv+db4SD+TcoYBWWR0KkA5gYBJMFZK1+BBdnkgyelnEnp7ptpxfEWgDNlPu1nifBRRn4
    aHiTovqx8QbP9En4hRl4vnOMcXjBEmu+mdLIoIoUZ7rtbg9fnXtRF3vtt+/3t1pSKSf21+
    vZfR37SAZ9DFHcXs1rLNTbcH5Z7k1WUZSSVkaNdsLx9aUEKx7wa9gDC17iIhEctFQl6OuT
    3IEWleOgnwDBdmrBw8CB0h8Q4jAjCImlOPtsdF3Qt3vVIYeiO4YLBMFyZw/WmWGJeQvpIG
    nfaq19XnA4U9LwUY0ivBTye0cZJ5Zslk+CGk6GEvXn8aw9ij16VRWxBOy+jZ8WXWqP3Hfp
    VGSuLShurX4moAWwvGcDJoWkU1yhSavAGzpfaXmXDO2h8ycM8ryQnfkkwJFihV8tN4P9d7
    /2AKaVFrPmWxCvyZC8o21wVaCG6KGv7Y7TocKIv2Ne31Oc2QTaKSVAUSxqvThltNR3r/PE
    nx+URxL22jwzJ1/JQRIPYQgdyce+NZdhtxtr/78fSr0uZhoPBZ3Sq0fA6ixpc47YRcJGbI
    kwj0e756NJSVQUJWzVt0eeVFX47YFxcLBNZ1wrVYaf3Pjv0KTUPKt2sv4q+w
X-ME-Proxy: <xmx:EYXrapXH8CrGJuD9g3Z081lofSDKXYV_EFMvwC2LP7anZqaNol4XhA>
    <xmx:EYXragUp9FHf5lYov1AEELO0NYe-84DxWbmBWbdpUOeHqiefqjpZwQ>
    <xmx:EYXranLVH5vgQIi_YVqCqF7MGzCmxFiC-K--_ETyH4AYNTrCdvblcA>
    <xmx:EYXraoAiiM6PF2jSEU4N0cgrP5o9r4Tszm0fCmsTJRZbb50DNL83fQ>
    <xmx:EYXrap3nvKtEXl4OItYoUvDt7YcaZSkxT7Q9_Djt_Pe-4y6Gx9PvRpWF>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 14:18:41 -0500 (EST)
Date: Wed, 4 Nov 2026 11:18:59 -0800
From: Boris Burkov <boris@bur.io>
To: Siddharth Mishra <smish149@asu.edu>
Cc: dsterba@suse.com, wqu@suse.com, josef@toxicpanda.com, fdmanana@suse.com,
	mason@kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs-progs: tune: do not remove owner refs from
 tree blocks
Message-ID: <20261104191859.GB3301639@zen.localdomain>
References: <20261104102323.4090290-1-smish149@asu.edu>
 <20261104102323.4090290-6-smish149@asu.edu>
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
In-Reply-To: <20261104102323.4090290-6-smish149@asu.edu>

On Wed, Nov 04, 2026 at 03:23:23AM -0700, Siddharth Mishra wrote:
> [BUG]
> On a filesystem without skinny-metadata, "btrfstune --remove-simple-quota"
> can corrupt the extent items of tree blocks:
> 
>   before:
> 	item 31 key (30756864 EXTENT_ITEM 4096) itemoff 2363 itemsize 51
> 		refs 1 gen 6 flags TREE_BLOCK
> 		tree block key (940 INODE_ITEM 0) level 0
> 		(176 0x5) tree block backref root FS_TREE
>   after:
> 	item 31 key (30756864 EXTENT_ITEM 4096) itemoff 2372 itemsize 42
> 		refs 1 gen 6 flags TREE_BLOCK
> 		tree block key (0 UNKNOWN.0 1456) level 0
> 		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> and "btrfs check" then reports "backpointer mismatch" for each of them.
> 
> [CAUSE]
> remove_owner_refs() takes the first inline ref right after the
> btrfs_extent_item of every EXTENT_ITEM. For a tree block without
> skinny-metadata that is the btrfs_tree_block_info. If the lowest byte of
> its first key objectid is BTRFS_EXTENT_OWNER_REF_KEY (172, here inode
> 940 = 0x3ac), the tree block info is taken as an owner ref and 9 bytes of
> it are removed.
> 
> The check for an extent item without inline refs is also off by one: it
> reads the type byte when ptr == item_end.
> 
> [FIX]
> Owner refs are only added to data extents, so skip extent items with the
> TREE_BLOCK flag, and skip the item when ptr >= item_end.
> 
Reviewed-by: Boris Burkov <boris@bur.io>
> Fixes: 2336a7b921ff ("btrfs-progs: btrfstune: add ability to remove squotas")
> Signed-off-by: Siddharth Mishra <smish149@asu.edu>
> ---
>  tune/quota.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tune/quota.c b/tune/quota.c
> index a5f7fb40..187ba4f6 100644
> --- a/tune/quota.c
> +++ b/tune/quota.c
> @@ -132,10 +132,12 @@ search_slot:
>  		if (found_key.type != BTRFS_EXTENT_ITEM_KEY)
>  			goto next;
>  		ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
> +		if (btrfs_extent_flags(leaf, ei) & BTRFS_EXTENT_FLAG_TREE_BLOCK)
> +			goto next;
>  		ptr = (unsigned long)(ei + 1);
>  		item_end = (unsigned long)ei + btrfs_item_size(leaf, slot);
>  		/* No inline extent references; accessing type is invalid. */
> -		if (ptr > item_end)
> +		if (ptr >= item_end)
>  			goto next;
>  		iref = (struct btrfs_extent_inline_ref *)ptr;
>  		type = btrfs_extent_inline_ref_type(leaf, iref);
> -- 
> 2.54.0
> 
