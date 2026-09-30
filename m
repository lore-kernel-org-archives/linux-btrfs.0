Received: from mail-ej2-f42.google.com (mail-ej2-f42.google.com [74.125.228.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A58349CF3
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 04:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790744354; cv=none; b=edp1APCTiYysWMDo0z3pH3ZlyACz2avuPEekhSPfjNIcyWkUaaHVzyoxQJrWvnVMGhmhBFY0yLmcyyZkytgsWJFFVF7TguMw/CM5Cm6U6P7MTOM97tBkAxNV70/x1qyabfrdGnlHj6pmnwso4Kjs8Z0mfba3ynBEEDQlWrfo/LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790744354; c=relaxed/simple;
	bh=tBFYR+pPX+Mc3GHk7xg7kxd5FvlyhS+6Xx2TO6YQGaE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lItNduAu1PsovN6GmM71ZQtHw/S8TABA1/yMYjRDPjlkH1xyjL5Zgt9mNwsVzRXi4rCJB+1OtIlgTHbjOO2GufqjxGUU6X4QrLmS+Ybx610Al3mhol0fcV0pziIbtQZSkzEcbA4yEp77YxGbaM/WcAULE8Q1DSLjD+BCHUZoYQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FRFVGdzn; arc=none smtp.client-ip=74.125.228.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FRFVGdzn"
Received: by mail-ej2-f42.google.com with SMTP id a640c23a62f3a-c2c570a3030so480369466b.0
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2026 21:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790744351; x=1791349151; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XrY+Vr3eILY3xsFYAzUADGMXkv/8GRVBT/SGbUkGg8s=;
        b=FRFVGdznm1VnwMyCVUC7biFRP4fUEkBIQ72e7zPIzKzNs1nZ8Gn/9jspC/zlqCTYX0
         OpZOXD7xLpBS3pfgivOTlewT8HJjqY1lyspHAx0ue1gzkI0QhCA3NPOkiszg9JXk6K0I
         7Ewfs7CSsLSUTo85vYwst61fuae7c13NadbE8jKqFnzve6dVlQuQBYTElsl8GX4dD080
         PvOZ+eL2+ctDVWtziRb7L3ablk+iQCZBHhd0rspanjJ58q3+yMjy/qovoxTeMNT+L3ND
         O3b9OZvefY/FRte1owc7zxY+swPE0HBnv0UJUKa1F0jT2oy43dPrTlMbE3uAu23v7PVh
         XEIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790744351; x=1791349151;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XrY+Vr3eILY3xsFYAzUADGMXkv/8GRVBT/SGbUkGg8s=;
        b=NbXYVpD4M2oiaR/f1X4a7x9M9TuWAqRuluE7nnymOenX6nJ0W3XUHG/ifY6cCoLmOh
         mczr0hQJTAPZNoP4+NSGaCaHyKmNsBnvK1Rc/ITNHU04RoRROaBsq0OFD5TQ4BWCP/eP
         7sgHd360m7xxn/S18hgiqgRVJWgX1ZgqqcJKMsV5nu2oQlcRlAgzZJszYr7liRJQepvo
         6tsAFa2Nwb0fzmG35QZKxADD2W/rCbdoMtmIaxUzSRUN11tbyefM/WlegNIVjdKesljW
         tITsYfwB/p3dM9W2t70E3OuwhSaJ0QKt7rJDuUlwJ8o3Ae+WLtnM0ploDmihZeVY01YY
         45bA==
X-Gm-Message-State: AFuF++mM4GVHEdXOUkRg7WzvVcGootvqicF0M8/lip7GUoXv5p8orjla
	nIN+Of9wGcv8eNlGc4kBb2+q4DxDEbvbMtxgwve/kmtIq2xHQICKEaY+zrsmoxyHUUuTDZaBN6a
	C2qfqrbKEpQ==
X-Gm-Gg: AYBFou1EkKP+43S/EuRHszDR0ly80Lpb8sFMlGP805o1Lz+QMLWKexlFea3F52CEL0N
	wn3y8/JscDfJTk1JwuCO8SByyuxdqU6/Wh5iA6LA+/b+Si39irQIrlrQfiy8cAYt7t+3IJE7Tmj
	VgDCbLbq7gbPuHwGBWSAVL6sC1tgmAu98KuQpyBtEqgrtfEjcthRyU57E7LiooHMMrqX1/17qyt
	m25CaP1A+hIWMPOAOABmlDIjtZ+6LAK5S4e+J3reEWI59IjZS1t/CbpXm1w4jh6jLve518V3sWB
	gr/pJ89SpMYRosIi99iH/xjB12EbRubKHUCFKZLtoOnE+GLO7uzloIkHvxfmh2UgJHRZFei8J7J
	GoJ7qFvOVwfUAdldkTl5TSiV9is2N1SXlMwG5x5CX9iGKVvUfKhHwRbKqcKFeMwtNUCbuJhn8vn
	tELyJXLPVyrtujciXxnlyaLl2BfH6OHZ5oMn2CoqrcXkDGy64GRfCKLOkr5aGHzKU=
X-Received: by 2002:a17:907:8b90:b0:c26:22ec:db92 with SMTP id a640c23a62f3a-c2e23e01a9dmr8483266b.47.1790744350798;
        Tue, 29 Sep 2026 21:59:10 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88722f72b9dsm194711b3a.8.2026.09.29.21.59.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 21:59:09 -0700 (PDT)
Message-ID: <dc67e026-1af8-44e6-adc6-f4c2e398f93e@suse.com>
Date: Wed, 30 Sep 2026 14:29:05 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs-progs: receive: fix unused variable warning
 without LZO
To: liuh0329 <liuhuan01@kylinos.cn>, quwenruo.btrfs@gmx.com
Cc: linux-btrfs@vger.kernel.org
References: <1ba84f08-92d8-4add-9e19-82f47446de87@gmx.com>
 <20260930022142.26073-2-liuhuan01@kylinos.cn>
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
In-Reply-To: <20260930022142.26073-2-liuhuan01@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/30 11:51, liuh0329 写道:
> When btrfs-progs is built without LZO support, sector_shift is still
> declared in decompress_and_write(), while all its uses are guarded by
> COMPRESSION_LZO. This results in an unused variable warning.
> 
> Move the sector_shift declaration to the LZO-specific code path so it is
> only declared when LZO support is enabled.
> 
> Fixes: 345731fff32d ("btrfs-progs: receive: optional build for lzo, zstd")
> Signed-off-by: liuh0329 <liuhuan01@kylinos.cn>
> 
> ---
> Changes in v2:
> - Move sector_shift declaration to its only usage, as suggested by Qu Wenruo.
> - Add a local scope for sector_shift.
> 
>   cmds/receive.c | 18 ++++++++++--------
>   1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/cmds/receive.c b/cmds/receive.c
> index 49103ea3..02c864a6 100644
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
> @@ -1220,13 +1219,16 @@ static int decompress_and_write(struct btrfs_receive *rctx,
>   	case BTRFS_ENCODED_IO_COMPRESSION_LZO_32K:
>   	case BTRFS_ENCODED_IO_COMPRESSION_LZO_64K:
>   #if COMPRESSION_LZO
> -		sector_shift =
> -			compression - BTRFS_ENCODED_IO_COMPRESSION_LZO_4K + 12;
> -		ret = decompress_lzo(encoded_data, encoded_len, unencoded_data,
> -				     unencoded_len, 1U << sector_shift);
> -		if (ret)
> -			goto out;
> -		break;
> +		{

Why? Why not just simply do the following?

diff --git a/cmds/receive.c b/cmds/receive.c
index 49103ea3eeea..f592a044801d 100644
--- a/cmds/receive.c
+++ b/cmds/receive.c
@@ -1186,7 +1186,6 @@ static int decompress_and_write(struct 
btrfs_receive *rctx,
  {
         int ret = 0;
         char *unencoded_data;
-       int sector_shift = 0;
         u64 written = 0;

         unencoded_data = calloc(unencoded_len, 1);
@@ -1220,7 +1219,7 @@ static int decompress_and_write(struct 
btrfs_receive *rctx,
         case BTRFS_ENCODED_IO_COMPRESSION_LZO_32K:
         case BTRFS_ENCODED_IO_COMPRESSION_LZO_64K:
  #if COMPRESSION_LZO
-               sector_shift =
+               int sector_shift =
                         compression - 
BTRFS_ENCODED_IO_COMPRESSION_LZO_4K + 12;
                 ret = decompress_lzo(encoded_data, encoded_len, 
unencoded_data,
                                      unencoded_len, 1U << sector_shift);


> +			int sector_shift =
> +				compression - BTRFS_ENCODED_IO_COMPRESSION_LZO_4K + 12;
> +
> +			ret = decompress_lzo(encoded_data, encoded_len, unencoded_data,
> +					     unencoded_len, 1U << sector_shift);
> +			if (ret)
> +				goto out;
> +			break;
> +		}
>   #else
>   		error("LZO compression for stream not compiled in");
>   		ret = -EOPNOTSUPP;

