Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDBC3BED43
	for <linux-btrfs@vger.kernel.org>; Thu, 14 May 2026 14:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778770476; cv=none; b=KTkl2EzOHVgPJjJF2l6PHlwoRw+RuGPtmf9aECg6vm+61I0PQoC+DheakxONWQI/LoUFQbRWEB0USfbl3oziRlEas7BPfoyJlEpdzhI1Bl7L2SwgNuqGNCfaDnomVnff542oe89EQwHmyROqFcePBRXDfrZOoRIrlk6PpjNgKS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778770476; c=relaxed/simple;
	bh=vdJqx5JOXST6p+fBv1H4urQOl0WNaws8dGpCkLCK5ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lYVlYL/wdhvkAlG5QXrs4NfC9ai0CovC+9zhfhGwdYKY2iahVGfDnj6gNVsAprUzK9mZC8NxBGnwWeXCo93xb1wfFwAhTQ8t+hY59vEW4zy5k0D5rVJ+ipnpYQXYmjsP7xWtufE+rj/YiAcppW1CO9xqkU5s7KixVBjAqO5L8j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=fHgill+3; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=vsFJK0dG; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="fHgill+3";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="vsFJK0dG"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 7132B1400093;
	Thu, 14 May 2026 10:54:34 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 14 May 2026 10:54:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1778770474; x=1778856874; bh=k7Fq26HZ0U
	Ul5/OdjETIkAYY8aarhM9ooUA+Ap455iM=; b=fHgill+3RjlPWAL8ZY8Q7ACBFX
	TcraFQ3oAxbx0LoEwiNtNEWeLQShWQTZk/LV8vs6krepvyjTds1Py+zVeBK/mDfv
	e1IKuBdweJnrvst5R0WCrrV3roJSXGq+jVd+2Vmda5Mh2emm+3+iVrHdGl1VW3vK
	XcHDYjXWc31ULMLzMl8gg28J5Zua+qWgGH6Em/VhDwq+YYK615F92wh8aKFD5YoT
	ad3fh7vLeC67KmYMBWp4lOc8EoNtp62FQKOmeXLeZGo8iuUGEVh7b4/zPouyvWwY
	jQwEWFCRskCX4Wt8jtiYZrPbbhJc1H0742bwEaXHInhSQ7UYCS2UMcbMssow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1778770474; x=1778856874; bh=k7Fq26HZ0UUl5/OdjETIkAYY8aarhM9ooUA
	+Ap455iM=; b=vsFJK0dGlaEqMe4QS+QtOYQYD6PbqL3kzlsVbQa/7XtO54e/3Hy
	lsRY+1i1MkRb2WrH26v6BKUV657lz5Rt65JJ5vD5+nLPNjpnDKuj/ntM3IuZHfgR
	6iK7iiqh6qhrsiQ+pHBOCPRNcRQ6YuS/CthJBNTY1FqsUvTiL9E0F4T93Xb7n/82
	5VtewA5MAJsYhYez4dxbFjFF0Whw8K6n0E1Inf3IrilmWJMUc1V4FTcC5dSV5uze
	d106rjpGRjcs6Hy0BVZLoNriIiet8uHccUqfWOEvIXs7oHl8eKNiohGk0fcasLLm
	QCuZBAlIcE8sOcsvIpWOOMiyYHI5pXW7/2A==
X-ME-Sender: <xms:KuIFalaCS67dpllT3uwx16SHu8f2bHMJG64su3eql1qsWLZaVIhQdA>
    <xme:KuIFapWAFFw5R6plN4dbCPZc-fBWMGjPUaxJyhsMQY2HvVgxK3Lu6fQiTJbe_83Dp
    pSyD7uJXikQWj7LeocflqZFdmb3_NNUy-5osHv7OrFCZubElrJZ8aM>
