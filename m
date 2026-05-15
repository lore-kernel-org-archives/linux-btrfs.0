Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C734644CAEC
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 11:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778844874; cv=none; b=BZt/eNoB2Hmo3ainsFx1Ei/Gjf+75uJF7j8+t2ZdyptOdxhKVkgwlZhOiim/mvvz0cHyPXdlFs++3zcOp8ThBSG3pecbSnlCP+5I5MxDR6n9dBLOp928lzqSXQmF+kdHLw1mjK7GN7v6kwdk0lKHfgb7hefdDIHxzZfWpxMQLlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778844874; c=relaxed/simple;
	bh=I5G3zdIBFyeQGn7+L+rz2ymF9ILRY00tTJ2zWfKvFPo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=izkYXz5ghBM79ZnPmn/pZmZ+iEzVaWZjF9nVTPbo0GH9PGl7yMuK9u1NUORoAxM9XwCxeVzWV5YUrQNZmsHJZYhLGkNGdtzwGxGQqUjWkT6v2N1FzFtHNQyzPv/lhJGCnuN8ZtGw4hP7Mhq4kqckgHtTAn0M1MUqaG7taLhR6Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 600A368B05; Fri, 15 May 2026 13:34:30 +0200 (CEST)
Date: Fri, 15 May 2026 13:34:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>, Boris Burkov <boris@bur.io>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH 5/7] btrfs: zoned: subtract zone_unusable space in
 statfs
Message-ID: <20260515113430.GA25099@lst.de>
References: <20260513123445.43197-1-johannes.thumshirn@wdc.com> <20260513123445.43197-6-johannes.thumshirn@wdc.com> <20260515043921.GB3936@lst.de> <bc97d41f-55e2-44ed-a500-e74f8f25f006@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bc97d41f-55e2-44ed-a500-e74f8f25f006@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, May 15, 2026 at 11:26:22AM +0200, Johannes Thumshirn wrote:
> On 5/15/26 6:39 AM, Christoph Hellwig wrote:
>> On Wed, May 13, 2026 at 02:34:43PM +0200, Johannes Thumshirn wrote:
>>> On zoned filesystems, space in block groups that has been freed but not
>>> yet reset is tracked in bytes_zone_unusable. This space cannot be used for
>>> new allocations until zone reclaim resets the zones, but it was being
>>> reported as available space in statfs.
>>>
>>> This caused statfs to over-report free space, leading to ENOSPC errors
>>> when applications tried to allocate based on the reported free space.
>>>
>>> Fix this by subtracting bytes_zone_unusable from total_free_data in the
>>> statfs calculation for zoned filesystems.
>> This OTOH sounds very wrong.  Freed but not reclaimed space is usable,
>> it just needs work.
>>
> man statfs says:
>
>                fsblkcnt_t f_bavail;  /* Free blocks available to
>                                         unprivileged user */
>
> which in my interpretation would include zone_unusable_bytes, as they're 
> not "free blocks available". Or would that be accounted as f_bfree?

The only different between f_bavail and f_bfree is reservations for
the superuser, which IIRC only extN do on Linux.

f_bavail is all the space you as a user could potentially use on
the file system (modulo quota restrictions).
