Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB7E246768;
	Wed, 15 Apr 2026 06:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776234445; cv=none; b=X7+587npISSW/3B28XmJBDRynZrp5LhFzwnKqewkttvXciBGJEFRrUh+KtxSnAQcAbeu20EkHOSZFQJqXLBeJ7FbllSlnfJxuOg1aqmi25r+j/vPZJoh90emKVnPcFpijMeh1aEtfwOhqk/TPVQLNuetTNA7WjIuIWYQxQkmWZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776234445; c=relaxed/simple;
	bh=Z3kL4WpzINB5y6nF4QUoHulkMIHkFFAgpB3ENpr8+T0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CuP91KohnnoQtKXHW/UBwQC6HK4CVM4mcBYu6p9HGTkIFIUUVDgImSiJlqokOJDJExacXnQfJJ/ft0FcO5YzkHFweG+RAmBEH6ZEgaqDTdAbKFmpQIQ8oXYuUtorPyx+D7OXijTo5BBMuduzIQn/YHUkKVyaoSs0Ts7xKbMGwU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 56D1168BFE; Wed, 15 Apr 2026 08:27:21 +0200 (CEST)
Date: Wed, 15 Apr 2026 08:27:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@redhat.com>,
	Naohiro Aota <naohiro.aota@wdc.com>, fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] fstests: test premature ENOSPC in zoned garbage
 collection
Message-ID: <20260415062721.GA27874@lst.de>
References: <20260414143341.167875-1-johannes.thumshirn@wdc.com> <20260415052203.GB26443@lst.de> <6cfca682-4f8b-49f9-ad16-21d90eb5f402@wdc.com> <20260415055629.GA27242@lst.de> <6a849834-75de-4007-8591-05ff9eda1932@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a849834-75de-4007-8591-05ff9eda1932@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 15, 2026 at 08:10:29AM +0200, Johannes Thumshirn wrote:
> The test still doesn't run for me on XFS:

Worked for me.  What does the full output say mkfs complained about?

