Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4444534A9
	for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 22:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780093391; cv=none; b=Zg25Apva7fni0oJ8SkDuWVgbQN+vepa2My9JBPxXy+j1ZqCIAtp1vVIW/9XmcScYu/ohlhOglfxUOYbqFmIrr+/3nx1rZ419Af9YronYxzhSf46gDn6Amm3WBTWvorw97RSyuPl4czhGTCKNb0smtCZWsjNlb9HJyFXsRdbRX/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780093391; c=relaxed/simple;
	bh=qII8T5/4CGGmX+iIn4/z9aFv9zfQxu8ShsOmBbgJmUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=opSenfP95Db+vHyM6NcJvrFKerWyizlJGq/ixRMZ+oz/3K19i4nMAgrEQoHFGpRGK5c/gNOKykmCCLrW1qvFp/uom/+qVuO76gKg3FuVOT2KBkXQH+rh0pLq+DeRbNZU6lCt6ObzTOBBIXgtjs8n10EOIdWqHtXdCpwjUhm6060=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eMavUYkb; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eMavUYkb"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4891c00e7aeso97103095e9.2
        for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 15:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780093388; x=1780698188; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=s6eK9V5Obcs3oCWa0B1O6BNOJ/cy3Xl+hbhAxQSjdFo=;
        b=eMavUYkbGlHhh63NyjPr3T7FKPcXC5YYbahUE2kwJPOfEpWUbGH7S93n6UeIC+e/bH
         Rpx1hgf+RGfuRPdqrMb+qwrmYDwLebojantbT1ZkPR/tOSCj6KoyGSJNb4Z+BeMMv4rc
         dt5YhcAOo6WAnbHMM+V/PpK0FQngdfgEZwNjQS8CBffI4MaH1NlG7TTwREgVCstSQQja
         yeet/ZKlxW6w10rF1c8sWxPU70hSup2ZS6EvgQPBCOxnTPoPWELD4Ni0u5S5gXQ39dy1
         ECwsjmASSBfi+J40XcnGkSJgETyyWRtPK5wvZKIPAxN97EilES7p39OLLj7O5V0DYbu2
         Qdeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780093388; x=1780698188;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s6eK9V5Obcs3oCWa0B1O6BNOJ/cy3Xl+hbhAxQSjdFo=;
        b=lHEmUvKuV/eelS+0Q+9olpGUf1LuUedwi4sEmce13v6S+V2Ab7o9Ky5O/p4o6E6Dqu
         KlCO5gHhu80X0Q4DLT+OgnIqWAd74MW0Fq8+JNyTDmZ3wVSeK0lmRsWDZsldTpYR9npB
         qKLVc2OrG9ywMZ1SqJbTyBgwY8auDDBZ9Xhl4xCU7HXbXxMZzjwil9GykJBb4/8pVokR
         PRf+0xS2JhyTE0qzCWSju+H5q2v8m0fiDpmN4FkGDeaiXpqfCEvJMxjjt+nt+BODym54
         OPW/ybVbKABFZunLMOKeq8skT8IGys5VTHnKpc1qnAE2D6TDILlZ7j1G1IB04Rl83k5O
         RFcQ==
X-Forwarded-Encrypted: i=1; AFNElJ99XUB2maMayKsC8P3n5Sxh7cP/Fim58zIYDAcXe28VXAq2+pEAEjdlZEHJBUZSULGRjm//ZtQyj0MJdg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwW74hwIi5FCozIN4EatkcWAnU9R1Heyz+oLQEQloEN0PK3++1x
	lR7CUeyHu6LbnzgV1ng0x9VXVVy0Tv/2Q/5smJd1LDxrs5+fu42mT9s103qU79Io3Hg=
