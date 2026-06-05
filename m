Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F40B33EB06;
	Fri,  5 Jun 2026 04:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780632812; cv=none; b=Otex3No518FMbmVb4EOIGh+fikxx0svtmANaGWlokdLIhzWVb/we1DE6fYmeMFKTnvxXgdkTFfelzWPNerI+S1jaPEmo1k0jQ66juCWr0UO8yPCqsiab4jIVvOMqnfVhbgkAe/szh7GhzRb8ePaecrxy0K2MQTZH2SC4swhK2nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780632812; c=relaxed/simple;
	bh=97kHzdMA6M+WARQzaEWg0fuAQCwla51V0Gh5NAi/TC4=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uqlhzi3YKpyMGcNW3LuZ0Gf65fxH0aAd0ztgsG6yTGABaopy03noioPRYmb3GlDlKWgiJ7lv3L/6W5w9S3YpKTXkEnawq2VpVbvmUy4ow2pX0RuT5/KvrkWgL8ciBmrZ17LYecYk/lx8wwUtv+4KXwMPDPaVIRZHxylY6t/NWy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gyMsfxRc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gyMsfxRc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eTyCBQ604GIsCkI3wxwi2uE5cbzqcrS5KgIU1LPj/nc=; b=gyMsfxRcJFoJLC152z1lNaLn6m
	IZmVxYrrxZpSzFNBDzOq/V98AerQGVVWqzqpzth4kl0oHvPhPptZWIxif0SfJhOuKrIMSNPLW3waV
	WCdEHKVeLTyQ/8MoMYz9z935XE9VCZLbzRjFyRLSZmCjTDKQvXWJtqqs9g2wImjfwXNBd1PD7V+9o
	baP4xPfdx6CB5azKwyfa+RNMI3rrZ/ObRXIRWVMo93wB2SPd1/yAqGxJC+limJvuzuUUdjUH1bsuA
	CP04rTE+OALaFIeBzPsHjaZAzByHS5H+gjYGyyLTyAGRNXKl90SonuIS4gINWOp2Wk2CXtBPyX9Yn
	Lsw9CvSg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wVLw2-000000004E5-1k1j;
	Fri, 05 Jun 2026 04:13:30 +0000
Date: Thu, 4 Jun 2026 21:13:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>,
	fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Xiao Yang <yangx.jy@fujitsu.com>
Subject: Re: [PATCH RFC] fstests: use MOUNT_OPTIONS to populate
 TEST_FS_MOUNT_OPTS if possible
Message-ID: <aiJM6o982CKp7v_y@infradead.org>
References: <20260602001422.24364-1-wqu@suse.com>
 <ah50bZRaH6YWTJXc@infradead.org>
 <aiGYgLaQ7_r9LQ2G@zlang-mailbox>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiGYgLaQ7_r9LQ2G@zlang-mailbox>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jun 05, 2026 at 12:46:13AM +0800, Zorro Lang wrote:
> Right now, the biggest inconsistent issue is probably with those feature-probing
> helpers. They often check TEST_DIR to determine behaviors for SCRATCH_MNT. While
> this works fine for features unaffected by mount options, but we might should
> handle mount options related features (for TEST_DEV or SCRATCH_DEV) separately.

Yes, I've run into a lot of issues when TEST_DIR has more feature than
SCRATCH_DEV.  The problem is just that feature testing for scratch is
a bit annoying because we have to create a file system for it first.

It might make sense to catch some of the results, but then again we have
tests that override options for the scratch side so that this won't
apply.

I've been wanting to look into splitting the scratch tests up into those
that "just" format the file systems, and those testing very specific
corners cases using special options.  Especially as we should not have
to run the latter multiple times for different configurations.

