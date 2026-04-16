Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5DC1FCFEF
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 01:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776302761; cv=none; b=e35bqx7QLyx6PeAfAq/JaBl8qiFkCZSULlFJvyCdKYvDyOAt1Q1KegXcy6oBwUP4aFX1vS1zYogdhVLBx/UrIsfHRpn7Grt99S7E88KCOlpB9CHfmyDrGdWx+5UjXxl/GBOHdbvwplHeL+qJ+m+Gn4EMD6Xezj1YuerC1N1eSKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776302761; c=relaxed/simple;
	bh=/J4M3V/6ZyQoTX2l12Jg4QojJDRWwe9P61atd+VHqr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MDF/npP9tIq0TppswaznE2VkINg+UWTIViTBcMcraZA3o2barMK8szmcXr3utslmpp5SwxZnk0xD3VBO5jSCjvfr7H9kfsDdroJIHral7id+peD9RFW2H/ZrfiG43IV2QeKIP5UnSkZcaPCaTn22UBUR/S6OZV1BuM/zXiW4SPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=UuUG607r; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=NRCBeftX; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="UuUG607r";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="NRCBeftX"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 8EE907A01C2;
	Wed, 15 Apr 2026 21:25:59 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 15 Apr 2026 21:25:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1776302759; x=1776389159; bh=Muldp/e9It
	kaReZ7PHRL8UMiBOsV3+8oaIlDG+Y6NoA=; b=UuUG607rWPqBTJq537naeiU8LL
	R1pzJpgI+zKZPejJAYqGWZzd6UAAiMhf8Z5mUXgb3dOsNAZxLSyRD0wuBTgJktDh
	F/5yfULkg45puWvcmo5eCJMgWRMKBeM0i5K9pBZVLs9Ag9Kc6YKwsb6aceq1NlpN
	lhJ19Tr9wrv8vhHexPCwZlDxJONI0ybhorhZN1MVp7BQlRWfil36BgIDw+lwMt9O
	2by+kDOJXMRWVO4NaSfAj/cvyVj4lf+MtqaQ8to15cCwxr7jMVez46OFWKqxCkOP
	yGfDuWvIO0ZSI/ppQm2o2oZ7Ae9xlgjAdx/8lGUSOWinT0o9BWiTHeOe7bfg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1776302759; x=1776389159; bh=Muldp/e9ItkaReZ7PHRL8UMiBOsV3+8oaIl
	DG+Y6NoA=; b=NRCBeftXsus0zg22OdYNtw9EQgFJlrhBE4R9EQdpFpLRDuFW2cM
	Ru5AJkHDJ0yV6P8TeSwnNognoE4f7vecGBzJToMBk2sPo+P76wngyAGyIUEh0IZV
	LQjcdPxa+/ksXHfJuJOk+OhGUlVbZTBNeOJd3Rl5SdEFvR498VZa643t+SjG5+aV
	L9h6eb3tEBhk42QUFjYLCqVuN8qTuqCnVFl2XWxj+NO6ajEm2702kAsnCX0Bgs4/
	Oq3dhx/JtturYuyUcexpkAldz0H84qtKKrT5Rg21FFF4TOvxTO5lnR4Eb/39bRtG
	LHvTI4fmRNK8+1+SCPgYweH0xm5lQ3uxpwQ==
X-ME-Sender: <xms:pzrgaRxqfEPyNIEndE3z7QxCrzmq12qObYa60uUb31ePF5h-RhGTkw>
    <xme:pzrgaXT1sXXDBIQvPhcPM6Wx91hcJoqrDdifb4nzyOSloUF_8uMTWQtOUb5RlwFDJ
    GgZ183NQoMFzQSLyNDhD1YjLuG-aBnx9T-PiH4YYFxcoIrI30vUsfg>
