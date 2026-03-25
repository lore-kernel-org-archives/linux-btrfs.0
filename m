Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41F13112BA;
	Wed, 25 Mar 2026 05:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774417730; cv=none; b=b1n0HSIim2BD06Dm2kPRxF/mmp/axg/kutlQRSL+/87mSr2mKQhi4fjRZ7/UTkrzf1qPeNwL6yGw+cJbaJgphqyS+iDH0GVdtxh4kz2926ZutibgTGxXjHXQjmEE+UXXlYVBN4Pw2ShIQvo98uYMLvOesqbW1t+2ldGI/wmoOsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774417730; c=relaxed/simple;
	bh=uOt/NzW4Lw5hGqfn//3Dv44769lSHgkjQa95b4FncY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lKeBsIatNHQFPjYQh3Iw7rU7a0P6sQ06VxGHrkiKEUp8JkdRwWCrfX0n4dovODW+Ffb/eV5DPMUFMTn1kKQRl4RyDoLX1+15jLpM/sRh3Y0j+bUFA87saDbkHOps+60wIdV7eRqV1oeF3BV3d/3EQ6XfXI2E2etLtgyg5UvR7Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=prWIuupY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="prWIuupY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hF5YyQ1VKzdYQ8Lo2fkcNZNppKAqOTfn5yvFQfWCe+U=; b=prWIuupYyp65kZ3d7tL9hV2NZj
	SfcWIb7SzabfojA9qicmNhlni8ayRCLnYvNq/QH/B0tHfKsNKM7TmzsXgruVAHc8jCmoBK2vWQZnI
	Bb+GPuopq6WgjiyjH9F1+lZSQZt7Q6rsWWDgbTz/Z+7e4CzY+SGwd0piVYs+jnV+SlHfDir4p3p3q
	ytJchTPUBKYOQQHULkk7ue70/XZQsrBaxBfTKoC+OEMlI9eyjXUSQUuz6fwDc9WsOWjuPZjtPEZSj
	OG5LAhawcC0VDaNzIc2z0mIunl4zIkhzj9EEwdBnOhbdcrPyUExM3Z3d+cTwDXQ6wGSibegVROv4m
	4g1ZtE6w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5H6m-00000002jjV-0x3y;
	Wed, 25 Mar 2026 05:48:48 +0000
Date: Tue, 24 Mar 2026 22:48:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Leo Martins <loemra.dev@gmail.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
	fstests@vger.kernel.org
Subject: Re: [PATCH] generic/301: skip extent count check on btrfs
Message-ID: <acN3QEpx_YZZN5Qb@infradead.org>
References: <c56960b514baf810f2929b5e955a966d9955c468.1774383226.git.loemra.dev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c56960b514baf810f2929b5e955a966d9955c468.1774383226.git.loemra.dev@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 24, 2026 at 01:40:00PM -0700, Leo Martins wrote:
> +# btrfs CoW extent allocation depends on transaction commit frequency and
> +# metadata reservation behavior, so the 2/3 fragmentation threshold (designed
> +# for XFS cowextsize) is not applicable.

It really is a quality of implementation issue and not specifically
designed for XFS.  But I gues it is hard to force quality of
implementation on specific file systems.

> +if [ "$FSTYP" != "btrfs" ]; then
> +	test $new_extents -lt $((internal_blks * 2 / 3)) || echo "file2 badly fragmented"

Please break the echo into a separate line to keep this readable,
either by just breaking using \ or by turning this into a proper if
statement.

