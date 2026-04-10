Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA1638E5C7;
	Fri, 10 Apr 2026 07:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775804893; cv=none; b=Sqd+Iaxd0vi2bzCpVHkeJ8bzgZGbHYEutsQKBkg0jk+p12wj5V7o6PaUi6w6nC6BjZe89tGN0fRUVgZnpCUgNNbsUInCODcxvWIoxtlVkhXOahuLdZhCLdoki7BfC1XPpn34odL5ngJIkihx437D4j9JIdeJTrDhhUdJ4lDMn1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775804893; c=relaxed/simple;
	bh=dLrnTN7l85A4M/+nuDYynQvuWGIh0VWPyahjcmdC4Yk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FQYb21TolBbXCEhimS/IfOI5dndOfDWAXxVFipXeznqpFQ+VjhShmoARvIdaNJ71yKqUmIKnzZ35fZa4emr5osKkcncloMFX4EkrC+jor6fqwQh4xh0T/4aG6z6/3N1eltOQlDbA59exoRj07Zl7IS9vuyHsTGyD1qwxBDxwoBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FtuugAuG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FtuugAuG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xPaxU+hWT0ZEvzMf51KWwAKk8kmuCkfO6rPBhH2/bDM=; b=FtuugAuGyqZC2jQrdNhDVwzxpi
	dJ5SExKEL6oOf5ZM/vBhsqAs4X7id6OJQfzGpjXAOPfUG3QNrMgVymo5yGk+Pteme3HlMErSpyosH
	EYzkJi5uupoAJz/H3OiU8lG6oeGCbtitZfMu2UMnGRwKRIFdFU+tCrDVeFYpYQx431oTr73xMcUhn
	yCpRhmC5cUA6nj7lI8wTfCMseD+k5gFAUKi8XRlqnaf3H7ITogD84t5f/p1vk6nUBf8YGj2bMnUnL
	svhucEGk643fE6RXT/3XYZy+TDvUzrnKJD8r4qMP92fSKa+h5rnUf/Pbx0FX9yJkjzeTfF+xJ7WWT
	wc/pBhSg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wB5yM-0000000Bi7B-1NBq;
	Fri, 10 Apr 2026 07:08:10 +0000
Date: Fri, 10 Apr 2026 00:08:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Boris Burkov <boris@bur.io>
Cc: linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
	linux-mm@kvack.org, linux-btrfs@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Direct Reclaim and Filesystems
Message-ID: <adih2i15lagPQmGc@infradead.org>
References: <20260409210906.GA881465@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409210906.GA881465@zen.localdomain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Apr 09, 2026 at 02:09:06PM -0700, Boris Burkov wrote:
> - Reclaim freeing metadata and/or forcing metadata writeback [1][3][4]
> In btrfs, this results in redundant work fetching and writing btree nodes if
> it happens to hot nodes in the btree. Should we be trying to lock some of
> these nodes down from reclaim? If so, how many is appropriate/safe?

The solution to that is object based reclaim as in the xfs buffer
cache.  That way you can set priorities on the nodes to keep them on
the LRU, or even pin things down much more easily.

When we last discussed this Josef didn't think it would work for btrfs
due to the amount of metadata, but I don't think that is a valid
argument.

