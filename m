Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883E3524F;
	Fri,  5 Jun 2026 04:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780633064; cv=none; b=E+Xc1TT3jda4nzqD/0MdQvX71cPQqdxpBF4ObKDAII8RdwNGebYKyhY62MLDYHUYEOIbFKiia1wDj8BsNfnaivZLpojSn1O/BJGusc0rIOUU6lP4O4tc+kJ9ISIC4hbOA8MpUnRv5FlKB/kv7EYPF9jr4RPL6+PneLCM+23uoVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780633064; c=relaxed/simple;
	bh=Qicmsk4Oqa6zZ/J2yz3Q0PNiMbLD5R2kFRtoBqNMwIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NhHenPSxGbudUMhvcZz16MEH1Mr4ur9GKAH/2wzyCjydnqaV0vZRvhLPNes72Dm3j0VYI6HLTlwF7yDy5QjdkFAiMWDtcJSjzoiZNXJPXCRByc6mMFfQMTaLWdy19SuI3Naj7GanC0VEwDgU/RbipqOMcOeExlYPuCIfVCgGxTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=03yBjOOm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="03yBjOOm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=81szXppS8kuS3d+kMnlyD2hFTlX760e3VnS54rebAU4=; b=03yBjOOmsVJJrPSNFh3Ljtzrlc
	/TlmQl/99/AA2n/pEZwMd5iDZne2bCnvsMZZW6NcU2USiQCiyZWNWlrLJ828StRhaDIoUAksgw5W3
	QldqdfCqKwh+rkdBGeADyILV0O965qGjZAHvS57MaDou+dX5ffsDQbPmlru+1cUbTjytiijYtJ0y6
	EGLKr9CS29g5JMXFdrupZb+cP4TUFsaeM6rSCnlM32nKbQlOVQT8UAO18/8rPSjrAaJBm5/EMMaLI
	NwyNnduulYx8G3Xe+DPG5c65CxOtHF/3Q0rkwnS464paag9qJn1iIqAJ25jjxslS8GJxuIZ0p+Nbh
	DLm3eU3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wVM06-000000004Kl-09gB;
	Fri, 05 Jun 2026 04:17:42 +0000
Date: Thu, 4 Jun 2026 21:17:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use -f by default for mkfs as xfs/extN do
Message-ID: <aiJN5l0UqOA9lY5_@infradead.org>
References: <a31e9841-fd0c-435f-b376-86a7e01ddca7@redhat.com>
 <aiJL1CBTV_N4YAtb@infradead.org>
 <16b7fc31-3684-4144-9076-8cdb60e97001@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <16b7fc31-3684-4144-9076-8cdb60e97001@gmx.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jun 05, 2026 at 01:44:02PM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/6/5 13:38, Christoph Hellwig 写道:
> > On Tue, Jun 02, 2026 at 10:47:39PM -0500, Eric Sandeen wrote:
> > > Recently saw a case where testing ext4, xfs, then btrfs failed all
> > > btrfs tests because mkfs.btrfs refused to overwrite the left-over
> > > xfs filesystem on $SCRATCH_DEV.
> > > 
> > > This seems well-enough fixed by only making the change to _scratch_mkfs,
> > > but several other helper functions explicitly use -f / -F for xfs
> > > and extN, so I've updated them for btrfs as well.
> > 
> > I haven't run into this yet, but it seem like btrfs needs this.
> > But maybe you should also Cc the btrfs list?
> 
> This is the wrong fix.
> 
> It's caused by a mkfs.btrfs help string output change, and it's properly
> fixed by this patch which is already merged for a while:
> 
> https://lore.kernel.org/linux-btrfs/20260510001704.68396-1-wqu@suse.com/

In other words: we already get -f, but it got broken recently.  That
explains why things always worked for me.

I took me a bit to reverse-engineers this from your answer :)

