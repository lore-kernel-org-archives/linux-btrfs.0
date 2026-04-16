Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49391BD9D0
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 01:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776302553; cv=none; b=j2Hml1ebDZlqStWlJBWfexPGX50glexJR7MH+VeC1mhtfUIFRTuUlBEDjbDu+CZHOoPGKJCaCuUZ3wmzMQVutNI834TI9rMx8vXhf9NQ29rsNIPRzWdHJjiGeuxZYily6BS+bXyLq/4Qt00cVQ+D1iOVrCRuqQ07gBof1UlosiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776302553; c=relaxed/simple;
	bh=/5Z70NeHvY+sngRcBykTvmyyq+dyB5raTSENaWmIcFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h3WIkJ2VM3jLXWp8Po4wnSaUbX2K5zLQbC14rngaicx8u9OrhqIjHfUoU1Ml2fPpfI+zVuU6f2jNmL7A0Gas0MPUg9DftQFIsDqv98lcFlYelbLxQNBq2TvIFDQa9IJnH9mjNz5YNe4w/G1tf7sY0A/H0MPyIdS1SjottA9ifnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=vHEZDNfu; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=tKQqCPqR; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="vHEZDNfu";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="tKQqCPqR"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 50DCC7A0099;
	Wed, 15 Apr 2026 21:22:30 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 15 Apr 2026 21:22:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1776302550; x=1776388950; bh=I9/Mu10omZ
	KAojpXaOktaMgN2R5c6NSC38he+kbWShU=; b=vHEZDNfuJpv7PG6J5QIwIquMmJ
	DfgRFEzc99BwQqD8JwkqJzP84q+LQvwPYXy/53ZZOh8dBkdQIj3fKslL7f3QZJBi
	TU6A8rAGXKT0dEiuQeDNgbo+FP3/NNPWB4cehrC2Q9pdKsib9H0/YsyP3GZLXd8i
	wzCSgTITD1HYpLZsScj4di1QdzRbLetWEsmI385x7urgkJGMsu9hQFSWG89Wzuvf
	jJ3+qRe7OGsXWwe+ed7ZBdCRuQWLgrQNbh5vpF0ZEaA+5RD8mq5Ur1u96hYTz4Vw
	MRipzmB3JcDvfzzP9ZGHfYN3mnXUJ6uJ5BWBZxV82BjjoFKyFeObAUKXD2Lg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1776302550; x=1776388950; bh=I9/Mu10omZKAojpXaOktaMgN2R5c6NSC38h
	e+kbWShU=; b=tKQqCPqRwtmK96A2nQMtwDVXivhEa2EASun0quR04Uph3FY+8W0
	3Bd9LV1vmefjhWRcIwHhA3hZbsy4sCRrPis/WnKmAQkP8LIPsQPHXwbs0IVDTmJX
	njNpJBX2tZNHX/4yLCnzJRkzmbyHNMxyRdLrqADUfPvmQ6hKQ5Jh+AUiKV5pYkFO
	4n+ReTLdHa+QwSMuhSMdgrI73n06jHEagPQtEuKAUmO9GUWf5j66PWYJ/iv9W5Am
	rwL++nlItlELlNEi12vULBIzPnczHHlKJs3Rmwe8xpsQJbXT1C5K1391+6jMsS+s
	Cmit3y+4SyXAmq4ld7GCAkbixwbKGl+O+Ww==
X-ME-Sender: <xms:1TngaXb4fpTt-8aQZMukJhPwsgGGZqrkPZxArZwLZNfDbaAehHshEA>
    <xme:1TngaRD-kS9PCSXE_vqs-e8gH5Q1SynJ0LFiq2OBWLPz7PR3tOmTOiLAJzawx8Dpj
    afALrVZAd4gDin8QO86XRIU0bPFkvNNT-YKxFaH50T7o3GlUMfsl9A>