X-ME-Received: <xmr:pzrgaY-whBLT_WknCkT79L0fOUg0cj3R2Y_yEGSPEifO7E28X2uAuNuLbxrbSd-1wbnGNRsL8BIC6ua-7pQYZ1CfZ9s>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegheeijecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesthdtredttd
    dtvdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeeutddvtdehgedvvdetuefgvefggfegudekjefhgefgje
    ekgeelgfeigeegudevheenucffohhmrghinhepmhgvrhhlihhnshdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepmhgrrhgtpggsthhrfhhssehmvghrlhhinhhsrdhorhhgpdhrtghpthhtoheplhhinh
    hugidqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:pzrgaervzQb00wMyJZOFNj9LaFxB-1Ic6ps4lRkNGVQLs4abrymjkw>
    <xmx:pzrgaVnguez7TdXFAiWDIGHlYOxphymXbp2Z9WTLxhC_1N13K8hpDw>
    <xmx:pzrgaVJnWGjFsdPHYqvTis1OFABoEeASZfxHjD2mOkDIyPfAcw0Vmw>
    <xmx:pzrgaaxcpBGxhX8BpHWCzGDUZ_SjOzBdOE4RVOwnnb9Y1UPOvCRszQ>
    <xmx:pzrgaVK2PLSVnZr0EhovY6qZXfURUcZylc-APm5Ye_G7ADX4TbmrVPx->
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Apr 2026 21:25:58 -0400 (EDT)
Date: Wed, 15 Apr 2026 18:25:35 -0700
From: Boris Burkov <boris@bur.io>
To: Marc MERLIN <marc_btrfs@merlins.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Simple quota unsafe? RIP:
 0010:__btrfs_free_extent.isra.0+0xc41/0x1020 [btrfs] /
 do_free_extent_accounting:2999: errno=-2 No such entry
Message-ID: <20260416012535.GB1065998@zen.localdomain>
References: <ad1GxXgWNBfgrRtN@merlins.org>
 <ad8gcwTFOLUhBHGA@merlins.org>
 <20260415170510.GA780391@zen.localdomain>
 <ad_SEOvBQtzsxWkY@merlins.org>
 <20260415184427.GA842130@zen.localdomain>
 <ad_zkh47QZZnns7x@merlins.org>
 <20260415223629.GA956756@zen.localdomain>
 <aeAXawJ9F9K28shr@merlins.org>
 <20260416004552.GA1045221@zen.localdomain>
 <aeA2c8V4FgCctUPG@merlins.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeA2c8V4FgCctUPG@merlins.org>

On Wed, Apr 15, 2026 at 06:08:03PM -0700, Marc MERLIN wrote:
> On Wed, Apr 15, 2026 at 05:45:52PM -0700, Boris Burkov wrote:
> > I am 99% sure this is a squotas bug now. I am able to reproduce friends
> > of your issue like:
> 
> Great news, thanks or looking into it.
> 
> > I also think "btrfstune --remove-simple-quota" may fix your fs. It will
> > have to do work in O(extents), and might fail in its fake mount, though.
>  
> moremagic:/tmp# btrfstune --remove-simple-quota /dev/mapper/crypt_bcache0
> bad eb member end: ptr 0x4000 start 15495725432832 member offset 16384 size 1
> bad eb member end: ptr 0x4000 start 16568941559808 member offset 16384 size 1
> bad eb member end: ptr 0x4000 start 16133011357696 member offset 16384 size 1
> bad eb member end: ptr 0x4000 start 15495760642048 member offset 16384 size 1
> bad eb member end: ptr 0x4000 start 15641229164544 member offset 16384 size 1
> bad eb member end: ptr 0x4000 start 16027775762432 member offset 16384 size 1
> bad eb member end: ptr 0x4000 start 16217851576320 member offset 16384 size 1
> bad eb member end: ptr 0x4000 start 16217853050880 member offset 16384 size 1
> bad eb member end: ptr 0x4000 start 15505960157184 member offset 16384 size 1
> (...) many lines
> 
> It's still running after a while and giving hundreds of those lines.
> 
> Willl report back when it's done.
> 

Not too promising, but no theory what would cause that off the top of my
head. You can let it run, now that you started it, I think.

> > In terms of a check option, I think I can try to detect that we
> > have a owner_ref item for a missing subvol and then nuke it. Working on
> > that next.
> 
> thank you. But I can only check that if btrfs tune doesn't fix it. Did
> you want me to stop the tune or let it run to completion?
> 

That's ok, I think the condition to fix is easy enough to produce.

> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>  
> Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
