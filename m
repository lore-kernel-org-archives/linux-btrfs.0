Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.159
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793994583;
	b=NtwT+Y09xLmVVxksbmHhDhWjgXVNH0IKZ0/w2qWeYGDbq1AegG6NvALURTQK7ybxMgBs
	 O0U0YozDDkgNO2o6ZjI20dB/vbJiAt0v5FLwpIdPc8IkB/jEVhkaCC8taCQA0+E+Sy3QJ
	 nth1dIpupcBraYiAA9BvLAPp/DgPEu6vEptpbeB2Eq2iNHdwkgUh8vOcczF/KeCCTTcOQ
	 XXjSSHHIa9rtqeoFA+ImTQD6XOixAydoK0ZA0yOggivZiW+DOHHYqfKnKwj60nSTSBp4t
	 4eVh3zU/jZgluwn9m1Z4HgoS+TWcS0hi3YZtVnUxjMQcSiYeY2En1gpWWwNHbdmWCkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793994583;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=hxZtpdYiCJaYkq7FjcdAdhfkjhBoV9HHfNoA8jtJc68=;
	b=oiC1jLdsXvGYT2tOwNtz2+ndKHR9bC6wwSJpEfgjNP5t30XZEBZvCxUjMTH7XlH7ZWUj
	 DBnkxO3DGCohicDCuGU1jADAKAP+9CjEdPVJqklssCELQuBQXkxXBGaGtbO+zuLjZALcs
	 bv440qIohBmwQfotLvWBLOF2qlhAhuNmbfahecj3+X2qC8ZPPEW+nRuzCCmVXn9VneIk6
	 PFeCVHHy8cAUGw9ytZjzQl56jxsSuRERAjKIJep8rhGpk6hFglhWe7LVnvTvUcDDGPzgl
	 1k/hd2WLT0/WTZPlf1eH2HX+40e2b67F+gDhPtc3uS6VHig5cl1n7Hvh99hB8YukolQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=aMDoOe4T;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=yQqJCScb;
	arc=none smtp.remote-ip=202.12.124.159
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43B7606A329
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 19:49:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B43B7606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=aMDoOe4T;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=yQqJCScb
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 0C27F7A018B
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 14:49:42 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Fri, 06 Nov 2026 14:49:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1793994581; x=1794080981; bh=hxZtpdYiCJ
	aYkq7FjcdAdhfkjhBoV9HHfNoA8jtJc68=; b=aMDoOe4TuUySwSzXfpuPHPU4s1
	4t5+1PYt6iXzHmpj2Y2/WTHPs+ewlEn5kZzoieE/W/pw/Ax8+2u0+FBT7od+4Ai5
	Hzoc+iCYRsuXeMwWi1cb3x0kGgwuvU4qWjpvhVEAV/rySJt3YEMBo8Fz5Q2NRt1C
	BkMFRSfVRYrO4hpCRAJLCe6YOTEMV1AeUMbSnLf9KMyXnKapIE/JE+tPxDQRqDBq
	7mkIeS406mbf3seKWfI272gDN4E0tKuX2+SazMsswRWM4k0ErZlUn5Uni9sYTIix
	MlS4YjOQXeAViF8KbZq8VCnUNRUJcm+hp5K5455iYJEvuTOlnhThH1RUPETA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1793994581; x=1794080981; bh=hxZtpdYiCJaYkq7FjcdAdhfkjhBoV9HHfNo
	A8jtJc68=; b=yQqJCScbIgE6X/Y1vUhOiBdkYGlKr6t4a6EdRUbBCf/Mb/FS02I
	oOwWelXBmXHwYQ45DSBg2MXYFIuOzP3+52XlLQ3oRaUa82OwTMsJHh9UlNTnwLf3
	aJXgwXpDdY1F2q0m3hkiqNbJifU0BtmSZVVEElE4MO3xFa/0s01/h8p3HwGUHbmh
	KBybK7cdcs0fnDTVCoU5SuywWjv2IsKWvMIDowGUUA2CqQ09VOK6CXpwyvYemGNO
	C89B9F6kgS56gKxz2J/F3/0q0PfvwwAmIclBZt0VsUXaOweCQIsObhNR6RjHP52g
	8YNYKDHIMdKv60cAZ3JfU53hSBxlC/0GZgA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793994581; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:ibSbXjJur2QNZhpeFTm2EhEIPOYLcEAv7J0gLzTs4dqmgcm
	iLuvdL+260KhsQIH71GRc7HJMpT6YAsVmF/4Eqe9BoL1o6GKCV/A68FdAAieFvAC
	R7tdxCDerM437zTKzsGaUfilC2yv1yDEEz2HCUBjBkZq6+4zgq98HI+buIWJYQ/H
	qtpEP9tZv8s3LrQpIHmbXFP4C48GUDukpHV9e3QEoGm4qM60XuwFa4KnCnIip0UY
	c3mXze1DxfCFchRUNr88VeVxXWQ4VgqcRNTS3gY4iqYrd+qwFt7G68fGgevwoDLs
	9LUg6sYsUopuh8LSzouc2r35c609xGDj+YCTdFA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:oWiZD4uoNQ/Lfw59PT63jL0qoxRnySPlUfMZ9AX0j+U=:jmbA4QPL4hupi1iA7jaJf4QUuDyrZqga60gGKIirRf0=;
