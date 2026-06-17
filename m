Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBBB18872A
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2026 03:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781666138; cv=none; b=uhujH/S18ZD95kaC1NA4lIO8ns8YJUVsUK4R212trOWBf08+6iXcx+uJl9Pc24R5sObPuFHicKEPueX2ptXmZlj0YJlhbWxUbhIgVNmMyE3K0xnn3fEDO7XI9AskEzX0sEoeuwfk5VNUlLAO9C8RNXu0mM5+Rk+1amE+IAhYKWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781666138; c=relaxed/simple;
	bh=RSm06Jj+95vQPAeQr3Rpe3V8zMp4iN410HpyGcaDAR4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ekKGYrFvhML7PWnkGhZ6T+kePFH2ZkxV8xUy5hJ+4Z9lS0nnTjEJLOCEP04PLBmeuGR6cydXFyceQmqDwMdLq7nP7Bbr/f//b2Cvd2A4wrXrBpVWzsb9iruXBpWuCbfs/sX86lihYN/QRte1kud80lkWY/aKXZ8smVxFyHbbzdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=V+CbR+L4; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="V+CbR+L4"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-bf0170c80f7so893849966b.3
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 20:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781666134; x=1782270934; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=FawX+/Uj4ieUgfBlqLW2ad9nnJ/NBF0TxgVZB5Z/S4A=;
        b=V+CbR+L42hsxghRLh/0uN7abG4wF9flQwAMsJ/KJMs659mFrDPXgi3ty3uYelavH2n
         HPZ8HeleTu4G7IVrZxux7QLJQrVUr+CuGmvQ7CxuNvOxMxFnaNQDLSy7jKIyLdXE5WUH
         xXlQtm94Fuv6rBLgDGrv1auYUgmOhGumBH9Fkhx2qLAULG6HwyzTq8qt5DTnLsy4n/IP
         TXK8hw3HcLMGC8rswkC/WXAszHHtCWGYRdkSmdcaCLNXbGk/VjmoiuzmIxYWTFa2NIe1
         JNLGYJm96GtLI0EDq5u6smazL8OcjzRRFsG5/fMPDSGpkOkkRx2uPQIJddRGyREybinT
         oYug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781666134; x=1782270934;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FawX+/Uj4ieUgfBlqLW2ad9nnJ/NBF0TxgVZB5Z/S4A=;
        b=nF2Q0X2vczif30jXltYTzNavTPwPVyFRTdvT1GZz/joNW0K1z4bkfLH1BTeMSOIQet
         6/VmyNQDElTeE7ER9Us1Rn+bmcHW8AapbpyNnV13tkDnd0AK3ggOxM4HAAGTGgEh6U2I
         5/lcZ9qJd3zQ5Ha5nqkR0K9BT2r+D3KuH439fy97A8JxG65Ag/MQenr/g6Ls3CqDl7Wq
         H8NxkBGan6S/tl2Oa/ij5+JJlvWVgY7wKDUgJ2+Nv23ueSb9YiEr2/Ag8vl0vmP6wIIG
         vSgJTVdZ/0L47lUQVyCUO0th/VUFM2Lagk2sVTNjHpVR5WkdF1TnjZUpLPOkKZ4GRpqz
         YfWw==
X-Gm-Message-State: AOJu0Yzum3LoJ8pXRYtzbU+gt4IrFNA3RjmRmzZLcDLlDB3GA71OyPif
	LTFYcx2C+TNeLFAdorAq2UiU7Om/BjEvqufvLM4cUJLYP0YbpvcIYSdoxz3lORevoag=
X-Gm-Gg: AfdE7ckVUlmlHpGPuoV+oJ2wjVV2YVwK4rISxYpD9NokgiV1oQ6CJnR+SreXrddN0ys
	7ru/XIzD09Z6UHDPCTh7hF3OaKJXL/W4WqOykgdMb69oiJuZ2QOZd+ZACWp2EvEJnOIWm3ZGafO
	NL/HT9Z97jFpaCnjP94lxf5j57alq1JU6tJA3H4097bzbTyTFUy1iFbEcQELZ0u0brLZKfpRKUt
	mf7BQ8O9WcjRKTmfd4reT1kH74laa25eFmeTABClEiTMVPNx2UKhUnJuSrrsqFOmbPBT7IGvwV5
	+Zb6WBf7KwHzW3HGq9jiBmTOEpI/atusRIA9EYmhMQTll1eSIrDKXCYBJtNnUFP49iofDKXcM/U
	Xq6K47nUvobzSvv8WiMj0ykHrpZ/AZ7rG/ZnabiYicYExcjgsbii1642b++8qbwLVhVsG7obYte
	hZeJUWclgqfCyCuqB+CKGFmSiD8yd8uQgBGSyXi7D6BxK/717yFZQs1bR3NxXXR5OGXWNbmFOQE
	RGBE5rrZfxnaUTY60Wa5HMRm5japlo1tcek
X-Received: by 2002:a17:907:844:b0:bfe:ed06:5a20 with SMTP id a640c23a62f3a-c05a83a5be6mr122394366b.53.1781666134398;
        Tue, 16 Jun 2026 20:15:34 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ac9dc96sm14540674b3a.6.2026.06.16.20.15.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2026 20:15:33 -0700 (PDT)
Message-ID: <62a6fc38-f204-45fd-b924-6cca98c6a2c1@suse.com>
Date: Wed, 17 Jun 2026 12:45:28 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: emit BTRFS_SEND_C_FILEATTR during full mode
To: Mateusz Poliwczak <mpoliwczak34@gmail.com>, clm@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260616183721.1400225-1-mpoliwczak34@gmail.com>
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
In-Reply-To: <20260616183721.1400225-1-mpoliwczak34@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/17 04:07, Mateusz Poliwczak 写道:
> Currently BTRFS_SEND_C_FILEATTR is only emmited during incremental
> mode when fileattr change between snapshots. This change makes sure
> we also emit BTRFS_SEND_C_FILEATTR when sending the full snapshot.

Please explain why.

And there is no signed-off-by required by upstream.

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

