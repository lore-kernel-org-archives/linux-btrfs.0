Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E3938C42B
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 16:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784825663; cv=none; b=lUBcmvFUhCNzcp0UUJtQi7YjvSomNoYdarJl9gjLYbFG64h5ROsW8D7dc4YKabKtXtQslC0EeMAQFQm5ewt4uq/jw7Fs57L3A1Bl15X5aAiPrIGKp/qtAp5k5OyrwvEObJ00eQa1E1VvpwaYwqOEYl1qrSeDadFSWxr9MOTaHn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784825663; c=relaxed/simple;
	bh=cB5pufHzNKczw2scHsFT8T9joeRAv0Uc3hNCH19Hx9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AUBSwSPDWcXX7FxEKyHaXSkH0Xq1u51C6h3yVpAV6om8IEF0v6lxl0Wjc+U7/XLQTmkJwbN3R9ByCinnL12SeDl6SjJZc98UuK0OmKPfgGYt0YbDO3/1LILqApkFidsfcZwUiDLx1citxmUfeZjsX2lWZzGMLcZscCf7Z2o7Gx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=VWgqvVNk; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ptXYrE5o; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="VWgqvVNk";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ptXYrE5o"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 4949EEC02E0;
	Thu, 23 Jul 2026 12:54:21 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 23 Jul 2026 12:54:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1784825661; x=1784912061; bh=sEKiA8q434
	ORhWM6yfQkrlxZ7Ov7K7Rz4c/R7ZGQmhI=; b=VWgqvVNkl1ZzQrDxSaaNbz3efp
	el0mI+DqtE8ACNSY+YoVzuv5wwFQHq8YL95Exfw8EN1M1+5HmW+a4pr7nq8CsNsR
	pwriYY2ZtigZLXw+zmKk4qmtD3Bkf5AgEv2OKvPRF9gR1kGr7qiEPZ2VEFQCdUxN
	/4IXB4mIPCMbrwFjMDP5wN0ylDQAnX4xtSwvqVGq9lW8YchroNpg3HEzR959TC8j
	CEjMVQs7sYzaVHPfZQ09JxREYQy0QE6CnWMnUY7jC3BC2NsK6TJUo3tdFWt0vkNU
	ndpJlk+cEQaPTGM5EfWuSf5arVEuJJQATqg1xq2rWqZay8uYFzpLCmxU8eUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784825661; x=1784912061; bh=sEKiA8q434ORhWM6yfQkrlxZ7Ov7K7Rz4c/
	R7ZGQmhI=; b=ptXYrE5okIDxpYOPUBVraUsY/dNidlLQYCHuDfIqW42khGBoYSs
	aKclPdfqmYqeB0bOO3APaYFD3B/dZdP7B5vF4sGrd6E2H+ZISE2lEMeABgAvuW5w
	EwX0TWHS8JeiX9UPBp3xX+Q1cIU8msi5OAMyNAASHAz+nin7XqrJtndMGdEWDG0P
	on73AlOEKgRn6bP4JZMPVLNWqwYrxHCQTMs8148v0xOLSOHq3bQ4NHjaqyB0wlNm
	HKFJW3/FAbzvKmDOg9fy2O22kiez9WqTWX4BSAauZ33rm0Ekc92wBjHuc8t9hxq2
	T5vn3+hLDoMrIsyUYT4TbUrXNTAKTHQJUQg==
X-ME-Sender: <xms:PUdiappHNV6PfVjs2x-VuW5UWgPr6l62ogK4IJSp0ejjfCsjDfRHxQ>
    <xme:PUdiavUZbYANkzTM2bBCOuQquu2GMT2gWmqOnhjMjlKKeFbtDDfZ7FglW44f04q2S
    xMndtPX83gDqLQUGNr4PWQ6huUZU6LrAdQ7i_V6s5-zyFeO4IO1954>
