Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643BE3C5552
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2026 07:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781682985; cv=none; b=VR/jv91EoaiUuz0MdJRwUZD7lsGGGvIjNt8CT+W6K1pZXGXaif9hgqxOKNevyYFb7kjZix9X0GRtRrV7KEjo+oVOPNy0RuR5hWwGC7gPl4pM66HvR1RDAtoMNQQlavbWRL8CMz7bC5qicGfzkQGUa1mOTpEVE3RgEdpni2BhWzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781682985; c=relaxed/simple;
	bh=b9MIUXLi7Yy866TVOJKWhgPnIF7sm8FvDvxm2v2jUyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FjyyGzbNoZmjvaKLS1jxpi1xaPZi9sHHBN7VsAQmwoVFXoE4L0FTRIth7btWPhddY+VZqUyE1C8lm9AqZsbWdbE/Cab/KfJ5LaeGMgTXNJuf4QiMdqq5Z0A/qmuicIpFfaqSekhV6eiROep+RhxQLaIJN0K6CmjIAyZfx+Sf/Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DZ3J2yhK; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DZ3J2yhK"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-beb8a08a6c8so757742266b.2
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2026 00:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781682979; x=1782287779; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=zcJ1tdQewApN4Hgr9Ll2GkeSCxaanAQJNzTUGfQ3FsI=;
        b=DZ3J2yhKC01n/UT+ehIRooojaVEPjOwLow3tUHNccuQ0akVpuqHtEn/tANxvyyS4Zp
         eyW8ljcuq5PwkBALXQo6DVK2ttckK5cGQJE4XQh20PR7OhChIA/NKIsKP7wQIT38Q9O0
         iws4UlqZVbz841RSX4KOGpCxJZL0GJgsLmkfgsBMeZxMPzfG2P1sN0NGrQyrVa12pXrE
         Dq2hn3C2lQVyIM0Y9DWVHEtKk3dIHtVe++Eh71qu746R6lcuiZcwpczrsru534uMe7Yw
         XZGr7U0i2wkG5twgyua9FhPwF3ZUsaXdLgMUGYxLoJwNNXr1Ti+TTtgKO+WvA7rzNZj5
         x+3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781682979; x=1782287779;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zcJ1tdQewApN4Hgr9Ll2GkeSCxaanAQJNzTUGfQ3FsI=;
        b=s199eXHGxBWXma9/IdcBkd5dqZjhbDYvQwsFSJb4zjs7SCJjPQ7ZAJKVFOHPDAf5Ai
         79xUVFxG6syfRB7a6dqIZGKxwhqpXYNi9JN3M8fJdGEpaCnAHSIROG8/hzihu7dZG0mt
         6AW650kNKEJ4R+dLe/68ZFD7tXT9vpggBlTQscyiVcfH/faTD03OS0u9fl7S82kfA4xE
         ENmvPJ6JBXCD2Pv+cph1C8fTMyAc1yQoIXFluYB2neM/a/8mydAd6vnFQ/4lk4E6UtYp
         9fCvICYJ8qWzMXq/DP9k4tL9nUFpJSL3yb7pgN91X6/g0sxsaiQEtz65IzlD7ZfIdgoQ
         PP6g==
X-Gm-Message-State: AOJu0Yz4qd1cRBip+MsPxNAeHuM+nnit9M5AA4eU9brEiVacf3CwHD/Q
	8ee85745VO5pPJye9NDwiojwoS7uhm2IISA4otEoM/JtvOvdRXTbWGPZ8INodegYv7Y=
X-Gm-Gg: AfdE7cm28xB8OxtP2Kpw8COSJqh404nUbevXUe2p3aJhIlOSofZFC/bNwZNV2O0darT
	A+RPVc39neANTdTxiM7gE0KAeGtIKydxwxosNPIyLXJT2DOjMIaZru73ffGJVXgbNQmy8p0C0dR
	d4zWFWjgZfnZDC02quZpwsmjBpwYUZb/2pb7XZnv7bTM6opNvO+QNcz+zlIspmmo/62vGKHXQWy
	CKLEGzVrgMLjh+k+y4jZvfDTmwDopF804+zu+Z8XclvkmbYrbtHSgemxwIJhJorntpZOgfNbu/4
	tMPZnVOXJjttohZ9wMiDK2Om1djC20eY764B5F+XhfYxm3Y5j47F4rLcs7Jet3Pg2QFFcD8hYJh
	iB+VAXHZ/coLLcFW6XfaxoNR7SpUSDiDTO29gydkFnZ4IDOsDNPMpHhnh6nPcL6HhjBhu8rnkNA
	e/R5FSLUtvb9RjAcWui8rL+dF4TKxI2zxMyulDJMmYfvCR+OdTmvOzEOmV0BpFskytV78go8isd
	r8A5FhCB0b2E9OI0G6pg1uv+1Dn6IZEE4rr1iTU9o9rVA==
X-Received: by 2002:a17:907:60cb:b0:bea:4a9b:27e6 with SMTP id a640c23a62f3a-c05a1e4b3a3mr168377166b.3.1781682979493;
        Wed, 17 Jun 2026 00:56:19 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c6a1878426sm39124445ad.64.2026.06.17.00.56.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2026 00:56:18 -0700 (PDT)
Message-ID: <6260dd58-5b46-47f2-8c4c-382bc470b5aa@suse.com>
Date: Wed, 17 Jun 2026 17:26:14 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: emit BTRFS_SEND_C_FILEATTR during full send
To: Mateusz Poliwczak <mpoliwczak34@gmail.com>, clm@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <62a6fc38-f204-45fd-b924-6cca98c6a2c1@suse.com>
 <20260617070112.1407453-1-mpoliwczak34@gmail.com>
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
In-Reply-To: <20260617070112.1407453-1-mpoliwczak34@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/17 16:26, Mateusz Poliwczak 写道:
> Currently BTRFS_SEND_C_FILEATTR is only emitted during incremental
> send when fileattr change between snapshots. This change makes sure
> we also emit BTRFS_SEND_C_FILEATTR when sending the full snapshot.
> 
> Without this there is no way to gain access to the fileattr of a file
> e.g. the FS_NOCOW_FL flag without doing a separate FS_IOC_GETFLAGS
> syscall, which might not be even possible if the stream is send over
> network or such.

Unfortunately, btrfs receive will just ignore those fileattrs.

It's a known limit:
https://github.com/kdave/btrfs-progs/issues/1057#issuecomment-3492918443

The reason is that different file attrs will require completely 
different handling.
 From NODATACOW/NODATASUM which can only be set for empty file, to 
immutable flags handling.

So this patch will not do any difference, and the whole situation is a 
very deep rabbit hole.

If you want to address this problem, please check this issue first:

https://github.com/kdave/btrfs-progs/issues/526

> 
> Signed-off-by: Mateusz Poliwczak <mpoliwczak34@gmail.com>
> ---
>   fs/btrfs/send.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 3ae480c7474b..effbe7ac1a81 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -6575,8 +6575,10 @@ static int finish_inode_if_needed(struct send_ctx *sctx, bool at_end)
>   
>   	if (!sctx->parent_root || sctx->cur_inode_new) {
>   		need_chown = true;
> -		if (!S_ISLNK(sctx->cur_inode_mode))
> +		if (!S_ISLNK(sctx->cur_inode_mode)) {
>   			need_chmod = true;
> +			need_fileattr = true;
> +		}
>   		if (sctx->cur_inode_next_write_offset == sctx->cur_inode_size)
>   			need_truncate = false;
>   	} else {

