Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810983E49EC
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Oct 2026 21:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791407125; cv=none; b=ROH54fAMGuPvmLgR+Dlf4DSDSTf1z3d2wr1FpZvj7VXPJl2tcHSNrhBLvM3QK5hSAlgJiM/xf5ax3E4CQzmNzrbwy0RoicP7etxRTCfBmyTkOV+Jfuh6ua3vRnEp8QwehtWYIy2dgHuSyU938r8aCOY+xI30yI41Tux/v51hYG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791407125; c=relaxed/simple;
	bh=xS/ky5t2ImWSC04Lp1rBwnQJwrelkruNQiYkKiMXcko=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iiXw3p4hoQaa7biJj9TdTEkKZg0zwfbaylfeW71qfrCcxYhvq8GbcST1lcYN3aGs2RHEn/Si+2gtABDDmEJ83ecLS4SrrmMmQB1GV0ovKLZG3OZKyMaqHE1tIU50zuh8h4PQlgWcsghnRZaAhFqNi3mMLjwqoJuPwUBACAj3tXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=S5ZPGjJz; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="S5ZPGjJz"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c2e36c3478aso674536366b.0
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Oct 2026 14:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791407122; x=1792011922; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZB8ePJJ5vG+DOYZ4nM5G8Cik/BT6PRRvvVa/2N1PPYc=;
        b=S5ZPGjJzffGkWbMs0QWgNoFiW1sj0NrZWv0XbZP+PKN2t+Z342qet80q8i7m+I6kye
         nvxtEEnqfzsUXlwgzYnxMqt+XiUKz7SwvQEb87UnEy4vhZlF60SI7o9fALDmGZq8pdTI
         ixa9bHTWriiliNtv/hxu5h4AtqT4QGUtFP4ThCDtAvBVWnUupKwca/EHm6b9/Y7dvPSp
         hu7l9B9qfBblA1NNFhROWZlrbzZ6MMZU8LMJ90vnmzorfm4h8J+EfVSDSM3WsH1D4YWO
         bi6HO4EtH45hm9o+pNG1NcCsGkiNi0ZYfk+vmWl5EYaSmumjRjHugdU+OMemkWzNPAHW
         WD0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791407122; x=1792011922;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZB8ePJJ5vG+DOYZ4nM5G8Cik/BT6PRRvvVa/2N1PPYc=;
        b=yL5XFFy81qahCsDvuoN075x8LVxNI0wBSO2A5NscIkddUJ7PyLj+2fubMBH20NkuSy
         b/OQQx03YmvB6+k5DjgnFpyP60PRx0naaPBlRPz6inTwtzXsVCJ6ap0kSkWf/JuGEo1L
         DGpeh09k28RauqrPc+NSAe3ceJLtNrc//gRfYsXh79Jn/onwUPp3sDfh1TGNVsnHVZ/y
         tMhEaBxQMdFw2G69V7xLxNTyqY6bf9ShobljnTN//A2LkGsjjXw21NhZd8TLRds6OmjP
         herCOrZMw/JGnWc+Y4QC1elc+HMg3qcCkWguGxAaLtmyqIvSU/n0HHEK95MGdLNR3f5I
         h8bA==
X-Forwarded-Encrypted: i=1; AKwUvBwj7Zff7kWHuk9Rex6asi+yJTjz8RAhs63MpruB1gwaGyGY2vHTp8hScf3iOaS3wCXtP+A2cIY9NaioXg==@vger.kernel.org
X-Gm-Message-State: AFuF++lwp98jz5tdqx7RbxRnid0V7B+CNXGgtgZD7TAjLMEiVevJ7cuQ
	qBzmmJHY3evykcQXEQ5/92bvB6T+sKKUML7xzl2rVDMFJcXyoFP9bPuTuGjtxS0wxq0=
X-Gm-Gg: AYBFou0qsgS4+PRPVtxH3y1ycll/1AvRUZLdgjr5Cu76VQWSnyrxuIoL4uBKbIUrAEf
	OGS8v8FmKS1dLhtLd7JZDrfYnQI//jYzyiIGjDKD0Pwn9z1497MkhkmQFrIlGS4ZhiDPQX6HDYU
	zNJWFZuLbg3/4YvmWWuROq1HOuGk8B9uH3PJmZ5djURWVzLSb1Dd8OYpA1k0RLHvNCOi1D9TGnd
	OEOku6ox1HhnYw2xgBo2YRve6X67oL4IFhQenMv6zeh+ryUmH49nZlcF6zFvr/k0r5ke26uXX99
	OxXgWfNkw//SJAopKC/n6Y7OvXWF7CEILZHkWpYtbkRUyaRX8tkQY5jt6krrZcJ8S3Dh67NGKrG
	ZfrXVJxWTeBF1lcFXOuinjiQciENe+sr2PVKI+0lCGyihvRC4bPplcjBrGDNVDwwbUXA2BcyhvM
	Ni3ZzXaResH3+nM5L7AdK32dhDDFXRwRzWCeGOalxue1+IyygIBa1LUWZtf/OV7A==
X-Received: by 2002:a17:907:c0d:b0:c2d:d019:d414 with SMTP id a640c23a62f3a-c317c07dd5cmr304872166b.29.1791407121648;
        Wed, 07 Oct 2026 14:05:21 -0700 (PDT)
Received: from [10.86.128.17] ([149.22.87.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-892bc276d97sm770291b3a.61.2026.10.07.14.05.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2026 14:05:20 -0700 (PDT)
Message-ID: <0c109786-2c48-4225-8f17-a64112d97711@suse.com>
Date: Thu, 8 Oct 2026 07:35:16 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: defrag: fix key comparison with max defrag key in
 btrfs_defrag_leaves()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <7c5964a3dc1d6cfef098dd3d4f1abdfac068aafe.1791384948.git.fdmanana@suse.com>
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
In-Reply-To: <7c5964a3dc1d6cfef098dd3d4f1abdfac068aafe.1791384948.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/8 01:26, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The comparison can not be done in isolation for each key component (type
> and offset) after the objectid component. For example if the defrag_max
> key is (300 2 0) and the defrag_progress key is (301 1 0), the existing
> comparison makes us jump to the 'done' label with 'ret' set to -EAGAIN
> because 2 > 1, resulting in continuing to defrag despite having passed
> the objectid of 300.
> 
> Fix this by doing the comparison correctly with btrfs_comp_cpu_keys().
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/defrag.c | 6 +-----
>   1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
> index 6ec5dd760d42..75c87aee5de9 100644
> --- a/fs/btrfs/defrag.c
> +++ b/fs/btrfs/defrag.c
> @@ -530,11 +530,7 @@ static int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
>   out:
>   	btrfs_free_path(path);
>   	if (ret == -EAGAIN) {
> -		if (root->defrag_max.objectid > root->defrag_progress.objectid)
> -			goto done;
> -		if (root->defrag_max.type > root->defrag_progress.type)
> -			goto done;
> -		if (root->defrag_max.offset > root->defrag_progress.offset)
> +		if (btrfs_comp_cpu_keys(&root->defrag_max, &root->defrag_progress) > 0)
>   			goto done;
>   		ret = 0;
>   	}

