Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A653DBD59
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 22:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775083984; cv=none; b=vB7arYQzY4cih1fIgqTJhhetZ/URoMDjIZV1K2XKXobPSPKomXgrGtij4hIJ/W5DF4G82MPtr6r8w0lqadubTQt0DFRGiC248wLAG+iYa2Q0GvbVtG3L2YK7bhuOVVeM/y9F9fMjlVFn0Y9TbVAuRTl49MTBHsvRHYT6FkCnD0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775083984; c=relaxed/simple;
	bh=9ND7Tnq4dWkreBQ9VRQDTNLu789aflCf/whIUSNbNNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qcwHtf5qL0WJsWq8pKK6C1HSe8tXBtghSJSJSY4gu1S52ZAeAs7Kqfhhkf/QmMtqfujo/IOy7dyBP7xckFk/2Kg/+PLzNNdMuNkic5XsPvKy2ivqhA6Vu2v7kpyYzd2rZJZ+9OMR2wnnEWHtyYTaHDgF2pBBHbnbnZX4Ew9AbaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=rkVvqxBa; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Hox80cq0; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="rkVvqxBa";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Hox80cq0"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 169F6EC02C7;
	Wed,  1 Apr 2026 18:52:57 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 01 Apr 2026 18:52:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1775083977; x=1775170377; bh=3Eqai1O3s/
	o3i1TDnnfvWilT5wXzi1Daon9JRgGeWsU=; b=rkVvqxBaJWQ5Sl6r8qxXhEo1jE
	RC2U5y0cLpPs0f/7k+5bqisKbqCovaSz82C15kOiSR8lVXriJ0MDko1DXUqUs++I
	p/Y9bV+XLHsRqqsvDXPphx8AhdMqH9IzBQFEr1fRwTJVDtD2YwG2i7eOGL89DuAx
	Yqu+kjACJTeqNZ8QlmBg3Gi7VM8u9bhhU0kP1eGeN5+p20H1QicmOt4VYqYWgIzm
	ICC5VPf+ju6Lrx0O05NxHnFtGsdVaZ9iIXaIqP5/Wb9v8GRS9fg/rjsiGyHkLzMM
	58OItIjFRXBs+3Xphx1xGZHZDI2az5jtYEtXcq19QXvd9jQPwkVfx8IFjPsg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1775083977; x=1775170377; bh=3Eqai1O3s/o3i1TDnnfvWilT5wXzi1Daon9
	JRgGeWsU=; b=Hox80cq0est+dvx1iJbbHQRmzxcGuLUMCZMjNkEDdlq00+j8b46
	3Sq3V7GQlxIRhKtbKIOqUDneSBpO5AWoLIXdcOmwd0CEpGw5aiZcaVfuCIgH12xS
	NfWSOSB3lJY1birrAl30NhvYZasuqYaahZyNKAWX57xT5o0Inn8pxFbgbHxGEhZt
	YdP7q2Bi87oIkEWG3M1CmryLTNUVARILjTUbByITWw59lzgh/eNmyZ4t+aD4PE9j
	K3gNnTEK08m4f6XnCSUd+IVZakTArAhe4Ub+d8OKWe5yX6l2SF9WgvJ7v5MA8Nwm
	un7v17133VNO+RyKLvnXvAUqPiTueZ9oCXw==
X-ME-Sender: <xms:yKHNaUU5EFiiJr_uFqAWbaAxDjOWEdKbTG0KGsWtPynpP_3tvFM9Vg>
    <xme:yKHNaen_i4wPbxUHu5EKePzYglUBTJaV1RZ-ChOfeOMZ5sEE0IjvxAYsXCeLkvu1w
    2LC2gk-sjbrBzynDGOm5pDf2m3P7_BvKMgjHLv3sQayeyaW-QKT>
X-ME-Received: <xmr:yKHNaWBCnMxa12vTHeSgE5TzZeWUk3_5LIVBfGm0Qs1KDpMloOraaTYuaUNHRCkSc2nrxqVE6AYMKrDL85xuw26QYCQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegfeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehorhhishcuuehu
    rhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpeekvdekff
    ejleelhfevhedvjeduhfejtdfhvdevieeiiedugfeugfdtjefgfeeljeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrd
    hiohdpnhgspghrtghpthhtohepvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohep
    fihquhesshhushgvrdgtohhmpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvhhgvg
    hrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:yKHNaefLhBofRV9jdkAErNvkPQv7FRgf4lYKEhI7zLDmssLJVFyiCQ>
    <xmx:yKHNaRLZds5jB7bF8pmMK4HJn7S400kbwoFQCI5fBQI8CUNA9y3KFA>
    <xmx:yKHNaReE0AX3za1OMcVplxmHEgFGPS3LODhXMKU3ra-vREzp45bGzw>
    <xmx:yKHNaY2aPWMWc9H9XGKMm7dctGcvaZmoFl1XF52Rkp8yCVo8qBy2oQ>
    <xmx:yaHNadCwYJxKcMIbLhDHVq7Er2vjKFyEJjbkYSefQ5CbpAdMvTSBom2c>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Apr 2026 18:52:56 -0400 (EDT)
