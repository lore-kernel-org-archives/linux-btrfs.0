Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.150
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794012840;
	b=qvafbzoBo6oFAnGufYCcdAGc8FgoqrUU5+cQVlQCJ+PvglQsFhNMfGDOJN31geeXVP0B
	 a04IuwnEpon+wBGuhB0LPx50KBbqgHA4TTYxovf4Q2lcOwS3y9Uq/9JgW99LzV2K/CNAD
	 lEUD6um4O8qs+e2m0u6I9XSLmZ5FO6mxLjdXoPlEiK6NjSwWey5Jma1bKJ8RLpJdwyWR3
	 tL1YZWEbYhxNBnjlzm6+gTk+wqkrM8WdRWfl3cOGUpAhG75R4wjYzeHWC4XDiBbiK3p/q
	 MfrMT+Bw2LxOgva0KRCS0w0LXB+0lPYrpvauhn8A9BQyGUDuQSTqL+rNi88fUiMtdmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794012840;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=iXs4Blx/L1Ur9Ff/xrpeRd+pXPRXUTyErbOku7yvKz0=;
	b=mofqXcd89GeW05w7NRiBVqf/G+a/qmWRmlQL4GKfc1rEP3zTpr7LIFl0RnTAUjfP31Jr
	 oLxJrvMEDOB5j5Ien8Ey3IM75Bn425uhJG5/UmaOcGj+k2Dtc8IrrTL1jF/ggy49vfK2m
	 SEeqh124hsHZTnTx+njWuUxQDPkTn7by1X3erUwxdaDKJfQO+0vyRMtQhG2hic4BF98n8
	 qJEHqCqoQTlYQxq9TstAjdK7pdyIfPKKQvY70pTeTMR3LwEj2CW/SrTUImlkE4VUdRKux
	 t+Hl7E3sXhUFGTMjlxSF1q1tsoXmMMMqiXOrFV0IyVG5hnNjZhAIP5d7WcO95eZqQNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=SayTY0BJ;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=OdKNLEsB;
	arc=none smtp.remote-ip=103.168.172.150
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C7E606A32F
	for <linux-btrfs@vger.kernel.org>; Sat,  7 Nov 2026 00:53:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47C7E606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=SayTY0BJ;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=OdKNLEsB
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 66D17EC01A2
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 19:53:59 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 06 Nov 2026 19:53:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1794012839; x=1794099239; bh=iXs4Blx/L1
	Ur9Ff/xrpeRd+pXPRXUTyErbOku7yvKz0=; b=SayTY0BJpYGtA0Gb7ibom0pplK
	lvH3NqC8wlTKD50HlznSencdRKK5/M5kME1lQJ2a+siI0NDkW6WCzrdZWtdUzc/w
	yGJ8oKdiItSlxThzs8UDC7/9NP1PzNLbOIgclcoL7j042TS1vJli3Yc3donGiDR7
	asw4K62yt7PvVyDhC3zIr4L9ds2sYEyg9YUjOnU7moj2R29RsRY4uDzQF78PHh4f
	i1HTLRpdO7SyfnSy3cSOwkI9s0fh7grWH1wxhnpIiJ0+7wtoPRQhX2MVZ8hQujzH
	glVvUsHRvDop0EWiqekfPFmjrN3eDZuKvChDBn8iB8K+os+NNhvU5ElnPEEg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794012839; x=1794099239; bh=iXs4Blx/L1Ur9Ff/xrpeRd+pXPRXUTyErbO
	ku7yvKz0=; b=OdKNLEsByh/pLSSJMekSfcA4OlcqQ0HtLHNq1Hvb62y4vYXBxC1
	seMYAgmY5cBh3srZvIKm+ME6fMoAd/kRHRLVpieROaJj7g2pHjYBn69Z8Rdc7DNN
	yyCR2fgFiUJE8R+qUdulGILbnVMursCHAVfRXDfFYdk59WFOGewIWXVniDkR/YBx
	tlyQQCXIVAVO80jnSagssR3TDBl7Se7qZrAO70M1BdAIVYK8qGqT3fufcyNPmteE
	RWXwDubVw2JUzxrtL1dRm7UIxGOpNpCVcz77sxmoLlxepcL/IM4OwigCm9KQBrJ9
	c9zE3uelZwiJE9lmmETUApr4I4PumEs9t3Q==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794012839; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:Ilc6ODtH4o6ySgMjGaZthd0oCEoY+OfyvFSKwWOhVMviubF
	y+vHFMvP4L/zCuq9xwu3JgJxSaImASEMlVOIE4IB5H5uTBv0kX+xmKE2GHDuT4ha
	t9IIcRUt1zcJWOWjTWG6N528GpOQZNW2KOBBOtKAqmdTQR4EYK7VY3y0B6YCypjy
	4vzfw4BPZeYmQQKWuevCTGXxqOkuNgvbLNDdCvXUxGhKek8ahSH7nZlGKlv0+DQ/
	GYEIz77W2m+dhRQX6/kT9zbqkIFTkQ/hz0MQjXC4/KO2x4YO/nhCVYaio9+PeVBa
	v+zIwv3xj2/GDL9jVz68Z8V9bYUFybq4las4UJw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:wKRybfjfx1WgAKBtsj/Muj36d+2re0IozfTHtseqhbM=:kkseY7OqBd4covF2L1UA8R+mBucXu39WnZbFB1Y/ghg=;
