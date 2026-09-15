Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511DD47CA6D
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2026 22:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789510620; cv=none; b=EGqBfNGF39zETW+p0nZq/xdRN9LTy1xZJazYN3Itfti9YsOcT2xmmoGesJCB6bMGSUGHgbLUWAd8J4HDA4D0sicbFNzsDCyG+C454zgiQQnRHuYs7hBq4WwmqPaO2dsxZw+IMuBwEmjgBJGX6VlOdXtZ2iPdvU6ch4gHx9opwp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789510620; c=relaxed/simple;
	bh=m0VworCC0hvtkyN35xI3DVvQHc1L03vSJl90gKlNcvI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YNcSL6NXnXAOiJ26iMFN73PoSQNetH35Jk5qh2Dhqf0kW1oNrX+PTzRoKsEI2/TcLCoH/BbhyAz41fgaLvzQ4B3t15u01OA6fFmKqVnhmzifk4nyrIwjRU4zRrnH1fjencUXsq2aCosNPzpQKOmQIOmWe4uUvVKS4I2AA43ODSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YJgrkkir; arc=none smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YJgrkkir"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a605844571so427817a12.3
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2026 15:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789510615; x=1790115415; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g/3ioZ/oq7xLigqBssrulMujM0mR1kVlUfT5AQAbB8Q=;
        b=YJgrkkirYmPil/STC+AN7+HbNRYeoau1J3XQqp+eXHmdguhVAJM0pJzlBC8DRMiUgs
         fS3pXRSaa04f/nElujpok88/c/XgGtgQY0ir8JWIfpsQymb3w+GISqemQsOvhnmemDVI
         4++kpzZOeboS08SWRbW7V1x+QeJnXW/huNu7c4Ikd9NVDL8bLhasKBkJ5R7YvtBYnFLS
         uHFsFzGPHxWFMyF+30LYmCXN6BjWER7MIPwYkALFQUd+p/A5+OncUNXrL11n53SsdO6l
         zk0iP+CtuNhS9+raWe3GomeQIDsGTJO4D3NIYX9xf07VygtxNB6CIFPCSoz53riLPeR7
         NMaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789510615; x=1790115415;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g/3ioZ/oq7xLigqBssrulMujM0mR1kVlUfT5AQAbB8Q=;
        b=KVz27RfKPf1LFsTOHgf7tOvymEh0fuSCyx7d6Be7vh5/3pNkm6zchV+HnFzxA383Rg
         G1kn4zSwbv1nT17mVU5lrTMiILdOgnycboOtLtyWanRNE0lcPSuS44kqOGq7iimQ6fZo
         I3QS7W7uAvWlrnU0HO5LWwt9VSnvmSjCdnyKoHiYzZgc/VrZ/51pIo9ZJJaGfxuCrsXg
         pB2dn2T71o9m11LiW8UkauEucU9zFNLHNDTv0ZSArJVecbZKjOYCrbIFkwYFZ5eYAecQ
         vEocZybjcvrv89BGTdZWA7MyvrCIuuGLIdSOYk0DVhWJLACbjfXZCwqAiQHKLEXf+q8r
         Gjkg==
X-Gm-Message-State: AFuF++nnXCu4CfuyHiwbI0QS93eqZPIEGLly0nWrpCdzQmAti3AWqpo6
	O+AMk4fERFflvzOwf350tkME5bbBRZmkffXo0DQvH0IFPAZmnA6bvm1kfE79Dx3DISE=
X-Gm-Gg: AYBFou3h8jZvX07xRzg3d9a29buR+DS2V0IEKEoU7Uh/3VaKyDnhMGRMrPoZyh0U8K0
	xefxtjqIqd+yL+7xRB9dellHsXxeaEbFqrTIlzHrvCxrTi7P7d8IF+InQH7jBXlV+fSZkPL1UUy
	VzqRKQqvaTULmmQNwThUPNaF8a5TnID2eYx28V7/VY/4ecNcf93avpHvcl/ZMkKcpxcPkN5pUx2
	0sBrP8cMwFFroYAlq5QWoo80F8dqSS/HzKCjcN8/JxQzjhNTrwFRASEG7mo3fkKGNmVTsuPP6aB
	36w3asJ3Ac5QSvLMVL/b6uLGVf5TGu2El0u+KY+6b7bzJ71ome7FCKzH/NuckgXdJvTQDYsYdda
	St9BhM67ndGl7Zud4lAgkjcZrHNbYiVQT0eBm7vVu+OP/yFxgz8wsutjad4QRAU//lyumCk7A1R
	NgG+eNnnlqCGvYspuZ9nj9hFWN8ENklWLdaQIWvLB7bNbXqGZewVnQUMrIPwtNXdSsBkr1+OJl/
	g==
