Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82153E5585
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 17:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776272736; cv=none; b=uSPKX7PDkWmIv+Lur4uR/3cs8VwxW/WHWPoQlYJ65vlJCUcboCzywvwXB94DvPeDhyaS8J7WFCJnCvx/8kl++be0woBGwAzS6wlBIAYLPgT6XsJKVWUKvw+xDodBm+MUoL1fQj537hFrviXPoGtYPjcvIt/bAy9HMPLts9mtXQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776272736; c=relaxed/simple;
	bh=LDZNx4TcsiIoyThBFeig1TvJ2vWDSPg1C22l/1fIAjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eqerOMgknQftU8u8PcN3QUNGMBW7LVmshUVFhdeNMIoGlSbnOl9PysQqlVh5uKBirEMfukFuOGISiiE3NioqRuTB0YLFulRsob6yvSSR4Z7J0ob4dFe2iV/DQORjpp7HrHls1RLoBLNHPNaPr3ZsZmeZ+vvO2j7hWBJkM0oKmCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=NYgHWyTN; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=QP+zF6j1; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="NYgHWyTN";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="QP+zF6j1"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 21734EC00E7;
	Wed, 15 Apr 2026 13:05:34 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 15 Apr 2026 13:05:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1776272734; x=1776359134; bh=m3vC86yTaF
	HTTVTEv4ocxlMrsy/2ZEfBrxKfj7fW44w=; b=NYgHWyTNLKcwOXOMkbxV5bvqcl
	EQZsivqe61OLhbkOq0GxvGHrQf8weUltTq9Hj7ow7cDvcf+g910WLumLMz6v+onJ
	/YsYuRevLkvwymOUvepfPstEJ7fhvoqRjqGXdZLUdhaL+ZSX57jAAc1yXvRx9dTl
	bLfzqJm2dGFujEryBnKWILSswCe/aW/ziRejKzEWtuKnK5DyKYKNiSwKMzgha3ci
	VkLQxxplKasXlIt7wBtv7JLMMeDJDC1Yk0bqeU790xoH8xSyJso3neXCCWnMrjF/
	wzxzHp0jhFdpMb+p/brDIPpHLJ0RswTqt/WxWoJvznO1LDTBLxJybHWyZ26Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1776272734; x=1776359134; bh=m3vC86yTaFHTTVTEv4ocxlMrsy/2ZEfBrxK
	fj7fW44w=; b=QP+zF6j1pnZ96+xN6L6zfoBMeYXMR42oZbIkB1oDlZDlfVfos7n
	NEqinPWxY1azM1IJwoUzqx4IpTPJwonY4L025TD11R4MMXVIY/vzHTgpyXUPgiG7
	ilw9S92raBoBzduQyHocJ9l1EhgvwWfMd2IQEO24NLKMh3EpqMrcOpkv0OSoaTt4
	mq62SbWOhbj9X1kfOB7ZWN4wYIvLlIWNPLNIE6o5pwpo0q7VyGlMMmUjD1FhaccH
	w7tiA50lPiR7Tvf4GQta/sCrsDic0M30kaGzzFeAcZxi8PlQNERn6MCP9cRrBW0C
	QB9SjixuHcXF3ubzKvljQsBBWrbp910evkw==
X-ME-Sender: <xms:XcXfaXRsow4uoGHX_mjc33o6kIZ3Gr5xz8Hmn28TLpmbPKOe5MVjZQ>
    <xme:XcXfaUo42pgT93SXlMIHiwgJlc3Af7CZFNd2bP-u860ksFA-hpN9emm-C33rak58j
    xxHObXyev-In2PCWyLGEflA0GLO-5FWXMjUCwSZ3_bf5EoQUSP3yjs>
X-ME-Received: <xmr:XcXfaZ2OfwNVgb5WcvulO922Fo1IQF0HVd56GtoSuk5TVbW7IGM6ZyhNn3XeYPoWvkDRmLKAenMJpwtf3K6L8OLS9GY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeggeeihecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhrihhsuceu
    uhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepuedtvd
    dtheegvddvteeugfevgffggedukeejhfeggfejkeeglefgieeggeduveehnecuffhomhgr
    ihhnpehmvghrlhhinhhsrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopedu
    uddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepmhgrrhgtpggsthhrfhhssehmvg
    hrlhhinhhsrdhorhhgpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvhhgvghrrdhk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehjohhsvghfsehtohigihgtphgrnhgurgdrtg
    homhdprhgtphhtthhopeifqhhusehsuhhsvgdrtghomhdprhgtphhtthhopehquhifvghn
    rhhuohdrsghtrhhfshesghhmgidrtghomhdprhgtphhtthhopehfughmrghnrghnrgeskh
    gvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhishhtshestgholhhorhhrvghmvgguihgv
    shdrtghomhdprhgtphhtthhopegtvgefghekjhgujhesuhhmrghilhdrfhhurhhrhihtvg
    hrrhhorhdrohhrghdprhgtphhtthhopehrmhesrhhomhgrnhhrmhdrnhgvth
