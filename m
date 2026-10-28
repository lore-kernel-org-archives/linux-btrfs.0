Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793222974;
	b=hCLh5p9qwdCVWV5J4dOgRSBZBEXHjI5C5FuOh9xSfnUPpVKS7jDFBPe1M8uzXD4Jvnuc
	 CJOA5kINJ/O3TqpdeCVP8/nC1+yM8RF78QXQlvTc7vm2z4L5hRmO/mgzXyarW9dwsUPQY
	 ctkupFQH/je4veykG/Go1Yxg2YanXmewqscoE64JyZxHtyR0YLWhc+WEyw9Cx6C9hyu9/
	 RiPJCOcdRD8xn8UnEjwsQYgSEjnWE+r9jstmjEsSrqZLyLP50NxrEMXvrIEjz9BDsrYjK
	 4C2HKOFawcYNo/78wxUbHzH8U145wRXGTGfpLivHY5KZ2+uacAqm3JWEbFu3m6cFSZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793222974;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=iAaWZBXA5nN4dTKF7tG2rnH5xjAMPLpn110ikOB8TOs=;
	b=teEfrDxdiU3sRlp/+BMk41cP/qYpaJM3o0AGqdjZYATRPKw9fQx6Yr40Vnbo870kUOoI
	 QkB1917D9+xASasde8YearGorFvtBQdk57GEj+pSt4tUmVxyCWOe9ZG7tmSkMc5UrdjlO
	 Us6wZzYt+xIour0d7rd5hcwFJmYp2Gbe6sYMamRoFMmQHlXFuX1D+bW2+3k4bUpfQHhdX
	 JCy9fyZl+IoU9Mgf9Dzq8gWc5kKC5UWhGAL34z8zskKOBjyF/Obo8U74EY589OzNBo/zZ
	 /0mHS1EB7i0UApPcEWanEycOQnO2dus7FpT7lxsFfXrz4mHIsn0iOg3Si/EdRP7vXpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=MOhiOJEm;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFE7606A321
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 21:29:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ACFE7606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=MOhiOJEm
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso15423085e9.3
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 14:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793222972; x=1793827772; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iAaWZBXA5nN4dTKF7tG2rnH5xjAMPLpn110ikOB8TOs=;
        b=MOhiOJEmeakhgW/quEB/e6J5P6z5sobhJGKnpRnCJLRsLpUPIrKLfm78MCpTrJdqbU
         csfoCr9LXvwL3tauswaJOoCgC5IbGR/IMtqg5SI5MApyzaObbTbmNnO0+f1FguPaqCem
         C0JOk4Kr3ABtNyATsqkmv6/Motq5SbruCA1nK1p6n3IhYM2l73qJOVoCdyLZnpqk978F
         GDc6tdMjiTSdAPOB7jqysS8yNeywCN8UFIByAy4a9Kb5YjLvD45NTaYmDI9KeE2lSN+Y
         e55Yq9TjditZ3XfkSJiShA9KzpErgXKQnAHftIxfCJXOBqHD6Pj2K9FYDPITIbTDt7IE
         iuJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793222972; x=1793827772;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iAaWZBXA5nN4dTKF7tG2rnH5xjAMPLpn110ikOB8TOs=;
        b=l6x6S2KUwEYk6A2PJ/WLPxfDEBkatlNpPnow3swohXWDUzoersL9+xZV6eFCHWAYM6
         c48ylLAX6yd3H5cBHgWdXo4J+lsCWW/D4hXxAhpiYaM/n4yJH8p7qzpVhcqGDOBNOPo0
         udUgenn3YKLaG9UihYDzDYZS7bwx/MaONiJN251zr+XD9G4odHm0U4Ytew/lx4agr4a2
         6WjrJJpS669UOgCqiTZ056/PkBOhujfqsps6HeUI80xM7fteWXCmVsOF36GdAo5/ceo+
         dWIP9CrFOFVj5ZKMBSr8bOEmmLVnXuutiiu+Atw44XdeC0VkDE8XRVkSXUajJCH9N6J0
         agtw==
X-Forwarded-Encrypted: i=1; AKwUvBy8JZF9TzGZLCcmVAuqFNwV3pb1uycbR8+BPNlxUxzBUAbRvjd/0Yn1KJrBkSON5xMZWgjigNXBJjeBNw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJhFK6StIk9XBCh2yTIRaAuW92SdiB2AheG/fbkSPwZp0xFPryr
	h93KOaEIwXKT1KNyX9i9bcO8VgjoEnDu+uvo+q1NKL/ylgYgHeKJRHTSTuo5BcxrzLY=
