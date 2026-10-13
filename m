Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E0855D88A
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 21:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791928138; cv=none; b=Zrk2tAthQVb+c/F11yZzczixrHdL6WYikPnYx4TPknbwSd3P/UOBZkhxHtN+A7XArTyAHGz7y2AC4xjgXbBtBLt1Xl8YejnHIHmI+qUkLaqtUDZWnZoNQ7hrOMFg0kX5KRE6DtcwW66epWw+Bw/SiNSdxoQNmbEnnpMsYe19/Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791928138; c=relaxed/simple;
	bh=EIJcfqk1kqu/mbOCD0P9RFlRcTXrHhil4xME6tk0xZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iI9SwBlS2/nv3nzuUZSAtftf5bBOvf1Zvf0kuJJZp2zDSdLy7Gzt8XEiuprg7gTrWbkYEzw5hdnvABRhjwdCHjk8QGHY4kb5o4sfl82tZbN7n7nwuUfHFL18tLtIYle+4jrP5juKwVzGpyO4Xzi1K2MdaAV1jwgA6zVKC+oc6ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XGEIBEFA; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XGEIBEFA"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a180fbeef5so31263255e9.1
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 14:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791928135; x=1792532935; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WtrFNiWBoxJmgXREjWgjf0cW050KpUmi+CEBFYW/jeM=;
        b=XGEIBEFAC13DGbIkY+w3nTA6ee4KseU+xuEBVIzy+xGBOwQvDeyj7cMA70EwpxJ6zR
         I4iexLZiGPDN6Ie3uW8ZPHyzcrxzBBhbZdT2xCi0lDCg+8DojulPu7+iAwaN9W8ZRniO
         lhKY63pUpCkPTE15gtolXwpvBF1dShLZY5xKmjjbduUf+e3PGA9i8bRN66C9a0kR2n3O
         a1AVzpsGoAIuGi9KK1f1y/1WScOvIggv3nG93Nrr4wMW2xmhRnBNCEL8fp7/kzfdyQgI
         QzAooPeAa0F7Jv8HNYxQuwpohWzqXAjRkS7xZWw4JbfaA0u59CLfGQU0W9mMjT7XwtZx
         eW+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791928135; x=1792532935;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WtrFNiWBoxJmgXREjWgjf0cW050KpUmi+CEBFYW/jeM=;
        b=najIvsw3+NCt2+Xog9GU+6rfg+Pde1nWMPduhpMnWx95yjedulLodypQT5cWkf4LPT
         k1lmzqN9fAQOjik+MDixLnnadcug13w9Fy1lYmYwAr0qCYPyrMxgU9tx+/m1z9blBzMd
         JxR6JZxsAzL8YsZsbsUg2ygcve0v7cwDMTC00usxb7p1MYA85Y7efuJK1muhCXJhg4OJ
         yr1AM6sdzPTLPVsIfd3B4Uo8ar20pDgz8+GLIr0lUiL67TNpp8xUaPPNzSTTwp3wXMwB
         TbFT7mJeJJcxB709sOWwSk4N53N1S7qz1YIPYrmFnfdYCc+waOMR52OuJfv89i9SlJss
         ZhCw==
X-Forwarded-Encrypted: i=1; AKwUvBxKS4ZD+D23juKmJC3R9o9sQKkJSyekUznOZmjaFuRm2g675rtzDtd/EJBveXC1hHINhs3y5otl5UqWkg==@vger.kernel.org
X-Gm-Message-State: AFq9FYK1U5OtMAXXT93CSJVxTYg5YUYSg2Q1k8HdJn7vKmUoMMB21gd6
	+2h95MOYZMXMuuGG3w8MGILuXVCB4uwwq7IrtHn6XE++akSNczjIj0CQI+KaG2UGZSKG+4Y6dFp
	HEBMUqFM=
X-Gm-Gg: AYBFou0F2R2/1aN7iLYnPSApFDunjkOO+f14GYtmUlW2dE8nHUELjuh4ChXcDA5xJGH
	r4Kep1Q/jB2Lh6RktfWuSB+csiJX0GrQ9ZG0JJ1BTzF/ZB33kLJh3psX8zwO+VnAjcuAPr7FS3T
	KsNo1EvjfzMpuM3kSK0K6y7Bclq8Fz4ciXOhXDjvF5n21QRYVa4qXrSt66MobctrOdtfd86BOTY
	rVmJKwkGk88E1bLfzWHBX2pmTmJFto4X9fwlRYyztCntVZHvsH0SluUCeGD5/gGRUkiFR6JbtcO
	kz6kBqICM6T06OaT/dFi0VuttAVs9Rn177h1+PfWIZexucTph2o/39I8KfLSSk4Gpnbui1bYcMQ
	UPnv63I3p+PPjK6BMTJcpsCE8JxH6JuzyIB1qHPUIB7GYRbwGN3HP79zHMkoHBBYFXxINNbJAfI
	DlqRujaHWbDVoj/A/EJlQFUWMLB2hT5QKG8jB8QKZlghmQE6GXoW+uhpe4QfxR2EwY
