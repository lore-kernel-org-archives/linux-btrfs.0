Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795649400;
	b=OcHTCgYzHlIZ1WpUDLstyVgCgpiS2/XZmJ87D69+zebbJSny0yNEP8w/Fd0CTBgCtbmG
	 kCgiNaojk7zlqXflg21F5leYPUr+tZ/YVBXmZZd1bKpXh+Qtk2zyzlieL8E1u0K+4K7pL
	 DFS5Tld5Pcn38gg9rtKBXW9pTBmpL59dH0PhfVlYvVZhJ5fhvc2D1zByPNi4rnKPSLiBK
	 8oufdnT80tgC62A1TvBgEoM3jhZqarD3PVlL4KYi/lxmIH/lsnbUsOQOabjQrvlPChupE
	 zn0eDXD7DVYAxz8SlLIgvIKRZgUIkDYzM/C/hK84geJ5386EyWyXXlU3foSgh/xjS9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795649400;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=UC4hQkHdr2sM++c7r9PgW4zExXedCdbPUw4geG+Rrxk=;
	b=tjNy46wy2QGb5UIXQ2BBIYxsWiERgx019qGSWs9DkGAwkJ+Trx5GJ2ZppG8JQsKzq2O1
	 6aYzDasPMDdS/e3wdA2yCydLnmHOYKKoAD2VNZB6ml2GdtmWtuxQQHy74IqL3cxyx5/km
	 RT9LT7obqXk6BZtgDH0KEpt8dt5JHrFsXmB4znbvWa0qFwkRg9OEcbTxrZpvzzoWNFqtx
	 bVlJmq9HZlSz13n2KsZ9WrT61nxb0GXYszGCCJ0Z/r1m3sJtvKREjkFHhxalRvBraXCIe
	 jTujInpB54whEjCmdLOfJR4osrsiy6Md2yiwwpHUnhYzUZl/KQWU2HmHuuYR74dUmBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=FZE5RUMn;
	arc=none smtp.remote-ip=209.85.218.43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27105606A31E
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 23:29:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27105606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=FZE5RUMn
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c4cac7a7d3cso951086666b.3
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 15:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795649398; x=1796254198; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UC4hQkHdr2sM++c7r9PgW4zExXedCdbPUw4geG+Rrxk=;
        b=FZE5RUMnj8VyUNjPjYlhqQfbiBTVegapwOgMn5ykrOJ+V60b5h3w/4M/Ncp3xJ1T2E
         lSdcbuDDTpTOTBVyyoJEnjJIPW0M059bb9Rs2TfqOlxR9AM/iR0HhS+OVLXaljR+1wRJ
         ItAjTkMsmQK3mU0E4hHYyD4C+TndUrWE+8UQQs2d+UII/PD6c/ZHi2wVL1mDeKHRrd98
         pFOKlHww6L6f0Tv+fhmlCZd8OcR9kEANDpShwQJ2WT8e+VyhnFPt28QjqNhbHjeZY6SN
         t9yvcS8/Iw7ob9cdhK21F6bJCu6vuJM0zFi+q4HHQOTt5gX+xIoWdxMzBK4jLFfoOSgp
         Nbgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795649398; x=1796254198;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UC4hQkHdr2sM++c7r9PgW4zExXedCdbPUw4geG+Rrxk=;
        b=A/atbvBIu6KiDLew5rYVc8dFW6nPLODI6gBxuQkyUMSRHycdDWH17j3bFApWZG8x8J
         2ZQtzfY6RrXNwL4icy1mCSn3g58+prlK/xLTVT5hfQaUtMpM4vQAf+kcYy41OZUlHyZw
         yuSwlX5NjSkyTj2kHZ7srxLyLuQrb0iynLjPFL0JGdUmsSbpRY5WRGspCpDhRATl2M/S
         HJiS8FbiQBJuDu+6HlntXVY+9l9z+nljSaE1H6CYFmumzUoT5t0oI1H/JsZf22fl+8p3
         IBS3p3rU0KfJ7I9otoqgj0zgB0madlvRFLHufje1T8ZQEuOJY38L6BE5ity5vR7oUi7F
         gHrw==
X-Forwarded-Encrypted: i=1; AL+hErGBTfRjuaKOTVYQ0yPpA2/6jgeJsx4pTW+8TOY5rpJl4m8KQ5Msqa4GgV7vicmn4wOezYoI9Lz3gMoLyw==@vger.kernel.org
X-Gm-Message-State: APuU4Z/QkaTXKA6sYGQ8lqiUU1NwLQtls2VvUTV9fpPbsjTHDCnBicMM
	C1z0B2XW7vbJkDHVYj0U0eYO+E6FKYZJVLMjua4voXBZoDT/7YaBRa2Y986dxU1g2k8=
