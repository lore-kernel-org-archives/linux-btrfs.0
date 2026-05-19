Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C659352003
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 23:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779233030; cv=none; b=CoFqwK8b7nko0mCr4xE+xb+K/mnQG94yl6scPmV3IReNfJtbpqK7i5RRAZhoCzKrt7zYhsnwjvMyDORdxkGTdhjvlUKDKcRLkOPjL/j6ZtIsGk0BBaCks3wXvyRxmygo5B1pLRCbK+fLptY2Cqvfj7r4L0zvkR5j4ujOnH5GL7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779233030; c=relaxed/simple;
	bh=TDn7+VBVYXpIkstLhgBBtV6lOy694Jy7jMvwc52sI2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tLJS7NWJaeLSTzaDYGpRc5WMouWOmU36A2FYzKOFKkrTx2jMmO0SbW5x4dE4Uw2f6RW0v2m9icmgB1VZ9W2d+zNqo01Bvme8Zt5BQwAQkqeUiHLOcx3Ki5BWgHMg64ihGsETvwKlsxosruXPkHPCRIcFOj7EQidJ3Cc/vBocDME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=F4AhG8Cu; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=bvOnffv+; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="F4AhG8Cu";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="bvOnffv+"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 88DDC1D000D9;
	Tue, 19 May 2026 19:23:47 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 19 May 2026 19:23:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1779233027; x=1779319427; bh=jgZHyqy4T5
	uPCUd5WSymkYEB1aFjy1JN7JR9pVPnklE=; b=F4AhG8CuQKpVhNaVleFHcMDLmO
	XBfNZeiYk/zBCYZR2AiZ7C9LLtTaNbk0I5QS58Sh+/wdI7kCfoVHEmBC645jD9kk
	IBVpQ3xchZ6oaw13hQCcCPYrQoQNpX9yMxoKL3faaNMyFCwCze4mDK2vgMID621O
	YTrPb9ynlu8P17tq3+CSwr91EZKD5Js33ebyHxNy7Dn3nr7Cd2OyA9fipsDfpSQI
	afqoWRelSJlrBqH7fV1ZszkqXAhGhXmBjpyVbYgDf4rcBgy3+SinlhXhncCeWALU
	K9KDLbcagcBPMsv3Mg6qYLhW8BL5v0SqNCooPVxYwTJ1j6lgDcwc2fsI/stg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779233027; x=1779319427; bh=jgZHyqy4T5uPCUd5WSymkYEB1aFjy1JN7JR
	9pVPnklE=; b=bvOnffv+kr0N9K3jd1+kBjQ4p+U38H7Aq/bN7N3ebVGWsSun91B
	BCLtFIe+I/DnSDrov9f3E2pmnUJ1k3vZTNKmTwevbqytAsEGjiSnGUFHDAbUWNBU
	Rnnx+mBLUunzzOxQf9VB5hnSzpJNtENco93IYtuBAuHGhwF4Z/k3TzBy9OHkiIbG
	vuDKmTODvnJc53dKXS7+4DyPXb4T9duxljbYTvuK913mW+FlcPIJ8VihwjM64+9R
	AXTTCuuyKNvTSD1iE9NLrsFmXrIJ9XgHp7wtqRnreDfLl20zkKpKKEFMqTqrJrsQ
	+bpNZey7zvEC1CK7Kv7++HSo6ghSbX3YFrw==
X-ME-Sender: <xms:AvEMasnLLfz67zlOl2f3PSqrQDe99jg8lEULrFO8202-1eTZ1Xqrzw>
    <xme:AvEMaq5VSz5wmplAjtzx5drxoXIG-XvOphb_KeSRGCFqXiqhQHlLBUqsaL2v7l3ha
    hqsx0ZdXxLXDcjPFAqSB5zyjN1qeyjwuZTbSi-fHMsyk_4FW4-Pyp4>
X-ME-Received: <xmr:AvEMag2NAqnVGzemauF-1mzR6qcUPkn4NxVLFGaY7-4gj3Lfg3dRzQhqAoxs5DSI2ffbVG_Sxk6NrcaEHPE5cflxIKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddugeeftdeiucetufdoteggodetrf
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
X-ME-Proxy: <xmx:AvEMalHatANGu0AdZFY2ZWFf-Z451GZOEzAz5EfuU7UyY7fZgOKIog>
    <xmx:AvEMavhIELm30aa_2V25yQRhjLUuQbwLGzGrNDOK7zn41vYRm4XTdw>
    <xmx:AvEMaoDf1aLiGyOeg_JXyZ0ah61gz_s8cAwBgxIGvEkChtlxdVE8xQ>
    <xmx:AvEMahR6oAjWNcWBMi5IV9DInO70TnwKpRBZdiZCZyaGww3t-SKfTA>
    <xmx:A_EMaoCh3vD9Bu60OghuUZiTSPmPLLs5HPOsjTcdLpVs-pqCd20mbjjR>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 May 2026 19:23:46 -0400 (EDT)
Date: Tue, 19 May 2026 16:23:45 -0700
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 3/5] btrfs: zoned: always set data_relocation_bg
Message-ID: <20260519232345.GA718937@zen.localdomain>
References: <20260519154902.223445-1-johannes.thumshirn@wdc.com>
 <20260519154902.223445-4-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519154902.223445-4-johannes.thumshirn@wdc.com>

On Tue, May 19, 2026 at 05:49:00PM +0200, Johannes Thumshirn wrote:
> When searching for a data relocation block-group on mount,
> btrfs_zoned_reserve_data_reloc_bg() is looking for the first empty DATA
> block-group. But it first checks if the block-group is empty and if yes
> continues the search, and then checks if it is the first DATA block-group.
> 
> Reverse the order, first check if it is the first DATA block-group found
> and skip, then check if the block-group is empty. This enusres that there
> is always a DATA block-group set as data_relocation_bg in the filesystem.

Can you help me understand why you want to skip the first one? Is it bad
if the next real allocation just has to allocate a chunk? Why does the
data_sinfo need a fully empty block_group rather than just one with some
usable space?

Now aside from the general question, I still don't get what this change
does or is for, it kinda still feels like a no-op. Can you be more clear
about the case you are fixing?

Previous logic:
if non-empty: skip
else (empty): if (first): clear first, skip
So you skip until you see the second empty bg

New logic:
if first and empty: clear first, skip
if non-empty: skip
So you also skip until you see the second empty bg?

Is the relevance once you loop around after allocating a chunk or
something?

Assuming I'm not missing something, I think it would make sense to simplify
this algorithm to something like:

1. Try to steal the first empty bg.

2a. If stealing succeeds, do some arithmetic on the data_sinfo.
    If zone usable is 0 (or < a chunk?), allocate a fresh bg into
    data_sinfo. If no arithmetic could ever work, do a second pass?

2b. If stealing fails (no empty bgs at all), allocate a fresh bg into
    the data reloc sinfo.

Also, when we do have to allocate something in the reloc sinfo, I don't
really see the value of going to again: with the space_info set to the
reloc sinfo instead of just setting data_reloc_bg to the freshly
allocated thing directly.

Thanks,
Boris

> 
> Singed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/zoned.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 16dd87aa06f2..dcdd7f8d8406 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2784,14 +2784,14 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
>  again:
>  	bg_list = &space_info->block_groups[index];
>  	list_for_each_entry(bg, bg_list, list) {
> -		if (bg->alloc_offset != 0)
> -			continue;
> -
> -		if (first) {
> +		if (first && bg->alloc_offset == 0) {
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
