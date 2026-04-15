Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250D630AACD;
	Wed, 15 Apr 2026 07:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776236661; cv=none; b=iSE5VVrGR11ubg05mrLT48L5cRjEWXsiPvlPawxBhGSJYidBvQfw5oFDlyHqWYbhlVoiqzDu4uX5XN1z9UVSwZz/FN3DcuRAlhz2yHanOQsOfWVdv5QOOorSkRGK2SVBOL/MPiarM45d11Rp6m4Cj4nd2y/vv9VJcgMUU3P+5V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776236661; c=relaxed/simple;
	bh=ibwktoDrttMYYGFpE7mydFo+LpSYz9PJUxsJjKlsGYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eYBodP1D9N1eHBTb7LSoVjFUNhUCoAgrn2bDAh9WsPY51nJOguQLgJB6/IQqBMcgvP//tnjLBJfRRNs037jEPebCo3geLgea+84ZC/TBilNmnb7I0Idcp1/DBPRRaNICfwevnfkwThwnTaBMLVBeGCI7rzYypuEWOH7pWAyQPQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4264B68B05; Wed, 15 Apr 2026 09:04:17 +0200 (CEST)
Date: Wed, 15 Apr 2026 09:04:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@redhat.com>,
	Naohiro Aota <naohiro.aota@wdc.com>, fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] fstests: test premature ENOSPC in zoned garbage
 collection
Message-ID: <20260415070416.GB28634@lst.de>
References: <20260414143341.167875-1-johannes.thumshirn@wdc.com> <20260415052203.GB26443@lst.de> <6cfca682-4f8b-49f9-ad16-21d90eb5f402@wdc.com> <20260415055629.GA27242@lst.de> <6a849834-75de-4007-8591-05ff9eda1932@wdc.com> <20260415062721.GA27874@lst.de> <fdabef27-ecaa-4b85-9a88-8a0514523b56@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdabef27-ecaa-4b85-9a88-8a0514523b56@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 15, 2026 at 08:53:52AM +0200, Johannes Thumshirn wrote:
>> Worked for me.  What does the full output say mkfs complained about?
>>
> Here we go:
>
> bash-5.3# cat ../fstests/results/generic/999.full

Oh, this is because your conventional area is too small for the
specified size. My test was with large separate conventional and
zoned devices.

This has hit in a few places before, I'll look into fixing it, but let's
not block this test for it.

