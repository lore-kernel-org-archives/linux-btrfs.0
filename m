Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8B930C630
	for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2026 18:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779818418; cv=none; b=DYuruSCjqubEa8UQZazATRTnW6sZDbIttQOQMKNNJPgzd4ReEw1y0RKW9zMfweXChgepMSJ5Ur2iK1JQjaNWt5MIXDKwD5yRF9AnUk9tbOdquaeK5f2W3Nweglk9+i64AbQkUc+fdEgBTtTAGc7divioSp7vvw9tzPQCuP8jhPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779818418; c=relaxed/simple;
	bh=bVW1vQ5AAOF/s9qQtmY5QnM7zD857J4Ym+WWJaxuu+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UUB4dJvwvXJxq86quOPlUT0Fob4dyw22gzamz0oNk1MnyIxpEU7RpWi47HGncfe5OD4L++iXrT2UeAlZ8y/IHf3/1fkSalrnUp9SiuQQjqTaDxB6QC5tgKT3isqTL/Cbm4oqFR5vriX6qx+BXi7GwkYoXaR5whs+DG9Mzdro2Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=KDi6SErB; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=KX2kJ0P9; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="KDi6SErB";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="KX2kJ0P9"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 074671400132;
	Tue, 26 May 2026 14:00:16 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 26 May 2026 14:00:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1779818416; x=1779904816; bh=xRUoAK+dtG
	JF32hiHe2+JRTTlO24DCKSiOo6hZG9FcA=; b=KDi6SErBTfrXzxOKaaMWQEdoGT
	JcLrTMqhLV+hTSOn05YjHlar6D0IUsF4GtzWKfZkv2lrDRsnzhluKjMnHWEsgCWN
	DkjU6frJSRDGiSuQD7inEHHtbcps6kWw962u8yPKPErijjs5qSt24cendh0mUPaW
	ExuRczpTp5KPe5itCPmhuXvtHN4bVbypp4mrEboxPeXmlJ8eKPQw3yT09zAKHCed
	JD9Vd283iBWfepaclYW2mukG+eWEffEID65+5F/D79kiYJSag6a1jgZZyE80ihEa
	B0tBQs/RXF0VxIWQI7iyHBUsy1cfZHIQfJKNXhum22b3xB6e8jv1pHvZm5KQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779818416; x=1779904816; bh=xRUoAK+dtGJF32hiHe2+JRTTlO24DCKSiOo
	6hZG9FcA=; b=KX2kJ0P98R4emGI3WHg7AREens6yC41YDWo8xgfmCgZOoLznHy6
	/J7ThAKiqPCdVGtjuqJwHOjuzRjcTSW0WIrIoNhmXJXvMSiAMA00VgTd228A1jE4
	afVOAzmV1pDQ0VMb9hN5A5qEWKgO48oVgWTrghN1He1653obMF2+DT06Fhk97qJt
	2yCIv8zPP/fLGQz7XZszonhJK7Bdn7YMAwK/irdAwS5I/IwuW83eRLV+yQN0pZEq
	bEBg3fOqIJoJWqJ4CbLTXxh3nt0XKo/hcQg3+yUlE8EyjZBYHpDexFdEZpG1RKkF
	ZvZSiETveD+mQP8dWWL5og3qr60Tsve/rSA==
X-ME-Sender: <xms:r98VaiRwcT-H6K_I0dJGNo0YuWmJ6Mguqef6i6hXZVv4PgOG0suFeg>
    <xme:r98Vaty20F_kIhoSE-Wb2d5CMKcIF2LCLJXHid6obp5qSyIZRpf1vExQWieLjRkQx
    aR8-tbXGDj9VNASmc8C48SLeI4F7vQpkYC2gqaDI6W3-6v0xzAIA_4>