X-ME-Received: <xmr:KuIFajm7hdRoBMAypXcPBCDkzjtdXiVJBAUPEosCIZmgzgiVcUeiTZk9ctixkgWvRV_dzUO7TkZTGRoeSyQRT39jRmM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduvdejkeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehorhhishcu
    uehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpeekvd
    ekffejleelhfevhedvjeduhfejtdfhvdevieeiiedugfeugfdtjefgfeeljeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepkedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepjhhohhgrnhhnvghsrdhthhhumhhshhhirhhnseifuggtrdgtohhmpdhrtghpthhtoh
    eplhhinhhugidqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthho
    pehfughmrghnrghnrgesshhushgvrdgtohhmpdhrtghpthhtohepughsthgvrhgsrgessh
    hushgvrdgtohhmpdhrtghpthhtohephhgrnhhsrdhhohhlmhgsvghrghesfigutgdrtgho
    mhdprhgtphhtthhopegulhgvmhhorghlsehkvghrnhgvlhdrohhrghdprhgtphhtthhope
    hnrghohhhirhhordgrohhtrgesfigutgdrtghomhdprhgtphhtthhopehhtghhsehlshht
    rdguvg
X-ME-Proxy: <xmx:KuIFasB78NFM71opjck0mb5nYDaXwyNWTWFs9GQ0chOOrmjXItAPVQ>
    <xmx:KuIFaqguS-jWvRdcvYo19EKVY28KZqBF2BZ5XFoz9Ay8FJXUr6_pcQ>
    <xmx:KuIFahwekanslyCrFYbNAh1AWyzjLnBW6LT396XHGxdVZTYuQe9-Hw>
    <xmx:KuIFaj3aWtAyDsPg8Ut7is7HGl59pcwpPc0aE2PAc-OOi8cfHETE1Q>
    <xmx:KuIFas5GJfcGl1BN5b7sE7JpUqic40FYQVlP3W7Zwk0VolppIrfhMXhI>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 14 May 2026 10:54:33 -0400 (EDT)
Date: Thu, 14 May 2026 07:54:22 -0700
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/7] btrfs: zoned: always set data_relocation_bg
Message-ID: <20260514145422.GC1197064@zen.localdomain>
References: <20260513123445.43197-1-johannes.thumshirn@wdc.com>
 <20260513123445.43197-4-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513123445.43197-4-johannes.thumshirn@wdc.com>

On Wed, May 13, 2026 at 02:34:41PM +0200, Johannes Thumshirn wrote:
> When searching for a data relocation block-group on mount,
> btrfs_zoned_reserve_data_reloc_bg() is looking for the first empty DATA
> block-group. But it first checks if the block-group is empty and if yes
> continues the search, and then checks if it is the first DATA block-group.
> 
> Reverse the order, first check if it is the first DATA block-group found
> and skip, then check if the block-group is empty. This enusres that there
> is always a DATA block-group set as data_relocation_bg in the filesystem.

You want the second empty block group? or the first? if you want the
first, then checking for "first" ever seems pointless. If you want the
second, then I think you need to layer the "if (first)" inside the
successful non-empty check?

As is, it just unilaterally skips the first bg even if it's not empty
and will grab the first empty one. It makes sense to not use the first
empty for reloc (that's for alloc presumably) but I don't see why just
plain skipping the first one makes sense.

> 
> Singed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/zoned.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 16dd87aa06f2..0b80b498fb85 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2784,14 +2784,14 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
>  again:
>  	bg_list = &space_info->block_groups[index];
>  	list_for_each_entry(bg, bg_list, list) {
> -		if (bg->alloc_offset != 0)
> -			continue;
> -
>  		if (first) {
>  			first = false;
>  			continue;
>  		}
>  
> +		if (bg->alloc_offset != 0)
> +			continue;
> +
>  		if (space_info == data_sinfo) {
>  			/* Migrate the block group to the data relocation space_info. */
>  			struct btrfs_space_info *reloc_sinfo = data_sinfo->sub_group[0];
> -- 
> 2.54.0
> 
