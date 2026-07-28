Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A6841A76F
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785229391; cv=none; b=QXwKazBVqcReuqjy2N6xpP4tJkurs6fN7xm0Bfy+R2lWWQWAfWr6hTdVKbUxbOptJcnE6otUBjffADwMmTVCowhW4vabgEmpduEN+kQUARKbwELapspZKFc17CQupj5pxsVhPnWm2rhG4Bm7T+tS4AG+bfzfdvq5NpK+pmtW3Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785229391; c=relaxed/simple;
	bh=xRtFpwBE5btOYRqc4YyVaCj34uRwpPKlqYCWnsbY4Do=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JmpO6+K6o6rmgofeXt5Jzo1T+gNMh6X2cTSnt3pLC5efadOrZ0l2/BOc/10DFmOu/UefjJjqab2mgKY/i2VlY/gqlNseWLr6ZHVu7Xp1t0s9KzT1fzSHg0cMxCAE2pQFSqfTMSLD8a2+tVIMAz0QNOPFLDXQkJddHtO2wTcUQy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LZr5m1Ul; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LZr5m1Ul"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6a01b8959e7so1819204a12.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 02:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785229388; x=1785834188; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q81FhYY1LJ5QPAojqGqmrpxbE8W117HJkzYSfq3Ntzk=;
        b=LZr5m1UlmI4oY0RPwe/aLN3AYoE0EfCllukslleV4yicsXK5NC8KSUSoL2Dt8YDYYO
         6qK81IQDBL8/YU2r5Y2/3i50uenqVgzQ5bcfDzU2cTd7q9ZElT5Li4Ri+3II24ZSQ0TS
         0EQDW6NiTxwIyNWKsZ1tXH/I8IN3f7qEGcK0dibks8qZn1CRyno2LeGj/4SZYNnDm/1M
         rKHXwS++N3jiwYrwJclUJuD8/Izt1Xkia8PnULcmL9iSQwdkxYTHzdOc+KSxk5v8uQig
         CdWzUOtDF4nB6GQQzfXrHFz4VZO3W6Hw98mv8YNlEQNzGOIqfgHXSrk+YfUyOUuTZDqz
         /tKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785229388; x=1785834188;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q81FhYY1LJ5QPAojqGqmrpxbE8W117HJkzYSfq3Ntzk=;
        b=aUO8uwjCoad5P0EeTwmR0kk4C4JTKUkOC6kT6oFE3pgV0YMn142WMF9awXVkw4p8ZO
         CJJ5Rhn2jVQIRma7Y8iz6xI67LkO/OH11UNEVEFIIOhIJ9zir4BnpiclUacy1Xg5hTDD
         Q6ju5zQwr0rcuG3VSkQrbQiWnj85lZT6RUNaB7qeoVVnsSbVd8Ddu41dGqgvNbo7W9Qy
         Vlhqey2alOhRKipN9QGsTZZJjET4tZhYD8u7+GMuMER27L3nQyzoGFoAXbQCY5B+X0Ez
         KIyGamnzBPI0R1PBx+pUpwB5MV3j8+Pdj/YA7eVCNSccOiY6tyBppQgv7HJMJWnAwKUp
         m5zg==
X-Forwarded-Encrypted: i=1; AHgh+Rp+vQVCuyy2ZZ1JSpzMUYXqrOxck0w4aCOIqdjZzHMEcmxCXfzHWM66cCrEX5LKHHCVU1ysZ59Om/TvZw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8VsT8qfBFeXgvUiXKB8TocU8X8Y5LXuUd0+EZncEuFA1uuHSr
	MWRDF/la4Nn+v7wcnAnC3tS/ZaK15kkOJYYEMhFc/m/20gilV2UvQvZWZ7jPMF0qNkY=
X-Gm-Gg: AR+sD13dXIwyrVPIHSiea6etxGYuV+FTgDmXwbR2Xb9EAZ5jCvfsicOvDnZ4+QJcm5A
	B5Y7RYPUAzKvbdUkYpkPoVIf49KB8qFyNl869nz4C+Ffw3F0rJFPvIJLYh51VLLjdfuWYzx0Whe
	QRWKA+NYPzUQAtnFYqH6q4DM81iPaSY9n+jUPHWU/YkhV/sZPnMxBWOCjUEw0F4cgyspZS4BzYj
	7jM3nAt9ah/TOAAuej3rR50upPnfG83+OstXmk6v5fowykHvx5AVp2LkZe2FYqPMYspfdYcZwwa
	DnoWopgc++wsAukap3c7aAeWD3yzmFaCmaXxB166EfASLKG1X0xvmZx4AFpg3zRe7WA3k2C9YDw
	YsZ6YuMxQzmKwm2AY9ojde6BUQmJBEbokvsPEYP+DZY+3eC+gMbQF8HHZHtwrv/4WMzWrB9c=
