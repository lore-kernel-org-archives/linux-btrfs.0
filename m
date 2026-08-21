Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E584052D6;
	Fri, 21 Aug 2026 05:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787290705; cv=none; b=OT2apcOQF3S5cCkEkjC88GCKnvQ12CCtsD/rBuLHrgTtgbJ2WVQg7V2JzD1gM1uthNdadwV8s+cMVg7asPYhwqt2H8UM281rXh/jLUubiuVgiSpkmmBXRK5gV7jK/ZlFQfZSJiN4OYP0ZWKzTPhHM5ppfi34c2x4BIj63mpF95U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787290705; c=relaxed/simple;
	bh=TrGsRTudCMBQ2k1c+Od0eZPjH/Le0XaqsFnVvGs9hO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uKhfa0Icszp0YIC300u0aOT1DmrW8JoKNPkVvHc9BPEkCR8Nkon5G9pyP3kREfk34iKlit5t7swlHlZHntnlMH8XoTFs7vX1BdJ1fDWsxIUa8y+yk4cV3ytDaQf4tBcK2C/qV+DpU9zEJBI/qq69CRNJgot7TtZG/vmvxrMBwq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iw04q3+e; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iw04q3+e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GKddGqXHEhHTr55nqB2sXWv4JvnCdN38b+cFLE5wl/0=; b=iw04q3+eXMUS15gbP2T0tiqanC
	rarT+aBx+CGrg3w7s1HgjzGzNwTWx9m7Yumh1KR1u6oOUG6hfjbtygTAGbuOvbaqymmqsOoep/eSq
	/PnUTitwVakip9yWx5YvWKc5BTQct+NOMPR7C7NeMXZJyGJIaNi+ASCg0N92SxlR7tO9A1KPM4ngW
	8A5ECYrhr3tOZEg6hLLnCccbD7DkTu6gvDuoxp6AvzcMM6pSJIdw2VT6m8zkLzFUcmnkYROqJfKQe
	6U+rkBRuz5nRfNuYjZ0qN0xP6/Wxdp8uYu8Wbf5y0OA+OX41lqOZpz6hun4MoDyCJGR80zELgPeFd
	m4NKT//A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxHxP-0000000CZO3-2OjJ;
	Fri, 21 Aug 2026 05:38:23 +0000
Date: Thu, 20 Aug 2026 22:38:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 3/5] generic/746: skip on zoned btrfs
Message-ID: <aofkT7rrfQYCr6yK@infradead.org>
References: <20260819131606.1478488-1-johannes.thumshirn@wdc.com>
 <20260819131606.1478488-4-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819131606.1478488-4-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Aug 19, 2026 at 03:16:03PM +0200, Johannes Thumshirn wrote:
> The test relies on loop device discards punching holes in the backing
> image file (holes are then detected via fiemap on the backing file).
> Zoned btrfs does not support fallocate/punch hole, so fstrim on the
> loop device cannot free space in the backing file and the test cannot
> work.
> 
> Skip the test on filesystems that do not support "fpunch"

Shouldn't _require_fstrim return false for zoned btrfs given that
trimming makes zero sense?  Otherwise once zoned btrfs at some point
supports fpunch (which it really should), this starts breaking again.