X-ME-Received: <xmr:1Tngaf9CzZMFepbOS9KdHQPGUaRMIp4g1-wE1MfVhusY63cGoMXUyh8sqKfxn65t0cRMqNYdW4Zeqddwpa6_4bei4wE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegheeiiecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:1TngadScsQbiT0VQ6ScR6cbdLA0pg26T9Vq-GUdg5auamin4xKeNkA>
    <xmx:1TngaTUlwk82niM4mHWGdQ1zkg-mjC1qcFKQ0XWql6_LG4abJyY9Tw>
    <xmx:1TngaXSumRm-HlmVKj_teBDPXKbVBIkMLv8qdUC9xlg3XNR63nwVfg>
    <xmx:1Tngab2AkJSGa4WL3O8GOHX0MoSazGkWOq3GcNXOsql2M8qxCxLv0g>
    <xmx:1jngaZ8eaz9aTXDrOIiZUtQWsVkIErQ2zpWtZMfJ1yfdp7tB89YREy9n>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Apr 2026 21:22:28 -0400 (EDT)
Date: Wed, 15 Apr 2026 18:22:05 -0700
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
Message-ID: <20260416012205.GA1065998@zen.localdomain>
References: <ad1GxXgWNBfgrRtN@merlins.org>
 <ad8gcwTFOLUhBHGA@merlins.org>
 <20260415170510.GA780391@zen.localdomain>
 <ad_SEOvBQtzsxWkY@merlins.org>
 <20260415184427.GA842130@zen.localdomain>
 <ad_zkh47QZZnns7x@merlins.org>
 <20260415223629.GA956756@zen.localdomain>
 <aeAXawJ9F9K28shr@merlins.org>
 <20260415232502.GA1006689@zen.localdomain>
 <aeAzm4bAmZNiVUuy@merlins.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeAzm4bAmZNiVUuy@merlins.org>

On Wed, Apr 15, 2026 at 05:55:55PM -0700, Marc MERLIN wrote:
> On Wed, Apr 15, 2026 at 04:25:02PM -0700, Boris Burkov wrote:
> > On Wed, Apr 15, 2026 at 03:55:39PM -0700, Marc MERLIN wrote:
> > > On Wed, Apr 15, 2026 at 03:36:29PM -0700, Boris Burkov wrote:
> > > > On Wed, Apr 15, 2026 at 01:22:42PM -0700, Marc MERLIN wrote:
> > > > > On Wed, Apr 15, 2026 at 11:44:27AM -0700, Boris Burkov wrote:
> > > > > > For a giant fs where we don't want to dump all the metadata or it would
> > > > > > be difficult to share the resulting gigabytes of text, I would still get
> > > > > > quite a bit of benefit from:
> > > > > > 
> > > > > > btrfs inspect-internal dump-tree -t 2 /dev/tst/lol
> > > > > 
> > > > > 1.2G    /tmp/tree2.txt
> > > > > 65M     /tmp/tree2.txt.xz
> > > > > do you want it?
> > > > 
> > > > Yes, please!
> > >  
> > > https://marc.merlins.org/tmp/tree2.txt.xz
> > > please tell me when I can delete.
> > 
> > Which machine is this from?
>  
> The laptop where quotas were removed after the filesystem turned R/O but
> I was able to recover
> 
> > OK, the laptop is no longer useful for me to debug, which is fine, but
> > let's just disregard it going forward unless you have logs or other
> > dumps from before.
>  
> I do not. So I can delete the tree above?
> 

Go ahead, thanks.

> > If you do see the issue again there, please do capture the extent and
> > quota trees and I will look straight away.
> 
> Understood.
> 
> > My request for that extent tree + grep command was aimed at the rpi, I
> > believe. That is the system which produced this dmesg log, right?
> > https://pastebin.com/7HmQwy3n
>  
> Correct, that's the rPi with 6.12.xx
> 
> > If so, and if you ran the commands on the laptop where you already
> > wiped squotas, then that was just a miscommunication. If all that is
> > true, can you please run:
> > 
> > btrfs inspect-internal dump-tree -t 8 <dev>
> > and
> > btrfs inspect-internal dump-tree -t 2 <dev> | grep -50 15506102321152 
> > on the rpi?
>  
> Sure thing, out2 and out8 attached.
> 

Sweet, thank you.

> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>  
> Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08



