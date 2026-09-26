Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E6536D9E7
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2026 05:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790402331; cv=none; b=OayidvvbxqkoPg+HSt7mtkzq3K8Ag8VS1VUc7m4f7JlLTu8/yWyEpGIDsVRfdyKk2iqyjAZv7ZLVv3lPaE+sD+GRi8+w12A9THO44yNMtQWw/HPE1d/ECdQ76j9Pi0MdBrRlPqqZ9i0ep4IztOKRhABDcN+gd0QmLTCtPNbR+vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790402331; c=relaxed/simple;
	bh=B7ZZi1+CkoYMDPVqiu77qo4+K9oTgZr7dOowfG+dB1E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a5DOyF7fNpFyy8S0NV5GGvYOlq+Be+DW9zlVOgkYE8Aek5Fccsz9cjwjGoGpyXl1jB8ORBoC1p3h/Y5i4HeSKfU96kIxD/QFF+gmHgJQSgRNt0Wc8odC+E8B/eG1jIRvglGCl5elo7txYJqcv3Jkb88sxw+y8/gNaon0SmCk3gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gxkxg/PT; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gxkxg/PT"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c29703cb470so242446266b.0
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 22:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790402327; x=1791007127; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eRoOKu7wWDUfVEc6t+RlTgBMVjPXjuwtLo+K2bN36aA=;
        b=gxkxg/PTkFDBHDVmJgJ0sIUOm6XS1V15sMeH9FJ6ChujSyFpNJlB4fCB7jvkQH2ilm
         ZVxKblRphRXcD+Uyoc93GTw0JxoioxhHxPAeEgRAccZILhXsoFeK7AbgQXNvV+I80BWL
         5B0wWAbrJzi8fTRhbNWQDkknXTeJUD3LlR7i1S4dqOgAwHzckcHZSSvLo8hAH7rI/9Ms
         oN3eC/YpHh7ZG+MZmmymaQnz4Zmke6P3MQGJvwm9GBekPpMG5mccd+O0y7jTYgf1CLJ9
         z2Extg08iyWFGyhILn+kMYWjwBNL/9YdFJvIYtrFXcv7oupFxATC1txWYIqlWhX6JoPL
         HaXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790402327; x=1791007127;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eRoOKu7wWDUfVEc6t+RlTgBMVjPXjuwtLo+K2bN36aA=;
        b=QoCUamydQgKdr2o2718W35LQhcODdz8D1xBd+fFw9XLR93NmzK+RIsU6K+LTOWV6mM
         9kSqE2T248ImzKk0Msp7UKDLghg/bOj+5X+pyp653132nxIAkLYsxt752DeN87NP70vw
         lzkH7FqF9+dqd3gQh3aT5D2ZKNiqlz+ZKcDOuBqOk0mSjl5mnGCkyUbCX3SIyUsXPFHK
         VUj2B0Qv1PwGHIze/DofWRE9f0yXv/f8g51n1BIzrC+cldvLwuhiAFDMKgR+D7LNnY8O
         Z+7RVAnhobgb8KMothzE1ERrPDsF8t4scHLqCe/WDSZMNUUi4P2wfhJatwu/FC0mOzPn
         oh8w==
X-Gm-Message-State: AFuF++nCdtbwXZYoqT7+9iP1ThhIKhhNL0TH53XtgYrri7SdvYgyGpKU
	YJaeYg/eHJZQRuweT8aVbCISLO+JCN8ZZzSuU3xQvItWwpFb5OkfE1C7FyaCaZsEe+M=
X-Gm-Gg: AYBFou1N9qYUJd4BOLkEdTJQzgZ68RTTAq0bW2ZFwjzI87cyb+8Mb4RnfYMkn2zQL15
	8oBGzzHmkfESA3FlU4t+XEN7VH+ucyHwXUCL6rJZyn8my83RElUlo0YJ1BsbXB7yMOB1Qqsg9Rr
	VIHD0FfQF/zCITBPGzfyCORu3Kb5IeGIQJdg9GVyiltR/GgDgjSxC4d25a1YMgNin7ui5/gEYeo
	X87D5D3OiEa8MsK8UoxJqZRBDKxFcGQkbK6qJlibBuRGJT2qJ0UAClpws74hjUnTeF+mVUNYeQb
	T2QZ4WYNEavL/HLO/MV5Y6yjDeVijKDyRJhtawp42f2LmVQbqoBz9rk+3EwbaM5a/7nq+IZRADb
	XDMo1QVtZAlNaduQnAi54hmGp/4L60rlMH4vOzNDqSUF+0KMDIW0dX/VJ7Tr+eFFX2BwplZvziN
	v2S8Ck7aZR+zdKVj0PukFHkSeqPWEEZ3uXxqxlPBEbstTsXh44ZCSrz1CqmOUtfsS/HpH0PU+q
