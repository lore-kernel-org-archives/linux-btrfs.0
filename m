Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6795635E931
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 23:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779233221; cv=none; b=Zh1tm/WaWdUDs0YY7P+BhxgAPeIaQ6UvV5ec3yesXyj+DeakZWHLEzzzbRn7c4cCy3pV1PnRck1Vdi8amxsaudtW6CaXWSkOjvAynEY7/wyssfjw97SrxM8S4SNDPTmB0KQrh4wdLB1XJNW+fHoiyU7TsgErEAysCUzf3usIAfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779233221; c=relaxed/simple;
	bh=wWwfxKPNQla4HJjh/M3GE0VEP+7x2zu2m+6qZii1tGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I+4PvYmqIShXzyErKYR/Q5goMZKlddfZj54GSmUkMmsOYg2QKLc3aQVN/n6ANf0qyF7gCjtNqnhg1GXQ8vL+SVZuZ8kkStB7LhaT87QgvsfEB0Ts5uXId9BP6oN9lw/2SkH+4cBbp9nEVUNBCtFrB6RfBGsP/YCz32vNhrX4K/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=Q7KTnm0e; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=pOrRuoz5; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="Q7KTnm0e";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="pOrRuoz5"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 9B8781D00129;
	Tue, 19 May 2026 19:26:59 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 19 May 2026 19:26:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1779233219; x=1779319619; bh=6wnE6B7CMP
	iHTieCz+Vc92agk8hrbv0AXkXCoFdMa/w=; b=Q7KTnm0eGbIxozkI7tt24hYPfN
	J/VYWMJ9dtG41fUxXQUbEKDHCnGPAUwc2tn+CKt/NMW8uf/4yCqM4BOGabgRe8DK
	H1MArTRV8uYNpE9a6UhQJL4akjiA29LqXkUS3F/xVe7Lh514/At/Kv00jKOhTchj
	MjjBhPaVGCFX+/BljN3D8+yCINve1UYZ1hJJTx8XIpZDS7UGUjH0XhYWSGPcFDQv
	x7Uf/pfvvaVg+D6HHk8ZLwRShHEseDSdWKKqvFeIPhczf7iD+kS1mMtSgM7hd/Ke
	SwyKLhzew4Y2yCZAh8HYhPahCq1ZHEbHks58j7xqsyJu+jnHDEwg8G0WJaYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779233219; x=1779319619; bh=6wnE6B7CMPiHTieCz+Vc92agk8hrbv0AXkX
	CoFdMa/w=; b=pOrRuoz5yCRRWhI83luERiSWEwuAO8hLYnb68HJDcDc5s70KrZS
	v8SygepN20iNdR58lBzW6nlSWz5Mvn+KTO8AfKggXKbz7ATdS3dFCl9VPHrJpIJH
	GPhhQpVHmbA2CtZv3ZMQX9vLysDbsfjjDekVvsSNrgjK2prdsW86f+m3qTiUJqXM
	cCbJkWxufONa/uqZUfLax0SQYOdOhyDYoUkLwql8a5HDrbH6T2rCqVwte/2waMxk
	TPX9ezJdNP3eSyh0yd/eeHMkFRy8QKor6hc9zq3ErDk+kVFfV7tBUwIOGxY5g+O6
	orC+66LqWPa6v/0FRi0g4GkVpNSaQ7u9W5w==
X-ME-Sender: <xms:w_EManTUkTOAJDe-W9k-tOrbuYpGT2jiczLkkBwNDuyWWGpcBq-VeQ>
    <xme:w_EMan2oUPs-oZnWA0nBi9MO5pteFWPS7T6Sc9XswK6oUnS4NZ8jT0bqPQm7kRdWP
    l2mVylFfQ1BCzDizfiLWqcRmo97jGPY4XausUxVT2fIy2fI8KWAVHg>
X-ME-Received: <xmr:w_EMajDJgMW70E2ZmZGjLGVrhxaKDIMuJkeeWDofF59uN4jweb5OpTB00ngLsqI7qyj4l3_VOVEAMRF5F3V8ecKFEtQ>
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
X-ME-Proxy: <xmx:w_EMajjnv1m52JOCAVxAfVo8EE009ynhQ0cf5PZRZdAafOWX3Nh_ug>
    <xmx:w_EMalNRUICpiuBxkV8Nsr6BSc4GQDGSbBg7cL6EoKm6dXflRACV8w>
    <xmx:w_EMaj8wf54fT8XkV0SuAPqwAAaUZdmbHngf_KV4Cu4CgDdRYAfhLg>
    <xmx:w_EMamd1V2DoOg3HrhXQMrU2_W0ZNn2SPWdJvB351mQfJMR0AzKwnQ>
    <xmx:w_EMajP_MXa5y5G_qu93VdIODZ2RV1NSP4tPLHIdWMf9AIa2bkU__W0r>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 May 2026 19:26:58 -0400 (EDT)
Date: Tue, 19 May 2026 16:26:59 -0700
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 2/5] btrfs: zoned: decode 'RECLAIM_ZONES' state in
 tracepoints
Message-ID: <20260519232659.GE718937@zen.localdomain>
References: <20260519154902.223445-1-johannes.thumshirn@wdc.com>
 <20260519154902.223445-3-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519154902.223445-3-johannes.thumshirn@wdc.com>

On Tue, May 19, 2026 at 05:48:59PM +0200, Johannes Thumshirn wrote:
> Decode the 'RECLAIM_ZONES' state in tracepoints, as of now only the
> numerical state is shown in the tracepoints.
> 
Reviewed-by: Boris Burkov <boris@bur.io>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  include/trace/events/btrfs.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
> index ec1df8b94517..ed272a100fa8 100644
> --- a/include/trace/events/btrfs.h
> +++ b/include/trace/events/btrfs.h
> @@ -101,6 +101,7 @@ struct find_free_extent_ctl;
>  	EM( ALLOC_CHUNK_FORCE,		"ALLOC_CHUNK_FORCE")		\
>  	EM( RUN_DELAYED_IPUTS,		"RUN_DELAYED_IPUTS")		\
>  	EM( COMMIT_TRANS,		"COMMIT_TRANS")			\
> +	EM( RECLAIM_ZONES,		"RECLAIM_ZONES")		\
>  	EMe(RESET_ZONES,		"RESET_ZONES")
>  
>  /*
> -- 
> 2.54.0
> 
