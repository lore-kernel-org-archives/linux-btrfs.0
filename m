Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD20431F9AD;
	Fri, 20 Mar 2026 07:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773992188; cv=none; b=LILyuwSUgaF0kip8YZDVIWujDy20XHnGvHzvpPmJANvoeSf4f0q8AOxwgbbrvBZxL4icf+RnRuts1hoXu7ovnWjW7YodB8dU9CkKSpnKiIGvArbt68jPGIsWmqCQAEIDow5UZd/wao8GO7vmFoysar+vtGp6P/hRfqAmFhSb2Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773992188; c=relaxed/simple;
	bh=rlM6c6zXGuC1RmJn9xdidyOhaBk60RenE9LfSeCBokg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WlEPtUEZ+LyRBZh6lbjJbHXMRyV2Rjo8cIt4oNu3hfTXSAnJJMpRhO6EF+hKB4uoQ5maFzeokCBl5X3yZ187Mhj9q+hc1+FgSdy4d3Hpr6h2/BdiceAJCvABiTLXta1Y5NsRNNgjtKDx/+FNbuTCofSgN8GjgSGcI24qNndg6sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iQgnS3Mv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iQgnS3Mv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rlM6c6zXGuC1RmJn9xdidyOhaBk60RenE9LfSeCBokg=; b=iQgnS3MvEwGevRawNf9Ehdz+7X
	b/HVuhoKm8FXHht5TAmCZS23XRyjasyZHc5Z65Qy4gqimC766sh2W05pwYCFqDPiWPNaBrDshkOSZ
	u3aw9WgOjd+j/1jaBGP3TB81qGJWSC5UR1yApHcYzLnotvXcipm7/H+/ifgYl0yfhlinnrnLgUFwM
	LTrNxD8pxMwikmjW+jJxBP/1tUWYs7aqKshU1/abChLTYdqzZjdrM40tUWwdkPJPqxtgStJcfltgQ
	OtyJJP1/GuUYPAiQuF5macQMVo6kLjrU1MjerTy88vpNKjv/HKWyh6XaCr/oPWaXpXWyRFos0FK08
	Oo5PsLlw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3UP7-0000000CH1i-37IV;
	Fri, 20 Mar 2026 07:36:21 +0000
Date: Fri, 20 Mar 2026 00:36:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: boris@bur.io, mark@harmstone.com, clm@fb.com, wqu@suse.com,
	dsterba@suse.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-team@meta.com
Subject: Re: [PATCH 2/2] btrfs: prevent direct reclaim during compressed
 readahead
Message-ID: <abz49WgkJ-KpmBcN@infradead.org>
References: <20260320073445.80218-1-jp.kobryn@linux.dev>
 <20260320073445.80218-3-jp.kobryn@linux.dev>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320073445.80218-3-jp.kobryn@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 20, 2026 at 12:34:45AM -0700, JP Kobryn (Meta) wrote:
> Prevent direct reclaim during compressed readahead.

This completely fails to explain why you want that.

