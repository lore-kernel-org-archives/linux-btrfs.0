Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368084DD3BC;
	Wed, 16 Sep 2026 17:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789578399; cv=none; b=RV2FQGpmzGQp2grepqvgiar69M1bvEsvdL0OTM+LbaKdaN5N/ey+TRSF7WNxTIO+KnFcO3pJ0wzqd/JlLQDlWN6CvTRmDkBh8mHwsvMfRpsuipSebgu32vOrgkIOQfq4efhixKgclVJSd0nuAYKw31/MBVmV+eHQjEMLgfUS5Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789578399; c=relaxed/simple;
	bh=DyY92omELeVm4uig6i+GjBD9Q9GrgbPw/Jz0OIMI+po=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FE/nCfSxCvP03L65DlnVzx4QmZ9Ry/32IFzGN828EYf5A5NfGPeVRfFAJXSRSP5afRvkYrp/3PC2qOc1RTEps4YkgWNX0LtMfhwUpOXDQjFkOlmE/Hsn0K+snTaS9Bu3s8le6qfltl5SnrKNrBP8HMwTeTJyoDQP14Vc2YaAZMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=iFka4FzJ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=LfM0GQLm; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="iFka4FzJ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LfM0GQLm"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 5FF997A00CE;
	Wed, 16 Sep 2026 13:06:25 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Wed, 16 Sep 2026 13:06:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1789578385; x=1789664785; bh=hNqcTswGdS
	aEycTRiZCcJRFbsIJyY2y4r4eY6uKvk3A=; b=iFka4FzJpSnobQ2OgALU8//U8r
	J7P2iGzvTgZ34wp64ENKJ5m2Zn9tCjaxh8Y7w4KzIsFvCIWPkD80+T9PZBbXb27K
	Y+Cix+TaHU+00dyLdw23fEELvKueZEADeClcl347MvwXE70kNVvifw1ceiC/tAYR
	VZSaUtSfpviK5GB+0J2/6y8tSJrpvp9CxFwBn5S41wo8K5B92D8mpB2HsP5fAW5G
	et5/U2hTayzIlJaDRhxQ9nAt/kWdeq1s3oV7mHt6aGkOSUyxh+A8kTNs1VRDn17Q
	y9BidGYJ/3FGCMwMjMY6lZS1qgFjA9wi1jdkuPUNl1ZA6HrRb3OLzid5LhCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789578385; x=1789664785; bh=hNqcTswGdSaEycTRiZCcJRFbsIJyY2y4r4e
	Y6uKvk3A=; b=LfM0GQLmQ/mWMJ+c+CJhU4UvFaOZe0t5frBtRnDTcKAfqc9heJT
	kn1H+RGhOw4p4z3pubdLl7a74976AEdmotSyfW1tgJvAOzHEkijZzZyXl7ZN9SqS
	ZwFcrYUoQYm0GZ5l5YT82wK9YC4c4hvVwg6ht5CaQxyw8cAJsApJREr5hp+TMKRM
	yyqYksX5sjrp9xUs1BjiSHh6+1OcDh6vHmJEFL28UlBoz5sXSjL2kcMgEZmanbBt
	NSxyAZJEJDSI6Aarx9adHEb6KXr7eJMRuBEtBhEGnCJXmsqdXYCTa7OGD9ZYuekS
	ggOS/ukSer62hwGk0pleO9RCXZCLaaNXdsw==
X-ME-Sender: <xms:kMyqas9FRHTr2v68UZGoJ6mzsMaRoe_8ZyMFtn_vztPdTahWII-8XA>
    <xme:kMyqaguxVZX9gOm5GM_MUaNn-yED2Rm-hWNprKfqo-6l_X7MZ9IRP8Pjr8Pe0tkPN
    GaXfX61UfQh8PlM2zONyeL-_lQ62tfQl17-QGp13l5vs2VCz8x0rw>
X-ME-Received: <xmr:kMyqakOUc9U4Ou7C_HsotxVBVqGylKgAJ-T5Wrk4uaHVR6W7pkEmaC8>
X-ME-Proxy-Cause: dmFkZTGOX0kJKhjnaGk4qwvxs2aPGu2AXSr7Vp8bf5VKuF1lRuq6CLCjw6NcKgoKzEM0ck
    I/TziC5znurtx/cmr5m40rZi5egdG/l06WlL1RDxXXC4P/jHpzHGCsbfSCSc+NkTnf6CyZ
    kvEa8B49+g+2WKa00JAPkJa2re2OqLkGQzGfRE7r5R3C2Wib6LUqX9dUfoAr0U1NJvCcOa
    KOFNBPiP+CLiL9Gbj12ubSfsV8Fm41ddcCu++WKpCPQBgjdHBO1mIr33WwATKN64lGOYQX
    UQO5+HWJkp6W9wDRfbhf1jQtg9pXUNZ0DnhteoGpEHGW/IA/Teu4daQzpnxdesIpGayHPJ
    gruWHAzSCHP+/diRhF8vdOUH8cHAzJzgtBMB/2yTwI46Le/DVUWq1wtAnzr/6VRepRFGLA
    uwN/t757GmUBLeWz3LKMhCaAgD6/0dCCJzeaeXKnqRyoRYlo2xcBOSGKPiITjuoYEWiNMr
    GnLAkbyURJTCX8SvAPBZDohOOnUsoyt8Np8ApHDAXTFlE1+738emXaG4c7Xd06DU5lS0o9
    I8CllK6XzxTuYpWINklIlHGyUfrtw/GG+cByv5DWYA+8xu5+u/DkU2NHaJA96HiapP6+F9
    IZ41rdW+qrkbCSDLHGirHK5jRyOrPt3Ggj3SXreIK/ZgMTlAYyPx3PIMY9KQ
