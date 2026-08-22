Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C808B3AA1A8
	for <linux-btrfs@vger.kernel.org>; Sat, 22 Aug 2026 08:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787385699; cv=none; b=sT7U/WCMd1s8BvbKty8i+urFjy3JuLLnHP8p1tX94GoMtGlpDC68653J6+NM/JKvSVJkj1XAFztB2q1k8cujZKPR2kInJPQuHWdW+M1qQGvUOxz007f6txfuRlvGb6q0h1vCp/8hSfIPWdqDlz4dJUA9vO0cKWkryHbonhFQPCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787385699; c=relaxed/simple;
	bh=LEythSh93ur+JuZh7bNhyBxjlDajGTMWB4vMIXkoXQs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rzYy6/Oa2HwdJg2MQO62WMvcT+kiV+vDzlNbPCKhusCoFULSI3dl+8j5t94D9rfwdmitle0ggerZ0tX/N+9fIeqdygwmjQunmecWoQHWpR0scZBZueNAGH3skj91tW/RRvTrv9ohUc2wDZklBXpufjXCQ1Ca0PtZMpn+M27CLt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RwxhK/MJ; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RwxhK/MJ"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4998590d392so2001445e9.0
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Aug 2026 01:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787385695; x=1787990495; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f6teVtwP/dz97VkrP76nFaD4a1ws+mzZUejjgeL5HNk=;
        b=RwxhK/MJqISfZb7VGJuUe2VkAcN2MeHgKvtR2xaG+kis2L4kCelSpUT0pShyOaqaOM
         aVUT/yQ25ZRvV8BPQVzhaaNr9P8JWhqZuDK7kIkGjOV1lg8ADC2b+6qomrVF1Rrg8SFu
         3+MYexyPrcr+TfVcjqHlxWjLE+Xwfq+EyX4o7IaY04eRzQaPHfsetUEras2uGOQZp8+/
         Pk+Te4PXUg3gacVyJeK/dbt62YrWxfIaqfi5QZB/+ZDM6v3Rp1IUoEUzoNJ+5JL7jpPr
         3bJ26sxia+SNA79ip83y7IlGoeCHmRpVnuarhaSyPM5vqr9Oc5LRab9sb71IuypzLi/6
         ihfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787385695; x=1787990495;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f6teVtwP/dz97VkrP76nFaD4a1ws+mzZUejjgeL5HNk=;
        b=sFfkh4YEINt6fLjt8u4fivsCM9UGUfexQE/ricYB13QqeR8Qac/a3yf/jCtW1i33sM
         Mxmd+przB04JwZXAbEjS+z37TBcHG3GHcwkGuxBcEeVDCUQuh5rqdwPTT8vtDsuluNYd
         rq2LqqkNdjpFARbV5LcFBHfAJBwu0U8FwqovaqYdY6RVB3689bzB+zG4yBaTvP70Xhf5
         aOhu+4Y9aehizm30YysfiwM0dIAbhFlyJu6ajiW6YMeeDSdh9u4dwDUDXu/jxNLl9513
         z6Xyi0hX7Jsv9lDybdwQYymNr17AM205i7d4rqkFsnunoq9BmYuJBg8JVDzgokBc2wnV
         FCtg==
X-Gm-Message-State: AFuF++l/pGhvPrixpOkmmFXE/KzzlugqJAaSh8anF0TIlN9cNNyHy3LV
	UanquSDCKagcLikCIl0EoOY78kGJB5qTabPbDH5Rj26bNVZ0XkQu5B3e38IayuI1nivpq1zhyaB
	06O/ppGw=
X-Gm-Gg: AR+sD10VhE+zYpH6G08bf9ouLFYO8sUHL42ivz9B2ejMcKiawCfBqio3nPx6Z5bmU/a
	SOedp1jCnqRJ/A5dnRGsPCtEr09WGGdpdTiBNXxjxwLKCEQlucbeI8T7Fr/SkY5Hh4+LqPQHxX8
	MBvnAbw9ULj52/ZlNgDY8B0cQoKDjLcLRAakFb/akucyKn8DGsgdZkSlsinq/eM/1PA+Z32540s
	rpwaH8Y1R+PRI3edcjXpeuQkKXMsqFM8qkRKE7yPz7ut4FP5aTwSOZ9zJRC/DkZ+WB6IibajA1P
	vhywyY9M9pN3McG4BWOcAyCjsYQOIvfIS2FSvy79ZkzrFLargYwIHI8RK2ySuGk/5wF/DsXmth0
	hoK/taWzSxZ4a5SenJxK7IOD5snSO/oqkg5spYHb9aqm3kYspJHhcpAYGLFpnxO4Qi8L1JNZ4xP
	G0kw2tP4kyUS0uTH8iWCNHAkZTWQKPK6uaAIX5s/lsYk1KUO8B8UWFDA==
