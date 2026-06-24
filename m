Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA95629ACDD
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 04:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782275246; cv=none; b=CW1LdR16JoA97ajn+zz/UBWIP+IQT6OHzV46aSWycawZeL7ygJ9+EeVflT/GjeHAFHqcJNX4NKa+ri4FddScietHLkh6GIZTyIXNq2FCciApfjshUDuBh8ISlxBp5Z84ToXzWwuwmVFaLYwwjXbOyQEL7dzwi2gUpE8S/QlIfoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782275246; c=relaxed/simple;
	bh=r7/45Lq2rNVBAz31s0eP7aRiEmU9924jFty03KaLXHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MlkyZvx4Azx56hYDJBBIRyq/fCSjFNs2MlIoM6TUXi0KKunBG/eklKV7deDHIhsuhFetH3KUV3kbJpY2azGOq73r8DkAhWk08OQvp94uu+NSwKm36Ms3jPf2F2n4RT3AzZiGLG5Rag59JAcCPd6P32BRFDC2IC4L5t5E1Zj4wbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=K5cZgm9Y; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=VyPnEhlO; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="K5cZgm9Y";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="VyPnEhlO"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfout.stl.internal (Postfix) with ESMTP id 3125A1D00043;
	Wed, 24 Jun 2026 00:27:24 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Wed, 24 Jun 2026 00:27:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1782275244; x=1782361644; bh=pcRtO+OP8r
	ZER/NxdyoXMD183srnZIvDvpX9m1VLG1I=; b=K5cZgm9YYSan2GYJg08NUdxOUV
	s106f/3uSNy/O221LCigBgqLoDB4qs9BrI1QHeTzB7Sw2pCg1dxeXU37ATnJSy2k
	MtrGlOrP3Hql0PWfIGY4+Q4NuEW8/tlEWivFrsu+dPNDHiNKzopQ8u0TVTuxztrk
	1FTWKr3eTXfM4K4erOPAnuyhAf4yYuGcZDLNGP4zYfC1Pyw9zbCGjDSfBK/H+/ZX
	UKu1eIJshpHFqt/uhlli1mj2ZRhRFSzLitFj8GW8CXHDIYkhhnqtz8OyZQnH7FeH
	okGsu86xexjKkGR/c3faKJeHrlDpRi5ScP6I+33gWLrkhT3j64Fs9d81FEOw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1782275244; x=1782361644; bh=pcRtO+OP8rZER/NxdyoXMD183srnZIvDvpX
	9m1VLG1I=; b=VyPnEhlOWHYPqoBmx4chVe61Gi5ShUhgDY9onqoIurfJLULPJqo
	GMa/5ZxdVX+aB0ChzpNtvp35yDAxh7yc/VyphiQdn1bxBDaO0Yt71C3oPryq19Cg
	4OmsP3zIHPrY3Gq0Qp6DpxasSl93KOf/0qZBIp/+0Efwa1oYIZMr8NaVjSvk2rts
	BBs4igoKmiPdZJ18ZyGJ4llnOMKs46R7mD8cn1WhlOQOd6trWu3CYhZpha0Ekw8p
	xC40qHXF+AlgrR1yvqDAZ+2s4Wi1QpCOlCc4JeZXjkTsqKWEsPzGvq8h/Q1h200J
	WeAeX3uUYoA1PUqGcqCh+vZ+k0HvLSnEyFA==
X-ME-Sender: <xms:q1w7apj2kkBjPD5MMtGqbvaNx9NqNvH-17DFsgOheEqrsxM24a2Fpg>
    <xme:q1w7akAu04Rop4we5axclKSsQXQIjG5ShVyIJdSTQWfKVZc475yFI1iUpN9KLUV8Q
    iC0C1FtWjQ-cqqeAPgbUam1M5EhIHLq7ARi8mLrOhdaX4slDs5xu7A>
X-ME-Received: <xmr:q1w7amsnwaB3PWM7IQ81POn9dNQup_XYDnQ-9bMjQfCsTKwMPaxcqEbR-lb1Q2sMaYleFwNnApOSCRIBYs1bvDfizBs>
X-ME-Proxy-Cause: dmFkZTFhlF/kZLTKoXfLfOsje0x2DKkquALKYxd6vjTke4ygBMu1PF0wdd/4Q3TE6ogtXn
    NzHqqKKdRxbaxydTAD8V6uc1T/kJuCo/wQW0ii8sURHqMsH0ScoWRXDpNpuRNLLysezQjz
    HroneCvdzeuF0M87WfWxFZsNu1bUTxzjJcXZr6okubiX0R9KMQkNCFpaAPlr/TMTxxx+sK
    tWJXCx93Y+BiH8V56TVDJt2ecD343AdaK8VxDKI0wTlnYkLn7dXvTr0y+C3eTL6fD3RCOl
    B48AQrk1Ly8lsc0WkT5cuaHO+rK3qqRBJtbTQLqd4J/MiYjmF4mhSLFYfWEQBGUHIFFLov
    oV2CvgCT8MD5qibB1S8qC1TBIBdT3u01xDUfnHDQWStLNARgE5mMiM4GIeVT5gagtmHXHi
    TDF0VScDqBgm9CO1CPCQWJ+1AKn7K/Ycz0fG2XZZME0n1qHP887DFVBp/OB4wQ9nerqggT
    YN3F6SCZ7eTJiUtZYmno7uwc+BdAqTwNQBoanHE9Bbiko61TrOkHYtikgHoowMMQF9/SnM
    mOdzSuF4sMNLtJuBHLrXXI1UNc3Oqof+EPh810OAoTyDE2jwX65q1FfcX2E3a0DLYSRdsB
    kLRRGNuKEfYwKGaLmhcQaXjSuWO8J2B7PQ30AAzD0d/cqDyWuwrN8pE3q8xg
