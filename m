Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0382D0625;
	Thu,  4 Jun 2026 16:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780591659; cv=none; b=bcgc6C0iFbrWVbYtRzCaH9bzLgbwxJNAj5WnGmVyi30N237OFPidTNCd3QGRAtW+CFj3CTWYvuaHKR93LIkJttfn3ACkdSHd5OdiFoKAQl4/6NwSEORkZyMcqIqXuc9dhNbZmfbodBczeiwFmsUiF7qtuDWaBpjQ5FiE2X/HJFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780591659; c=relaxed/simple;
	bh=MUnLsCrPDVDhr6URnxsPIv7RkbZtGg9K5rd/eZeA7do=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uI0shSjhecQnT+bcxyMrVUuXGJ4SaaCyZjBwdpGvhLHl0TZqE7WYtl4qObsYHv+pJo7ogthH+ZD3lGNxFhYC+1BUayxFBK36TE+nb5dgSWsVeFf+mjCOWyiwJd+5e/znS5+wi5PMd8GnTmGXdn/iG7qarrP74+acXCfeTvugTCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=pwwerau3; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=PKgrNL6a; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="pwwerau3";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="PKgrNL6a"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id CEA9A1D00084;
	Thu,  4 Jun 2026 12:47:36 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 04 Jun 2026 12:47:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1780591656; x=1780678056; bh=DNVzUrxgG/
	jJw0bXtC9bwQVGzN/5tRTDv1iAtF6x/is=; b=pwwerau3irJONVVrcstCe7Ee6x
	h3Fy3/cR9kK2ThI7tBG/75SFkqUFFoORJQOfU1Y/h0PTbB4HQ3W/7Pp4TkoZ6N9p
	8eoY2suVODSM+9LVnsvMVRHT2Eu9Pfw0WJrghMCRc1cX++UFWbdh4YHo9aj5rk8T
	Q0Z17d3OM4UkhivA7UEB4REogAIgUN78VP5dMU1+zE9/bjz6Gzd57TNgtcB/f01I
	mIwxxbXVWLKzB9T3EXgKcH7bojyoV+LxR82QIPKLn6f6RKg0bMFTPpjFfTzjtvj3
	TczzIVMAwBqUu5W2ROODsClBVfm5KxEHZ4gmyaO32ZFUvee9yRCdQONA6dHQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1780591656; x=1780678056; bh=DNVzUrxgG/jJw0bXtC9bwQVGzN/5tRTDv1i
	AtF6x/is=; b=PKgrNL6aM1t1Rg945DATxRn47TOCn4G/TYjyYkvVqWG97aEU3e6
	5qjNlhdpHdGSrkSM3pTU9e64f9rxG/BOnYmR3AiAHUe8QEHQofytgtvSVYBxwOKv
	pdv1CPUFnIaLPWUFv1ApmUofUJecr2m+49mc3TPbVYOkVl49IIehsn3umKV7cqwv
	BK/uKiJjyL7Y7nnZ1O4AZY3JtanlzE3h9NY1ve5tqFO/L0FmCbp/ihyMKXcOGSH/
	lbrHTiRQD8JJmrlKwhH8rCx0umzJYSCCaTWE+0pNeL7QLOq9zi71Vlbym4wJFoLT
	Yj9BQX1USKtj7/1TDNFK5cfN+rPXDwd13Xg==
X-ME-Sender: <xms:KKwhaqRBBLP4jtxz8acbwfxTstZS3ytfvtqOp3CHyJTjvIg_G7_-ig>
    <xme:KKwhanjOw69kFCwUiDc_rxwFa9ule5A2e7ROlB9HxQuAcJ1vKHne8nynWB0m198vi
    dzb13LPrAEROC0NNPo8I3pU1zzTRmeVfYxLc6sAjvshSRL9-zef6cM>
X-ME-Received: <xmr:KKwhaq404JLFzQvSGyPgbQtETotCPD1BOs5ZjYhWdSypsBaNzM8-O3O3QQf0aUiyDjmxY7fBfIawi-LGdcbkZcCnc1U>
X-ME-Proxy-Cause: dmFkZTFFm1kzkdcanJVRBkku+90OVlpTxJZcfGkWLoFiNd4+bG1aUQ7bXWpm+mP6F6zsSI
    yJ0kgis6vznEiV7sLWjMJ+z4UmHEdgAEOhy4m6+IAdBWLzBTf6CjC5g/Uy9GMub7RcQ+XQ
    l8mqxlhl5kP2ODizuz59tgLTpWBm35H1XZn3c1s6nZkxuJgoulQuklFlsdfoDtcU+hAIoZ
    rH4PoA8s9YbQVUpai0Z+AKcvlfLYKQXtGULvGcclwnTGjrK6PyatXftxX4n4kEPZh8+OqY
    CO7+tTnMjXu4RZ5d76ncPASA+0XGlGe19Lnjtam5mUZqZnO/cALz8/i0/DAOh7osECacsW
    QogGaTcCZ0CNylftEYcAf1PCbs/fnNIeSnKyjpBd8zyIojE856QirlTMSvo70GX67CTC+x
    kQDgooaj6+sv2ZdfNxKExZ8UnMSgI00Ly6fdYsujhSa9y1rEnMRWFxikZLPfqPcySXRtkB
    MDMxfdcnLo3Lskr4eR4r9fhM6NELeYMg5BA1IU6VqFgMXHw/gOW62o3QLREwPcslzGRItj
    L2Y1OLuaaAe+JDfvSV1Q3l8qzKjx9I6JeCoYvfAwW4QLqLvNCcusyNRDn2XIxjsupjUYBR
    vMT3Ru62zBlTQhxEvb2V3Edd3FUvM/Ezyia0o6D3b3uk0Gwoon99bg0yHoFQ