X-Gm-Gg: Acq92OHG55assP6RzGKJRtBvKjRSX1PuXtfmphnrAr1PnuRy2UyQhdzLydMZsm23U2R
	UYcePALPU7ZmFeRBugXkhEzas2oK3mANVnsVfdd9t6K++fQ6043dDciJ5gYnKtqa6XDIAlMiF5R
	JkM0LyegRIduvYJ9hnDRfO2W6uSX8TyAZO+CjzICb84vxUe2NH7U9fr5Sgi4dZGI9ZmiO3xVmFM
	fqKklwtBfazuHcqHmYaHBBsSczCRIenDIxaxAI5bx/z+b71ZBYksxJGVVKERtHgxgT8gJqxgsoR
	+IBh76fqcsK1Xt2QXEBc+CyBnlQZZe0xBfSuREUFaNkD+aStRcuupHIUDq1uMuBjEKyo0h7ID9U
	MCmXGaNSjVCXIYM4TdpmVmRSeUbz1VrCsjNNC1BsKymK5GDPE0n96thG0PJQEzcrrpOqWVE1bUF
	nfq4Bfvo7k/KxcUgs4uCNE9ejlENUiA1M9uNiRBfId4H1WXnX+uOuSvUeu+/cVNKnlFwwO/F733
	ZfwAflKe3r4D+jvKrY25vmz6G6LZ0FSoDG5wspT0suZG35xpMw4wAptmlsR6ZMyclYk
X-Received: by 2002:a05:600c:4e92:b0:48d:366:b962 with SMTP id 5b1f17b1804b1-490a2900ef2mr22588725e9.6.1780093388540;
        Fri, 29 May 2026 15:23:08 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214b02365sm2871139b3a.8.2026.05.29.15.23.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2026 15:23:07 -0700 (PDT)
Message-ID: <80004fc8-1a9e-430b-a20d-2fad3006a6e0@suse.com>
Date: Sat, 30 May 2026 07:53:00 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: use lockless read in nr_cached_objects shrinker
 callback
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
References: <4c64ed769cbb827b8c55de8f89372fc27290feea.1780089816.git.boris@bur.io>
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
In-Reply-To: <4c64ed769cbb827b8c55de8f89372fc27290feea.1780089816.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/30 06:53, Boris Burkov 写道:
> From: Ben Maurer <bmaurer@meta.com>
> 
> Under heavy memcg-driven slab reclaim with many memcgs and CPUs,
> shrink_slab_memcg() invokes the per-superblock count callback once
> per (memcg, NUMA node) tuple. For btrfs that callback reaches
> percpu_counter_sum_positive() on fs_info->evictable_extent_maps,
> which takes the percpu_counter's raw spinlock with IRQs disabled and
> walks every online CPU. With hundreds of memcgs driving reclaim on a
> host with dozens of CPUs, this counter lock becomes a global
> serialization point: profiles show CPU pinned in the spin_lock_irqsave
> acquire under __percpu_counter_sum, with cross-CPU IPIs hitting
> csd_lock_wait_toolong while waiting for spinning vCPUs.
> 
> The shrinker count is advisory -- super_cache_count() already notes
> "counts can change between super_cache_count and super_cache_scan, so
> we really don't need locks here." Use percpu_counter_read_positive(),
> which is lockless. Worst-case skew is bounded by batch * num_online_cpus
> (a few thousand), negligible compared to the millions of extent maps a
> busy filesystem accumulates and well within the noise that the shrinker
> already tolerates.
> 
> Tested-by: Boris Burkov <boris@bur.io>
> Signed-off-by: Ben Maurer <bmaurer@meta.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/super.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 958dd185c0d6..c946bccf0748 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2432,7 +2432,7 @@ static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
>   static long btrfs_nr_cached_objects(struct super_block *sb, struct shrink_control *sc)
>   {
>   	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
> -	const s64 nr = percpu_counter_sum_positive(&fs_info->evictable_extent_maps);
> +	const s64 nr = percpu_counter_read_positive(&fs_info->evictable_extent_maps);
>   
>   	trace_btrfs_extent_map_shrinker_count(fs_info, nr);
>   

