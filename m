Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD1E3E024C
	for <linux-btrfs@vger.kernel.org>; Thu, 14 May 2026 14:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778769893; cv=none; b=AA8Ft+WuDrfeppXUFyF3xhi6A042G7lyCjJyDcvYB/YTIKhV5eKImQFGZ6UlfGtxHYnrZIe5k+uwkEwBY+wn+B17jTbGlme35WDymJClDPfd44DtDY+WajH8badppUGe/RID8roSFUqHpe7w+XpC9UzmE3ZBjGh/OBBhGJN5XgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778769893; c=relaxed/simple;
	bh=81AdJ9aRTzOJJqU2TdQl/B8BJAQ8N16/IwPMnrxxsUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ToY42AYT6WhKyHuchW6vx3zXryb56YI7G/TQa4Yr6wpmQceg3wbH17YlZDcyg5cJ5r9JAVYWEXxgM78ARRWOBHegDacJDxcD8G0KSa26tS/jEIHfwthEE/s1kmPGr8kvqTOzE4joVyhgERoqwcEaUsFK8gpuKKNae/wOrdc6LzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=RQRVpQIo; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Ep5ayLLk; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="RQRVpQIo";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Ep5ayLLk"
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 523281400096;
	Thu, 14 May 2026 10:44:51 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Thu, 14 May 2026 10:44:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1778769891; x=1778856291; bh=domnWjnbMv
	tiJGp9+4m4p0POsvK24z2JpHaa15/ADNo=; b=RQRVpQIo5AzZ9Rck+3c2oiuLh4
	N1m1fw7L1o46W9OVPUxoBCbrBlmuFsdPFV2hkATM8WpRyXjfO2vzVaOC8jQJFmWD
	wVGCAjvsVSop8Htr77ekiX0Je6dOCBN+4Xjje/w8w7zyv2L8ijxTv0VIfNtY0QIV
	jLAiuKnkiNK3AwPShrt95t7vsUbKDe7Ap3XA2PCjNuxupM2DpujUimlqn1dorZy1
	fhn4O9h1m1kxa3IXkpbM9RaQxBJLIXIiszu57G20ElRgL2uFMGBj2dGSM5Yg8qAb
	e+49N8MdF9WtnPTET/0maOcSdRg76zO5EuA/XfdTdR+xIyh4dtroPsFQSQIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1778769891; x=1778856291; bh=domnWjnbMvtiJGp9+4m4p0POsvK24z2JpHa
	a15/ADNo=; b=Ep5ayLLkGIIXQFIVqwMd2EZF8CIoSQCEmnKgib5bv+TyXa8Qrux
	gAivFxDEsR5F2CVHeMgF0rChPBaWcfDyREKbvSHh5g7SIkUjzV+qKwdeolWPIoFb
	+2b9hSaece9OWB5q56PwPd1xZNu4HB7NUPE9iMAYR+x25Jba9M7JCCgIVjmPhMBt
	NodzoeceKqYISymSsfMtXZk7PrxzLSKcEwgqI7NaGoiaY5hJc7uUnjB6GtMWXOkM
	XDKm/niYRtW2bk/Z8eVN59CcYL8GSjUO0SyjnNuzbxHRZHDeKVwAOqOGtEI0kejy
	Hzn5ZR1KUHe0ygbpkmAy0kim4pCy9Inym9Q==
X-ME-Sender: <xms:498FaoHgBn76z_TrgdFlJQ0DlPygKf_4udxhj1PxnBjCrY0qz1y-3w>
    <xme:498FagZ49jnmA2LP4nU36dGu06r2YEzizwD3jaivssnZmoMVkPad5Qfd9j84caveq
    e0SmHKnv1fFpiEqb7DxmELUBS6CMvzCNjINNute6B0YfgbhhDIoSQ>
X-ME-Received: <xmr:498FaoU824rym-MzOpYYKwHf3N9MqEUoMilYwqmU78A-3yjyeKzVSyWYYa--zqX7CW3LK_HSNF3-cEOMhUD7k5r4opQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduvdejjeelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:498FamlgPa2DgY-QU2B1NGUuNNyR9WOyRwgqwoLn0KE8vJjTkM4OQw>
    <xmx:498FajDxyv7lNFwjXDy2jKx_Tjo7QoL-Sg4E_XNcEh4lm4MzeU8Ftg>
    <xmx:498FaljPEapFPIZ2OJLRpTqDrNzM2_ZB3JksFrbhfK0yjYigj-E0IQ>
    <xmx:498FagypwWFOPOgzQQZLvanyjsC5-HIh9BrWEXCqz0ZVzFqVT5slEA>
    <xmx:498FanhvPBgIL_tYVLU1vMXBhmv_8OThY68tEQLy6w2_oo2GYPQ6MHGC>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 14 May 2026 10:44:50 -0400 (EDT)
Date: Thu, 14 May 2026 07:44:39 -0700
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/7] btrfs: zoned: document RECLAIM_ZONES flush state
Message-ID: <20260514144439.GB1197064@zen.localdomain>
References: <20260513123445.43197-1-johannes.thumshirn@wdc.com>
 <20260513123445.43197-2-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513123445.43197-2-johannes.thumshirn@wdc.com>

On Wed, May 13, 2026 at 02:34:39PM +0200, Johannes Thumshirn wrote:
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/space-info.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> index f0436eea1544..58256a9c056d 100644
> --- a/fs/btrfs/space-info.c
> +++ b/fs/btrfs/space-info.c
> @@ -1411,6 +1411,11 @@ static void btrfs_preempt_reclaim_metadata_space(struct work_struct *work)
>   *   This is where we reclaim all of the pinned space generated by running the
>   *   iputs
>   *
> + * RECLAIM_ZONES
> + *   This state only works for the zoned mode. We scan the block groups in the
> + *   reclaim_bgs_list and check if we can relocate them. If yes perform the
> + *   relocation to garbage collect the zone.
> + *

I think it would be helpful for this to be clear on how many bgs it tries
to relocate

>   * RESET_ZONES
>   *   This state works only for the zoned mode. We scan the unused block group
>   *   list and reset the zones and reuse the block group.
> -- 
> 2.54.0
> 
