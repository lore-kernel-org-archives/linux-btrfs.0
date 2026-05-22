Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7C222A7F0
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 18:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779473665; cv=none; b=HSAYOYAW25gIkE4VEllbhBi9C5KAwYQTqqZ6iHMaWmMOKUx4tiIvIRN8gmHOuiqlXgwLerlPBMiPe0+u0sh5LFaT/qmZUVDoEOq0CuiazsLFu2p+5HYGaw72T4sK7ziFJh77JH7WIAtpLcvItAlsCivfOxWo8XIOdin/ovffThQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779473665; c=relaxed/simple;
	bh=syqMWzMst2L7FzXMkVTYnbp4NGbeOIl+OMJD6u17UY0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VSTim7VcaQs/O83h59fwhv9TZ5bMv56sHUQg4Y0TCzzDp9WuG5TSzSGYGw/sO0MpAFevbEtk9nujp9XHp2CjzYJT9LthyQKE9YZlycR5AQZoL/sjRJ6EJYub1f7OEFnRLilwQDCKjnICr3p5lNBDFX5gHwlX9n7vaFbaryvzD8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JDlDNbco; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JDlDNbco"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=AyE3GyzPVckepRCPVut48rbgTCT+HzXatkoZDluvEBE=; b=JDlDNbcoCSLxS78V7HKnCFCKKj
	bfRy4xqQej9M4hlClksavkvwqMxxvpuDUczMdgagbgYr3Tip6E1w7b215bxRJN8HnY8XNBtUqKfVv
	eM+DXvFZjFUFYmW3LcikZTD/qDn7Bi1jePxkTmDr9nTVbHpgBkcFdArOXIQSMNlylGmqUFseRYNFR
	PeUhqJpnp7sw4Br3Dzq2XJQIDF6ZG7+WIbOy4BYVztW5YJY/GiPmN5IN8ugPCxHJKukq/cjNwkpbZ
	6rFVc7FXZGnjQias3tEPAhaUuajvNUKQSl4bHyiSqO+HTpOGXOHXQPURxyOOLb8qVUtauackeeztW
	Ma29WlHQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQUNw-0000000ARAv-3Rb9;
	Fri, 22 May 2026 18:14:12 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Chris Mason <clm@fb.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 0/3] Three folio-related btrfs fixes
Date: Fri, 22 May 2026 19:14:06 +0100
Message-ID: <20260522181411.2487732-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All of these were discovered through auditing the (mis)uses of the folio
API throughout the kernel; I haven't been specifically reviewing btrfs,
nor testing.

Matthew Wilcox (Oracle) (3):
  Revert "btrfs: fix the file offset calculation inside
    btrfs_decompress_buf2page()"
  btrfs: Use folio_put()
  btrfs: Remove use of bv_page

 fs/btrfs/compression.c | 18 +-----------------
 fs/btrfs/extent_io.c   |  6 +++---
 fs/btrfs/inode.c       |  2 +-
 3 files changed, 5 insertions(+), 21 deletions(-)

-- 
2.47.3

