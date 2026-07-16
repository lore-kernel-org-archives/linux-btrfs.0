Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156B2347537;
	Thu, 16 Jul 2026 16:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784219041; cv=none; b=Wl+m5C5eD2YvpQkGrG5pHGM86tyBjSdZDDmuzeAZtlw9VwfblXJUbEmLeen+crpZ1EQS4USM9aAoVFyZvmuKhS6wM6rljbQhFmF54Oi7WMW10GRlT/92lfAVXBgnXC4dsg9sVhaXWcyxvjkUdbJNuCeb0HX4+j4kIrvyxLapCiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784219041; c=relaxed/simple;
	bh=Bms5EDbmnWXQRHmtaZmCawgNpyUgkCpj5UqdU1fBgKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ene76cXrNtjo5uaZH3hR6lHqw/lQ0fC+dAX70bBLC0GXeykG9U9UIybTcQvEbnVkUEuOzewOYrb3X5Bt7bwHEJNF2uB9fuFqhE51Ibr2yfGwqxEslqc4VXz3Nf4BLiP087+O7odb30qwyuxA0faAoAnbWEKdajQw+dEpycYx3hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=BMZZrmE2; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ElU4m75N; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="BMZZrmE2";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ElU4m75N"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 330F71400076;
	Thu, 16 Jul 2026 12:23:58 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 16 Jul 2026 12:23:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1784219038; x=1784305438; bh=KpCNfkrxoy
	UX23CwWt1xfaC7RL/4HASoGRcBNnmkktQ=; b=BMZZrmE2XdPD9VRyPujc5JB8hs
	gkRBWGXHDKqeT6rScOoTbFWUU6yya/GLH5c1Eg8jEYI8xRzzeKDE4+6o0+LrCfby
	pFASjwXFz0/XoKH9iBQC4LFDgeMpEVLKSd0KdpEHafcwRM3aEMwIvvZvxH0eqe62
	hr6hUtZEIOoYmjlupNdr3sSzAHSyZ+XN3dYbrwjV7dAJ+vp5BTufSgcVPsC2Obnj
	nqVCQ2E6jsbdmdOXO0JoijVCA+KQQIPxGEew6pCAiYx32yfXwfOYs7tOCSNd1hpo
	lq7sSyS5MAGzLa66JrFccQV3JMv+sco24ta7QSYlfofsBVX6Ug0LOy8FHP/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784219038; x=1784305438; bh=KpCNfkrxoyUX23CwWt1xfaC7RL/4HASoGRc
	BNnmkktQ=; b=ElU4m75NkA6dWmWcltZ6D9oCAzokuEz0nocc7O+WvW0Csc3X5PB
	OalsgnJA2SgSqILKL6OA+AiQT39OfmxTqbfW81ibSgn6QNTZix3JwzS+f+RVfVSx
	ovjoScnfJsWzjMguVCzjKWBvqEcJWN4KaK4LDWSgmRqmuYzYO2rDIEkz+ELT/TXI
	DuAXdelyUnZIkteQZ8pJF4QjDAZzrIza9LVtGoqO55NJ7VMkt3IZnXpSfFMFDfpp
	gJnXUPgoMwxKNE176LiKqO0LAs1jb1kCJRsB1Kz9u6hqYWHo0D+G2mYZueDE3uwN
	wwqIYpaf2qvEUvyrRACuwmak3BtI13aLs9g==
X-ME-Sender: <xms:nQVZar62nhYiRx4ojD0JHU13t7ryT-1eyRDFYu9h_RakUgKcKLVs0w>
    <xme:nQVZaqPy11jjJkXwRT7NEiDHBpiq3-L9XRU6BuLaUosW0IgmtKNEoYvVx2lQdm163
    aTQhtvz0_3K70psAtkNbYaeK2lOzq6QQhRXxELOK-Ip3hC5hxeWScog>
X-ME-Received: <xmr:nQVZapuQqkYjnTwGN_A-92hJ8zQ8Ew-E4h7DPKkSD7_bwR6pe2xJ8I_G4v-u1DQ9dtiRthsaJLhW0yjl3iOgtPSBycw>
X-ME-Proxy-Cause: dmFkZTE+krbDGQHkyGx79YZxqLzZonJOCAvsuap32/rDStdH4s5YDkrYCylW3YJajp8WeD
    Wxy5aGD3+x5lX64xH11WWFHIMDdQCui5q/atK7keBG0REGe/xnzIqnfOg4VGG/E69XNAq5
    wq5ie/PkcHtBEeTWrrhFjR4d8rkSJd6u+c0JTKm9MC0QYPlI64D6FMJ5PYuNErXhghfFX1
    OTRDtS/4bSbLc3WQWg8mxjWxws2jScb5uJNt6laYDk0X5B7uTGGeqGlonMEpnyGCTKiUTN
    da4S8AmPeH56sQrhthU8R235b6V7TtumvkKcInZAXtD/j6RGa8ANemTJ1uY3/omGn/toG6
    J/bj47MfMVepOxOqQTlD+hPkNC04rik92xVR1HutSJBVlLHSgvKrijwDr/daYedq22hTiI
    gislKC1If8KoSt19Sh/LA2g5Qpr8VpKHtf5DoUnWAUPN3wNONcK/LC/yLQeQhjTvu6Cgec
    DrDl7+QUctMrRipli1bWhEBGo0g0/a24v/8WiNyuyB3nH7VKL+it3jTzukJIKb+7utNbOA
    0ChABIMNSc1J85HRhxeVMocYMZgi+lRtUuSoZAYmySI9Aq9X34sjEmkYH+2M/3DLFo7uHU
    FyOkHCffLivOEL/cybSNXJLxifD+iU2s4XejaeHm5Im6tlDhcJ3vvGKNIxbQ