Date: Wed, 1 Apr 2026 15:52:57 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] btrfs: delay compression to bbio submission time
Message-ID: <20260401225257.GA826348@zen.localdomain>
References: <cover.1773953307.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1773953307.git.wqu@suse.com>

On Fri, Mar 20, 2026 at 07:34:44AM +1030, Qu Wenruo wrote:
> [CHANGELOG]
> PoC->v1:
> - Fix the ordered extent leak caused by incorrect ref count of child OEs
> - Fix the reserved space leakage in ranges without a real OE
> - Fix the hang caused by incorrect extent lock/unlock pair
>   All exposed by fsstress runs
> 
> - Fix the OE range check in btrfs_wait_ordered_extents() that affects
>   snapshot creation
>   All exposed by fstests runs
> 
> [BACKGROUND]
> Btrfs currently goes with async submission for compressed write, I'll go
> the following example to explain the async submission:
> 
> The page and fs block sizes are all 4K, no large folio involved.
> The dirty range is [0, 4K), [8K, 128K).
> 
>     0  4K  8K                                        128K
>     |//|   |/////////////////////////////////////////|
> 
> - Write back folio 0
>   * Delalloc
>     writepage_delalloc() will find the delalloc range [0, 4K), and since
>     it can not be inlined and too small for compression, it will be go
>     through COW path, thus a new data extent is allocated, with
>     corresponding EM/OE created.
> 
>   * Submission
>     That folio 0 will be added into a bbio, and since we reached the OE
>     end, the bbio will be submitted immediately.
> 
> - Write back folio 8K
>   * Delalloc
>     writepage_delalloc() find the delalloc range [8K, 128K) and go
>     compression.
>     Instead of allocating an extent immediately, it queues the work into
>     delalloc_workers.
> 
>     Please note that the range [8K, 128K) is completely locked during
>     compression.
> 
>   * Skip submission
>     As the whole folio 8K went through async submission, we skip bbio
>     submission.
> 
> - Write back folio 12K
>   We wait for the folio to be unlocked (after compression is done and
>   compressed bio is submitted).
>   When the folio is unlocked, the folio will have writeback flag set and
>   its dirty flag cleared. Thus we either wait for the writeback or skip
>   the folio completely.
> 
>   This step repeats for the range [8K, 128K).
> 
> AFAIK the async submission is required as we can not submit two
> different bbios for a single compressed range.
> Which is different from the uncompressed write path, where we can have
> several different bbios for a single ordered extent.
> 
> [PROBLEMS]
> The async submission has the following problems:
> 
> - Non-sequential writeback
>   Especially when large folios are involved, we can have some blocks
>   submitted immediately (uncompressed), and some submitted later
>   (compressed).
> 
>   That breaks the assumption of iomap and DONTCACHE writes, which
>   requires all blocks inside a folio to be submitted in one go.
> 
> - Not really async
>   As the example given above, we keep the whole range locked during
>   compression.
>   This means if we want to read a cached folio in that range, we still
>   need to wait for the compression.
> 
> [DELAYED COMPRESSION]
> The new idea is to delay the compression at bbio submission time.
> Now the workflow will be:
> 
> - Write back folio 0
>   The same, submitting it immediately
> 
> - Write back folio 8K
>   * Delalloc
>     writepage_delalloc() find the delalloc range [8K, 128K) and go
>     compression, but this time we allocated delayed EM and OE for the
>     range [8K, 128K).

Just for the sake of the description:

I think it's helpful to be more clear that we unlock the delalloc
range here.

> 
>   * Submission
>     That folio 8K will be added into a bbio, with its dirty flag removed
>     and writeback flag set.
> 
> - Writeback folio 12K ~ 124K
>   * Delalloc
>     No new delalloc range.
>  
>   * Submission
>     Those folios will be added to the same bbio above.
>     And after the last folio 124K is queued, we reached the OE end, and
>     will submit the delayed bbio.

Can you explain the importance of the delayed bbio more? Why not just a
work queue item directly?

