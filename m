Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCB435CB6E
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 02:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776824832; cv=none; b=A7qryvK6Z+l/BJdn8mzJii63V3bErwmMabBF2f7RPTk/xq3OgqbhzdIEUCssLk9EdHLBW1F7qJNz4d3AOnrctAfOx/ENFSxhopV8jukC7zKUfWnFnayXsLSoNitj4GlaC+cwGosBuV8MvWv9uGqxYq2jgCmR4UrzjlV2cyf6ioU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776824832; c=relaxed/simple;
	bh=MM/5RZpp6JhNVPh3naIbNvcoNUVO2flAbKZOhutbnG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DpFZrmlg9tKmTWA8sxC3ocZKvuNiXd6onrv5OKwyvaQaZWyZu65u4Sf7+3FrP+heLOWNVT0GL/RqO7amqtMR1F3KujSvFJf/ThMEtQIGhoyuqhR4az0MzWOu/Th6sWCZKSZ5oRW/pcJCFhllvfl+4huiqPxTiFQDeotcUJkPuvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=MGoR7GkK; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=eOKv5N3F; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="MGoR7GkK";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="eOKv5N3F"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 743EE1D00144;
	Tue, 21 Apr 2026 22:27:02 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Tue, 21 Apr 2026 22:27:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1776824822; x=1776911222; bh=pBoneOW9os
	ABACtekEzu4u8J1imQgv+eZwM1bg4XPro=; b=MGoR7GkKd2YsgdJcXlJna7C1gx
	OMgMYh1dHgx/rPbqca08VKdvgshdyYEA6iGMyUX1+7/V0FTSR8gvTgIDdNJ9Ylww
	fGwAcyonlJnrtUvazO8Uyon6/PfvKZDvLopgrmrg9iHWM4efOJJZZEHlnceN1nVx
	+d5n5ART+rhXDXtm6QulNEA7XpKJCgvKyBWBT4PYzVfc+g2kzlaTjXODfG7mNjGW
	8yKxiPljMXMzUjq5lXr4kX1wyEDMQhQrbx1sDHH/aIUVzGmre7199i6C7UpHRIm1
	gmqkT2xfLF6gdalj0iK6W8IMuBoBEefDAyEtD3ITJRf6/krv1WJXUiNo7gCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1776824822; x=1776911222; bh=pBoneOW9osABACtekEzu4u8J1imQgv+eZwM
	1bg4XPro=; b=eOKv5N3FZxSfs8eSt/IQMFzLjm+5udDGw+Lod6bfEo4hEVNqMkp
	WCSHsGBAjOXamX7NfjppnB/HwXbpSVX5zq9DCNpxWtEsoeXJhf0eUfYOdNbPR94L
	MywBHd2mHDBIruLVVs0OZ4aWAkjG2UHY40nbdI1ocvRo4aQgVWsarf2y/P4Nf3zz
	InogJbOtr1D86E8FTmvjK5Us1UIF9UZHDxOtjCmBeunz6Swork2mF/UBbTktT2Tz
	QzCxxIYf8G5L4xQE552QgHTXZP+wIjLtk+XDv0YsQh3gFD4udrs5vlfEYsAhFfrw
	WrJ+XAzel3rUKGpNAMO3ppiqMksjQyFFC6Q==
X-ME-Sender: <xms:9THoaVzpvvZA3K9-Kch6SPYAO6mFNsCkwAntiUsM-mpu9oXnhzIJFQ>
    <xme:9THoabSjVVZDa4qbykl4pJmqbat8Plk5BQwi1loTMGb8bd7nKIo0N6LR8u0zOD9tO
    C8KI9xE4qwLhisd9_uCuWk0-G46Bvf5za5zpIVj6BHQAankwqv9A3E>
X-ME-Received: <xmr:9THoac9hw-mr-IAl4zG0KeKdcy14Sb7n_0C0zW-JuH-X9pWG6qcT8btc94oZ-GA4N05eghwASw6ACsiQEW08VMja8D4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeifedtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesthdtredttd
    dtvdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeeutddvtdehgedvvdetuefgvefggfegudekjefhgefgje
    ekgeelgfeigeegudevheenucffohhmrghinhepmhgvrhhlihhnshdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepmhgrrhgtpggsthhrfhhssehmvghrlhhinhhsrdhorhhgpdhrtghpthhtoheplhhinh
    hugidqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:9THoaSrovuYNQrUG8yq7CjX3cB19vXgsFY2t-3rYRQtblWg-OWkjYg>
    <xmx:9jHoaZkTXSBREZ5acYcf7AG5inbpkO0uzASLMU4RT9XIMfV2N7zKNQ>
    <xmx:9jHoaZK54MPQF7xInfg4Ji8h9CVNF2HCXNtaiHxmPkXoHLVmDIYzoQ>
    <xmx:9jHoaezhlNepxki5wgnqynHQDfD8jVj2wgTAb6twQnmYlTqPqfmftQ>
    <xmx:9jHoaZLV74jEbmtSckxwyozB6kW-HxnNonGCVcrSMTa2x0SEM6sB6RgG>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Apr 2026 22:27:01 -0400 (EDT)
