Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679763D1A8E
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 07:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779693822; cv=none; b=VtbSZQlE7l4q3wFNkmyYNljpsRcJ0qoH8CVe2RXO23A1ycnuD16F/P0yV+fsjZV9KWYKRe2b458yILL0itdU1/W2PC6oGZtVstCDdBv3Cirjs/OhOyLZRp9HpygGprZkxq3ehr7E6Q8J6+IQzeOFrnWsofU8KOpRMpwJpD4eRH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779693822; c=relaxed/simple;
	bh=mXZO2lyU2NVkPgt9LZbB4Er8pTyEjJHlqHc569hkbUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=olZtj4ZG8Lu7s8a5hW4l2FxaFDGtkOTm6xpfXKjbXbUN8x4tpFBfQjAg3PD1cypmFBdoAZAsXfHeP87ZYrtbCo4VcKJzIlL5UCcRDCCoYrZLUsPr/USIAqQbrnISGs5mlreiC3ccGgZemO6pC0H8jAByQmu6j7y35m2YKM6clX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jwf6//cN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jwf6//cN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=L4ET1aofQIpaT2VTOf0V51rkRNcc+6BYVcv4nOQ3e8A=; b=jwf6//cNUwIAyEFrDNuAen3lG2
	sr5Z0iYQ7I27ySKIeyhJrls3XgmxQ0gGuHB5uacyFVgc7/2sm2PS81EJTeuqpd8JWAyhgpYYYgbQh
	nax5tImA6lqRM6gM6ImBqRwP+88m3loeAzqeuNgTz6baoqS66kjdPl+Dsald20G/qKwxdI9WletyT
	o982y0erpTkfZgZIhurgOA1derRUFWn/KjdEh3R+iqZ9FUFTFPnKywSjDqyyEQlxmp9VlyznKYhCs
	0fa8gnZ2zZDBH+XnhdO55MG1FoV4DFMK1HpASZCG1c8EsUaR5GjCFPiiLPcZ+Xd+baWzc1qu0Ied5
	CJ1pINTA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRPf2-0000000GWO8-3nSo;
	Mon, 25 May 2026 07:23:40 +0000
Date: Mon, 25 May 2026 00:23:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: use IOMAP_DIO_BOUNCE flag instead of falling
 back to buffered IO
Message-ID: <ahP4_BV5QPphEPUC@infradead.org>
References: <e578ff1a2dd9a4f720ea77bc601534734ce87e18.1779685479.git.wqu@suse.com>
 <ahP0yXND64FAOsCV@infradead.org>
 <6ff25e6e-ee87-4708-8a86-e4d982edc2df@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ff25e6e-ee87-4708-8a86-e4d982edc2df@gmx.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, May 25, 2026 at 04:46:16PM +0930, Qu Wenruo wrote:
> > > +	if (!(inode->flags & BTRFS_INODE_NODATASUM) ||
> > > +	    (data_profile != BTRFS_BLOCK_GROUP_RAID0 && data_profile != 0))
> > 
> > Should the 0 here be BTRFS_RAID_SINGLE for better documentation?
> 
> That BTRFS_RAID_SINGLE is a special enum for iterating btrfs_raid_array[].
> 
> Meanwhile for bit flags we do not use that enum index, even if the values
> match.

Ok.

> > 
> > Also the old code only did this for !BTRFS_INODE_NODATASUM and not
> > raid, right?
> 
> The old code also does the fallback to buffered for raid too.
> 
> That's done in commit 7c2830f00c3e ("btrfs: fallback to buffered IO if the
> data profile has duplication").

Ah, right.

> > Also while you touch this, you should probably also check the
> > bdev_stable_writes similar to XFS (probably yet another patch).
> 
> For btrfs stable writes == data csum so far. But we do not have any bdev
> stable writes checks, thus it will be a pretty huge change if we want to
> take per-dev stable writes into consideration.

I tink you need to.  Various network storage protocols like iSCSI, NVMe
over fabrics or DRBD, as well as T10 data protection for SCSI and NVMe
require stable pages, so you have to take them into account.  My
approach would be to do it globally if any such device is part of the
pool.

