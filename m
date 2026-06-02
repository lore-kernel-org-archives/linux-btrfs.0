Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893313A6F04;
	Tue,  2 Jun 2026 06:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780380785; cv=none; b=bv2BwNT9FgA/l7WndJOai3EdS6VitLmG/JTUjkubES0+WidlrTG3IKXeRs4mTyLTGPgk+QtJor3hW/IRNwGIUy6MjjrVA+NA9zugCxjwtr5G1gz6KiUF1nN1TnuC3PGX4XeKPnPCX1HMOreRz5ttYbyxU5O/PZSr05pBwsBtpso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780380785; c=relaxed/simple;
	bh=XSMA9BXrG0bDvarLtBSu1VgN6obS+n+5XO45gAqvudM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C5RTIYX8GtJ09dzx8SLWFdACLfriAyIG21axphi/F55XE+lwpXe0kPUiUcDVzGk3Vg6JjhSUYOXA7aaMqfxphWqwZIzOgAi9b8Zx/pn3jZebtcWHg0VshNKTwCBd/GBDkUBHsxWufWpww0EYuuvgFiYrwLZVjnDv6UGl1CeAypc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IjOsYKdy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IjOsYKdy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XSMA9BXrG0bDvarLtBSu1VgN6obS+n+5XO45gAqvudM=; b=IjOsYKdyb9evC0sFH+6KxUuzSb
	xJotSMxa+5kBzb9YzznXKLJWTBuQkFaI3Dq52cW3k9h/nXX2rB1kJ8KYwOketz9ydH4pF04LfZhVP
	4RJKLh0gZWENC1KBTeThTWmYysEwnmlXVO3FprkMX0NARRrklMDK5r35aUcGnd7iLNS9+ubRwCNUk
	wDRbpE6XK472irY3TYd835gYcc0cHNnHigFbwQ1bqQKyNofOjkY42CIh5BJNSGKcyvAkzgoE4yoSR
	r8/T5MruVXRkoSKE5FDR16mjOxFUIbWDByXs0tIitMDc3tdvl736qMm+m4791LJDMwu9TVk49jBRh
	CnQPL47A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wUIN3-0000000CN7B-1WK7;
	Tue, 02 Jun 2026 06:13:01 +0000
Date: Mon, 1 Jun 2026 23:13:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Xiao Yang <yangx.jy@fujitsu.com>
Subject: Re: [PATCH RFC] fstests: use MOUNT_OPTIONS to populate
 TEST_FS_MOUNT_OPTS if possible
Message-ID: <ah50bZRaH6YWTJXc@infradead.org>
References: <20260602001422.24364-1-wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602001422.24364-1-wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jun 02, 2026 at 09:44:22AM +0930, Qu Wenruo wrote:
> If the test config only specifies "MOUNT_OPTIONS", but not
> "TEST_FS_MOUNT_OPTS", the mount for TEST_DIR can have inconsistent flag
> after _test_cycle_mount().

AFAIK TEST_FS_MOUNT_OPTS gets overriden and isn't even a public option.
It gets filled by fstype-sepcific options in _common_mount_opts.

This started to really confuse me lately when I was trying to test with
mount options on the test fs.

I've looked at bit into the area but haven't come to a conclusion yet.
The most recent change in this area is 1dd7395623cb ("common/config:
Make test and scratch devices use the same mount options"), which didn't
really make them common, adding to my confusion.

So I really think we need to fix things here, but right now I'm not sure
how much of the current situation is intentional, and what our final
goal is :(