X-Received: by 2002:a05:600c:8b16:b0:495:52a5:8829 with SMTP id 5b1f17b1804b1-499b8343dd3mr132988015e9.11.1787385694829;
        Sat, 22 Aug 2026 01:01:34 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395e4b46518sm1961697a91.17.2026.08.22.01.01.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Aug 2026 01:01:32 -0700 (PDT)
Message-ID: <217f5236-e34d-46bb-97d7-2429f7a74ff6@suse.com>
Date: Sat, 22 Aug 2026 17:31:26 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zstd: fix lost wakeup when waiting for a workspace
To: fy15309206903@gmail.com, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260821-btrfs-zstd-lost-wakeup-v1-1-84f358d4ea67@gmail.com>
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
In-Reply-To: <20260821-btrfs-zstd-lost-wakeup-v1-1-84f358d4ea67@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/22 03:20, FAN YE via B4 Relay 写道:
> From: FAN YE <fy15309206903@gmail.com>
> 
> A writer can sleep forever in zstd_get_workspace() even though a workspace
> is free.  When zstd_alloc_workspace() fails, the task is queued on
> zwsm->wait and schedules unconditionally, never re-testing the pool.
> zstd_put_workspace() publishes the workspace and then calls cond_wake_up(),
> which only wakes when a sleeper is already visible, so a workspace returned
> between the failed allocation and prepare_to_wait() wakes nobody.  The
> window is wide: zstd_alloc_workspace() goes through kvmalloc() and may
> enter reclaim.
> 
> Only a max level workspace triggers the wakeup and one is deliberately kept
> allocated as the fallback every waiter waits for, so once its wakeup is
> lost the writer stays in TASK_UNINTERRUPTIBLE until some other task happens
> to return one.  Re-check the pool after prepare_to_wait() has published the
> waiter, and use the workspace if one turned up.
> 
> Fixes: 3f93aef535c8 ("btrfs: add zstd compression level support")
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: FAN YE <fy15309206903@gmail.com>
> ---
> Reproduced under QEMU/TCG: CONFIG_FAULT_INJECTION_STACKTRACE_FILTER forces
> zstd_alloc_workspace() to fail exactly once and widens the pre-wait window
> to 400ms while six concurrent zstd:15 writers race it. Unpatched, a
> btrfs-delalloc kworker hangs in zstd_get_workspace()'s schedule() (hung_task
> warning, >120s); the identical race against the patched code does not hang.
> Compile-tested (W=1, x86_64 defconfig + CONFIG_BTRFS_FS=y).
> ---
>   fs/btrfs/zstd.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
> index 86919293fd54..cb15cbd737c4 100644
> --- a/fs/btrfs/zstd.c
> +++ b/fs/btrfs/zstd.c
> @@ -307,8 +307,17 @@ struct list_head *zstd_get_workspace(struct btrfs_fs_info *fs_info, int level)
>   		DEFINE_WAIT(wait);
>   
>   		prepare_to_wait(&zwsm->wait, &wait, TASK_UNINTERRUPTIBLE);
> -		schedule();
> +		/*
> +		 * Re-check after being queued: zstd_put_workspace() only
> +		 * wakes a queue that already has a sleeper, so a workspace
> +		 * returned since the failed allocation woke nobody.
> +		 */
> +		ws = zstd_find_workspace(fs_info, level);
> +		if (!ws)
> +			schedule();
>   		finish_wait(&zwsm->wait, &wait);
> +		if (ws)
> +			return ws;

This doesn't work.

         Thread A (last ws holder)  |       Thread B (new ws user)
-----------------------------------+--------------------------------
zstd_put_workspace()               |
|                                  | zstd_get_workspace()
|                                  | |- zstd_find_workspace()
|                                  | |  No WS found
|                                  | |
|                                  | |- zstd_alloc_workspace()
|                                  | |  Allocation failure
|                                  | |
|                                  | |- zstd_find_workspace()
|                                  | |  Still no WS found
|- spin_lock_bh()                  | |
|- spin_unlock_bh()                | |
|- cond_wake_up()                  | |
    No one is waiting               | |- prepare_to_wait()
                                    | |- schedule()
                                    | |- finish_wait()

This is the typical LLM behavior, if your human brain can not examine 
every possibly wrong conclusion/fix from LLM, LLM will only waste time 
of everyone.
>   
>   		goto again;
>   	}
> 
> ---
> base-commit: 531ed942bb0df04f6747983fecdedce76a22d07f
> change-id: 20260821-btrfs-zstd-lost-wakeup-0b0ee88ed52f
> 
> Best regards,
> --
> FAN YE <fy15309206903@gmail.com>
> 
> 
> 

