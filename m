Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323F23B52EB
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 18:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784830738; cv=none; b=J2Az1ZWV60eoPSHbkWoGQyg4uRCBBKlym8slY3tjwJZ2O+k0Vng0SFTMGyxCa78cRIyhiCzNFLxB37ZUMA9cquMMWmF17gyYsatluuTnuLXvOPusdCwOefSj+VUpJ2qNFNAAdoGuOkE4uEiS4pFNGfscV7Ek/JKiIbxcx0QyqeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784830738; c=relaxed/simple;
	bh=ZgM8CK6yjJ2aM/G7AdPh+VrGbIXc6Cf4/Tt97rMg/S8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uxF3FjOtrs57dZODKAmsmRb8l9HARaE4mMQz7Ip/yGETjBwL7kkLM90SR+9v7feBPYN3WrnA0FgYb0dMKGyZhzjeaOFm0EaC3lshDo+E+9xJ1iS87K3y/tKgfPFJqnszHjXDOuVp3gU8HHm2OGb+9qbWLDkL1iVTQqQzOI6SmMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=MTwSA0Zj; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=KdNg1SSt; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="MTwSA0Zj";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="KdNg1SSt"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 6E9647A012E;
	Thu, 23 Jul 2026 14:18:42 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 23 Jul 2026 14:18:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1784830722; x=1784917122; bh=ma9eKKAfzL
	W+Rct8UjD0ONgwMOLdYLYtJXXLIdkD4SU=; b=MTwSA0Zjk6CD7TRA7cYGORige6
	tVyrFkfDTFw3NJOV/htOEj3hnBpDI0FJU0jEJNPYtqchCqyMIqBkYXabIvFBlwCK
	W0kmVgWwwJR5dCtQHNWYrt4ZkDtVYR5OHLVmBy/x72vBtKVuS5+be+8j4EGuzQ9H
	kj+gHNjxF1LuCbx0q4pQiFUoXCSfQ9e8iFRdYnsbRWznUzrDQBi4q0BpYLCWm7Ha
	HsY0XChiRO0o5MbsEyTGCm450xNm+CvSvkbRQjau6kWhSBEn87FmC0/v7+p3X3ie
	K2AORxcZLq51G1MxJDPRX3dhHKaHOWnm/sVEMEUoWlSCy4NS+63UGPkzf/jg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784830722; x=1784917122; bh=ma9eKKAfzLW+Rct8UjD0ONgwMOLdYLYtJXX
	LIdkD4SU=; b=KdNg1SStQxdEVSisTO9KgVmXY2TRfyMiPX3IvNLEhd83XV6xKTa
	NOB+prS6Nh8nOJepfuiSz0VYIVHxPG7cJreYCIjUU6+Rc3CCu9n1B516jTQn8Nxb
	/9XG8mkVUyh/7ach4HKqgFRSm4f86MVXRx76k/aPnn4erXl5Pw3J9babHKbLyWfY
	ZCWyRgANKDKEiPYQQmWde8jfZr3C+rDNIIvhbKvtmMhITjvIbPAgZTRdN1Oe0kxj
	I6eNf/nU29zdODIJhJFVordfq+Dr/8uRqyfxoszlU8ig5r04wBWTKDKDjecF2dmp
	fE6zOh8lLXEcYfxHnAQxWFW3jJwZyuk6ztA==
X-ME-Sender: <xms:AltiajY6Vjec4VoePhSA58QZR08benvPfEk_P4jq9Ox06Tm9crOqSA>
    <xme:AltiamGOPH0XD155uFCTXNJMod8PyzITFimHkm4z9e-bXX-b-5_uHYrksHm9gzvt9
    baV3_TzYADLhttn5oipGMSrP5tbGagvD09v_9a5zX4xdfA16DqooQ>
