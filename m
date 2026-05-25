Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0173B0AE7
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 07:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779692749; cv=none; b=uzzDE0/jGtAb6SpFtxWb6F3gg0KG1RztjLnAMJKVVOY7Rox9hWkWUfk6roLy+SS8wqGTyZxHNBPyRqbl+LwBCnglx9kXNlAtQTN2aCEus4uXZZEPiFjOT+91MTOv+jHWSiB0btWxxvc0EIIij6RiV45byCTSbWrLC3aKL8qD+f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779692749; c=relaxed/simple;
	bh=06qaBguhC+beb84OG4lcvrsxElviP4W5cQ2lyYrj+CI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GjXcnXBoBsv1t6pDv4sAjk9JpetgDaGHK89/AlM7CLqlfs1Fk1ZMYdN5dgCxAwZfl4rvmLdeCFiigdCAedkeeKVTnGKs21F4MnOJvJhjRijbvztnGIHxo1eaQbkugYIZ50LSJPngznNYnV6iMxoS2LKwmfZvTQ+8RpSdl3yyuag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PcYde8AB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PcYde8AB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HwDh2hckJj3RrsYndD3oPe6p9hhVhBIMNSFmkr2LZuk=; b=PcYde8ABQTzvIs3eFkrc1hb4It
	24ZQ6S3gOei37x50KilM4mcrEF6+NaVLPeWuZG1ZSwZ7tDHRVUagqyF3CRRfLPDzoVScMoKB4eiwV
	jKeyx3nqvr7Uj1ecwMgbY4wwQcZRwzr93+uBUQ3Ai2r9viXR/hWNiP67E/5VhrQkbJOK4hREqRaKf
	C8rhcShqTo2kA73JVnkIlP71Gd2L0jO84CUNx4BEehmNDY3YAqJrjP996sO1ImBtBpSLul4nAE35X
	I6rajB3sdL7wDUejulcUqqby7lhGDQ4eDEEpbgzmkNlwD4iuFY5h8mvmNqtCx/LnGinsKtWl9HgH4
	coCqTzOg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRPNh-0000000GUal-3T6B;
	Mon, 25 May 2026 07:05:45 +0000
Date: Mon, 25 May 2026 00:05:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: use IOMAP_DIO_BOUNCE flag instead of falling
 back to buffered IO
Message-ID: <ahP0yXND64FAOsCV@infradead.org>
References: <e578ff1a2dd9a4f720ea77bc601534734ce87e18.1779685479.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e578ff1a2dd9a4f720ea77bc601534734ce87e18.1779685479.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, May 25, 2026 at 02:35:33PM +0930, Qu Wenruo wrote:
> +	struct btrfs_inode *inode = BTRFS_I(file_inode(iocb->ki_filp));
>  	struct btrfs_dio_data data = { 0 };
> +	const u64 data_profile = btrfs_data_alloc_profile(inode->root->fs_info) &
> +				 BTRFS_BLOCK_GROUP_PROFILE_MASK;
> +	unsigned int dio_flags = IOMAP_DIO_PARTIAL | IOMAP_DIO_FSBLOCK_ALIGNED;
> +
> +	/*
> +	 * Userspace may modify the buffer while DIO is in flight. With
> +	 * data checksumming this would produce a checksum that doesn't
> +	 * match the persisted data; with duplicated profiles the mirrors
> +	 * would diverge. Bounce in those cases so writeback sees stable
> +	 * content.
> +	 */
> +	if (!(inode->flags & BTRFS_INODE_NODATASUM) ||
> +	    (data_profile != BTRFS_BLOCK_GROUP_RAID0 && data_profile != 0))

Should the 0 here be BTRFS_RAID_SINGLE for better documentation?

Also the old code only did this for !BTRFS_INODE_NODATASUM and not
raid, right?


> +		dio_flags |= IOMAP_DIO_BOUNCE;

Splitting the data_profile check into a helper would improve readabilty
here.  Maybe even as a prep patch before the actual change, then a
patch to add IOMAP_DIO_BOUNCE, and the extension to raid as another
stand-alone well documented patch?

Also while you touch this, you should probably also check the
bdev_stable_writes similar to XFS (probably yet another patch).

