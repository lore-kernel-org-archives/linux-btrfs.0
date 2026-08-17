Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3974B04AF;
	Mon, 17 Aug 2026 03:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786935926; cv=none; b=FWWjMzSfCNFY4OPd1Y2biYgGezUQX/ohQgCS39sVmzGBcZM31MO/khII6d/dpjerE3a9+i6VAkxOAg6/vFajEjHgigfWbRuvnX3WOfApVZPahovFCVKJiSZvn0V/nVRMRWD4OkndN3+ZkPl4zxKU/CwpYpY9UJ6/pTPZPswX0IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786935926; c=relaxed/simple;
	bh=B2i0i2kY35fDnkukfZ7YJJNT6eWGXjlCDfv300GX7pE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p+JLx9Z0zLT56/6K/lUsHF3GARXByWL7w7Tsm4VoMYLiVCQtNh+cuQHiEvHjxZJksH7pFTrjEH6FM2wr5ZtsmSA149XFBOT8a2r+5f2q0CSqJ5/AJMukFbSEEMGlinQrvjojvQ8AkuRBBCiKh90kuwaHwHCAqqSdwoC26C/OdTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=U079tmqn; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U079tmqn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5kRJylOPT7YVJEMBQni98bXxesU6u4TbhPVpNSajSCk=; b=U079tmqnQL3MTSvhYGYidir+IL
	UO9bgxb9jf1F1ywwwhy5DMpYocvshQ5Qt/eU23edpzK2fcqdjEBUtalx90eJIUxuo9l2TzBD8ZrKw
	OfaRL+RMg49j+EVvgk1e0wbbEj0hsKuPUiymswWo3kPhaOCjPxojfYvjzvwTxbDoKiZD8KtkEHzbG
	86tZ7qc6BvglV6MssRQ+EAho6MsGlkfRPJmcgG56UiKWRK3yYXH0R3MqW9XI6MiEBHiPqDalOOEHD
	E3JQ33YUk8/CyzABcYebQ1ziGfa8SQZlnVemH7S1rFSA4W4ZvF8JjWYMByGkVJfm+3i9D68e1fkDx
	dVOHq04A==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wvnev-00000009Otc-0o2o;
	Mon, 17 Aug 2026 03:05:09 +0000
Date: Mon, 17 Aug 2026 04:05:08 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] btrfs: retry verity reads for not-uptodate Merkle
 folios
Message-ID: <aoJ6ZP-jKQoWwuXT@casper.infradead.org>
References: <20260722025435.1493093-1-chenyichong@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722025435.1493093-1-chenyichong@uniontech.com>

On Wed, Jul 22, 2026 at 10:54:35AM +0800, Yichong Chen wrote:
> btrfs_read_merkle_tree_page() can find a folio in the mapping that is not
> uptodate.  After taking the folio lock, the current code treats that state
> as a read error and returns -EIO.
> 
> That can make a previous transient read failure sticky.  If the failed read
> left a not-uptodate folio in the mapping, later callers find that folio and
> fail instead of retrying the read.
> 
> Keep the existing page-cache insertion and locking order, but retry the
> Merkle item read when a not-uptodate folio is found in the mapping.  Also
> unlock the folio when read_key_bytes() fails so that a later caller can
> lock it and retry the read.
> 
> Fixes: 06ed09351b67 ("btrfs: convert btrfs_read_merkle_tree_page() to use a folio")

I object to this Fixes line.  I didn't introduce this problem; it was
already there before 06ed09351b67.
