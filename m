Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEAC456DFF
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 18:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784831312; cv=none; b=scCUnajmZdtQyEqWE9p5n4jYMS0qr7QgG6Am474+3VD7Ft/lJDQSViq7ud04sC0UZbdWrogqBW0hjcDf4ouwMiQtG5kdSaVBrofQvIoK33jo/FFNo6vS9CI4BSs+5XmnzqwOcH1jY5NcCah0/CxFAY5v6cEebBaCcg9FhDa7rtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784831312; c=relaxed/simple;
	bh=RDnJOg7il/vGjTNucUrzAXwzAn3rxgANIxjFzqjr+n8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sIyyZ8cKUXO/3/8I2+rfx/7/+NLo1d6zSEwTsdCPayVPpZB9Xk/v/RHQbEXkZbs9IUKeVEZy8Bm7V+e1MK3idyBCgr0RttOGfuSjQS1gM7Phd7bdS74CWjWGaCh+ssQbCtP5WJFSYEFi7ZdEemQGiWE+1SVAPc4IoOJmNikHg+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=F3KMFhEb; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Dp/E+8t8; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="F3KMFhEb";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Dp/E+8t8"
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.stl.internal (Postfix) with ESMTP id 7201A1D000F6;
	Thu, 23 Jul 2026 14:28:14 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Thu, 23 Jul 2026 14:28:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1784831294; x=1784917694; bh=QyAWd3fCgR
	BpV9NDAYQ5siXn0GSsoGtug9eyoFwQ2q4=; b=F3KMFhEbWJ7ahoyoI9lfddTBUK
	H+76Ap2HDgoUzJkHJl5IpczRNaFTZjJ0Y3jMxzWWuR1Lmc5CHb1kn+az12BCzTn7
	/k7dhGA51ghapbmZ94ez6CXL6+toy7bP+fRFqy5yf7rto7bZ6cH9JugP0X+T6TuW
	OYBV5rFII/2YN2UoIv+h80rlz9J6prw2lcF/dhhAptfbX9LKoCOFTNc8CE0SsCPT
	KFc5HpSO96Y4o3S0/bZVT9YCn4jPP/hOwev9yA0f2b8jrYfxT41th6MToxQgYXB8
	RePgaawj69q+zDt/B21vU3A8BI4bKPcLwoSCDp9FJjRlSPrFKEOkA9AXZ5cA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784831294; x=1784917694; bh=QyAWd3fCgRBpV9NDAYQ5siXn0GSsoGtug9e
	yoFwQ2q4=; b=Dp/E+8t8U2yEnByufsNXKxPfAUqL6vBcEri0y3Sx+Zy+Z5AAdoW
	rQVk8QLHjLQPzsNvXH3dyi3v+ge8/map6/MRqY3zIQEA1OAVwjZgs9K1l35D8AfQ
	BwKjgv/fhy3UAdYr+v6EHGD0jqbEse0I4d6MNxmX++xXTTNN+P6iRYd/G6LdggLE
	LMRCrxlMBupuSWyDNTtIEQ1CQOH3hCmCJEGvCHVcOVhfnC1eq4Ba+2S3fPrNUwdQ
	s3awzSMrBzEoHCmWe0wykoMvgudIENEBvr+owV1TyM+S6+6+TxASYE74nzN6kkcp
	Be/jgwzUZVE0mFT5BTF8hZ+RS8F8ruNHz0A==
X-ME-Sender: <xms:PV1iapxobmnAOqX4Ekvfq5mymVTxO8NP_x2Y4x3Ga-uFCg3HLnckrA>
    <xme:PV1iaguqoH9SSbMWL1lQPMON9jZBsxpN_okvWKvlSG854--lVJAnyoHxOSGT49lVh
    PUDFvr8t_Ov_6Bu5jgKUeBNxFIkjlRbkURoUFSsSnEqwKMw3K89KLg>