X-ME-Sender: <xms:p3buag9pp0eBJdow-ggduOwxYVmQzKpEXgvIts9H5cExxkdxkibpag>
    <xme:p3buagItUXglZ-mmthgOWcB9AFItk8xARGLnuLWybmBMjtaiI5R98YMuPVZmBMOSe
    YnW8MukeExjyDNzTe9vj8h1BNacm08FSkaOvGIKZPSs2ABYPCeu8M12>
X-ME-Received: <xmr:p3buajb-VZcU45-qPfQeUm0anaXO00MIPRCqdnhQCbDbWVCMsP0RE8H0>
X-ME-Proxy-Cause: dmFkZTFiOjcnUhZTNOLXsS31w5mwj0103BfHrlWLo/FTUTYU3yf9hD56UyRZ4ee5SsRDKz
    OT9qvH0niot26sEgOiA+tLOV8J2nKlWcd6PFB44F5C/07q3Geyje7wgTNWxoX1QSHm/Gra
    eyXZegRM5s0JAUPIvfL8idUqa3kXzCcCCkdc/uR4payCKpfmUSE4P2VrodNLvcWO//EjU4
    dbEqiOIqXx7t9tjGWxLlv6sfzIKqz+7sahCjY8pIhJIqp/LzxQalzUZ6lJYsoVc+2U2Lpd
    852bCmbh0haGdUx88sWcNJ+hoOcLKXhqwJ37uD2byDuya3WEpXKFieoyBRHp8XW/WoaujH
    kRAslCL0Ljvi9BVWNJMujE8o8W2e6+7Z4FgTDSqhAvAd+Mv+F2tJoY3uSCQkLCwKwNp1/3
    SUB/enmNmu79tcpcBdtbmLjc36N4FMA8RnR0UuIPqKyb7LSgW7QU8Ks6eIGSfYb6LhqLBq
    pfZR1hxWO7/4RjeAdQF+rEt9DsHW6S7JgUv+iViURYNqEu0aTy9TkDMVsSYUYaNNP6gzg3
    EwtBh3j3B2LaoCUxfWUWPblZgiqaZ+VJ9JR5Quk2ifXYmrTeEH1EoG2vBsRArmYa31WN3Z
    J8b75y8Jp8Jbe/Vk5cQml2YIFNdrlMYHPGFQJEgr9E2ML5DY6mxcCiai1HlQ
X-ME-Proxy: <xmx:p3buaqJElMi3oA7zSB4dpxXlYgNzVR57e2hCJzvkQZtWLrTWb5bHwA>
    <xmx:p3buapBAhMiyDbq2bv66hXIh0ntDC9acJtRMpXoSEpm7oHU_ar2fjw>
    <xmx:p3buanpeoqHk6nPE1LYt8zKq6I6XN3PGcNWmmJ7Bu7u8VFq_sU4CAQ>
    <xmx:p3buasjfTgWxX6XaMU9gSXm1IS2KrEExKcOef4qM2eDXmNFSXCmJwg>
    <xmx:p3buarhEtn6wzLUQymAqdLsE8746hww0YKB23b37PxaABGhgN2fo6HWo>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Nov 2026 19:53:58 -0500 (EST)
Date: Fri, 6 Nov 2026 16:54:13 -0800
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH v6 14/25] btrfs: zoned: don't count in-flight data as
 available in statfs
Message-ID: <20261107005413.GF401465@zen.localdomain>
References: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
 <20261028182111.160492-15-johannes.thumshirn@wdc.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028182111.160492-15-johannes.thumshirn@wdc.com>

On Wed, Oct 28, 2026 at 07:21:00PM +0100, Johannes Thumshirn wrote:
> On a zoned filesystem, space of a data block group below the allocation
> pointer is used even before the extents written there are accounted as
> used, and freed space only becomes usable again after GC reclaimed the
> whole zone.
> 
> Don't report reserved, but not yet used data extents as available in
> statfs.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/super.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index b424cc836bd4..9bf211916870 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1691,6 +1691,18 @@ static inline int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
>  	return 0;
>  }
>  
> +static u64 btrfs_zoned_calc_inflight(struct btrfs_space_info *space_info)
> +{
> +	u64 profile = btrfs_data_alloc_profile(space_info->fs_info);
> +	u64 reserved;
> +

perhaps it would be helpful to add ASSERTS that it is data, zoned, and
any other key assumptions for this to make sense?

> +	spin_lock(&space_info->lock);
> +	reserved = space_info->bytes_reserved;
> +	spin_unlock(&space_info->lock);
> +
> +	return reserved * btrfs_bg_type_to_factor(profile);
> +}
> +
>  /*
>   * Calculate numbers for 'df', pessimistic in case of mixed raid profiles.
>   *
> @@ -1730,6 +1742,12 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  			total_free_data -=
>  				btrfs_account_ro_block_groups_free_space(found);
>  
> +			if (btrfs_is_zoned(fs_info)) {
> +				u64 inflight = btrfs_zoned_calc_inflight(found);
> +
> +				total_free_data -= min(total_free_data, inflight);
> +			}
> +
>  			for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
>  				if (!list_empty(&found->block_groups[i]))
>  					factor = btrfs_bg_type_to_factor(
> -- 
> 2.56.0
> 
