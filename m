Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EEBAAD24
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 00:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776300380; cv=none; b=iAe+bpz0D5QZItfviAeFiFwqK8Jp7akuJ98hlbkjELcNFa6/494OL+DL9dDznXpPUPej8BEKYOFd3YSeqIBss2TPeGO3E4rk7ol4IhjncLmP/5JMoaw2gFlApopAOulAXOblrRKGRGnaU5FaLTXtmO3r2yMoYRK5fwHbYMSjSn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776300380; c=relaxed/simple;
	bh=Vt1YMsiR8GWafpfv4QfDpZ9+29g0ngaCrLQiItizhT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mw8QtwPCcuXetT1oMdoP2AwCBIgCW2rxIeuZNjqCRHbqGA+J4F61qc8zEXr5k6ChyOAdcOti8OtmUuvB0RZrf2JsNDzWRvm85Fp3E6OiwgWVg+xVfmjfhu+/AFu7uClQqgVicTup3eXeCXWFyhiwGQXde/8GtxZ0MI6xzXQg9B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=npE//Sz6; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=anG40EgL; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="npE//Sz6";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="anG40EgL"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 943157A0296;
	Wed, 15 Apr 2026 20:46:17 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 15 Apr 2026 20:46:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1776300377; x=1776386777; bh=2kxUWuf9RT
	dB+lA0Vu6LulpoJVPdCVaQsiVozvvGLdM=; b=npE//Sz6OUeLuiTKqVRIC8F3V0
	Qbzt+MBtUi1jCsvFZi490cnqHeAoJf+zegiHoy8g0d446gOPMnrCYYBQYDkGxK5k
	owg3TqNJON51/Pq1KeQJK44MglDQUSc53V1JMqaF197bpmPYSL4CcLrhNj1bp22L
	N6EVjdlGq1//QXIuR5zTHnurRk65J/Qrc2b/Svv4p7rtpPG/KHoJNd4zr6lQ0mHN
	2RHUe/Na7eLwL2Y1rmc1erYmiP7QvaMQ9J/RqygjdSfXqM6nNQmELUu/kJvWd0hK
	muBbgD6Q90QlOUAOCm6Ps9VNdzvIzu+I8dQu8yAKSHWBeoePS+HT2jaDFZtA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1776300377; x=1776386777; bh=2kxUWuf9RTdB+lA0Vu6LulpoJVPdCVaQsiV
	ozvvGLdM=; b=anG40EgLZmvbWQ4Xgof8vNvIDA/0FN3qVO3Ot9FyT/dV5quiOsH
	a5WDZl6n5LuGlNKLwO/0D+3Xw2OVt/uRCa/1qwFXDDNGmddVj77cbtxG9u7owP7y
	tLqyyZ1ChpIPA+UtD7Sw2S5QG7o0w3M2JKB7tHIkX9mMpX3L0emlnezJVWvltGnF
	/HSN/mAYg5/71eR1kvSIGD37O5XCwyRdrNXO4Fgptc/1ZkrqOcqqaYStNdi4MGWe
	yAAQNdliwtNGOfTne03Zx+Ir29WLHjM8S1xH/9g/O5RkHZiNg4Kkap3HtkmLpbfW
	tzoAWDDbbmkQ5+S96L3Br/3E/geFVepkOJQ==
X-ME-Sender: <xms:WDHgaRT1E1vf8QvFZYMdX_TS6cP9DqyefsRnysVfjM77fBGH1EJnHQ>
    <xme:WDHgafsGrAkRo3SoGC7oED3How7_2Yk1cMpbAsVrarBd9IffOHDZBbRRK0xytNnFy
    IjrOrxN2vGSXc2I6zZniYkMwLzgTBW5k6NtPUclgqjT8gtZbiUr1AI>
X-ME-Received: <xmr:WDHgabGqaEdll5MieY3hvKfd4oArR0f3QDRywsTktyt57DXTS_TMr2hwQhxInUeJCHSPirPzFfVMMmnXeMNZirwwkSU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegheehlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhrihhsuceu
    uhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepuedtvd
    dtheegvddvteeugfevgffggedukeejhfeggfejkeeglefgieeggeduveehnecuffhomhgr
    ihhnpehmvghrlhhinhhsrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopeel
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehmrghrtggpsghtrhhfshesmhgvrh
    hlihhnshdrohhrghdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepjhhoshgvfhesthhogihitghprghnuggrrdgtoh
    hmpdhrtghpthhtohepfihquhesshhushgvrdgtohhmpdhrtghpthhtohepqhhufigvnhhr
    uhhordgsthhrfhhssehgmhigrdgtohhmpdhrtghpthhtohepfhgumhgrnhgrnhgrsehkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopehlihhsthhssegtohhlohhrrhgvmhgvughivghs
    rdgtohhmpdhrtghpthhtoheptggvfehgkehjughjsehumhgrihhlrdhfuhhrrhihthgvrh
    hrohhrrdhorhhgpdhrtghpthhtoheprhhmsehrohhmrghnrhhmrdhnvght
