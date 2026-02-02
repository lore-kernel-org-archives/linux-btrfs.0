Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A032DF144
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Feb 2026 06:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770013502; cv=none; b=aVxh9EdwGJmIttH+cKUKa+WVtptmMXrwkZzpy+Tj2PAANvWkcsQliANCk5CvGOSQaln5lhHERWXFW/1iiXBvfRT5upzBxo8tyfz187zQoiaKF29b1ScWhjeKVXPP8+3wo8S/mdYmZMka2fnq5Ozm3P5AJtugPnJoV5VQ0ZONxZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770013502; c=relaxed/simple;
	bh=1stEsRXMrvtz8ayBVAtEaJbfARkQAtDcUuc1wkDlnSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ReCUms6UbDKOFnFKF9QWh0KpCLQoxHrXeyzwPnEE1ZZxiYpBXI2JueiUp0NrFwzI4V+ig/g92FHJKWGZ76XieVuezqhvbcAhvkgrnsG92aBzjnW2uvI5+VgYnPawSen2papacWnA95bNVUgCSQm3/he/ETJgo0U1Cm/TZ9IJ2z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CIJKFs9R; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CIJKFs9R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=R7UUS8YTAFiDOtlPb4fSAo/WYggPwUbnTSBl206jBuU=; b=CIJKFs9RVjiljyf4iqGCr5QpWI
	q1AviO0eYvz9tl9B2gnSRz4LgXFL0ue4CtEYeAPtqUeA2gReaXaF5hzAYvvZ0uGuSk0XvKEqU9KlP
	HuKCUTigCZXT0T9ke00VEZV459sDdLE3ArnLWOt2BIl0YPm07G/csR5pQYd+c24PwvX/N3vhbYPj2
	dR/srp/iBPToFb9e6Yh/urVvW9rYFkJY2hc5f7gYLtlIBCMnWNTMytir6RVR2k1/nYf0YhGltOkdm
	4zm93+Z/6SZcMQfKia1P1YtfdwxrGNDSV7hmGNALOX1DK+SV8xEBMiLBWaqR7kpzHcuLbieGPwXV7
	gIpNRB9w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmnMp-00000004VMY-236L;
	Mon, 02 Feb 2026 06:24:59 +0000
Date: Sun, 1 Feb 2026 22:24:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: raid56: fix memory leak of
 btrfs_raid_bio::stripe_uptodate_bitmap
Message-ID: <aYBDO6g5JB8F9Vvm@infradead.org>
References: <140aedc1e1af2866bb838d29b742c2015d55d91e.1769793280.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <140aedc1e1af2866bb838d29b742c2015d55d91e.1769793280.git.fdmanana@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jan 30, 2026 at 05:14:59PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> We allocate the bitmap but we never free it in free_raid_bio_pointers().
> Fix this by adding a bitmap_free() call against the stripe_uptodate_bitmap
> of a raid bio.
> 
> Fixes: 1810350b04ef ("btrfs: raid56: move sector_ptr::uptodate into a dedicated bitmap")
> Reported-by: Christoph Hellwig <hch@lst.de>
> Link: https://lore.kernel.org/linux-btrfs/20260126045315.GA31641@lst.de/
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

This works there, thanks!

Tested-by: Christoph Hellwig <hch@lst.de>
