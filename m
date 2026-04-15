Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2484D190473;
	Wed, 15 Apr 2026 05:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776232593; cv=none; b=C0YiQysk9zmkmKHDNcALPx697MRQ0XYa4/KN86f3OYlwRDBny7PFcvOzckcw1xs9Coy9nZzAcx1ULL/t8OsLIeiGv59STCwGn+WOJINfjzc7ntgJ+CF9CuKRSqHdq87dJ92l95JYZOZ8Q+9sfSspCx0TZiJ8w9qU8jdc6UxNIvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776232593; c=relaxed/simple;
	bh=5/ohZnqMdqHQ0KCVNxaCaJUXhav6QXFty8F3hqHtlmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hl/o0W41fGjGJo0u4CciNB96QVpgoonNx50+gGSwKYcvYRKO/kZuUtMs8RCjKw1nVTWllI90PAuOAtj968WFBMWgXpxlB0cz8gdoz/3kIr84+E0R3GkzxzQPvwywYIzKCmhbfOqaacHSQdMgcLDxgbyDLeULgDijjs/P+kb1sRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A4DEB68BFE; Wed, 15 Apr 2026 07:56:29 +0200 (CEST)
Date: Wed, 15 Apr 2026 07:56:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@redhat.com>,
	Naohiro Aota <naohiro.aota@wdc.com>, fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] fstests: test premature ENOSPC in zoned garbage
 collection
Message-ID: <20260415055629.GA27242@lst.de>
References: <20260414143341.167875-1-johannes.thumshirn@wdc.com> <20260415052203.GB26443@lst.de> <6cfca682-4f8b-49f9-ad16-21d90eb5f402@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cfca682-4f8b-49f9-ad16-21d90eb5f402@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 15, 2026 at 07:53:52AM +0200, Johannes Thumshirn wrote:
> On 4/15/26 7:22 AM, Christoph Hellwig wrote:
>> On Tue, Apr 14, 2026 at 04:33:41PM +0200, Johannes Thumshirn wrote:
>>> This test stresses garbage collection in zoned file systems by
>>> constantly overwriting the same file. It is inspired by a reproducer for
>>> a btrfs bugifx.
>> s/bugifx/bugfix/
> Fixed
>> I tried this on XFS, and it doesn't work as XFS uses SCRATCH_RTDEV for
>> zoned data.  Manually hacking in SCRATCH_RTDEV makes it work, but that
>> will break btrfs.  Maybe you can add a little:
>>
>> if [ -b "$SCRATCH_RTDEV" ];
>> 	zoned_dev=$SCRATCH_RTDEV
>> else
>> 	zoned_dev=$SCRATCH_DEV
>> endif
>>
>> end then use $zoned_dev to make it portable?
> Sure, can I still use _scratch_mkfs_sized for XFS?

Yes. It sizes both the main and RT device.