X-ME-Proxy: <xmx:WDHgaYxpuVtBl8R4bgnPpflc9M0xo2_ZDCOCtBHM6Y1r6F6YUXuEHA>
    <xmx:WDHgad203CDQLY70aKRC2Fhy4QvEaf_V0rwRqD6l4Du1Bpr5IZ49EQ>
    <xmx:WDHgaQp3_yFvEA7kwi0d0ixh8AeiUdR0PO21VTtZHFmwGNtbl4qpAw>
    <xmx:WDHgaSXkltsw5k0TLr0Hq9JUvP9ZUgz_XD5pRu2L2gzQd-vByfxPAw>
    <xmx:WTHgaeifu-TkWXesmGvAz96EHJIHfHflClxrCjbA020oPkTRwaDYpusc>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Apr 2026 20:46:16 -0400 (EDT)
Date: Wed, 15 Apr 2026 17:45:52 -0700
From: Boris Burkov <boris@bur.io>
To: Marc MERLIN <marc_btrfs@merlins.org>
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
Message-ID: <20260416004552.GA1045221@zen.localdomain>
References: <ad0tdWyavEngGlQ-@merlins.org>
 <20260413184731.GA3448810@zen.localdomain>
 <ad1GxXgWNBfgrRtN@merlins.org>
 <ad8gcwTFOLUhBHGA@merlins.org>
 <20260415170510.GA780391@zen.localdomain>
 <ad_SEOvBQtzsxWkY@merlins.org>
 <20260415184427.GA842130@zen.localdomain>
 <ad_zkh47QZZnns7x@merlins.org>
 <20260415223629.GA956756@zen.localdomain>
 <aeAXawJ9F9K28shr@merlins.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeAXawJ9F9K28shr@merlins.org>

On Wed, Apr 15, 2026 at 03:55:39PM -0700, Marc MERLIN wrote:
> On Wed, Apr 15, 2026 at 03:36:29PM -0700, Boris Burkov wrote:
> > On Wed, Apr 15, 2026 at 01:22:42PM -0700, Marc MERLIN wrote:
> > > On Wed, Apr 15, 2026 at 11:44:27AM -0700, Boris Burkov wrote:
> > > > For a giant fs where we don't want to dump all the metadata or it would
> > > > be difficult to share the resulting gigabytes of text, I would still get
> > > > quite a bit of benefit from:
> > > > 
> > > > btrfs inspect-internal dump-tree -t 2 /dev/tst/lol
> > > 
> > > 1.2G    /tmp/tree2.txt
> > > 65M     /tmp/tree2.txt.xz
> > > do you want it?
> > 
> > Yes, please!
>  
> https://marc.merlins.org/tmp/tree2.txt.xz
> please tell me when I can delete.
> 
> > > > btrfs inspect-internal dump-tree -t 8 /dev/tst/lol
> > > 
> > > btrfs-progs v6.14
> > > total bytes 4074040004608
> > > bytes used 2417457491968
> > > uuid 49741c78-3949-4d7d-b77a-160ce071dee0
> > > merlin:/mnt/btrfs_pool3# 
> > 
> > So no output? That is surprising. Did you already disable quotas on this
> > filesystem?
>  
> Ah, sorry, yes. First rule of sysadmining: after an unexplained crash:
> revert the last thing(s) you did.  2 crashes in 3 days on systems that
> were stable for years right after I turned on simple quotas and block-group-tree
> could not be a coincidence.

I am 99% sure this is a squotas bug now. I am able to reproduce friends
of your issue like:

  create subvol
  enable squota (usage is 0)
  delete subvol qgroup (allowed, usage is 0)
  add an extent to subvol (BOOM)

and also

  enable squota
  create subvol (usage = 0 until delayed refs run)
  destroy subvol qgroup (usage 0)
  sync (actually create usage, happens to swallow enoent)
  delete subvol
  sync (BOOM)

I haven't reproduced one yet that hits on subvol cleanup / extent
deletion without manually deleting a qgroup, but it is probably possible
as well. Did you happen to do any manual subvol qgroup deletion at any
point?

I think some variant of only logging that enoent will greatly harden
things and when we are deleting it really should not matter.

I also think "btrfstune --remove-simple-quota" may fix your fs. It will
have to do work in O(extents), and might fail in its fake mount, though.

In terms of a check option, I think I can try to detect that we
have a owner_ref item for a missing subvol and then nuke it. Working on
that next.

Thanks,
Boris

> Thankfully the laptop FS was not put into an unusable state and I was
> able to get it back online quickly. As soon as I did, turned quotas off.
> 
> Since then I have upgraded the laptop to 6.19.11 and turned squotas back
> on on that single filesystem.
> 
> Sorry if I removed evidence that could have helped. It's still on
> moremagic, the rPi, since I could never remount read/write and turn off
> quotas. Obviously I can do dump trees on it (please provide exact
> commands you'd like so I don't mess them up)
> I think there is also a way to backup the entire filesystem structure,
> mangle the filenames, and omit the data to alllow a copy that is much
> smaller and restore in a VM with spare blocks to emulate the FS without
> needing 22TB
> 
> Let me know if either helps
> 
> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>  
> Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
