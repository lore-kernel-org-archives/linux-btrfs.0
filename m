Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C22930215A
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 21:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776376037; cv=none; b=ss5KqsIPYB8jyaeIIxVWhVISa9m/BbJC0v/Hsj6Fgq+ZQz1TzK/nyqCNLIzxogufyC4He3M0TVoiiGsOuXAdQY9Ly5LxkP0x9MUus+GqmxRVjNZdWGdDQK4S5lOGMiGL+kYg0NrScH3exEPCnmRxibCZQMqeow90854orTYPtpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776376037; c=relaxed/simple;
	bh=XrTcbj5b6tR56vDVvpcEBOz2TgUyljJKKq000CyqPDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GZhRb+BJwuFiBrAHQwizGnpLSciLbor4EQ5oJPShGNwNViULQM4qUxn7rK2xGBpXMKvlLOjRnby/4r/UaiZVu93b6Z4k6qsuKeZ4vd2wq1fCO6JdhT6AJ/KbO5l4f+sG/s6Lu7AgXb57xxEerBhY3lA06BDphrS3X0VvVqrTLAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=KfKTWEAg; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="KfKTWEAg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PdicfQjyxoQUD84n/SGzwV6rmzssnIybELyb4sS7mjw=; b=KfKTWEAgKs2WiyriIperz66/ra
	0udlId/pFzvGSQk7uLp4SNGORpKdW3d01YXiyC5ZeL9WX8rmbvLUXxws3lxdiM9O4u+uoGxEFJ3xo
	FjxFKwhObaG30nXHYxbbdNuqXbkyd07qJWQDGtTFX6hlGEz8/GigBXV6Si0ULn8m6R7iByaGpXk4d
	9tpBxpDpt1vS+1LOTmmghk7n0q7ezvHxG5YYPQb3lNf2wq6BHaAMNM85t8ot8Jeu9F1PU5bnyAC7X
	3NfJCo27cRpru1vEElphHMqODsX9gxUCMvUBvlbFUNpJFJ7JsjRN8T80M1LVY6hNDk2Gadqy7QkjT
	e2PndDBg==;
Received: from [24.6.49.44] (port=49822 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wDUYO-0000000DqVB-0xAW by authid <merlins.org> with srv_auth_plain;
	Thu, 16 Apr 2026 14:47:16 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc_btrfs@merlins.org>)
	id 1wDUYM-0026v0-27;
	Thu, 16 Apr 2026 14:47:14 -0700
Date: Thu, 16 Apr 2026 14:47:14 -0700
From: Marc MERLIN <marc_btrfs@merlins.org>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Simple quota unsafe? RIP:
 0010:__btrfs_free_extent.isra.0+0xc41/0x1020 [btrfs] /
 do_free_extent_accounting:2999: errno=-2 No such entry
Message-ID: <aeFY4uSTSIz4Ccat@merlins.org>
References: <ad_SEOvBQtzsxWkY@merlins.org>
 <20260415184427.GA842130@zen.localdomain>
 <ad_zkh47QZZnns7x@merlins.org>
 <20260415223629.GA956756@zen.localdomain>
 <aeAXawJ9F9K28shr@merlins.org>
 <20260416004552.GA1045221@zen.localdomain>
 <aeA2c8V4FgCctUPG@merlins.org>
 <20260416012535.GB1065998@zen.localdomain>
 <aeEaqCJAWaWbz1vO@merlins.org>
 <20260416213632.GA1654609@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416213632.GA1654609@zen.localdomain>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc_btrfs@merlins.org

On Thu, Apr 16, 2026 at 02:36:32PM -0700, Boris Burkov wrote:
> On Thu, Apr 16, 2026 at 10:21:44AM -0700, Marc MERLIN wrote:
> > No help needed, just showing it happened overnight with balance and squota in 6.19
> > on my laptop. It looks like squota and balance are simply not compatible until the
> > fix for squota, lands.
> > Now that I know more, I rescued the FS and removed squota on my own and it's good again.
> > 
> > It looks pretty clear that btrfs balance seems to trigger the bug in
> > squota:
> 
> Thank you for the additional report, this is helpful. I am attempting to
> reproduce directly with balance to be sure I've got everything.
> 
> One question just to be extra careful:
> In all these situations, were you ever manually managing either the
> subvolumes or the qgroups? e.g., when, if ever, where you deleting
> qgroups and / or subvols?

All 3 filesystems this happened on were btrfs receive recipients, so
that created snapshots nightly (when it crashed each time).
Also after btrfs receive, my script deletes the oldest backup that rolls
out the rotation.
Then I also have some amount btrfs-snaps that makes hourly/daily/weekly
snapshots

So yes, multiple per day per subvolume multipled by many subvolume
(10-ish)

I have squotas still running on a single host but I turned off btrfs
balance nightly cronjob as well as btrfs scrub, and it has not crashed
yet (it's a 20TB+ backup recipient built from scratch, I woudl love for
squotas to work on it)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
