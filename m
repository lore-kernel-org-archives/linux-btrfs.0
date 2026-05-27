Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D774A308F26;
	Wed, 27 May 2026 16:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779897688; cv=none; b=CkSCxxrVhr7Nry4DgSgXXPpTDMo4LBav6D4Dc0YsKEvDlcekPaaB/7ak+RiqacK8QMIck9ECcJKyReQctQfCwfs/MwmfCFWFJZCPljy7Zm7egj7l3I8aVbmDqG+BNbzPa742kzTwHGqK+TMh0q4QVvYymw/2vgKYjNObD+hJTm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779897688; c=relaxed/simple;
	bh=6sdQsTRTF2Jeck9wYxmfYfSHzR8tCYyMGE9BHlJ5ZqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lVAwEG0caDPHXVto8jO+tJYP/uti5cweDbAUWSrnwt5JoeBp/7h3Ee6VKjdf7uRmOB9ijwYjPjgVSqWgCGdvQFP/GDGWlfVlwYWeyE21wZnXvMgNN1unk6VGIM8uTXom9IwYf6shywGZ1vGmmDgo0N5tgKxKn6Br+0jT3ANbXJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=GgFmfe+u; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=QcwnAUdx; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="GgFmfe+u";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="QcwnAUdx"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 0F36E1400008;
	Wed, 27 May 2026 12:01:26 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 27 May 2026 12:01:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1779897686; x=1779984086; bh=Wg/1x0WtE+
	BjGzc5E8aAMBFgMx6f+qWGQhLMY3NY7DU=; b=GgFmfe+ug4EGF3YKZQmA6YPzSD
	HYkOHVRkQ6HMU5EbYa2RnUT0F2rYaE/9IFxqUMxBcAZBeHphQNRcRj5nqyRTQAUB
	QJVuq9Z6RBQXS+EU5iTe+k6sNLrqKG5RBKcdm0BkvxtOQBznUitgoLT4aLG6iKXL
	iBvWI6sAX5DuSNo3zFThUsQD2flijfJSWRyEZ9pT9XXDhrt8gbn3wYZ/7G8eYcCb
	qJSRsOgJxrut776JUgRKX0rToJF8SW8AXAM4f1ebi2I9Ddwl3ee/HVDde7vcx7QM
	B78NKGhuKO9RYqbOl3PRPGVLIXwfMLIIQx5D2GdG6kAMZHc/jpMM6X5Tupag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779897686; x=1779984086; bh=Wg/1x0WtE+BjGzc5E8aAMBFgMx6f+qWGQhL
	MY3NY7DU=; b=QcwnAUdxA71uYrvxs2jMQoY/eAm5uQMW1547IIJyR72z+cBgjmc
	jlgjHYhX9ZtC9Do+1RgNnhMji0j20souH7YlnAK5GNi3MVFIVUGoNDimRHncuOBk
	QDayNzuSh9BgECQUI19rRhGDJHAjkM1O2gPlE5g0MT/vJz9GPvWyQ6h2I+wpo8hw
	v7diek0AgAAOUsXuC8C5jh2q4ybW3/dqg6wwoMn3bJcTfopNEvwnhdQUnMbTfVb9
	52eYNJSvOaj1W070I7kIJaDEkjP1iT5pUQLXGLRLX/pwLIY45PW6nDIupIQ8AAoY
	MvjxNzFu5t6QeIiCPVVVu6DgHHlMTdxjMxA==
X-ME-Sender: <xms:VRUXasSjoGjinCQkwNPHNqsS0cZouPKSS8SHLoNOhOmwLANEF0J9QA>
    <xme:VRUXahhWArlUVSILhub4UN-aUBYl06Fbs4cJ62CKw0KxhGUKVmbhRVrAWUk_xF2th
    AkNtHYk_rxhP9HE2Tav-ugd1Tc7U70kDdF6MpfJywSphCEjH-pxQM0>
