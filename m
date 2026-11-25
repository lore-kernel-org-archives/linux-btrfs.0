Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795648355;
	b=iRG/6+JknD+CtEdMnPEy5K+9088Ql2csoi78s1lP1zlU49qiswu5Z09pa21E6jonXEBn
	 51s8ZGCwXCs5hPd2KgbKKftp2qjMd2MCUnGZ1KCskpjF/oOegdaGCt7VrQQEC+i8hALeg
	 BJJPDtzK3xPvHsI9xUhm2CCa4DL9/QUxDrdp9EvbcQE1M++C2R1W8gHGRJq4RGMSTpW7w
	 pER6ZyaK76Zu+w+5qBXKCapOnOxH5N2IXZzMYK6Wi2ZjMY8WUw78PKjyWIrUd6gOP+rGi
	 51lowj8xICs0sNChNfU3YZowTcR5woxY51PLuVX3UGt351oagm9B3YpQO/3uquFM84w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795648355;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=N1vTL4fthNXkigMsGEK1ZFGsQbWfAhF2CfNpgeoLRZ8=;
	b=okSTL57sKOuKT2YnnkFoCJFssBSnfPJbJ7HJIfHs39wVP1Jw5Q3i753SRLuoViCXEdCo
	 S/7xGS32xjTjxxBqECuyXHh+uf3xuHdpROmSJLfen8zm9xjwuFWN0cFURlE5Gsh7/N/Sh
	 kNdaSVaDBjJ9BDR2XF4OUdyd6oumbJ0wUNeO3XM4I1118htckP+i2JgMxMlhMsvE4q/Hn
	 L3slYOqGKnEFtIKclrL6F5h248Efxw7Pg0AJP2cDBpslVKcQPA2jKNDFPRRSQZgR2IKSe
	 t9+PvSTFlj3GfQsb08vv68p5A8boAZ0ZS1BV+XBO+yFv+8Ajb2mnAS6czvqQ+d8sMLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Hop0mw+Z;
	arc=none smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF3A606A33A
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 23:12:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FF3A606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Hop0mw+Z
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c516a574bffso98177766b.3
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 15:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795648353; x=1796253153; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=N1vTL4fthNXkigMsGEK1ZFGsQbWfAhF2CfNpgeoLRZ8=;
        b=Hop0mw+Z4QE+oHC8hh6egnjgl7mzCTmuAgYe+46if1fjaLhJnmJokZfZQciAKb8cy5
         0tHE8+ZPaa/apDxTy8rMVcrq940Kja9/dycCd9CzVmM0eXbbBNozdwVZPc3+ZxNYprKx
         f/h7GSTlSWmTIyKF2B7Fuirnw33Wx1g2hKCecsyfsIxOcJ+TSiMy/CfCvVgeeviEHn4g
         N+1UIkDiKttOLrL/XXSaqqFhW+rq2ONGQVl6IC7i9QJsbUE+8lbPgutVjHnD+HoxU//n
         UU8Au/p0RPpztXVdr3BOb/SHzQLupn5Hm4Tp+V8JAvKQhFyCmPAF6g6Vd6/3xLGD7nqz
         p1Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795648353; x=1796253153;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N1vTL4fthNXkigMsGEK1ZFGsQbWfAhF2CfNpgeoLRZ8=;
        b=JyryTLam27FbtV39VwPnbZYJURsZ69VTq9njnMkcn6McLGYGpiZDxtYPcT+ojD5YFS
         FnCXUKRRcbaoQdhtA9tkjBBu2a67RI9puC3tSsCgtRlreZU3iUYIkXevMQgWPE7pI7zc
         hLJLWHheSB6wT7NiqQRjuzX3UJPyFqtBBdzsAfcxEGDDwzapePqkrsH9Pwmc5Uaj64Hc
         0naSFmBi92jE7rAKOB8cmDSqudsH+5v2tBBl5nhwNP9U5wyLr8g5eZW8m/GDkgfH7cEW
         fmLZK3zW9GKpeJWDdLwCU6UHSs1CH1poT+xHChBD6k5bwO92yHQos+5HSarQvNSzhyN+
         fPUg==