X-Received: by 2002:a05:600c:608d:b0:49c:cee0:e7c1 with SMTP id 5b1f17b1804b1-4a18e48d45cmr294155675e9.16.1791928134590;
        Tue, 13 Oct 2026 14:48:54 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac60064254sm1279720a91.4.2026.10.13.14.48.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 14:48:52 -0700 (PDT)
Message-ID: <a29f5513-1483-4064-bd8a-aa2399076bb7@suse.com>
Date: Wed, 14 Oct 2026 08:18:49 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Stacked fs keyed by lower i_ino: detecting a nested
 subvolume root
To: =?UTF-8?Q?Cl=C3=A1udio_Fernando_Pinto?= <claudio@studiomoob.com>,
 linux-btrfs@vger.kernel.org
References: <CACU5Mh9KdABHuGXFTY3=s1DiPSPUSLabhWZnQRrYjnjK5PGPSg@mail.gmail.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJqqw0NBQkUl/JeAAoJEMI9kfOh
 Jf6o/xYH/3AaWnGSq58XnY/T3/YYjr6g+TUZxa7MPyiYTELNpNlvmNlbtbAL0nW0LNvkeiqf
 SmYA+xkwY4RbxnZYQK0H5iv2w1eqa9qqFZb4bIBRmTapu26GEEkpad0W0ZhoSPMO8bV2Bwkf
 YdtPZQLaeUKvHZqNqBKnmtRLQj2Cgy3kuXX3bEGvWjzUOxPUSCj/S++JWBewMdMBPT62vZM0
 3156gfn5mHA94s2p+NFJoWkERY+JPTMu9NISkpD7yuGhXN88qd/aqD0RrlhxvKsrQogdPwn9
 vP18FGG3CRlHtOvOLVoY5NKSOWTDc+o+8t2XEETFTGbKYTcqeTzi4SxhvBLtTinOwE0EWdWB
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
In-Reply-To: <CACU5Mh9KdABHuGXFTY3=s1DiPSPUSLabhWZnQRrYjnjK5PGPSg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/14 00:16, Cláudio Fernando Pinto 写道:
> Hello,
> 
> I maintain MoobFS, an out-of-tree, experimental GPL-2.0 stacked
> filesystem for 6.12. It is not proposed for merging and this is not a
> patch. It was developed with AI coding assistants; I review and test
> the result, and it has had no outside review.
> 
> The layer keeps an in-memory index of extended attributes, keyed by
> the lower inode number. Over btrfs that broke as soon as the lower
> tree contained a subvolume: a file inside it and a file outside it can
> have the same i_ino on the same superblock, and the two shared one
> index record.

That's exactly what a subvolume designed for, it separates the tree.
Different subvolumes should be treated as different filesystems, it's 
just cheaper than a full different fs, thus "sub" volume.

> 
> For now the layer refuses to enter a nested subvolume. Lookup returns
> EXDEV when the lower dentry is
> 
>      a directory, on a superblock with BTRFS_SUPER_MAGIC,
>      with i_ino == BTRFS_FIRST_FREE_OBJECTID (256)
> 
> and the mount-time scan skips it. The lower root itself may be such a
> directory; it is never looked up.
> 
> Two questions:
> 
> 1. Is that test right and complete for "this dentry is the root of
>     another subvolume or snapshot", as seen from another kernel module?
>     Is there a case it misses, or a directory with inode 256 that is
>     not a subvolume root?

I'd say that's btrfs specific, and should not be considered as a generic 
solution using that 256 magic number.

> 
> 2. Is there a better signal a stacked filesystem should use, short of
>     calling getattr on every lookup to compare st_dev?

In fact st_dev is the common practice. As that's exactly the way to 
distinguish different volume/filesystems.

> 
> The check is moobl_nested_subvolume() in layer/moobl.h, and the test
> that creates a subvolume under the layer is in vm/suite.sh:
> https://github.com/studiomoob/llmoobfs
> 
> A pointer to code or to an earlier thread is as useful as an answer.
> 
> Thank you,
> Claudio

