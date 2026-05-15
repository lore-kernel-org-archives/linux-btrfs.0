Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5563D2989B5
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 21:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879129; cv=none; b=YDRFilYfq/tcOoYUiW8rSL+1HPl/TchTrwx8dXLeugDX16pC4Y27t0Ko7bM3U7cf693O2ZLRx4MfuA2Yp4p1jdKFNpjLQaUACyia2RXbHw3dgQF56Y19s4uEha12RRZDp0CVBU0rolGYcl/PGSKsWL25AowcE2XbdOx1ExsO+KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879129; c=relaxed/simple;
	bh=Tk44JUH7aQdlxlwKW7j4czHVsgwMP/EIQJsE255POzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X5lXK8zvuAdF9vOYhf7LV7ghdEHvaaRZgc20/1wu0jmqptTg7LUF7X6/tU03TC6g6hAk5Bo/CHOcKO1cr5JSo3JQRKxGJOufb4DlHQr3la2f2eyxlYd049AXRkFTUDRKu4BC58V6CGEiuQ+djEDxp0hLxGvkIVspFg0bX8gNXX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=LcJyFGr+; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=rRMNzOq4; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="LcJyFGr+";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rRMNzOq4"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 5A70AEC00A6;
	Fri, 15 May 2026 17:05:26 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 15 May 2026 17:05:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1778879126;
	 x=1778965526; bh=FWzlAw7br1jpCEj1rKF2cNBWIcKGg/MDbXI54Et+XhU=; b=
	LcJyFGr+zqAADs508j+ZG87tmVy+sLvBg/vqomnTmqiNy68ruLHmDIn56MmSK8J0
	Wpfh/l6veBQ+3mUDDVPviQgQhKO3Go5vIIsPXz91PVC8TnB+Zdyz3ZYyEBR4npXE
	uIZaZUX6pJgP5oV8Cbjhxoin19T8G4KYagOcQn1EWa6091alvZ0lbesNsGUd2J18
	MArsJAlf+POdbJb4uHVeWKMK91PoQ93jk76hRaSIMSUnbS+XuWJv3bk6IMtllpNz
	BxTJ2cot70GsKt7I0ZaM0h/fREDbNDo63kTtjbn/T5t/puiab8mhrJN3jrX11tL3
	8nZMUjAyP4H9dmgwPL3k9Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1778879126; x=
	1778965526; bh=FWzlAw7br1jpCEj1rKF2cNBWIcKGg/MDbXI54Et+XhU=; b=r
	RMNzOq4A8vKkKnGBl3Nprc6kQHjqZDGBNGYbp1q0XWkIbPxr3fT3w7C5O4O6nMgg
	kAgL0t3y6asa5YzPurhumoyXaMsIS7kRzkbP/x1eHztim9MluHTPVrKm3iEoqYMm
	2WZZbw93WIxFo2DmZBv09tlv45lBv1elD+zOWrm89P+Rn5k9TB5vHBDh4929dfke
	xdhY9dQ5XoiKXvaU2Afmf1oZchiWKwwEJ9ywjaHhFnh2qsh671C6XMkR0M+IGV1R
	HdhoSxbmsViWw2hICmCNPQddyykwxLyg4DW+FY583fRPeZQvlNOFFU2/pRc+EmFT
	Ls7fZh2kkJdjgrROXcDYQ==
X-ME-Sender: <xms:looHaiCD19rXMAoL31mweWYVVD3VzIlA4sLlV_zdLBR8VbW9reaaVQ>
    <xme:looHarmPev1xI13zwbGguRwl-mSOlFymb3R0pawxHvDRxfVhSati5i75_7Fi2Dcqs
    n7usSutIvLwoe2Dj6sGsfWQRvn1ikHg5jxKHWbM8a2vlW8Pwq18w-4>
X-ME-Received: <xmr:looHarwlaIo-0KkezRN4XgMIW_xJiZm3R9a0x7Kh9XvRN-Kr13bhcv9tT7obK7FiopuNWZi7OjeL1fi34soltWwUKGk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddufedugeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpeeuohhrihhs
    uceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepud
    eliefhtdeggfekueekheeukeehheelfeejuedtffelgfdutddvhfffvdeggfelnecuffho
    mhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhiohdpnhgspghrtghpthhtohep
    kedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohephhgthheslhhsthdruggvpdhrtg
    hpthhtohepjhhohhgrnhhnvghsrdhthhhumhhshhhirhhnseifuggtrdgtohhmpdhrtghp
    thhtoheplhhinhhugidqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtph
    htthhopehfughmrghnrghnrgesshhushgvrdgtohhmpdhrtghpthhtohepughsthgvrhgs
    rgesshhushgvrdgtohhmpdhrtghpthhtohephhgrnhhsrdhhohhlmhgsvghrghesfigutg
    drtghomhdprhgtphhtthhopegulhgvmhhorghlsehkvghrnhgvlhdrohhrghdprhgtphht
    thhopehnrghohhhirhhordgrohhtrgesfigutgdrtghomh
