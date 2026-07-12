Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44D23769FE
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2026 22:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783893676; cv=none; b=X/oQHPI9GEZo8+FCIsOHa+QfmCBc1TcT+QzyMc+ViqkLPJdSaNXc1xo1UDuCDuO5m+tJlihN8dHPrkaCb6yszmeJLvhAORNDLHJ3kU5EZ4ywxpKjdk05JiD+0Ors4Yj5E3vznBWomSkp82x9zMBEdCUCRLC8lgvpOhgVKrv2MJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783893676; c=relaxed/simple;
	bh=BOpVYrTNhjghP5/enVXtFM+9uuSVo5HZFb0YmZtFevM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RF9aOdYTqE4eG6zNUjB08jSXUwUBgCkeV1ZqWDfFraGCmsidZAsm9DCslF9Yz+1VIVlFUSd1rjC+iKYD972UKV3R7zac+eRT6Rs0ZsvIbANnziHH0HG8w7Awj0ZqTnzlLhBuuaeaeelZVTy3F4A2FBkWEp45ZjBZFi9FCzQlHtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Xpz6aSE8; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Xpz6aSE8"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-698a9f11776so3919379a12.1
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2026 15:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783893673; x=1784498473; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xq9qAMC5A/wvIZiuTMSrFsa3uUeo5oL44ebMOxmKbgE=;
        b=Xpz6aSE8Mb/d4TmKCz1oobcguMtIJJBcUgml2oriYKTaQ5R2s7r1VgE6JzopC4iDzG
         R4w450zOyR3fijktt5e/ix32WXKXEC8XwoRvh+CbkuhER2jE9QOYm1MudTWYNbfxI8uG
         invk+1tx/gTmMorqzUS0nyfIsjtVpiovyTqBfH+aDx0YDEkpwVrgTffqiGxhUV3D0XYI
         nzabBiovAiOQP02FQsv4Ba21ZU6B6XO+o1QMAxF0t4Q5wJWlDlSpf0VsCTQJTDxOGn8b
         Mh1pSUgGmsx+Eiq1F8cMxHZo/jBPtIHnrtJ96xCSyMEOvN0yVRnbrAk8yUikGkA2C39u
         VZ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783893673; x=1784498473;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xq9qAMC5A/wvIZiuTMSrFsa3uUeo5oL44ebMOxmKbgE=;
        b=pMAkDwwTVaSftuQBUh1nW4g0n1ZuIX7527zwoK4EKg4Rayk3X9mlhwJHAPejYsbHQU
         ZjQSCyMCdQvYK1OT96rFptU56v2N69ts0WkN8y7MJCfhraHGiTyHfd+H987RTzaXo/iZ
         Thg0iny3f+Tpy6F1bOKjajcXb0HqZWfwmO5LpNwUe4vWqL5ywX1//CLB1YuBh4CvkW4y
         PPdjahlwG9sNnDvuun2A9XnI/prEWMITWJKlUXYywl79ZwlbPgnoMiDo1/Un6OxKcIuT
         Hr/izFj73NhAI8sXC3orGaJXK8T250eBZpAK8lwlaBA5Ru539lzu9gAy4TP1fhodP37G
         A8ZQ==
X-Forwarded-Encrypted: i=1; AHgh+RqIrcE2a0A+hgbJjCtfrn8rWc6Q7xf/n1J3d/uBuDA+5xoX2GTYoeJa8HfCo5oPvPuu4GhEWvn85QBdSA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxs898lYNB462FKOtrtM0vSfjLSCa4UKrWA7Qze/7B4nF4Y7OJQ
	45kUtj/hGBsDf9CnnRLmcPz9cp7nB21tMen/lcs55G2CihOPEDLlkYKZN08EunOYFn1HxYZvGeS
	k7wPbua8Aqg==
X-Gm-Gg: AfdE7ckwOXkkV9VSL0h48GWw3iwpoYH6cbItJKq7qQUsKseN5ggfTqm+fleknDYPkXx
	pq2c27PaYRp3wlrTzoWmplnSx6IwebSIO4copRfhYrmmlVnulhetg26ahEGvlIrVcxmXcFz4tBq
	JNhnpI0C0vzNp4CLc7J1aIxi/WFIPxmWWZCWTbNzst7i2MUn7hob0Eksv+lO3C4zc8R29Se7cKK
	JTUDyRYJHFd2C7k25EGH3ZF0VYBVfVvA6xBi7n0e6FfIThcvyIuVfe7xxGgpJlNDZeywLomyi3e
	glk0w/A0Jg2g6qa6iRz4ypZ5PbpOkMjzr8rJhK/oZsOqoWarXL+HAxjZSEk/ZWiPE8IthvE1+Bj
	4ccWILAFntG5rPIo9DmGK68O0QLXGzKZUNji33fznJio1p8OgmebXyqbSnKE4XNifSuzBzutn2e
	nQ06S7wYQLzKmm+M8sD6iCbVAPL3w=
