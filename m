Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70CA501F21
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 20:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788467972; cv=none; b=ecIn1J8j2GU1DGRbbf0cVkOrgqXGRm+cmGF42p3us+e6ByzgfAxp5Wi3/0I5pMwMFyDJvUd7Gw3teoHFpKlTxoJ8JQwilIYuEWJzqdCsrV8H7aDuIImv1KsT1S1wTeMx8Er541KKPYnu4MSqBPPYle4GqLLcI32uuOBihj9Q5+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788467972; c=relaxed/simple;
	bh=LdFgowg5hDydWEhNu1H2kh/D/wCjw9qQDRz0iX/Ii2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ta7pnqYwgwTQUl/UhICKXLY2qJGqQgRg+AfMz4ed0MQ7rTa6z2hppeADv/MoveDir46UTrQyX09qKXro+YemwhZQRl3UTX2IAYxNW+wnKsp6IHdFTbYnM0CcAAzfFpcL2Jioj4vVxComgq9SAqREk4wDvGhxDFYDszitIMxT2pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=uiOFHlMl; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ewa74+vn; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="uiOFHlMl";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ewa74+vn"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 473E97A0168;
	Thu,  3 Sep 2026 16:39:22 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 03 Sep 2026 16:39:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1788467962; x=1788554362; bh=fTC1rvDR3J
	gE7tL7MebBegXTzIaQcjOP4h1sx7cdLgg=; b=uiOFHlMljnelaalyS0/t1S1hHS
	FMdrgbZGKA5Do7Qu8b5350r3wLOgqMIXwS2bprid0MUhouq5LRE4/13LX9poGskB
	3JmLH6MRyQPP45+ZUcBlj48WyOQmnTYtiMBiZb6w57qzgwx3O3hggRjGFFcwQWCH
	2e+tpB6jGyrGIPoMzxvaECHCCd0AAHqAC/PpufeTgqOD6lY87+uT+mX8rJgMU4G/
	G2UtzgdsgyDs8o7+2KmLxOLCihWaGy3HH9q6C5cAt0T7enLjwoKhPhrUw2sm3lJU
	YC+YYY3elwak6k0upjPpWDrsBU1H0lQY8ypfdRkiDHffcjKlEJc5U815Jrvg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788467962; x=1788554362; bh=fTC1rvDR3JgE7tL7MebBegXTzIaQcjOP4h1
	sx7cdLgg=; b=ewa74+vnUhmg1MzivyyvVX5HJiiudH3vnrQHWgjaYlo0+VROt/b
	+CFbjWTUj4oASdYy5WqfF2BdNkGOP34S0LLVxhkUtWygMqH4mACkhKV7EvJJHfwH
	GQBMBlpwyKS1It6CJ/nG9B2NqeX/e7NRWb0QfEKXOUvcRx0uPVZvr/RoCrJ3hSH6
	dJEMagfBo5uUezZ7OYSGSDqNXi4cYld32lxHnGVZZ7bx1GA4/j5Xis+sxbkwca2G
	01/F49sdB2guTldNDsvfNp5y8NCxXflux9NMMirtn+8BD9jX6JH2snuE5z11dQLF
	I9vbXUTicL1pqowWyY2734RX9aHhJKMid3A==
X-ME-Sender: <xms:-dqZakJa7Ch8AmSoXyHBYcG-NGYlq_mdZjEpE4F5sogLqlsRRZ-8JQ>
    <xme:-dqZaqJZJQ-82t5qyeSEfZq1LyXXjhCJdXeTQm-mkrwG6pIRiWwwFbu1icYKR53gl
    rL8p4Z6oe3_AGJk87Lwj4JZTlTVle0sfLtKeYG9nZmk8jiTQvHrmejo>
X-ME-Received: <xmr:-dqZaiWsD1MG6IPY4spiNi9txgy0pxrhEXLj3dHt3pQWPkbA4PaQN1I>
X-ME-Proxy-Cause: dmFkZTGccuVGXQjAzhY0pcH52StchfO3/ptOv+6INBKDcSgWEaUpLKdSYGhBJhzSoYlHKk
    96r+pSNsOLa4nxTYPXuQwK5yxiNFRv+ojSQDwDAu45X28vYAjjSQLt03E9uAu0Aq8x27W3
    0yne7Jdb4dzUL9KVqtDbCPXqqx88FacY3vKvSd9l9YFGMB4opY/ZgdQop9zmwI5F2Kk6Pt
    82LpnwmJaO4Eu/I9+8WVyktG394nnMHGbZXS9uHCeQ+3lH0i2TGl/j2hVDhWDOQcppMkV6
    vwJmXlwt8/k6/6/mo70KYSl7TCSjOfeOWg+mSOhdDOv9I7A/yrI07J6ViCue9gC8iHY7QG
    xcgL0VUdm7Uk6aZBrnuRaQDBj6CyL+mJdSjimfDEKwiuJagE9tMDEUsgY6ovLP5aZUf/5e
    hfslZHhiLL76FTQCNW0AaaD+jKk8VEl6qi9sg2+UTNXrmrqg6CCVSKRwBQAEmyP4ZzrV5v
    Kg/gV0tq8V5jBoxXMZHUF/KrQ1HqcdAij8m08sFosO5E3kqtcwGFqGucQqL0xcxNxoy/nf
    AKgRg17YzWt76sZ7k7/JqD4ub9xbWF4rvCwOX1m6QoYhVI6RHGdoicvrvJIXNiICKRMl9y
    fvagZ0VemKEo3w1e72DvzjySzQyLl0798U454ce2b3RzyGkfLerJvyeMpQfg