X-ME-Proxy: <xmx:looHatQWeMZSN4kf1haN-UzpbNLBk7RxTgWauIxKeym8Std3tjjhhQ>
    <xmx:looHar--UnHQWiXtRtEvdg2dux8HSDmGggJr6zHGwbga4Y3t683UaA>
    <xmx:looHajvPZvIPp2e1p4cg0lCJpKNoOBCtW9iuoOF8LWzN58NSi34o6A>
    <xmx:looHarOOHEvQFfVIoqs3SJhsDCKACAqUbyBJNR1dUHcF2h4-O2tguA>
    <xmx:looHav8hbuNH16EzvXqFoB0bNZGbMq5JM2OmbqFmGWRl3hfFjY7lPSd6>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 15 May 2026 17:05:25 -0400 (EDT)
Date: Fri, 15 May 2026 14:05:11 -0700
From: Boris Burkov <boris@bur.io>
To: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH 5/7] btrfs: zoned: subtract zone_unusable space in statfs
Message-ID: <20260515210511.GA2887949@zen.localdomain>
References: <20260513123445.43197-1-johannes.thumshirn@wdc.com>
 <20260513123445.43197-6-johannes.thumshirn@wdc.com>
 <20260515043921.GB3936@lst.de>
 <bc97d41f-55e2-44ed-a500-e74f8f25f006@wdc.com>
 <20260515113430.GA25099@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260515113430.GA25099@lst.de>

On Fri, May 15, 2026 at 01:34:30PM +0200, Christoph Hellwig wrote:
> On Fri, May 15, 2026 at 11:26:22AM +0200, Johannes Thumshirn wrote:
> > On 5/15/26 6:39 AM, Christoph Hellwig wrote:
> >> On Wed, May 13, 2026 at 02:34:43PM +0200, Johannes Thumshirn wrote:
> >>> On zoned filesystems, space in block groups that has been freed but not
> >>> yet reset is tracked in bytes_zone_unusable. This space cannot be used for
> >>> new allocations until zone reclaim resets the zones, but it was being
> >>> reported as available space in statfs.
> >>>
> >>> This caused statfs to over-report free space, leading to ENOSPC errors
> >>> when applications tried to allocate based on the reported free space.
> >>>
> >>> Fix this by subtracting bytes_zone_unusable from total_free_data in the
> >>> statfs calculation for zoned filesystems.
> >> This OTOH sounds very wrong.  Freed but not reclaimed space is usable,
> >> it just needs work.
> >>
> > man statfs says:
> >
> >                fsblkcnt_t f_bavail;  /* Free blocks available to
> >                                         unprivileged user */
> >
> > which in my interpretation would include zone_unusable_bytes, as they're 
> > not "free blocks available". Or would that be accounted as f_bfree?
> 
> The only different between f_bavail and f_bfree is reservations for
> the superuser, which IIRC only extN do on Linux.
> 
> f_bavail is all the space you as a user could potentially use on
> the file system (modulo quota restrictions).

I think it would be great to discuss this in more detail. The whole
"reservations for the superuser" thing never made a huge amount of sense
to me, and feels sort of under-specified.

I take it to spiritually mean "space allocated to other crap definitely
needed to do your data allocation anyway". So in btrfs that would
mean something like "an estimate of how much metadata you would need for
the remaining space"?

Returning to the actual implementation and this concrete question:

AIUI, we calculate f_bavail as unaware of any stranded metadata space
we could free up by running a 'btrfs balance start -m', for example.
Furthermore, there is a discontinuity to zero in edge cases when
potential space for metadata is exhausted even if there is still space
allocated for data.

So I think Johannes's change certainly fits with that (and the raid
aware) nature of the bavail calculation.

On the other hand, given that the zone reclaiming is guaranteed to
happen automatically, I can see how it could be treated differently,
though, unlike the metadata balancing. But if we made metadata
balancing happen automatically in a flusher, we would need to change
f_bavail to count stranded metadata space too?

There was another recent discussion on this, where you said we should
avoid over-estimating:
https://lore.kernel.org/linux-btrfs/efcb3c8470bf099534fec1c1745780eba445e111.1774394322.git.loemra.dev@gmail.com/

So I think the main thing is whether btrfs guarantees it will succeed on
allocations given space stranded in zones is available "after a balance"
or not? Should it admit those writes? (Is this the right test?)

I think in this case, given that balance is in a flusher, it should, but
it is better to say "everything" out loud to leave less to the
imagination. And we should confirm that this property really holds, that
such a write will succeed after painful extra balancing work. It is
possible the balance fails, for example, due to insufficient free space
for a large extent that needs balancing. Maybe because of the reloc zone,
that isn't true for zoned? Either way, does that aspect of it change how
we feel?

Thanks,
Boris
