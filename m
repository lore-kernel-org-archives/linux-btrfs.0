Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBE72D8376;
	Mon, 20 Jul 2026 17:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784569062; cv=none; b=fZ/y1Z8DjlEQfWZeM0Sw/RDBLieH2dl0wBY8r0MAm+fBQd+Tkosl7IAaPOCLuEb6lQI6k9vqEb1V501Kg++swhbWwRQACjmfv5MrZvBbxCEikcsfhGb9kXjVOrcsv8na3Pu0q5ssIH7x4OGEYB/6hHb3g9snqOyEUHB7vo1UvK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784569062; c=relaxed/simple;
	bh=AOVxpdK8PWYWSzO+/JuhNUxhJ5Qp1ne7aSR/kcsA+9U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=szbn1all5zbaeBw2zJD9upPTtCyhkbZuE3r2SrPzHlXnuHSD/L/yhhx3cUZqRL9BTOpGQRUHYYM9LFT+vIpzAxdE5FIIK8N0BUYFq1Ls8XDultafYLgcryc2AR22knYEw3I0Aex3MOyZ4lkYUsi8dyeUS6uBC43p0om258iiI7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HOFESqoU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HOFESqoU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1qJ+8zvQuOlIxtamJsyot7tCQET1NfBVbvOHPnjcCnE=; b=HOFESqoUhpVyu+JAI+MgxyZpKV
	Q53/KPZdafpxU3qVnfAdmlI4Oy3/zDUGqeInYgu3icZylzrPANaPaNB0euivreJXy4qbl3So2yrWq
	nWD2GJ+aeCuj0T+fATBTWhUbmuvwSmr8VYcYqWiJ62RtWmuL7iuTOtwynEi2bXtBR7wpihfk/J5rt
	8Kl5c6wiOEQ8Rcmmj60WsVpeMFciXvChxfEL1jLeUV03q3C8g91SkEr7Zpj9uhh1Q0Aiq1vUomvXz
	2kWY7mT+K4zAZFF5sd7hUh6SqutTSkEKWyxirCgQ6psxom3Cvcydo9Djr51bgeuQdpA1UC2XnTLlg
	CheptbSA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wlrvu-00000007Yq8-07dU;
	Mon, 20 Jul 2026 17:37:38 +0000
Date: Mon, 20 Jul 2026 10:37:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/5] generic/746: skip on zoned btrfs
Message-ID: <al5c4krF3A03HZ1o@infradead.org>
References: <20260720111849.1659111-1-johannes.thumshirn@wdc.com>
 <20260720111849.1659111-4-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720111849.1659111-4-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 20, 2026 at 01:18:47PM +0200, Johannes Thumshirn wrote:
> The test relies on loop device discards punching holes in the backing
> image file (holes are then detected via fiemap on the backing file).
> Zoned btrfs does not support fallocate/punch hole, so fstrim on the
> loop device cannot free space in the backing file and the test cannot
> work.
> 
> Skip the test on zoned devices, but only for btrfs so that other
> filesystems (e.g. zoned XFS/f2fs) can still run it.

This should use feature detection and not hard code file systems.

I'm also a bit surprised that zoned btrfs doesn't support hole
punches.  Unlike classic unwritten extents there is nothing in a
zone model preventing them from working.  Did you try just enabling
hole punches in btrfs?
