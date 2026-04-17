Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4475837F742
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2026 23:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776467793; cv=none; b=i8dIEuiTGU6KUi+bAJebo5KWDfmzLUzuVXpMBqsFeYgvyMgh568cyp5DhVNVCOHsD7bjCMHvgOMr4LEu/W6qP2NMCUwsP10baGv1rv81xzKOvr4ijZq9+XdpdsUxcRRyN33O2NkT5XhxhPbGzTbp0FonkFv7AAIErO8aIiz63gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776467793; c=relaxed/simple;
	bh=dioKhvlPx8gEF12LRAqA6JpX9yOFd3IVZZXD64M0zyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MxdNdSki+ph90ZzqEH9O9uVETQHhYkWmBpeTnUE9oXmzPtEE6QYr6lVLAjlhKbuftuwNRl8ZLKNww51y/4LS5rQZQ/dkJskd9NkKxPJyRZLo3AsKzp3DoTkRPNYa7PLrUdym6i8tJVAJ+hpYfqv+FbYfHKoeDH/Y7IZ+CC4dVqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=H7IWGkjx; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=rei4gazz; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="H7IWGkjx";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rei4gazz"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 30E08140006C;
	Fri, 17 Apr 2026 19:16:31 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 17 Apr 2026 19:16:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1776467791; x=1776554191; bh=XPJaFkT5CZ
	iQRA3Gs/UIT7nV5NCTfdm4E3Mp/Jrw6ig=; b=H7IWGkjxHgw/0xpIovU7v0rkeO
	Js9G1IHvvz+1olnD5L9xy3T3lsLsEFATvF0UhZ8stBkAR9my3TNP8uNywJZwmewY
	VxvWScQIQIG73xlwck4MNqAO8eg+YV8Ikuwqb5A/Fl84QmIfy42zEOrZ9tX9pbjM
	lxMqOL2AcQld70hRt+dqnRM4TYu11ALrIjfJX49MnU88+ykk+FgfUtOe2FIUmcys
	6dCp8wj2/BNK7FMjtiv7m7YV4NWRxk8vqEHo0vHJkz9o8NLN0dIFt0Drljf4BDKH
	QauPQYSR4G0h+TUKDA0slvIyS04YqgdOsVPXwGvnVKdJ/dTefLcPnqb2RrXQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1776467791; x=1776554191; bh=XPJaFkT5CZiQRA3Gs/UIT7nV5NCTfdm4E3M
	p/Jrw6ig=; b=rei4gazzvvxuQJJlTt9a1js0OL3jZts+w+Og6cnQL44pK+WaM7M
	g1kUbmFqfHUH1JIvsEpAAU7Mr5OtPQMAVEK7XlgxlxlGr3Q9Vk23CVvvYBcZNDpd
	GvHQEPewA2Xslkl6xxffwVOVqmk5AAuwrEzCEEuvAsbOhUqaVoGh/PdqNl+fYDyU
	aaE4Mt/m6bOzjlBtS7aDfotqomELr+gJIgkuOukFbVAzTcwgeMTHzEIr9Cb/RFj5
	WAMq1BtvCkCKlkwftgvCtYql7cg/Nr1b1kJnJ8vPFxDHBw8tFsd/RnEMPSaSDTed
	aiiWsmi5/SNs3Wt2m1VEY5aby/57Dln8kNg==
X-ME-Sender: <xms:Tr_iaQfu5DDnowNDNOqPWqqAbrfr-is9r62o_BW55YbwfV-PexbbtQ>
    <xme:Tr_iaYNCW9ixw6l_bJ1qfK0YyuYmUJjQkFETpb8jO9S-GYIz1t7sXQN2jQRbNQxNX
    IcUF3RxEFPUBNydQWXIKgWOO2lig6GAetK-l7sSXnQMkowxbHq89m8>
X-ME-Received: <xmr:Tr_iafL5qTtjZqTxrznulLgXZRhp0DYYLSBQ5OXg4XvAJKKdiAz2CgMtZXQOXK4YJTSSjOZuwCzdpXCwXMEpi6VgfF4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdehuddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesthdtredttd
    dtvdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeeutddvtdehgedvvdetuefgvefggfegudekjefhgefgje
    ekgeelgfeigeegudevheenucffohhmrghinhepmhgvrhhlihhnshdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepmhgrrhgtpggsthhrfhhssehmvghrlhhinhhsrdhorhhgpdhrtghpthhtoheplhhinh
    hugidqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:Tr_iaREh4YwDy40C33W4_GN4ypGygQDelOUaolmA9Q49RHCx23vNew>
    <xmx:Tr_iafTXAmPnshMlJAoSKyuhWU23AckwLgU8kp1adaCeRCDGf5xNPA>
    <xmx:Tr_iaVEWwwCyb1lXIyQayxKmJhZbMxWJBvWDpGv3DyWWTrJqE1P9GA>
    <xmx:Tr_iaT_5XUWYydjZxkMV-LuJcGje0Bn5KAvRlIWS2sYCfm_AGAhNNQ>
    <xmx:T7_iab2LxA5uU8exuA1AX83bp0E0uN8PVwkkZFxu8exhrBVQFYIZzJ_B>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Apr 2026 19:16:30 -0400 (EDT)
Date: Fri, 17 Apr 2026 16:16:03 -0700
From: Boris Burkov <boris@bur.io>
To: Marc MERLIN <marc_btrfs@merlins.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Simple quota unsafe? RIP:
 0010:__btrfs_free_extent.isra.0+0xc41/0x1020 [btrfs] /
 do_free_extent_accounting:2999: errno=-2 No such entry
Message-ID: <20260417231603.GA2376753@zen.localdomain>
References: <20260415223629.GA956756@zen.localdomain>
 <aeAXawJ9F9K28shr@merlins.org>
 <20260416004552.GA1045221@zen.localdomain>
 <aeA2c8V4FgCctUPG@merlins.org>
 <20260416012535.GB1065998@zen.localdomain>
 <aeEaqCJAWaWbz1vO@merlins.org>
 <20260416213632.GA1654609@zen.localdomain>
 <aeFY4uSTSIz4Ccat@merlins.org>
 <20260417215127.GA2310330@zen.localdomain>
 <aeK2QgUCefpVY4KX@merlins.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeK2QgUCefpVY4KX@merlins.org>

On Fri, Apr 17, 2026 at 03:37:54PM -0700, Marc MERLIN wrote:
> On Fri, Apr 17, 2026 at 02:51:27PM -0700, Boris Burkov wrote:
> > Just to be extra clear as it is relevant for fully understanding the
> > repro-space, are you managing these purely with receive / subvol delete
> > commands? 
> 
> yes
> 
> > Did you ever delete a qgroup that was straggling around or add
> > automation to do that (btrfs qgroup destroy <qgid>) or did you ever
> > disable/enable squotas besides the first time?
> 
> no to all 3
> 

Rad, so there is some more "exciting" bug with balance lurking there.

> > Were all the squota enables on existing fs-es?
> 
> Yes. My understanding was that I have to create the FS first and then
> turn on squota. If I could turn it on as an option to mkfs.btffs, I
> would but I didn't find such an option.
> 

mkfs.btrfs -O squota <dev>

should make a fresh btrfs with squota enabled. But we can worry about
that once I get the fixes in. :)

> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>  
> Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
