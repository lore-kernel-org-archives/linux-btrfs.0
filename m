Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438D03C9426
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 05:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779083562; cv=none; b=K1FFo0pDwvqHfk6ijiC13osOJma2aKj11sAv3UKlb7plxr33opXeo/7yP2iGAXAFiwPfEQFW9KFZIM5ewS2TtA5t+lnf9ymN36DSpa3pGQ/zQEKyzFFBZwUbxty7uFWotcIXs3LcV3drohWGK/W6McxQJW5nwT8YT5nV174ezEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779083562; c=relaxed/simple;
	bh=b07KNmKIWoCknfIM0JUMj5Qpw5V0RtyXMXVFwChRHBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n9nHUwap/dihpaVdZI7/F0hTVskKWj1o8ApNpn3TrqUtOhl2V0FZLFeha0Hqqwa7FaITyMvS309sNDxcqlcNwc/RhV/sLCoe7MXH69wwSfAMJkLhQKzbNR/3F1J6I7OANJzrXf5Cj1+z36sCw4IgbhhihSn1Z4W6A+SzB+/B4bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CC29068C4E; Mon, 18 May 2026 07:52:31 +0200 (CEST)
Date: Mon, 18 May 2026 07:52:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: Boris Burkov <boris@bur.io>
Cc: Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH 5/7] btrfs: zoned: subtract zone_unusable space in
 statfs
Message-ID: <20260518055231.GA10154@lst.de>
References: <20260513123445.43197-1-johannes.thumshirn@wdc.com> <20260513123445.43197-6-johannes.thumshirn@wdc.com> <20260515043921.GB3936@lst.de> <bc97d41f-55e2-44ed-a500-e74f8f25f006@wdc.com> <20260515113430.GA25099@lst.de> <20260515210511.GA2887949@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515210511.GA2887949@zen.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, May 15, 2026 at 02:05:11PM -0700, Boris Burkov wrote:
> > The only different between f_bavail and f_bfree is reservations for
> > the superuser, which IIRC only extN do on Linux.
> > 
> > f_bavail is all the space you as a user could potentially use on
> > the file system (modulo quota restrictions).
> 
> I think it would be great to discuss this in more detail. The whole
> "reservations for the superuser" thing never made a huge amount of sense
> to me, and feels sort of under-specified.

It is, and the fact that most file systems never implemented it probably
means it isn't very relevant.  Buf if you're interested in you should
probably ping Ted or Al.

> I take it to spiritually mean "space allocated to other crap definitely
> needed to do your data allocation anyway". So in btrfs that would
> mean something like "an estimate of how much metadata you would need for
> the remaining space"?

I don't really unnderstand what you mean here, and how it would relate
to reservations for the root user.  Remember that these definitions are
from a time where there was very little dynamic metadata, and the size
of it was trivial to estimate.  Basically just directory entries with
a tiny overhead over the file name, and indirect blocks for file data.

> Returning to the actual implementation and this concrete question:
> 
> AIUI, we calculate f_bavail as unaware of any stranded metadata space
> we could free up by running a 'btrfs balance start -m', for example.
> Furthermore, there is a discontinuity to zero in edge cases when
> potential space for metadata is exhausted even if there is still space
> allocated for data.
> 
> So I think Johannes's change certainly fits with that (and the raid
> aware) nature of the bavail calculation.
> 
> On the other hand, given that the zone reclaiming is guaranteed to
> happen automatically, I can see how it could be treated differently,
> though, unlike the metadata balancing. But if we made metadata
> balancing happen automatically in a flusher, we would need to change
> f_bavail to count stranded metadata space too?

the bfree/bavail needs to fit too criteria:

 1) vaguely estimate the amount of space that can still be used
    on the file system
 2) don't over-promise

And this patch fails on 1).  Once you've filled a zoned file system
entirely with a normal non-optimize write pattern, and then delete
a lot of this again, either at once or in small increments, with this
change statfs would permanently report a value close to 0, which is
very wrong.

IFF btrfs automatically reclaimed metadata (and I think it should),
it should be treasted the same zoned data and be reported as
free/available in statfs.