X-ME-Received: <xmr:PUdiagCGZWAoDBTxysd8d4dL5ZJXYaQDcMjtNMIKSD40NPxEbrWvRZwq6pj73GaJX-JmW1r73q6tW1iPIcKH43b2zcM>
X-ME-Proxy-Cause: dmFkZTGdaVIsy0MYksNn9Rpewd7yyliVgcelsvG9Bm7lT6lhIiJqARxdSflxNs+c40xDsL
    4j4Tox2Go8P6zpxPvpLmUIY0pmfX/Mhx3T1hj3Hfon9pROwxvjmwGIU3vmehMepR/LJdC4
    Am4ki2aEYyZksym/f1yI4hWqyAdRppfcteCVoQLtoYa3tuLeLqnUMZEhQTgduzRViumAu1
    OXC4OMNWdohZF235zKbWHXH/ZgudxpVnrnnNorYKkF/ExHtbYjfF0WkKFfvmOLoIl79kxM
    hXTsdtpCxsJZ+t4kuyYecgehI4Mr4utePl3YLQb5P8nL9xTsldu8ybxdAcbOaKB2C9ddEb
    aJrShj+LhxwN5hWFXKdZHxsiL3qJkouV4RsCPdEzMXe+jjnKajgobn5tJh0EHJNtH3zA9E
    bGEUz8HVKHgTmpVVG+Nrl448c1AT+D09sfDWodklRwyO1UKkJhmosj74ENetvB0R6WaRxT
    XK5FSLviSkRFWTguu3bsjTR3KPFQ1/tzNbNCTLkylkxyy3GaKc7iZBv1AyBOrU+H1Ydmu/
    8+KtngXHRT4RNNJKSeJg5bWvKvZ0nfAgOmkXc3ip1qsAgzdEjWXjcMLV0lf16DYO5+lqQy
    5uu5mSpjHeaOb0feYwOL8lOLopgaNosvGdFCWWCCsnZhRNMde3cqLEXx6vmQ
X-ME-Proxy: <xmx:PUdiar19i61vkZDLCRmdcvRgYK28ItazKS7b1M6qX3ICjDm5hgiefQ>
    <xmx:PUdiaq0mDm7rxgMaeIi0YuG3gl7geCQyp63a5lVrTBeFTO2OElbAFQ>
    <xmx:PUdiaoAEcs8ChTeVD6KAp1tZwX3y5PrVyAOC1X1kaQmoHG7JwGE-Dg>
    <xmx:PUdiah5hn_dz_LyGf526plFkWanlffORD-_hM_LlzN8rbCdtCdJogg>
    <xmx:PUdiasJmtXDNDGmjp927wGzh7zP_5Chmdtl7oK-YrEIqfqJSYw2uJG5e>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Jul 2026 12:54:20 -0400 (EDT)
Date: Thu, 23 Jul 2026 09:54:10 -0700
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH v2 2/4] btrfs: zoned: drop stranded dirty metadata on
 transaction abort
Message-ID: <20260723165410.GB752950@zen.localdomain>
References: <20260723155428.94187-1-johannes.thumshirn@wdc.com>
 <20260723155428.94187-3-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723155428.94187-3-johannes.thumshirn@wdc.com>

On Thu, Jul 23, 2026 at 05:54:26PM +0200, Johannes Thumshirn wrote:
> On a zoned filesystem a freed tree block is not cleared but kept dirty
> and flagged EXTENT_BUFFER_ZONED_ZEROOUT, so a later writeback zeroes it
> out and advances the zone write pointer. A transaction abort turns the
> filesystem read-only before that writeback runs, so these buffers stay
> dirty and stranded ahead of the write pointer where btree_writepages()
> can no longer write them. They survive to the final iput() of the btree
> inode at unmount, which submits the write after the endio workqueues are
> gone, hanging unmount in folio_wait_writeback().
> 
> Clear the dirty state of such buffers when cleaning up the aborted
> transaction, where the buffer tree still references all of them.
> 
> Assisted-by: LLM (debugging, commit message)

Reviewed-by: Boris Burkov <boris@bur.io>

> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/disk-io.c   |  1 +
>  fs/btrfs/extent_io.c | 74 ++++++++++++++++++++++++++++++++++----------
>  fs/btrfs/extent_io.h |  1 +
>  3 files changed, 60 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 67171e0d41b3..8d0afc2842cc 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4997,6 +4997,7 @@ static int btrfs_cleanup_transaction(struct btrfs_fs_info *fs_info)
>  	btrfs_assert_delayed_root_empty(fs_info);
>  	btrfs_destroy_all_delalloc_inodes(fs_info);
>  	btrfs_drop_all_logs(fs_info);
> +	btrfs_zoned_release_dirty_metadata(fs_info);
>  	btrfs_free_all_qgroup_pertrans(fs_info);
>  	mutex_unlock(&fs_info->transaction_kthread_mutex);
>  
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index e3125ef701ce..fa473476b7db 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3911,6 +3911,32 @@ void free_extent_buffer_stale(struct extent_buffer *eb)
>  	release_extent_buffer(eb);
>  }
>  
> +static void clear_extent_buffer_dirty(struct extent_buffer *eb)
> +{
> +	struct btrfs_fs_info *fs_info = eb->fs_info;
> +
> +	if (!test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->bflags))
> +		return;
> +
> +	buffer_tree_clear_mark(eb, PAGECACHE_TAG_DIRTY);
> +	percpu_counter_add_batch(&fs_info->dirty_metadata_bytes, -(s64)eb->len,
> +				 fs_info->dirty_metadata_batch);
> +
> +	for (int i = 0; i < num_extent_folios(eb); i++) {
> +		struct folio *folio = eb->folios[i];
> +		bool last;
> +
> +		if (!folio_test_dirty(folio))
> +			continue;
> +		folio_lock(folio);
> +		last = btrfs_meta_folio_clear_and_test_dirty(folio, eb);
> +		if (last)
> +			btrfs_clear_folio_dirty_tag(folio);
> +		folio_unlock(folio);
> +	}
> +	WARN_ON(refcount_read(&eb->refs) == 0);
> +}
> +
>  void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
>  			      struct extent_buffer *eb)
>  {
> @@ -3935,26 +3961,42 @@ void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
>  		return;
>  	}
>  
> -	if (!test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->bflags))
> -		return;
> +	clear_extent_buffer_dirty(eb);
> +}
>  
> -	buffer_tree_clear_mark(eb, PAGECACHE_TAG_DIRTY);
> -	percpu_counter_add_batch(&fs_info->dirty_metadata_bytes, -(s64)eb->len,
> -				 fs_info->dirty_metadata_batch);
> +/*
> + * On a zoned filesystem a freed tree block is kept dirty and flagged as
> + * EXTENT_BUFFER_ZONED_ZEROOUT so a later writeback zeroes it out and advances
> + * the zone write pointer. Such buffers still dirty when the filesystem is torn
> + * down can no longer be written back and are stale; if left dirty they hang the
> + * final iput() of the btree inode. Drop their dirty state, and the deferred
> + * zero-out along with it.
> + */
> +void btrfs_zoned_release_dirty_metadata(struct btrfs_fs_info *fs_info)
> +{
> +	struct eb_batch batch;
> +	unsigned long index = 0;
>  
> -	for (int i = 0; i < num_extent_folios(eb); i++) {
> -		struct folio *folio = eb->folios[i];
> -		bool last;
> +	if (!btrfs_is_zoned(fs_info))
> +		return;
>  
> -		if (!folio_test_dirty(folio))
> -			continue;
> -		folio_lock(folio);
> -		last = btrfs_meta_folio_clear_and_test_dirty(folio, eb);
> -		if (last)
> -			btrfs_clear_folio_dirty_tag(folio);
> -		folio_unlock(folio);
> +	btrfs_zoned_meta_io_lock(fs_info);
> +	eb_batch_init(&batch);
> +	while (buffer_tree_get_ebs_tag(fs_info, &index, ULONG_MAX,
> +				       PAGECACHE_TAG_DIRTY, &batch)) {
> +		struct extent_buffer *eb;
> +
> +		while ((eb = eb_batch_next(&batch)) != NULL) {
> +			btrfs_tree_lock(eb);
> +			if (test_and_clear_bit(EXTENT_BUFFER_ZONED_ZEROOUT,
> +					       &eb->bflags))
> +				clear_extent_buffer_dirty(eb);
> +			btrfs_tree_unlock(eb);
> +		}
> +		eb_batch_release(&batch);
> +		cond_resched();
>  	}
> -	WARN_ON(refcount_read(&eb->refs) == 0);
> +	btrfs_zoned_meta_io_unlock(fs_info);
>  }
>  
>  void set_extent_buffer_dirty(struct extent_buffer *eb)
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index 869925337699..ad4ffce32702 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -393,6 +393,7 @@ void extent_clear_unlock_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
>  				  u32 bits_to_clear, unsigned long page_ops);
>  void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
>  			      struct extent_buffer *buf);
> +void btrfs_zoned_release_dirty_metadata(struct btrfs_fs_info *fs_info);
>  
>  static inline void btrfs_clear_folio_dirty_tag(struct folio *folio)
>  {
> -- 
> 2.55.0
> 