X-ME-Proxy: <xmx:KKwhakBDxHdJTOWD3iB8NKc3J6_DmsClv4bE41NNh0vdTfUrcpFhhQ>
    <xmx:KKwhahYszz_XraSHIZjRYt2R8U5GCWnWB7NZ-SzGV9GyUcF7T7RWpw>
    <xmx:KKwhavZJSGgusY0aJXIi_L3XyM0ZUYEDImVxj0wrnWnu7_HAmutp5Q>
    <xmx:KKwhao-P7EkCnXALlkj9a4C8zVmU_kriYLSZOP2CkUNP5i0Ff4XrOQ>
    <xmx:KKwhauwNp0xqESs5DbbGbTR8w0xcj1pIKk0iDcl82kOpZ9-UDEYRamk9>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 4 Jun 2026 12:47:36 -0400 (EDT)
Date: Thu, 4 Jun 2026 09:47:04 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/3] btrfs: fix incorrect buffered IO fallback for
 append direct writes
Message-ID: <20260604164704.GA3450576@zen.localdomain>
References: <cover.1780528155.git.wqu@suse.com>
 <4be56f5a6bd21da0f073d79d04912f3642a62e9b.1780528155.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4be56f5a6bd21da0f073d79d04912f3642a62e9b.1780528155.git.wqu@suse.com>

