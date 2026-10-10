Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1562D322E
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 08:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791620013; cv=none; b=UEno22o9jhZhybtROsB0Snm/0N4egcJzqvyioUIFVHBDoU9/tDhjrvpyGv5LVdZfea14PoGdS+gLEqW60hcntq8Zyzw/D+qYOQ8zeGdLXu3hL+1m/p/c0SfDsa9Fk3LulEQqN72tzFv6sRZYnokgpsNgVWnCr+AfP1NLOIHz86E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791620013; c=relaxed/simple;
	bh=7rTIIgKaddi4hDM6fJnPwE8ZbnQao3d1oom38sjqL/Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nlTvhaFBkVeA3CbLerueCYLjwPFWvJjDS9AKhyIqOvW2MIxP3JI8Jze0t9u5FeOspmBZqHXFSAh/5yb1589OLhudJsEp70ovT4R4Vgs1FlBdBM5QgyWUxDqSPCfAssvasd+gSqKqQQCLjrGxUP0LhRHp6N4vBp7pOPBxR/Eb0SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dKh+FayB; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dKh+FayB"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a02667ccebso3223695e9.0
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 01:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791620010; x=1792224810; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YMRSDuE4mes3IXuNa4LOHgfmDiOgpCBCgNtD7mtyjl4=;
        b=dKh+FayBz36cmP6L1XRSxt61rWx5pAktFzBZMeMCf09FouyKZPRozNBXziu5merATD
         b7UyYUw3rt0WRV/xhrmCzISM8aAYXIqfHA8hWdzjh//9BR7FFq1X/55BfYGU38zh6Neq
         eCeYzImisRIg1XUB1Zmxpk4zT4wQx+eveCgraY4L95TH3wxqOSH8M1jnL9sAbBlUldF8
         dYzlF6yqeDn2uJKgr9HH368rG1QRmVI2TsHFs32QJ4PlAzfV2Bg+pHrH+z5yvzSZfWR4
         gSdlsODcogUFb1/WRKIsFaHLV0AQbg1r1KyYFd5smwPibbtsJcK9u9lLaNzY91rW/7Kc
         tbqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791620010; x=1792224810;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YMRSDuE4mes3IXuNa4LOHgfmDiOgpCBCgNtD7mtyjl4=;
        b=Xe+v0xz4rl7JYszF5BW4EpD7ipjA0pnIPU/Ww0nVZyTF8GG4qofrfkCh1RWGd5Kv4/
         ugrDp6IDBB5HHLdBikGH9o6pZzhD4l1QD+XcEmxZlpEerFgmRwZSb0kXdZjwSkcNiqPp
         7kJM7LykkwY1C43aEl8ewliWO65+LOYUKUCoTkFOEYryUcjHZna9b5bVdSInCJgu9/D+
         2PwdbxSDelr+EeqClvkE2Y9jJJxG1amFsMYOu4JI5kliGWbXfIfCQzngvwqd8PxZ//At
         sLklbuybiNer4y6fHKKxm1ynoGnW7A84VlK+RjL2soxwPXewPr3QwPDcE4i8L7hsYv93
         toGw==
X-Gm-Message-State: AFq9FYK1wTJ/kLU4Dy+u5mFiqu3VkyFthg/M9edk+vCXLVKEaj0ZCWo7
	C4A40Ybw/SSFIBBQvf3hMv7HvrUGI7gHA2uAjSEBdRVgicmd5mzlFWI7VtoD/66+L2A=
