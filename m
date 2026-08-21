Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18B643B6C4
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2026 11:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787310792; cv=none; b=t1k7tIIBy8ECgCZOsmieELBYyk3ARCqwWzTk8unv3TKL74wSJgV3FYCOfTbtph+TjwGUxfdTdkQi9qHlgS3UnCLoVjQQMxXZt7I3RBrXZAoC9ySoVCd++hgIWvg5OP5ICdD0HCIE5W7JLyvTp20TKlkKiwctceHKPCJqc1nSlcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787310792; c=relaxed/simple;
	bh=8Jrm/f8DHRj9cbmAogBnHWR2sNS/Kw6ZQic7MFLRDuo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=USbATEYgcEX7/26ouThqixevSp6nklDPdqnvwNdipxLBC1KEhTFEayyULjxX7xXgIrewI3wKCMwOufBUmesm0zWm92Bk4Yt27qOITLZ9NErLAp78P6xAjR8xaSzE5d5d+px0DAtECt7oZL+hN9b1mN1UdoHGvHBnhwGG29w/43E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JzEXn1cw; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JzEXn1cw"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c15cd3fd760so110058566b.2
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2026 04:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787310788; x=1787915588; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aKdNPfvm3vDBif6gcbUEsOW/ZRihQHs7bDrXqPv+r9o=;
        b=JzEXn1cwK1qhlCTHGr0MAT6dTAmczPkVismy3CXp/kCbIzaBb73kJgYt90gtFw666J
         SjwrJbEYQ2cak7DKsNlN5izwT/ka+DnLok53DE1bRiSflNSp3i8RQ75cOEVfC3yzY/K7
         282yp1l7Q1/LzEZD5m6Chi/7t5rG7Nbh4xVufDZDpF1hqPu79vKidU9Ktk8Wjwz54FEU
         IzzwjHaMUJQQIDOXIazN0/aeynERVgSZQcXelrdPS/TPPVVpdobdBXDoYNxOu4slMxwe
         PhBVnyDKrA1FY2aiaKvmW23OQW43k99gfSuVbTJfQ4531UDbbbmqcKS/DXNq5PA0aHzw
         I8eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787310788; x=1787915588;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aKdNPfvm3vDBif6gcbUEsOW/ZRihQHs7bDrXqPv+r9o=;
        b=SzJPS1mC8zW0We3wC4ijfJstow/HqB1akFi2JRBdh89k0H8esWhjJjn8i2UtYiLfnh
         TglOc6pNym60zo9jJGCmtPOiFJ3nzU7brwjvOvq7otCz/3L/w4GBQ6Nnc1AXcqMeI5/r
         2vGSMbNZsLGYfjpmANy8vnO3hCRdMYb199VWEtZsZzJtyx3QsoH0v+UuNJcH/Gr96hJk
         7pM7vYr4WtNwJtrKFJZ5o/VaX9PC5OCRp2j6womOwFuu6+IZdHKbWoWLTZPLKoLUUeVZ
         83BKKxvp3DN2+jcKgU4q1jMBkuXaOEP/UVBHLh8FqGaP5D0idhcmsVI3DOmvXcYOHet8
         viVg==
X-Forwarded-Encrypted: i=1; AHgh+RqJ6E8hIP5gN4tIPLmU0d+sYterz7phaPKfC45Mw1Lv2G7ABSp4HstPosC7jl25khC4oRkP4hULaKxTGA==@vger.kernel.org
X-Gm-Message-State: AFuF++kFgajOE2o2HmOxJ4rws3ubTm3vV9xNNd2NoWuzlr5iEDLxoXPk
	cvfWA919Fg+QDW9nMDrTkVNrxlsz08Ui58zc4aQ/IEvNr28HKf2OvFuRjrjyWpfPXlk=
