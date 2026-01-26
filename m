Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9468D30E836
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Jan 2026 04:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769403199; cv=none; b=FungjxaYKAbpfdqH84bj0g/79xhGTLGMwXF9DmqsxO2vvaYzEXLmMphHz3MyauJKQH2lATKCOFNHNd46U7/DuZ5ZfXIav8meKTYKyeMjqJN+TgNsZAsESzEOFmZ5b4KjQE8JR3IuzXVZJzbtnVUEdha8zYthQtvDMZ0hM/YDLa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769403199; c=relaxed/simple;
	bh=hIM/fW/fDkb+AbvpBObafVmwzteEfGIY7KdWvV2Pvz0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=QZzv188FURCGd7R8DZ1jt+iZBBV/kgEMihxoALLuXozgs6Fa81SgKOhPwD2RzYuBh3EGUQcBfuPC9AY01jAlVGwzW3c+DnBnsXy7wDhVoOQzwzzef9J+QdIR5vaG/xngTkc6GS+ZaPrePozkuFYga/I8oZpncks+YeGyD+9W+JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 104F1227A88; Mon, 26 Jan 2026 05:53:16 +0100 (CET)
Date: Mon, 26 Jan 2026 05:53:15 +0100
From: Christoph Hellwig <hch@lst.de>
To: David Sterba <dsterba@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: memory leaks in btrfs raid code in 6.19-rc?
Message-ID: <20260126045315.GA31641@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)

When running xfstests on btrfs with a SCRATCH_DEV_POOL and kmemleak
enabled I see a lot of these kmemleak reports, start with btrfs/060,
but affecting basically all tests exercising the RAID code:

unreferenced object 0xffff888111f61890 (size 16):
  comm "fsstress", pid 5252, jiffies 4294898624
  hex dump (first 16 bytes):
    ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
  backtrace (crc d3088d4f):
    __kmalloc_noprof+0x3c8/0x510
    alloc_rbio.isra.0+0x127/0x390
    raid56_parity_write+0x2b/0x180
    btrfs_submit_bbio+0x26d/0x870
    submit_one_bio+0x7a/0xb0
    submit_extent_folio+0x163/0x320
    extent_writepage_io+0x2c9/0x4d0
    extent_write_cache_pages+0x396/0x9d0
    btrfs_writepages+0x70/0x120
    do_writepages+0xc8/0x160
    filemap_writeback+0xb3/0xe0
    btrfs_fdatawrite_range+0x22/0x60
    btrfs_wait_ordered_range+0x47/0x110
    btrfs_fallocate+0x193/0x11a0
    vfs_fallocate+0x160/0x3c0
    __x64_sys_fallocate+0x44/0xa0

