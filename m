Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5441391
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 05:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775538997; cv=none; b=Sv3NgHVJhTNPEx5ChQBJy6Nk/kMbsT56XZEF5kCzVzqyA8QctISWNvEsywh4hO/1OHb6qectZn8/WJJyTYi7XvWg3Cee9cd687J0ekqCEElEfmb4n0iW17F8QgrOTe0rwgpTWtke1wKTBIrE+9Z4qIRa1brHR5l8j+P+roIDQXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775538997; c=relaxed/simple;
	bh=+xo9KL/TGoyKmEXhnCU4qLF8nz+5m6KyPUvoanDfJKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H0NiE1CNviGvQdMb1nuhEvFu+PlbMDh6MMU24IF1QnfdpPfTzmE1w7RwJT/nj0hQZzDZSI3V/9FX+MUIOimehacYQf0BXSYDTDTgoCVInbSIEGoH8bXWDbYHvvXNipvE0Ow3pK/uzDFxuXJsuYdn9GPDMjnLEOZpVtwgsFrjCcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JZUBj61O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JZUBj61O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ff2L6EGw3H9HfeVqeovtoSkMzMFawFnWaAkFoB1AM64=; b=JZUBj61Oiqrd+3ZZIQzLYC4sNi
	l3by2G2HFvEZtNbZkbSntRuXqS4En4er6AJrSV+J90Cwv9QxIryebr0vu+VWFCz/eI0cEA69dn/wn
	irewI7bSHxXokvK/kRVPBY3Ph4paW2nKXm7AEYXQp/xfR+k6CKgdrjNK7G94nsYAzk3VLXoPiePXX
	cca0tHXS4ysQKmkPQnTRqu8fAFkeezllnrrdFxhJ/ZNmGYjACXeeBbTWBNUDVT3MI4aAjmM9gaQW4
	/i+uyDEw4yrdutxjDXoClLQFs5qrl0rfNg5yAxGPVOTBn79GYGKVdBSIgHo/4NvLNaS0s6z+zQi5B
	jMYQl94Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w9yna-00000005uD0-1tdw;
	Tue, 07 Apr 2026 05:16:26 +0000
Date: Mon, 6 Apr 2026 22:16:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3] btrfs: btrfs_log_dev_io_error() on all bio errors
Message-ID: <adSTKjKt_67xF0CV@infradead.org>
References: <335133ce1989ac89a6de007d4db05f5f4a6c1be2.1775491985.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <335133ce1989ac89a6de007d4db05f5f4a6c1be2.1775491985.git.boris@bur.io>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Apr 06, 2026 at 09:15:15AM -0700, Boris Burkov wrote:
> As far as I can tell, we never intentionally constrained ourselves to
> these status codes, and it is misleading and surprising to lack the
> bdev error logging when we get a different error code from the block
> layer. This can lead to jumping to a wrong conclusion like "this
> system didn't see any bio failures but aborted with EIO".
> 
> For example on nvme devices, I observe many failures coming back as
> BLK_STS_MEDIUM. It is apparent that the nvme driver returns a variety of
> BLK_STS_* status values in nvme_error_status().
> 
> So handle the known expected errors and make some noise on the rest
> which we expect won't really happen.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

although now that you have an unlikely annotation for the non-ok
slow patch I'd use a switch statement for clarity int the second
pass.

