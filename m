Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794615909;
	b=BouPUEaPX9seoXIvj7t7bIgzvitxvNwhP4Kd4X30Qk8tsU4SAb/ykz8JFBa2CDGpmKuw
	 5zxMC+ExEsMTgXOV05OuWlY0MbosqbHrKs7EWorajxfY4BsEVBk3Onxnx+Hg+z0vFoLV6
	 PWhjeGV6kL1TIlBg3cAdnqeEBx1WNDfcj+hpDbc08VPKmt19giXDVEnh5kNzpbrhyq82o
	 KEybJNOkbjyJYc5FAy1NwQXDXRG41cNSJYUmnm83LtapPOpXvf9lR/XFGxczeOwltkP/w
	 gSch0+20+ruHXmdQbzl/tXStB7SZcnTlcX6Q4D6KAX61nxfAH+cwRTaK6sPwcuw6OCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794615909;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=It+9ibvQdL1rLp2HtknV/aJ8lGIy+bDOBTvvQaORdLg=;
	b=3UmGDUps25oGQNf3F2ZUf0H9tKI41y2duwyWe2ihVRAPbeFYxqTgqosYP3nExz0Uim0i
	 xh89lNlyuMEF7at7ZklECP2adCm6tHgjWdT3aSFaRKSADzi3YneFHxhK0o1mRY0taUjrA
	 GprJDXgFrkZVZWxxtE0nfppqGTgRlbM2mlAJnnJN2fWa/tFylgEpqZFfSbYaNmleaLqAV
	 eEiA3CLfea7/pagmNNRSK6aINNQ7dvkFwsqzyGsZuJavgVLS8iRqpbEGvY/VdXKltoL8D
	 +zCmtMLxC5/GvjI021VCoH3T7FBXYH7uiP4prrSHcW0Ml68YJF+ioSp6tQfv0+I8BUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=P1deSVa6;
	arc=none smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF71606A32E
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 00:25:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CAF71606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=P1deSVa6
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c45551fa84eso382669766b.3
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 16:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794615907; x=1795220707; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=It+9ibvQdL1rLp2HtknV/aJ8lGIy+bDOBTvvQaORdLg=;
        b=P1deSVa6BRyNwO8hMXJ895/WNfrXhD1RMD1i7a5Hc+cbtDwcjxiMU6DaN9tDaPbxO5
         2HXpElZFBL+SC/sURSQXV8CZWbQ2talY2aCddWmYejqN/L3po6eDUrioc62wUu0exUdI
         yhcQJAN2MuCCATZW/uTi0dQr09sQCbN2VOmvqdh/r/aFWH8JlCAe/vpgB5YIC60FsQOl
         AIyZZO5SmZHKC0pxQMjcDLEn1mJR20q3R6jqgiEkRThQPgQ1uYim6Bc/ADawNt8VlxkB
         KH4W0hWI3dzTKATqOjH6Zjy2t5E1zlHMPJors9aMaTbRBEqH6ZELS0B67NB6UloiogrD
         N0Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794615907; x=1795220707;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=It+9ibvQdL1rLp2HtknV/aJ8lGIy+bDOBTvvQaORdLg=;
        b=jAf3GcyF8xMp12keJNrxfQUXs2e8YLEv8Hd3EFsTdHu4Q/+FiQBZ7/gmr3Qw7OU+Vo
         vME+GlcLrLB7yhfLblLJX6IgemyZezp6mT+c0nkBMld2ZlRzj9BmujxeUhkShv+v6U2Z
         CxnaCYHFjSZVpW3i3Jjs5M6hdl6suC2X8Ri5qC5yENaSayehsSFs58deyziz9ZOsh6dd
         TCcPkxb3aligQhZb0XvCBiyuZsieiqPmWaL8q322nQXrMLYhx3PikcVdLZOmy5ikYE7x
         9anMrSQ9XH6Fc2NbwHzRHGhcPJCTY0kNDqAlajyQ4MLQaeJTUEURxNKrBuixXPy651IA
         uXnQ==