X-ME-Received: <xmr:r98Vatd5QN9kTlslP7bIwikWXE45r--Zi5MGFYRAJUwIUbZd0HKNCe87SqFeM7JbSL1CP4vpPneIx9ZbWSvceFyAW-o>
X-ME-Proxy-Cause: dmFkZTG1guFTOuIayrzjqBiSoe4IKFOTq47f7QPogJn3s5VSOmNVb2p74z/uHMx/phydtK
    A+f1q97Vqsgw6o+rghwBTFolVRFiJQp/1aU2m/gosrVXz6kv24VkzkXUcUl2vqPO0p/Yc6
    mR6PeTOnt7Rf5lXxLYLX/ccwaeq9p4rO+mUwwLfxQ/QFCGVZEqiee+WbbVOde4KekJ1XNQ
    TBrzOICgzPia6YSeIIWzOTXCQwqG+NTCeYq7xVtTa0W9DFdg1bIlIGi+CDU4HOLfygg8Ha
    zcL8q0fhIDxFvsbkLRkBzigr1YZm1m0fyFDl4EhhQJoqnyOdT/1Y2hB/TEl0bkTe+ZjemM
    FnjXfQoVH1w0XbPwE1v8SPqfpHS5M3KMPTuryUOJd3AK9AikAaWJH3lsAgS9MQKvXzq9aG
    dFrpnqshWMfQ/ObJ6L9D+F6m6LtjTU7rDtPd5t39KQPkkD/SVBuzk1TdSjFSY4tO4pxwy0
    samKqEJa11/NEvtSubzona+ImrsbhTrsGa+6pZvx2A+N5LOh4zPgtATkT0v1RVn9yk85dG
    KxeQEYclxqdnOSa9lPJmF3vtna+PrvY+YK33f7zcNBu2gNjONFfvgGE4hMwEugArJziIAN
    laUS9sZ8dztPMzPo/DZiKs4hKgHWMLDHQyjGm9BcDvRun/nkw0FdoO24g8iQ
X-ME-Proxy: <xmx:r98VapJT-edPs4pThbtYZ7eWWDzaBJGb1ZiJlDV62-cpGnsYymO6rA>
    <xmx:r98VauE-nFbQZ8kH38oTtcM_NbcS4Rs7gXFPSfYkmMkHmjtBjUIXNw>
    <xmx:r98VajrXCPSQauBS4hrsIroHj9hNMKKcaBz5EK5wUVH8sj8VlVMbfA>
    <xmx:r98VanRyLmrtALFb1mqcG0WelJsdhJeEEmHx8frD0E1APrvQkEfXmw>
    <xmx:sN8VaudDANnVOX7SMFWi_-MF3tJSMno2YNiaK8cstkWxVcy88lz2OFXv>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 14:00:15 -0400 (EDT)
Date: Tue, 26 May 2026 10:59:55 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: use IOMAP_DIO_BOUNCE flag instead of falling
 back to buffered IO
Message-ID: <20260526175955.GA1359754@zen.localdomain>
References: <e578ff1a2dd9a4f720ea77bc601534734ce87e18.1779685479.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e578ff1a2dd9a4f720ea77bc601534734ce87e18.1779685479.git.wqu@suse.com>

