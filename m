Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF295391837
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2026 07:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783928851; cv=none; b=A1y19fm4LIyDw9JwkqJ2te2m2aM2t9+VmatqOXkv/IrTwy1a5ndmcJ3/POvaeSQ7oeHbBA7LQfbdUilYFa5ljKCHL24A8CB0/80fpcB2m98XuAo8AjaYW3fOQmFiog/zw+8Cy2nc+ZuMoefSvKNEmt6Ak273i3cVHH1ESZaOaSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783928851; c=relaxed/simple;
	bh=vsSen++Rs/RTMUZD6GCbt+Zfr8BTaoJOjaTgtkhTY2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=T6+1rOcHhhj1qV85CU/9SYGP6Bt2gAuUl6ltETJFXV3FZnhTwNRHbnB65Da1qRnhGq1HeWBvc4c7KAd4Kh1u2KVd2VGklVpnRceS9LCUBTB25VHV+iniqSFYcgIV6xH1kpvWgyvu4Dr+ycxhu9ewIfVcasQZ/dGcWKPMkB/TtL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AEuCOYc3; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AEuCOYc3"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-698aa7ba3e6so4967899a12.1
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2026 00:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783928848; x=1784533648; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1dIbHwd+iu108HoqEFBRS0kR/OFma205+3o8d7pRAFI=;
        b=AEuCOYc3VJcuSl6K+ftmEG34NCeNrHx6J87WIAl+94XHVVaEb9TSdQA2Sl9sdMF73T
         v+XdqpGzMb38kwHuuZrm8ob0K40XNfsvBpS2QSC6BI2BsTzRmAftLKiQEv8/gYwNw8JC
         D5la3LI6uIyNY1Q4qtS77yI2TqhhCjFqe5Y5Q/wukZFQVYvCcUKqVsjuFyBQy0PBvITD
         mvZ3N4bRU3pLL2lkfTqrAxaUiTxeTmEBlkaWdOq8swtK771kqvvzcRZ5yXbO7V81x9iV
         6erl7/Al/YUd3dw/D6ulH98fBTF756TFogPFC30Or5VvieSjtk4+Lx0tRNEsMifIdot9
         mdyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783928848; x=1784533648;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1dIbHwd+iu108HoqEFBRS0kR/OFma205+3o8d7pRAFI=;
        b=UJYs+uqMltLCt5hwKG0Wj0SZw/Z3F/TgrzCyRquJ64LcLhjNLwmU5GM1nogIfj2bgp
         Ul53TNhNizyQv9Mg4rVWdUbQMkhX+j9qaAdz7BqOeshPhKH6ovEy8WXkpkt1UudbSLiK
         GYyzkR/a2oo6Aq44PodLxqlfnD2ENCxVnlDNrGBVxJ9SH/h86/XbwwzqPcCJhLosCHR/
         Flfa9pqWQP5100iVdkPMqvXHRUYIaSu1tZtTRhyX4vHCaQWDQA2pKrAQU3aOgfv3S5DQ
         xzQiJNr4xPvN6DS2wWwHwmm3t9+dxzEHc5SV5AYMNTSTfxITcwIKRLZL5+yfON5G12DH
         /kJg==
X-Forwarded-Encrypted: i=1; AHgh+RrDjZW/PpmeDpgiebE5HrDBGB4TmQXEJDH8cpQYQPyXFvWPnr0zkxjbIZH/v6EphlEzz/M5vmRak7Zb8Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzUwL4FJFn5Mk89oNLEQJvAQtRNUdbaK7fpvd+ai5sFiKwZmxZ2
	+9IDkYxrYtkBmSg3xMlrs+H3gxXtnW61lJkeL2459Eex0evTPnpc0tXiPAflu0z5aJWVVJlfb+V
	HVhj50TnBbA==
X-Gm-Gg: AfdE7cn4KISJEm+RCyRa4vEUTdyMiXXjYqCrR0pv8UBLRXXF14G94Qkl7dmu+bOhqC0
	Oz6zD5pLmMdVlka+KtJt0nfaDeELgU8BXn01xuzubKCaqeq06QoIXqx5n/mxMq2BHET0l/PdB9v
	13wU2G4V1vGyNCUYOjMbNh5NT6Zf/c6lbMg6ZT8YBeae+CDHSNvMOQZ/AKC1JudNoRP5EkiFsKF
	iqRtLNzDr9iRK9i11YOP2TNLTrEgv42BLBR4W6BCi4+WyJw+tpu+dukxPRoi2NBWweqJWoYTeZq
	MYsaYpGuiIIpzMJJEhEsgTmOUoUEk0Hq9AYHANo1yrHYCkPcnjEy4UiMnac5lOQk15xSm4xxRjT
	aU2fpqP2BxtLCW3vRevhRTy6aS7KNFcXKlO4ihZz3t9MeR/w2IShGLErR1T/QrfY3SU2VTVVy6N
	deBRgziw==
X-Received: by 2002:a17:907:25ce:b0:c12:7f25:cc59 with SMTP id a640c23a62f3a-c161e9788demr358147166b.16.1783928848103;
        Mon, 13 Jul 2026 00:47:28 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6d7a98asm13590506b3a.42.2026.07.13.00.47.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2026 00:47:27 -0700 (PDT)
Message-ID: <bafd591d-fe12-4edf-8835-08a9f43eef74@suse.com>
Date: Mon, 13 Jul 2026 17:17:23 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: test checksum handling for clone, dedupe and swap
 on NOCOW files
