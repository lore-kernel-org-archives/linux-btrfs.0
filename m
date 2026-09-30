Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F8A318EEE
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 07:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790753999; cv=none; b=g18RSypV7AtqCCt08676zHKi3XP8AoDrcK5ZLqHxNpoSUBXcVD83HJVD9XSZb89k0dvo2UEiXW3gWE71Bjr4Sm85O/E/WQozrnTh09zwl9YzTU2PbG/MJpavSnsx5nQquqqWVEQn1ldsR2DonOFYtWL2veV/lVvK3vHgXgLbDWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790753999; c=relaxed/simple;
	bh=ASgutEbKzSjf2Gzvh/w2BmAFm/P7shiR/UZ/qvVhJZw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VR2r3lMVuD6G80A1C9QPae0CNbSs0QlMBpf+Bh/OYupW135rPxFcaQRvaVslbanGiPtL2jiy9tgCryPyVti6yiRfAUCSPgpA6GCy8CQbSg8YHPd89IxY0iDRdA1TWD9Bd0i1obuHaCnNqAKb7EKanZ+QbL+3I3iSdNBBF+h8UyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gATVW5aZ; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gATVW5aZ"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c169ae1cb26so232507166b.1
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 00:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790753994; x=1791358794; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kdAIvkz5SU3+fotowIVUFZIIhMpcbbEUTQrkCxh7GvQ=;
        b=gATVW5aZY869eVHWbQdhzCohWPUxBJNXVSCqujwx2BLO5tH65H6SmCRzufvxuKJ0Pl
         o3CahlPsA/8MQoP8z6BrVpABZb6hZVKs+OUM07jwvlAxcbodGhRn/g1ntsp847qmbJtJ
         52E58ZwVUiOCdo9LzLGsXX574a9OIWVQ572VXJtheDt8k+uWhJ1G7IgrB9C7JuX/aLZO
         FzkgAmgRR9qGVpRfoU2PTr3JKm2a4ThcK8J5a0p2Ij7Ot0jdA2f7UtUIx334u9kiSbX+
         c5/3sPzoEJBV+xOczb8xgtHkxn1pDRuEkOMTlaroyEIXDoMz+We4mOz5ibuFtb5FOFZO
         HK2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790753994; x=1791358794;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kdAIvkz5SU3+fotowIVUFZIIhMpcbbEUTQrkCxh7GvQ=;
        b=gzquPDsu1UqUotjqESI0/CODyeq3PRRvaR1bNi7Iv8htqKv7/Ewup+3dP227xrVpHy
         SC99kHScsG5iYj182NePEcKoHEJVSX4yi8bsUllirJIkrMjoUE+CVcseTlArQMrKdExG
         4CXd8QLGhW3d/NkkWaq8kfrbkC466MPa/B/cnLZK3F0zgUBEGV7QaD3AMyO6SfS8Mxja
         xDtxZE2IFtoxQd1i8JDpVFRaGlKIyUOSvE5dFbPGzu7bN5SSYGin1VW8A704kZ4oeBxc
         oR9wZ3yj/lF+pQ0kVfhl0xNhDzHXEJmxbbmstpKWCjvJJwy/YtAKvr7wzdXOrmNcJy60
         DRCQ==
X-Gm-Message-State: AFuF++m8Lz9L99Kz54Dt1rKvaCQb9nANbZLjVHwG1Kme17rNSFeoMADZ
	/ZwA0aM8IJ1mUsEAyWUedLJ36gsRBTIEP+YD1yqD5CuSqZM9D8oGhjNBZ3x4/RODlw1czuxj7vH
	1EjQz7236nA==
