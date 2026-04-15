Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE84931618B
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 22:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776293744; cv=none; b=gJF6DCwPn4L1DWoO7GwiTOa/T4CtJN1a76lBQf31NiEIn67GKk6IrbwjsWtM3hyfjtsn7ItVjMh91UNNKr+oaHkX/4G7CPNeMRjfiOMYtar+F5T7LBBxzoYNBMlc4WEoVodJiThC/XwgU2OElK3+pT3YzABpNYEd18FcKlTvIIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776293744; c=relaxed/simple;
	bh=xCc2j+urU25WSjLv+xFGN/4uyJJUEB+rPOO2kHNw7AA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rwHHTqs8PeOPmpAOimNWGB3DONjTY7dBuews7t4lZ+tX5rI9DG6jP+Ov/J4bW5jk89CWJV2BIJ5fRGB7h02y76HpVxKOwW0Ga4r9kHz1s17ls2FP5bTzwSFkOynDWlwSIfmcCZ2hcbPxKPauVMVsXUc9tzLrIIXKNQ1yD7GSryI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=NJJNE+bD; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="NJJNE+bD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1lUEYpF5c8P5QYilub2BhJ9e20USCnhuD27tX1MCgO0=; b=NJJNE+bDMdYITeRdmgc+fHRWdz
	q42dJgZrq/FWyVt+7wonTv4ZFIFgs01kSnq70L3vwDCk9gaepm7W/0kK09YhrOXxkTXYyNCHJ7e7C
	PbE9FFwwxjm7qvqqYwY9vwmv6XQdjl1X7gdbwHo9gi5KyUKl5qwIrCBgduPheYjWwUg2F7dfQqsVY
	CGlOALjXOC9c2tZ4w2zTF4QRqV0qSq/hMRMoRd3CDOF/q+zIt9uFJjM6j9YJVMztkQ8/13BubqB90
	QsasnJZUtTO6X0s0GACfnJW+gP4GcHPAb3Yd0L9YbqbrQEZE+8m/AEDUHniynfk1ZSNVMwmQK9B5K
	ewxDKKtg==;
Received: from [24.6.49.44] (port=39934 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wD992-00000008P3q-3vhS by authid <merlins.org> with srv_auth_plain;
	Wed, 15 Apr 2026 15:55:40 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc_btrfs@merlins.org>)
	id 1wD991-0002yB-1N;
	Wed, 15 Apr 2026 15:55:39 -0700
Date: Wed, 15 Apr 2026 15:55:39 -0700
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
Message-ID: <aeAXawJ9F9K28shr@merlins.org>
References: <adnBhWfJQ1n3hZC8@merlins.org>
 <ad0tdWyavEngGlQ-@merlins.org>
 <20260413184731.GA3448810@zen.localdomain>
 <ad1GxXgWNBfgrRtN@merlins.org>
 <ad8gcwTFOLUhBHGA@merlins.org>
 <20260415170510.GA780391@zen.localdomain>
 <ad_SEOvBQtzsxWkY@merlins.org>
 <20260415184427.GA842130@zen.localdomain>
 <ad_zkh47QZZnns7x@merlins.org>
 <20260415223629.GA956756@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415223629.GA956756@zen.localdomain>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc_btrfs@merlins.org

On Wed, Apr 15, 2026 at 03:36:29PM -0700, Boris Burkov wrote:
> On Wed, Apr 15, 2026 at 01:22:42PM -0700, Marc MERLIN wrote:
> > On Wed, Apr 15, 2026 at 11:44:27AM -0700, Boris Burkov wrote:
> > > For a giant fs where we don't want to dump all the metadata or it would
> > > be difficult to share the resulting gigabytes of text, I would still get
> > > quite a bit of benefit from:
> > > 
> > > btrfs inspect-internal dump-tree -t 2 /dev/tst/lol
> > 
> > 1.2G    /tmp/tree2.txt
> > 65M     /tmp/tree2.txt.xz
> > do you want it?
> 
> Yes, please!
 
https://marc.merlins.org/tmp/tree2.txt.xz
please tell me when I can delete.

> > > btrfs inspect-internal dump-tree -t 8 /dev/tst/lol
> > 
> > btrfs-progs v6.14
> > total bytes 4074040004608
> > bytes used 2417457491968
> > uuid 49741c78-3949-4d7d-b77a-160ce071dee0
> > merlin:/mnt/btrfs_pool3# 
> 
> So no output? That is surprising. Did you already disable quotas on this
> filesystem?
 
Ah, sorry, yes. First rule of sysadmining: after an unexplained crash:
revert the last thing(s) you did.  2 crashes in 3 days on systems that
were stable for years right after I turned on simple quotas and block-group-tree
could not be a coincidence.
Thankfully the laptop FS was not put into an unusable state and I was
able to get it back online quickly. As soon as I did, turned quotas off.

Since then I have upgraded the laptop to 6.19.11 and turned squotas back
on on that single filesystem.

Sorry if I removed evidence that could have helped. It's still on
moremagic, the rPi, since I could never remount read/write and turn off
quotas. Obviously I can do dump trees on it (please provide exact
commands you'd like so I don't mess them up)
I think there is also a way to backup the entire filesystem structure,
mangle the filenames, and omit the data to alllow a copy that is much
smaller and restore in a VM with spare blocks to emulate the FS without
needing 22TB

Let me know if either helps

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