Date: Tue, 21 Apr 2026 19:26:27 -0700
From: Boris Burkov <boris@bur.io>
To: Marc MERLIN <marc_btrfs@merlins.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Simple quota unsafe? RIP:
 0010:__btrfs_free_extent.isra.0+0xc41/0x1020 [btrfs] /
 do_free_extent_accounting:2999: errno=-2 No such entry
Message-ID: <20260422022627.GA1034721@zen.localdomain>
References: <20260416004552.GA1045221@zen.localdomain>
 <aeA2c8V4FgCctUPG@merlins.org>
 <20260416012535.GB1065998@zen.localdomain>
 <aeEaqCJAWaWbz1vO@merlins.org>
 <20260416213632.GA1654609@zen.localdomain>
 <aeFY4uSTSIz4Ccat@merlins.org>
 <20260417215127.GA2310330@zen.localdomain>
 <aeK2QgUCefpVY4KX@merlins.org>
 <20260417231603.GA2376753@zen.localdomain>
 <aeLNxjmUGGhnW5ss@merlins.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeLNxjmUGGhnW5ss@merlins.org>

On Fri, Apr 17, 2026 at 05:18:14PM -0700, Marc MERLIN wrote:
> On Fri, Apr 17, 2026 at 04:16:03PM -0700, Boris Burkov wrote:
> > Rad, so there is some more "exciting" bug with balance lurking there.
>  
> Correct, all 3 times the bug happened, it was during balance.
> And now that you mention it, all 3 filesystems it happened to had a
> bunch of data already before I enabled squota on them (because those
> FSes were several years old, and created with much older kernels).
> 
> On all 3, I ran:
> btrfstune -n -x -r $DEV; btrfstune --enable-simple-quota $DEV ; btrfstune --convert-to-block-group-tree $DEV
> and then on the mounted filesystem
> btrfs quota enable --simple .
> 
> I'm not sure how many of -n -x -r were already enabled before, but 
> 100% know squota were not and neither were block group trees
> 
> My last remaining FS with squota running is the only one that had
> squotas on it from the start (with the btrfs quota comamand but the FS
> was empty).
> If you feel the bug might not trigger in that use case, I can try to
> re-enable balance and scrub on it, but it's another 30TB FS, so it sucks
> if I lose it. Then again, I think we now know I can recover without
> losing it, so should I go ahead and re-enable them with 6.19 (even if
> 6.19 did crash on my older FS where I enabled squota after data was
> already there?)

I believe I have reproduced the balance bug, and in my reproducer, the
fact that the subvolume predated squota was critical.

reproducer sketch:
- create subvol
- write stuff
- snapshot subvol
- enable squota (usage = 0)
- delete subvol (leave snapshot)
- run a data balance that hits an extent in the snapshot (owned by subvol)
- balance double counts extents in squotas (valid interpretation) but
  critically, creates a new tree block with the old dead owner but a
  fresh generation.
- run_delayed_refs happens now, say from a commit running (important race),
  writing that dangerous tree block to disk (in the reloc root)
- we do the pointer swapping and drop the reloc root. the nodes of the
  reloc tree are of this bogus form and cause your abort
- I believe the snapshot also has some bogus leaves and would abort
  later, too.

So the thing that is definitely dangerous, as far as I can tell, is
running balance on a filesystem where squotas was enabled after any
subvolume owning a shared extent (snapshot or reflink) was deleted.

Is that story consistent with your situation? It sounds like yes, but I
think it's nice to double check :)

At any rate, I think that your fs is safe from this bug, but at this
point, it is hard to be certain of the safety of other balance vs.
squota interactions.

Now that I am at least clear on the more sophisticated bugs we have, I
think that I am ready to put in some fixes and some defense in depth. I
was feeling sheepish about just wallpapering over it without explaining
your actual bug. So I think you should wait for that, to be safe with
your big FS, even if it happens to not *need* the fixes.

Thanks again for your reports, follow-ups, etc.
Boris

> 
> > mkfs.btrfs -O squota <dev>
>  
> Aaah, I was missing that option, but even if it's a make time, do I
> still need to turn them on with "btrfs quota enable --simple mountpoint"?
> 

FYI
I believe that when btrfs mounts a filesystem with qgroup trees present
it will enable quotas, so you don't need to manually enable them if it
was created with squotas.

> If there is no good documentation on all this, it's been 12 years since
> I wrote all those missing docs/howtos on btrfs in https://marc.merlins.org/perso/btrfs/
> happy to make a new one to put a few new notes on squotas and block-group-tree
> which I was unaware of until just a week ago.
> 
> On the plus side, knowing it's squota and balance makes me feel better
> that btrfs on top of raid5 isn't as unsafe as it used to be (it's
> supposed to be safe, but I've had more than 5 unrecoverable FS crashes
> after swraid5 misbehaved when I was really hoping for just a bit of data
> loss or data corruption that scrub would find and then I could move on.
> Also, I'm pretty sure I had -m dup all these years, so it's sad it
> didn't help)
> 
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>  
> Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