X-Received: by 2002:a17:907:97d5:b0:c12:b2dc:4834 with SMTP id a640c23a62f3a-c161ea6d217mr293621166b.57.1783893672938;
        Sun, 12 Jul 2026 15:01:12 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bdcbe2sm90703955ad.9.2026.07.12.15.01.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2026 15:01:11 -0700 (PDT)
Message-ID: <95fb922f-996d-4f3b-90fe-ab0b8db1388b@suse.com>
Date: Mon, 13 Jul 2026 07:31:05 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: test checksum handling for clone, dedupe and swap
 on NOCOW files
To: daan@amutable.com, Zorro Lang <zlang@kernel.org>,
 Anand Jain <asj@kernel.org>, Filipe Manana <fdmanana@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20260712-push-kwzqkrlxwvnv-v1-1-e2466aff1bfd@amutable.com>
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
In-Reply-To: <20260712-push-kwzqkrlxwvnv-v1-1-e2466aff1bfd@amutable.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/13 00:07, Daan De Meyer via B4 Relay 写道:
> From: Daan De Meyer <daan@amutable.com>
> 
> Add two tests covering how checksummed and NOCOW extents interact.
> 
> btrfs/348 verifies that checksummed extents can be cloned and
> deduplicated into NOCOW files, and that the reverse direction stays
> rejected because NOCOW extents do not have checksums.

I strongly doubt if you have run the test btrfs/348.

As a very basic reflink clone from a datasum inode into nodatasum inode 
will cause btrfs check errors, with your kernel patch applied:

  # mkfs.btrfs -f $dev
  # mount $dev $mnt
  # xfs_io -f -c "pwrite 0 64k" -c sync $mnt/file1
  # mount -o remount,nodatasum $mnt
  # touch $mnt/file2
  # xfs_io -c "reflink $mnt/file1" $mnt/file2
  # umount $mnt
  # btrfs check $dev
Opening filesystem to check...
Checking filesystem on /dev/test/scratch1
UUID: efcb3cdd-5dd9-416d-89ac-33071c59c9e7
[1/8] checking log skipped (none written)
[2/8] checking root items
[3/8] checking extents
[4/8] checking free space tree
[5/8] checking fs roots
root 5 inode 258 errors 800, odd csum item
ERROR: errors found in fs roots
found 229376 bytes used, error(s) found

> 
> btrfs/349 verifies that a NOCOW swap file containing a checksummed
> extent is rejected even after the checksummed source is deleted and the
> extent is no longer shared.
> 
> Signed-off-by: Daan De Meyer <daan@amutable.com>
> ---
> These tests cover the kernel series available at:
> https://lore.kernel.org/linux-btrfs/20260712-reflink-into-nodatasum-v1-0-9f27ef836073@amutable.com/
> ---
>   tests/btrfs/348     | 180 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/348.out |   2 +
>   tests/btrfs/349     |  73 +++++++++++++++++++++
>   tests/btrfs/349.out |   2 +
>   4 files changed, 257 insertions(+)
> 
> diff --git a/tests/btrfs/348 b/tests/btrfs/348
> new file mode 100755
> index 00000000..4faf994e
> --- /dev/null
> +++ b/tests/btrfs/348
> @@ -0,0 +1,180 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Daan De Meyer. All Rights Reserved.
> +#
> +# FS QA Test 348
> +#
> +# Verify that checksummed extents can be cloned and deduplicated into NOCOW
> +# files.  The reverse direction must remain rejected because NOCOW extents do
> +# not have checksums.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick clone dedupe scrub
> +
> +. ./common/reflink
> +
> +_require_scratch_reflink
> +_require_scratch_dedupe
> +_require_chattr C
> +_require_btrfs_no_nodatacow
> +_require_btrfs_no_nodatasum
> +_require_btrfs_command inspect-internal dump-tree
> +
> +_fixed_by_kernel_commit 28ce1d263f4d \
> +	"btrfs: allow reflinking from checksummed files into nodatasum files"

Nope, this is not a fix, nor the commit is upstreamed.

A proper test case should detect older kernels and skip if it doesn't 
support a new feature.
