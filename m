Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7121DE8BE
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 04:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778819965; cv=none; b=a/xTs72eKEhJWcQ7sXlzP0MXzhosMgCR67A3oMB9LD22XXcJ74EUTEOa8yFYxX9pwTODk8P2pITomkDS2OjV05M1ES653Q6ftSHIJHQRvLX4M4IkiDMIQBnJcElxrnuY8vMbhtMlagcmIqFBra1hXEibYO4yf68vSfBe+IJiC9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778819965; c=relaxed/simple;
	bh=4ifrKO50VBk6ka4pIV975EWhWYsWHLRc9ckP/Fif26A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=edUNTX2bapKkGwDHLCZRtbLytKOpCo7FRnEyMAJl8vdYsTCGeZDLT8nMhop1mzPGv+YCzYLYKQW0hrNSmdTQUViNiQGy815mAhyPv8it8qik2wts6Us+u2muyWc7DpEo2VWyrI3jAgaVqARlcJ8TOobYtF1p7FUuFTZp99Is9mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6414368BEB; Fri, 15 May 2026 06:39:21 +0200 (CEST)
Date: Fri, 15 May 2026 06:39:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>, Boris Burkov <boris@bur.io>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/7] btrfs: zoned: subtract zone_unusable space in
 statfs
Message-ID: <20260515043921.GB3936@lst.de>
References: <20260513123445.43197-1-johannes.thumshirn@wdc.com> <20260513123445.43197-6-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513123445.43197-6-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, May 13, 2026 at 02:34:43PM +0200, Johannes Thumshirn wrote:
> On zoned filesystems, space in block groups that has been freed but not
> yet reset is tracked in bytes_zone_unusable. This space cannot be used for
> new allocations until zone reclaim resets the zones, but it was being
> reported as available space in statfs.
> 
> This caused statfs to over-report free space, leading to ENOSPC errors
> when applications tried to allocate based on the reported free space.
> 
> Fix this by subtracting bytes_zone_unusable from total_free_data in the
> statfs calculation for zoned filesystems.

This OTOH sounds very wrong.  Freed but not reclaimed space is usable,
it just needs work.