> 
> - Delayed bbio submission
>   As the bbio has a special @is_delayed flag set, it will not be
>   submitted directly, but queued into a workqueue for compression.
> 
>   * Compression in the workqueue
>   * Real delalloc
>     Now an on-disk extent is reserved. The real EM will replace the
>     delayed one.
>     And the real OE will be added as a child of the original delayed
>     one.
>   * Compressed data submission
>   * Delayed bbio finish
>     When all child compressed/uncompressed writes finished, the delayed
>     bbio will finish.
> 
>     The full delayed OE is also finished, which will insert all of its
>     child OEs into the subvolume tree.
> 
> This solves both the problems mentioned above, but is definitely way
> more complex than the current async submission:

I mentioned a few key questions in line, but I think they how and why of
"this solves both the problems mentioned above" is lacking at a high level.

As *I* understand it, the basic explanation is:
=====OLD=====
WRITEBACK
lock folio F
lock_extent_delalloc_range([F,F+N])
submit async chunk work
folio F+1
block on folio_lock()

ASYNC SUBMIT
do compression
do allocation
create OE
unlock folios (except locked_folio)
submit bio for OE

WRITEBACK
unblock on F+1
no-op
etc... till F+N

=====NEW=====
WRITEBACK
lock folio F
lock_extent_delalloc_range([F,F+N])
create delayed OE
unlock folios except locked_folio
lock folio F+1
add F+1 delayed bbio
etc... till F+N
"submit" delayed bio

ASYNC SUBMIT
do compression
do allocation
create child OE
submit real bio

Is this correct?

If so, the "magic" is in the delayed OE providing enough synchronization
to allow us to unlock the folios right away in the writeback context. So
we are breaking the contract "OE <=> allocated space" to allow this. I
think making the absolute core of the improvement more apparent in the
descriptions would be helpful.

I think one thing I still don't understand is the desire for the layered
bios/OEs instead of creating the same delayed OE, but then as we do the real
allocation/compression and discover the actual ranges doing
btrfs_split_ordered_extent() like short DIO writes, which seems quite
similar. Splitting/joining feels like a much more natural model for
ranges like OEs than layering into a tree. As we discover the sub ranges
we actually use, we split off the real OE.

I actually think this sort of makes sense for non-compressed too, where the
reserved size can be less than the maximum you tried for, just the same.
Probably too early to try to switch over everything, but it could be a
uniformity benefit in the future.

Fundamentally, I think it just feels kind of strange (with the old code
or the new) to have the one folio at a time iteration in writeback that
does lock/unlock on each folio and the delalloc locking/iteration that
we really need to do the right thing with extents. I would love if we
could reconcile them more completely rather than just hacking OEs into
submission (no pun intended :D).

I actually think your model is quite close to what I want, I think it
might just be too hacky/incremental. I am ok with moving forward with it
if we can also envision future next steps for further simplification.

I read the patches but apologies if I missed the answer to some of my
questions in the code.

Thanks,
Boris

> 
> - Layered OEs
>   And we need to manage the child/parent OEs properly
>   But still it brings the minimal amount of changes to the existing OE
>   users, and keep the scheme that every block going through
>   extent_writepage_io() has a corresponding OE.
> 
> - Possible extra split
>   Since the delayed OE is allocated first, we can still submit two
>   different delayed bbio for the same OE.
> 
>   This means we can have two smaller compressed extents compared to one,
>   which may reduce the compression ratio.
> 
> - More complex error handling
>   We need to handle cases where some part of the delayed OE has no child
>   one. In that case we need to manually release the reserved data/meta
>   space.
> 
> Qu Wenruo (6):
>   btrfs: add skeleton for delayed btrfs bio
>   btrfs: add delayed ordered extent support
>   btrfs: introduce the skeleton of delayed bbio endio function
>   btrfs: introduce compression for delayed bbio
>   btrfs: implement uncompressed fallback for delayed bbio
>   btrfs: enable experimental delayed compression support
> 
>  fs/btrfs/bio.c          |   1 +
>  fs/btrfs/bio.h          |   3 +
>  fs/btrfs/btrfs_inode.h  |   3 +
>  fs/btrfs/extent_io.c    |  29 ++-
>  fs/btrfs/extent_map.h   |   9 +-
>  fs/btrfs/inode.c        | 492 +++++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/ordered-data.c | 181 +++++++++++----
>  fs/btrfs/ordered-data.h |  14 ++
>  8 files changed, 678 insertions(+), 54 deletions(-)
> 
> -- 
> 2.53.0
> 