On Thu, Jun 04, 2026 at 09:59:47AM +0930, Qu Wenruo wrote:
> [BUG]
> With the previous bug of short direct writes fixed, test case
> generic/362 (*) still fails with the following error with nodatasum
> mount option:
> 
>  generic/362  0s ... - output mismatch (see /home/adam/xfstests/results//generic/362.out.bad)
>  - output mismatch (see /home/adam/xfstests/results//generic/362.out.bad)
>     --- tests/generic/362.out	2024-08-24 15:31:37.200000000 +0930
>     +++ /home/adam/xfstests/results//generic/362.out.bad	2026-05-27 10:13:09.072485767 +0930
>     @@ -1,2 +1,3 @@
>      QA output created by 362
>     +Wrong file size after first write, got 8192 expected 4096
>      Silence is golden
>     ...
> 
> *: If the test case has been executed before with default data checksum,
> the failure will not reproduce. Need the following fix to make it
> reliably reproducible:
> https://lore.kernel.org/linux-btrfs/20260528111659.87113-1-wqu@suse.com/
> 
> [CAUSE]
> Inside btrfs_dio_iomap_begin() for a direct write, we increase the isize
> if it's beyond the current isize.
> 
> But if the direct io finished short, we do not revert the isize to the
> previous value nor to the short write end.
> 
> Then if we need to fall back to buffered writes, and the write has
> IOCB_APPEND flag, then the buffered write will be positioned at the
> incorrect isize.
> 
> The call chain looks like this:
> 
>  btrfs_direct_write(pos=0, length=4K)
>  |- __iomap_dio_rw()
>  |  |- iomap_iter()
>  |  |  |- btrfs_dio_iomap_begin()
>  |  |     |- btrfs_get_blocks_direct_write()
>  |  |        |- i_size_write()
>  |  |           Which updates the isize to the write end (4K).
>  |  |
>  |  |- iomap_dio_iter()
>  |  |  Failed with -EFAULT on the first page.
>  |  |
>  |  |- iomap_iter()
>  |  |  |- btrfs_dio_iomap_end()
>  |  |     Detects a short write, return -ENOTBLK
>  |  |- if (ret == -ENOTBLK) { ret = 0;}
>  |     Which resets the return value.
>  |
>  |- ret = iomap_dio_complet()
>  |  Which returns 0.
>  |
>  |- btrfs_buffered_write(iocb, from);
>     |- generic_write_checks()
>        |- iocb->ki_pos = i_size_read()
>           Which is still the new size (4K), other than the original
> 	  isize 0.
> 
> [FIX]
> Introduce the following btrfs_dio_data members:
> 
> - old_isize
> 
> - updated_isize
>   If the direct write has enlarged the isize.
> 
> Then if we got a short write, and btrfs_dio_data::updated_isize is set,
> revert to the correct isize based on old_isize and current file
> position.
> 
> And here we call i_size_write() without holding an extent lock, which is
> a very special case that we're safe to do:
> 
>  - Only a single writer can be enlarging isize
>    Enlarging isize will take the exclusive inode lock.
> 
>  - Buffered readers need to wait for the OE we're holding
>    Buffered readers will lock extent and wait for OE of the folio range.
>    Sometimes we can skip the OE wait, but since all page cache is
>    invalidated, the OE wait can not be skipped.
> 
> But I do not think this is the most elegant solution, nor covers all
> cases. E.g. if the bio is submitted but IO failed, we are unable to do
> the revert.
> 
> I believe the more elegant one would be extend the EXTENT_DIO_LOCKED
> lifespan for direct writes, so that we can update the isize when a
> write beyond EOF finished successfully.
> 
> However that change is too huge for a small bug fix.
> So only implement the minimal partial fix for now.
> 
> [REASON FOR NO FIXES TAG]
> The bug is again very old, before commit f85781fb505e ("btrfs: switch to
> iomap for direct IO") we are already increasing isize without a
> proper rollback for short writes.
> 
> Thus only a CC to stable.
> 
> Cc: stable@vger.kernel.org # 5.15+

Looks good to me, now, thanks!
Reviewed-by: Boris Burkov <boris@bur.io>

> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/direct-io.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index 88cb2e82a507..412309825d6f 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -15,10 +15,12 @@
>  
>  struct btrfs_dio_data {
>  	ssize_t submitted;
> +	loff_t old_isize;
>  	struct extent_changeset *data_reserved;
>  	struct btrfs_ordered_extent *ordered;
>  	bool data_space_reserved;
>  	bool nocow_done;
> +	bool updated_isize;
>  };
>  
>  struct btrfs_dio_private {
> @@ -228,6 +230,7 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
>  	bool space_reserved = false;
>  	u64 len = *lenp;
>  	u64 prev_len;
> +	loff_t old_isize;
>  	int ret = 0;
>  
>  	/*
> @@ -341,8 +344,14 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
>  	 * Need to update the i_size under the extent lock so buffered
>  	 * readers will get the updated i_size when we unlock.
>  	 */
> -	if (start + len > i_size_read(inode))
> +	old_isize = i_size_read(inode);
> +	if (start + len > old_isize) {
> +		if (!dio_data->updated_isize) {
> +			dio_data->old_isize = old_isize;
> +			dio_data->updated_isize = true;
> +		}
>  		i_size_write(inode, start + len);
> +	}
>  out:
>  	if (ret && space_reserved) {
>  		btrfs_delalloc_release_extents(BTRFS_I(inode), len);
> @@ -625,6 +634,38 @@ static int btrfs_dio_iomap_end(struct inode *inode, loff_t pos, loff_t length,
>  		pos += submitted;
>  		length -= submitted;
>  		if (write) {
> +			/*
> +			 * Got a short write and have updated the isize, need to
> +			 * revert the isize change.
> +			 *
> +			 * Normally we need to update isize with extent lock hold,
> +			 * but we're safe due to the following factors:
> +			 *
> +			 * - Only a single writer can be enlarging isize
> +			 *   Enlarging isize will take the exclusive inode lock.
> +			 *
> +			 * - Buffered readers need to wait for the OE we're holding
> +			 *   Buffered readers will lock extent and wait for OE
> +			 *   of the folio range, and since page cache is invalidated
> +			 *   the OE wait can not be skipped.
> +			 *
> +			 * So here we are safe to revert the isize before
> +			 * finishing the OE, and no reader of the remaining range
> +			 * can see the enlarged size.
> +			 *
> +			 * TODO: Extend the DIO_LOCKED lifespan for direct writes,
> +			 * and only enlarge isize after a successful write.

I am a little nervous to leave this as such a confident TODO. I'm not
100% sure that is a good/working idea yet, and I wouldn't want a future
reader to get confused. If you are certain it will work, then I don't
mind you leaving it, though, this is just my opinion/gut feeling.

> +			 */
> +			if (dio_data->updated_isize) {
> +				u64 new_isize;
> +
> +				if (submitted == 0)
> +					new_isize = dio_data->old_isize;
> +				else
> +					new_isize = max(dio_data->old_isize, pos);
> +				i_size_write(inode, new_isize);
> +				dio_data->updated_isize = false;
> +			}
>  			/*
>  			 * We have a short write, if there is any range
>  			 * that is submitted properly, that part will have
> -- 
> 2.54.0
> 
