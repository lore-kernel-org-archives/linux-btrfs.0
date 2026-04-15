Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95893DC4C1
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 17:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776275998; cv=none; b=DuauEGA7dpdd6DKMol1YCaLiYB92XvokhNwvUVi9KpjboG3TqyVeNi+reV9o3GKg3q7h7obm0FD5Y1ZJl/b+wcZSq/7A/ivHKKFpJyKE2BfGjNA2mK3ANLP/7tDi9PZp/yWRwBKcuG6sk9Q1Gc4wVntYdZVn1/oyTvFKAapPjLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776275998; c=relaxed/simple;
	bh=LZnPV/Ua2y/C6pD4sRSyQRJPNdCCdp3MkpTCrManBV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t59i7KhnRIk7la6f0s6uz9kn7m0HKLfg3VkcmDbovUEKOtTd+8GPmptU3CrnXoiijJhFZ/DiFYNnT15Rmo2VY3E0EXqaGwqIP9gUSjx99LJwWGcuS1WzZA1xofePB9KJ/t9xqc1rpIbM/yW2NhlXuUa5WPoCPFTVCp5x0iGwBtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=Kgwr5plX; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="Kgwr5plX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hoI0jMzGGIDzL821geWSVUEXbAnvhNlijuUUnYQHSYo=; b=Kgwr5plXkn1ErowvNaYPpdvQ34
	2+2LCGrjDbl4DXw8OlbruXWXOsqY91WC4Ze95nPGg7YP5Rf0OPmelvS2iXUOyywCoEuc5iRJWgMmv
	I0wjX0W8HT9p/8Dte6K+6p+tbUxR7fQoXjQWt9UFY6u7jTyJLb7inzSwUiCYsFG5rI6ghZ2rbSIbm
	2+Taef63wcC+u/Y6jW9JIjHYkSa7AnOgHP5/ticVzTpUozgDke/a8wa6yRB/q0ep8hw44HYfSXyha
	XC90h2Whx0h2pT+qp28ecF0Ak2omTT/Qq/03kxT3QCREAcO2Wus7uhQd1/mePQfXas+ZnGwhbfCcE
	Ebi2+N9A==;
Received: from [24.6.49.44] (port=36442 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wD4Wf-00000007Grm-3mAY by authid <merlins.org> with srv_auth_plain;
	Wed, 15 Apr 2026 10:59:45 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc_btrfs@merlins.org>)
	id 1wD4We-007X9u-1H;
	Wed, 15 Apr 2026 10:59:44 -0700
Date: Wed, 15 Apr 2026 10:59:44 -0700
From: Marc MERLIN <marc_btrfs@merlins.org>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, QuWenruo <wqu@suse.com>,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	Filipe Manana <fdmanana@kernel.org>,
	Chris Murphy <lists@colorremedies.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	Roman Mamedov <rm@romanrm.net>, Su Yue <suy.fnst@cn.fujitsu.com>
Subject: Re: Simple quota unsafe? RIP:
 0010:__btrfs_free_extent.isra.0+0xc41/0x1020 [btrfs] /
 do_free_extent_accounting:2999: errno=-2 No such entry
Message-ID: <ad_SEOvBQtzsxWkY@merlins.org>
References: <adnBhWfJQ1n3hZC8@merlins.org>
 <ad0tdWyavEngGlQ-@merlins.org>
 <20260413184731.GA3448810@zen.localdomain>
 <ad1GxXgWNBfgrRtN@merlins.org>
 <ad8gcwTFOLUhBHGA@merlins.org>
 <20260415170510.GA780391@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415170510.GA780391@zen.localdomain>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc_btrfs@merlins.org

On Wed, Apr 15, 2026 at 10:05:10AM -0700, Boris Burkov wrote:
> 1258303029248 is the logical address we were freeing so its backrefs in
> the extent tree will be interesting. As will whatever subvol tree it is
> in, as will the qgroup tree entry for that subvolid. If you can share a
> full dump then I can find all that myself.
 
Note that I fixed the laptop, thankfully didn't have to rebuild this
filesystem.  

Sorry, not very good with the debug tools. Was that the right command?
merlin:/mnt/btrfs_pool3# btrfs inspect-internal dump-tree -t 1258303029248 /dev/mapper/pool3
btrfs-progs v6.14
total bytes 4074040004608
bytes used 2415294197760
uuid 49741c78-3949-4d7d-b77a-160ce071dee0
merlin:/mnt/btrfs_pool3#


> ditto for the logical address that broke on the rpi, but if that is a
> gigantic fs, maybe doing the dump will be pretty unwieldy..

That's the bigger one indeed, still waiting read only until I'm told I
can wipe it, or should wait for debug data request. It's been too long
already and I had spare drives, so I started a full restore on a new
set of drives and will swap them in for the current one I can't mount
read/write but can keep it around for debugging / potential future 
check --repair patch

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