X-ME-Received: <xmr:Altiavwf42In2lTFN7x9S2zEuaExBU232FAwNgWHku_4qo-ie_2X9QFxoWYvOFK07-Geb1BHMC55qvMm5y6g9A2cma0>
X-ME-Proxy-Cause: dmFkZTF7i9zJXibow4snj9UT8+YiEgtO9Grg0nBFNibF+vnn75Gl7SpijXcUtqCzQnZJYE
    wnx9/8g/T1rOtcUg5OeJBtaJ/+LpQULrARb3Xr3vp4D6nLKEq3eEUnt43QqlkcLm/lKkBM
    D+1hOJdajsJpMkTL2y+RLE8Lo4j4DYHpLfb8x0Jtbnu1YfZQyIbRfNJ/WKurksBe6os11I
    YClFfDGqSqPNt9EVCqqaeAGWqTs5L55/uyRww2DmPyR/bV2yJpEKkZHBsL95q/T4KFCY3O
    jl0BeKSkHB8nYSCMTzBiRIz6ao2Uupu1xbu76jj8GLhkWu2FbT9ZRJtTuBuvKc7Y5Fw/HP
    Z14tCEEfFivvFfGgHCCHZ/vWuMzuHLNgu2hfhPsQBJ/AKEa5tFhnBHKl0B9/C17kr1bmuo
    K9u4xD/9BrH68hY4YLHKmmOkD5p7rSkJV8aZ89TVdvYGyemab7j+iRcBI2fZDfU1dWnLXA
    WbCdO2R48xaq5joVokuj0ZpGYgnWqvt8i4QFndlfUAeUhm33kpUsJB+iDiIJ2xyLIIQ3RJ
    swo1peVx44UJiWTigxodiKvUjlzsZPBSwovBKyMLQM4zGZxbhGa3o6U7OA0SDpMFSp5eSN
    99nzEImBED5s7BwlyshpE6on/juz0gopebfVJNYavZt2B19loTrFdCjusMVw
X-ME-Proxy: <xmx:Altiagl2rhHTqJy9QqavBUd9lyjC1wHn6LFxvkgBemVZK_jcDPJpCw>
    <xmx:AltiagknFkoqoBsrx1h2vMiaKwMehn--2BC8QJbgGzccwBRAKHY4eA>
    <xmx:AltiaqzT_MtWA-dSMhj4i2QXiMCsSIDDPA_5fbwiaulF35Vwwk6_dA>
    <xmx:Altiatoea1n3aK-bNetZH-MP9MkkvwD7mFA6kVwIdx5E0d_7XOJ3DA>
    <xmx:Altiav7tnc8RKMpanOz0xdmvZf8mDaaqO0ye2H6X5aACJRphR2HYkiXS>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Jul 2026 14:18:41 -0400 (EDT)
Date: Thu, 23 Jul 2026 11:18:30 -0700
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH v2 4/4] btrfs: zoned: don't clobber the extent buffer
 when zeroing it out
Message-ID: <20260723181830.GD752950@zen.localdomain>
References: <20260723155428.94187-1-johannes.thumshirn@wdc.com>
 <20260723155428.94187-5-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723155428.94187-5-johannes.thumshirn@wdc.com>

On Thu, Jul 23, 2026 at 05:54:28PM +0200, Johannes Thumshirn wrote:
> On a zoned filesystem a freed-but-still-dirty tree block is written out
> as zeros (EXTENT_BUFFER_ZONED_ZEROOUT) only to keep the zone write
> pointer advancing. btree_csum_one_bio() implemented this by memzeroing
> the extent buffer's own folios before submission.
> 
> That destroys the in-memory buffer while it may still be referenced. In
> particular btrfs_free_tree_block() can run on it afterwards and reads
> the header to add a delayed reference; once the header has been zeroed
> it frees bytenr 0 and corrupts the extent tree (the
> btrfs_header_bytenr(buf) != 0 ASSERT in btrfs_free_tree_block(), or an
> "unable to find ref" abort). It is flaky and reproduces under fsstress,
> e.g. generic/461 and generic/013.
> 
> Write the zeros to disk from the shared zero page instead and leave the
> extent buffer content untouched, so any later reference - including the
> delayed reference from btrfs_free_tree_block() - still sees a valid
> header. end_bbio_meta_write() now clears writeback on the buffer's own
> folios, as the bio no longer carries them.
> 
> Fixes: aa6313e6ff2b ("btrfs: zoned: don't clear dirty flag of extent buffer")
> Assisted-by: LLM (debugging, commit message)

One question inline, but
Reviewed-by: Boris Burkov <boris@bur.io>

> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/disk-io.c   | 13 +++++++------
>  fs/btrfs/extent_io.c | 31 ++++++++++++++++++++++++-------
>  2 files changed, 31 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 01d01e10d000..a1277c8f2871 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -271,14 +271,15 @@ int btree_csum_one_bio(struct btrfs_bio *bbio)
>  		return -EIO;
>  
>  	/*
> -	 * If an extent_buffer is marked as EXTENT_BUFFER_ZONED_ZEROOUT, don't
> -	 * checksum it but zero-out its content. This is done to preserve
> -	 * ordering of I/O without unnecessarily writing out data.
> +	 * An extent_buffer marked EXTENT_BUFFER_ZONED_ZEROOUT is written out as
> +	 * zeros to preserve ordering of I/O without persisting the now
> +	 * unnecessary block. The bio is fed from the shared zero page (see
> +	 * write_one_eb()), so there is nothing to checksum here. Crucially, the
> +	 * buffer's own content is left intact: it may still be referenced, e.g.
> +	 * btrfs_free_tree_block() reads its header to add a delayed reference.
>  	 */
> -	if (test_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags)) {
> -		memzero_extent_buffer(eb, 0, eb->len);
> +	if (test_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags))
>  		return 0;
> -	}
>  
>  	if (WARN_ON_ONCE(found_start != eb->start))
>  		return -EIO;
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index fa473476b7db..e88381a40600 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2266,14 +2266,17 @@ static struct extent_buffer *find_extent_buffer_nolock(
>  static void end_bbio_meta_write(struct btrfs_bio *bbio)
>  {
>  	struct extent_buffer *eb = bbio->private;
> -	struct folio_iter fi;
>  
>  	if (bbio->bio.bi_status != BLK_STS_OK)
>  		set_btree_ioerr(eb);
>  
> -	bio_for_each_folio_all(fi, &bbio->bio) {
> -		btrfs_meta_folio_clear_writeback(fi.folio, eb);
> -	}
> +	/*
> +	 * Clear writeback on the buffer's own folios. The bio may carry the
> +	 * shared zero page instead (EXTENT_BUFFER_ZONED_ZEROOUT), so iterate
> +	 * the extent buffer folios rather than the bio folios.
> +	 */
> +	for (int i = 0; i < num_extent_folios(eb); i++)
> +		btrfs_meta_folio_clear_writeback(eb->folios[i], eb);
>  
>  	buffer_tree_clear_mark(eb, PAGECACHE_TAG_WRITEBACK);
>  	clear_and_wake_up_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
> @@ -2314,7 +2317,8 @@ static noinline_for_stack void write_one_eb(struct extent_buffer *eb,
>  	struct btrfs_fs_info *fs_info = eb->fs_info;
>  	struct btrfs_bio *bbio;
>  
> -	prepare_eb_write(eb);
> +	if (!test_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags))
> +		prepare_eb_write(eb);
>  
>  	bbio = btrfs_bio_alloc(INLINE_EXTENT_BUFFER_PAGES,
>  			       REQ_OP_WRITE | REQ_META | wbc_to_write_flags(wbc),
> @@ -2334,8 +2338,21 @@ static noinline_for_stack void write_one_eb(struct extent_buffer *eb,
>  		btrfs_meta_folio_set_writeback(folio, eb);
>  		if (!folio_test_dirty(folio))
>  			wbc->nr_to_write -= folio_nr_pages(folio);
> -		bio_add_folio_nofail(&bbio->bio, folio, range_len,
> -				     offset_in_folio(folio, range_start));
> +		if (test_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags)) {
> +			u32 off = 0;
> +
> +			while (off < range_len) {
> +				u32 add = min_t(u32, PAGE_SIZE, range_len - off);
> +
> +				bio_add_folio_nofail(&bbio->bio,
> +						     page_folio(ZERO_PAGE(0)),
> +						     add, 0);

In your opinion would it be better to hang the zero_page off eb->folios[]?

Gets rid of this special case but might do something surprising /
unexpected (or just be a dumb idea and not work at all, lol)

> +				off += add;
> +			}
> +		} else {
> +			bio_add_folio_nofail(&bbio->bio, folio, range_len,
> +					     offset_in_folio(folio, range_start));
> +		}
>  		wbc_account_cgroup_owner(wbc, folio, range_len);
>  		folio_unlock(folio);
>  	}
> -- 
> 2.55.0
> 
