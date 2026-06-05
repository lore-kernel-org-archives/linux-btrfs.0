Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D7F2F261C;
	Fri,  5 Jun 2026 04:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780633655; cv=none; b=cb8t8vy7YgMScmtXGRUMxdhJ9rrtMVELE7FzKJK1drN4PAIjLvgb/XQlmS3xaNgsqw8mShhbfrh9CNDyt9FcgWtF4O61ptguVfYWGOEQ5GtVTmQD8sVLLn/JHaXYSnlTc7EAZwhNQwfgKakoMvngbCluhIPtHYFI0EI9Pnt6RXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780633655; c=relaxed/simple;
	bh=ax6ZDTGU9+dwdRoWk17N4vn9R+YZsWb0NN7PvCOPhCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SN15PbmHdfwrR1kNjJdtEUbnggEGYhtXb9eW/jkDkI0VInpHj6X4Fn0EiGdhJBHoiTwC4tc09UkX3VHof411YSAenlQutUHPGN7asmFk1nB0tH3j1umIuPyI+DkkTjSgI686zav/+ssmfY37Rv3dy/094NsobQfBuQ6UNE7ytpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=w/xsHeQ/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="w/xsHeQ/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iT+mBQogolf6DfuB7TFisIAhhAk9rQ0bzBpd3es4/Gs=; b=w/xsHeQ/xc5BDH+0RBomf72Qwc
	WaMh+4Zh91w9t4i/kJOC5iPTSJFmk9vfaoTpe3zmePFoMrUva0Zje8lAgbO99biBaz6wtGFiwamfD
	Jkhi3TVPHhKQ85PWKoEo5dGUAIb9uA4kh5xyRg9IHuP27dOukqrlubDXW65Dho6mewZm2jsEiX1hz
	O+RaZREP3ZMmxhiZfFWbBhULF5tB49YUcQ36Mx+ziKtRsNf5EympXRrimGV/HODgOkSlDQmq2mram
	EQ4INlbsZl+VAp98STAqyruJHI4QXFN1Pcy9XI2Gs2wa4WRAv4kxgcGan+0bem9KIqRvrQ8zZNs3f
	IyCU106g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wVM9e-000000004Wy-09Qn;
	Fri, 05 Jun 2026 04:27:34 +0000
Date: Thu, 4 Jun 2026 21:27:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use -f by default for mkfs as xfs/extN do
Message-ID: <aiJQNguZO5K6n9J-@infradead.org>
References: <a31e9841-fd0c-435f-b376-86a7e01ddca7@redhat.com>
 <aiJL1CBTV_N4YAtb@infradead.org>
 <16b7fc31-3684-4144-9076-8cdb60e97001@gmx.com>
 <aiJN5l0UqOA9lY5_@infradead.org>
 <a6cf8da9-9fe6-4338-a130-13c1a475e9f9@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6cf8da9-9fe6-4338-a130-13c1a475e9f9@gmx.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jun 05, 2026 at 01:53:33PM +0930, Qu Wenruo wrote:
> > In other words: we already get -f, but it got broken recently.  That
> > explains why things always worked for me.
> 
> Hey, this shows you're running on a proper server distro, not some rolling
> bleeding edge one :)

Actually I run self-built btrfsprogs in my test VMs.  I just didn't have
a need to update it recently.