X-Gm-Gg: AYBFou33EK8tHcjIkOXbmvcFjTHowATd/pasSgI/FcFYnBhyAEjX3KjdHWyezkpg3de
	njd/rxjnByOnIl5eSsPmcP8l2+/ByVzmruu7I6LeVeIisDYntL9n0XozbC2H8NZny45ZTMfSjNs
	TdRTNMUctYQGja1csOdRopRiVef9Hl9HxWqqunLQeKF9NwYUNxY7PAP5oOvNB8qV1MuJv8BLPTm
	O1EIyG5DJ+1YqXoDSTUiJSHCxYdak1CC1uYmx64qpFLvKZcFrabOsp+H39qQFZU4Garrkv2Jkof
	WPau/V2aaAuXLpEWa9YkDYQQKHcjsgShs9E1Tep4ZNGHepGlH6qOwWcIx6eG1To0IqJq+kE3P0G
	AA/Rj2wTeb6567k+krqr2hcM5UjOeqWRkH39CGeiZSyBExtsRyR02xsusGBRfpd9v3u/VqSUA71
	yikqulIXvgYMzG2YYlhIEHK/n69+V+HS8XHf+08wkoEkrgl9fd2XwqiXz3gSytLeY=
X-Received: by 2002:a17:907:720f:b0:c2a:ac35:95fb with SMTP id a640c23a62f3a-c2e23dd74b8mr38145066b.24.1790753994441;
        Wed, 30 Sep 2026 00:39:54 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8874d493d27sm252180b3a.18.2026.09.30.00.39.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 00:39:53 -0700 (PDT)
Message-ID: <d5d16619-54be-4d1d-ae49-03f48e9fa6b1@suse.com>
Date: Wed, 30 Sep 2026 17:09:50 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs-progs: receive: fix unused variable warning
 without LZO
To: liuh0329 <liuhuan01@kylinos.cn>
Cc: linux-btrfs@vger.kernel.org, quwenruo.btrfs@gmx.com
References: <dc67e026-1af8-44e6-adc6-f4c2e398f93e@suse.com>
 <20260930064327.49205-2-liuhuan01@kylinos.cn>
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
In-Reply-To: <20260930064327.49205-2-liuhuan01@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/30 16:13, liuh0329 写道:
> When btrfs-progs is built without LZO support, sector_shift is still
> declared in decompress_and_write(), while all its uses are guarded by
> COMPRESSION_LZO. This results in an unused variable warning.
> 
> Move the sector_shift declaration to the LZO-specific code path so it is
> only declared when LZO support is enabled.
> 
> Fixes: 345731fff32d ("btrfs-progs: receive: optional build for lzo, zstd")
> Signed-off-by: liuh0329 <liuhuan01@kylinos.cn>

Reviewed-by: Qu Wenruo <wqu@suse.com>
> ---
> Changes in v3:
> - Drop the extra scope and move sector_shift declaration directly to its
>    only usage as suggested by Qu Wenruo.

Next time please use more common sense, less brain dead "vibe" coding.

> 
> Changes in v2:
> - Move sector_shift declaration to its only usage, as suggested by Qu Wenruo.
> - Add a local scope for sector_shift.
> 
>   cmds/receive.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/cmds/receive.c b/cmds/receive.c
> index 49103ea3..f592a044 100644
> --- a/cmds/receive.c
> +++ b/cmds/receive.c
> @@ -1186,7 +1186,6 @@ static int decompress_and_write(struct btrfs_receive *rctx,
>   {
>   	int ret = 0;
>   	char *unencoded_data;
> -	int sector_shift = 0;
>   	u64 written = 0;
>   
>   	unencoded_data = calloc(unencoded_len, 1);
> @@ -1220,7 +1219,7 @@ static int decompress_and_write(struct btrfs_receive *rctx,
>   	case BTRFS_ENCODED_IO_COMPRESSION_LZO_32K:
>   	case BTRFS_ENCODED_IO_COMPRESSION_LZO_64K:
>   #if COMPRESSION_LZO
> -		sector_shift =
> +		int sector_shift =
>   			compression - BTRFS_ENCODED_IO_COMPRESSION_LZO_4K + 12;
>   		ret = decompress_lzo(encoded_data, encoded_len, unencoded_data,
>   				     unencoded_len, 1U << sector_shift);

