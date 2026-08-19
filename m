Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9E02853E0;
	Wed, 19 Aug 2026 20:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787171273; cv=none; b=grNb8ObB8Wyl/P4uoRz3Iq4qcFlrBCI4ENOcFMOt2tvAZsjkfSsiqiDW5RV50v5x3t7dhVY/GpGO8aI4U8wNR0gyMrH0l/gomNeeQrBlCKpS9BUdncF3hiMlamp+dimWW9KuBtbJqChokMKVE70xlcRUEw1fsskdmS90Px+G9V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787171273; c=relaxed/simple;
	bh=AyldoyEBn/2ou+fuE9ZHQgIfWO0cEyEhzmiIxOLjLWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u0nvCFVhxssLIvJEj/A3aGzMNNonPqmA6+0unnHNYK7qRZh2r2kt7MgCairzNnG7u0umzhGeeF1KFEhusO7rWyFdCMrfDDlLlIVI4bI3xSaXJLTGEFvxX4QYxnwQ/FFo3Xlqfc2kSekQY22bZvWuyEt24FTybThfxfKDYXYn0YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=KnetYzJI; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=kmlqrqVk; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="KnetYzJI";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kmlqrqVk"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 6ABFFEC0174;
	Wed, 19 Aug 2026 16:27:50 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 19 Aug 2026 16:27:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1787171270; x=1787257670; bh=1FxtkVCQJ/
	RY68QE8HMiIEYoHMQWxZ4NDcj9PkdkFoo=; b=KnetYzJIx06H/rUrjcCt8Dkf4s
	IhzmGBaMwMnB9avGCGSO0b2ZhUoe5MxfnXy5Lkn9biBViJn6FCWRHE2mkdVSZ2zf
	69i3I0pgBmST7dYhwWa6M7oDd5Pk9XmDNVTHEx1fo7/sdGeL0D0+zAtKyydzdert
	uisHsV4kNQ+stpgE4lp5jd9mJKvTrZbblGv7ioBpLQU2DFd59biiqX+O4plRzP4X
	PuILq3Easi6VQbZBdjCtnh/VoiWSlHwBdNSGNSCL3gdor6RKp6DQ3hmtZpueZfgq
	DI0EgP5lvGvC0ygoz5Dt53aplmPEn7OjltonHRavGX+cJVEnJ9WjEDV+pgdw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787171270; x=1787257670; bh=1FxtkVCQJ/RY68QE8HMiIEYoHMQWxZ4NDcj
	9PkdkFoo=; b=kmlqrqVkZ8TBJnkAXoV98xI6Tdjyyqk6go0WCVvomhKJCG1//BT
	n1O5F0yrheULWI5A4y0cd+CodixTxkCWPjaWUA41i1AWPbXGz5V1VltRDRWxL0hs
	ylzmT1P/sN1EFA5xfGd3hxCiaxPBDhkwODxxAbFirHPm9plO4Hx/hbEL3cmcOdaQ
	rdJUlgQFxCIR8k+vsh5qMIuvUwv8qciTwMxikd+D2wEVLgurYcEjyiKiT/G1qmiE
	m4LLdAQoVZmvDYIo8xYI1DVqJkbv5dy5Kfsa4C9VZjwTrHEay/r9+AsHzVpv1EzL
	Ii9dvBzBbAIJ+X3JGMk0sbXMOvsioE8Z89g==
X-ME-Sender: <xms:xRGGanuwpXOiHbWAmNjpwKxoGV72HHDwM1a3nz7PJiROuuLWFHg7fw>
    <xme:xRGGakV5Y2wRRY9OsCgSICnnz7-rcpOplaDHkvejcXi3iU6xvRjGivEyKG8WnLhMY
    FjRYvV2xG_w_zhNBt-63kLoV7-rfc6yDOsZposwqJYGDJe0dBtujffl>
X-ME-Received: <xmr:xRGGany7tfZFiv4t8pPZKvFLCzdCSSf9zrclD_tjdDkvieY_upIc4E_NcetlFaqb-9xVhPNp8OCr0nergWOkDDpmysw>
X-ME-Proxy-Cause: dmFkZTEulO96cc1bVbyXB5XL5VoXJFkVnVWKa3Lh0Kvo61cbZ+4WYv0j5db1S8rWhH7984
    J/vhzeL9RyrkFkailvPNjtzi2AAqQ70oQH24b3BMGVKkANLbvdlwwoj0mOblzvMCNNe15X
    mLnqpJslv0wN1sjzrqxxCDrTXDsTpPFNiIn/QJwHy1A7rQyqXC20hilBuRRFz+2zffFxD3
    0xHsZe+D2VECsyOK+upQnpjrsYP7lXo+mSwvS12Wl27B0UlU4YFxzsBR0CT4WqjRc/zfSb
    PyQbm/ETYwYzwys5B2d26O1wKnYVHFyfWi2hYNdqTkGaBhGy5ZColCySeHnXD5VV/oQ9Y8
    SLdaIKeAlzwmHnCrg7xaUTKNHrl5nxND1hV7ZoexpISucea2z/KCroNoedZFJHMTrLLGAc
    MoDQmkLSYXgGYs2oQsoJIFYZJB2f8L6M1io2xjqzu7j3uOChs35w2iztr8LUTowd+qXUwa
    dS3xdFdWVhW2JfQXU4tVsFB/BeW+oXUj6kJoZ8zViBJ1YoUz8HP4swENpigByQ7zjYrF5r
    myeBitzBTd9Bk9o51jB2IgI3Sj6lZFAkRC/BbuXGvhEqYlVgTpAY3aPKVA60SzkXqDwYMT
    uFiJCy7anZknPpOXY/3tvnwzELTUmdF6p2yCdDjxUZulPFM68KdxCBycWvkQ
