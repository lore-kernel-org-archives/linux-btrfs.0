Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2871DF748
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 08:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788163775; cv=none; b=IjH55WwGE7q8LwpbuI80PIRc+l0xzBTtIPmwauIwbzZEYOITF0GWIzI3g6o0p8v9wwqdrHmDdE0A2xWV6zi8mKpR1u7z5IwGpJUFh/lEH7XRQn6O2/eYra6s1oN40/Xw1QBN2kIWiF0ojh2saE3b0F5/0X2DO7YgRM2bYGOu6fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788163775; c=relaxed/simple;
	bh=lVkFsjOkW0qG7+18JLOlFKPg3Xh5pBVcH4DIO7bj98s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f/tX76Gj2H7ylQgwZKMMf4dxiwSZ2uGtA1HZFbtZ9K3S7xJYIXc/bA+w1LmC3aMIc45CTr6vWJYn7Uer976S8m2i9JuU3JwUnFJlyD0o6/hfZbL/AusELmeuZ0fZZtMJAH4+/nX8APeu2k7xcRK5kSRnQC1ZxGE8BaJ+PsOAzCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2/qxgGOR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2/qxgGOR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=avwCKTeRYR4TKhCvB/ogpAKBtyGQ0OHTaEVbI+FSorU=; b=2/qxgGORM96jrZrboL7KzMaHl/
	vNJ9kUlDWZl9/yno9+Q3m78NkLPZTIiBQm+bJ4vxqw4RtTqMW0jtH6xg7OTn4zA07ycLkboszuLYQ
	ttYWGfNwuReckYRib476KkOmNHo/61uIA6kP0Q07f1H1XARSISptgu8IkjGia5jtWg9J9hVS/FaVW
	jEWdSonrkf5ik1g5tbQbAJdbUA+9x81Fm8Ob6CPccQrMe97qG+sYprAYqLB7+NebzVpdHMniKVimg
	TWbqjAIKrTEA8euVpYATx6IDLDD+O56brlEV05zt44xusSYTxplA++YBOg+WvotLHkhDA6PW9yRjB
	kNQSzEDw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0x58-00000008naF-1tu0;
	Mon, 31 Aug 2026 08:09:30 +0000
Date: Mon, 31 Aug 2026 01:09:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use IOMAP_DIO_BOUNCE flag for direct reads
Message-ID: <apU2ugNeGspvr75y@infradead.org>
References: <1219d8d9ed105a922d9af6130e08532e2907ea17.1787909265.git.wqu@suse.com>
 <apUp9SjdTSAmmzXV@infradead.org>
 <74188ab7-96d7-4536-997f-926a5a845f79@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74188ab7-96d7-4536-997f-926a5a845f79@gmx.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Aug 31, 2026 at 05:01:21PM +0930, Qu Wenruo wrote:
> However it only shows up in lore, but not in my inbox at all, and I have no
> idea why.
> 
> And lore is never a good way to review patches, nor easy to reply.

I got it brack through all the usual lists, so this must be some kind
of filtering on your side.

> > For one this removes the read-side IOMAP_DIO_BOUNCE support you are
> > using here, because it had problems.  The alternative is iomap-based
> > and better at building large, aligned read bios which matter for HDD.
> > It also introduces the concept of lazy bouncing where it only bounce
> > buffers after a checksum failure happens by default, which means you
> > only pay an overhead for misbehaving applications.
> 
> In that case I'm afraid btrfs may need some way to integrate the checksum
> handling into iomap.
> As the btrfs has a very internal handling for repairing each block.

The only iomap path is the bounce buffering, the checksum handling is
still left to the file systems.  The code will probably need some
minor tweaks for btrfs, like passing in a bio_set to use for the clones,
but it shouldn't be too bad.

