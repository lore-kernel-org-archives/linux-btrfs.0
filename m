Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C973590C3;
	Thu, 16 Jul 2026 09:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784194194; cv=none; b=qw61KHXpon0Jpf45lH/KDrkoLykAxNINo+NFI08mr1NmhlMb7G86a9vKMh99+rem4WaeRn0rnqgrZXo0XItXiOQGZWtV1b499tDI4V0WA6PxmkZsWnoD4bqXo7s/J7m4yGKGIUjpV/xhoR1WHm9s16g5z4Xuv3nlSiIZPe99wc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784194194; c=relaxed/simple;
	bh=aI1G7pIUYEc0KI7+aPBSxl7AMuXkXU+fp+1QAbvxBek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tidoaVw+1dfROILrqewX1Nm+IAZWUTBlKeGG+n9AAgdc5cMzc63EVIliM1PpjWxjQVLmEQ0L3r0DeJXKcYD9fn4MgepPLeGNh3S2/TkcXBc3FUYvDjN7SsSl5mkEY9NeZjlUje4mRPIoegwg6dxhlpGZ1X1f3O34ozbOBEGdIUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uRrQpRCQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uRrQpRCQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rn3IIyqwAq66vUZzMQaZATUhjYxuwm96LQ9g78KE9ic=; b=uRrQpRCQHTUp0yiTpEWwzlhyNK
	E/B5VBCnomTJK9Xsp5dBGx6nyg7yVwuFT+yf57JTBcm2/pDbnzu/oiHaoSAu0XmSeA7Icl78gKBsy
	NVtM3YC457uI/NZC3DFd2isvgRWP+15MTXXkyo/1kONXd0Yx0I+B9Lirza/FoQ92XUtSIyi87l+HM
	ZI1cUwsWHvLEwbqZ0nZqE6hMLsvzlo48gzwovMkiYzVsH5HSrzBHaAOY/245FBaJxTYzwry3IC2ZO
	tbe9MFasfFBILd7vOE9+B8ip3e7iWBclUfk9bMCdaWiEyIY0bpexWVu9nQy6z/VcIutdNDPtZ1y7H
	6cGLc/kA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wkIPe-0000000GryX-18Os;
	Thu, 16 Jul 2026 09:29:50 +0000
Date: Thu, 16 Jul 2026 02:29:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] block: do not warn when doing greedy allocation in
 folio_alloc_greedy()
Message-ID: <alikjtke-YNWdd1I@infradead.org>
References: <d10571445ee505d95ba6eaad7558fc1f556d2921.1784020005.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d10571445ee505d95ba6eaad7558fc1f556d2921.1784020005.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jul 14, 2026 at 06:37:39PM +0930, Qu Wenruo wrote:
>  	while (*size > minsize) {
> -		folio = folio_alloc(gfp | __GFP_NORETRY, get_order(*size));
> +		folio = folio_alloc(gfp | __GFP_NORETRY | __GFP_NOWARN,
> +				    get_order(*size));

I though I read somewhere that we now don't have to specify
__GFP_NOWARN when using __GFP_NORETRY, but a quick dive into the page
allocator suggest that no such thing exists.

But can we make it happen?  Having to specify __GFP_NOWARN when the
caller clearly indicated that failure is perfectly fine using
__GFP_NORETRY is silly.  The same probably applies to
__GFP_RETRY_MAYFAIL.

