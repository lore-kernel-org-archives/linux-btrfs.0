Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98803126BF
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 21:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779484515; cv=none; b=jkF4A3Klx1eEMZ7dDu2moSFAhxmvo6/63wPquU1bHh+xuQdZt327bJekgkN1OrTqz0RS2CcHed23p3SZ2Hzla5ItTucPgolgX31+0p4uTnzU7O8gEnbxcc9w9MhwZTJU6EAZIexgO5iKqU3m81VB/IB31OuefbqXrDOYj4UPczE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779484515; c=relaxed/simple;
	bh=p7120bGKfIVXyAWeVB4qMtO3FES6dOMR8svQd6/cTtY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KM+dOzJFhdlfBSAQx9oic+scztc1gOJjB/ryPdae6EOHTeEH3eMMgLX0g6DDuKoEcdElZTJrkNdZQNoLlIgXJaGjiEd4S8Z7gFdUpkO8sCAhfzXe2U9KlwxH7L6LgUF+YgM9PKI6L/ytgfDO4fCu/W4h4VtwIUC2d/cT9bMZI1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=UyBmuw3d; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=BArL48rS; arc=none smtp.client-ip=202.12.124.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="UyBmuw3d";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BArL48rS"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 883A67A005F;
	Fri, 22 May 2026 17:15:12 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Fri, 22 May 2026 17:15:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1779484512; x=1779570912; bh=3ZTXjcbL83
	1aDaQftrVlzDqH+j8+i5R+imPXBs21dcg=; b=UyBmuw3dR9jEj/MFe+fQYoCf5t
	s6EA6GuLFDC0x6rShqt1DRs9HJDhW0S1MXUED6eOBxeZK84lRyEGD2ptPRXBpNan
	F9JWV/TyVY8ClzfAn/UDloqOU9IEOWte2/Zlmjh8dJrpY1bzpnChHE7+6VmyiqSH
	fgrENm9n0Rolu+igHB/DuiMPy0uB7kvQnwz2WOI0u0uyyVRUSI2bfK6/IsnnGfRy
	mxN553AH0/mTTmAk+F7TNJB4NmmJ/6hLmz6wvRKs2fmv6eaiFJVdU2Aq2Mjwvu7n
	ZhynpskflokZvYj3M5KsJrIj52jiyj7XwbkEP+uzpOjK1c7waWB0fVC6axaw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779484512; x=1779570912; bh=3ZTXjcbL831aDaQftrVlzDqH+j8+i5R+imP
	XBs21dcg=; b=BArL48rSQOVSTev2WTnposc+4GGGdlDKHd2LUkj4qBXKtO6o4Ti
	0hMk8/CkI+Zpt3q5I+i+FaOt3MK9xhxwn6pru8aeyX69T+nrHje8yyZ+SjOxgf/x
	7di8CsUK6IyuN4DAk1LY/Ck0DXtxNIuBPV5S90IIJQRBtky+2DpSDBM2zOvF8Aya
	2olFeZnjoBOd6e+J6Uqg6d4QObVQtLOqR8y/mMnyU5R6R+XKkh3qIbBHugrmtmhS
	pE57mT80XKzQ+WIrBRN/gC7LF32NVqWW8FzENAQpyY1SkVtDVMgwqLm7Ni7SpFyd
	j+admsNQd963HF9EfxaKwogAOVJhlB8pn2g==
X-ME-Sender: <xms:X8cQap5jdxkx3YkA-b0ED-43ixzKrIADpIAv6YBjQj4Sse4TxuVrMQ>
    <xme:X8cQapJiy_M0ILZzoqO92P2_NI-ckrtCVS9V363XDZOmWoPzokr5JvHxjgIp0CjAV
    ZG8fc2cxCk1capTIsfTfEfLvxuq2E-DESHBw4Hb9Mgm2c7U2hmYCwbu>
X-ME-Received: <xmr:X8cQaisABO7-SPnKeYpOHDRZVmDaym_t4IR_lKkAllVNdfO2cj7VLHsDoX9ZVKjnbG7kpKHFlzlnTBh6BKdqvPOSepc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduheduvddvucetufdoteggodetrf
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
X-ME-Proxy: <xmx:X8cQaoIiLvBRJ-9k4zLJMPUtAWbcW-aO7n-zN4yQ75ALY8Xqnpnisw>
    <xmx:X8cQar9RMoqG2rGPip4FdZ_KHLFfDh3gDy4-diVkM76KSbkuvIsIbw>
    <xmx:X8cQahzIP12FzjjHDmWOTb_TPTG8zWUYSVx6DcCwRgfsrkNT_OnYRQ>
    <xmx:X8cQao63mzfKeIurJBNcOXhMrJPLuZfSVmTvltDIoMd1Dt9Wt3GuUA>
    <xmx:YMcQapr2vIb8j-1O8zPPJ_wOPCi0448tRq2APMqQ7QwQG0SOf72A40TX>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 May 2026 17:15:11 -0400 (EDT)
Date: Fri, 22 May 2026 14:15:06 -0700
From: Boris Burkov <boris@bur.io>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: Re: [PATCH 2/3] btrfs: Use folio_put()
Message-ID: <20260522211506.GA3282973@zen.localdomain>
References: <20260522181411.2487732-1-willy@infradead.org>
 <20260522181411.2487732-3-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522181411.2487732-3-willy@infradead.org>

On Fri, May 22, 2026 at 07:14:08PM +0100, Matthew Wilcox (Oracle) wrote:
> Calling __free_page() on folio_page() happens to work today, but
> won't always.  Besides, it's far simpler to call folio_put().
> 
> Fixes: 082d5bb9b336 (btrfs: migrate extent_buffer::pages[] to folio)

I'm used to Fixes: being for bugs rather than cleanups. I obviously don't
mind, but it just stood out to me.

Reviewed-by: Boris Burkov <boris@bur.io>

> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/btrfs/extent_io.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 2275189b7860..478b7d936aa4 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3394,8 +3394,8 @@ static int attach_eb_folio_to_filemap(struct extent_buffer *eb, int i,
>  finish:
>  	spin_lock(&mapping->i_private_lock);
>  	if (existing_folio && btrfs_meta_is_subpage(fs_info)) {
> -		/* We're going to reuse the existing page, can drop our folio now. */
> -		__free_page(folio_page(eb->folios[i], 0));
> +		/* We're going to reuse the existing folio, can drop our folio now. */
> +		folio_put(eb->folios[i]);
>  		eb->folios[i] = existing_folio;
>  	} else if (existing_folio) {
>  		struct extent_buffer *existing_eb;
> @@ -3410,7 +3410,7 @@ static int attach_eb_folio_to_filemap(struct extent_buffer *eb, int i,
>  			return 1;
>  		}
>  		/* The extent buffer no longer exists, we can reuse the folio. */
> -		__free_page(folio_page(eb->folios[i], 0));
> +		folio_put(eb->folios[i]);
>  		eb->folios[i] = existing_folio;
>  	}
>  	eb->folio_size = folio_size(eb->folios[i]);
> -- 
> 2.47.3
> 
