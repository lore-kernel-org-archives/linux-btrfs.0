Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A2F328616
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 22:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784154241; cv=none; b=bHaiVupnHXqwAPSuFgFpeUjPb9Y606CSbM74xeBL91Bkr/EwBxcf4bNcBQ1yHRiBTQeXntHjdrilISHqxB8gVdLha9dRV+8vGU1V/uwUVByb8leHxCWXlaoLXdPSJg1kOX8ppT45AXDVwkSa4c+X4ClbSeOVWjIaJVgqmoNBAeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784154241; c=relaxed/simple;
	bh=W0JzndEIUW7TYvjEQpwk6CvGB9/mqfBPf0wk0JdavsI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L/MkYOv91BIjHWfOPpnschgy3sEKs/ZWYA+6isApmtnk8dY1qk+SOr+dWMxgoG7UrVH3IW9QRjnQrBUhntbXTtCctHH8dc2YicrUaYcqlvKbhYSbtwF2vBUoATbqb1U+lbd+TPjpptUgmac3yx9lCzrkPKP1wv5CfTZhVZgmDQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BRk2rYUK; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BRk2rYUK"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-493c7902f47so48661295e9.1
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 15:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784154238; x=1784759038; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UCFk58xT5btOtDL6jTbxhoixl4xuY2NmPnwOSlsMN3g=;
        b=BRk2rYUKhLoQsHkDjs0VUV1bmACMEkNtyl4M0jVvWBw1yW0Mp3Hbc279fIkRqltahi
         8UbAA7aDa/HG1tM2IL9gQOEMHyg7+D3790js2/X0YX9/m9Gc11zJlEsXIjPc1UTuyW3C
         u94IHcCBZlSyEu/ocnGrikc/396TpB7gQay7sfHJUao3m08O+jeLOA9kN6pEzSmRsOkf
         p9ln0n+oXrqw25IkNhJyTEebAKbs/ODmB/IAPyRMWo5L32tsCiT1uy+4xQhmM4kTdDka
         BTQWV85wtIJ+N4a38v8eF8mnUmMpDuDUf/kkyYFLOIE0xyy+hGuEVauxlN/X5VhuhyJF
         6q8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784154238; x=1784759038;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UCFk58xT5btOtDL6jTbxhoixl4xuY2NmPnwOSlsMN3g=;
        b=LM+xQTnM8BTR5cU//1Q6t2Cnst/3d582bLmQ4rU1As71BP7dIVfUZH3eE2t20C8+W4
         C8/zgPg/HwbNJbEOByBUI3u+YXs5fUUObmmIDfDMmYhESu6K0FYIM2fiefUKyq896n6J
         cC4TblOfyYvPeizYPeuyzRSttKGqLjfs/RYRu65krUnhhei0HUyRXkuHFmFVibiWxeeu
         IbtuXDxdTy3WF9Lqz3I4XQN9cjpwCxtJjFmqXhTX+pEQNt5udXcenmMYeg8Qzf3/It67
         IW5PTYNrIQHbwjTtm6ICCgJAJ/zMfS9TT5TrXtCAasGiWn54KiXNUW7ah5c/pngM8g8u
         b0fQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpgk0R7KpXIaDbmXdC24EhVWCYDmMaHCrLo/StkEULCIxi/PwVHHXpbNHcuYc1I/KlYStCWiY+cMpT63A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5t/RoukdNBnyhRlVqgyeNFRFJnQZVOMqDVge6TiYdzV3zUewe
	nyE5Su7jElKrZJj4cP+tGyNNawrlxv96yY2WlzLnU1FJchCO8OM4eAoWRomNaOq7zHAUpha0O7g
	0m2WPg6E=
X-Gm-Gg: AfdE7cmQfx7MdsyuoB5oZkCTcJRMLg6O1ttmFlHkyzqZBkozABOoCz8fUK3f+7RO9P4
	SSKImkB7ll6BvM74U/Mu8QUGlbJYoN2gFbocPSjWV2sunjds5TNMv57T+JuekGbd0GkT13SwVP7
	dtjPDkluLA/SEH9+qYng4ynixEukj+/GY5T6Q30jUFAKx5/J9MSOBcvEyH6M7YO+OIIdCmCBIGe
	U/d5cvjzogCNMHgi1CXelB08qNr1INqM608MWZMg8GkETvAYevnDlTVHWfc90vmN7LlQn2aTLf6
	WQsa7l6+djazEwks1UausW02TbmZCAjKy99N3hghnKpf2gdWvSuyq9YC8mdiqGWQMeK389jlPK4
	1UPb2bndiZBjdCSBDeHWxfGqsgkwfi5TFhw6qgwYG+bwo13xuXliA78v/J2gYdRfo9S550BWto2
	6Yz7Xnew==
X-Received: by 2002:a05:600c:2909:b0:493:df44:2342 with SMTP id 5b1f17b1804b1-4953c14efbdmr33610795e9.5.1784154237805;
        Wed, 15 Jul 2026 15:23:57 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e4fcd31sm5154832eec.4.2026.07.15.15.23.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2026 15:23:56 -0700 (PDT)