To: Daan De Meyer <daan@amutable.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20260712-push-kwzqkrlxwvnv-v1-1-e2466aff1bfd@amutable.com>
 <95fb922f-996d-4f3b-90fe-ab0b8db1388b@suse.com>
 <CAPa8sAjLdkMZDxi=a8qsn4=xNgMJKGGEt2RUeVnP-pLyH4-Wwg@mail.gmail.com>
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
In-Reply-To: <CAPa8sAjLdkMZDxi=a8qsn4=xNgMJKGGEt2RUeVnP-pLyH4-Wwg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/13 16:42, Daan De Meyer 写道:
>  > I strongly doubt if you have run the test btrfs/348.
> 
> I did actually run the test, I just forgot to open the upstream PR for 
> btrfs-progs with the necessary changes. Will push that PR to btrfs-progs 
> now.

No, considering there is no compat/incompat bit to indicate this change, 
your progs update will prevent it from detecting real missing or 
unexpected csums problems on older kernels.

As I replied in another thread to Neal, the if you want to implement 
this feature, it is not a simple 
just-allow-reflink-from-datasum-to-nodatasum change.

You have to change the current per-inode csum flags into a per-extent 
csum flags.
Or please tell me how to distinguish missing/unexpected csums?


Furthermore, considering how bad you completely ignored all previous 
notification on the regression caused by 32bit compatible ioctl, and you 
have no consideration of any compatibility on older kernels, I am not a 
fan of this feature at all.
> 
> Daan
> 
> On Mon, Jul 13, 2026 at 12:01 AM Qu Wenruo <wqu@suse.com 
> <mailto:wqu@suse.com>> wrote:
> 
> 
> 
>     在 2026/7/13 00:07, Daan De Meyer via B4 Relay 写道:
>      > From: Daan De Meyer <daan@amutable.com <mailto:daan@amutable.com>>
>      >
>      > Add two tests covering how checksummed and NOCOW extents interact.
>      >
>      > btrfs/348 verifies that checksummed extents can be cloned and
>      > deduplicated into NOCOW files, and that the reverse direction stays
>      > rejected because NOCOW extents do not have checksums.
> 
>     I strongly doubt if you have run the test btrfs/348.
> 
>     As a very basic reflink clone from a datasum inode into nodatasum inode
>     will cause btrfs check errors, with your kernel patch applied:
> 
>        # mkfs.btrfs -f $dev
>        # mount $dev $mnt
>        # xfs_io -f -c "pwrite 0 64k" -c sync $mnt/file1
>        # mount -o remount,nodatasum $mnt
>        # touch $mnt/file2
>        # xfs_io -c "reflink $mnt/file1" $mnt/file2
>        # umount $mnt
>        # btrfs check $dev
>     Opening filesystem to check...
>     Checking filesystem on /dev/test/scratch1
>     UUID: efcb3cdd-5dd9-416d-89ac-33071c59c9e7
>     [1/8] checking log skipped (none written)
>     [2/8] checking root items
>     [3/8] checking extents
>     [4/8] checking free space tree
>     [5/8] checking fs roots
>     root 5 inode 258 errors 800, odd csum item
>     ERROR: errors found in fs roots
>     found 229376 bytes used, error(s) found
> 
>      >
>      > btrfs/349 verifies that a NOCOW swap file containing a checksummed
>      > extent is rejected even after the checksummed source is deleted
>     and the
>      > extent is no longer shared.
>      >
>      > Signed-off-by: Daan De Meyer <daan@amutable.com
>     <mailto:daan@amutable.com>>
>      > ---
>      > These tests cover the kernel series available at:
>      > https://lore.kernel.org/linux-btrfs/20260712-reflink-into-
>     nodatasum-v1-0-9f27ef836073@amutable.com/ <https://lore.kernel.org/
>     linux-btrfs/20260712-reflink-into-nodatasum-
>     v1-0-9f27ef836073@amutable.com/>
>      > ---
>      >   tests/btrfs/348     | 180 +++++++++++++++++++++++++++++++++++++
>     +++++++++++++++
>      >   tests/btrfs/348.out |   2 +
>      >   tests/btrfs/349     |  73 +++++++++++++++++++++
>      >   tests/btrfs/349.out |   2 +
>      >   4 files changed, 257 insertions(+)
>      >
>      > diff --git a/tests/btrfs/348 b/tests/btrfs/348
>      > new file mode 100755
>      > index 00000000..4faf994e
>      > --- /dev/null
>      > +++ b/tests/btrfs/348
>      > @@ -0,0 +1,180 @@
>      > +#! /bin/bash
>      > +# SPDX-License-Identifier: GPL-2.0
>      > +# Copyright (c) 2026 Daan De Meyer. All Rights Reserved.
>      > +#
>      > +# FS QA Test 348
>      > +#
>      > +# Verify that checksummed extents can be cloned and deduplicated
>     into NOCOW
>      > +# files.  The reverse direction must remain rejected because
>     NOCOW extents do
>      > +# not have checksums.
>      > +#
>      > +. ./common/preamble
>      > +_begin_fstest auto quick clone dedupe scrub
>      > +
>      > +. ./common/reflink
>      > +
>      > +_require_scratch_reflink
>      > +_require_scratch_dedupe
>      > +_require_chattr C
>      > +_require_btrfs_no_nodatacow
>      > +_require_btrfs_no_nodatasum
>      > +_require_btrfs_command inspect-internal dump-tree
>      > +
>      > +_fixed_by_kernel_commit 28ce1d263f4d \
>      > +     "btrfs: allow reflinking from checksummed files into
>     nodatasum files"
> 
>     Nope, this is not a fix, nor the commit is upstreamed.
> 
>     A proper test case should detect older kernels and skip if it doesn't
>     support a new feature.
> 

