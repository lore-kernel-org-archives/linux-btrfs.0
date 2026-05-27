Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029B6405C32;
	Wed, 27 May 2026 13:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779887041; cv=none; b=twRKPkFkkM7uPv98uOf8hPf1TcitviEwVuXMJWvgIPmZJzewOrfwoI+55QzhjfzV2zdl/NKro1Ob7Ihuk7ruYSCmOcKWYgJChHkCM8uh0wB0/dEP4CZMESBhhS92urTtvuNDG/m9ao6yWN+uIOnYMWS+KGKAlXDl8D46HXA4z88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779887041; c=relaxed/simple;
	bh=qZf0ZcjZLhGcoFAHVgQ97YJjbK2ZOIXXX1J2huVeAQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G9fYnrkS2chQdvP4yBe1afyL0gsBmoesEYJNgNSqHLcVNir5p61SiRPtK5RVn0+6laaH2DBZ1YIX57ZuJ95d+8bDEO7ykGz1NxlhONuk5B590oYisfFCH2JkskkSCN2+LNTwZSB8mEfYPmRjRpCfqRsHeHTe8vyiToiiOxWVuIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gQmAeulH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gQmAeulH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=U9QWwYi1B3SoAURXVnU0ZU7NwgRBMCrt1DLYPE+oD8o=; b=gQmAeulHfqe1lqifpSVzfv+8cV
	UNJGQgxUHKMqGyw9GmFUkEb/RojLDimqKkDwjq60T6PjnNKBYbxD3X8zECfZyInPcLyXu+yj/GarS
	9Pts8ohtNemvhMdO5mTaDJXiZfXdFeRmw+esTEiRA6XRpU6Wqu/DJdSU5wctQPoacRQbuq2p1kcR0
	eEURmCE6WQ4/qzcYShXlkwCE7sCxUSRFuEWG0cGBwvvSb2VelD2ejlHzJavphmafIPPNjimjcIqY+
	GJxIxmyK+8yaWUEnbA4P3OJbjBbw57syyEyD8d/UinszrgX1Td38IVFJjNaPWlaeNi9xVmrdSdUEo
	QYHLiNbw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSDvT-000000049NI-2Thw;
	Wed, 27 May 2026 13:03:59 +0000
Date: Wed, 27 May 2026 06:03:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: generic/362: remove the old file to reflect new
 mount options
Message-ID: <ahbrvyNg65OjGhpS@infradead.org>
References: <20260526070055.60193-1-wqu@suse.com>
 <ahaQjYYQWcuOaRaq@infradead.org>
 <e9fc0374-4a97-4cab-8f9d-9de39587cbec@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9fc0374-4a97-4cab-8f9d-9de39587cbec@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, May 27, 2026 at 04:20:38PM +0930, Qu Wenruo wrote:
> > I'd rather add a copy of the test that runs on the scratch device
> > that can control the environment.  Or maybe just change the test
> > to use the scratch device?
> 
> I'm completely happy with using scratch device instead of test dev.
> 
> If no special reason to use test dev, the next update will go scratch dev
> instead.

I went back and re-read this.  What is the special mount option you
change?   If you want to always exercise this as nocow, maybe add a new
btrfs test that is a copy and uses the scratch device?  Or am I
misunderstanding something?

