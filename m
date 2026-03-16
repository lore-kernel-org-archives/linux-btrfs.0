Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B02032AAD6
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773678025; cv=none; b=Zex2CTn/X2BEstp34xzavF4QNF/73zLgUwgDZViK0qLN92TUDyghcpyRI4eqJNQf/6A/9zDNJ5EQMf6SHtPu/nvv12qydnRWZQAaMuI9NQL2jBDBhobwOIBccyE6lJK8sjHzOhDNYP4fyV7hwK1LFO+pcY+vz/BgNWHuc52Rs/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773678025; c=relaxed/simple;
	bh=JqJn0UEue4dTXRXIpD0E3+w05Nddws04tDyc09UcmLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ksVg/B5IijeFipJwcPclmN2+HfhXnPkI/meIwGF6yWZi2xU5qMmhy2GiWZGX18+NedcYJqFW9NsN5OxVqTnIIaO2QgLKIZDcvHQ1MTOYRxpyV5qlei3V6mAo6I1i4P8aP8Sxk3QyOTWi1zjZ3uURNpAs4OajF02BRw3sDImLlVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 18A3C68BEB; Mon, 16 Mar 2026 17:20:21 +0100 (CET)
Date: Mon, 16 Mar 2026 17:20:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, hch@lst.de,
	sbehrens@giantdisaster.de
Subject: Re: [PATCH] btrfs: btrfs_log_dev_io_error() on all bio errors
Message-ID: <20260316162020.GA21157@lst.de>
References: <d2edb3eda4038ef4f2dbd7b76a33a84e3b4ba32c.1773429838.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2edb3eda4038ef4f2dbd7b76a33a84e3b4ba32c.1773429838.git.boris@bur.io>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Mar 13, 2026 at 12:26:05PM -0700, Boris Burkov wrote:
> As far as I can tell, we never intentionally constrained ourselves to
> these status codes, and it is misleading and surprising to lack the
> bdev error logging when we get a different error code from the block
> layer. This can lead to jumping to a wrong conclusion like "this
> system didn't see any bio failures but aborted with EIO".
> 
> For example on nvme devices, I observe many failures coming back as
> BLK_STS_MEDIUM. It is apparent that the nvme driver returns a variety of
> BLK_STS_* status values in nvme_error_status().

This goes all the way back to adding the error counts in commit
442a4f6308e69.  The block error values are a bit of a mess and it's
on my todo list to sort them out - only a small number of them should
even be seen here.  I'd suggest to leave things as-is for now, and
I'll make sure you're included in the discussion when I get around
to attack the block status vs file system issues, which will hopefully
be very soon.