X-ME-Proxy: <xmx:xhGGarGmU21R0N6BZniAiQrMC0R0WMr-6ozP_jUZGu3Hc1l110cRfQ>
    <xmx:xhGGass43qXvx1-ZcvqmedCLrh9lq_RBRG1WOvCZ8RSdypKcrdgqBw>
    <xmx:xhGGarDNdt5L1xvMjnEgP4Bt8BvbX3Rn-QcmqjRjNksXY2Qeag-Ojg>
    <xmx:xhGGanBKLPovg14Lh8BjG_iVMdF4e8oqIqlTZ6fkzO-WaCAGatgPmg>
    <xmx:xhGGaqLej7vGYng0jg7-XZfZyOGaWJ1f2DsR1-WbJ-Ii6EN16yCWbkWu>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 19 Aug 2026 16:27:49 -0400 (EDT)
Date: Wed, 19 Aug 2026 13:27:26 -0700
From: Boris Burkov <boris@bur.io>
To: Leo Martins <loemra.dev@gmail.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: abort transaction before releasing tree_log_mutex
 on commit failure
Message-ID: <20260819202726.GA3622042@zen.localdomain>
References: <698c480ec13cd6e74c2175924f614b7e324e6cc3.1787099421.git.loemra.dev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <698c480ec13cd6e74c2175924f614b7e324e6cc3.1787099421.git.loemra.dev@gmail.com>

On Tue, Aug 18, 2026 at 05:40:10PM -0700, Leo Martins wrote:
> When transaction metadata writeout fails in btrfs_commit_transaction(),
> the current code only logs the error, drops tree_log_mutex and then goes
> through cleanup_transaction(), which aborts the transaction and records
> the fs error.
> 
> That is too late for the tree log side. A log sync can already be
> waiting on tree_log_mutex, because the committing transaction is moved
> to TRANS_STATE_UNBLOCKED while that mutex is held, which lets fsyncs
> join the next transaction and queue up in btrfs_sync_log(). Once the
> failed commit drops tree_log_mutex, such a log sync acquires it, sees
> BTRFS_FS_ERROR() still clear, and writes super_for_commit. That
> superblock holds the roots prepared for the transaction that has just
> failed to write out its metadata, so it can point at tree blocks that
> never reached the disk, and the next mount fails with a parent transid
> mismatch.
> 
> Commit 165ea85f1483 ("btrfs: do not write supers if we have an fs
> error") fixed this class of problem by making btrfs_sync_log() check for
> an fs error right after taking tree_log_mutex. That check only works if
> the commit path publishes the fs error before it releases the same
> mutex, and commit 68d4ece9c30e ("btrfs: don't call
> btrfs_handle_fs_error() in btrfs_commit_transaction()") removed the only
> thing that did so.
> 
> Restore the ordering by aborting the transaction while tree_log_mutex is
> still held. We have a transaction handle here, so this does not need to
> bring back the btrfs_handle_fs_error() call: __btrfs_abort_transaction()
> records the fs error itself, which is all btrfs_sync_log() looks at, and
> the error message put in its place is kept.
> 
> This is what commit 3810ab40afa5 ("btrfs: abort transaction on error in
> write_all_supers()") already does for the next call in this function.
> 
> This is reproducible on an unmodified kernel by failing the first
> couple of bios of a transaction commit with fail_make_request while a
> concurrent fsync workload keeps log syncs queued on tree_log_mutex.
> 
> Fixes: 68d4ece9c30e ("btrfs: don't call btrfs_handle_fs_error() in btrfs_commit_transaction()")
> Cc: stable@vger.kernel.org # 7.0+

Reviewed-by: Boris Burkov <boris@bur.io>

> Signed-off-by: Leo Martins <loemra.dev@gmail.com>
> ---
>  fs/btrfs/transaction.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 13a7e5f4e08c..ed850bf0546a 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -2583,6 +2583,12 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>  	ret = btrfs_write_and_wait_transaction(trans);
>  	if (unlikely(ret)) {
>  		btrfs_err(fs_info, "error while writing out transaction: %pe", ERR_PTR(ret));
> +		/*
> +		 * Abort before releasing tree_log_mutex, so a log sync waiting
> +		 * on it sees the fs error and skips writing super_for_commit
> +		 * for this failed transaction. See btrfs_sync_log().
> +		 */
> +		btrfs_abort_transaction(trans, ret);
>  		mutex_unlock(&fs_info->tree_log_mutex);
>  		goto scrub_continue;
>  	}
> -- 
> 2.53.0-Meta
> 