X-Forwarded-Encrypted: i=1; AL+hErEtvk5TrkRPRZeVz6ybb+I1sbVmUUFWCw/McMkVni1PDeZrUstDWY/JkJtMOe46Y8gHB4UlAYFy9HSzZw==@vger.kernel.org
X-Gm-Message-State: APuU4Z923vz++Hruqkx5wJTeeMKW7ulbTsHCGX3vMc3KNcvfXTTtgHXM
	rRQUR8sjBKPkxy+JBq5NN3B6nqbOptsZ64XSBlyIDUlpJahOPnONHwHzlrWheg5H8YM=
X-Gm-Gg: AZFdTZdhP4JinneBDWMpQEx1Lb0ddE8ZeOaxqk/eFds1zqrTv5ScDGnHHSLShB2TRBF
	nh9eNJEQouDy77gp6NmzDgJhjsb38xAn1dTueOJBoEUde5OP+lzg8DDzwRQzL9LOWQAu0Lw6buh
	O06I4a2ORn1ulJL32RATMbkerDYqrrs2Zk5zhQom9nCJ8duK0t0maH46ABZvtRwVFqSSB6bQGKy
	Jc2+Uf8D9hZSFiu9Co83M72Gfo0X/zvM4J6Tnlq26VgokeP7CqbAHRZiT5cIVvH2FyKjTXtoRy6
	XY0wbaHzWlyngMa3Egtnz9eSOgPZZpf4jEO8KZ2U3S/QTNk+bBjrOu1ZWX94E38NZU9Ks3IDZq5
	fU6VSAfccNjU/WtHvAnhRfA/P0PDi6tY8H9gkWcMiO39HLDvz46kvmMpLVjW9K1tmDnd6evjiGj
	8N+dRk6Gpcf+vxAOJ006hoyOgHbGSsrNiuXV5h/XVxEgLIqXQC59d3sVGXTLUnk9v+CxJT1iW1n
	PD+OkNd95ipNO3fOr5uPqzdtgXoMbFHHbib5oa5+zyMV6ALrI209Zs6FFbJt3uPvzS47artQf5R
	kbn8xTd8tbxY/vbjdmZBkdZRFzgeHOIuImU+U1XXCRU=
X-Received: by 2002:a17:906:2b11:b0:c34:83c0:b92b with SMTP id a640c23a62f3a-c513aadbe9emr1161126666b.23.1795648353563;
        Wed, 25 Nov 2026 15:12:33 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b4b3c71192sm13469254a91.5.2026.11.25.15.12.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 15:12:31 -0800 (PST)
Message-ID: <bec42b00-0170-45c7-a130-5cd02aa487ac@suse.com>
Date: Thu, 26 Nov 2026 09:42:26 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] btrfs: scrub: release the commit root paths before
 pausing
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
References: <cover.1795642270.git.boris@bur.io>
 <b0805ac31ef24ee19db794633ca7ef1ebe912ebb.1795642270.git.boris@bur.io>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <b0805ac31ef24ee19db794633ca7ef1ebe912ebb.1795642270.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/26 08:04, Boris Burkov 写道:
