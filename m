Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C997B332615
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 21:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779484828; cv=none; b=auUznZNPs2NQgvHvMkLKX3FMRQfKW5tPB7hFmwaN4Wd0axYgYHjl4Ojolai+nD1x3Cx1ZrGj7c1EvRvCpo653J0CkOJZojjVlhke5DKWRQJNnR2KGZJ8hFKeCE6ZKfVlqxdb3xmovuvFWZCREC9dX2XniIFFOV9TqGn6neqFGz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779484828; c=relaxed/simple;
	bh=5o40Pk5f6RWMvtMm0rCIYJwsTZvzHaFjsc2k/eUk+Ik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sxBixljlEiCn35EkWfY5CpCDrWgxvwkH8Pj+NmXoFFl2zg+4HSoqDqhGrI7wIsLNyPEzlcop2HfgEypp/7+4tLwEjc3dM5tnpAidld5Cb0ylUibnoI/zPiVLy67XkL3KiJ0c55Amq3Etvd4qs2ms4AsuhJiy0/HJIy20nMzRCCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=Fg44bmEo; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=S/iZYTH0; arc=none smtp.client-ip=202.12.124.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="Fg44bmEo";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="S/iZYTH0"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id DC8C57A0071;
	Fri, 22 May 2026 17:20:25 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Fri, 22 May 2026 17:20:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1779484825; x=1779571225; bh=hkfu+bdk2H
	K+6jXufa0eDQnIDhzi0XuklH7/3C4jM9M=; b=Fg44bmEoF3+4IyZABRqIeX+NiW
	XRetqAaW4wkqcBDs8SyosARu4G0f0VwYSVKOWLPWtoNp0Ve7AtlAafSF140TPzQF
	t2vSrGdyLrHnS2zXtyAN+EIxyJIEWiClP/OEGQpyo3hmBQBxXQorzyBBdzWmrAhB
	NetHsuKBWunVC9IrHAqGh9ynezqxJ9mmczaBVZAAJi8e/xNn3EGMRwD8n/P9nAqT
	iWKvJXnnZKgSCAJNB/VYxA/kn8qs0u6OA+S32MsOyRTI3GtOIYjMpmSHLRCRY/xO
	8YP4M9qsYggBTMxJeJl1vuiQj19QvHZ9kUFjfaJoIw12Z90/aTq56nsFNOnQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779484825; x=1779571225; bh=hkfu+bdk2HK+6jXufa0eDQnIDhzi0XuklH7
	/3C4jM9M=; b=S/iZYTH0EzrRzDIUKw3Nm90zG+SzXmUpinrJJsMUtMizefj8I01
	U0ZLz8y11wBBXY1FfmJ/jqmeDIosP3YnEaHIuD4lPP/IGfa3yniSmWZkioSrJUHg
	cAye9YwSkgOubUE3t/yHiEf5FCVKN7cN16It6JgmTtVNqKCHv1n+OFxUyDoBzgd6
	Kv7q9bT7eOocwGaxRXfb/sJFRwYWarYOIKu/bxhDfolhg9hpUKXnet8m/LmhBHMi
	SpGkgN08DYr0kAUPxEp2/daGRvq7CnW5TUXi+eZkH5HUN2XL9rMPXc26weBohd3q
	fxMxYzSZkawuqy+rx9cOCiZZn1RAut/2aQw==
X-ME-Sender: <xms:mcgQagCOx2B3Gq1hnJD8CSVy3hbjNHotPruqeNIwIS0rHLelewsiXA>
    <xme:mcgQakx6WWUDQcQM9DivzZlCEpRNUS7k4ud1QFaScKk4KQnMrxsU_-OttiGYuCt2Q
    3Cqr2PAwBwwErRQJo6qOprbS6bMHJNku2gwpk2atuI-On1BINpetrV1>
X-ME-Received: <xmr:mcgQal02TRybrqGQu6g1xRllOaiBX0K6AFB-kehG97iy0BWwtMMOUimM1Aiwc8wEvZdcx-SRWlPpxU4cS8EBqGlr4cU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduheduvdefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehorhhishcu
    uehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpeekvd
    ekffejleelhfevhedvjeduhfejtdfhvdevieeiiedugfeugfdtjefgfeeljeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepjedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopegtlhhmsehfsg
    drtghomhdprhgtphhtthhopegushhtvghrsggrsehsuhhsvgdrtghomhdprhgtphhtthho
    pehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    epfihquhesshhushgvrdgtohhmpdhrtghpthhtohepfhgumhgrnhgrnhgrsehsuhhsvgdr
    tghomhdprhgtphhtthhopehsfigvvghtthgvrgdqkhgvrhhnvghlseguohhrmhhinhihrd
    hmvg
X-ME-Proxy: <xmx:mcgQaswhI74lxjFdb6oTALl1wb9Gopa_YXytrH-txm9sj7LdevJk0w>
    <xmx:mcgQakGAF91M1MO6WHlhzyggQ7g_edz4rS1n_EmcTUUsX2o5g9vbsQ>
    <xmx:mcgQanZhdSxAN2fJQYIaDIXmvzss5b6_CqVDhV7aYed9qFbD0x5tSQ>
    <xmx:mcgQauDeLARZzzgUyBKva3W-lmn-pAXDmmqehpJ347pZFgqAB6XblA>
    <xmx:mcgQaoRaE4tptsgD9KN3QIyBfk33XeRjosDgkGWQF9Pqi4I2KdPM3lIN>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 May 2026 17:20:25 -0400 (EDT)
Date: Fri, 22 May 2026 14:20:20 -0700
From: Boris Burkov <boris@bur.io>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: Re: [PATCH 0/3] Three folio-related btrfs fixes
Message-ID: <20260522212020.GB3282973@zen.localdomain>
References: <20260522181411.2487732-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522181411.2487732-1-willy@infradead.org>

On Fri, May 22, 2026 at 07:14:06PM +0100, Matthew Wilcox (Oracle) wrote:
> All of these were discovered through auditing the (mis)uses of the folio
> API throughout the kernel; I haven't been specifically reviewing btrfs,
> nor testing.

I ran this through my btrfs fstests setup and observed no regressions.
However, that is on x86 systems with 4k blocksize so it was not exercising
subpage block size directly. Which means the revert is still relatively
untested. I'll try to get a proper subpage test done if Qu doesn't beat
me to it.

With that said,
Reviewed-by: Boris Burkov <boris@bur.io>
Tested-by: Boris Burkov <boris@bur.io>

> 
> Matthew Wilcox (Oracle) (3):
>   Revert "btrfs: fix the file offset calculation inside
>     btrfs_decompress_buf2page()"
>   btrfs: Use folio_put()
>   btrfs: Remove use of bv_page
> 
>  fs/btrfs/compression.c | 18 +-----------------
>  fs/btrfs/extent_io.c   |  6 +++---
>  fs/btrfs/inode.c       |  2 +-
>  3 files changed, 5 insertions(+), 21 deletions(-)
> 
> -- 
> 2.47.3
> 
