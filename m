Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF2732AAA7
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 00:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773275019; cv=none; b=AYw1m8fFxmIBKQfOdXNZLxx52EP/0PiUNkyc20Prex/ALZ4QjAKy215tsTpCq621hZa6xGVQoZvNuO/X3KvSXrhXPBywTcvT6NjSPW+TjfYG7luA7ArR0OMLlfogW3MplLn6n5xBi6sHeAmdywKM/7yoL+VqMDgzmyiX1M1Dwf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773275019; c=relaxed/simple;
	bh=lIREHVsprLQv+sgvZvN0VmPTBmLtDoktLDJp29IoUnM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sh/WeOwfTWgy0fRsbmMkR5yXGaf0WP3dKxPshYIdkBPeC9KF2rSvDN2y6grT8mWfB/fP6pnTIzFyvchy4XHS5FTZxXINwd3ctNPXgiOoHEtTlDGqsOZgrlJC6apsrLuj2yjj2/ZI1XzaukiHJXeM8ynN1JSZKdPFA6I5IyJJphY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fpq3h+sL; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fpq3h+sL"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48539cbb7b1so2074285e9.3
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2026 17:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773275015; x=1773879815; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=v1jAmHuTmJRFGX94V+S2RHH1PydmtxgIsgp10o+ygDg=;
        b=fpq3h+sLg+PWdHvDG9isqzJowL0anZwTqVhLhmS5tfmexwB4z2SEJ3mWluz+pkfb/M
         7T7iJBZMizbfipvTCSZlN8L+8PaO5MPbuIZDhAHUYS+xYZH3e6FBxgPnFRig8sVqfXhy
         yzHNEf0u9TOSJYiknjaXkdC6kVjXtoEZ8ib3w7wx65+RSqH7NUYaVn90S8UtnrmbVwbI
         PnBGYVGy5I3HL3g6pGd+ihdmWghkE35lCH+WTVOxhisthK6vUZME7lETIO8rn9i8V+zC
         nfx9pR4bJpz1hrQpLg6G+sS5YPWlvKPdOLT/qIm8Lkicx1z6FugnZ361UgiTbXp2ACRj
         yCew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773275015; x=1773879815;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v1jAmHuTmJRFGX94V+S2RHH1PydmtxgIsgp10o+ygDg=;
        b=FpQ0KZNrlOm6QxZM7OLCLRe1Etgj1AObEJJUQwJ5Hd2J0XOsPVCoopfXBbcKqIKeiN
         wHutAmCgiq4ocOTv/68YIxvYHxBeaL3Ngm4pK5O/WZ/nvS0F5EKKIlW7RSJQIgi1XbV/
         HgVCIEzPVMaBdfFvewTRGW55jKAtH3Po82ZTwryHnDqE2WM6Mt+2KHy/LgXEiQ7dCl8z
         40Qyff1YpjbpKfQ67/t7A7HPzzg8iT3HwRq4YfUUyuGXV2EMCvZOkoHw7N4ohI6qHXnd
         3T+vas7EDrqtIZsjkf7Gvs+qdRpWtfHyEh0mcrj2RrZyM0cK1ZQF/gMWM7CccPE2q5Wz
         DUsg==
X-Gm-Message-State: AOJu0YxYCplwGgyiNYz1QI7woLQFCXNVL93ch47heoBrLhw6gai8ggcM
	bou7JJQErASzPEUEBWSEO1zA7ee4i10+8U+AYZOYGpGBuWumCUYxZLlw9tn2ymGdMtE=
X-Gm-Gg: ATEYQzwgHUYSFiJCgdUK7n3GmFyPWcb3fdYP2mgi3Q6SLPFpEbTkHj4t7+4MfYHq++R
	aQbYqndE2k/sPSJysblcQXjbTC1GSbCTAVRScEyXvW5/U7PpLq62QpvCE4A+wPG7fP9nC+2yMgp
	ayttsZ4TOebYvcip2buabUV2WC8zIIP251gc46AeJob8/TBhpk3oa0M3AXpMbSvuz+Zve1Hv3L4
	OVdlhKsmSQxCu8MMfY4rgWZ6kXpjk50XbdkK106tDn3uPFz6PIxS4xFJY1gflzznZ5mNZOcs+Z8
	GOqpDqP3qyRybOiMUN6/UKS+wrgTNjhRyZCIaOPkzCTdupdYnbuhTP+CQ7ZHufX9chWv/VZoTH/
	S8QxnpqbRr7lGxwbREcsRpp4wB/oTlnx8FvicokGUlPatrOo/YwBMQJ6pv4v9d742T3AHQHG5J5
	UNro7t/Fib2uHQebkhq1AJ96LfLpa0YOfJ0khVMirrOz2vXpAn4BU=
X-Received: by 2002:a05:600c:314e:b0:485:3f65:94a1 with SMTP id 5b1f17b1804b1-4854b10a1ddmr80933685e9.18.1773275014806;
        Wed, 11 Mar 2026 17:23:34 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae34cc99sm35120315ad.54.2026.03.11.17.23.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 17:23:33 -0700 (PDT)
Message-ID: <17c102a6-bbd1-4937-b5cc-5f6912551180@suse.com>
Date: Thu, 12 Mar 2026 10:53:27 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: reject root items with drop_progress and zero
 drop_level
