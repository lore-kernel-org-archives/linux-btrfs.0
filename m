Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC41F3161AB
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 20:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776284567; cv=none; b=P/QkBvcj94wm4Uhn6RAVILyEIMIcURbEX2vp7cBbEX0+pXeCrbp6GsjKx6FR9enf15xdC+eqkl2MxSNwpppmIjZLIKAtjxEYI9QsIb6CtSHuuhXceABcEDH9eXyFvVaEVqh7gVr3tkm2VT/DEK4NWUVT73mHkY48f9SlqBpVKhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776284567; c=relaxed/simple;
	bh=k3Fqg7E9j5VubwFbCFK02/HEumCFJhhoZLd6tOFxi/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ro2ADZWpPH1NVX88f+Er5d8t0OC8rZK2HDkUBJ+ZTi/4zXXQOCM4q4UhULjGtrk77v/JAXvo5q0z6zAQgX38NZHK2be1nZ1oeEkqGjdmMSg9vi3nyde2YyqRTHF9t66NpDxAFmsixDp4IevBwCxxUCjnydH/hmWS1o83F5gcRQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=ldGTImWq; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="ldGTImWq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MFvhhPcdlsgbpchiUbVc+tpWXD7fV0c5T6AhM4ysnj8=; b=ldGTImWqleqQ07Bf3B3z0LZZla
	HUDihtRnlMkyohRJaEFv9w2CV+b/HqytPQLSkeiUBEl9e4CF9DliNQ0p9IWz4kVgFul7HGCcNN2iT
	7rMdVsqZU39BgtSUWpxFhHbmIISOnGAQlo/pDLKmpgyeREwAWQXI2wZz9vo+JiIcxjNRWFJmjzaqY
	dG9yTyxOglQY5TMBfr1yfJ+GVon/LxkSRs0i5CCUazCDAsZB+3s0atD0kCLDYJmQQ0byAweXz7czd
	epYEQdi4XcxiqpqzK4kV1HgJkuP0EOULPKhNbxuXc+7AEzA50E3ED4G4Z+y2UHYGXrq6eNPH7McV3
	yH+tK6IA==;
Received: from [24.6.49.44] (port=38738 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wD6l2-00000007q5j-0dzu by authid <merlins.org> with srv_auth_plain;
	Wed, 15 Apr 2026 13:22:44 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc_btrfs@merlins.org>)
	id 1wD6l0-007gCR-1o;
	Wed, 15 Apr 2026 13:22:42 -0700
Date: Wed, 15 Apr 2026 13:22:42 -0700
From: Marc MERLIN <marc_btrfs@merlins.org>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, QuWenruo <wqu@suse.com>,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	Filipe Manana <fdmanana@kernel.org>,
	Chris Murphy <lists@colorremedies.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	Roman Mamedov <rm@romanrm.net>
Subject: Re: Simple quota unsafe? RIP:
 0010:__btrfs_free_extent.isra.0+0xc41/0x1020 [btrfs] /
 do_free_extent_accounting:2999: errno=-2 No such entry
Message-ID: <ad_zkh47QZZnns7x@merlins.org>
References: <adnBhWfJQ1n3hZC8@merlins.org>
 <ad0tdWyavEngGlQ-@merlins.org>
 <20260413184731.GA3448810@zen.localdomain>
 <ad1GxXgWNBfgrRtN@merlins.org>
 <ad8gcwTFOLUhBHGA@merlins.org>
 <20260415170510.GA780391@zen.localdomain>
 <ad_SEOvBQtzsxWkY@merlins.org>
 <20260415184427.GA842130@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415184427.GA842130@zen.localdomain>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc_btrfs@merlins.org

On Wed, Apr 15, 2026 at 11:44:27AM -0700, Boris Burkov wrote:
> For a giant fs where we don't want to dump all the metadata or it would
> be difficult to share the resulting gigabytes of text, I would still get
> quite a bit of benefit from:
> 
> btrfs inspect-internal dump-tree -t 2 /dev/tst/lol

1.2G    /tmp/tree2.txt
65M     /tmp/tree2.txt.xz
do you want it?
> and
> btrfs inspect-internal dump-tree -t 8 /dev/tst/lol

btrfs-progs v6.14
total bytes 4074040004608
bytes used 2417457491968
uuid 49741c78-3949-4d7d-b77a-160ce071dee0
merlin:/mnt/btrfs_pool3# 

> that is relatively less important. If the extent tree dumps way too
> much, then doing a grep -C 50 for 15506102321152 would likely be enough
> to show us the relevant backrefs.

No match:
merlin:/mnt/btrfs_pool3# btrfs inspect-internal dump-tree -t 2 /dev/mapper/pool3 | grep -50 15506102321152
merlin:/mnt/btrfs_pool3#

Anything else I can do?

> If there is no rush to wipe it, then let's keep it around until I rule
> out whether a repair patch makes sense? Sorry if I misunderstood the
> state. If there *is* a rush to wipe it, then let's confirm we got what
> we needed out of tree dumping first, if possible.

At this point, I can wait.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
