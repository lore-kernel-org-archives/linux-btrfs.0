Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794351187;
	b=2Fwuhhu4+0XiVBA3bFAMcfnwImpZWNf3SKcjAg+8zPqd2r/frJOLxZdY6ICmsrtUPvxB
	 L44YghY8ossoJpEB9sPCY3mlOJ8/93pZxi8mWk+D4GvOuhiiut9Ir5EvuOIeN8Y2+fStw
	 /KmQtRa/1BL6v5uS8blaNxJndIqlPl6fXdCEwZV3d8p9q2MQ5hMoXuIw/NQBMQOKhb483
	 5oGeAhbKauvX1ZCSwu68+e4f5AI/T4De1BGx6qV5rrPHxabJy+qeQhLBQmEO395wLmfNp
	 HHXmmBKymG26OTsD/YtLIJh53r8k3qK41AUcJAXzYobx3jAp11xPBGejbm+wUw+3qbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794351187;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=oJqscINCPv8jf5iG5vAmxEIRO7GhzUyNHFdqYN+A20M=;
	b=UgHanLHdQo4t3JCJe77Kwgy2g2rzI0FS4dz1Crd+t4CbvZPuh2gb6pt43VawN/PU7cVg
	 w/tL/iWHjNdnpQvU55nde3XQyDuHOb74HqhB+27clN14DyFjC5rz1jiTzbhQ6P3rxGdap
	 oeDazEnrWlMuxyeOl5tq5KHityS21BQ/F93nXfU4hgFadqZKB4Z/fqS9JZG6L5mOjEEhG
	 C1SZDfwcUsEJsuYCv6Dc2gUEUEytYQk7B3V0Cp2Bc8DuwsJcpp9FM+U+Gv1ec9FNqzfxL
	 aTcKsnlQBQeX7qUvSa6IEsQhKfBQYgG0Giv2tB6C630oBY+VGdEzREBOkOZNz3BXwbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=DwqFaMCj;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC9F606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 22:53:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DC9F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=DwqFaMCj
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4ac95761c85so19316025e9.2
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 14:53:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794351185; x=1794955985; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oJqscINCPv8jf5iG5vAmxEIRO7GhzUyNHFdqYN+A20M=;
        b=DwqFaMCjgjcj3aw+J1b9dVjqADXutS5acKOrXc2MWlqLIx0Wl0B063xWhM7cM3AMze
         LwL+OCYGHSKLCoxgipVJr91tDBBZf7S0MjapiEfohmrX/9VWTvxHjsNIihxf99hb9WU2
         EQUnIlczBqW3izTEyxnKOXqAsQbL+jchnDWnggfVgh2TCVvCAoH+mt82nouNlGfIKjpo
         yEo3gQ8swEVL3QXK+O5vcNRQ+LhnmDLHALdc3OPkjy6w0oidmoVYJO++/67HniiLye7q
         UkDMCA1T82sRn1BapT/bs/wD1qgUa0tTvPVVuZ4TnLeR8Ab/Mtt7HyWXoP6Gc4w1ioue
         s4/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794351185; x=1794955985;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oJqscINCPv8jf5iG5vAmxEIRO7GhzUyNHFdqYN+A20M=;
        b=nF3QOt+7jxKmrhFVLi2d2SPqhH96oERxXRXqJ625g+LbTA7y606nv/QaJ0eT7+mfkz
         w2tlqHZQ98X2Dx49FBEeiTddqQFFp6VsFbyDZm+M5bRfWFvztpefN26AYLgGnXUwcGuP
         J/3r+gX5gHx6OrFrmE/rZf58/WIlr+SYRtb/eOiqUQUalErGNn0s4AhNP/Evmvjl7d3K
         TfjVP8K1pn1vvt2V1BazH50YPFiBFgcozdh0AEWUUV1w4Kb3z37hBUSDtGwu5YrEzvSG
         H8owGUBL7Mx9+Npnp4jnIa4vxsXZkOTFj50yf03TYlVJLfe/7y7bc4PyLuIElM0QQXT5
         rQ+A==