X-ME-Proxy: <xmx:-dqZasjSS2Kfe-nPgQCqKIrJcZayZjgPdL2x1S5UUVrRdYkO85i0LQ>
    <xmx:-dqZat_szqO8rz70aPdjOU1Bh6xgB0iXVMLexsq1BxbeiQwgHmlIkg>
    <xmx:-dqZamAgFwXGT3RPtrMUZPmt8D9k7mKQE7en05BgvWsL5SO4tf2y8A>
    <xmx:-dqZaqK7A-Ywt1vp1nZpVWh3Lmz8mnohM5luVwLry8f4ZK40J-MueQ>
    <xmx:-tqZanXR6Q59bAC-GqgNJZvHdq42FcgspXOsoeok-JyEZqEPHtOIYyDn>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Sep 2026 16:39:21 -0400 (EDT)
Date: Thu, 3 Sep 2026 13:38:27 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 RESEND 0/4] btrfs: removal of on-stack paddrs[], final
 part
Message-ID: <20260903203827.GI325502@zen.localdomain>
References: <cover.1787101260.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1787101260.git.wqu@suse.com>

On Wed, Aug 19, 2026 at 10:36:15AM +0930, Qu Wenruo wrote:
> [CHANGELOG]
> v3 RESEND:
> - Minor commit message change
>   The resend is most for proper sashiko review.
> 
> v3:
> - Rebased to the latest for-next
>   There is a fix in RAID56, which can cause conflicts with the last
>   patch
> 
> - Remove all remaining on-stack paddrs[] usage
>   There are two last ones in RAID56, one can be converted to use bio
>   interface, the other is not using on-stack paddrs[] array.
> 
>   So we can finally remove all on-stack paddrs[] usage.
> 
> v2:
> - Fix a missing assignment for metadata repair
>   The logical should be assigned before passing it to
>   btrfs_repair_bbio_failure().
> 
> - Move the commit message of error message change to the correct patch
>   It's changed in the first patch not the last one.
> 
> Since the experimental bs > ps support, several on-stack fixed paddrs[]
> arrays are introduced, for assemble mutli-page sized fs blocks.
> 
> However that on-stack memory usage is always there for 4K page sized
> systems, no matter if the block size of the filesystem.
> 
> The idea is to use bio interface for page iterations, the core idea is
> to use a const bvec_iter as the pointer to where the block is.
> 
> Then we save a local bevc_iter, and use the local iter to check the next
> few pages until we fill a full block.
> 
> Furthermore, with the help of bvec_iter, we can remove a lot of
> parameters:
> 
> - file_offset
> - logical
> - bio_offset
>   All can be generated by using the @iter passed in and the
>   bbio->saved_iter to calculate the old @bio_offset.
> 
>   @bio_offset is the (iter.bi_sector - saved_iter.bi_sector) <<
>   SECTOR_SHIFT.
>   As when bvec_iter is advanced, its bi_sector is also increased.
> 
>   @logical is simpler, just iter.bi_sector << SECTOR_SHIFT.
> 
>   @file_offset is the bbio->file_offset + bio_offset.
> 
> This means we no longer need to use on-stack paddrs[] to csum
> generation.

This series looks really good to me overall, thanks for making this huge
API improvement.

Reviewed-by: Boris Burkov <boris@bur.io>

> 
> With bio interfaces, the iteration of an fs block is as simple as the
> following: (I tried to change the page/pg_off/cur_len into a macro just
> like btrfs_bio_for_each_block(), but failed)
> 
> 	u32 cur = 0;
> 
> 	btrfs_csum_init(&cctx, fs_info->csum_type);
> 	while (cur < blocksize) {
> 		struct page *page = bio_iter_page(&bbio->bio, iter);
> 		const u32 pg_off = bio_iter_offset(&bbio->bio, iter);
> 		const u32 cur_len = min(bio_iter_len(&bbio->bio, iter), blocksize - cur);
> 		void *kaddr;
> 
> 		kaddr = kmap_local_page(page) + pg_off;
> 		btrfs_csum_update(&cctx, kaddr, cur_len);
> 		kunmap_local(kaddr);
> 
> 		bio_advance_iter_single(&bbio->bio, &iter, cur_len);
> 		cur += cur_len;
> 	}
> 	btrfs_csum_final(&cctx, csum);
> 
> However there is still one caller left:
> 
> - RAID56
>   That will be only location left without a bio.
>   In that case we can easily craft a local helper to do csum generation
>   without using on-stack paddrs[].
> 
> Qu Wenruo (4):
>   btrfs: replace btrfs_repair_io_failure() to use bio for page iteration
>   btrfs: enhance btrfs_data_csum_ok() to use bio for page iteration
>   btrfs: use a shared helper to calculate data checksum for a bio
>   btrfs: remove on-stack paddrs[] array usage
> 
>  fs/btrfs/bio.c         | 140 +++++++++++++++++++----------------------
>  fs/btrfs/bio.h         |   5 +-
>  fs/btrfs/btrfs_inode.h |  12 ++--
>  fs/btrfs/disk-io.c     |  25 +++++---
>  fs/btrfs/file-item.c   |  20 ++----
>  fs/btrfs/inode.c       | 114 +++++++++++----------------------
>  fs/btrfs/raid56.c      |  47 ++++++++------
>  7 files changed, 159 insertions(+), 204 deletions(-)
> 
> -- 
> 2.54.0
> 
