Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370EA3D6468
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 13:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773755987; cv=none; b=KMa/2UmnVYvtwzE61fdvRmClQIRDE36P03iA3errEJYD1+344Fx2vkbP2lIEZXcTuY+Ka09wRjDtJXEYdidJRcIX/v/N3+3mEnd9deXWOS1VLzVtcfHSaHn0bhgFsvDRVP3ylNKRtXPM/bd0wURE6Qt3LgDlLrym6asnRq4C82g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773755987; c=relaxed/simple;
	bh=3OOBcmsGu2hGlCqbTorExO7VfNCkY4Z+w5cj5imtLm4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mgvic9IJoEzhP0uM3hKvmCwT6a4hBdJiZr57VTUh7nuYrrCgR7ej4q/S3XuH12FtgGEK+Q7eSVEShMOHs0GkS3QmR7bQ/9PedrpeVfR5ao4xdzEd9L8Re+v9a2bo66pyj2ChO+7+yj4RJXT0cxSSMXHGxWJY4VVkAK020aYSKcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F26F168BEB; Tue, 17 Mar 2026 14:59:42 +0100 (CET)
Date: Tue, 17 Mar 2026 14:59:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Boris Burkov <boris@bur.io>
Cc: Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org,
	kernel-team@fb.com, sbehrens@giantdisaster.de
Subject: Re: [PATCH] btrfs: btrfs_log_dev_io_error() on all bio errors
Message-ID: <20260317135942.GA2670@lst.de>
References: <d2edb3eda4038ef4f2dbd7b76a33a84e3b4ba32c.1773429838.git.boris@bur.io> <20260316162020.GA21157@lst.de> <20260316162951.GA1074179@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316162951.GA1074179@zen.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 16, 2026 at 09:29:51AM -0700, Boris Burkov wrote:
> Is there a reason not to properly log the errors we are definitely
> already seeing?

For example if you get a BLK_STS_AGAIN which is not actually an
error.

> Put another way, if we are in a situation with technical debt, which is
> what I think you are saying, then I would rather have more visibility
> rather than less.

Can you give me a week to give this thing a stab?  If not please just
add STS_MEDIUM to the whitelist for now.

