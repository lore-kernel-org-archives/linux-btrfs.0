Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8980A374739;
	Fri, 15 May 2026 13:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778851397; cv=none; b=YGwwg9LPHBY4A7xpI0LxB3JunRP33YTOBu8ppDPlLbYpkvIyyqhpKd23dqdYZr+QaABUDeX0uK+kXBf3ntgBDe47x4XmXJQOsWyydrrgALJo0na9sZ40aEgrKoMzMyla47pwjp1+1Qwjwe8zMg4SS8BV3pxudvwxK3hIwfz/vu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778851397; c=relaxed/simple;
	bh=OUAeRmGFrKAqbEYEjKvXJL44Nuyi/LEDMyEDp0FfMaA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JotOCs9pWMU4XiR7L+6MKwbLBCufDHDeawplnHM4LeMa1ycz3xDOMdGv9Z2gJfM5xoOKGIGGqlyTWBwFQ5GfX5+hFRrp6JipCQtNsEBkmsq4azDloEG10PbVsQHeh29mowSMJ+vToNL3Do20xw9Jb+NGaNw4taJfQYAhwPNeRcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tiJ39MvV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tiJ39MvV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=clJs/M02D+bpYA4hUyzi57jr0yjvLDgea9w+FNfRfKU=; b=tiJ39MvVhLAZdQ5j27zAQ5DMcT
	RShTWjEanrg80OEmROi8UfaDW3sCxIWRgBa7Wj2i/acxpbXiTczr62knQK1e3weVYNN+FMc9ywXzq
	Ok6uylH3sYhFcNZbq8c4yY2cpjD5ozZyeyDdWWc55ir5Gggi9ZCZS5vvgsMBYL84Dc/BoFW/kqbP6
	YdgCjDsE1Iz10yJRTEkqx0oWzdzXVQq7XraIj57n/x8/96S1Ko1yzR2VTiSyD/g4vA0pAu3/H0G9w
	72GNA+toFOqeC/XgeaFtS7rsN2P6FIfoNvA2L2oE5t2WtKIrni7/Zi/eNARAu91pFSL0MVzPvgbXz
	HjuzvMtA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNsVS-00000008R2w-0O8z;
	Fri, 15 May 2026 13:23:10 +0000
Date: Fri, 15 May 2026 06:23:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Arun Rao <arun.rao.bl@gmail.com>
Cc: hch@infradead.org, Arun <arunraobalappa@gmail.com>, lenb@kernel.org,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
	pavel@kernel.org, rafael@kernel.org
Subject: Re: [PATCH] docs/power: note Btrfs limitation with FIBMAP for swap
 file offset
Message-ID: <agcePmiiO08tVtNb@infradead.org>
References: <CA+2hknjQ1wLjXdhZWezW=9BwcUhoXhXR1Yi=N8bhce-Qe7+RFw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+2hknjQ1wLjXdhZWezW=9BwcUhoXhXR1Yi=N8bhce-Qe7+RFw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, May 12, 2026 at 03:12:44PM +0530, Arun Rao wrote:
> Understood. My intent was mainly to document the current behaviour
> observed by users on Btrfs systems where filefrag/FIBMAP-based
> guidance fails, and to point users toward the existing btrfs-progs
> tooling.
> 
> That said, I understand the concern about encouraging users to rely on
> resume_offset-based workflows in general given the underlying
> fragility of file block mappings on moving or CoW filesystems.

Yes.  Can you maybe extend the text a bit to generally warn about this?

I also realized that filefrag uses FIEMAP by default these days and not
just FIBMAP, which is what makes it so dangerous on btrfs.  btrfs
smartly does not implement ->bmap, but it does implement FIEMAP in
this weird way mapping to the logical address space.