Message-ID: <2c8c2fb6-7b4a-4360-9216-de8e19fe4a5f@suse.com>
Date: Thu, 16 Jul 2026 07:53:51 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fstests: generic: add a basic cachestat test case
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 Anand Jain <asj@kernel.org>
References: <20260707113454.120001-1-wqu@suse.com> <alfiLTZaQeqG-7J1@bfoster>
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
In-Reply-To: <alfiLTZaQeqG-7J1@bfoster>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/16 05:10, Brian Foster 写道:
> On Tue, Jul 07, 2026 at 09:04:54PM +0930, Qu Wenruo wrote:
>> The test case is inspired by LTP, where there is a regression on 64K
>> page size systems with btrfs, that after a fsync, cachestat() still
>> report dirty pages.
>>
>> The test case itself is pretty simple, fill the file with a buffered write that is
>> 1/2/4/8/16 page sized, call cachestat() to make sure the cached/dirtied
>> number match the page number.
>>
>> Then do a fsync(), and make sure the dirty page number reduced to 0
>> meanwhile cached is still the same.
>>
>> Link: https://bugzilla.suse.com/show_bug.cgi?id=1270397
>> Reviewed-by: Anand Jain <asj@kernel.org>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> Changelog:
>> v2:
>> - Reject "sync" and "dax" mount options
>>    Those mount options write back data synchronously, will screw up the
>>    buffered write dirtied page reporting.
>>
>> - Use AWK_PROG everywhere.
>>
>> - Remove the unnecessary redirection for fsync
>> ---
>>   tests/generic/798     | 61 +++++++++++++++++++++++++++++++++++++++++++
>>   tests/generic/798.out |  2 ++
>>   2 files changed, 63 insertions(+)
>>   create mode 100755 tests/generic/798
>>   create mode 100644 tests/generic/798.out
>>
>> diff --git a/tests/generic/798 b/tests/generic/798
>> new file mode 100755
>> index 00000000..8888f6a3
>> --- /dev/null
>> +++ b/tests/generic/798
>> @@ -0,0 +1,61 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
>> +#
>> +# FS QA Test 798
>> +#
>> +# Basic tests for cachestat()
>> +#
>> +. ./common/preamble
>> +_begin_fstest auto quick
>> +
>> +_require_xfs_io_command "cachestat"
>> +_require_scratch
>> +# Any mount option that writes data back synchronously should be rejected.
>> +# Or it will screw up the dirtied page reporting for buffered writes.
>> +_exclude_scratch_mount_option "dax"
>> +_exclude_scratch_mount_option "sync"
>> +
>> +pagesize=$(_get_page_size)
>> +
>> +for num_page in 1 2 4 8 16; do
>> +	size=$(($pagesize * $num_page))
>> +
>> +	echo "=== Test with $num_page pages ===" >> $seqres.full
>> +	_scratch_mkfs > /dev/null
>> +	_scratch_mount
>> +
> 
> Do we need a mkfs and remount for each size we're testing? It seems like
> we should be able to mkfs and mount once and then just remove the file
> per iteration.
> 
>> +	# Basic cached number reporting
>> +	$XFS_IO_PROG -f -c "pwrite -b $pagesize 0 $size" \
>> +		$SCRATCH_MNT/foobar >> $seqres.full
>> +	$XFS_IO_PROG -c "cachestat 0 $size" $SCRATCH_MNT/foobar > $tmp.output
>> +	cat $tmp.output >> $seqres.full
>> +	cached=$(cat $tmp.output | cut -f1 -d, | $AWK_PROG '{print $2}')
>> +	dirtied=$(cat $tmp.output | cut -f2 -d, | $AWK_PROG '{print $2}')
>> +
>> +	if [ "$cached" -ne "$num_page" ]; then
>> +		_fail "cached not matching the page number"
>> +	fi
>> +
>> +	if [ "$cached" -ne "$dirtied" ]; then
>> +		_fail "dirtied not matching the page number"
>> +	fi
> 
> We should expect consistent values for cached and dirtied throughout the
> test, right? If so, it might be more useful (and maybe more simple) to
> just print the cachestat output on each iteration and let the comparison
> to the golden .out file determine pass or failure. Hm?

Right, will update the test case the address both comments.

Thanks,
Qu

> 
> Brian
> 
>> +	$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foobar
>> +
>> +	# Test dirty page number reporting after a fsync.
>> +	$XFS_IO_PROG -c "cachestat 0 $size" $SCRATCH_MNT/foobar > $tmp.output
>> +	cat $tmp.output >> $seqres.full
>> +	_scratch_unmount
>> +	cached=$(cat $tmp.output | cut -f1 -d, | $AWK_PROG '{print $2}')
>> +	dirtied=$(cat $tmp.output | cut -f2 -d, | $AWK_PROG '{print $2}')
>> +
>> +	if [ "$cached" -ne "$num_page" ]; then
>> +		_fail "cached not matching the page number"
>> +	fi
>> +	if [ "$dirtied" -ne 0 ]; then
>> +		_fail "dirtied pages not zero"
>> +	fi
>> +done
>> +
>> +echo "Silence is golden"
>> +_exit 0
>> diff --git a/tests/generic/798.out b/tests/generic/798.out
>> new file mode 100644
>> index 00000000..216d6e93
>> --- /dev/null
>> +++ b/tests/generic/798.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 798
>> +Silence is golden
>> -- 
>> 2.51.2
>>
>>
> 

