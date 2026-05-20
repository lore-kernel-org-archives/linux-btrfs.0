Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E0F3F20FF
	for <linux-btrfs@vger.kernel.org>; Wed, 20 May 2026 18:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300187; cv=none; b=J0kLA3gMeHNIhDANJfNOIeODRodQaL5DtgXs4Wqj+agQTCETChpTRY2XcEWQaGSqXMrf7/iQ3wT/4w51TpU941Xwo/WIQ5J5pr+M5GoFnhaEAMSnUyS95swYJxSjN/s8jushZNmYppWW2OjqUr4ykXF07ZyUz9oapGSGcb3UJUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300187; c=relaxed/simple;
	bh=0++kqYwcMc+sD8GUZOhljOiPdvu+hO7nAZ2lY9QBQWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N2+cvR6gWG1LUb8p9o8g1ajGnku/NSiJcSsiHkipqTWazUoVEo4J625ppy3R1VX8V6tApz1mc9nGA4itU/1AxUGXcEMm+iJYAvHJ9SvQbfxaEUVeaCRxVG/f7epzvFl9qeMe23KoPT12CRK23zHECYzmd3zE15dsfKgQRz5zmZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=H5qi7/Ga; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=unpUAIfP; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="H5qi7/Ga";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="unpUAIfP"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 8B7B9140011B;
	Wed, 20 May 2026 14:03:05 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Wed, 20 May 2026 14:03:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1779300185;
	 x=1779386585; bh=LuBZGEaIWbcndIsmdYe+gr8eZyq6va3CRWqSsJFc9fE=; b=
	H5qi7/GaW6OajHrowG5Qd8yS8PKJmwNqU6mXZucSPzBhrKqsg59ofvSQd4hhdud0
	ZrJvnhh06wImhfnS7aXZrZ/cilhE31/bX6AHSZ0u8hVNA2xq38PVSpZCglLirlj4
	MWpA7UkKQHI0siI+bj9pxbyTdcEEdGCMmeMPKsmKFLedsuP7XiR4B1QbV0eZjwNl
	khnv0+XxCl+dzgvxBcVLiPnaZzAkjLTIRplxVRUT7PHPXrCVBpDE7sZiURoXjVP3
	2t5V0NF8GDi1a6uB+hRr593NH0z9WKOStWwG7j+0KAhEG7dbeZM7iDBn+bCuUcoe
	N4opjhzYcW7n7IO28z6TvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779300185; x=
	1779386585; bh=LuBZGEaIWbcndIsmdYe+gr8eZyq6va3CRWqSsJFc9fE=; b=u
	npUAIfP0VYDhr/bj0FszSGECuKTiaMiOY4e00xkINwdeKEiJg0jYFTh3h39bk9Er
	UTttJUP5FWmqJrGDxZ7IsoQMmFpgkseNjaWwnTK3MsTe5n+RIWWl/KvZTuuU3M5i
	ARNuRuMr2F0WlFm0Eq2u7gtk99SjLxwDGznsx8cbt3/3oRM0AlLCv10rWF2cyDiB
	Z9PkLJl8qyIxK9szsZGfhEXLZEKVYLVA4Hw0H+WFSXlVRm0+6lGxoHrUAVhlzOEy
	nkUOSKcF/0iLnk7T4pvr6IoT8OuTKOSuhKCJiSrDPmzO6BOckMKqsKpY8t96w60l
	5MOJaOgpCA/Most9bz7PA==
X-ME-Sender: <xms:WPcNamWF518373N9dY-ldvyTaUamODFMI8PxXBN3LPXfVBT5UjFV-g>
    <xme:WPcNahqF8fQL7XuZBZSVExqj4ufFnwNrQu5WztvrmmM6rpN_vIB7qvFfl-T194qDw
    -22Tqp7-ujFDKGp-XMsQ1jTbFmtgV-Qk4MtwkCkXVnzSmpy-F05cTo>
X-ME-Received: <xmr:WPcNagnG7xuo_AaHfy72J08vb4yTCz6HdeyIl7a-M-fAO1GjB_l-4BxUGYpEPoscok3c1MJ2s5ke-G4-4t_gKooZGrw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddugeehfedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpeeuohhrihhs
    uceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepge
    elheehjeegudfhteetleehieffgefhjefftefhheekleeujedtkeeugeetfffhnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessg
    hurhdrihhopdhnsggprhgtphhtthhopeekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehjohhhrghnnhgvshdrthhhuhhmshhhihhrnhesfigutgdrtghomhdprhgtphhtth
    hopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthht
    ohepfhgumhgrnhgrnhgrsehsuhhsvgdrtghomhdprhgtphhtthhopegushhtvghrsggrse
    hsuhhsvgdrtghomhdprhgtphhtthhopehhrghnshdrhhholhhmsggvrhhgseifuggtrdgt
    ohhmpdhrtghpthhtohepughlvghmohgrlheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    epnhgrohhhihhrohdrrghothgrseifuggtrdgtohhmpdhrtghpthhtohephhgthheslhhs
    thdruggv