X-ME-Proxy: <xmx:XcXfab4xXnM4Z34RiQB912CZc8F6bSjUxTJvvOugA_W2C9qpRicDsw>
    <xmx:XcXfaVQbRScz4gh1Z50BeK9QfkwGMLrdWpPSCqzsweVecp9kV9EmCg>
    <xmx:XcXfaQVYGAtIjigu9fMUUS12zTevbTRHIn9kv7Pzor_nBwW1VMcPJQ>
    <xmx:XcXfaaGOmFlPOtI2EdQfFpoP0VLj4YC1l_9IUEKxuCNwoakl9shPug>
    <xmx:XsXfaXd71o8UKaBUDSvfdrvGVpetlWZw2bvWY2PfFiFwTVMZ_ErNkjLz>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Apr 2026 13:05:32 -0400 (EDT)
Date: Wed, 15 Apr 2026 10:05:10 -0700
From: Boris Burkov <boris@bur.io>
To: Marc MERLIN <marc_btrfs@merlins.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, QuWenruo <wqu@suse.com>,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	Filipe Manana <fdmanana@kernel.org>,
	Chris Murphy <lists@colorremedies.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	Roman Mamedov <rm@romanrm.net>, To: Su Yue <Damenly_Su@gmx.com>,
	Su Yue <suy.fnst@cn.fujitsu.com>;
Subject: Re: Simple quota unsafe? RIP:
 0010:__btrfs_free_extent.isra.0+0xc41/0x1020 [btrfs] /
 do_free_extent_accounting:2999: errno=-2 No such entry
Message-ID: <20260415170510.GA780391@zen.localdomain>
References: <adnBhWfJQ1n3hZC8@merlins.org>
 <ad0tdWyavEngGlQ-@merlins.org>
 <20260413184731.GA3448810@zen.localdomain>
 <ad1GxXgWNBfgrRtN@merlins.org>
 <ad8gcwTFOLUhBHGA@merlins.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad8gcwTFOLUhBHGA@merlins.org>

On Tue, Apr 14, 2026 at 10:21:55PM -0700, Marc MERLIN wrote:
> If you don't mind my asking, and even if it's just a guess:
> 
> 1) do you feel squotas are likely safe and I hit another bug?

I actually think it is a squota bug and am trying to reproduce it. I
think there may be a gap if we are deleting the qgroup in the same
transaction as the last delayed ref in the qgroup.

In meta production I have a carryover patch ignoring such enoents, which
makes me super suspicious.

I have not reproduced it yet, though.

The fact that the two stacks are in balance and qgroup deletion make me
suspicious. On the other hand, the fact that the second stack is in the
commit *before* the majority of the cleanup makes me less
suspicious.

> 2) any chance it can be block-group-tree instead? Are those 
>    considered reasonably safe? (I enabled due to the number of
>    snapshots, 100+, and being told it's bad for perf to have that
>    many, which block-group-tree is supposed to fix)

I think that is relatively unlikely.

> 3) anyone still taking bugs for btrfs check --repair since it
>    fixed nothing on an unmountable filesystem

If my suspicion is correct and this does end up being a missing qgroup I
think that I could likely have a useful fix for check --repair too.

> 4) anything useful to anyone in my broken filesystem which might
>    be easy to fix but not by me before I give up, delete it all
>    and do the multi week restore?

I think trying to dump the state of the tree on your laptop could be
quite useful.

1258303029248 is the logical address we were freeing so its backrefs in
the extent tree will be interesting. As will whatever subvol tree it is
in, as will the qgroup tree entry for that subvolid. If you can share a
full dump then I can find all that myself.

ditto for the logical address that broke on the rpi, but if that is a
gigantic fs, maybe doing the dump will be pretty unwieldy..

Thanks for your help with this,
Boris

> 
> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>  
> Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
