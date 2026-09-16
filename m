Received: from mail-ed2-f35.google.com (mail-ed2-f35.google.com [74.125.228.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BFD4B1269
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 22:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789599109; cv=none; b=S/y/4Ae+5CvAomH1tjYdAcR69+HFhi4zTbOgzs+ED2Py5mandYH9/rLVmb5Vd/EE9QxdOxstHWW9aKuzAk8OH5EqSLJ7HZWvHFyCGN6OirNaOCA6em1CJgbCbhXrIbxkXj+vwWwwts+i0evgFiTs6NtnhDWAMklNG8yMl85Fw4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789599109; c=relaxed/simple;
	bh=CNg96jRfOtV+UhpdH7GYfJnDLPQM1GKzQ0y/uAWg1mk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=D02IdrELBgIGZatop3uG9lLwOuol8FNLQCeQJe990JHg7ID4eHkRvE3PmFnh/iDgmGVsOBnz2kGTZagsv8uFiJ6VZ3Hm/PQ80yAFLAYa/9fp/Me7x1RxofMONo27gffZwxkYf0gSpfsH8fBQVEtUHyth9qjmqrS6jlCb2ZHyPBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WFatcoiz; arc=none smtp.client-ip=74.125.228.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WFatcoiz"
Received: by mail-ed2-f35.google.com with SMTP id 4fb4d7f45d1cf-6a6056ac81fso439791a12.2
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 15:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789599102; x=1790203902; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=egIbrW/qn+tc0sPWPAfAcjufJlz+TuiefiTHZGDwn0Q=;
        b=WFatcoizv2cz7lyN1/pjx8QzP8nLcV944SZ4E78FwKA9oDe0uBP4rTbeVK0jScZTEd
         xa/bIsmHQcmYzb6zXltnHxq56crQBH0Z131cpRfZMDcN87DKHNZwykhPICn8PmV/GI97
         G6uEt+c+QHWAUSEe8W+SJ0/dI0AgfDD4rSr9fqoci0mXgL3gZ8uNxTR3jbbfv6HLjdAh
         KsFv33D0woaGoVX0ouJjgpddcwWWcom1KbFCfGOBS84uyDG/C8SaLWBehKEdNS1KsnWS
         f8Og7ljrVf6bQNwHWuFYiQkkMuKceph6ycI5D+3WAXiNSeNCfPV3ceG6Qy2aBGvyo/2D
         zA4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789599102; x=1790203902;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=egIbrW/qn+tc0sPWPAfAcjufJlz+TuiefiTHZGDwn0Q=;
        b=tj3TwpR5DvV8SoRHeQ9FzY6kI6qHbjqrmLZUg5yFcDBwmR5BXFxz0Fyn3+cYPWDsCS
         reGNs+yDIkB0ySK7Fpl9wWXf4d1gXj0cyD5kjkuaB+wDTLTK1RChkGqm++BPnvjP3VqC
         hiNf2SP1hHvIfETwY3aQlanNVX2XROWc+lfuoeWtpSTVzsCrTguPao793IPrqRjhev+h
         OxN3C45oqusRt4Z8f6e4Do7zUZCjCFa0lwFqZ+k/2UYYu0SiGMa2MKgOjgQ1P8pZvgBq
         m4W0sM7iwk0Bx5L1Micnc6xUugu5Q3l5q+ou4PDOKsZvtMVY+XrrQXfVJk/wyIRwxe9x
         cKUg==
X-Forwarded-Encrypted: i=1; AKwUvByRHNeUbPVAvr6ra/aHDgOI+hDq/kucvOWgJO17Y2rYdMLpwNRnCJotI4jrlQcPJzUPNTFC0MGK9C7YLQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lWvHdR6Fa9+WVSR8kAUO/73uRSs2l0XSDzBqctaCpXfucBYgrG
	LwAorzPXUDpH7mfJBmlypNUGTX2xwOVvqenZ9mbjPOxQZWUZ4+xszLT6RPQUs95f1v8=
X-Gm-Gg: AYBFou0l4xW8aGkX9faHCGs58i7XLM6/05uvxvaFwQbFVzw8lVAHQsnoylM/yFBNlfO
	UVg0SURjMdoxZ9KxQkwpfi2QrkI1njy2OQXpyY1KuXYVB/Gr+8wFd68r3X7u7WAmCUlJH23wdKI
	kLycZ7UWm502ra5ibTA9pcvJG3cPjW8O2sAe5+n2PzzF3fqboW+ebJHeKJvpOVko+9PHyqy7p3/
	pMz8XYCwg81B4q7X62JqWXSt5ZkOmSemYMoewId62XRxnHgtxbId8Ce6uh7U5V26a/WxeCCnXUU
	rkXKAfPjuMB8vQoL+yUInXN3411tY9XjZfFjJkZU4BAEsxdxm4FQgyVnysEih5c+zNCqgh1yWjx
	nC10MgCSNWxP3/7LL7YOkFhapLZTw/seULgcZqe8dR6BLi5XqmWgtg8YQcJLIfWcc9LLpXKQrCa
	mY5lUfDCbKkKLABT7jiv6JTnh5FjEztBqtsAi+GelDmF0OpbWNruRWXhWY7l3B+R0lYT/H+1tMR
	B8=
X-Received: by 2002:a17:907:da9:b0:c29:cfce:1946 with SMTP id a640c23a62f3a-c29e52b691amr291675466b.15.1789599102220;
        Wed, 16 Sep 2026 15:51:42 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87201b2c5cbsm1918410b3a.48.2026.09.16.15.51.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 15:51:41 -0700 (PDT)
Message-ID: <04e6331d-6b7a-4a2f-9eca-8aa7f0e4042a@suse.com>
Date: Thu, 17 Sep 2026 08:21:37 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: keep unused block groups queued when a pass fails
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
References: <455009bf67d45ccb8df8c2a0aec270a16db80510.1789597031.git.boris@bur.io>
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
In-Reply-To: <455009bf67d45ccb8df8c2a0aec270a16db80510.1789597031.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/17 07:47, Boris Burkov 写道:
> Once any block_group sets ret!=0 in the main loop of
> btrfs_delete_unused_bgs(), the check
>    if (ret || btrfs_mixed_space_info(space_info)) {
>            btrfs_put_block_group(block_group);
>            continue;
>    }
> skips the rest of the unused bgs while unlinking them from
> fs_info->unused_bgs. There is no "level triggered" re-queueing of empty
> block groups onto fs_info->unused_bgs so it is possible to leak quite a
> bit of space this way and unless we happen to get a balance or
> re-use/re-empty one of these bgs, they are leaked for good, which can
> lead to a spurious enospc later.
> 
> While I have observed such leaked blocked groups that are empty but not
> on the unused_bgs list on production systems, I have not observed that
> it is definitely due to this issue. I also reproduced this behavior by
> injecting an ENOSPC error from btrfs_start_trans_remove_block_group
> which can also fail with ENOMEM, so this feels like a legitimate
> injection point.

Do have happen to know which error caused this non-zero @ret?

I did a quick glance into the loop, it looks like it's not that easy to 
get a non-zero @ret:

- inc_block_group_ro() failure
   @ret is reset to 0, so not this path.

- btrfs_zone_finish()
   I guess meta is not deploying zoned btrfs in production.

- btrfs_star_trans_remove_block_group()
   This can return -ENOSPC, especially considering we have just marked
   one bg read-only, thus even stealing from global rsv, we may still
   fail with ENOSPC here.

   Although I'd say, that means the inc_block_group_ro() checks are not
   doing the correct reserved space checking, and that may be the real
   problem.

- btrfs_remove_chunk()
   If it failed, the trans is already aborted.

> 
> To fix it, instead of checking ret in the loop, just break out of the
> loop when ret != 0. Also, link the bg to the retry list at the
> individual failure sites so that the failing bg is not leaked.
> 
> Assisted-by: LLM (reproducer/error injection)
> Signed-off-by: Boris Burkov <boris@bur.io>

Otherwise the handling looks correct to me, doing the proper handling on 
error, other than delaying it to the next iteration.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
> ---
>   fs/btrfs/block-group.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index ee182369254c..2eb09c9901c9 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -1612,7 +1612,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
>   
>   		space_info = block_group->space_info;
>   
> -		if (ret || btrfs_mixed_space_info(space_info)) {
> +		if (btrfs_mixed_space_info(space_info)) {
>   			btrfs_put_block_group(block_group);
>   			continue;
>   		}
> @@ -1727,6 +1727,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
>   		ret = inc_block_group_ro(block_group, false);
>   		up_write(&space_info->groups_sem);
>   		if (ret < 0) {
> +			btrfs_link_bg_list(block_group, &retry_list);
>   			ret = 0;
>   			goto next;
>   		}
> @@ -1749,6 +1750,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
>   						     block_group->start);
>   		if (IS_ERR(trans)) {
>   			btrfs_dec_block_group_ro(block_group);
> +			btrfs_link_bg_list(block_group, &retry_list);
>   			ret = PTR_ERR(trans);
>   			goto next;
>   		}
> @@ -1759,6 +1761,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
>   		 */
>   		if (!clean_pinned_extents(trans, block_group)) {
>   			btrfs_dec_block_group_ro(block_group);
> +			btrfs_link_bg_list(block_group, &retry_list);
>   			goto end_trans;
>   		}
>   
> @@ -1845,6 +1848,8 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
>   next:
>   		btrfs_put_block_group(block_group);
>   		spin_lock(&fs_info->unused_bgs_lock);
> +		if (ret)
> +			break;
>   	}
>   	list_splice_tail(&retry_list, &fs_info->unused_bgs);
>   	spin_unlock(&fs_info->unused_bgs_lock);

