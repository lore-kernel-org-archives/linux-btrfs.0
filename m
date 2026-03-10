Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3D93EB7E6
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2026 08:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773130398; cv=none; b=E46EiOBEfymb9w+Lxnf9+33SB0Y+2xT/o/Oic25R6s5X2H92hoSAj2w16h2XjgJsMgNfz8DoC7bbPK5vqwz1qh46wpdUu8dms/yfrx7GEaAu1vc8+QqVxMGp3K1190RUkt2ms+TeyTWIBDnX7pabmYEj2QSSN0Q9pZ45lMb17/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773130398; c=relaxed/simple;
	bh=Ogl1A47+skh40swvXNBfLLd9OGEpxiAPGpg7kD8IlMs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MkU8quLz6XjxHolYMHjzuko72w79/DoX28s777DHHlo2IjMPg2Au7QgxgSvnOuj307Q1mHMEnD/ethxTCDkDQaHSOjCV5oNccBDyoAsHLlxOq+7OaGuolejlXi31FGDaXOqjvIlz5uQ8Ii9SlRxGsXM5r4ox/ynfVa1chl5cTsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=H2l7YS/j; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="H2l7YS/j"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-439d8df7620so2638533f8f.0
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2026 01:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773130394; x=1773735194; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=gb/E7qAzjllB7lD/mOoAbiOu6V9IkXKupTTjpaqwPps=;
        b=H2l7YS/j6u2BkQqGGJR+ShRHv8wz3M+24Ec9A/D71ZUA4Jb8qE7oqKIJHt1dLNKo1d
         gxjyU/4o9KMLUYLohwONvcvF2rB6dPWZQLnWlbMNR1Nkb65rB3gUnqf81SGAJ5PwkMrj
         uP/1wSHVoc/2aUP5xyVhNlFkXS2XNs3ySgFGNs7kzPKkN0zKe8AJbPjXVCnbHOKpAmgx
         UilPze9ehHRivVM9pjDLGF38rpDn++GWDG68+laOMhVoJsqpX9+8fopu11eyH6VYkPTI
         07jm8EyNP1liWp4G8IZLGaAKB8gBSu9Fc1WDmttju8o+qnhL+03zsf2h7zyrDHrzVmHp
         QiKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773130394; x=1773735194;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gb/E7qAzjllB7lD/mOoAbiOu6V9IkXKupTTjpaqwPps=;
        b=b+DpGtjNbeMbroCqZVhh5UDTCzlihAMphmgIO2KCEWaq7QDegDw/C/hR3T266Fl4Bl
         v0URKPbabxcTZYx/MP2irIHVdyw0Drc2Td2BT1SFM0ywKXoJmp2ccZk0ZLvceUFoDrwZ
         ydVNSaTBc7u5eb9IuxveQ2e5l6DdWHG2Po3sQLww/nDD/Mmq1tptQqpD5il2WWuh4IPQ
         DdRlJC2eN9QfbFN5BUlVA0CaOMCe2CkErHZbj21/DAuVi+8mkmwx1UoeCb8j02hs3TaJ
         tIDAxZUfD/sH7zBvgnwqGPh4OmH+sUlgfaiYqS5IJQM5sIJGh+jGHjKB2jWQsT1+9es4
         yQaA==
X-Gm-Message-State: AOJu0Yx/9/RgWA6V+qogBdpyHWTHj4SL3he3KogZ0qAFQ63PdMhqcKuo
	bCAXRLVBQsf23wc0aR3Vx7vp36CAvatPG4+8azbVF7TQbz2dUDcxr9KmASCRZQOEDz0=