X-ME-Received: <xmr:VRUXas6z2Xeiydv0zdJab6XmLMnECmd4YGZ_h1NTpXMaAIUHI7V7-2nt63xwGXrbHtF2Qr1FAP_lENl03xO9OjMSV8g>
X-ME-Proxy-Cause: dmFkZTEyrNR4hFKKprhLoawz/V9/I/g+hZXDlVbsU5YJAr5JmKySPZTk2BadateLs79gta
    KGpSkbQlZ4MeLXxExxTDkr8O4ePSZUMl8mowx7KXcZRpT9USFI8M+wJxCmUd0YL8jJM6hb
    ky70S7JVTV0uXopyEFbiylQL6y5pXITsaK8/MsdiDuBjyzPjYMm1IRw1YuNIU4E+VPNqG3
    p/ItIx8PKpzGBNkuSIfF/cXRV8B+B17+m/Mtp5Y8I/zQsOgKcXMy5EVRjhqGxr/ocXhU+h
    vREnvNzyAiICrIhmjNmZuofiG84MB3aA7I8LNtMl+ygfJWjiakMPcz2XdZ+GcmMm+nOAqP
    mOBpNE2xeyfUJlDiMVsaLeCSvdr+BnfnB1dGAr6GuaMoMRQhcUWWaV+sHcvB9mFrviqDpt
    i8vZsjGZtRN47tNz4caR1TC0uUwwU0bR5UCwRysU1yz6scaWfXSnJQD/sL4cIPQST9Xhmz
    zh19P8v2ZO64gU1IeglxdmdsNggVWttU0jcGnoDpCh0zB3AewAmt8rcDWB0k5BHXiCecJo
    Q3cM9uoizRQShiZcRpjQOz2/8dX/yXTPYrx+URAb6kzdzyqNdRwKGab6hewwY33cEQq/E9
    MLzKhjkEt0t718P1MHRf0b+4jufkgyCbSZR4TlDcuukr/0yKm39Vskzs7gNQ
X-ME-Proxy: <xmx:VRUXauAjtg87XALKaAcSv11T_RMNyOthT22jFv2sKuuwXIh-wZt7PQ>
    <xmx:VRUXajaQGxUgVsMVEk_4ZC5MQRTERpkOBQz0wbcXzYIc0teFghF8hQ>
    <xmx:VRUXaparQ-new4l_BUtun-vHBnP3ljh-dYqcMNjg5EQxoMjgTSkKMA>
    <xmx:VRUXaq_gKs5f9_g-fQyLuM-Nprlw2mApFiQLoCcbVqNDiifMNL3pSg>
    <xmx:VhUXaozK9uO19BqdJzVrTJZP8dAVGgUAPtiQXaicwpYQzSqN5kAGt5KG>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 May 2026 12:01:25 -0400 (EDT)
Date: Wed, 27 May 2026 09:01:12 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: fix false IO failure after falling back to
 buffered IO
Message-ID: <20260527160112.GB1981571@zen.localdomain>
References: <cover.1779846117.git.wqu@suse.com>
 <b3393b113c45ac7bd7b2649576b5667395c22a1b.1779846117.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3393b113c45ac7bd7b2649576b5667395c22a1b.1779846117.git.wqu@suse.com>