X-Gm-Gg: AR+sD12K7s8PXhTj/V/ebSJTk2EUl1m+1oRXDqASVzYyDN8zhES3gvnF4fXMaPM6eG1
	Rh8q81eG9raaPXZJxsW8+M0ls0gWleqOFHw433YfvqYKYxO97p3lST8C6PHo6etFCVYP8XdK2ze
	I0y79evHs78yf4Tf3VNVwJImp6DhNC5v/dac4BXDn8HZcqYqGVT3WG5zx9TJJ1mzlsGHNwuYv0W
	TpnDkYBmY27DhWtaXODkmlfDks6GG278oXGTSBw1TAqFbCv40KWlpTtVkKDvqXZr7Gs2yuXgJPx
	D/LLz8O4Sy61RWIxURsHfaiM6w15Hf1N86p2x6dUeQm053D1s7ZjXJFEwUdfe3TNeitOnhKTQg4
	7k/ZZzB2yCWy0bg8VEmWwZI01S5uXYJxeNS1Was8bYtISx72EWSh7YNujHdAojRto+KsvUPJQIa
	A/G2WJnjJ/fSgIcId5yoP4g4/nKv85EEsS1UQg+/AjqsPZyM2LzUJGEg==
X-Received: by 2002:a17:906:4796:b0:c20:83b0:92d8 with SMTP id a640c23a62f3a-c2469f9a37dmr595221866b.0.1787310788075;
        Fri, 21 Aug 2026 04:13:08 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1416ad564bcsm27727673c88.5.2026.08.21.04.13.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2026 04:13:07 -0700 (PDT)
Message-ID: <a1eff18d-a630-4ea2-ac27-02c9252691d3@suse.com>
Date: Fri, 21 Aug 2026 20:43:00 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: skip the extent map tree lock for inodes without
 extent maps
To: Breno Leitao <leitao@debian.org>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, fdmanana@suse.com
Cc: boris@bur.io, layton@kernel.org, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260821-b4-btrfs-em-shrinker-v1-1-286f3fb15873@debian.org>
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
In-Reply-To: <20260821-b4-btrfs-em-shrinker-v1-1-286f3fb15873@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/21 20:08, Breno Leitao 写道:
> The shrinker (find_first_inode_to_shrink()) takes inode->extent_tree.lock in write
> mode on every inode it walks, only to find out whether that inode has
> any extent maps.
> 
> Most have none, from what I understand, so, avoid the lock  by testing the
> tree with a plain read before taking the lock. tree->root is only
> modified with the tree lock held for write, so the unlocked read is
> a benign race: a false negative just defers the inode to a later scan.
> 
> On my tests, find_first_inode_to_shrink() was a bit faster, so, if this
> patch is correct, I think it is worth having to reduce lock contention.

How much faster?

We are using write_trylock() already, meaning if it's not locked we 
should get the lock immediately, otherwise we skip the inode.

So the lock contention should be low already.

Furthermore, if there are some hidden concurrency bugs, it will be very 
hard to debug.

I strongly prefer to stick to the existing locking scheme, unless you 
have a very strong argument not to.

> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>   fs/btrfs/extent_map.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> index 6ad7b39ae358b..cdcd2b779050d 100644
> --- a/fs/btrfs/extent_map.c
> +++ b/fs/btrfs/extent_map.c
> @@ -1219,6 +1219,9 @@ static struct btrfs_inode *find_first_inode_to_shrink(struct btrfs_root *root,
>   
>   		tree = &inode->extent_tree;
>   
> +		if (!READ_ONCE(tree->root.rb_node))
> +			goto next;
> +
>   		/*
>   		 * We want to be fast so if the lock is busy we don't want to
>   		 * spend time waiting for it (some task is about to do IO for
> 
> ---
> base-commit: 6a746cd265aed59107ebdaa9ce039bb832922969
> change-id: 20260820-b4-btrfs-em-shrinker-7382d7f0dd05
> 
> Best regards,
> --
> Breno Leitao <leitao@debian.org>
> 

