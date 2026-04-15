Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF3238B7DF
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 23:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776295530; cv=none; b=pe3ntmOQfBg//kd4bCZ94+PbU2x0ETSAdkETNF+aT2Izns+t3VetKyi7++0KYlN/TCYApPcGswGLsKtKjrkAnx00WEtwzW2/6nFxzibk5ONR8DHjlrP9zPLn5wipxcC/HW76tGpzl81sjkf6Ay6TXCZdMfOV8oLb82k3t0cV/pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776295530; c=relaxed/simple;
	bh=LpJtdM0D4apUiUuEwGWitjeRpdcnT5/a6Y4EFNtGAqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QspEjFostYknjyg2E+etWFZE8UTy3zk7/QeUnrvgYK/r6udviF056LeZKrTU0kh+HrLZaZ1O1HifhZb/qbFPLrVHE+6m8JXSVKOL316P3eYdsDVo92RDNOMxUUuQvCF0v0NyLvHV2QjxGSsRFDbTx843HqCLxHkxdiD4YnL/Cw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=Q9NM6nq3; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=D65+uqDg; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="Q9NM6nq3";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="D65+uqDg"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 246A61D00255;
	Wed, 15 Apr 2026 19:25:27 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 15 Apr 2026 19:25:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1776295526; x=1776381926; bh=l3o46bshn/
	YVazXgU2TaYiERxcVTwrpFP+/XkcjaiOI=; b=Q9NM6nq3bnh9he4bJ+p0i78SiA
	Fbvchy4hxNDNyacQDidUoh2i68oGQoGpB1TlttNoCmdqUZLQRRas5ZjClyQCH66E
	M9NMhgM1NpPqPFPSPVX+YdCh1uWjw4CIgmEcVPyX7YCN7FBwNaTH/1ovFX6pARJY
	SKzWkJ/fkz/ZRtqu9ARMwOgKOMjcm9XQ64Bn6oGMLgV+8y5xaRa5GAiQAHueUORi
	BTj4PP5tzMjOIdXI1puOVHlcZ3bRBzka6QZsERUUs1m9LNuCYvDuVOned/XMWlwE
	lGVDK8niYTt/lTgmERXtv2jgTr03eFlV7wjTa04N7OF35HBSxerMp2bg8Z7A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1776295526; x=1776381926; bh=l3o46bshn/YVazXgU2TaYiERxcVTwrpFP+/
	XkcjaiOI=; b=D65+uqDgbegueVVn0Oo+efP1GasVFHa3gL/INRWf8TdZhU9JGYT
	OFHVHoyHw0aLVo0tZOmeQ/HENSffXtWdYhu5HACDayuRMOZTKgYZBE1oR7G8W75a
	VCUOYkbGRyH2lNO7QqsyQ+czAHthlBPIu8mie2BDLSx41FS9ynmnzh2hv0GixGLS
	I6qtlxlUtPNVWmUeT1B3PbtpoKa0/KA0taTpedG4AKdbVg3I3U4hJxE3pu75XuQj
	QbZ9dvR0j3VNoNSvXYeDJmZ4WarZhU7rANVETcqolHvVU7F2aU3sE0ZMuGIZzD5R
	+flqxQqc590e8tDsU8G5asVehan2hvAz9mQ==
X-ME-Sender: <xms:Zh7gadLfiwwwmK-NKWq5uMMNzzEh6l30seF8aYfVBSsq-0QgryFraQ>
    <xme:Zh7gaeGtyYEJbnn-plwe5YP1PiCTylAlgY3BUEsEwfqwcEe-oK3PPxhjHfr79_1tC
    7J4OxfvEDeGjVHZFON-FcMR8N7Adhznc--FkB9jXmGDxCZe2mTWVSGl>
X-ME-Received: <xmr:Zh7gaZ9eA2A-Qrxw0uMkx9o4OrhMSECMDdOg73Ygd2YATOh5nQ32iwbxn2NvOCoc3T_reYPl9a-VvXSALt5W2_6-Rx0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegheegvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhrihhsuceu
    uhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepgeefle
    elteetkeejffelfefhtdevfeefuefgledvuddtfeefkeehheeflefhhfehnecuffhomhgr
    ihhnpehmvghrlhhinhhsrdhorhhgpdhprghsthgvsghinhdrtghomhenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhi
    ohdpnhgspghrtghpthhtohepledpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepmh
    grrhgtpggsthhrfhhssehmvghrlhhinhhsrdhorhhgpdhrtghpthhtoheplhhinhhugidq
    sghtrhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjohhsvghfse
    htohigihgtphgrnhgurgdrtghomhdprhgtphhtthhopeifqhhusehsuhhsvgdrtghomhdp
    rhgtphhtthhopehquhifvghnrhhuohdrsghtrhhfshesghhmgidrtghomhdprhgtphhtth
    hopehfughmrghnrghnrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhishhtshes
    tgholhhorhhrvghmvgguihgvshdrtghomhdprhgtphhtthhopegtvgefghekjhgujhesuh
    hmrghilhdrfhhurhhrhihtvghrrhhorhdrohhrghdprhgtphhtthhopehrmhesrhhomhgr
    nhhrmhdrnhgvth
X-ME-Proxy: <xmx:Zh7gaeLZpxacHRGdS25I1u25wWnEtpUZy7SgiydUusTcrf_XnWSlZA>
    <xmx:Zh7gaXvNlxSj7pIWh7b1sF1jn2qcBEVCm3vhpcKCfXWe4WINmo24mQ>
    <xmx:Zh7gaVDmbrbHsBxloi-UDkdyVd6gghYmEIu4X-_Fd3ugqJ_78qrRew>
    <xmx:Zh7gafMoinXATwXuFnqFCYP4Kve_Xlz8a_U1_jfzE1hSunNIOOonvQ>
    <xmx:Zh7gaV4_YRZ78euN-HDCwi1O8UmMVwUezV3d9WBvdkcZ8CSaUKXMILfq>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Apr 2026 19:25:25 -0400 (EDT)
Date: Wed, 15 Apr 2026 16:25:02 -0700
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
Message-ID: <20260415232502.GA1006689@zen.localdomain>
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

Which machine is this from?

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
> Thankfully the laptop FS was not put into an unusable state and I was
> able to get it back online quickly. As soon as I did, turned quotas off.

OK, the laptop is no longer useful for me to debug, which is fine, but
let's just disregard it going forward unless you have logs or other
dumps from before.

> 
> Since then I have upgraded the laptop to 6.19.11 and turned squotas back
> on on that single filesystem.

If you do see the issue again there, please do capture the extent and
quota trees and I will look straight away.

> 
> Sorry if I removed evidence that could have helped. It's still on
> moremagic, the rPi, since I could never remount read/write and turn off
> quotas. Obviously I can do dump trees on it (please provide exact
> commands you'd like so I don't mess them up)

No problem at all, they're your systems :)

My request for that extent tree + grep command was aimed at the rpi, I
believe. That is the system which produced this dmesg log, right?
https://pastebin.com/7HmQwy3n

If so, and if you ran the commands on the laptop where you already
wiped squotas, then that was just a miscommunication. If all that is
true, can you please run:

btrfs inspect-internal dump-tree -t 8 <dev>
and
btrfs inspect-internal dump-tree -t 2 <dev> | grep -50 15506102321152 

on the rpi?

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
