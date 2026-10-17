Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBB846E01D;
	Sat, 17 Oct 2026 12:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792240861; cv=none; b=udZgNqzqhW3x355qbmGBehk2SF3T9uXG/CsGCEVKsmoydhhprqFUbYUxc/Tcr2PIn+FWAqlNpp2GAtoy/L4EcnnHvKh4xjojfvMsifhvz87nqg3GUqOgLUDptCCFmIUcq+XfCRyPk3U/+oMQfMkFm0Qmx1bFclyWHBBgn0BZ8qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792240861; c=relaxed/simple;
	bh=Cg9IYqJk4oMdfuXSSC5tCgnwlKj+cWInwkqJrmzWr5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c1pp/ZSyzDgV0RY754AR3uu8gPBFjvDSQL5Z17e5Q5uKzrxltRaG0biQ9s6PPTMbD1In09Ek/ePrDH3D190OjXzo8GwUOSEq6VEOvS7pKNB+85ztk6ukRgDk72LMA+DGUgZkDb0PQqvclWPRmh9s/do3l8okHN0zh6DKcakHBkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eLuxqXUz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eLuxqXUz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F651F000C4;
	Sat, 17 Oct 2026 12:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792240859;
	bh=/BAUFNpTkAsmQWY4V6zUyrZGpE1islACSrBj7eTHwd0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eLuxqXUzc8KxZmupoGrLhaQQguN73N4IpB+T/ru2pAg88ogZ4vUPGaAOihpq//uqC
	 4vYzRnQvtG9FqfR37RY61XWrNmv/WqbRiDW81ayUPx0vKgywJG5eKr9EeFYd4XPW6v
	 euKcReHe2p6qGiyimR6gUQvA98b0dqUD8Pv9jxyU+DOa/fxiuSU99RXIIxO7J325fN
	 Bu0r4aflIH8vkFWhUFnvXVTMr0h+L659/DJs67+2OFFYlbjIb7NlQ/sMnFqDOhzB7O
	 fwJbOfinGOGNveBwUANMc8YJICo0jBYJdk3t45FEOHp+AXy1EiQ7I1k+j6YNhQS3/k
	 k6A183P+oNLuw==
Date: Sat, 17 Oct 2026 05:40:54 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v4] fstests: generic: add a test case to check fsverity
 reads
Message-ID: <20261017124054.GA3127@quark>
References: <20261017090341.72079-1-wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261017090341.72079-1-wqu@suse.com>

On Sat, Oct 17, 2026 at 07:33:41PM +1030, Qu Wenruo wrote:
> There is a bug report that with the recently enabled large folios
> support, fsverity enabled files on btrfs can trigger reproducible
> warnings about file corruption, but in the end no error is returned to
> user space.
> 
> It turns out to be a bug in the btrfs fsverity integration, where blocks
> not included in the read range are passed to be verified.
> 
> This is a long-standing bug where btrfs fsverity always assumed that one
> folio contains exactly one fs block, ignoring the fact that btrfs had
> block size < page size support before fsverity support was added.
> 
> Add a new regression test case for it. The workload is pretty simple:
> 
> - Create a 32M file
> 
> - Punch a 64K hole for every 128K
>   This will limit the read bio size to 64K, which is smaller than
>   a lot of large folios, and thus can trigger the btrfs bug.
> 
> - Enable fsverity digest and drop page cache
> 
> - Read that file and verify its content
> 
> - Verify there is no "FILE CORRUPTED!" warning
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
