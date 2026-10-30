Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793394229;
	b=Sgfa/CJk5EUhrmvrvpGO1BkFBd+AXTZKjh+XmoB0THSAS0GGD8BgMGOFAS3XAGdNH1nR
	 uFopSj/faDCqWdxqIUFIvZVGwomIfeSNgulyGEQNOvEy1BjEj99+keMV6+in8j8jwlHi3
	 NPXBCAvxkhMOBNhmGxry/Rk/kbnzUVTyunX7IrBq7VrREmL69bH+PpuW+ZeUdg3rQP5pk
	 bwoey9jLaJAdXgfSTYaSlKH/ES2EyQ7S/c//pT3pNjcxWvu3yojKD4eb0ULHhwbzCuFSB
	 Mq8vwS58lh4L/BeFyah3mZCj1DSm9RjLqcvC9HtfG/S8cWnb2gqDxU/afgsRTTm7GYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793394229;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=MxI6kIjG4UY4nZOd3/y/oB30lotTLtKeu71+k5vRuRs=;
	b=eDkd0DfgvfGe5J9Ii9UNha7M7qETk4nq4M7FRGUQb2jWbXOLLSpxJ7bpyhqhJP2Q5GRz
	 zqp47XiOlHw6Svx6WPf+lXd8TFZpFOFF6moXXOX1sqWUqwRfFfFovOvZtVxZ3h9Fr9Iwb
	 pJxZk+6QJZS4oku8GkGnheWcUm1hxKj4OHr2nRJUCzhHNMqAd61apSKEsH5N3Mhb4JOCU
	 SSw18QecC+aJd1nroTdgRtoRyqIPkzXCZ6cfcpgW2LNKDGg9GrHtd64Vg4JaNcyqBCVuz
	 y7l8YIZ72oO3nOP8yDD6xU03ekWzaSjs2Ywe89jUbotiqOxrAtou63EWLke359gCDbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b="Mmc/pkPL";
	arc=none smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF93A606B6D3
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 21:03:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF93A606B6D3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Mmc/pkPL
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c43373ae89aso184992266b.3
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 14:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793394227; x=1793999027; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MxI6kIjG4UY4nZOd3/y/oB30lotTLtKeu71+k5vRuRs=;
        b=Mmc/pkPL9keqqwSl+8sH9VqGmrfnkO68L1FwnZohSCpWidqUXMskW/TkOJuiUwPXZ/
         YZwO2OrpBuWAs+/NH2ufaNfUwE8eZgI9l+7LiE/9k4vu04635NtkjbmdZ1jOt308/uGh
         QMSR59QDGWScoLFCB4f0cHs5kILmdXnJOCAEHWgxwX8TC0RmknaDL9pc2jyhMPnJ6Cbn
         xvGsEP0xAJZcyGliI0wn4AhKVLoXiWw38DbP3UiLPQxhU8qCIatusBH59G+1kgRW/Y4O
         jyghO0UFPwy17EaxoYhv7MY0769A7byRryDhvf3viVODPSl4EcmXrvKfDu3aeTojfe3E
         CZkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793394227; x=1793999027;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MxI6kIjG4UY4nZOd3/y/oB30lotTLtKeu71+k5vRuRs=;
        b=COrQZnkCFTfFlGC09YIAPR5nK0cJ43/BQ0/F/owHQPgTLXjB9lVDwawnxw6N3Pdlog
         1NI6FT48C+XxkaZX9TkXu11cXVysUBRGgmbR1iVp+CTplaqNFagFlZnb8sl2dc6LufCL
         QCUmlBUYJ0w2JfztwVsDAscuLfaJtqhvratoWSNRdPB07bNY2UW+36tIvI7eeOo65rG9
         VCVjH1qasNoFSieHxoAg7N+cQcV/N6mTkYL8TndoZVyLKqOAMIn84AawQjg0OmoIKrvc
         nQGW5Ib/7Qg0Q+hbG4TA4uZxzcZOwVrJY68NkRIi7aLVZ4W+ZOkj1x2uR7kEhQTipR+1
         ukmg==
X-Gm-Message-State: AFq9FYIjzyrElORy9w+et0OmD3K5xooGEBTVo+ZJGE4c6Dusx+yBxwmT
	f/aRc/NvpWI7c5qKM8mynEh9vtMSefBCSoNX9voGVixDQEqxpm/SZKUP12phIEPgF6k=
