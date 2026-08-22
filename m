Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DBB2EEE65
	for <linux-btrfs@vger.kernel.org>; Sat, 22 Aug 2026 22:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787436662; cv=none; b=QTHmQMnEdhgo2SZM0ymkmQK6o6B+7kaR9xcNcW7TBXNTrWlyiWrTprZNvLH44e6f1zehLm+jMpOPTRVLzO1NSJAizc9z83+bYQ6iM9ZCgXnZ4LJg8C/Hok/aAHCsI+bPyBAOMdgc0EXVBOEHkm56cJU+Z+vz9fzdGy0XuV9tLaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787436662; c=relaxed/simple;
	bh=xGHlJN0d2A4rk8ZTy3GhhpbBSJTFsDN3YyLexF1PMcw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jIvkv+nZK0vAW06tLN2udR12ivwG5qUFrnvFShMutJWwlTbKrfzzdwywGlVRK70bD2CB/4o1uPnJ6jW9C5bdtxVOjcIZ6rG/DeqtTeCw/dp7UAxysFJEetWqUwLn4zJXuGDfepAFblpd3B/gCIs2tHnUHoYOCTLXF4+8mXnsbm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=b6qUjo/m; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="b6qUjo/m"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a082b3671fso3612660a12.3
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Aug 2026 15:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787436659; x=1788041459; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6sO7WfhAIJ1nbuSFCtyRgBBYLF8hs1ePKr0RCA4N/Wo=;
        b=b6qUjo/mMFOdF2jWo+NslLvHCullHnj4C2NLyJlrGdcO77Jxb/MCXYuZv8QVeM2NlA
         /oyghwdZmUSMulZuLan6Gjd6q4jlCqxpvZA3d27VmuP3s7M9OnxNJSZwH41tBt9neFA2
         Yq13+p9ZNjJWvYzb6kaxkzLofRJof7fFs19jpgr098mT/LXXVatLXvhkhsJp8+pSdz13
         3BK2+qXSzdwzqkxnCFT/zxWxCseftsBQ7bihF324okXIanSDSbBO814Pqvy8tNdx8yQC
         YbAL7gwPpkOACnyEApavSZsxWLZema2CofAJV40YbCc5BaxBjFUXEdVtbfUKdx5eM8wt
         nG4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787436659; x=1788041459;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6sO7WfhAIJ1nbuSFCtyRgBBYLF8hs1ePKr0RCA4N/Wo=;
        b=D5WEFr4IIMsBFl3DShTHpLukySZTRbjEdqrgPOF04ZrbqB7y68jHlJeuLPLTW3ymYQ
         wefFdMq/i+uipeiCZn10HM8LJ+L5YApIKQQ9O+/9r+wTzn3BGyaBqnGgxpFLpNBbqAP9
         YT5OXb8zNA+z92IMX5JHoiAY77b1xWPDQKW/AG1n0TeTtHsIM4UBuWsUOf1PWt9M9pj+
         C74EX6RanfjOOYHtIFmJO/K5/mj6a3vmM36yTnceOMoXvZdw2IA5rkX4hq+Izo2491zr
         VO7/wSceAMmhFZmC3grhgYvWc//XC2fhCAYP0pfp1zT7FWWX8ruyG2hxaFAJgwRwTUtI
         dkJA==
X-Forwarded-Encrypted: i=1; AHgh+RqDGkpEsjedgDnrBCiUQWbeldRL0Sn1eUYMuukLp+WgAcvuDJ1Bc5hPNhW0JlcjX6Z0cnpxQODdBPeWrA==@vger.kernel.org
X-Gm-Message-State: AFuF++kdwckIADmsJWnmg6Oh1j7WoJo8Dea8G/hg1KpO+dW8fl8ZVK4y
	FwpET6pthuBuX5Z3ZXgdM9qKuq7bsxkpbAcZoEdF0sw+N2jZEtjz1z8EveAeBA2BE7g=
X-Gm-Gg: AR+sD12wwcmd8x56jAK51NkaweJl+upO2KKL0Tjp7ywHNAee06qe5bF622vjyemLW4B
	rcNtBhLXk+ldVimZG3bQkFvRwd8ERkJHBIY6oRlmRl7ebv64vTtRcje/GPbS3K8SAD10iSVqmhG
	0rhnYlAftwKVu3NVYnIDZPHHh/OkLDFm4MOnnia8R8ZkG5GAZiCs3kLt9vkb51Nq7smBFY4TzEo
	h91WEsMgOEtl9YPqPmtshy9+1TnOaojPo8SLvDWDRNZxSXxAdif3pxVX9Qxq1Sm+2l5D5Xvzloi
	v9mNaV0EUOw5Oz2cSMscH09TQrADjVO6b7y7IFeU9uhi4ch90shNXec3X69JRC1U1wO6slUPZZv
	3FBdGzaqHr+iPYPn8ZiaHyP+4swfYZRXkWpxHoi49S3rp0usj8rI7OPYN1O32vPQ/ut9hrctyUo
	SMXRiVerbbkfiH84dx7f3oYk/Q1uJXi+sqMOPiIZK2yo8jF2FFMpH6LQ==
X-Received: by 2002:a17:907:e00c:20b0:c20:23f8:99a5 with SMTP id a640c23a62f3a-c246a6a402cmr1255924666b.15.1787436658917;
        Sat, 22 Aug 2026 15:10:58 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395e4b46518sm3939114a91.17.2026.08.22.15.10.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Aug 2026 15:10:57 -0700 (PDT)
Message-ID: <f7fc4ab6-7a52-48fb-9dd2-fee5aac11727@suse.com>
Date: Sun, 23 Aug 2026 07:40:53 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zstd: keep the last max level workspace out of
 reclaim