X-Gm-Gg: AZFdTZcs2X+EGpywH/KN3C+jnyG/7xLCIuF360MQGi3KyazhLBPUO3fbSRf2LO8mef3
	LUHniXhX1B6CgyjhxfzLo/uj/5C3528oxc6clj0sMpa+k6VWjrH1y0fIYopX8U08ANPjJgA3uJq
	GXBcyM1bvdprQgC4X0oStk/yvuYV0oZHPKAxiuHYUM3QiL6it5q0uMVdUKaQNN/nC1FiMWvckK9
	qXKgGUtwyZMDee04zR4EQ6CFkmyOzR0k1LZlXhOO5qeA0v3UmaKYrcQC+Y8q7ihGCQhTL8fX4TB
	Cg1iIYxQycscQ4CkizqcbHpvVghPJbe92rmTp772I990tvtO9BTAahQh3EOgSuPPa9RBUjsPcJk
	vL29DiW3ZT1vLbCjVxN8zmwQCJEXpvJo0KqEFkHhx8b72zVTt2IPx06Xi+8R1b96YXowFNpBgNq
	9c7lZ491cPgXrDbXpZaYBFJPMKXN2GHVDJd/d6saSFieyi9EYNkR2TZ24bayCXA16ER7Qvhdk1B
	6K8eAlNWKLAQJOvvcFF1H/38TX9ELMkHxtoOGvQgakjfszqcCt/hd4rrZ5p3csz6/sC80hx5+xP
	83hs1szr8dfmIN/i+pu0Qg==
X-Received: by 2002:a17:907:f814:b0:c50:5cd7:2901 with SMTP id a640c23a62f3a-c513aac63fbmr1445635866b.23.1795649398425;
        Wed, 25 Nov 2026 15:29:58 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03ee844acsm96890285ad.2.2026.11.25.15.29.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 15:29:57 -0800 (PST)
Message-ID: <3ec88341-70a1-45af-a6bf-dc2cdcae330f@suse.com>
Date: Thu, 26 Nov 2026 09:59:52 +1030
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
Subject: Re: [PATCH 2/4] btrfs: scrub: cancellable pause during throttle sleep
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
References: <cover.1795642270.git.boris@bur.io>
 <fdeb64e3fcf92bc8f1a69d07718dc07a23a133e8.1795642270.git.boris@bur.io>
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
In-Reply-To: <fdeb64e3fcf92bc8f1a69d07718dc07a23a133e8.1795642270.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/26 08:04, Boris Burkov 写道:
> scrub_throttle_dev_io() sleeps with schedule_timeout_interruptible()
> without pausing the scrub, while a transaction cannot enter a critical
> section without pausing scrub. Thus, a transaction commit gets blocked
> on a scrub throttle, which is completely backwards.
> 
> Furthermore, this sleep ignores attempts to cancel the scrub.
> 
> Improve the scrub throttling semantics by implementing it as a cancel
> aware sleep wrapped in a pause.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/scrub.c | 27 +++++++++++++++++++++------
>   1 file changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 1a721623813f..a976897cea8d 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -448,6 +448,23 @@ static void scrub_blocked_if_needed(struct scrub_ctx *sctx)
>   	scrub_pause_off(sctx->fs_info);
>   }
>   
> +/*
> + * Pause the scrub, and sleep for the throttle duration. Pausing allows the
> + * commit to proceed unblocked.
> + * Scrub cancel interrupts the sleep.
> + */
> +static void scrub_throttle_sleep(struct scrub_ctx *sctx, ktime_t timeout)
> +{
> +	struct btrfs_fs_info *fs_info = sctx->fs_info;
> +
> +	scrub_pause_on(sctx);
> +	wait_event_interruptible_hrtimeout(fs_info->scrub_pause_wait,
> +					   atomic_read(&fs_info->scrub_cancel_req) ||
> +					   atomic_read(&sctx->cancel_req),
> +					   timeout);
> +	scrub_pause_off(fs_info);
> +}
> +
>   static noinline_for_stack void scrub_free_ctx(struct scrub_ctx *sctx)
>   {
>   	int i;
> @@ -1435,12 +1452,8 @@ static void scrub_throttle_dev_io(struct scrub_ctx *sctx, struct btrfs_device *d
>   		delta = 0;
>   	}
>   
> -	if (delta) {
> -		long timeout;
> -
> -		timeout = div_u64(delta * HZ, 1000);
> -		schedule_timeout_interruptible(timeout);
> -	}
> +	if (delta)
> +		scrub_throttle_sleep(sctx, ms_to_ktime(delta));
>   
>   	/* Next call will start the deadline period */
>   	sctx->throttle_deadline = 0;
> @@ -3334,6 +3347,7 @@ int btrfs_scrub_cancel(struct btrfs_fs_info *fs_info)
>   	}
>   
>   	atomic_inc(&fs_info->scrub_cancel_req);
> +	wake_up(&fs_info->scrub_pause_wait);
>   	while (atomic_read(&fs_info->scrubs_running)) {
>   		mutex_unlock(&fs_info->scrub_lock);
>   		wait_event(fs_info->scrub_pause_wait,
> @@ -3358,6 +3372,7 @@ int btrfs_scrub_cancel_dev(struct btrfs_device *dev)
>   		return -ENOTCONN;
>   	}
>   	atomic_inc(&sctx->cancel_req);
> +	wake_up(&fs_info->scrub_pause_wait);
>   	while (dev->scrub_ctx) {
>   		mutex_unlock(&fs_info->scrub_lock);
>   		wait_event(fs_info->scrub_pause_wait,