X-Received: by 2002:a17:907:9346:b0:c29:f5d8:9c80 with SMTP id a640c23a62f3a-c2ac22d5a02mr679182266b.47.1790402326784;
        Fri, 25 Sep 2026 22:58:46 -0700 (PDT)
Received: from [10.86.128.19] ([149.22.87.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b998dbf2sm8161692a91.12.2026.09.25.22.58.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2026 22:58:45 -0700 (PDT)
Message-ID: <a76bf043-e379-4e7a-883b-cd2bfc1a5c05@suse.com>
Date: Sat, 26 Sep 2026 15:28:40 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] generic: test replacing a xattr with a larger value
To: fdmanana@kernel.org, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
References: <8916aea263bc59af6cfb1accacc2eaf78aaffe89.1790354960.git.fdmanana@suse.com>
 <7d2caec7b8ecd95ad63fcbbc7e1cc1c84ee50d7f.1790356355.git.fdmanana@suse.com>
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
In-Reply-To: <7d2caec7b8ecd95ad63fcbbc7e1cc1c84ee50d7f.1790356355.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/26 02:46, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that replacing a xattr's value with a larger value works. This is a
> test that exercises a specific scenario on btrfs where two xattrs are
> stored in the same item, and for that to happen their names must result
> in the same crc32c hash.
> 
> This was recently fixed by the following patch:
> 
>    "btrfs: fix xattr replace when multiple xattrs are packed in the same item"
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Missing the "---" line, which makes b4 include the digest and changelog.

Otherwise looks good to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> 
> V2: Fix missing _ on _fixed_by_fs_commit call.
> 
>   tests/generic/806     | 43 +++++++++++++++++++++++++++++++++++++++++++
>   tests/generic/806.out | 11 +++++++++++
>   2 files changed, 54 insertions(+)
>   create mode 100755 tests/generic/806
>   create mode 100644 tests/generic/806.out
> 
> diff --git a/tests/generic/806 b/tests/generic/806
> new file mode 100755
> index 00000000..1fcf0145
> --- /dev/null
> +++ b/tests/generic/806
> @@ -0,0 +1,43 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 806
> +#
> +# Test replacing a xattr's value with a larger value.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick metadata attr
> +
> +. ./common/filter
> +. ./common/attr
> +
> +_require_scratch
> +_require_attrs
> +
> +_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
> +   "btrfs: fix xattr replace when multiple xattrs are packed in the same item"
> +
> +_scratch_mkfs >>$seqres.full 2>&1 || _fail "mkfs failed"
> +_scratch_mount
> +
> +touch $SCRATCH_MNT/testfile
> +
> +# Add two xattrs that, on btrfs, have the same hash (crc32c) for their name
> +# and therefore are packed into the same btrfs_dir_item.
> +$SETFATTR_PROG -n user.foobar -v 123 $SCRATCH_MNT/testfile
> +$SETFATTR_PROG -n user.WvG1c1Td -v qwerty $SCRATCH_MNT/testfile
> +
> +# Verify the xattrs are present.
> +echo "xattrs before:"
> +_getfattr --absolute-names --dump $SCRATCH_MNT/testfile | _filter_scratch
> +
> +# Now replace the value of the foobar xattr with a significantly larger value.
> +$SETFATTR_PROG -n user.foobar -v abcdefghijklmnopqrstuvwxyz $SCRATCH_MNT/testfile
> +
> +# Check the xattrs have the expected values.
> +echo "xattrs after:"
> +_getfattr --absolute-names --dump $SCRATCH_MNT/testfile | _filter_scratch
> +
> +# success, all done
> +_exit 0
> diff --git a/tests/generic/806.out b/tests/generic/806.out
> new file mode 100644
> index 00000000..620a953e
> --- /dev/null
> +++ b/tests/generic/806.out
> @@ -0,0 +1,11 @@
> +QA output created by 806
> +xattrs before:
> +# file: SCRATCH_MNT/testfile
> +user.WvG1c1Td="qwerty"
> +user.foobar="123"
> +
> +xattrs after:
> +# file: SCRATCH_MNT/testfile
> +user.WvG1c1Td="qwerty"
> +user.foobar="abcdefghijklmnopqrstuvwxyz"
> +

