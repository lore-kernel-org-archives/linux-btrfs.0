Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795655838;
	b=EfdDDoUZDb7VKLeKbWTmJo5Z1xmIG4z9Ds7xq6x3xLOo74KhjZoVVGLhz19xpRoTb/c/
	 qN2IH5IYO96Hq15bUwJaTG2yNDBuwmm6dHWxu1jqa9UlP1Aj/p19hs8T3aseS4zlfRTSq
	 y/OafNLVBJmmVUpdGJvgLyRfAEbiNLY4oH0UhAu8wEqfmuIIHLCx+U9sbFPS1ZbosBP4a
	 0ll0H+Dsvep9VFF4a24OZ1hG+xPEyitS/8dZsSfdDHicsy9YByICZ0qySqo/6y2jADTuZ
	 UjW94jyzUBiRh0Y6OXlHHlJh6LR+sGEXT9jr/bpIzA4VlfETI1tMDAaKoBuounMIaNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795655838;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=8vhDEbyn1nkYBGZ2jl97YuxcDAz2vqULbU/VOeX9XGM=;
	b=sNbkuJi5HTe0NAfvIq6gJAGQGEOr1TY0bbfuFiEWyDTC9s/G4wSEP8cjEc7s/Uu+JES9
	 PJFikyuFzuZLXoU9eYCTQA3Qrv9U3nhXstc2pvRQSfyw+c+ozr7MUavbCjUCauCxQmnEm
	 8y9m8dYZdqBAB6uX1AyM7KJ9xPTPCCFsPm79cEP8fZkEq4bdmO+oBnwak4eUbR21pksrW
	 yzxAp5QNWKNUWGb11kTYBxbj6Km46dtLzTAz2blV7Hzt+YfmY58Sn/zuqKqM9Zve80xgC
	 ELXbMA0OshGC+GwWsONXrQTEFOJ9mgs3Zoz5xFe2eOZrT2XGVevNgF1z/bM4L1s9ulg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=EuPcaFp9;
	arc=none smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6AD606A321
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 01:17:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B6AD606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=EuPcaFp9
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c4d5b2db4bbso1214224766b.0
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 17:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795655836; x=1796260636; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8vhDEbyn1nkYBGZ2jl97YuxcDAz2vqULbU/VOeX9XGM=;
        b=EuPcaFp9BXac6sMmb6amC/sR4AV3C810SzQPpUadP/CfYhNJy95HQsqugEQEF2j6X/
         hM9gfQzFVGfyzTwTLXpS2VwXeFVoKiz7QXps9mnzKN+jSK5XrUvLQErzOEBZ/SYP2uOX
         G3j4mAXF0nUzjlVKJrVvXV4JEl/A8e1PcamDXVPTTvUeHC0JpBHWGUBCwXPrnQmH3n3p
         j0y3yd0wXW/9fQJQariK7blt2FBn1GiGFGUIhMW3zwY7qsr1Xop+Y6wgHYs4DkmRt0ZT
         XHk6U65FBDhQo8yOok+iVuRTpH227Jp94oddWifomkp13/RdmxXbFcExrnj0funb7Zmj
         OQ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795655836; x=1796260636;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8vhDEbyn1nkYBGZ2jl97YuxcDAz2vqULbU/VOeX9XGM=;
        b=NWP+aY71mk5iCoCn86RmSXY/3EHVTjn1drynn9Q66JswETDOu1bH6zFLn5lBDwZOst
         NN2qZe/TSet8EG4JnfArP8aLiFLuXBgV1UKP1wsf/U0E5+zhIDoAtRhwJxmOega/r8km
         aTJufdN+3VrxmKntkYlen5qjzaLf6WF4WBNyImZo0dYcbUloEofL8kyqoGwKYlKKaEdx
         kFf+ZFW6fwKUKwgsEpSg/nAt5tGtZ/I4i5olejVqB8i3GUnCfqvv89+BZBhBPYuCocwk
         /76EtCbJb8Z8kj5tuxQQDscP7V0wDfH6Ris0GbIYnimLFQ8lY0toffvs1/8XTaMXnVc6
         Beeg==
X-Forwarded-Encrypted: i=1; AL+hErGenNH05l6Pr/5l/396PiqE6HBZuvb9idPyYyY6qj6bcLZppfNNdKAVE2GeRV4JvId3irZHMlQoVUp0PQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z/dunqDom+tRe5gb2RvAtGChfbca1t83NqLqyCp1Ox5yVf/IWKC
	BuJltHcLot32b0zFcndLBppdOGlwbiSdMkVgmj2bmnigEcBAgloBtfZWIs+6mkTEeIY=