X-ME-Proxy: <xmx:q1w7apYzJkRjkZ6QpfRXq9JIwCxkIvYNaaLKXZjdnI7Lj4kZLhuCUA>
    <xmx:q1w7apU4q-JMzK5XxcjhK1Xvlsp0M47RVbXtL7YkR8JmXQrR_jhc3w>
    <xmx:q1w7at7gsFTDrV0Ds4fjMVtdqHZOzfliRLBkio3BMOrrcAa801DLoQ>
    <xmx:q1w7akjlk6XCytFcTOpKJ93BUG11CtkzMycnLqrTS760AxTv6RG_gg>
    <xmx:rFw7avu8xDa_2sunJXyLb87EMfqf-prKR6RiOtt3v5ISg3IbWmEArgFB>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 24 Jun 2026 00:27:23 -0400 (EDT)
Date: Tue, 23 Jun 2026 21:26:21 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: print-tree: print header owner as signed
Message-ID: <20260624042621.GC2011094@zen.localdomain>
References: <cover.1782168847.git.wqu@suse.com>
 <20260622225540.9ZqL0Mh2J9h-lFv7N3RWN2wumRXixcik8a0xiNBBO-c@z>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622225540.9ZqL0Mh2J9h-lFv7N3RWN2wumRXixcik8a0xiNBBO-c@z>

On Tue, Jun 23, 2026 at 08:25:40AM +0930, Qu Wenruo wrote:
> When dumpping a tree block, btrfs_header::owner is printed as
> unsigned, which can result in numbers that are hard to read, e.g:
> 
>  BTRFS info (device loop0): leaf 8908800 gen 16 total ptrs 28 free space 1676 owner 18446744073709551607
> 
> For the above output, 18446744073709551607 is (s64)-9, the root id of data
> reloc tree.
> 
> Despite those pre-defined root ids that are already negative, existing
> subvolume trees will not have any negative values, as subvolume trees can
> only utilize the lower 48 bits, so there will be no output change for
> existing subvolumes, thus no extra confusion.
> 

What do you think about a macro or function wrapping a switch statement
that also prints the string name of known trees? What about some identifying
info like a volume path for subvol trees? That one might be a stretch.

Anyway, this is already a definite improvement, thanks.
Reviewed-by: Boris Burkov <boris@bur.io>

> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/print-tree.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
> index 87e60a2d4bd8..53e726119ca7 100644
> --- a/fs/btrfs/print-tree.c
> +++ b/fs/btrfs/print-tree.c
> @@ -449,9 +449,9 @@ void btrfs_print_leaf(const struct extent_buffer *l)
>  	nr = btrfs_header_nritems(l);
>  
>  	btrfs_info(fs_info,
> -		   "leaf %llu gen %llu total ptrs %d free space %d owner %llu",
> +		   "leaf %llu gen %llu total ptrs %d free space %d owner %lld",
>  		   btrfs_header_bytenr(l), btrfs_header_generation(l), nr,
> -		   btrfs_leaf_free_space(l), btrfs_header_owner(l));
> +		   btrfs_leaf_free_space(l), (s64)btrfs_header_owner(l));
>  	print_eb_refs_lock(l);
>  	for (i = 0 ; i < nr ; i++) {
>  		char key_buf[KEY_TYPE_BUF_SIZE];
> @@ -600,10 +600,10 @@ void btrfs_print_tree(const struct extent_buffer *c, bool follow)
>  		return;
>  	}
>  	btrfs_info(fs_info,
> -		   "node %llu level %d gen %llu total ptrs %d free spc %u owner %llu",
> +		   "node %llu level %d gen %llu total ptrs %d free spc %u owner %lld",
>  		   btrfs_header_bytenr(c), level, btrfs_header_generation(c),
>  		   nr, (u32)BTRFS_NODEPTRS_PER_BLOCK(fs_info) - nr,
> -		   btrfs_header_owner(c));
> +		   (s64)btrfs_header_owner(c));
>  	print_eb_refs_lock(c);
>  	for (i = 0; i < nr; i++) {
>  		btrfs_node_key_to_cpu(c, &key, i);
> -- 
> 2.54.0
> 
