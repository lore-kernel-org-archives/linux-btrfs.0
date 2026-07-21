Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5ED1415F10;
	Tue, 21 Jul 2026 22:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674558; cv=none; b=WKS8OFnf1GjckRBb3hZguC3pdhIfOAZd9rV2J6jQ43JOWQj2+hcwNnIRJpR5Ut1ITish1FGt2FnoPxIftl7FqvTus4svdeYJjCW+agFDJNf42wlGsCzWhxc96AtRruu2+IIqEoV0raZhZS1ikCFKLvRYSNPvIX0+LR/UwxpiTrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674558; c=relaxed/simple;
	bh=tM/BCv2CQq/ORLJdWaH5bhF1GV8bGR8p0Wwgd+wHgcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q6LH4CbjNzwFuRtYS2MYeDpRyufG3oF+z88znrtRA6ZQgUqI+RwbCYbhHN+2fAZk6jdxfUo48zBBpm45ngSS2zETMrDycYUWjaJEShlpfZYYFvBdqSCfU5bz6UMKC3AGDyVhfM1SkfnTYW/QmjepxGWmGAcuLLNxHIKWYswMen0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=ZxoxXa5A; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=EEy2ZV5J; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="ZxoxXa5A";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="EEy2ZV5J"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id CF8741D000F1;
	Tue, 21 Jul 2026 18:55:55 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 21 Jul 2026 18:55:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1784674555; x=1784760955; bh=zs/gxexyoL
	oB/q5D5NvIaAeMDA3y9jkOxCDROa9ZTvE=; b=ZxoxXa5A/nV+hLCn9Beibe/NX7
	W7LT4SWfbMbVBfLkjUm7EmWYhyGYzYjKLgWVRXGsAp7rHngms/rQgsof0bSAf5kw
	ehidPz+OHiy05z8BxmzpXkAabzUogWrH2eGpVbulwz9xDOa/xPKVZn9BDQRG37X7
	zFvhoy3p3BbuOjpajnu5GoxyUCSgt3uTUVutu8oRID8r8p04sUyWD0swH6MKGfJk
	KVF4lC1RDYfmCp3MGAddNdbPx+yVj8PWta4Fwazu8w8YWI7JLRMbI9Km8NWgCIvb
	VJGtyNfwKd7S9aBHFwGqWY2BjRUPYUgCWY3m/EaAozF7zIbG8y5eEAx685ww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784674555; x=1784760955; bh=zs/gxexyoLoB/q5D5NvIaAeMDA3y9jkOxCD
	ROa9ZTvE=; b=EEy2ZV5JUtXUdlZrtFxyiCgkH7DqJYgdsWlDjke5/MRgPvRBRmN
	f6439PrQNWZwtqfpHYiQr61GTghD5OHpfojEzsdT7PxmIOZ8Je00zMRCLWnGaOio
	nJMO+mkckuLfjn8PuSNnssnDHW8wsOi85Werpg7hG1UyulCAwIg35/GYyVF0HFQo
	3caERUs0lanFCov15KZI/vELFhwmjqamTjxXdlyG59POXHDDjXKJ5F+qcj2dnHBK
	iaatyRGUWRIjRWhayOo5/HQ2cT9Jc/uJF04crRnqF6Wx7JPPuhWyr6apbsdbfBmM
	QggnRV/fY0AvyYMCz1L1CGAT/XSAX3mAAVg==
X-ME-Sender: <xms:-_hfauWiAp0a9fAMnGQfIv2lzktOoEjyLC7t56ZxIZgpNWnwdTkZ3g>
    <xme:-_hfaj6Jgt0WNwn504Eb0pRiDV9vMNv_MMai2rz7_7YAi-t9_02DVZDbHLl6XsmXa
    Dz4PZtPoMBc1aIqCD1SFhPKr5ZPkIzELU7j4Ko7FDyONiJyt7lNesay>
X-ME-Received: <xmr:-_hfapryf0c6_EORtAS4NdrGxzHSTPOWWmhyLTq-9fDMXDhzwOk1Jfuxijqfm6_lJ9nzninFgtx47CVFDdDBc_y-lr0>
X-ME-Proxy-Cause: dmFkZTFlpAfmrSaomoSjOggapVvURcf7jZCr7hK89fdxIV0moye+wjV1H4aeZ/mHl9FKdn
    VePN62H6Dr27AhFDTSF/qRPtgCiYNK6w50ft9PFNW/5NmIvQHBwT3AAyf6hcQeV8YnBJzu
    XIcBEt+m4mL9j9Klm40UHj03819GdDgIb6wXR/PEMfRQSnCV3XfYuzIWxf00hu62eYSsrd
    tKzrfpIVEfAmXSkpeV6kcw/g5tkZdY/YJTyy/TpANsrbZXTSjkElOJYIU03FwBsM9VkQe1
    c5NuDSkajKCWTqEITsPJW48+zap7OHu8R83JPWDlYnYelr+iSjRXbTlN/Zgju87ZUpParD
    WUxQVNEJiYcc12kYdm68XUgcq7d7pJxuGtn3oU4k/N1Lh01KfdjjnQcivpk85x+NK2kfbF
    cahRpCZ62baVwcxWQi4SxNqRS/mHWIF5Humn8HfrokMdvyoAVWRrKh8DDGa7ulQBQg2Zqv
    mxkaul4px63Mrqzpdgm+khS9MX2I72ZulPKacNCRNbNp4tYsQY6fK5y9GmkhOVv5Tgaowu
    5LDcVNFVnhnIrfI2yMUNBQFhhmEV4+eVIwB8xTRnuu5RgEKVHUuLLIBOBqDqmpjelPmZ5H
    3cTTE0F+AQSb02qEhLGi1ESz4lZBZKnN0Ptt1h9MPoN+gXuyOppr0U+1aXcA
