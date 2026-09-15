Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921EE37416F
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2026 22:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789510702; cv=none; b=oSvc0jlPR4dNJxEm8MCgpT1FeJF0o33KQCTG0+GHsMfFwY9lPmjPRd3eRL6NYWZhFuC1LCfsnwjGJ70kRCVa+ITuH2nymaT/t9UpIWpF6WhRlAN2QeBoLx22XywnWcmW9xyYuNCVvVr+kPeMjdO050xehuvADFA9FwbqtudVNIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789510702; c=relaxed/simple;
	bh=bKLrzd7mzke4xNMgjy1dDJw5E7c0Bo+7KuWuUyP0dB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kBEtAEHX1IfGXIrvm/71RXjB46oiZcOaNXazaPrJFD+luHgfsd+dZoj2dsuDDaZy5t5aulh1X/wZtomyGRQlHujUHOGi8YZ/aKE6fjGwgkyOSYZgl7Rvo7NFlIuCw7so+TBihuoWMBceOw2KvdKiC0PJ1DV9wGt9DuiHVVzN+GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OLHVOSh3; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OLHVOSh3"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c294af0caa8so45397466b.1
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2026 15:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789510699; x=1790115499; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pdk/vYsItmsk6uXrnubu3MUn5VZJ/8iyyzxZQ2N88ho=;
        b=OLHVOSh398beVvfQ2OQhx+njOiN8VuM27vCeNYzMWN12NCDe4ceQhYCIBkEyu13ACe
         ZBeivKTsF3hh/4S8ZlfTj07EmxYZfKQ1q2A4uEfMRSHVx/dTPHzMRgNEzPrmem0kHkvH
         im7RIFsykLGGcPPmMyaHjWVXSHc1MDZBc5rmuJC3kgZamxsltB6leY01xboCDw583DPJ
         dmddjoE9R4mXtBdv95BAvrYnfZkwikEuB3rIbHIWFNkVmF4OeBwCvM7UWl/uA0KPrkKv
         ujUMX7rO2UVA5+YeCy3dubYOfUE3hRghmMieRk+Ba3elOIMa5vJ2V+6ocnmjJXzjpGxx
         LqEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789510699; x=1790115499;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pdk/vYsItmsk6uXrnubu3MUn5VZJ/8iyyzxZQ2N88ho=;
        b=TSlvVp/vUefe7ofR3ivuVAnRPfKBZdw1/ojEHQSxcoNgUYBcfZ8Jd/hhFNTsNyKDg/
         izBe5yBIO1Bisq5szLk+8BJv4sdjls0hEDS468u3WDgkia2BVNqTfl00amQOcGreQXPu
         Y1iTrVbrr7J3GHxx/3ZCcuyEM/Fp5+cwzcF4sFCvmSkeblCq4s4xh7RLLVBDDhxo+EXu
         qZF0x+L6/lvqB5B5oX2YUa0msqlHCLkVcZEvYTPDbkH5jNACRY4DMp+SI/Rk2iAsQx0W
         lktn/FMfBZLwMk9Xof/Ie32adDYLRoLUxM0jnXTdDmPYEhOZ3A8W8cYwAAbnckz4QbO4
         QkNw==
X-Gm-Message-State: AFuF++lFPS55zXYI0Ul6DO+I5/6CLxncv6SUzvqpU8KSigi3RDYcvsMF
	Mrnc1rKCbatzIS8bW/Z9Z1TtRIdldE8yi8Ahv0+sMDyF42CQk4m4ui1wmQ3WvAig8nk=
X-Gm-Gg: AYBFou0nfHp9I3OKeHPNboIBYwbYQIGrS0LZh4pUy2cD4TqBj2upkhWEV4FvqR/Gko0
	8flHBXj75e1qhS/LVRD3vclw2PSUUSDqVE/oSCmOg4BNu3bzWP0Ac5p8VQ83iQVJqrBSxy29cmE
	PlnTOGAQ22RpIlWTd3SiQtBwqDC3vZXhCiR3wOj0mpAcohRL9UOD9Dcu+/moGMVEmK64D7swbZR
	ZkoQqsAOIDcuyONZfB7ve3cBXR3z1eiOuh/BqSfWcpF0as9Zo9gbF2cljy7wowKTX1xOMD9n1VD
	ahxnJmlIlyx99xHLg20qTGZ0YHvVy3lumVHOh1I/auqXiYLE8tXrDWW03mxlUSJ9vIKGoMFpNMK
	aa+hN9Bmy7BsynH/frN6NpTAYPHlDJ5DJlKSVCANubL1oYlMD74xRbnGYSjpkaA6DA0XXWdQ/GV
	Tv010LUY6NQva5MCnsK/rFPjJJ+fUd0xtgi2MXBoJYOpPlbLIFimMGDu/EN5hqTvc=
X-Received: by 2002:a17:906:7949:b0:c26:2205:3df8 with SMTP id a640c23a62f3a-c29e52903famr4435566b.9.1789510698935;
        Tue, 15 Sep 2026 15:18:18 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87200c581fcsm208935b3a.12.2026.09.15.15.18.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2026 15:18:17 -0700 (PDT)
Message-ID: <b735211e-5987-4829-922d-4b80633f699d@suse.com>
Date: Wed, 16 Sep 2026 07:48:13 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] common/btrfs: exercise all algorithms in
 _btrfs_stress_remount_compress()
To: fdmanana@kernel.org, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
References: <cc052d6b35788720c6cdc93be7eb6af637a9fc96.1789486070.git.fdmanana@suse.com>
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
In-Reply-To: <cc052d6b35788720c6cdc93be7eb6af637a9fc96.1789486070.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/16 00:58, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> _btrfs_stress_remount_compress() is using a hard coded list of algorithms
> which is incomplete as zstd is missing as is supported for some years now.
> 
> So remove the hard coded list and use _btrfs_compression_algos() to get
> the list of supported compression algorithms.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   common/btrfs | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/common/btrfs b/common/btrfs
> index 0bfb02dd..3eb68beb 100644
> --- a/common/btrfs
> +++ b/common/btrfs
> @@ -449,8 +449,10 @@ _btrfs_kill_stress_defrag_pid()
>   _btrfs_stress_remount_compress()
>   {
>   	local btrfs_mnt=$1
> +	local algo_list=("no" $(_btrfs_compression_algos))
> +
>   	while true; do
> -		for algo in no zlib lzo; do
> +		for algo in ${algo_list[@]}; do
>   			_mount -o remount,compress=$algo $btrfs_mnt
>   		done
>   	done