X-Gm-Gg: AZFdTZfLPCMlONc2h+d9UCxm1Kj0XoyqW5bzVIPQ5S288tFBje7E0jgA4XFG9dBpNon
	4SQnGuRQkbTSUkH+IvEsFNzs+YfVzSrduB12A7dXwVs/UIMnf4/Dyhd5DOCA2utp5Wm4XRAThhd
	tT+h4x69wizu803J/Iw2kzkECkyv3QU0mYPmKm2zUWJEFnFOX1jrAejLemFT0gWXYMq3WNjCBGP
	z8O0kGFnwHj/RUsPj/zYh1HoqX9klAVR/wcbvZFmT9Lwf47Q+vziGZasaDeWRJv5gtz5/i8WAqg
	Ln9HGJGd1O5jldInI03cNTWorhx1R9y7AiMAz5va4nHxABLR739IkhFPWcGwlrPXvbBa+KRluxy
	GJZLNYjdJqqv0R7h8rCzzl+Vug6NG4dlq7ZQfMzy95bHd2ezoNPoFeXDYEdo3snsD5ojHOcJsc1
	QBgVPF8UcOX2hESXB5XXI6srTSyXoAxrUBTgARWiP5EtIhHsdUzhWFS1iGnjkQna9GevkV2qsO9
	uKPHiQJuj5xFmJRFJjzXLcw12VLw4+QwgNPIqVIrQcKGHfuDNc0t0MZ+r8/LuHpeEMDz0rrtpNs
	FW6OYb9fLpFwXUNyrOk+vTIFOEv1ecgGDBlrCAM7tjE=
X-Received: by 2002:a17:906:730a:b0:c2e:1b6b:8b19 with SMTP id a640c23a62f3a-c51319443e5mr1859065766b.23.1795655835781;
        Wed, 25 Nov 2026 17:17:15 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cff4c1asm9716494a12.15.2026.11.25.17.17.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 17:17:13 -0800 (PST)
Message-ID: <03dd7e64-2357-4e8a-9383-d748b4883efa@suse.com>
Date: Thu, 26 Nov 2026 11:47:02 +1030
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
Subject: Re: [PATCH v2] btrfs: tree-checker: verify tree_block_info bounds in
 check_extent_item()
To: Elkin Cruz <elkin@google.com>, David Sterba <dsterba@suse.com>,
 Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, irogers@google.com,
 stable@vger.kernel.org
References: <20261126004332.1712403-1-elkin@google.com>
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
In-Reply-To: <20261126004332.1712403-1-elkin@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/26 11:13, Elkin Cruz 写道:
> check_extent_item() only verifies item_size >= sizeof(*ei) before
> reading struct btrfs_tree_block_info on non-skinny tree block extent
> items (BTRFS_EXTENT_ITEM_KEY with BTRFS_EXTENT_FLAG_TREE_BLOCK). A
> crafted filesystem image with 24 <= item_size < 42 causes
> btrfs_tree_block_level() to read past the item and potentially past the
> extent buffer's populated folios.
> 
> Verify ptr + sizeof(*info) <= end before accessing
> btrfs_tree_block_info, matching the inline ref bounds checks below.
> 
> Fixes: f82d1c7ca8ae ("btrfs: tree-checker: Add EXTENT_ITEM and METADATA_ITEM check")
> Cc: stable@vger.kernel.org
> Signed-off-by: Elkin Cruz <elkin@google.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Will push to for-next soon.

Thanks,
Qu

> ---
> 
> Changes in v2:
> - Use (ptr + sizeof(*info) > end) with matching extent_err() format to
>    follow the existing pattern in check_extent_item(), thanks to Qu
>    Wenruo for the review.
> 
> v1: https://lore.kernel.org/r/20261125221849.1424464-1-elkin@google.com
> 
> I am trying out new Clang static analysis checks for kernel bug
> classes, and they flagged this code as possibly buggy. The findings
> were triaged/fixed and commit descriptions were drafted with help of AI,
> then checked against linux-next (not runtime-tested on hardware).
> 
> Thanks,
> Elkin
> 
>   fs/btrfs/tree-checker.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index d2bf21c7b848..40f2355cbb1d 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -1665,6 +1665,12 @@ static int check_extent_item(struct extent_buffer *leaf,
>   	if (is_tree_block && key->type != BTRFS_METADATA_ITEM_KEY) {
>   		struct btrfs_tree_block_info *info;
>   
> +		if (unlikely(ptr + sizeof(*info) > end)) {
> +			extent_err(leaf, slot,
> +				   "tree block info overflows extent item, ptr %lu info size %zu end %lu",
> +				   ptr, sizeof(*info), end);
> +			return -EUCLEAN;
> +		}
>   		info = (struct btrfs_tree_block_info *)ptr;
>   		if (unlikely(btrfs_tree_block_level(leaf, info) >= BTRFS_MAX_LEVEL)) {
>   			extent_err(leaf, slot,