X-ME-Proxy: <xmx:-_hfamnGmCbc4QzyIUCLZI8uD29791gRYbsnyZA0283Cb-GhxTYl-w>
    <xmx:-_hfalNHI7YmWm_Hlo_K4o3yGlXCzHTB-cdASPxxyASXJ0HP36b1qA>
    <xmx:-_hfaqP0a_gGzwkxZKAmzTt7k0_shyPQQ1uqBXZ8kOChWeaTttX7EA>
    <xmx:-_hfamh3SY_0Q2a-9mDVAq5NF8cq8XwfhJlRnkMh8Ls56KgfxpptcA>
    <xmx:-_hfarOwPzaD1VKx2wv5Zsik92U0132dnXuRcBSxMHxqbfmfyBpk2TTM>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Jul 2026 18:55:54 -0400 (EDT)
Date: Tue, 21 Jul 2026 15:55:47 -0700
From: Boris Burkov <boris@bur.io>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	Matthew Wilcox <willy@infradead.org>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: retry verity reads for not-uptodate Merkle
 folios
Message-ID: <20260721225547.GA3719379@zen.localdomain>
References: <20260720062820.1386340-1-chenyichong@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720062820.1386340-1-chenyichong@uniontech.com>

On Mon, Jul 20, 2026 at 02:28:20PM +0800, Yichong Chen wrote:
> btrfs_read_merkle_tree_page() can find a folio in the mapping that is
> not uptodate.  After taking the folio lock, the current code treats that
> state as a read error and returns -EIO.
> 
> That can make a previous transient read failure sticky.  If the failed
> read left a not-uptodate folio in the mapping, later callers find that
> folio and fail instead of retrying the read.
> 
> Keep the existing page-cache insertion and locking order, but retry the
> Merkle item read when a not-uptodate folio is found in the mapping.  Also
> unlock the folio when read_key_bytes() fails so that a later caller can
> lock it and retry the read.
> 
> Fixes: 06ed09351b67 ("btrfs: convert btrfs_read_merkle_tree_page() to use a folio")
> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
> ---
> v3:
> - Keep the existing filemap_add_folio() and read ordering.
> - Retry the Merkle item read when a not-uptodate folio is found, as
>   suggested by Boris.
> - Unlock the folio on read_key_bytes() failure so later callers can retry.
> 
> v2:
> - Avoid calling filemap_remove_folio(), which is not exported.
> - Add the folio to the page cache only after read_key_bytes() succeeds.
> 
>  fs/btrfs/verity.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
> index 983365a73541..25f021b04ce4 100644
> --- a/fs/btrfs/verity.c
> +++ b/fs/btrfs/verity.c
> @@ -720,14 +720,17 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
>  			goto out;
>  
>  		folio_lock(folio);
> -		/* If it's not uptodate after we have the lock, we got a read error. */
> -		if (!folio_test_uptodate(folio)) {
> +		/* Folio was truncated from mapping. */
> +		if (!folio->mapping) {
>  			folio_unlock(folio);
>  			folio_put(folio);
> -			return ERR_PTR(-EIO);
> +			goto again;
>  		}
> -		folio_unlock(folio);
> -		goto out;

The filemap comment on this is helpful imo, otherwise it's sort of
surprising to see folio_test_uptodate() getting checked "for no good
reason" twice in a row. First outside the lock (presumably to not bother
locking if uptodate, so that one is an optimization, then we have this
one after we lock to be certain someone hasn't beaten us the the lock
and brought it uptodate.

So maybe a comment on the one before the lock? Or here as in filemap.

Other than that, it looks good, thank you for fixing this.

Reviewed-by: Boris Burkov <boris@bur.io>

> +		if (folio_test_uptodate(folio)) {
> +			folio_unlock(folio);
> +			goto out;
> +		}
> +		goto read_folio;
>  	}
>  
>  	folio = filemap_alloc_folio(mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS),
> @@ -744,6 +747,7 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
>  		return ERR_PTR(ret);
>  	}
>  
> +read_folio:
>  	/*
>  	 * Merkle item keys are indexed from byte 0 in the merkle tree.
>  	 * They have the form:
> @@ -753,6 +757,7 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
>  	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY, off,
>  			     folio_address(folio), PAGE_SIZE, folio);
>  	if (ret < 0) {
> +		folio_unlock(folio);
>  		folio_put(folio);
>  		return ERR_PTR(ret);
>  	}
> -- 
> 2.51.0
