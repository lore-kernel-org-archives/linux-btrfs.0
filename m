Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FE91096F;
	Mon, 17 Aug 2026 03:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786936059; cv=none; b=uypOVEbWubQ6zttWga1chEBz7oqA0m+zEX0WjKt+xxoLXWRR7/Ue2tX2cmOR6PURyII3Hm6PYbf0ksFs3RajjbrTr2MJ5KdSU0xmmXMgPmZAuNDszZTF4kiKzZHSxDtg9xQH4hBLrjjh/IJbqmLg11rN2yrY9uS4j2xrPeHvb50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786936059; c=relaxed/simple;
	bh=LvHfJ+tvo9NIgxJcBs4AhSzzICNZqcSlCNVyEBkZtzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d77qTojzMPAb02IMqaP1BF8o29QsdBn5EXEPG9DS/SucQqtXG3gV1fNoD3j8TeokRa6pYV196ceYYJuPTiyvaKviBzWDUlXs/NQf8hB2Ie6t43qeTyXFPUNJ8AIAfbQPLfcaXAPn1xtby88kS7wrFOoBgDGxrCxYH/g0oqqbSr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FrW3VF+K; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FrW3VF+K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LvHfJ+tvo9NIgxJcBs4AhSzzICNZqcSlCNVyEBkZtzs=; b=FrW3VF+KzlWIsDN7Z88DlFigFu
	ixQ12RwuZzFrtdD/1lj6k2oXe6njB/lU6RmMf+OriZ2YBfiUXP4sc6Rg2HagwP8EM6f7DeM16F0w9
	w7J8dzrPXRcQGMPYd5oVGdD/oOUIn/gjKqYip3SXK1t1R1Rb9z9YlfhnWbfnhNe22Y4l9WGgTyvwo
	sgmJkS6yPv8OT/YWMaMi774m6ALK7VXc/KdIqfVxE1jkqkc9KSWuMGptCzPPDQbecs4wOv5xOjDNt
	mKGO8r3BEhiDf1ScRlL5TzOQck0CtynhqkzGBXEAbQExhh8jMfoFpZ5uwO5dCzWttxem9Mau4oA8+
	XSndOC0g==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wvnhB-00000009P38-3KVN;
	Mon, 17 Aug 2026 03:07:29 +0000
Date: Mon, 17 Aug 2026 04:07:29 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Sterba <dsterba@suse.cz>
Cc: Yichong Chen <chenyichong@uniontech.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, Boris Burkov <boris@bur.io>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] btrfs: retry verity reads for not-uptodate Merkle
 folios
Message-ID: <aoJ68S-_9W-14lsA@casper.infradead.org>
References: <20260722025435.1493093-1-chenyichong@uniontech.com>
 <20260723031444.GP10684@twin.jikos.cz>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723031444.GP10684@twin.jikos.cz>

On Thu, Jul 23, 2026 at 05:14:44AM +0200, David Sterba wrote:
> With that new label the main loop becomes a less readable, previously
> there was just again and out. From a distance the loop likes a big while
> from again: to read_key_bytes, so this may be a good followup cleanup
> (if the end result is reasonable).

I think a better followup patch would be to use read_cache_folio()
(or similar) rather then duplicating that logic in btrfs ...
