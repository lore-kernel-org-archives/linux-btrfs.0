Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092A1489896;
	Thu, 27 Aug 2026 16:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787846965; cv=none; b=WvNLXbqhBfXzzGL441YXKNCAifiUHMLsBkYmudoj9RbRbCG/2COopTVlw2w+/SpQFb3SM74oP47P25xexj7QAhjOwMJsnahaNGR32GWkybowbSs6U9l/BDIQFWqpmXP95NGCD4zQtWJcCEbIApTbTSKko4cvh69h4xpSTKp4NnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787846965; c=relaxed/simple;
	bh=8bgJ74oIlGyB65X04m7Kj/pM+du+sZhf5F5o2t7/ois=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KmSwxyqd4+3B13VnqDpNR806dqQEn3jTEOYJmIkr9ZrQOrJftvjqAAraKpxm2m0WBvEOCItSj3ZaDhcSqMWrJUA3sMHHMXg1upZZXUola/RL9MpyB4W/XBJ47YfIkC/Pj+PNMlKMNERsEi+2sMc6lVin6rhY8+oU1Rgry0M7BHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dAQMoujw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dAQMoujw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF8C1F00A3A;
	Thu, 27 Aug 2026 16:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787846963;
	bh=mL2wUylsj/p3np1Pa0w2NUFvNycVzbZmuBWRd1F8Elw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dAQMoujwqqmowTn7BnpGsUErs1iEfVFFYvl1F8DsIdA8SEWSnQuplHERVim/AqMN5
	 J6tMsa2aNneJ4CTtdIvwQIvGXjUp89Ip7Sh4XteYGMByX9IE4pcjkk3MWRkPmn+9iF
	 YBvpegzqk6MDdnsZbVud9cRj22sqA8Ti3lWpab3JfXezGbUJw4krq2Lxr5KtT77EAX
	 Mgl36Ua2ycTmmFgqfiYABn/fT++Xt3WbIZFVeuDkQ3pWXYRN3BtdXCmOzp3te4C5Pq
	 m+1e/W7SP00G3b/LoWAQX4rIYRgofFxzi0SFyIO90xsb+u0fhrBK+ZFraSYGJyp+WQ
	 FLbQqZJK1TKLQ==
Date: Fri, 28 Aug 2026 00:09:16 +0800
From: Zorro Lang <zlang@kernel.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/5] fstests: misc fixes for zoned btrfs
Message-ID: <apBg3n-J7PP2nD0M@zlang-mailbox>
Mail-Followup-To: Johannes Thumshirn <johannes.thumshirn@wdc.com>, 
	Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20260819131606.1478488-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819131606.1478488-1-johannes.thumshirn@wdc.com>

On Wed, Aug 19, 2026 at 03:16:00PM +0200, Johannes Thumshirn wrote:
> Misc fixes for test failures (and a typo) when running fstests with
> zoned btrfs.
> 
> Changes to v1:
> - use _require_xfs_io_command "fpunc" 
> 
> Johannes Thumshirn (5):
>   common/btrfs: fix awk field separator in _check_temp_fsid
>   btrfs/199: skip on zoned devices
>   generic/746: skip on zoned btrfs
>   btrfs/284: skip on zoned devices
>   generic/781: fix copyright

Hi Johannes,

Except for [PATCH 3/5], which still has some open points to discuss, the other
4 patches have all been acked. Given that this is a misc fixes series, would
you prefer that I merge the 4 accepted patches first, or wait to take the whole
series together? Either way works for me.

Thanks,
Zorro

> 
>  common/btrfs      | 2 +-
>  tests/btrfs/199   | 1 +
>  tests/btrfs/284   | 1 +
>  tests/generic/746 | 1 +
>  tests/generic/781 | 2 +-
>  5 files changed, 5 insertions(+), 2 deletions(-)
> 
> -- 
> 2.55.0
> 
> 
