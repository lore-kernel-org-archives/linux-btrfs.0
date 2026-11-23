Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795466542;
	b=GhTpxwhaen5YltXtXOk2CrxzvF6c4OhfBASTFulzZDseDN5SaaW/fI4lb0nyLrb3ELC0
	 hHO8c8bhU4EgZDsJqCmDcs/c93D5jyMkE8tZjdx/aDWG4LeDVyVde8gheVwUDHhHkkwwy
	 zyO38KBwlzGcJeYbjE6+nHwdPeHTYiErEBmiKy5TX6UatQBGIHxmxbelECD6aNFg7COto
	 75/8IlDsoUvyEXdW0mqel/BfvOGlpEGDI3AbWrqd/f2ydqjquRdn3tlZ3+JdtLWPJTS2t
	 zAlPPQHvZIsaYSkGy7Zirfq6hJkyIFSsO4zfFqWsRTELtNrgADA7DJLO76TY+W/A9fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795466542;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=zRwz+gSCVWJ0n4qlL4tlSkZeTmsxV0hdkxs7uTsUvUQ=;
	b=MEp882KCS/a89dmDf/skX2S4boEuFkkcHNLjqXTXMnQwjdpkS/AbHsf1cFAEawDigSeX
	 aKfGnNq6d+EoD5TxuWwMKwPowbI4rbSAAn1DfoSagaGnZ5+y9kk/mdvGcknXe32rkKOjo
	 O7Ubs4IBY4tBLFkIJ36WQ7nijzxZp2+50ls91jFreTuhzzvn0Dq7CUHlXWuiMr1adFt8Y
	 aFLmM/zM8MNzTw34pjgjp2NI7PSSZsw+R6FOG2h02/UcLurkV+I5yE622v4fusUbUHCBw
	 ORQ26Nls8D+Ap7tZNYMzQw9Lpuj+g5LWx+m6IE7WNGUi26hevdrZPsK9i3kSSxE0tvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=AE9EzkPq;
	arc=none smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9848606A31E
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 20:42:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9848606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=AE9EzkPq
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b4bd3d98bfso4599259a12.1
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 12:42:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795466540; x=1796071340; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zRwz+gSCVWJ0n4qlL4tlSkZeTmsxV0hdkxs7uTsUvUQ=;
        b=AE9EzkPqz27MSp+vW3BaNLzNXviOyTvXJNapeoxojsQIz51wFy0KcFdSYcPldEcATS
         Nqa7nFbB3GFwA3TN068pSyhMyLq+p3bptJ+mmeuRB/wNTynjQPmVP1Qs6okcr058UQyB
         V7SdceT76PqaGktQRalbNuga7likvcEezb83tyu5ggZ6gskSIytJ8IgNbdJ5l09xPaOV
         HHvZtoO5JZy8mD52G7HdbZj9Ety3liRALGTkJRiuZb1QtCHJ6Bji/6wFNpQVo379owaG
         Q6gm2CV4D/M+7fbZ/3PL+Do0T1Q71LIl4yuJSGt4wUhIqohCJDpzBFGfeKHlDDCfgbSE
         4Vxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795466540; x=1796071340;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zRwz+gSCVWJ0n4qlL4tlSkZeTmsxV0hdkxs7uTsUvUQ=;
        b=iMmr2DMdZeQdAseGQzp3wmfjKQw6f0z3kXupJ6Kb4617MicpeupHP6/CW0gL8lSr1V
         hpyK1QUNz7fqGc/lyACYeen54ai4+UjAj/ihBoDe4UaMkutO8O2K/2l9NjSwB21btP04
         IM/C8+ernp3JDz/oIuNwIr/3XRqj4OqVaqUc0Z7R5AN+Q/35SJTP5zTng18roJ7aWybT
         4QBzFXwnAqTIJm0Ha9ClLWh58yxqQz9rkKdCmBKErMXivyTkror9g/L6Uj6Lu6NC+wYF
         V9H5CCsCLM6kBFwjAIM1QYO2qREVB9jjJUp73x1i00yIMyIcin3UKEtXuBxexqsAJjw5
         tHtQ==
