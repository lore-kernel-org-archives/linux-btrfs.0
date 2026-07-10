Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A508535E95C
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Jul 2026 04:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783656666; cv=none; b=qRbARWVcEVGqkXjetW6W0jjvhufXG9jnhpCSsCE4Xj3g8+8ev8I6qyKgyCJcXkhvBcy82b93A3Nz5ML0QFCHjvcOOLKz1FdJtRWF2o/E2nuZ5TUN3aHDMOPz1K9hq8hnqethYhlfz5kLHXkYS/7VBmJEDtQ+7kwUnqjUla8xXQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783656666; c=relaxed/simple;
	bh=nwKFwB0asGgm3VmcZxfazNiodnraSoBm+HWP3s/QIlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HSZ+VdTVQKNQriblQJCXyvlZ/OKncjZrRlLjjAg38stMfNuuxjyk1UoKcX1s6vlZZyeEfkKI/iDz4wWUTOPlZ2RuvxijcyyWrhpnPfIgLMhJY668WfXGiJDqskm/zrKorhj74YLeFoG5KWiduIcSO2vPs7dGquHdDnuCbwboaNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0TINad1E; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0TINad1E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=amPLM5FpFiz7aMS7A4gL1n/8n0Lf1ApJFEfhHwuXOgo=; b=0TINad1Es+tlE5U4onENL5V238
	mquI8ynKCXsRCxxhsDfjCtfxzxttEbZ/lqM1sWVN4hc21we/+I6V4IqHozSCo3dlFp5cWP2gNzYGc
	JbfNqaVG/keBfyZ6+RR99Ptj198tvo6D4THZUSns7wn2llsboKQHFPgYd1yJnQMv8rUCFhvFFy0JB
	VOtBTnsijmSny9nHOm2nL+DTibOQaGvHexcSudZdoBaVRWyjNGVDhoMryrDtGNYKETcjrpFElg7cV
	usL1c2nx+jWs3eW1ykl1XaXX0o3IuAOFSVmp5PH3Nx6EPhehHFASuqE+Ou1niEa6MVXjFRuVQRMwn
	PhcdI1QQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wi2Zo-00000004511-0Gmp;
	Fri, 10 Jul 2026 04:11:00 +0000
Date: Thu, 9 Jul 2026 21:11:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
	kernel-team@fb.com, willy@infradead.org
Subject: Re: [PATCH] btrfs: write-protect folios during data writeback
Message-ID: <alBw1EEcqAVuD8zo@infradead.org>
References: <856f2a691977072386085d768b7929520e1022af.1783570200.git.boris@bur.io>
 <27264cb6-3172-4cb5-819a-705a3d607cb9@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27264cb6-3172-4cb5-819a-705a3d607cb9@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jul 09, 2026 at 03:08:49PM +0930, Qu Wenruo wrote:
> Just to mention, we can workaround the problem, by extracting the real work
> of btrfs_invalidate_folio() into a helper, with a bool parameter to indicate
> if we're called from the writeback path.
> 
> Then we would have a better chance to rever to folio_clear_dirty_for_io(),
> but there could be other things involved.
> So I'm totally fine with the current hot fix, but eventually we will still
> revert back to folio_clear_dirty_for_io(), to align the code to iomap.

This has nothing to do with iomap.  Normally the dirty clearing is done
by the generic code in mm/page-writeback.c.  Gettind btrfs to use that
instead of the horribly outdated forked version would be a really good
thing.

