Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B123A14BF92;
	Mon, 23 Feb 2026 13:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771851854; cv=none; b=uGpLoRyd8nm7OBKe6WRko/iZg+df7fAElDDnEWtPEBOhLl4qOtlCNd1I2bywu1jedT7ITVfTGMtHr2nJgnjGZ5MF5Hd7wyzN+FvvB9rGOfFDplvdTLXGjWUJ6Fms1mL9Hkayhir8kEAHPMstpE7iAYid+IlEPVWglh8qswdulNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771851854; c=relaxed/simple;
	bh=GBHBY7axj6y7f/B+WQZYMA1YKSnE7dTsMApGKvkM94Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t36eUjibgc+7IBSeKaavIN9vpL63yzMOLojilDBZndV1rF/GhWESjnu00uHqHcgMcpu6WF1q0nf/XdK9WzRIG2cszbeVBnqUJzc+2PuMEKH6sIFG3XAhqJNdnEMz+PCVzVFPaNM9PFiFKc39njcZQNCqMuNK1iAjHJbnTKsO8N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DDk84mjm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DDk84mjm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LeDA6odOI+QbSBHQLkGzaGqgIKIgnmp6jDfA1O/cNvI=; b=DDk84mjm2l/p21tV3S2ykdobKh
	rrFhvOrBUbFzZE3/jIgPK2yAVCa9p4GenCdEQlA6BJzn6g4ZNWqtT1dUEfe/A10DkzleJN1DR4FHY
	9KdBiwlNSXBUSkFyAo9QMzo+tpk1LpLK5FhBfmTvAimUuuZcARm/vqg090YnAE5X9mST+uiTYd0OU
	0IE4pgy3KwuRhC+3RZ4EJfNS1ZPwFwMUhfp+L/XphZSFHeRmN2USFHngeRdmOg8xu1RbyvAu9qhHB
	Pyry18U7D630BMC664r3G7Rn6kHYzhbukwYA1pOhZSTotO4/09jFdNcdNsFb4WiaTa6MShzAhnCHd
	DNtFywdA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuVbW-00000000KMi-3yF1;
	Mon, 23 Feb 2026 13:04:02 +0000
Date: Mon, 23 Feb 2026 05:04:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v6.12] btrfs: always fallback to buffered write if the
 inode requires checksum
Message-ID: <aZxQQhK7H04yQgD0@infradead.org>
References: <8419975b6281ce4d112a3a5006c8ca3bc489a41b.1771832083.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8419975b6281ce4d112a3a5006c8ca3bc489a41b.1771832083.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This looks good for stable.  For 7.0 and later I'd recommand to
switch to IOMAP_BOUNCE to properly support aio, though.

(sorry for sending you down the wrong direction a few month ago,
I though buffered fallback would be good enough)