To: fy15309206903@gmail.com, David Sterba <dsterba@suse.com>,
 Nick Terrell <terrelln@fb.com>, Chris Mason <clm@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20260822-btrfs-zstd-max-level-reclaim-v1-1-0eb13c127480@gmail.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <20260822-btrfs-zstd-max-level-reclaim-v1-1-0eb13c127480@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/22 22:15, FAN YE via B4 Relay 写道:
> From: FAN YE <fy15309206903@gmail.com>
> 
> zstd_put_workspace() makes the "hide this workspace from the reclaim timer"
> decision only when the workspace is returned at its own level.
> Decompression always asks for level 0, so a max level workspace borrowed by
> a read skips the whole block and the test for being the last max level
> workspace is never made: it goes back to idle_ws[] still linked on the lru.
> A read borrowing one while a write holds the other is enough to leave every
> max level workspace on the lru, where the reclaim timer can then free them
> all and clear the level bit.
> 
> Once no max level workspace is left, zstd_put_workspace() never reaches
> cond_wake_up() and a task sleeping in zstd_get_workspace() after a failed
> allocation has no possible waker.  Make the decision on every put of a max
> level workspace and unlink it from the lru when it is the last one;
> list_del_init() in zstd_find_workspace() keeps the entry usable for that.
> The test also no longer hides workspaces of other levels, which it did
> whenever no max level workspace happened to be idle.
> 
> Fixes: 3f93aef535c8 ("btrfs: add zstd compression level support")
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: FAN YE <fy15309206903@gmail.com>

Sashiko found a high level problem:

https://sashiko.dev/#/patchset/20260822-btrfs-zstd-max-level-reclaim-v1-1-0eb13c127480%40gmail.com
> ---
> Reproduced under QEMU/TCG.  Both arms are the same kernel with the reclaim
> interval shortened to 100ms and a module param picking the old or the new
> zstd_put_workspace(); the workload is compress-force=zstd:15, three rounds
> of four concurrent writers followed by drop_caches, four readers and two
> writers.  "unprotected" counts puts of a max level workspace after which
> nothing left in idle_ws[] is off the lru; "borrowed" counts a max level
> workspace taken and returned by a lower level request, the path this patch
> changes.
> 
>                      borrowed   unprotected   timer cleared the level bit
>    current code       245/339       118/216                          1/0
>    this patch         300/379           0/0                          0/0
> 
> borrowed is of the same order in both arms, so the zeroes are not "the code
> was never reached".  The last column needs the reclaim timer to tick inside
> the window, so it is a coincidence rather than the criterion.
> 
> Compile-tested (W=1, x86_64 defconfig + CONFIG_BTRFS_FS=y).  Independent of
> and applies without my lost wakeup fix for zstd_get_workspace(),
> 20260821-btrfs-zstd-lost-wakeup-v1-1-84f358d4ea67@gmail.com.
> ---
>   fs/btrfs/zstd.c | 25 ++++++++++++-------------
>   1 file changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
> index 86919293fd54..8abc4e456f32 100644
> --- a/fs/btrfs/zstd.c
> +++ b/fs/btrfs/zstd.c
> @@ -260,7 +260,7 @@ static struct list_head *zstd_find_workspace(struct btrfs_fs_info *fs_info, int
>   			/* keep its place if it's a lower level using this */
>   			workspace->req_level = level;
>   			if (clip_level(level) == workspace->level)
> -				list_del(&workspace->lru_list);
> +				list_del_init(&workspace->lru_list);
>   			if (list_empty(&zwsm->idle_ws[i]))
>   				clear_bit(i, &zwsm->active_map);
>   			spin_unlock_bh(&zwsm->lock);
> @@ -335,18 +335,17 @@ void zstd_put_workspace(struct btrfs_fs_info *fs_info, struct list_head *ws)
>   	ASSERT(zwsm);
>   	spin_lock_bh(&zwsm->lock);
>   
> -	/* A node is only taken off the lru if we are the corresponding level */
> -	if (clip_level(workspace->req_level) == workspace->level) {
> -		/* Hide a max level workspace from reclaim */
> -		if (list_empty(&zwsm->idle_ws[ZSTD_BTRFS_MAX_LEVEL - 1])) {
> -			INIT_LIST_HEAD(&workspace->lru_list);
> -		} else {
> -			workspace->last_used = jiffies;
> -			list_add(&workspace->lru_list, &zwsm->lru_list);
> -			if (!timer_pending(&zwsm->timer))
> -				mod_timer(&zwsm->timer,
> -					  jiffies + ZSTD_BTRFS_RECLAIM_JIFFIES);
> -		}
> +	/* Forward progress depends on always keeping one max level workspace */
> +	if (workspace->level == clip_level(ZSTD_BTRFS_MAX_LEVEL) &&
> +	    list_empty(&zwsm->idle_ws[ZSTD_BTRFS_MAX_LEVEL - 1])) {
> +		list_del_init(&workspace->lru_list);
> +	} else if (clip_level(workspace->req_level) == workspace->level) {
> +		/* A node is only taken off the lru if we are the corresponding level */
> +		workspace->last_used = jiffies;
> +		list_add(&workspace->lru_list, &zwsm->lru_list);
> +		if (!timer_pending(&zwsm->timer))
> +			mod_timer(&zwsm->timer,
> +				  jiffies + ZSTD_BTRFS_RECLAIM_JIFFIES);
>   	}
>   
>   	set_bit(workspace->level, &zwsm->active_map);
> 
> ---
> base-commit: 26260251022fbc2f248a3d747a9b2b961b18d2d8
> change-id: 20260822-btrfs-zstd-max-level-reclaim-5ab59a71f83e
> 
> Best regards,
> --
> FAN YE <fy15309206903@gmail.com>
> 
> 
> 

