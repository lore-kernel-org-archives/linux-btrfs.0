Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3821C2F2607
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 23:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779233179; cv=none; b=PU1b9pM6VlHMrkhSq052KHNXNoVYrP4xUd43SCLvqhF5g8HZtXoAO3857qiFvV0x/U4rbKgEBDR4UJuU/hO9yOsVC4/w6XOG2V4lBnzZfI0cR0TP2H5shuGsybLtEU28wh44YVzRsLEwR3N9lfBYuwDAPLVMrYxRRrZL8N+ub0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779233179; c=relaxed/simple;
	bh=UDYwEEuJRvi4t5qwA7vlSbpIhmiNTs7plk5ZgD4j8uc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kJXrfmNLNOzeJ3bQKAXoK8oZUo9RFAJZvmLf0TUAukueFxn+u2OJ9htG/lChVHUm6zYc2hBjlDhkERnRSpe4l6Zx31KDNFq/d1nA5OiLmouWbZvYz+91tt9pbU5fwSvYWWhq6f9wqCeEshbqguxLG8zzMBxSZyY5TsZyE5KKZyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=O0ZTA3W9; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=nb2A9tiX; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="O0ZTA3W9";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="nb2A9tiX"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 675F77A00EF;
	Tue, 19 May 2026 19:26:17 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 19 May 2026 19:26:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1779233177; x=1779319577; bh=ovrP0Ev935
	xcedFbKrbm5qiE8RVo7FDVCQXuOEBaNMU=; b=O0ZTA3W9dr3bFOyEhvoVKNs2o9
	iQdexfTGcwZ5Rybf8lmuSBqKvcZU0itnMaXdYHIzl+xYOm7wFaFp1zUCxu9E+uyl
	HX1W58yp09430/tLgqeO+tYBaiJcxtxx3S+/UcTbPTKlQZqLCop/ZdsBBrawQWUs
	zHeT/EDmjKCsmqfUnakEOHDyBy3mYv/jmHS8C6SEP0C/x8M2hPQwClMI5XqPpYAs
	thaUqsRAvCTup0LEUGqvyRrdqtwLp1dKQtGoK4wLQmChYIuK/RNOVr40qLYVqxrc
	4SsqBHL9jW2/BERSqsAiZtymdqW5mq+odjf/9dDiX/e8iwSQTKkLcYUpEAKw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779233177; x=1779319577; bh=ovrP0Ev935xcedFbKrbm5qiE8RVo7FDVCQX
	uOEBaNMU=; b=nb2A9tiXBU21oofntPT8OJfAXyLU8mMOifDZXHA4T3w0pb3UD+X
	Z1Pj1oxvZeM8DlgSt9HCtvJdFEkFI7EkoZVWgq5IRg02499wXpDqHH1M0jNic58o
	65pxuNzOwtlxW0Tic9u2aN5s3ZS04ulMMzi6nrpcLPJfx8b47YWODXattOxeIkqS
	IPSL28UBhXZRTU1pJ4FVrLivZydHObUYH1rkp8GLawVCIxJTrUW+eRXlfpnQyqPr
	a2v8jqw666Hx33KGiQOBX3v77o0zUfVILEBUYhGXRNgnlnxw3DOAaaKzInZgpoSo
	vla8zglLqr8fhgQBIk0Y9wUSyB4LsS+U1/Q==
X-ME-Sender: <xms:mfEMagzODKXOPCgobH8RO6MZx5UckJm1oTbPJW1664wC55a_CRoFQQ>
    <xme:mfEMajV-C7HvNW7NvqLbIBsub-mMzvR0skwjE55f8qwJg9U_BDAxyewRuW4RClIds
    iaB4p8F-MslC4lPyVA0FFsfq9RfPJuQYsvcnasn5V0oxiRALHzDiwc>
X-ME-Received: <xmr:mfEMaogYsZek3rZML7qiJv3OoMHBl4oBJ8FFfVBi9H_GrQwQyg0DQqTNW6HIeRgYHephGB-IHo9PoW6eAKtOPd9uV3k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddugeeftdejucetufdoteggodetrf
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
X-ME-Proxy: <xmx:mfEMarC_urQ6mbCHSKUjA0ZYPh30sshFZFtPPm-Y9vIKn_RhzaS1Og>
    <xmx:mfEMamtMOjpP_3CQlEK9PGrjdtNzoF4azGPQGiEHeh2to_HGBUStyA>
    <xmx:mfEManep1kiFgaby_d2tZZaun9GPGilRuk6O_pqk8jcs6H99poIStQ>
    <xmx:mfEMaj9iHs7bBsEpdu0qK2t5xe88OOsLWyAGKreRPodivWjVeb0myA>
    <xmx:mfEMagtHmGf1keJykJgCtol-LaHMzt0CF05hP2GJiEq2SVO7muxCa2zb>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 May 2026 19:26:16 -0400 (EDT)
Date: Tue, 19 May 2026 16:26:16 -0700
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 4/5] btrfs: zoned: don't account data relocation
 space-info in statfs free space
Message-ID: <20260519232616.GC718937@zen.localdomain>
References: <20260519154902.223445-1-johannes.thumshirn@wdc.com>
 <20260519154902.223445-5-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519154902.223445-5-johannes.thumshirn@wdc.com>

On Tue, May 19, 2026 at 05:49:01PM +0200, Johannes Thumshirn wrote:
> Don't account the free space in a data relocation space-info sub-group as
> usable free space in statfs.
> 
> This is misleading as no user allocations can be made in this space-info
> sub-group. It is only a target for relocation.
> 
> Fixes: f92ee31e031c ("btrfs: introduce btrfs_space_info sub-group")

Reviewed-by: Boris Burkov <boris@bur.io>

> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/super.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index fb15decb0861..a0dbc0d2213f 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1739,7 +1739,8 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	int mixed = 0;
>  
>  	list_for_each_entry(found, &fs_info->space_info, list) {
> -		if (found->flags & BTRFS_BLOCK_GROUP_DATA) {
> +		if (found->flags & BTRFS_BLOCK_GROUP_DATA &&
> +		    found->subgroup_id != BTRFS_SUB_GROUP_DATA_RELOC) {
>  			int i;
>  
>  			total_free_data += found->disk_total - found->disk_used;
> -- 
> 2.54.0
> 