X-Forwarded-Encrypted: i=1; AL+hErH/3B+HnCNU89WKdyST7l3rxbDofvDXq3nRxi6Buw5jDrN5fIVPVJqIzLFoo/e/Q9fuu+VBk2pvmqgFOA==@vger.kernel.org
X-Gm-Message-State: APuU4Z85tKB4QQmEZfWxOnwa6qgbazLSSKD5XT5DmTF74eSUdpxNxqV9
	e0pQvDTjZuqOR74+GNkvOc3+efDPdkAAki1CbqR6d1vUtxTXxu1DhYH5Q88H/1Y3Bno=
X-Gm-Gg: AYBFou12tq8xTJrcbkngPc0yL5/cxCuP1Ra4cv0+aPLcHtXVuQONLOV1j+0ErXl9AgV
	UIYSZUz709acqKqxOWnTYhlLehNcpSGZX5HQrHUGj0VJLBnUexaETQUQyeg+K1tuK03L3jFJwV7
	3diWyTdL2Z7y/HtThyMGT+U1vNVajUrCYpeJuBm7n8Czuibnn68k/nJIldpT7Zo3cMGT1bLA5my
	+zV7+9emSTO39LeIt6naYLtmfSs4MrsS4qb/s7ngX4A1ZJ63zqwlli1d9S+sj5LJ/Gr8QHsEp7T
	axVcRpoPL3bFXLy/9ZCUBVbK2X4+/KgUPjW5jvWbSFVIrZ6pe3UV80cbTEXLqIxkdQd91xtgFjg
	dSULFvgokvOeAPT24AOrh6nPxoJ2bUmOwOu9evh7nrOy6w9l5hW7JLWBcoHMJR7pI1So4FAb0gz
	sHOzrhyulZTDkfmuEZ/9uyNPinH3h12LRkHzjOdhmsvaDqzK214vBOUTsF8gzWRTefy7AivXO6n
	okQBsnQyaT4MIqQGyZd0eubiu9ML0FqvT7lANOZgXO42IZQUQUd6cZg1bFmztS+dmbVtWdl8aYS
	9nejbKRqGIDzSt9Gw4dt/xtQ/mlqdpnC8ryyf0WdTYQ=
X-Received: by 2002:a17:907:72c8:b0:c2d:c98f:4824 with SMTP id a640c23a62f3a-c509640e213mr341129866b.30.1794615906936;
        Fri, 13 Nov 2026 16:25:06 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1aec63b9bsm6669618a91.12.2026.11.13.16.25.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 16:25:05 -0800 (PST)
Message-ID: <d829648c-3fc2-4f6e-ad07-ffce8be579a8@suse.com>
Date: Sat, 14 Nov 2026 10:55:00 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: speed up steal_from_bitmap_to_front() with a
 backward word scan
To: Elias Jernberg <eliasjernberg@gmail.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>,
 Chris Mason <mason@kernel.org>
References: <20261114000234.339513-1-eliasjernberg@gmail.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <20261114000234.339513-1-eliasjernberg@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/14 10:32, Elias Jernberg 写道:
[...]
> 
> Fixes: 200055239604 ("Btrfs: improve free space cache management and space allocation")
> Signed-off-by: Elias Jernberg <eliasjernberg@gmail.com>
> ---
> 
> Notes:
>      - The numbers above come from a 7.3-based tree (aurora-silicon/linux,
>        Apple M5 MacBook Pro, 16K pages) carrying this change in an
>        equivalent form. This version was build-tested on btrfs for-next
>        (3aefd67f08f8) as x86_64 UML with W=1, no new warnings, and the btrfs
>        self-tests pass (CONFIG_BTRFS_FS_RUN_SANITY_TESTS, including the
>        bitmap stealing tests).
>      - On x86_64 with 4K pages I could not reproduce a clear stall with the
>        similar fragmenting workload (sync after the delete took 0.4-1.9 s), so the
>        effect looks tied to the larger bitmaps of 16K and 64K pages.

I'm more interested on the page size bounding part.

