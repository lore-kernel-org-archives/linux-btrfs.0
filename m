Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AB54052D6;
	Fri, 21 Aug 2026 05:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787290747; cv=none; b=iim4ePjqfO6nvnm9v+D7LKsvnJCgVelzgnGzwpDfKlmHtWvAxhpws9rU5EhuknJ0CwD5MoSz3Zb3TgCM3hsHa9G/XrnytzVHlcHosnd+wUyPCP9YagHH6noNI3AQmx8XoMvmrT5rz9KRylo4HfbzDsDUb6Mqd+qvW3MZ2oP6rFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787290747; c=relaxed/simple;
	bh=e4Tgx+8MUYgK948UmRlQ+OOovCOXxuRqPnb2sUB7lnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=buZ8JT9ceq4kSua3zbGsVOq1m5xCdP7V8lYV6GQVe7ZWFPzfbAg2gZYlFrSqyP2QruTsGt0tXI+TiY5iny5isDRbCGA/5Gc9ACMdvNiTnYBURs4FbMaxg2iKq/JMaUYHz0iba6IhSIUilPGbIm7ueKtjV1f2q42YtscaOQeAiVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xA5j0lSh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xA5j0lSh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=e4Tgx+8MUYgK948UmRlQ+OOovCOXxuRqPnb2sUB7lnc=; b=xA5j0lSh0XoPTPB71fOi9zUDNz
	z8OJqvibn9hdU0HCxuXsPcZ4B9h+Z+pUQcn5wr/xGNYEXccyyhVNUBIpjt8RUQPtrywhh5xrL4bIr
	VdA9r/lwAc8m79IKMeKmukVd4YfQo0UNJtBT6FElN5+/VeWu+pPlwtqL0exB40e4+KdNCZ8ysyR/y
	XJmHeGJq75TX0n0jfqfYjt/sPwA7xr2Yiyt2S5PhYO+75FEeciGYnIzK16UPvpt2zzEtq/OicpbGq
	rSAw/qx7KNSiLAomIT4k0cHP7uOougr8nmgBDUq2eP7H9vEO2/VC50h/F+U8av/ZA88VJS6lbM1H9
	1d6aLLMQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxHy5-0000000CZQ7-2wK7;
	Fri, 21 Aug 2026 05:39:05 +0000
Date: Thu, 20 Aug 2026 22:39:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 4/5] btrfs/284: skip on zoned devices
Message-ID: <aofkeaym0bilKKtp@infradead.org>
References: <20260819131606.1478488-1-johannes.thumshirn@wdc.com>
 <20260819131606.1478488-5-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819131606.1478488-5-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Aug 19, 2026 at 03:16:04PM +0200, Johannes Thumshirn wrote:
> Incremental send stream v2 uses fallocate(PUNCH_HOLE) to represent
> holes, which btrfs receive replays. Zoned btrfs rejects all fallocate
> modes, so receiving a stream with holes fails. Skip on zoned devices.

The requirement looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But isn't not supporting standard send/recv a pretty big limitation?

