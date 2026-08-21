Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97606403B10;
	Fri, 21 Aug 2026 05:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787290642; cv=none; b=SeqIpJQPI4KvFKvsvjSzD4rLgAvPV+5P9P9LQVg5mgVtbIVjSm22O6Nmv/7LeUs+Xq6dwBEAL0jQb33i6D4+hzG+WVRdTaFq3xZvIkIC18JPlyWAd2mjvFfbZokHb+XwYDFRgmNz+C3rcWsqL80gC6AAyk8gePxrXPFrlgDX738=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787290642; c=relaxed/simple;
	bh=r1ZxfHzv86zL4FQv0GhjK0YB/DqidihzPLhq7hFjTHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qER6A7D7MQUpgUpqwXxMi49dik/IRGUSPUDtVsjd+I6PxD3lRQf0JdSofrGLDiuZU7evxBfwKQnpNcdKEGT4yyzwgLiYVxBX7OTVmhMlAKRfX/ooySWOYLAXqI7jAnu/PTfvtUAqD8WLVtFeH4cF4j5remIr9zW5ZXXdmZXhx+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hzoFLZqz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hzoFLZqz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GxZ+xWZFGRo88f5rxItptUCLhUZ6tPEW+4/E8WsK0Fc=; b=hzoFLZqzczSpO7CybBhHRbr24c
	nh0WGQZecu8XTjHl7VMYdjp/k3w6+yZ++Lps3+NwBlWOqcbOk8h58kIjbU3BdEdTlslY8roEuM/0r
	dOyofXtpL92W20jTLPqs/JOFMVmKQGk1+h7mpgxNBHEHoHEgOCykzJbw0j6hPs9vlgCARWOXfghbR
	TGPov3o0pzzm8Ctcf7oJQ/DQOLK70ez6PnjdE1lHx2WjikS/IV2Nv/OpN+utMt1SkiRDKwEtHKM1P
	NeKpsAq+63dSr9IRWnAoZzjvSktp7tSM4lbjyrflDei/8XGRzQ3aTuyfudhSLbT+WDEvMq9V2wqdb
	XyWjrARA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxHwO-0000000CZN6-0j6v;
	Fri, 21 Aug 2026 05:37:20 +0000
Date: Thu, 20 Aug 2026 22:37:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/5] btrfs/199: skip on zoned devices
Message-ID: <aofkEIj3zkXhSRdb@infradead.org>
References: <20260819131606.1478488-1-johannes.thumshirn@wdc.com>
 <20260819131606.1478488-3-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819131606.1478488-3-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Aug 19, 2026 at 03:16:02PM +0200, Johannes Thumshirn wrote:
> The test detects trimmed bytes via the used space of the loopback
> backing file, which requires the backing filesystem to support hole
> punching triggered by loop device discards. Zoned btrfs does not
> support fallocate/punch hole, so discards to the loop device are
> rejected ("operation not supported") and the test cannot measure
> anything meaningful.
> 
> Skip the test when the scratch device is zoned.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

