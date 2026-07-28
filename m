Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0088823D28C;
	Tue, 28 Jul 2026 03:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785208944; cv=none; b=HpQhcS3ebsv7m7dHlkZcEeOg27190icpadEhU0jk3Oa6RpigxpnL7m8RsAYjlV+fpvDSaqibmSoSg8grL0yb0PPHNHDOWbK+THjGQXmpnrDLDOAjxueZryRUZW6lVY0vhI6uzFAMuAx+cDlaYP1PImEJhs0n0CxYq7ZEc6cZH48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785208944; c=relaxed/simple;
	bh=8eVcv6n7DO2h6bwyj5yGT9DgVFVPFeeCoIODUS3aHro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XwJxs0BSyCogMZ9SyOmwgkQIjs7aspXi5cZtfDZHSTcVZ6VtUkuzhBv2lhccNaYapD/7QEnPxSKEovLtECdANylOXBXPtnizYryv7ednueER1IP0eQ7tzLbHUSQwJ0KNrLFohMNLJu2ErFHCamxbn/SLbjU3Dv77a0NECBGOkzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1YbDWw5V; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1YbDWw5V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3kVGQnXuQLJuTOpQvL3JEDPWkiCKiFoO3UPdMvD6PiY=; b=1YbDWw5VuUjaqTGHjt3UKnOMZ/
	wkY99z3NT3JKR2EEARByCZZnu6qWRiiWnUk0JttlZOR0U9x1TnNGxHbro5eCKFsWP8ell5WxOwEjF
	LemAocBs7AioWHZIgovaIt0CqBfW4ICtgcYikLGHEQU3cNAaMCMs3VsANV8GNw7LceJRCAIDr9LYR
	2YS1KcQhFrYPRCuVbn2VkpvGMv6ulDHM4MwoNI2JE8B8HLYdBv8InEFLGyTwV7Ny2PJX7Fu9bRM6O
	6Qu5yAS5jo5NwyAY6w17BmmKgCeMBSiubSMas2/i1EW0IpGoD6caJM0DWfo3GTS4qRbEkClj7Nw5E
	zkfvCvFA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woYOb-00000004K9C-20Ow;
	Tue, 28 Jul 2026 03:22:21 +0000
Date: Mon, 27 Jul 2026 20:22:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Christoph Hellwig <hch@infradead.org>, Zorro Lang <zlang@redhat.com>,
	fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/5] generic/746: skip on zoned btrfs
Message-ID: <amggbYhuW7cRFkV-@infradead.org>
References: <20260720111849.1659111-1-johannes.thumshirn@wdc.com>
 <20260720111849.1659111-4-johannes.thumshirn@wdc.com>
 <al5c4krF3A03HZ1o@infradead.org>
 <amcdDtFZ5pYz-nI0@neo>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amcdDtFZ5pYz-nI0@neo>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 27, 2026 at 11:00:35AM +0200, Johannes Thumshirn wrote:
> On Mon, Jul 20, 2026 at 10:37:38AM -0700, Christoph Hellwig wrote:
> > On Mon, Jul 20, 2026 at 01:18:47PM +0200, Johannes Thumshirn wrote:
> > > The test relies on loop device discards punching holes in the backing
> > > image file (holes are then detected via fiemap on the backing file).
> > > Zoned btrfs does not support fallocate/punch hole, so fstrim on the
> > > loop device cannot free space in the backing file and the test cannot
> > > work.
> > > 
> > > Skip the test on zoned devices, but only for btrfs so that other
> > > filesystems (e.g. zoned XFS/f2fs) can still run it.
> > 
> > This should use feature detection and not hard code file systems.
> 
> I didn't find anything for that. Only using _require_xfs_io_command
> "fpunch", but the test is not using ot so it felt wrong. 

We use _require_xfs_io_command as a shothand for feature detection
in various places, so this should be ok.

> It is not the zoned device model that prevents us but a desciccion we
> did in zoned BTRFS when doing the initial support for it. I can look
> into hole punching but I got a lot of other more urgent fires to put out
> and features people are waiting for first.


Yeah, tat should be fine.  It just did sound like a rather odd
limitation.