X-Forwarded-Encrypted: i=1; AL+hErH/pM1+Ym9NgwuGi8efys1M5rSPTRhlNqlI0bkXGaL+rfak4JW/YGpRWMezeCkZpwA5607RjPSh1aotNg==@vger.kernel.org
X-Gm-Message-State: APuU4Z8kl4W469qLmGWj6PF2hJ9y1axi/9I1pi9zz3I3bBi6AKTdHpXY
	PStpIEFsrtt+VqRBCnKWM55KN0DqZFC3mEc+XngVjCKqPzGmEfW8fZ9wdEocfa5NSy+Ubos+xB7
	LCD5LvvGRrA==
X-Gm-Gg: AZFdTZff8L7A0QIfFDDJJXZyPRGDmg90ERHUgIE3gOxFhRMZlj1nB95AW/ldZqvhWTD
	pIF9tLL3ygKcQCu20VU322bbiJhpzl2SFzBHYkx81HWjJoHDvg1Nr6JgFzOY6EZH116zH28UmIM
	OeqT7R4vLglwhX2HJwWJGulTyDFRP0jCaTgFkYi632NNeupc85JRWDloFe8tvuWOtbjFmPyDZwa
	rBeA7XOTfNTqrsirTMBOhP41MrOXL9uErVZgRWi6K7fPf8/Jo+SeCYzrkXy+/35tthDeqNe4BDm
	c0P266TBhhSPOpmv5rrXhMnq/lZANmypJZyf347HXK5HeMGQYVKHD4oAmQLHJ2m9MInkh6QJ8YW
	HWpgIgfssSPxwxUPSIvrPYfC56y9iuzkWg38Xst4MwODVegiu1ZpYQ/9kSITzsNmxDLCaXy2ffF
	AwKvno3aswqBtT/gmadMtrXUZ1zQ0qSDsWUo5lhRbkKFixeCjyDmfPrX/av4/wpoC42BVg6uoAX
	5g0BiJmbdFDRvhrP5YFy7IuP2qYPEV2eyuLgOR7EqjltoXzqEk3hgp60AfAh6bO3R35G9KD/vX5
	0UoxekpxAZ4571dOSpbUsA==
X-Received: by 2002:a05:6402:2347:b0:6b7:d1a4:fe1b with SMTP id 4fb4d7f45d1cf-6ba37ee380amr9501279a12.43.1795466540093;
        Mon, 23 Nov 2026 12:42:20 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d05782asm5595695a12.24.2026.11.23.12.42.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 12:42:19 -0800 (PST)
Message-ID: <b3964f76-73b8-4c0a-989c-d0f7c2403b88@suse.com>
Date: Tue, 24 Nov 2026 07:12:15 +1030
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
Subject: Re: [PATCH 0/3] btrfs: cleanup some use of boolean struct members
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1795433118.git.fdmanana@suse.com>
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
In-Reply-To: <cover.1795433118.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/23 21:57, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Trivial, details in the change logs.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> 
> Filipe Manana (3):
>    btrfs: assign boolean literals to fragmented field of btrfs_free_cluster
>    btrfs: use boolean types in struct btrfs_dev_replace
>    btrfs: use boolean type for struct btrfs_device::dev_stats_valid
> 
>   fs/btrfs/dev-replace.c | 22 +++++++++++-----------
>   fs/btrfs/extent-tree.c |  4 ++--
>   fs/btrfs/fs.h          |  4 ++--
>   fs/btrfs/scrub.c       |  4 ++--
>   fs/btrfs/volumes.c     |  6 +++---
>   fs/btrfs/volumes.h     |  2 +-
>   6 files changed, 21 insertions(+), 21 deletions(-)
> 