X-ME-Sender: <xms:VS_uamryQNO5Kr5mj3CJtZr8jwaOe9AZiGnyKMCzE3IicIjrK1g3bg>
    <xme:VS_uasFq_GO7ZXYOFOEZnTP5KPPel8n9utVJ7pXuthACkY2FZgdOE-U7fsb0j27s1
    rdRgSf_MpX5oJj2jrBOh9uSaBOct407-J2K8ZqNsCV4ngo683g41D4>
X-ME-Received: <xmr:VS_uaonizFYq4QEPrnniG6GRnwvJlB7Q9kUDt0NQ1BNX0olSyLPJ8bVL>
X-ME-Proxy-Cause: dmFkZTGm/2AMWpUWu6UHqGoBHifR8VlOEt/VGxOEZdJ9xyNzGKZHsWuHPI5F1lnU3whT2Z
    +iWpQCOUTLdVW2IZwdwlhq2p8L1QGmZKndcKFGyIlCciXIYqxcEOggee6yblpfHQp88eeB
    XlNJSFW0hZLDpXESu84xmuPAubwYNiPBGHlfvVWwxja4Kl6Qy0dHZeCdYpB+zkXhmsp9Fn
    8/uzSbouVK1qE/Y7HWM93Gi9GzJTzS+Z5bxviIhla1tsHYDFJmUgxCV+aQJBmABmaBkVmD
    0vjWeVeixip+UuP49djnLmbfE2vpibCN9uZiK9p6ba9UU9UzCRPqwpgGjGjVzW4kueWUgf
    97GO9WZx/8M4tZd5iTuOMz5t+SqQfuoRv3528W7N0DQFctn1xKBOEWq41A+R1xcIex4XmB
    adLNdvzzqFKCseehSeHEU7ivj8LUZho7ddsrzo8pcpCKGGNq9MMHrot9DnFkfFY7xbhfsv
    bFeAjSaxAzd/1LZQFCxFUs8STn33egOqNvs/mfPwaNJeQOKAkm+juuP2jcE3SsuScESNg0
    5QKhqegYCiemYAkqEU0Rera9vcfKy30iXGKUt3CCPSaLvI/7cEa+LX1bDvMCSBR+AZUDe7
    fLBqRSIIOl1fBRxzJ5g/MoyRVdutyQAvjvisdQ+AZOHvZTjE9XFNeykJ8HdA
X-ME-Proxy: <xmx:VS_uavkN2pXwk3iLKthmekNxzzpozWuyuP08cjcsT31HsoNie4JRjw>
    <xmx:VS_uapskU_Cd7a2lNxvI7W7Bpuhdm52eySF1u5x2LgIalbtFeWo0hg>
    <xmx:VS_uailZvzmYxZmAtYrQEcl8-8N4KXuqrj4UJ8xXgXWIu8kxhY2eMg>
    <xmx:VS_uakvWMq44MptYGQh7yZ9ChfblSHXE3m7bE0S0dGyNp3zzLAb1UQ>
    <xmx:VS_uaudC6ZJDbJASH4_2NnAkx0tRMyZLMCFhgj2w_8H4nEmh3yWf3BGY>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Nov 2026 14:49:41 -0500 (EST)
Date: Fri, 6 Nov 2026 11:49:55 -0800
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH v6 04/25] btrfs: zoned: never activate conventional
 metadata block groups
Message-ID: <20261106194955.GC401465@zen.localdomain>
References: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
 <20261028182111.160492-5-johannes.thumshirn@wdc.com>
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
In-Reply-To: <20261028182111.160492-5-johannes.thumshirn@wdc.com>

On Wed, Oct 28, 2026 at 07:20:50PM +0100, Johannes Thumshirn wrote:
> Metadata and system block groups backed by conventional zones only are
> written in place, so they do not need a zone to be active and they do
> not consume any active zone resource on the device.
> 
> Make btrfs_zone_activate() a no-op for them and skip them in
> btrfs_zoned_activate_one_bg(), which would otherwise report progress
> without having activated anything.
> 
> Such block groups are still marked active when they are loaded. That is
> dropped once they stop using the append only allocator.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/zoned.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index f2d99fe50ebe..554688fc7030 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2458,6 +2458,9 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
>  	if (unlikely(btrfs_is_testing(fs_info)))
>  		return true;
>  
> +	if (!btrfs_zoned_bg_is_append_only(block_group))
> +		return true;
> +
>  	map = block_group->physical_map;
>  
>  	spin_lock(&fs_info->zone_active_bgs_lock);
> @@ -3070,6 +3073,8 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
>  		for (index = 0; index < BTRFS_NR_RAID_TYPES; index++) {
>  			list_for_each_entry(bg, &space_info->block_groups[index],
>  					    list) {
> +				if (!btrfs_zoned_bg_is_append_only(bg))
> +					continue;

Is it safe / accurate to call this with bg unlocked? With racing device
add or something? Seems relatively static and OK, but wanted to double
check this is justified.

>  				if (!spin_trylock(&bg->lock))
>  					continue;
>  				if (btrfs_zoned_bg_is_full(bg) ||
> -- 
> 2.56.0
> 
