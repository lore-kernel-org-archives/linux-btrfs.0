Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC97335067;
	Mon, 16 Mar 2026 16:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773678594; cv=none; b=iEme2r7gnUzWQ4ZRkgYdOIwQcmG8aqxNS9uemKBOsZrkFd2cr8689MSPnUYQO83EFh6sCLY19EEnRtrIN9XXK7NlN/dICWoS2jyNASArWQ2MAs5Z1dlmxnR732cZZ0Qe98RADNkjAbd0uGvyoioQUabnu7IKZHI36UTG3Fb3vMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773678594; c=relaxed/simple;
	bh=Q63k356da7lrFrLT3m0Nd76ONZ+WvvXppuG7Q5n5Y6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SpDl71ET9zp2Zuvy46FCEKv8CWHa1hcbtwbP5u1IgzBev7HWIRkj6aWPVhYl5vEjqas7vzPPFZN7rwF3JPE9cloUgaeGhVuM7fyi3LveIs1t5sZdrfu8PKYPIG3/zzOdVzAyVfPkm4D0ceHsaed9jTpvS0m0dQyD24rj2tLDJdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=5A5pxrI7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="5A5pxrI7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LOYPSzph1NHeq1BodHisai35r6ik0awd7KvuePptLus=; b=5A5pxrI7NLg/oS3YBDmjys0Jwo
	Z1h+N9B+Ub2hcshCZDbF/Ru040WTfwZvhkaJ4djpNu5lM5em0c1d+77vuTHfxDg9DlnlmF00fqrQ7
	ELflu1FZi5mETXUSsI4BY1n8W/74Hqr/PJoz2E8mrfcZ7PIL6dpQlVyf6fNPS6zdCbWCToArEGaBc
	xRJE4glI9MTWfOrCBnPC05N4FlA5EMRYhe0DJMmn4kTXnwWGAOEM7ZWp3C/8Pp0Ve39pXp/SJ6pTS
	llUem6GsKgGL9Xa4bJl+HnYRxiG4CXgHAqaW/M4CysqE6siyS8sAJPukNceeTvN/IsSC6X0Du4FGe
	IdTYphLw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w2ApE-00000004SMy-47pT;
	Mon, 16 Mar 2026 16:29:53 +0000
Date: Mon, 16 Mar 2026 09:29:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH] block: reject zero length in bio_add_page()
Message-ID: <abgwAPMckUrmsnUx@infradead.org>
References: <f3db373bad065ae6251892acd15993f5dd56dfe1.1773368732.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3db373bad065ae6251892acd15993f5dd56dfe1.1773368732.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

I'm a bit worried about adding more an more checks, but this seems like
an actually useful one.

On Fri, Mar 13, 2026 at 12:55:55PM +1030, Qu Wenruo wrote:
> [BUG]

However this [TAG] style commit message is a bit weird.  Can you 
rewrite it like a normal kernel commit message?