X-ME-Proxy: <xmx:WPcNap2FOCSriypy4MqiYf4SgEV9r4_qoHnw8IoxcHzBJ4ZdtyTRug>
    <xmx:WPcNalSAFq8XoT8aZN3G0BZPPrhQ0XGKiAyq4bTO9GrhfEhgssaPJA>
    <xmx:WPcNaqwZCMqix3QXSAU8JwcvC6eqBf6CHHxjznv6cgibxLnOPvx1lQ>
    <xmx:WPcNatDG1qF1GlEiOXBNir7sURBLUlnKoYEa6Y_WardYBe4BD5S4zA>
    <xmx:WfcNarzlOxxK2n-13gcCZLwUzjYPRNkNONMsxC97ht2ZlR29irtuRcAH>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 20 May 2026 14:03:04 -0400 (EDT)
Date: Wed, 20 May 2026 11:03:03 -0700
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 3/5] btrfs: zoned: always set data_relocation_bg
Message-ID: <20260520180303.GB1458531@zen.localdomain>
References: <20260519154902.223445-1-johannes.thumshirn@wdc.com>
 <20260519154902.223445-4-johannes.thumshirn@wdc.com>
 <20260519232345.GA718937@zen.localdomain>
 <d20b97b0-3d83-44e3-8132-edf8f2b7ddc7@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d20b97b0-3d83-44e3-8132-edf8f2b7ddc7@wdc.com>

On Wed, May 20, 2026 at 09:32:04AM +0200, Johannes Thumshirn wrote:
> On 5/20/26 1:23 AM, Boris Burkov wrote:
> > On Tue, May 19, 2026 at 05:49:00PM +0200, Johannes Thumshirn wrote:
> > > When searching for a data relocation block-group on mount,
> > > btrfs_zoned_reserve_data_reloc_bg() is looking for the first empty DATA
> > > block-group. But it first checks if the block-group is empty and if yes
> > > continues the search, and then checks if it is the first DATA block-group.
> > > 
> > > Reverse the order, first check if it is the first DATA block-group found
> > > and skip, then check if the block-group is empty. This enusres that there
> > > is always a DATA block-group set as data_relocation_bg in the filesystem.
> > Can you help me understand why you want to skip the first one? Is it bad
> > if the next real allocation just has to allocate a chunk? Why does the
> > data_sinfo need a fully empty block_group rather than just one with some
> > usable space?
> 
> I thought so as well, but I there can be a situation where you pick a bg
> with enough usable space to house only one extent. All other bgs are mostly
> unused. So you relocate one extent to the reloc bg, but it is not enough to
> free up the source block group. Then you have to allocate a new chunk for a
> new relocation block gorup. So if you're now  out of chunks you end up with
> ENOSPC.
> 

I don't see how allowing the first fully empty block group to be the
reloc_bg causes that. That sounds like a bug with allowing a non-empty
data_reloc_bg? I was asking about normal data_sinfo needing an empty bg,
not data_reloc_bg needing to be empty.

Let me put my question a different way:

Suppose you have an fs which has no unallocated space and one empty data
block group. When you mount this fs, do you want the singular empty data
bg to the be relocation block group?

I assume that the answer to this question (even more so based on your
reply above) is that you would want it to be the relocation block group.
And if you had 2 or 3 or 4 or K empty block_groups, I can't see why you
would care which one of them got selected to be the relocation block
group.

So why is the "skip first" logic ever useful?

> > Now aside from the general question, I still don't get what this change
> > does or is for, it kinda still feels like a no-op. Can you be more clear
> > about the case you are fixing?
> > 
> > Previous logic:
> > if non-empty: skip
> > else (empty): if (first): clear first, skip
> > So you skip until you see the second empty bg
> > 
> > New logic:
> > if first and empty: clear first, skip
> > if non-empty: skip
> > So you also skip until you see the second empty bg?
> 
> The problem I saw (and I hope I recall it correctly) is:
> 
> The FS had lots of GC activity then remount.
> 
> All the non-empty BGs where skipped, then the first empty block group was
> skipped as well (and used for data allocation) but the drive did not have
> enough free zones so the FS could allocate a new chunk, resulting in no
> relocation BG to be set at all.
> 
> 
> > Is the relevance once you loop around after allocating a chunk or
> > something?
> > 
> > Assuming I'm not missing something, I think it would make sense to simplify
> > this algorithm to something like:
> > 
> > 1. Try to steal the first empty bg.
> > 
> > 2a. If stealing succeeds, do some arithmetic on the data_sinfo.
> >      If zone usable is 0 (or < a chunk?), allocate a fresh bg into
> >      data_sinfo. If no arithmetic could ever work, do a second pass?
> > 
> > 2b. If stealing fails (no empty bgs at all), allocate a fresh bg into
> >      the data reloc sinfo.
> 
> Yes actually I can just skip the whole 'first' step and any data allocation
> will create a new BG. And if we're out of zones to allocate a new data BG we
> need to GC anyways.
> 
> 

OK, looks like we agree, I think my proposed algorithm in my previous
mail is too complex with the aim of ensuring an empty bg for both reloc
and data_sinfo. I don't actually see a reason data_sinfo needs an empty
bg.

> > Also, when we do have to allocate something in the reloc sinfo, I don't
> > really see the value of going to again: with the space_info set to the
> > reloc sinfo instead of just setting data_reloc_bg to the freshly
> > allocated thing directly.
> 
> This is to search the newly allocated bg. btrfs_chunk_alloc() doesn't give
> us a nice interface to get the newly allocated block group.

Oh, gotcha. Sorry for missing that.

Thanks,
Boris