X-Gm-Gg: AYBFou1Qzi6f9wTjaBukAdPG0sP/VmCsUFH0b2R/pUsDxtZs0zKI3gHPAgm5z4kN52v
	ymdv75iXeNAV1Wz3yoCTBWFlCsE8IBdusPuOUzKTUXpd6MdPFRZSj+vZPSBze6w4ZFAvWg319y0
	JnZOt898cITRSuZxrld0Vtuvzwxd7OF34hZSlU5cp7mOBXzxL7QKAhlD4UdM5v2CpClqTTLoYWa
	e880XZtodIxTIugmEpN/ZOadwzObf5gOkzzLz6bPuCVVQH3EDlyocGdhMSw/+fkiQjSIq30edHH
	lxQ8DTDXC0gVqAnOHNhh9ur8wctEkwMZBYS8pJXxCL6Ai0HC1oCey17Kk8q8ehxzFK45+UFOJY9
	N1MATPAVLwVP4SG11LvlXQNJsZZYN+udvVdN8D5360pb+iS41dqT9P/Y9305A+9Y0H9BxUmhFmR
	KecwTHOiPkv5y9oRXsbdLu8a/6Mxo3FEthyvP4tS8K4QsLXsExG9RZ6BgmvnnNKTpc2z/bO9DfN
	BVFjiFhcyE/IdpoVXPghlO87wHQ/D62tkYcXJhdhGlGY3qIPprQrG/ZeY4atwa95PouKdnd7fVN
	zjva1JQKGhS/HKkUZlunTH9Ii+UzES/eH4//ABi5c8Y=
X-Received: by 2002:a05:600c:8b38:b0:4a3:5a91:5f61 with SMTP id 5b1f17b1804b1-4a966c4062fmr83695695e9.14.1793222972048;
        Wed, 28 Oct 2026 14:29:32 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e7ac746sm1047389a91.1.2026.10.28.14.29.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 14:29:31 -0700 (PDT)
Message-ID: <128df277-19d1-4328-9591-79bb991def7f@suse.com>
Date: Thu, 29 Oct 2026 07:59:27 +1030
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
Subject: Re: [PATCH] btrfs: zstd: prevent leak of workspace below maximum
 level
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <c305694d12ec20fc431cffd4cc718efb1a3823d9.1793204767.git.fdmanana@suse.com>
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
In-Reply-To: <c305694d12ec20fc431cffd4cc718efb1a3823d9.1793204767.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/29 03:02, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When putting a workspace we always protect the workspace for the maximum
> level from reclaim, since it can be used not just for that level but as
> well for any level below it. However the logic is flawed because if we do
> the put for a workspace at level 10 for example (maximum is level 15) and
> there is currently no idle workspace for the maximum level because all
> are currently being used, we don't add the workspace to the lru list and
> that can result in leaking it if we don't get more compression or
> decompression requests for level 10 or any level below 10.
> 
> Fix this by skipping the addition to the lru list only if the level of
> the workspace matches the maximum level too (besides the list of idle
> workspaces for the maximum level being empty).
> 
> Fixes: 3f93aef535c8 ("btrfs: add zstd compression level support")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/zstd.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
> index 9235aa7b922e..b686f67d52ec 100644
> --- a/fs/btrfs/zstd.c
> +++ b/fs/btrfs/zstd.c
> @@ -347,7 +347,8 @@ void zstd_put_workspace(struct btrfs_fs_info *fs_info, struct list_head *ws)
>   	/* A node is only taken off the lru if we are the corresponding level */
>   	if (clip_level(workspace->req_level) == workspace->level) {
>   		/* Hide a max level workspace from reclaim */
> -		if (list_empty(&zwsm->idle_ws[ZSTD_BTRFS_MAX_LEVEL - 1])) {
> +		if (workspace->level == ZSTD_BTRFS_MAX_LEVEL - 1 &&
> +		    list_empty(&zwsm->idle_ws[ZSTD_BTRFS_MAX_LEVEL - 1])) {
>   			INIT_LIST_HEAD(&workspace->lru_list);
>   		} else {
>   			workspace->last_used = jiffies;