X-Forwarded-Encrypted: i=1; AL+hErHHVHMGqTfb9MSpkEH7lB7dIqH53+L7lPDqZ6pWpuVq5deXOlRCWLy4qO4HzUbrO+1UaoafBshmFdvT6A==@vger.kernel.org
X-Gm-Message-State: APuU4Z8ctrTfLql22J434mAYSQLfbBF5BDncgkKJ917bePosPOAFT+md
	+r6J/qPfxZQF3L/vicA0n+oBzQNfU8kDBE5+9ob0S62eyI8l9CDq5RBeh2s+RXM/Z5bdjkfVUCD
	t85yHU92qLA==
X-Gm-Gg: AYBFou0taq8YwIF8MitSCtmWcXvKlhHMyBGCJChiK5VTsBmxyyhRlEdohI6M8fllcZ/
	IrqiS8A29sR4WaXNigq3vIHQqreQHxHXUyaSKOuJzXs8XpTORca4X3bJslalfTekMxkRmqR5s8r
	qvc5wKBOuraccmW92NY8GCueyiNOpVCuH+1iQmVkZXPv3mgQM/U6wcqWUzK2+pGtn54HIgxHjFJ
	Ql5IaVTVFbW3WZdQe2EHon3FukUGc//LxY/yBtbyrz3BBYigYpxKc6uphwLnyCa4rY9hrVCVzpT
	a04W2AZmF/+CKiZSMr9zcI5IofPYPqXw98lrSI4vO2gWJbB1ue22ULd6Mg2MBoDeqGAvP6rx+z0
	U919H0u4A7heDAYfwdld/XPaToja22EQPZbLjVtFhyhsFQidOOSX2jvmLw/5Lp8OWrt8muSzHE7
	wlHhkHDjtpF+oSWDCn6iLehls9buhafQ7cfJuShjEhi7SkQoPlcZJCorhFs55TtXXOh0jgGfTwg
	EJtorHrEjbQYcif+ZHKICUch6/2wgnSEk8EnsymxHH5ViEFGaKR6xkPtbqLy4awFgCosBbpBUDe
	LTzfByS2MeD0oUEn7/Sw0A==
X-Received: by 2002:a05:600c:3f07:b0:4a5:87a:50ba with SMTP id 5b1f17b1804b1-4ba0938a6a7mr7708825e9.33.1794351185560;
        Tue, 10 Nov 2026 14:53:05 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17e1d9066sm1347918a91.10.2026.11.10.14.53.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 14:53:04 -0800 (PST)
Message-ID: <966abdeb-2cf5-47e3-b4a7-c32002f3b665@suse.com>
Date: Wed, 11 Nov 2026 09:23:00 +1030
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
Subject: Re: [PATCH] btrfs: zstd: remove unnecessary early return in reclaim
 function
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <13284885928812954a694ac399f3186b76806fbe.1794351010.git.fdmanana@suse.com>
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
In-Reply-To: <13284885928812954a694ac399f3186b76806fbe.1794351010.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/11 09:20, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> There's no point in having an early empty list check to return immediately
> since all the code that follows can deal with an empty list and does not
> have any overhead. So remove that check.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/zstd.c | 5 -----
>   1 file changed, 5 deletions(-)
> 
> diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
> index 8756b19f37b6..e4937f6fde29 100644
> --- a/fs/btrfs/zstd.c
> +++ b/fs/btrfs/zstd.c
> @@ -116,11 +116,6 @@ static void zstd_reclaim_timer_fn(struct timer_list *timer)
>   
>   	spin_lock(&zwsm->lock);
>   
> -	if (list_empty(&zwsm->lru_list)) {
> -		spin_unlock(&zwsm->lock);
> -		return;
> -	}
> -
>   	list_for_each_prev_safe(pos, next, &zwsm->lru_list) {
>   		struct workspace *victim = container_of(pos, struct workspace,
>   							lru_list);