On Wed, May 27, 2026 at 02:36:44PM +0930, Qu Wenruo wrote:
> [BUG]
> The test case generic/362 will fail with "nodatasum" mount option (*):
> 
>  MOUNT_OPTIONS -- -o nodatasum /dev/mapper/test-scratch1 /mnt/scratch
> 
>  generic/362  0s ... - output mismatch (see /home/adam/xfstests/results//generic/362.out.bad)
>     --- tests/generic/362.out	2024-08-24 15:31:37.200000000 +0930
>     +++ /home/adam/xfstests/results//generic/362.out.bad	2026-05-27 10:21:17.574771567 +0930
>     @@ -1,2 +1,3 @@
>      QA output created by 362
>     +First write failed: Input/output error
>      Silence is golden
>     ...
> 
> *: If the test case has been executed before with default data checksum,
> the failure will not reproduce. Need the following fix to make it
> reliably reproducible:
> https://lore.kernel.org/linux-btrfs/20260526070055.60193-1-wqu@suse.com/
> 
> [CAUSE]
> Btrfs direct write disable page fault of the input buffer, this is to
> avoid a deadlock specific to btrfs.
> 
> So for the test case generic/362, it uses an anonymous page as input
> buffer. And since the page is not yet faulted in, the direct IO will
> fail with -EFAULT, causing us to go through the following call chain:
> 
>  btrfs_direct_write()

I believe that when direct_write() sees EFAULT from btrfs_dio_write() it
should do the fault and retry, not fallback straight to buffered.

	if (iov_iter_count(from) > 0 && (ret == -EFAULT || ret > 0)) {
		const size_t left = iov_iter_count(from);
		/*
		 * We have more data left to write. Try to fault in as many as
		 * possible of the remainder pages and retry. We do this without
		 * releasing and locking again the inode, to prevent races with
		 * truncate.
		 *
		 * Also, in case the iov refers to pages in the file range of the
		 * file we want to write to (due to a mmap), we could enter an
		 * infinite loop if we retry after faulting the pages in, since
		 * iomap will invalidate any pages in the range early on, before
		 * it tries to fault in the pages of the iov. So we keep track of
		 * how much was left of iov in the previous EFAULT and fallback
		 * to buffered IO in case we haven't made any progress.
		 */
		if (left == prev_left) {
			ret = -ENOTBLK;
		} else {
			fault_in_iov_iter_readable(from, left);
			prev_left = left;
			goto again;
		}
	}

>  |- btrfs_dio_write()
>  |  |- btrfs_dio_iomap_end()
>  |     |- btrfs_finish_ordered_extent(uptodate = false);
>  |        |- can_finish_ordered_extent()
>  |           |- btrfs_mark_ordered_extent_error()
>  |              |- mapping_set_error()
>  |                 Now the address space is marked error.
>  |
>  |- iomap_dio_complete()
>  |  The dio bio is empty, nothing submitted.
>  |
>  |- Fallback to buffered
>  |  And the buffered write finished without error
>  |
>  |- filemap_fdatawait_range()
>     |- filemap_check_errors()
>        The previous error is recorded, thus an error is returned
> 
> However the buffered write is properly submitted and finished, the error
> is from the previous short dio write.
> 
> [FIX]
> When a short dio write happened, we shouldn't mark it as an error, but
> treat it like a truncated write.

I am quite skeptical of this as the proper fix. I looked into this
really thoroughly back in
https://lore.kernel.org/linux-btrfs/20230328051957.1161316-12-hch@lst.de/
and remember concluding it was much better to do the OE split and submit
separate direct writes, and I believe it was more or less working. I am
willing to believe that the mapping_set_error() thing slipped through
the cracks, though, so I apologize if I missed that detail. Has
something changed since then that makes us fall back to buffered on a
write buffer fault? Or am I misunderstanding something about what is
happening in this case?

g/708 is the test case for that particular corruption, FYI.

Thanks for looking into it,
Boris

> 
> Extract a helper, btrfs_mark_ordered_extent_truncated(), and utilize
> that helper to mark the direct IO ordered extent as truncated, so it
> won't cause failure for the later buffered fallback.
> 
> Cc: stable@vger.kernel.org # 6.1+
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/direct-io.c    | 18 +++++++++++++-----
>  fs/btrfs/inode.c        |  6 +-----
>  fs/btrfs/ordered-data.c | 12 ++++++++++++
>  fs/btrfs/ordered-data.h |  2 ++
>  4 files changed, 28 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index 57167d56dc72..598480b77002 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -610,6 +610,7 @@ static int btrfs_dio_iomap_end(struct inode *inode, loff_t pos, loff_t length,
>  {
>  	struct iomap_iter *iter = container_of(iomap, struct iomap_iter, iomap);
>  	struct btrfs_dio_data *dio_data = iter->private;
> +	struct btrfs_ordered_extent *ordered = dio_data->ordered;
>  	size_t submitted = dio_data->submitted;
>  	const bool write = !!(flags & IOMAP_WRITE);
>  	int ret = 0;
> @@ -624,16 +625,23 @@ static int btrfs_dio_iomap_end(struct inode *inode, loff_t pos, loff_t length,
>  	if (submitted < length) {
>  		pos += submitted;
>  		length -= submitted;
> -		if (write)
> -			btrfs_finish_ordered_extent(dio_data->ordered,
> -						    pos, length, false);
> -		else
> +		if (write) {
> +			/*
> +			 * We got a short write, will fallback to buffered IO
> +			 * for the whole range.
> +			 * Set the truncate length to 0, so that no real file
> +			 * extent item will be created.
> +			 */
> +			btrfs_mark_ordered_extent_truncated(ordered, 0);
> +			btrfs_finish_ordered_extent(ordered, pos, length, true);
> +		} else {
>  			btrfs_unlock_dio_extent(&BTRFS_I(inode)->io_tree, pos,
>  						pos + length - 1, NULL);
> +		}
>  		ret = -ENOTBLK;
>  	}
>  	if (write) {
> -		btrfs_put_ordered_extent(dio_data->ordered);
> +		btrfs_put_ordered_extent(ordered);
>  		dio_data->ordered = NULL;
>  	}
>  
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 973a89301baa..2c0131452754 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7590,11 +7590,7 @@ static void btrfs_invalidate_folio(struct folio *folio, size_t offset,
>  					       EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
>  					       EXTENT_DEFRAG, &cached_state);
>  
> -		spin_lock(&inode->ordered_tree_lock);
> -		set_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags);
> -		ordered->truncated_len = min(ordered->truncated_len,
> -					     cur - ordered->file_offset);
> -		spin_unlock(&inode->ordered_tree_lock);
> +		btrfs_mark_ordered_extent_truncated(ordered, cur - ordered->file_offset);
>  
>  		/*
>  		 * If the ordered extent has finished, we're safe to delete all
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index f5f77c33cf59..b32d4eabe0ab 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -358,6 +358,18 @@ void btrfs_mark_ordered_extent_error(struct btrfs_ordered_extent *ordered)
>  		mapping_set_error(ordered->inode->vfs_inode.i_mapping, -EIO);
>  }
>  
> +void btrfs_mark_ordered_extent_truncated(struct btrfs_ordered_extent *ordered,
> +					 u64 truncate_len)
> +{
> +	struct btrfs_inode *inode = ordered->inode;
> +
> +	ASSERT(truncate_len <= ordered->num_bytes);
> +	spin_lock(&inode->ordered_tree_lock);
> +	set_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags);
> +	ordered->truncated_len = min(ordered->truncated_len, truncate_len);
> +	spin_unlock(&inode->ordered_tree_lock);
> +}
> +
>  static void finish_ordered_fn(struct btrfs_work *work)
>  {
>  	struct btrfs_ordered_extent *ordered_extent;
> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
> index 03e12380a2fd..8d5d5ba1e02f 100644
> --- a/fs/btrfs/ordered-data.h
> +++ b/fs/btrfs/ordered-data.h
> @@ -226,6 +226,8 @@ bool btrfs_try_lock_ordered_range(struct btrfs_inode *inode, u64 start, u64 end,
>  struct btrfs_ordered_extent *btrfs_split_ordered_extent(
>  			struct btrfs_ordered_extent *ordered, u64 len);
>  void btrfs_mark_ordered_extent_error(struct btrfs_ordered_extent *ordered);
> +void btrfs_mark_ordered_extent_truncated(struct btrfs_ordered_extent *ordered,
> +					 u64 truncate_len);
>  int __init ordered_data_init(void);
>  void __cold ordered_data_exit(void);
>  
> -- 
> 2.54.0
> 