X-ME-Proxy: <xmx:kMyqatgy4rPcmSU7j8ET-wspilNETceLiKsR5EkA4ZQPLs4LLczEBw>
    <xmx:kMyqau6KO4doAYASntBggeVdK7RnIWSaE_KbpbN4rS1XOZAK895vYQ>
    <xmx:kMyqas2wIJj0ADnKWCRdDA9NipxvxzvJu4Tum5VYRNAWtl2VwsPCtw>
    <xmx:kMyqahulP2k5MwrKzhZwg3A5KNMXCw5lgKM8o0UkJzeOewPoLjhe5A>
    <xmx:kcyqanVJBjTrAPtHR5tN-MsmpHMnqNLIsyj4sMEtMuCvzLY7r5bNTC3u>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 13:06:24 -0400 (EDT)
Date: Wed, 16 Sep 2026 10:06:39 -0700
From: Boris Burkov <boris@bur.io>
To: Guanghui Yang <3497809730@qq.com>
Cc: linux-btrfs@vger.kernel.org, wqu@suse.com, dsterba@suse.com,
	mason@kernel.org, fdmanana@suse.com, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: clear free space tree creation state on
 rebuild failure
Message-ID: <20260916170639.GA1491164@zen.localdomain>
References: <tencent_705010B6315454003C478AE79E1F215E6E08@qq.com>
 <tencent_17320F87E281276888825B1844508C179506@qq.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_17320F87E281276888825B1844508C179506@qq.com>

On Wed, Sep 16, 2026 at 05:16:38AM +0000, Guanghui Yang wrote:
> btrfs_rebuild_free_space_tree() sets
> BTRFS_FS_CREATING_FREE_SPACE_TREE before rebuilding the free space tree.
> Several error paths return without clearing this flag.
> 
> The transaction restart failure path can leave the flag set on a live
> filesystem, causing delayed reference processing to be skipped. Clear it
> on all free space tree rebuild failure paths. Keep
> BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED set, since a failed rebuild leaves the
> free space tree untrusted. Callers must fall back to extent-tree caching.
> 
> Fixes: 882af9f13e83 ("btrfs: handle free space tree rebuild in multiple transactions")
> Cc: stable@vger.kernel.org # 6.14+
> Tested:
>   xfstests btrfs/015 btrfs/032 btrfs/104 btrfs/131 btrfs/352 (pass)
>   xfstests btrfs/quick: 261 passed, 30 failed, 90 not run on
>   Ubuntu 5.15.0-60-generic
> Assisted-by: LLM

Reviewed-by: Boris Burkov <boris@bur.io>

> Signed-off-by: Guanghui Yang <3497809730@qq.com>
> ---
>  fs/btrfs/free-space-tree.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
> index 1b3d82ae3de8..b7a4a6ade30f 100644
> --- a/fs/btrfs/free-space-tree.c
> +++ b/fs/btrfs/free-space-tree.c
> @@ -1353,7 +1353,7 @@ int btrfs_rebuild_free_space_tree(struct btrfs_fs_info *fs_info)
>  	if (unlikely(ret)) {
>  		btrfs_abort_transaction(trans, ret);
>  		btrfs_end_transaction(trans);
> -		return ret;
> +		goto out_clear;
>  	}
>  
>  	node = rb_first_cached(&fs_info->block_group_cache_tree);
> @@ -1371,14 +1371,16 @@ int btrfs_rebuild_free_space_tree(struct btrfs_fs_info *fs_info)
>  		if (unlikely(ret)) {
>  			btrfs_abort_transaction(trans, ret);
>  			btrfs_end_transaction(trans);
> -			return ret;
> +			goto out_clear;
>  		}
>  next:
>  		if (btrfs_should_end_transaction(trans)) {
>  			btrfs_end_transaction(trans);
>  			trans = btrfs_start_transaction(free_space_root, 1);
> -			if (IS_ERR(trans))
> -				return PTR_ERR(trans);
> +			if (IS_ERR(trans)) {
> +				ret = PTR_ERR(trans);
> +				goto out_clear;
> +			}
>  		}
>  		node = rb_next(node);
>  	}
> @@ -1390,6 +1392,10 @@ int btrfs_rebuild_free_space_tree(struct btrfs_fs_info *fs_info)
>  	ret = btrfs_commit_transaction(trans);
>  	clear_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
>  	return ret;
> +
> +out_clear:
> +	clear_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
> +	return ret;
>  }
>  
>  static int __add_block_group_free_space(struct btrfs_trans_handle *trans,
> 
> base-commit: 587858367581b9c55c3690f4e63382ad622719d4
> -- 
> 2.34.1
> 
