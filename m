Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475B540DFB4
	for <linux-btrfs@vger.kernel.org>; Sat, 18 Apr 2026 00:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776471497; cv=none; b=Kc8EHuspev0CdVSJntA+1P0up8gwbgAHC6M3S2eyxpFtrThMLcaIYl8yp9dE0YxWiqiXSXN4D8fAh2d7TbcpX1oIIsjWCSPFlpPo9gnONICLet5hxu+J359Nxges3nWaXxqwqmI7oHhBu8lba52eQ7eNXL0eUdMuEnrDj9WvjSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776471497; c=relaxed/simple;
	bh=3OO1hg+w/oM2fbUYgKQXfR+W4XjctgHDJHqjhsTecP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PZQS1rXfSGBF6lP57bcZMmEFydMaMv+tiCyOt+FYkFwFOv+QvLAyP1fu7Wt8tnmnV/xqIcxoVLtozM6Y17R/BHc6B9DOuioLCNvDE9T09J7RL23sIbQ56En6gYZfNUBlgJOthXj93QXHh0H2libS61hJORmqYkgSaIk25yCbb1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=ag/F2jJI; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="ag/F2jJI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BXYlollBxdwv308h1lEDlWuxiJlb8HXcLsQ1TdZc6lo=; b=ag/F2jJI4/S97OPnA6cP4r8Cpk
	cvuEXrmvXF56/wcrS8iRpev1l+NyWbnDmN3+wmcyfcshbD4DPjL1McLFwlvBJjnryF+pNiiB/LFZz
	D6+VERTC2fOCvTxBWUkcxtIcGIajAu6/HBMBsivdTB3uGzFmKc1zbk7sdrPP69iGAFfGzIlZsyVOg
	y8xQh32qnkz08sChiLE6ebCEWUFSZo3sgQKCBzEvQ0L9F9g2glNAy5FK4LOvUm+aXTN4VpqhvKRF8
	bDChiKCk9e1S0kjy7xcgk7bqs2VS1pPk+kmPSan9UZEtbOYcomOy0bR04CFZXHHm+5r3zTQbGGQts
	vKwRF04g==;
Received: from [24.6.49.44] (port=49498 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wDtO3-00000002NQp-3cBR by authid <merlins.org> with srv_auth_plain;
	Fri, 17 Apr 2026 17:18:15 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc_btrfs@merlins.org>)
	id 1wDtO2-003k3U-1R;
	Fri, 17 Apr 2026 17:18:14 -0700
Date: Fri, 17 Apr 2026 17:18:14 -0700
From: Marc MERLIN <marc_btrfs@merlins.org>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Simple quota unsafe? RIP:
 0010:__btrfs_free_extent.isra.0+0xc41/0x1020 [btrfs] /
 do_free_extent_accounting:2999: errno=-2 No such entry
Message-ID: <aeLNxjmUGGhnW5ss@merlins.org>
References: <aeAXawJ9F9K28shr@merlins.org>
 <20260416004552.GA1045221@zen.localdomain>
 <aeA2c8V4FgCctUPG@merlins.org>
 <20260416012535.GB1065998@zen.localdomain>
 <aeEaqCJAWaWbz1vO@merlins.org>
 <20260416213632.GA1654609@zen.localdomain>
 <aeFY4uSTSIz4Ccat@merlins.org>
 <20260417215127.GA2310330@zen.localdomain>
 <aeK2QgUCefpVY4KX@merlins.org>
 <20260417231603.GA2376753@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417231603.GA2376753@zen.localdomain>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc_btrfs@merlins.org

On Fri, Apr 17, 2026 at 04:16:03PM -0700, Boris Burkov wrote:
> Rad, so there is some more "exciting" bug with balance lurking there.
 
Correct, all 3 times the bug happened, it was during balance.
And now that you mention it, all 3 filesystems it happened to had a
bunch of data already before I enabled squota on them (because those
FSes were several years old, and created with much older kernels).

On all 3, I ran:
btrfstune -n -x -r $DEV; btrfstune --enable-simple-quota $DEV ; btrfstune --convert-to-block-group-tree $DEV
and then on the mounted filesystem
btrfs quota enable --simple .

I'm not sure how many of -n -x -r were already enabled before, but 
100% know squota were not and neither were block group trees

My last remaining FS with squota running is the only one that had
squotas on it from the start (with the btrfs quota comamand but the FS
was empty).
If you feel the bug might not trigger in that use case, I can try to
re-enable balance and scrub on it, but it's another 30TB FS, so it sucks
if I lose it. Then again, I think we now know I can recover without
losing it, so should I go ahead and re-enable them with 6.19 (even if
6.19 did crash on my older FS where I enabled squota after data was
already there?)

> mkfs.btrfs -O squota <dev>
 
Aaah, I was missing that option, but even if it's a make time, do I
still need to turn them on with "btrfs quota enable --simple mountpoint"?

If there is no good documentation on all this, it's been 12 years since
I wrote all those missing docs/howtos on btrfs in https://marc.merlins.org/perso/btrfs/
happy to make a new one to put a few new notes on squotas and block-group-tree
which I was unaware of until just a week ago.

On the plus side, knowing it's squota and balance makes me feel better
that btrfs on top of raid5 isn't as unsafe as it used to be (it's
supposed to be safe, but I've had more than 5 unrecoverable FS crashes
after swraid5 misbehaved when I was really hoping for just a bit of data
loss or data corruption that scrub would find and then I could move on.
Also, I'm pretty sure I had -m dup all these years, so it's sad it
didn't help)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