On Mon, May 25, 2026 at 02:35:33PM +0930, Qu Wenruo wrote:
> Previously btrfs forces direct writes to fall back to buffered ones if the
> inode has data checksum or the profile has duplication.
> 
> That fallback is to avoid the content being modified that the final
> content may mismatch with the checksum or the other mirrors.
> 
> That brings a pretty huge performance cost, which already caused some
> concern at that time.
> 
> But later upstream commit c9d114846b38 ("iomap: add a flag to bounce
> buffer direct I/O") introduced a new method by copying the content into
> new pages, and do all the operations based on the newly allocated pages.
> 
> So let btrfs to utilize the new flag for direct writes if we require
> stable folios.
> 
> There is a quick benchmark, using the following fio setup:
> 
>  fio --name=randwrite --filename $mnt/foobar --ioengine=libaio --size=4G \
>      --rw=randwrite --iodepth=64 --runtime=60 --time_based --direct=1 \
>      --bs=$blocksize
> 
> Unit is MiB/s.
> 
>  Blocksize | Zero-copy (*) | Buffered |   Bounce
> -----------+---------------+----------+-----------
>         4K |          35.1 |     17.1 |      33.8
>        64K |           522 |      251 |       492

This is really exciting!

Dumb question:
Do you have a sense (or reference to previous discussion?) that would
explain why bounce buffering so much faster?

Thinking out loud about possible overhead:

- copying overhead : bounce vs buffered both need to copy the user data
- memory allocation overhead: they both need a folio (to copy into or to
  dirty). It might already be present for buffered.
- btrfs architecture overhead: They both should be doing all the same
  cow-ing/extent_map manipulation.
- synch-ness: The buffered fallback immediately writes back and waits as
  far as I can tell, so it shouldn't be some kind of "writeback doesn't
  get triggered when we want"
- balance_dirty_pages: we do call into it in the buffered fallback so we
  could be made to wait. But I would sort of not expect that to happen
  on the test you are running, unless you are doing lots of other
  dirtying at the same time? Since each fallback pass does trigger
  writeback so it shouldn't build up too much.
- libaio/iodepth true async: buffered fallback is synchronous per go
  while maybe bounce can be more properly async? Haven't thought through
  this too carefully.
- generic page cache overhead: we just have to do a lot more work for
  the same operations. managing folio state, xarray, locks, balance
  dirty pages, writeback xarray, etc etc

I would guess that it is the "generic overhead" in the benchmark.
Curious if you have any clearer thoughts on it.

Thanks,
Boris

> 
> *: This is done by reverting the commit 968f19c5b1b7 ("btrfs: always
>    fallback to buffered write if the inode requires checksum")
> 
> Although with page bouncing the performance is only around 95% of
> true-zero copy, it's still almost double the performance of buffered
> fallback.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v2:
> - Rework the comment in btrfs_dio_write()
> ---
>  fs/btrfs/direct-io.c | 45 ++++++++++++++++----------------------------
>  1 file changed, 16 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index 57167d56dc72..173fe065fc38 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -768,10 +768,25 @@ static ssize_t btrfs_dio_read(struct kiocb *iocb, struct iov_iter *iter,
>  static struct iomap_dio *btrfs_dio_write(struct kiocb *iocb, struct iov_iter *iter,
>  					 size_t done_before)
>  {
> +	struct btrfs_inode *inode = BTRFS_I(file_inode(iocb->ki_filp));
>  	struct btrfs_dio_data data = { 0 };
> +	const u64 data_profile = btrfs_data_alloc_profile(inode->root->fs_info) &
> +				 BTRFS_BLOCK_GROUP_PROFILE_MASK;
> +	unsigned int dio_flags = IOMAP_DIO_PARTIAL | IOMAP_DIO_FSBLOCK_ALIGNED;
> +
> +	/*
> +	 * Userspace may modify the buffer while DIO is in flight. With
> +	 * data checksumming this would produce a checksum that doesn't
> +	 * match the persisted data; with duplicated profiles the mirrors
> +	 * would diverge. Bounce in those cases so writeback sees stable
> +	 * content.
> +	 */
> +	if (!(inode->flags & BTRFS_INODE_NODATASUM) ||
> +	    (data_profile != BTRFS_BLOCK_GROUP_RAID0 && data_profile != 0))
> +		dio_flags |= IOMAP_DIO_BOUNCE;
>  
>  	return __iomap_dio_rw(iocb, iter, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
> -			    IOMAP_DIO_PARTIAL | IOMAP_DIO_FSBLOCK_ALIGNED, &data, done_before);
> +			      dio_flags, &data, done_before);
>  }
>  
>  static ssize_t check_direct_IO(struct btrfs_fs_info *fs_info,
> @@ -800,8 +815,6 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>  	ssize_t ret;
>  	unsigned int ilock_flags = 0;
>  	struct iomap_dio *dio;
> -	const u64 data_profile = btrfs_data_alloc_profile(fs_info) &
> -				 BTRFS_BLOCK_GROUP_PROFILE_MASK;
>  
>  	if (iocb->ki_flags & IOCB_NOWAIT)
>  		ilock_flags |= BTRFS_ILOCK_TRY;
> @@ -815,16 +828,6 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>  	if (iocb->ki_pos + iov_iter_count(from) <= i_size_read(inode) && IS_NOSEC(inode))
>  		ilock_flags |= BTRFS_ILOCK_SHARED;
>  
> -	/*
> -	 * If our data profile has duplication (either extra mirrors or RAID56),
> -	 * we can not trust the direct IO buffer, the content may change during
> -	 * writeback and cause different contents written to different mirrors.
> -	 *
> -	 * Thus only RAID0 and SINGLE can go true zero-copy direct IO.
> -	 */
> -	if (data_profile != BTRFS_BLOCK_GROUP_RAID0 && data_profile != 0)
> -		goto buffered;
> -
>  relock:
>  	ret = btrfs_inode_lock(BTRFS_I(inode), ilock_flags);
>  	if (ret < 0)
> @@ -865,22 +868,6 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>  		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
>  		goto buffered;
>  	}
> -	/*
> -	 * We can't control the folios being passed in, applications can write
> -	 * to them while a direct IO write is in progress.  This means the
> -	 * content might change after we calculated the data checksum.
> -	 * Therefore we can end up storing a checksum that doesn't match the
> -	 * persisted data.
> -	 *
> -	 * To be extra safe and avoid false data checksum mismatch, if the
> -	 * inode requires data checksum, just fallback to buffered IO.
> -	 * For buffered IO we have full control of page cache and can ensure
> -	 * no one is modifying the content during writeback.
> -	 */
> -	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
> -		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
> -		goto buffered;
> -	}
>  
>  	/*
>  	 * The iov_iter can be mapped to the same file range we are writing to.
> -- 
> 2.54.0
> 