X-Received: by 2002:a17:907:8b99:b0:c16:28b9:a203 with SMTP id a640c23a62f3a-c1f7251a933mr70709566b.38.1785229387596;
        Tue, 28 Jul 2026 02:03:07 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e5346dc8bsm4151943b3a.61.2026.07.28.02.03.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 02:03:06 -0700 (PDT)
Message-ID: <9d9d207e-ad2a-4af6-9d0b-9a2bfc61d442@suse.com>
Date: Tue, 28 Jul 2026 18:33:00 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: commit current transaction in
 btrfs_relocate_block_group
To: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
 Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, "Yan, Zheng" <zheng.yan@oracle.com>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
References: <a06b5077-baa5-473f-9c65-bf72ac651b14@mail.kernel.org>
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
In-Reply-To: <a06b5077-baa5-473f-9c65-bf72ac651b14@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/28 18:15, syzbot 写道:
> From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
> 
> During block group relocation, btrfs_relocate_block_group() is called to
> relocate a block group. It first makes the block group read-only by calling
> btrfs_inc_block_group_ro(). If there are pending space reservations or
> pinned extents in the current transaction, making the block group read-only
> can fail, leading to a transaction abort and a warning in
> cleanup_transaction() during the transaction commit in
> prepare_to_relocate().
> 
> To fix this, commit the current transaction before calling
> btrfs_inc_block_group_ro() in btrfs_relocate_block_group(). This drains the
> current transaction before the block group becomes read-only,

What if a another workload triggered space reservation between the just 
committed transaction and btrfs_inc_block_group_ro()?

> ensuring that
> pending extents are unpinned and space reservations are committed. This
> does not claim global settlement of every reservation or later transaction,
> but it provides a clean state for marking the block group read-only. The
> setup commit in prepare_to_relocate() remains necessary because it commits
> the transaction started during the relocation setup (such as creating the
> reloc tree) to ensure everything is in a consistent state before starting
> to move extents.
> 
> WARNING: fs/btrfs/transaction.c:2068 at cleanup_transaction+0x727/0x7c0
> Call Trace:
>   <TASK>
>   btrfs_commit_transaction+0x262c/0x30b0 fs/btrfs/transaction.c:2664
>   prepare_to_relocate+0x3dd/0x4e0 fs/btrfs/relocation.c:3541
>   relocate_block_group+0x141/0xe90 fs/btrfs/relocation.c:3566
>   do_nonremap_reloc+0xa7/0x560 fs/btrfs/relocation.c:5323
>   btrfs_relocate_block_group+0x6e2/0xaf0 fs/btrfs/relocation.c:5490
>   btrfs_relocate_chunk+0x114/0x830 fs/btrfs/volumes.c:3647
>   __btrfs_balance+0x1b6e/0x29e0 fs/btrfs/volumes.c:4586
>   btrfs_balance+0xaa6/0x1180 fs/btrfs/volumes.c:4973
>   btrfs_ioctl_balance+0x3dd/0x640 fs/btrfs/ioctl.c:3474
>   </TASK>
> 
> Fixes: 3fd0a5585eb9 ("Btrfs: Metadata ENOSPC handling for balance")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+021d10c4d4edc87daa03@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=021d10c4d4edc87daa03
> Link: https://syzkaller.appspot.com/ai_job?id=ca6bd6c4-fbcf-4533-af07-79b4a0eba74d
> Signed-off-by: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
> 
> ---
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index fb85bc8b3..05f5110c2 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -5430,6 +5430,10 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start,
>   	if (ret < 0)
>   		goto out_put_rc;
>   
> +	ret = btrfs_commit_current_transaction(extent_root);
> +	if (ret)
> +		goto out;
> +
>   	ret = btrfs_inc_block_group_ro(rc->block_group, true);
>   	if (ret)
>   		goto out;
> 
> 
> base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda

