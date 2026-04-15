Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2D437E2F5;
	Wed, 15 Apr 2026 05:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776230529; cv=none; b=Ur/CnL3Ffc4HUerMnMUQpLQ0W8BSwel/ruguSPAossMSJO1Fm86EphOlee4ePHwM5cHbWHP2jeEgYG/2ivyxHuhWAe84L3He5L2BGaLbFeITMUJwhGEuC4ySb6raGCP+d4MoZCaP0gSlUbH2rpyAGpn/Oia33h3QoRTNinSE9iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776230529; c=relaxed/simple;
	bh=tUAjicaaYL77It4ZOPRTanjx9MixRHDfMTtAFZXq0sg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hZznJMblMmZr732S00zQ1BUksZftyRiaw6/EKBOmyW9IW9ZApzH14s/whfd1EiVvthwg+yLJBB9ZZPlqEzfnoWBVFxZP4U3wt4j3d6fDystMXlhuFLBucn0SRUHum/Jb2D+QZau2KAHTG4xCe6jQxF1+7yzTHFSD6XGAsftub10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7236668C4E; Wed, 15 Apr 2026 07:22:03 +0200 (CEST)
Date: Wed, 15 Apr 2026 07:22:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@redhat.com>, Naohiro Aota <naohiro.aota@wdc.com>,
	fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3] fstests: test premature ENOSPC in zoned garbage
 collection
Message-ID: <20260415052203.GB26443@lst.de>
References: <20260414143341.167875-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414143341.167875-1-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 14, 2026 at 04:33:41PM +0200, Johannes Thumshirn wrote:
> This test stresses garbage collection in zoned file systems by
> constantly overwriting the same file. It is inspired by a reproducer for
> a btrfs bugifx.

s/bugifx/bugfix/

I tried this on XFS, and it doesn't work as XFS uses SCRATCH_RTDEV for
zoned data.  Manually hacking in SCRATCH_RTDEV makes it work, but that
will break btrfs.  Maybe you can add a little:

if [ -b "$SCRATCH_RTDEV" ];
	zoned_dev=$SCRATCH_RTDEV
else
	zoned_dev=$SCRATCH_DEV
endif

end then use $zoned_dev to make it portable?

I also tried it on f2fs, but mkfs.f2fs fails now with a 'different sector
sizes' warning when using a 4k-sector conventional and 4k-sector zoned
ZNS namespace, so I guess I'll give up on that.
