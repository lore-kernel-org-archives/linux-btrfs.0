Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC7D3803DC;
	Fri, 20 Mar 2026 11:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774005083; cv=none; b=oSVzggTGJno/z6XjaxN84PJhbsa4D739MgOQsJmqM1+6fiZmvxqFr17tr7J8vdfuboYvT18MiNGCvL3tE34mbGEdX0y1wdIuRKM/y5OiD4wv0PisnUXkoNAw0VuS5sz/7V+HnPyNYmhhvY8azVrWtQNzEEkivd3ewz3DbND5DO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774005083; c=relaxed/simple;
	bh=A992hxqeKPF/W35JOvXlABO04cpSDihuS3T2MUUqdaw=;
	h=Message-ID:Date:Mime-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uFQSckOud1PFLr0gdozBowTXW/NRf+MXj2Y5inTOMk8FF4G3tNH1MWf0OhmtDcWa5RoAhSR1dwbjcz86WEvZMtLeu4PwTRNTv9Zwf7KlqrutRt72vHmVvZobudzjXBJShLFnMutZHUgIEJ3jX3siI+F9yyadXxQoa0zy67gHf2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=GdyGMtWB; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="GdyGMtWB"
Received: from [IPV6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2] (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature RSA-PSS (2048 bits) client-digest SHA256)
	(Client CN "hellas", Issuer "burntcomma.com" (verified OK))
	by mail.burntcomma.com (Postfix) with ESMTPS id C0907312551;
	Fri, 20 Mar 2026 11:11:17 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1774005077;
	bh=hjBAIVRKoYzF6IB5krlHH6/D27oVrxXPE8aOIjpFFGU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GdyGMtWB2nrY8TWbNWVybQJEM8Ho1CsG/DvGS2TINIGQ1Dkcs8iHmKJskabgdwMZU
	 sYg0y7I+if6HzrVGY2VhUrv8Tdjjt5BRSDPW4RLeGtmNA9MtbXemaFrBLeO9LS4J07
	 JKF6GAnZNHM5hUyzY11FhCfC+jyZ7cN3z3RvmCeI=
Message-ID: <7a7f3bf5-da06-4fc5-bbf2-38eb9ad11803@harmstone.com>
Date: Fri, 20 Mar 2026 11:11:17 +0000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH 1/2] btrfs: additional gfp api for allocating compressed
 folios
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>, boris@bur.io, clm@fb.com,
 wqu@suse.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-team@meta.com
References: <20260320073445.80218-1-jp.kobryn@linux.dev>
 <20260320073445.80218-2-jp.kobryn@linux.dev>
Content-Language: en-US
From: Mark Harmstone <mark@harmstone.com>
Autocrypt: addr=mark@harmstone.com; keydata=
 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
In-Reply-To: <20260320073445.80218-2-jp.kobryn@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Mark Harmstone <mark@harmstone.com>

On 20/03/2026 7.34 am, JP Kobryn (Meta) wrote:
> btrfs_alloc_compr_folio() assumes all callers want GFP_NOFS. This is fine
> for most cases, however there are some call sites that would benefit from
> different flags. One such case is preventing direct reclaim from occurring
> during readahead allocations. With unbounded reclaim during this time,
> noticeable latency will occur under high memory pressure.
> 
> Provide an additional API that accepts one additional gfp_t parameter,
> giving callers flexibility over the characteristics of their allocation.
> 
> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
> ---
>   fs/btrfs/compression.c | 9 +++++++--
>   fs/btrfs/compression.h | 1 +
>   2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 192f133d9eb5..ae9cb5b7676c 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -180,7 +180,7 @@ static unsigned long btrfs_compr_pool_scan(struct shrinker *sh, struct shrink_co
>   /*
>    * Common wrappers for page allocation from compression wrappers
>    */
> -struct folio *btrfs_alloc_compr_folio(struct btrfs_fs_info *fs_info)
> +struct folio *btrfs_alloc_compr_folio_gfp(struct btrfs_fs_info *fs_info, gfp_t gfp)
>   {
>   	struct folio *folio = NULL;
>   
> @@ -200,7 +200,12 @@ struct folio *btrfs_alloc_compr_folio(struct btrfs_fs_info *fs_info)
>   		return folio;
>   
>   alloc:
> -	return folio_alloc(GFP_NOFS, fs_info->block_min_order);
> +	return folio_alloc(gfp, fs_info->block_min_order);
> +}
> +
> +struct folio *btrfs_alloc_compr_folio(struct btrfs_fs_info *fs_info)
> +{
> +	return btrfs_alloc_compr_folio_gfp(fs_info, GFP_NOFS);
>   }
>   
>   void btrfs_free_compr_folio(struct folio *folio)
> diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
> index 973530e9ce6c..6131c128dd21 100644
> --- a/fs/btrfs/compression.h
> +++ b/fs/btrfs/compression.h
> @@ -99,6 +99,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio);
>   int btrfs_compress_str2level(unsigned int type, const char *str, int *level_ret);
>   
>   struct folio *btrfs_alloc_compr_folio(struct btrfs_fs_info *fs_info);
> +struct folio *btrfs_alloc_compr_folio_gfp(struct btrfs_fs_info *fs_info, gfp_t gfp);
>   void btrfs_free_compr_folio(struct folio *folio);
>   
>   struct workspace_manager {

