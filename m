Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D220640682C;
	Fri, 21 Aug 2026 05:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787290596; cv=none; b=GcvuqWYhOz2HMbIxxU1xb7r0M8O4aLTkj0ntVimWwc9RhPtG++tl4kEiLW4Yd8MfVl7NXJHdQdE8Vd5wJQ5N6+s158K0OgZKBMtc2GQ0F5l2KK/VRMztn2YNI8/3ChfcTklwv+kgDGKLnoR94eZ6ed/amiUId2PLcNLDgEGMMNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787290596; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hdgeBqS0vyo0Gr6pDCkfgWhJ7XaW3y/5QNl9CO5Qxjd5XW5JACITpxvMB6XGLA/LCuEW4cmnavMTyWFMiblfb+am8mXsaXDE2U9S8Zz58QnYSD7QHMWvBsD39rFf47P0vkjHKzpOdy2XCtyXPZseRbbCUzJ+pmms9JFIQj2E6vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UFKYB9Qt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UFKYB9Qt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UFKYB9QtSoQOOz4HyvL3stYxeG
	Ev7vxZQqYMZE/KOJ1mL8RTKPnyKESQwX0WlWzot9utVov78/t2nZTD7SA0oNgzFIOqkjruGvD/Ztl
	tE16TQ5vF8BYU+i6u/uNZcbKX+Y/MJr8TtxvqJIidT1TW1UoO2TUfo9ZY7X8BA3XwREMhjIc6vq2s
	uEv66zuZjHzLw3GmFIXl7JIbEceYqoBEwnPXMMBEL5v0gvFCAwLBxqSiV5IQy/o2GfPdTQ6qdTQJB
	uPEedEC3UanvncwDtkcLQ+iGFPQxh/tiaK4UZtY+gDtRgUa8UGJqAZm1nJAk3qJKkYZSHFKZ8Nmdy
	h/Oj1scw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxHve-0000000CZLr-0Jxx;
	Fri, 21 Aug 2026 05:36:34 +0000
Date: Thu, 20 Aug 2026 22:36:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/5] common/btrfs: fix awk field separator in
 _check_temp_fsid
Message-ID: <aofj4h3C4sjFIjkk@infradead.org>
References: <20260819131606.1478488-1-johannes.thumshirn@wdc.com>
 <20260819131606.1478488-2-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819131606.1478488-2-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