X-Gm-Gg: AYBFou3YD7003pakIWoDMc8vSmMI3LGqD/N5njji1c9Tfd1RpdXiCtr9sS5mwAfvNri
	El8Z0GoVUR+RD0LFdGLYGoMFT24Mmp68TjWGUBFl7UeseNH1fgm9Ar+1Dk7mm2poUkinPMfqNUW
	RgLV4pHTCv6wuSZsl27BF12W+xk8XKwj7+58LHuHOEECCYrm3wVmw5X92XCjSgyyoncut1aJ/mD
	i/MenMTVT32ja4fbQ+6sIqqhv5RCHiuusxpOwR4pY7C1xrVOTRIe/swQzmY6U1x6Sj0T2gIM2QR
	ZA17qe4znCkvXgdJ3ztTlkH3qIePAKSg4238ZWtq5db+JLTQa2QQsGUUZvaiBgA60oc3RnXagJ1
	qUFP6CDwqOBNigkSLR3fhgKGovrXDoSB8KdpULsM/xmtL/TKndKqSVDXVsKleSg/2tAhAuGegR8
	bAjTHVCqg1YJNZgJ6g31j7rlJM7qjvb/UkgSpHJzaCgZPTM00iLsDaPkwa0hOsj78nYv2LdcRH
X-Received: by 2002:a05:600c:c0c6:b0:4a1:96cd:2f6b with SMTP id 5b1f17b1804b1-4a196cd31fbmr6954665e9.2.1791620010509;
        Sat, 10 Oct 2026 01:13:30 -0700 (PDT)
Received: from [10.86.128.17] ([149.22.87.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38fc9e52sm7137428a91.13.2026.10.10.01.13.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Oct 2026 01:13:29 -0700 (PDT)
Message-ID: <d2fccd43-877c-4797-a221-833d37ff4b8f@suse.com>
Date: Sat, 10 Oct 2026 18:43:25 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fstests: btrfs: add a test case to verify fsverity on
 compressed files
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
References: <20261010032508.36935-1-wqu@suse.com>
 <20261010080203.GB1946@quark>
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
In-Reply-To: <20261010080203.GB1946@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/10 18:32, Eric Biggers 写道:
> On Sat, Oct 10, 2026 at 01:55:08PM +1030, Qu Wenruo wrote:
>> There is a bug report that with the recently enabled large folios
>> support, compressed files on btrfs can give random but reproducible
>> warnings about file corruption.
>>
>> It turns out to be a bug in the verification range, where blocks not
>> included in the read range are passed to be verified.
>>
>> Add a new regression test case for it, the workload is pretty simple:
>>
>> - Create a 64M file with compressed file extents
>> - Enable fsverity digest on that file
>> - Drop page cache
>> - Read that file
>> - Verify there is no "FILE CORRUPTED!" warning
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   tests/btrfs/359     | 45 +++++++++++++++++++++++++++++++++++++++++++++
>>   tests/btrfs/359.out |  6 ++++++
>>   2 files changed, 51 insertions(+)
>>   create mode 100755 tests/btrfs/359
>>   create mode 100644 tests/btrfs/359.out
>>
>> diff --git a/tests/btrfs/359 b/tests/btrfs/359
>> new file mode 100755
>> index 00000000..2047d965
>> --- /dev/null
>> +++ b/tests/btrfs/359
>> @@ -0,0 +1,45 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
>> +#
>> +# FS QA Test 359
>> +#
>> +# Test if btrfs handles fsverity read correctly without corruption warning
>> +#
>> +. ./common/preamble
>> +_begin_fstest auto quick verity compress
>> +
>> +_fixed_by_kernel_commit xxxxxxxxxxxx \
>> +	"btrfs: fix the fsverity callback where unexpected range is verified"
>> +
>> +. ./common/filter
>> +. ./common/verity
>> +
>> +_require_scratch_verity
> 
> Missing _require_check_dmesg?

Right, thanks for pointing out this.
> 
> Also, sourcing common/verity adds nodatasum to the mount options.
> Doesn't that disable compression too?

It can still be override by the extra "-o compress" option at later 
_scratch_mount() call.

In fact after the run, the fs still has compressed extents, e.g:

	item 201 key (257 EXTENT_DATA 66977792) itemoff 5577 itemsize 53
		generation 9 type 1 (regular)
		extent data disk byte 15724544 nr 4096
		extent data offset 0 nr 131072 ram 131072
		extent compression 1 (zlib)
		extent encryption 0

On the hand, I believe it's possible to craft a generic test case that 
doesn't require any btrfs specific mount option.

Using holes can still force btrfs to split the reads and trigger the 
warning.

I'll send out a generic test instead.

Thanks,
Qu





> 
> - Eric

