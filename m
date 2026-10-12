Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B370E47255A;
	Mon, 12 Oct 2026 12:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791808393; cv=none; b=MvzboTbBUz9lwAk5QhKv1zarGN7uagFZsOExhrYWNwE8dJ6hzM22SUhdqxpn5vUMStbrDca5bH15nDaDqH1dL4skDPB2FZ6+ddC/5EkscLovZsIHst1TMs87bdbSmhaKvSgiRKqlAUqfWWe0JJ9d454rE2hQSvLg0tsSxAMgPS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791808393; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RgJ1/bwllBB590uN0pke+1b0C7W/pYq0KEpWjPZ372D4XQGqn5/s+PjJRl2BwsIocLqHRHX6N2BiD/rXUUxzShPxsU1gk/5F2XNZiVkrkDtpvwBBy+qkQpP5AuDPen9BuY/8y1kMfDovzIhIp/lJIdNfh29UvksdVOBwSoVKrSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QuuU6UV6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QuuU6UV6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=QuuU6UV6tsVKvKnE0r3330A8UO
	ge+brHN8cQAU2WKwB3gb4zGHV3MEhvFYL1TFAGBz72p/iXgM9B+Wc8m+GCXeSS4TVaZLoxAkTgziV
	6YhL4Pdwmnusk0hDCp1rLtkd5ZZl6CQUNMAU4CC8EhT7VTAuNuVUSqP+lomeXO7Vx7jBiDby47xFO
	nIRcs16Du3O5pWtdcXYnKItEdyC3mz7L3CbTKpyh3epd3U+k6SqFKW6Bh39s99woaQCF+JEl+1lt2
	IIQ0vbJC7I0y0BCL1wRvDPgwnvWIaym4g6B3yvB5PR/ljrrePECV+WB3DsnbOiBcFuzU3Mwu03XJ2
	Ko/T6DUQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFDL-0000000ASmT-13yx;
	Mon, 12 Oct 2026 12:33:11 +0000
Date: Mon, 12 Oct 2026 05:33:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v3] fstests: generic: add a test case to check fsverity
 reads
Message-ID: <aszTh8LpDInLewpr@infradead.org>
References: <20261011222613.10793-1-wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261011222613.10793-1-wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