X-ME-Proxy: <xmx:nQVZatbynpzLzaUvSUtgRGNwlmc75mxYX4XPJWs8FHLSsvYBwhP3WQ>
    <xmx:nQVZarwfKv1mUJZz1zcz0-Gb40JbiGEscI7y9hv0bph0AmAF8Xc1qg>
    <xmx:nQVZalhvkOvc3nBLmP_BFaBs9mKGZ4OLKrq9PvQ3ge-gv0XzzZmFzA>
    <xmx:nQVZanlU7PBee7ZONLlW8p5HVow_W4Q94xtXBecj6qFowy935kkAtg>
    <xmx:ngVZajz-2Vcu1U1Nc2L_FK48LBw61URErjAqBvKaUVvTxZOiPTeyplOh>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 16 Jul 2026 12:23:57 -0400 (EDT)
Date: Thu, 16 Jul 2026 09:23:49 -0700
From: Boris Burkov <boris@bur.io>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	Matthew Wilcox <willy@infradead.org>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: add verity Merkle folio to page cache after
 reading it
Message-ID: <20260716162349.GA3278562@zen.localdomain>
References: <20260706053907.544337-1-chenyichong@uniontech.com>
 <20260707055517.570586-1-chenyichong@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707055517.570586-1-chenyichong@uniontech.com>

On Tue, Jul 07, 2026 at 01:55:17PM +0800, Yichong Chen wrote:
> btrfs_read_merkle_tree_page() allocates a folio and adds it to the page
> cache before reading the Merkle tree data from btree items.

So does ext4 via (eventually) do_read_cache_folio().

> 
> If read_key_bytes() fails, the folio is still locked and present in the
> page cache.  A later read can find the locked, not-uptodate folio instead
> of retrying the read.

I think the better fix is to fall through to retrying when we see a
not-uptodate folio in the mapping after __filemap_get_folio(), which I
believe is how the ext4 code will behave in that case.

> 
> Avoid installing the folio in the page cache until after the Merkle tree
> read has succeeded.  This keeps the failure path simple: the newly
> allocated folio is not visible to the page cache yet and only needs to be
> released.

I don't think this order is correct. filemap_add_folio() locks the folio
so if you do it in this order, you no longer lock the folio while
reading which is a non-trivial change. I don't immediately see what is
wrong with that off the top of my head for read only verity past eof
pages but it feels sloppy at the very least.

Thanks,
Boris

> 
> Fixes: 06ed09351b67 ("btrfs: convert btrfs_read_merkle_tree_page() to use a folio")
> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
> ---
> v2:
> - Avoid calling filemap_remove_folio(), which is not exported.
> - Add the folio to the page cache only after read_key_bytes() succeeds.
> 
>  fs/btrfs/verity.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
> index 983365a73541..d705ce3b386a 100644
> --- a/fs/btrfs/verity.c
> +++ b/fs/btrfs/verity.c
> @@ -735,15 +735,6 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
>  	if (!folio)
>  		return ERR_PTR(-ENOMEM);
>  
> -	ret = filemap_add_folio(inode->i_mapping, folio, index, GFP_NOFS);
> -	if (ret) {
> -		folio_put(folio);
> -		/* Did someone else insert a folio here? */
> -		if (ret == -EEXIST)
> -			goto again;
> -		return ERR_PTR(ret);
> -	}
> -
>  	/*
>  	 * Merkle item keys are indexed from byte 0 in the merkle tree.
>  	 * They have the form:
> @@ -759,6 +750,15 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
>  	if (ret < PAGE_SIZE)
>  		folio_zero_segment(folio, ret, PAGE_SIZE);
>  
> +	ret = filemap_add_folio(inode->i_mapping, folio, index, GFP_NOFS);
> +	if (ret) {
> +		folio_put(folio);
> +		/* Did someone else insert a folio here? */
> +		if (ret == -EEXIST)
> +			goto again;
> +		return ERR_PTR(ret);
> +	}
> +
>  	folio_mark_uptodate(folio);
>  	folio_unlock(folio);
>  
> -- 
> 2.51.0