> Since commit 1dc4888e725d ("btrfs: scrub: avoid unnecessary extent tree
> search preparing stripes") scrub keeps sctx->extent_path and
> sctx->csum_path across the stripes of a block group, so the paths are
> also held across the implementation of scrub pause in scrub_simple_mirror()
> and scrub_raid56_parity_stripe().
> 
> Both use searches that set search_commit_root and skip_locking to true.
> Meanwhile, the transaction critical section is exactly what issues a pause.
> So if we populate sctx->extent_path/csum_path with nodes from a commit root,
> then pause, then complete a commit critical section, those nodes refer
> to the previous commit root, by construction.
> 
> These nodes could have been cowed and thus unpinned by the conclusion
> of the transaction. It is generally not safe to refer to nodes from old
> commit roots.
> 
> Therefore, we must drop these paths across pauses to ensure that after a
> pause we do a new search in the current commit root. Otherwise we would
> need to block the commit on the scrub which is obviously unacceptable.
> 
> This issue becomes particularly nasty with dev-replace scrubs which can
> then try to use an invalid reallocated eb to populate the new device.
> 
> Fixes: 1dc4888e725d ("btrfs: scrub: avoid unnecessary extent tree search preparing stripes")
> Signed-off-by: Boris Burkov <boris@bur.io>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/scrub.c | 24 ++++++++++++++++--------
>   1 file changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index c8da03e14094..1a721623813f 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -418,8 +418,16 @@ static void __scrub_blocked_if_needed(struct btrfs_fs_info *fs_info)
>   	}
>   }
>   
> -static void scrub_pause_on(struct btrfs_fs_info *fs_info)
> +static void scrub_pause_on(struct scrub_ctx *sctx)
>   {
> +	struct btrfs_fs_info *fs_info = sctx->fs_info;
> +
> +	/*
> +	 * These paths are populated from the commit root without using
> +	 * commit_root_sem so they are not valid across pauses.
> +	 */
> +	btrfs_release_path(&sctx->extent_path);
> +	btrfs_release_path(&sctx->csum_path);
>   	atomic_inc(&fs_info->scrubs_paused);
>   	wake_up(&fs_info->scrub_pause_wait);
>   }
> @@ -434,10 +442,10 @@ static void scrub_pause_off(struct btrfs_fs_info *fs_info)
>   	wake_up(&fs_info->scrub_pause_wait);
>   }
>   
> -static void scrub_blocked_if_needed(struct btrfs_fs_info *fs_info)
> +static void scrub_blocked_if_needed(struct scrub_ctx *sctx)
>   {
> -	scrub_pause_on(fs_info);
> -	scrub_pause_off(fs_info);
> +	scrub_pause_on(sctx);
> +	scrub_pause_off(sctx->fs_info);
>   }
>   
>   static noinline_for_stack void scrub_free_ctx(struct scrub_ctx *sctx)
> @@ -2204,7 +2212,7 @@ static int scrub_raid56_parity_stripe(struct scrub_ctx *sctx,
>   		return ret;
>   
>   	if (atomic_read(&fs_info->scrub_pause_req))
> -		scrub_blocked_if_needed(fs_info);
> +		scrub_blocked_if_needed(sctx);
>   
>   	spin_lock(&bg->lock);
>   	if (test_bit(BLOCK_GROUP_FLAG_REMOVED, &bg->runtime_flags)) {
> @@ -2350,7 +2358,7 @@ static int scrub_simple_mirror(struct scrub_ctx *sctx,
>   			break;
>   
>   		if (atomic_read(&fs_info->scrub_pause_req))
> -			scrub_blocked_if_needed(fs_info);
> +			scrub_blocked_if_needed(sctx);
>   
>   		spin_lock(&bg->lock);
>   		if (test_bit(BLOCK_GROUP_FLAG_REMOVED, &bg->runtime_flags)) {
> @@ -2492,7 +2500,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
>   	/* Extent_path should be released by now. */
>   	ASSERT(sctx->extent_path.nodes[0] == NULL);
>   
> -	scrub_blocked_if_needed(fs_info);
> +	scrub_blocked_if_needed(sctx);
>   
>   	if (sctx->is_dev_replace &&
>   	    btrfs_dev_is_sequential(sctx->wr_tgtdev, physical)) {
> @@ -2837,7 +2845,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
>   		 * -> btrfs_commit_transaction()
>   		 * -> btrfs_scrub_pause()
>   		 */
> -		scrub_pause_on(fs_info);
> +		scrub_pause_on(sctx);
>   
>   		/*
>   		 * Don't do chunk preallocation for scrub.

