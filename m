Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D6C3783C7;
	Wed, 27 May 2026 06:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779863695; cv=none; b=KJ6Vzox7QimU09ydUzQIJIO0cIEDEbads0vs98kgAI9GudRwB0lva+ZnA3KfPTL7BjSLNGJSJecSADSZKkrmvzAbNcnCrIOiyMhDlfxeA+U3fYHUs4EsIlsRtlOC5b7vv3y3JzN+n1C5n3ux7nAQeS2JVZ5rUjkPE0qzO+Ke/Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779863695; c=relaxed/simple;
	bh=WphEaVz7GZD0H+XXP2EHbcv66PNVDnQ/1Z0RuRzWgdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m1C1XvhyR1bWcIGGVC4KHOs/MVOEzo1vBDyigYKLCgit9aOG46gd4Fmsd1mGo4ODgG+ZD0I4m4mzELnF3qqAVmETJLjJa+eztp99ZRh6isB+SEtXVL0tS1nX0raLbXDdGG65zUqvtvnfVBAZ0fgvdp6eU6Ae1JJmp2x9FzXV8wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sNbzPa8u; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sNbzPa8u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iQhgMUsnTkcdaUj9yNmctN24bRyQl11x8UI7zn48A+c=; b=sNbzPa8u5WmRf6H2RXDx957CUl
	jdnn/4UStwAeVVYKFzt7KohC0b3iFDmsuvvco9IYTCVqTIWL8CI0Re07VptWZhnt3stAgOzhMA4e8
	IdyoDoTkTa+yjh+dA7Tf20Qw72B/YbG+tINp9QPzuQQuSjThlZoqMnx3BSFnchJwk0AY/o+/yGOSK
	msckq1RvSUOf1ko6/UFqZXmVx8orkwOgWV3uMIZCqsCZ0pgDEcOLZM60xPdSDfjSSdvEkpft36ame
	wdFiBh77ENEmId1DY9Dv1rz0CVZ+8lhp+bjQdxCNRY9EGZN7gkGVvxVEcy4A8cjjP9aqqowVKoD3A
	mKSkoLmg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wS7qv-00000003PNv-40VV;
	Wed, 27 May 2026 06:34:53 +0000
Date: Tue, 26 May 2026 23:34:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: generic/362: remove the old file to reflect new
 mount options
Message-ID: <ahaQjYYQWcuOaRaq@infradead.org>
References: <20260526070055.60193-1-wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526070055.60193-1-wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, May 26, 2026 at 04:30:55PM +0930, Qu Wenruo wrote:
>       Silence is golden
>      ...
>      (Run 'diff -u /home/adam/xfstests/tests/generic/362.out /home/adam/xfstests/results//generic/362.out.bad'  to see the entire diff)
> 
> But if one has formated TEST_DEV, run test with default mount option,
> then change the mount option to "nodatasum", the test will not fail
> anymore:

> [FIX]
> Always delete the target file "$TEST_DIR/dio-append-buf-fault" before
> running dio-append-buf-fault command.
> 
> So that the new target file is always newly created and will follow
> btrfs' new mount option and expose the failure for nodatasum.

I'd rather add a copy of the test that runs on the scratch device
that can control the environment.  Or maybe just change the test
to use the scratch device?