X-Gm-Gg: ATEYQzzB9QW9ryRRs9pm87oqR72Hge0wiTAi35cPxeJyDwB3+a79VdYYyGCOb1WsqcI
	RKtJCpwG64mkZBO1CXp3frY5hMBPClXHt/TER5oOiL8PTrmnMR1l8aULDMc5tSFcJzOoQc9F9/1
	ufjJnIkaAQrIihFx8ziuSZqnw4R2elPvfEb5gyyfNiD2w1tNbppEQ6TVscQyvzArbcyQrZduxF1
	vpM1e5WPfmwMuKFU4/cEGgm9g4sUAadNEX9kZiLRl72nY0X2GfNTCk2ZeYfMZCy+DffKCgRa/ah
	G7EVgqfLXQPHFHWABkOmJhgRrmL+CiVU3EasyBppiIO1AlNHtYeYU8FjLCs/s1uP9MGkGU48AEl
	JJjvDH4Hz1aZHVwQiZxs38TnIS+qtNe6cL9jCylm86aLbBMJgu4NRAJIqqvTVF21Jvh9CdMaVAr
	4YpLEFxHEjQ1npEFJB0fADBR1JHou+RDmdc4XgjKKbgHpkxR+iXL4=
X-Received: by 2002:a05:600c:4fc2:b0:477:a1a2:d829 with SMTP id 5b1f17b1804b1-4852692bfa5mr230428775e9.13.1773130393898;
        Tue, 10 Mar 2026 01:13:13 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829a465b6f7sm15435258b3a.23.2026.03.10.01.12.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 01:13:12 -0700 (PDT)
Message-ID: <19e81a86-a8ce-42df-8cf7-da74205584ce@suse.com>
Date: Tue, 10 Mar 2026 18:42:54 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: reloc: unlink orphan reloc roots before dropping
 them
To: ZhengYuan Huang <gality369@gmail.com>, dsterba@suse.com, clm@fb.com,
 wqu@suse.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 stable@vger.kernel.org
References: <20260310075447.2088205-1-gality369@gmail.com>
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
In-Reply-To: <20260310075447.2088205-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/10 18:24, ZhengYuan Huang 写道:
> clean_dirty_subvols() walks rc->dirty_subvol_roots during relocation
> recovery at mount time. That list can contain both normal subvolume
> roots and orphan relocation roots.
> 
> For normal subvolume roots, clean_dirty_subvols() first removes
> root->reloc_dirty_list from rc->dirty_subvol_roots and then drops the
> associated relocation tree. But for orphan relocation roots it directly
> calls btrfs_drop_snapshot(root, false, true) without unlinking
> root->reloc_dirty_list first.
> 
> This leaves a freed btrfs_root still linked in rc->dirty_subvol_roots.
> Later list_del_init() on a neighboring entry writes through that stale
> list node, triggering a slab-use-after-free in clean_dirty_subvols().

The analyze is correct.

[...]
> Fixes: 30d40577e322 ("btrfs: reloc: Also queue orphan reloc tree for cleanup to avoid BUG_ON()")
> Cc: stable@vger.kernel.org # 5.1+
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
> Root cause
> ==========

Tell your AI/LLM or whatever to listen to the feedback.

> clean_dirty_subvols() walks rc->dirty_subvol_roots, which can contain
> both normal subvolume roots and orphan relocation roots.
> 
> For normal roots, it first removes root->reloc_dirty_list from the list
> before dropping the related relocation tree. But for orphan relocation
> roots it calls btrfs_drop_snapshot(root, false, true) directly, without
> unlinking root->reloc_dirty_list first.
> 
> btrfs_drop_snapshot() can free the last reference to root via
> btrfs_put_root(), leaving a freed btrfs_root still linked in
> rc->dirty_subvol_roots. Later list_del_init() on a neighboring entry
> writes through that stale list node and triggers the slab-use-after-free.
> 
> Reproduction (v6.18, x86_64, KASAN)
> ===================================

This section is useless as commit message, and that's the only part that 
should be kept after the "---" line.

[...]
> 
> Fix
> ===
> Remove orphan relocation roots from rc->dirty_subvol_roots before
> calling btrfs_drop_snapshot() on them.
> 
> That restores the normal list lifetime rule:
>    unlink from external containers first,
>    then allow the final put/free to happen.
> 
> This is a minimal fix. Since both branches now call
> list_del_init(&root->reloc_dirty_list), it may be possible to move the
> unlink before the if/else and simplify the flow. I left that out here to
> avoid changing more than needed, but I can respin the patch that way if
> preferred.
> 
> KASAN reports
> =============

Put this important info into changelog, and this is not the first time I 
or other reviewing asking you to do it.

With all these fixed it looks good to me.

Thanks,
Qu