X-Received: by 2002:a17:906:6a28:b0:c21:601:6501 with SMTP id a640c23a62f3a-c29e52293ebmr3900166b.20.1789510615118;
        Tue, 15 Sep 2026 15:16:55 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e1d1626adsm160217a91.4.2026.09.15.15.16.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2026 15:16:53 -0700 (PDT)
Message-ID: <f27a50d2-da40-4811-b459-f9c2ffc9c082@suse.com>
Date: Wed, 16 Sep 2026 07:46:48 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: test that we don't create pointless compressed
 inline extents
To: fdmanana@kernel.org, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
 David Disseldorp <ddiss@suse.de>
References: <83e3a8678c5eafb1cfcf10741a53b6e586cd72d8.1789408399.git.fdmanana@suse.com>
 <5acebd19e4e5b9b825497947ef32527cc2103147.1789484528.git.fdmanana@suse.com>
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
In-Reply-To: <5acebd19e4e5b9b825497947ef32527cc2103147.1789484528.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/16 00:35, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Verify that we don't create compressed inline extents when the compressed
> data size is not smaller than the uncompressed data size.
> 
> This exercises a regression introduced in kernel 7.1 and that is fixed by
> the following patch:
> 
>    "btrfs: fix creation of compressed inline extents that don't save space"
> 
> Reviewed-by: David Disseldorp <ddiss@suse.de>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> 
> V2: Use a single call to btrfs inspect-internal and a single awk
>      call (David Disseldorp).
> 
>   tests/btrfs/354     | 46 +++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/354.out |  2 ++
>   2 files changed, 48 insertions(+)
>   create mode 100755 tests/btrfs/354
>   create mode 100644 tests/btrfs/354.out
> 
> diff --git a/tests/btrfs/354 b/tests/btrfs/354
> new file mode 100755
> index 00000000..1b25ab5d
> --- /dev/null
> +++ b/tests/btrfs/354
> @@ -0,0 +1,46 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 354
> +#
> +# Verify that we don't create compressed inline extents when the compressed
> +# data size is not smaller than the uncompressed data size.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick compress
> +
> +. ./common/filter
> +
> +_fixed_by_kernel_commit xxxxxxxxxxxx \
> +	"btrfs: fix creation of compressed inline extents that don't save space"
> +
> +_require_scratch
> +_require_btrfs_command inspect-internal dump-tree
> +
> +algo_list=($(_btrfs_compression_algos))
> +for algo in ${algo_list[@]}; do
> +	_scratch_mkfs >>$seqres.full 2>&1 || _fail "mkfs failed"
> +	_scratch_mount "-o compress=$algo"
> +
> +	echo 'a file with test content' > $SCRATCH_MNT/foobar
> +	_scratch_unmount
> +	_check_scratch_fs
> +
> +	$BTRFS_UTIL_PROG inspect-internal dump-tree -t 5 $SCRATCH_DEV | \
> +		tee -a $seqres.full | \
> +		$AWK_PROG -v algo="$algo" '
> +		  /inline extent/ {
> +			for (i = 1; i < NF; i++) {
> +			      if ($i ~ /^size$/)
> +				 extent_size = $(i + 1)
> +			      if ($i ~ /^ram_bytes$/)
> +			         ram_size = $(i + 1)
> +			}
> +			if (extent_size > ram_size)
> +			   printf "inline extent size (%d) greater than ram_size (%d) for algo %s\n", extent_size, ram_size, algo
> +		  }'
> +done
> +
> +echo "Silence is golden"
> +_exit 0
> diff --git a/tests/btrfs/354.out b/tests/btrfs/354.out
> new file mode 100644
> index 00000000..8bc7ecf6
> --- /dev/null
> +++ b/tests/btrfs/354.out
> @@ -0,0 +1,2 @@
> +QA output created by 354
> +Silence is golden