X-ME-Received: <xmr:PV1iagtR0DCXw_gPOgly6xuOHtM5qcG7FU08lAlqlKf9dw1pdhy8TvXQ0vpW--sbMG5S3Xp_m1Nt7GqlZitnO_YFIo8>
X-ME-Proxy-Cause: dmFkZTEAAX1TWPYhXrlsTPkVvNZiO5s8dTY1RiHE3hf3ygUN498PfiNNAOeKb5KIxlsoEr
    r0WI9ctxQfsFtQnyWaMYRHOih4LCScGdQF+h7mIbqrC6BILU3ol/pYZOq8fgp/KULKkusC
    fIO7rBAl2vESqIAT3EhiBOKqh0FKRbhzmWMDEW9d+1NOWmuQwhNjMAE2Kws/86HepGZUwe
    0vn0HNCYKa7JqHAT+sqMeKesL5zm5ZwSZfzld7gSu4KlNlltrKEd0TKGaqkjvv0X47rxcb
    MWwMY+mOoUm281iawixBxb/nm5Tx6YyhTF0F+TgDt0d5Gh6dw8lgbSx0XK3+4graUYrbCM
    GLLSLLd4NM3KabIa4AEnvjLD6rPFvMUjwVmlhP9++fuGpyCpWD7wQ3jy52JI+hlUm5BKiH
    HmRq81fQdtcOlR2Q7tGchK+reUbFLsio6VrjT8duRctUTXpRVdeBWhn9lsagN2THq3BlMa
    V6ZyEN33j+AfALP/+l+WKzXGIvGsku/r2N71haWYvdfjlQ0fyhhlWir/T7j3/xWKTtahfU
    FgcX38qFqEji7VfmWcLIZ9yL/6uAxYEwjbMaxdWe/ktpWbQLpxjb7vJPhgl7N35+pgiQwy
    qwpp71EWfP487EH18p5DYgwRLYcOCAUTf7O0pmF4/XfHgYuKN77qdTb1LCsA
X-ME-Proxy: <xmx:PV1ialPncBqkGfEgU-SDD-10rVeQK5n7i0tC6l_90rm2WpAWtAE3uw>
    <xmx:Pl1iau2LzFYbggNRyUZGyeTbtOrZXOUHPQdKjYsLWmGZvqNCbNZXvw>
    <xmx:Pl1iahMD3Ek0cP6M96Bv20F5wE28i79HTPNzsT8Q_bfvBFnINqNpgA>
    <xmx:Pl1iau1qx9pgcSPuBDD5QhFBTxyRq_W1a3TIPbNzzMdXhPXRrkONXg>
    <xmx:Pl1iavSr-JyeMvVvYNXOwMOy5VlSvDgLdH9mfhFXBzEmM-oLOAGaALon>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Jul 2026 14:28:13 -0400 (EDT)
Date: Thu, 23 Jul 2026 11:28:02 -0700
From: Boris Burkov <boris@bur.io>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 0/4] allocate extent_buffer GFP_NOFAIL with unlocked
 retry
Message-ID: <20260723182802.GA788943@zen.localdomain>
References: <cover.1784673567.git.boris@bur.io>
 <20260723025857.GO10684@twin.jikos.cz>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723025857.GO10684@twin.jikos.cz>

On Thu, Jul 23, 2026 at 04:58:57AM +0200, David Sterba wrote:
> On Tue, Jul 21, 2026 at 03:42:11PM -0700, Boris Burkov wrote:
> > >From sampled fleet data measuring lock holders that go into direct
> > reclaim with a waiter present when they eventually unlock, we have
> > observed ~15% of those are btrfs extent_buffer allocations in
> > btrfs_search_slot() done while holding btree locks. This is the single
> > largest category. Additionally, a large source of hung_task timeouts is
> > both btree waiters and direct reclaiming btree allocations, which
> > further motivates the desire to drive down this source of stalls and
> > contention.
> > 
> > The aim of this series is to allow us to allocate the extent_buffer,
> > btrfs_folio_state, and the extent_buffer folios with GFP_NOWAIT then
> > fallback with EAGAIN to outside the critical section to retry with
> > GFP_NOFS | GFP_NOFAIL without any locks held.
> > 
> > This is analogous to how we must drop locks to read an extent_buffer and
> > then EAGAIN.
> > 
> > The series does not manage to completely eliminate allocations from this
> > lock holding path, as we also allocate inside xarray functions for the
> > extent_buffer xarray and the btree_inode mapping xarray, the latter of
> > which is done via filemap_add_folio() with no reserve type API. Luckily,
> > those particular allocations are small cached slab allocations and have
> > nearly no contribution to the production reclaim fueled contention.
> > 
> > Changelog:
> > v2: 
> > - rebase
> > - dropped the inhibit array allocation patch
> 
> Reviewed-by: David Sterba <dsterba@suse.com>
> 
> The logic makes sense to avoid the stalls. There's no sashiko review
> because the patches did not apply. You may want to resend a rebased
> version to see if I have missed something, there are minor typos or
> style things but that can be fixed during merge.

Hmm, interesting. I rebased on the btrfs
(git@github.com:btrfs/linux.git) for-next branch before resending, and
it just rebased cleanly, and I was able to 'b4 shazam' this version onto
for-next as well.

Am I messing up and using the wrong branch? Is sashiko?