X-Gm-Gg: AYBFou3fLFH8VeWM6c+JjH47pbYtniEWSuj2AvZJqi2f4HglCludCbU5hDHpQJr4x1a
	+9sLs+poRYQmG19NgpJvtz98wkf5wbwWs3EexlnRqP03RVMPMeWsWYC8GQ8M2ouPtghmsBUi/ke
	OUMYYph1jBJ2+cp3g5mqbIJ35coyISrPMzpkwoGewi/w1+eOjsgRZpMgNwwARThpLuC4U9a06KW
	twS0wrQnlSohhorqk1ZrJ/Ep1MgmX2YaSiiC1cSZl1bTUYzfB+0hrwz36PDCer3AWcKoSvla0ot
	jefqpbDfRK5bVQZCyB+KgDru/qoPnlzqCyBquIeODKy+VP+ivxo84tqFONR0rfwDuACysOV/tzD
	QN/nMDusnQnmIr+YSIrFJfEWvoOA+Stv+WyNALU4L7aHXsHTD6w1O/SKsVkHpi+IIUfTknSInCO
	Q4EgTQy3PdYIO9QXzhUYAYftCWqtPylg1Ds9HlwAaAqfq0sN2QVFPwVnjSa8es021GXGIwO2fOV
	vh1Q6lsm44EolqEv0DssvNifjxNb+D9f2LC6Fx7koTGP8ogDw4VP4yMGe+xC6peifUN1FcwPGiN
	0u1CP7ZTF+rgjW2oIcC1tXctyad3ju0v+81BUVGhhLY=
X-Received: by 2002:a17:907:a88e:b0:c3f:153a:8663 with SMTP id a640c23a62f3a-c4ca7b20cdcmr346484166b.23.1793394227163;
        Fri, 30 Oct 2026 14:03:47 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8aad963d6acsm403153b3a.18.2026.10.30.14.03.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 14:03:46 -0700 (PDT)
Message-ID: <fab0bfc4-3c20-4058-8b39-585b14152f6e@suse.com>
Date: Sat, 31 Oct 2026 07:33:38 +1030
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
Subject: Re: [PATCH 1/5] btrfs: don't drop the error of the last split bio
To: Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, Boris Burkov
 <boris@bur.io>, Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261030-b4-btrfs-data-integrity-v1-0-f4d4196731e6@toxicpanda.com>
 <20261030-b4-btrfs-data-integrity-v1-1-f4d4196731e6@toxicpanda.com>
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
In-Reply-To: <20261030-b4-btrfs-data-integrity-v1-1-f4d4196731e6@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/31 01:08, Josef Bacik 写道:
> When a btrfs_bio had to be split, btrfs_bio_end_io() saves the first error
> of any of its parts in the status field of the original btrfs_bio. The
> part that completes last is supposed to load it into bi_status of the
> original bio before calling the end_io handler, but that is only done if
> that last part was successful:
> 
> 	if (atomic_dec_and_test(&bbio->pending_ios)) {
> 		/* Load split bio's error which might be set above. */
> 		if (status == BLK_STS_OK)
> 			bbio->bio.bi_status = READ_ONCE(bbio->status);
> 
> If the last part failed, the assumption is that bi_status was set at the
> top of the function. That is true if the last part is what is left of the
> original bio. If it is a split bio, the assignment was done to the split
> bio, which was freed right after. If the original bio has completed before
> without an error, its bi_status is BLK_STS_OK and stays like that:
> 
>    original bio (tail)                 split bio (head)
> 
>    btrfs_bio_end_io(orig, OK)
>      orig->bio.bi_status = OK
>      pending_ios 2 -> 1
>                                        btrfs_bio_end_io(split, IOERR)
>                                          split->bio.bi_status = IOERR
>                                          bio_put(split)
>                                          cmpxchg(&orig->status, OK, IOERR)
>                                          pending_ios 1 -> 0
>                                          orig->end_io(), bi_status is OK
> 
> The end_io handler covers the whole range, so for a buffered read all the
> folios are marked uptodate, including the ones that were never filled, and
> read(2) returns their content instead of -EIO. For a write the ordered
> extent is completed as if all the data had reached the device.
> 
> This can be reproduced with raid0 data on two devices, one of them slower
> than the other and with a bad block, by reading a file whose last stripe
> is on the fast device.
> 
> The saved status has the first error of all the parts, or BLK_STS_OK if
> there was none, so always use it.
> 
> Fixes: d48e1dea3931 ("btrfs: fix error propagation of split bios")
> CC: stable@vger.kernel.org # 6.12+
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/bio.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> index 2c6234f6182f..fc0b021cdefb 100644
> --- a/fs/btrfs/bio.c
> +++ b/fs/btrfs/bio.c
> @@ -127,9 +127,12 @@ void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_status_t status)
>   		cmpxchg(&bbio->status, BLK_STS_OK, status);
>   
>   	if (atomic_dec_and_test(&bbio->pending_ios)) {
> -		/* Load split bio's error which might be set above. */
> -		if (status == BLK_STS_OK)
> -			bbio->bio.bi_status = READ_ONCE(bbio->status);
> +		/*
> +		 * Load the first error, if any. It may come from a split bio,
> +		 * including the one we were called for, in which case nothing
> +		 * stored it in the original bio yet.
> +		 */
> +		bbio->bio.bi_status = READ_ONCE(bbio->status);
>   
>   		if (bbio_has_ordered_extent(bbio)) {
>   			struct btrfs_ordered_extent *ordered = bbio->ordered;
> 