As btrfs_free_space_bitmap_cachep is using fixed PAGE_SIZE for the 
allocation, it's causing the behavior difference in the first place.

I'm wondering if we should make the bitmap size not bounded to 
PAGE_SIZE, but the sectorsize of each filesystem.

Have you tried 16K page size with 16K sector size? (along with changed 
blocksize in the fio)
Did that can reproduce the same latency?

Thanks,
Qu

>      - Reproducer (fio, run on the btrfs filesystem under test):
>          fio --name=a --filename=f --rw=write --bs=1M --direct=1 --size=4G --end_fsync=1
>          fio --name=r --filename=f --rw=randwrite --bs=4k --ioengine=libaio --iodepth=32 \
>              --direct=1 --size=4G --time_based --runtime=15 --end_fsync=1
>          fio --name=s --filename=f --rw=write --bs=4k --direct=1 --size=4G \
>              --time_based --runtime=15 --fsync=1
>          rm f
>          fio --name=b --filename=f --rw=write --bs=1M --size=4G --end_fsync=1
>        The last job takes 29-36 s without this patch and under 1 s with it.
>      - Prior art: Yun Levi suggested replacing this loop in December 2020 on
>        LKML, as a user of a proposed find_prev_zero_bit()
>        (https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2402457.html).
>        That helper was never added and the loop is unchanged in for-next.
>        This version keeps the backward scan local to free-space-cache.c.
>      - Tool use: the stall was profiled, the fix written and the changelog
>        drafted with an LLM coding assistant (Claude). I have reviewed the
>        change; the equivalence test and the measurements were run on my
>        machine.
> 
>   fs/btrfs/free-space-cache.c | 30 ++++++++++++++++++++++--------
>   1 file changed, 22 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index bff6e5b372d6..c599a8f25821 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -1269,6 +1269,26 @@ static bool steal_from_bitmap_to_end(struct btrfs_free_space_ctl *ctl,
>   	return true;
>   }
>   
> +/*
> + * Return the index of the last clear bit at or below @bit, or ULONG_MAX if
> + * bits 0 to @bit are all set.  Scan backwards a word at a time, so the cost
> + * follows the length of the run of set bits that ends at @bit rather than the
> + * number of clear bits below it.
> + */
> +static unsigned long find_last_clear_bit_upto(const unsigned long *bitmap,
> +					      unsigned long bit)
> +{
> +	unsigned long idx = BIT_WORD(bit);
> +	unsigned long word = ~bitmap[idx] & BITMAP_LAST_WORD_MASK(bit + 1);
> +
> +	while (!word) {
> +		if (idx == 0)
> +			return ULONG_MAX;
> +		word = ~bitmap[--idx];
> +	}
> +	return idx * BITS_PER_LONG + __fls(word);
> +}
> +
>   static bool steal_from_bitmap_to_front(struct btrfs_free_space_ctl *ctl,
>   				       struct btrfs_free_space *info,
>   				       bool update_stat)
> @@ -1277,7 +1297,6 @@ static bool steal_from_bitmap_to_front(struct btrfs_free_space_ctl *ctl,
>   	struct btrfs_free_space *bitmap;
>   	u64 bitmap_offset;
>   	unsigned long i;
> -	unsigned long j;
>   	unsigned long prev_j;
>   	u64 bytes;
>   
> @@ -1294,13 +1313,8 @@ static bool steal_from_bitmap_to_front(struct btrfs_free_space_ctl *ctl,
>   		return false;
>   
>   	i = offset_to_bit(bitmap->offset, unit, info->offset) - 1;
> -	j = 0;
> -	prev_j = (unsigned long)-1;
> -	for_each_clear_bit_from(j, bitmap->bitmap, BITS_PER_BITMAP) {
> -		if (j > i)
> -			break;
> -		prev_j = j;
> -	}
> +	prev_j = find_last_clear_bit_upto(bitmap->bitmap,
> +					  min(i, BITS_PER_BITMAP - 1));
>   	if (prev_j == i)
>   		return false;
>   