To: ZhengYuan Huang <gality369@gmail.com>, dsterba@suse.com, clm@fb.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 stable@vger.kernel.org
References: <20260312001443.3011961-1-gality369@gmail.com>
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
In-Reply-To: <20260312001443.3011961-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/12 10:44, ZhengYuan Huang 写道:
> [BUG]
> When recovering relocation at mount time, merge_reloc_root() and
> btrfs_drop_snapshot() both use BUG_ON(level == 0) to guard against
> an impossible state: a non-zero drop_progress combined with a zero
> drop_level in a root_item, which can be triggered:
> 
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/relocation.c:1545!
> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> CPU: 1 UID: 0 PID: 283 ... Tainted: 6.18.0+ #16 PREEMPT(voluntary)
> Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
> Hardware name: QEMU Ubuntu 24.04 PC v2, BIOS 1.16.3-debian-1.16.3-2
> RIP: 0010:merge_reloc_root+0x1266/0x1650 fs/btrfs/relocation.c:1545
> Code: ffff0000 00004589 d7e9acfa ffffe8a1 79bafebe 02000000
> Call Trace:
>   merge_reloc_roots+0x295/0x890 fs/btrfs/relocation.c:1861
>   btrfs_recover_relocation+0xd6e/0x11d0 fs/btrfs/relocation.c:4195
>   btrfs_start_pre_rw_mount+0xa4d/0x1810 fs/btrfs/disk-io.c:3130
>   open_ctree+0x5824/0x5fe0 fs/btrfs/disk-io.c:3640
>   btrfs_fill_super fs/btrfs/super.c:987 [inline]
>   btrfs_get_tree_super fs/btrfs/super.c:1951 [inline]
>   btrfs_get_tree_subvol fs/btrfs/super.c:2094 [inline]
>   btrfs_get_tree+0x111c/0x2190 fs/btrfs/super.c:2128
>   vfs_get_tree+0x9a/0x370 fs/super.c:1758
>   fc_mount fs/namespace.c:1199 [inline]
>   do_new_mount_fc fs/namespace.c:3642 [inline]
>   do_new_mount fs/namespace.c:3718 [inline]
>   path_mount+0x5b8/0x1ea0 fs/namespace.c:4028
>   do_mount fs/namespace.c:4041 [inline]
>   __do_sys_mount fs/namespace.c:4229 [inline]
>   __se_sys_mount fs/namespace.c:4206 [inline]
>   __x64_sys_mount+0x282/0x320 fs/namespace.c:4206
>   ...
> RIP: 0033:0x7f969c9a8fde
> Code: 0f1f4000 48c7c2b0 fffffff7 d8648902 b8ffffff ffc3660f
> ---[ end trace 0000000000000000 ]---
> 
> [CAUSE]
> A non-zero drop_progress.objectid means an interrupted
> btrfs_drop_snapshot() left a resume point on disk, and in that case
> drop_level must be greater than 0 because the checkpoint is only
> saved at internal node levels.
> 
> Although this invariant is enforced when the kernel writes the root
> item, it is not validated when the root item is read back from disk.
> That allows on-disk corruption to provide an invalid state with
> drop_progress.objectid != 0 and drop_level == 0.
> 
> When relocation recovery later processes such a root item,
> merge_reloc_root() reads drop_level and hits BUG_ON(level == 0). The
> same invalid metadata can also trigger the corresponding BUG_ON() in
> btrfs_drop_snapshot().
> 
> [FIX]
> Fix this by validating the root_item invariant in tree-checker when
> reading root items from disk: if drop_progress.objectid is non-zero,
> drop_level must also be non-zero. Reject such malformed metadata with
> -EUCLEAN before it reaches merge_reloc_root() or btrfs_drop_snapshot()
> and triggers the BUG_ON.
> 
> The bug is reproducible on 7.0.0-rc2-next-20260310 with our dynamic
> metadata fuzzing tool that corrupts btrfs metadata at runtime.

I'll move this part into the BUG section as it's about how the bug is 
triggered.

> After
> the fix, the same corruption is correctly rejected by tree-checker
> and the BUG_ON is no longer triggered.
> 
> Fixes: 259ee7754b67 ("btrfs: tree-checker: Add ROOT_ITEM check")

Again, it's not a bug fix. You're just adding a new check.

This fixes tag should only go with the error message fix.

You don't need to send a new update, I'll do all the update at merge time.

Otherwise looks good to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> Cc: stable@vger.kernel.org # 5.3+
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
> [CHANGELOG]
> v2:
> - Split out the error message fix from the previous patch, as requested
>    during review.
> ---
>   fs/btrfs/tree-checker.c | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index dd274f67ad7f..1e052c3303b3 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -1260,6 +1260,23 @@ static int check_root_item(struct extent_buffer *leaf, struct btrfs_key *key,
>   			    btrfs_root_drop_level(&ri), BTRFS_MAX_LEVEL - 1);
>   		return -EUCLEAN;
>   	}
> +	/*
> +	 * If drop_progress.objectid is non-zero, a btrfs_drop_snapshot() was
> +	 * interrupted and the resume point was recorded in drop_progress and
> +	 * drop_level.  In that case drop_level must be >= 1: level 0 is the
> +	 * leaf level and drop_snapshot never saves a checkpoint there (it
> +	 * only records checkpoints at internal node levels in DROP_REFERENCE
> +	 * stage).  A zero drop_level combined with a non-zero drop_progress
> +	 * objectid indicates on-disk corruption and would cause a BUG_ON in
> +	 * merge_reloc_root() and btrfs_drop_snapshot() at mount time.
> +	 */
> +	if (unlikely(btrfs_disk_key_objectid(&ri.drop_progress) != 0 &&
> +		     btrfs_root_drop_level(&ri) == 0)) {
> +		generic_err(leaf, slot,
> +			    "invalid root drop_level 0 with non-zero drop_progress objectid %llu",
> +			    btrfs_disk_key_objectid(&ri.drop_progress));
> +		return -EUCLEAN;
> +	}
>   
>   	/* Flags check */
>   	if (unlikely(btrfs_root_flags(&ri) & ~valid_root_flags)) {

