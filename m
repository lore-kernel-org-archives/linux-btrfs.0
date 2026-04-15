Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AF53115AF
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 22:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776292618; cv=none; b=tpTUghUDnPsynIaCfvopF55nJcEkNflfq/RPS04/nr2c3wA4zrHswxSjW3FwvHEHNzYnRQ1/c9bj5oUUaifCJTXfj3WDVtjI3cv7df6fByUBOsW1p1rFxV6qY9sRJGayT0Vc0tidFt3UopOrZrCMAPfGp5z+Tu/+fvAyuhYgofg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776292618; c=relaxed/simple;
	bh=MRdLtvgNglaOUYCFa0J0W3XG89nJVREhac3XMRkWXas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d7uVv3JIVcJoMesWIjW95K1mi4GILOHWakthqL+ksl06gjM4HHsafKmTZh21FGXZoxdw4qtT/2hcR0Z2PSUYvq+jsX/Tdce6u9a7jgeArzeTYRF3CV7pVsjdqxus3uU/fmfm0y03F6JZMt9OYGnOoBzkVRv5Inbr/w4UhjKLk90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=blQQzh+j; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=J39OzF+J; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="blQQzh+j";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="J39OzF+J"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id C93637A00F4;
	Wed, 15 Apr 2026 18:36:54 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 15 Apr 2026 18:36:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1776292614; x=1776379014; bh=HB8dKmo02F
	orvROETE0u5cIuBEuXpVgu9wDaWGrs2W4=; b=blQQzh+jfR6k17yGWdr7SyCfad
	DwrKy6b4EkpoeUa0T6CeBF2saAQWOhAyzRpNmQYt/5XsJNDgtqn2r7uTWGdVlnO6
	PZe8Y0OHKGpTHANKDCv2GwFs199+eD/2zyDIDrEFWj/Rus8OCbefKylVTeSwdIi4
	iOqQVIiaSGQ0Ldpw+G191HSCMmQwFwRbTkTX+1E6NnDIBjyn9kORW63Nn8j+BXzg
	OPYD154MzZd2IDiOQfymhknLcO62PGlstkZdnCJFcp+EDFY+iwfHplRN0tZAtQC8
	jiS+SbNypwCXs2ZypVnRecd2tacrDquJkVS3vj9xFCN6kun42ImPmoUxLAIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1776292614; x=1776379014; bh=HB8dKmo02ForvROETE0u5cIuBEuXpVgu9wD
	aWGrs2W4=; b=J39OzF+JwRq+7fl3aWXk0dfhO33nmGrsr/HCJTZ6hkVOGfjOoWj
	cDbtw+lMMq1E5L0Uk9N+jfDEJUrZhBTL4uGstxobSUku0h2+PX6qSKZjl5EkLmnP
	qyMy3sUlIaSmQ0DyqygmiIFdzsfrs6yCtIu1EsQL0a4FhlyqMkTgmXWZCxRUeWBH
	DAI0yNGD6Uyu/IEY6AZZCwSwGJUAZlbDoRo34dYz9sJ7hSxxa6ZFTldDU59NHTfH
	glHqN7jxQ22HJUc/Wo9T1EKhY7Pb0AeUjfYUk0lZyB+r91/lUtCM4YBpAEQF1lZ3
	V2qmVagqQWazMdxB3FX5s3yQwCfJ8ZCqaYg==
X-ME-Sender: <xms:BRPgaUwizdUkyCQVuvnGPEhUrmO2OsBJ9-Bhs-BRD69AEOBaqzSZgQ>
    <xme:BRPgaS4SuFyRfQj3LkketY8hn1L0-t6Ai9Y2zJ3ltrkYQptsq1QYuUefsfUDKQ7-J
    twTRMgFWlGtqZzoBkhxtUxI7tRjWugKVNSil-cJQX2ZxEQZavpmdTM>
X-ME-Received: <xmr:BRPgacXHvpJP96-Ldfh7EzZ-_kiqCTP_gLeIHhGonAuX5dy8J3ZXYyQLgYTzGtv3U9039YJdIUbpiKKtMbBYKvfpj8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegheeffecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:BRPgaSIJWat3JOjv--7Dti9TDRkUoJ_-2r9iOZ6M8-QqQz8AE0qV5w>
    <xmx:BRPgaWtWQVJfuWyns2yxeP6fHPrkq0uZOElvlNwFz86boZgGN9qMFQ>
    <xmx:BRPgaXImwKG0nT1o5kQVWwHOxNTWbFZQaR4L8gpq29-Xhcqzk66fiw>
    <xmx:BRPgaePL5_7qOMSKATfiC7WDAyiaphb6mP-wuoa7GR5X3WjNNLormA>
    <xmx:BhPgaY2E_3crAM0NCEROrTasL19po8g9b4FTPWyE2IdDwMCLbyvKMf0->
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Apr 2026 18:36:53 -0400 (EDT)
Date: Wed, 15 Apr 2026 15:36:29 -0700
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
Message-ID: <20260415223629.GA956756@zen.localdomain>
References: <adnBhWfJQ1n3hZC8@merlins.org>
 <ad0tdWyavEngGlQ-@merlins.org>
 <20260413184731.GA3448810@zen.localdomain>
 <ad1GxXgWNBfgrRtN@merlins.org>
 <ad8gcwTFOLUhBHGA@merlins.org>
 <20260415170510.GA780391@zen.localdomain>
 <ad_SEOvBQtzsxWkY@merlins.org>
 <20260415184427.GA842130@zen.localdomain>
 <ad_zkh47QZZnns7x@merlins.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad_zkh47QZZnns7x@merlins.org>

On Wed, Apr 15, 2026 at 01:22:42PM -0700, Marc MERLIN wrote:
> On Wed, Apr 15, 2026 at 11:44:27AM -0700, Boris Burkov wrote:
> > For a giant fs where we don't want to dump all the metadata or it would
> > be difficult to share the resulting gigabytes of text, I would still get
> > quite a bit of benefit from:
> > 
> > btrfs inspect-internal dump-tree -t 2 /dev/tst/lol
> 
> 1.2G    /tmp/tree2.txt
> 65M     /tmp/tree2.txt.xz
> do you want it?

Yes, please!

> > and
> > btrfs inspect-internal dump-tree -t 8 /dev/tst/lol
> 
> btrfs-progs v6.14
> total bytes 4074040004608
> bytes used 2417457491968
> uuid 49741c78-3949-4d7d-b77a-160ce071dee0
> merlin:/mnt/btrfs_pool3# 
> 

So no output? That is surprising. Did you already disable quotas on this
filesystem?

> > that is relatively less important. If the extent tree dumps way too
> > much, then doing a grep -C 50 for 15506102321152 would likely be enough
> > to show us the relevant backrefs.
> 
> No match:
> merlin:/mnt/btrfs_pool3# btrfs inspect-internal dump-tree -t 2 /dev/mapper/pool3 | grep -50 15506102321152
> merlin:/mnt/btrfs_pool3#
> 
> Anything else I can do?
> 

This is making me suspect *not* quotas now. That is the extent the mount
failed on. So it does seem to be the extent which is missing not the
qgroup.

However, it is possible that whatever has happened to the system since
the original abort / mount attempts is distorting our observations.

> > If there is no rush to wipe it, then let's keep it around until I rule
> > out whether a repair patch makes sense? Sorry if I misunderstood the
> > state. If there *is* a rush to wipe it, then let's confirm we got what
> > we needed out of tree dumping first, if possible.
> 
> At this point, I can wait.
> 
> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>  
> Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
