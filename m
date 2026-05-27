Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A893B52E6
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 06:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779864647; cv=none; b=AzNxOmQckSP62B2ExMyfH8keR/fgBpTqKzRubigOeJmW7CKkBr9EdYvrmOorvCVOsFGqK5+pFVYyWbZhpQ/F/gZID59Zl4ZKe3OioEp3fRlv30wOhYILb4b22w5NWpafR/jqtWYLSDxYChG082O4Ae2LqUbslfKA5tdRMXMwXKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779864647; c=relaxed/simple;
	bh=r7RMPoJcQHFM2jT3QnAqvPOJiyJhxETdTrSQ4z4Et2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h6X9kPJ4qvGkMKfDarGd/16Am0FxaGMGK5MpK0tV6CYBDCYWUej16apXhbz5+ysZGmKIxSw4hQWQ1avC/2b08+GnvEWAuGWxfdW2aGkckQwlMaSq5arGQ0e2iOMyUySl/4cFLiCw88JUW9bO5ZXPQUzTmSQlMyeA5m/Y8E6nwlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=W0FWJ1GT; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="W0FWJ1GT"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48fde648a71so74418645e9.0
        for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2026 23:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779864644; x=1780469444; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=so8aI5rea0SRysEX+wOuGqtd/uEo1+3RaKwKMIeaGa8=;
        b=W0FWJ1GTVOuLe7srBrfrP/NoOSjYt++2jWmIwRlYJZoxdQ9FGjj+ma0lt83R9QSKB8
         AmxRTu8n1G6x0kiofapKwiZeYFf7fnyYLgfHi7hJDttg2fipi2mF5t088ZL09Lujpjhc
         o8BXtjcSVA9SXD681r83P8SIP8Y196BpGUX9iXS6v9htaB5s0CeKH0MPVLbMVQuVT+hS
         vp++IHnxz6nKLKgY8llCeMqu3kxxQU52Ix5H/PgijUzkVRVDET0JVYRXuXsRAUCp55zz
         q66RaABMPBZmPUvH0od1ahGSm5iVRUF69PK8/+oh37IfHP8lNF9d7l3ugV24gLEgFs59
         DhUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779864644; x=1780469444;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=so8aI5rea0SRysEX+wOuGqtd/uEo1+3RaKwKMIeaGa8=;
        b=scnpaB1Wq8UuwGLxCTDjfzg4imSyt6qJDwhqwmwtx/uJq9usLFNCwe+94BQm1SG3Gn
         9ssfF/B2o37XDowR+n/Tnxi0zStX4/WW/z5wC5wdzWuhGNyg9fedp4mM3ctJPZdgN8Mf
         DrXy8xAnrQK5dqaV4wEpZqfI0I2uBfPDpJl9V3cV/oWZz7diW+iucFfaqmhKaK8+ARDt
         6PjRUj9hog6OO5UDRdIeSz94pKfR8b/Q2dcu4pcQ2+GXcIz/n4ZUCUOA/7Gi+MJ+p41l
         Oaryh6K/Fb+5mw3gN+e9up2GbFD9cIoFOTZAJYoLQAlGGFZ5+Jq6P7TojZ4zhWzydW5X
         Q8kA==
X-Forwarded-Encrypted: i=1; AFNElJ/n6deZ3IeRnAEbmCSLqUoQWDk+F/DkkqmN6WrLUc0o/YCoEQkCuRdXfkXnEaE432tAF+/hMd8uaFP5/w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwgtmFEAtWF8zah6yPiwEvvX9kyDqCwZHeuHQ+5DHWyNK8B4TjE
	/PCZ+4IqhdBp/OfKjJzNpTevKrfzLQuLNHYetDM7h5xJSOa3MCu8YM5mAKleXI64Q5sEUAsTteH
	Yr+1b
X-Gm-Gg: Acq92OHhWJrUkdUSig9T1MCokEk5CcH5WkLVTGp6qGJba+VUH3APnKOlem2Rfd5PQpz
	ZcEaH0oRH8trh9DEYKMJibzLTnNepoRqu/p/ruZxM7/bwmFHMorYNHTJezXgLU9xvahpGGTIwpi
	6MhVgAtsiRNFr3rYrqTwGBCRqDtUeE9k8mPs9/uoy23Pc5o13y2cZn3ij9inFdwBkxNbKnbZnkn
	7rG1jmZtT+5Ay5xrct8nxGO653bcUciU8U7ON2xlOBOYMQQREZFZ2yCpFYH2Tl/h69gIJ9uDNag
	jdUSA4oup1kcdV+LCQ7f2WNRBsjQP8D+aM/FHAPmSLna2MoYquY9N8nyTXlvZG2XXynfMx0Bp/l
	HmN1k4DcZ1qgdzSxhyOhDdFjg6TBwI6WdmVHcBJ0sbFKXq08/Ne1SjwHiE3JL1BEZ8tLIVoensw
	TFc/Wd++iFabVmJVfEAnxl7WrFp+ml12J/Y/PkNIFuCirR+qL7Gyx03/0blc2qIsuUaY+kKeVeP
	NsyBkr+9/nqVUp9rleSOtNc8RDo8LuGFrDKcD6p+m/Q4rjJtn+3QeyPHA==
X-Received: by 2002:a05:600d:6443:20b0:490:548f:6ca0 with SMTP id 5b1f17b1804b1-490548f6dc2mr176156765e9.8.1779864643897;
        Tue, 26 May 2026 23:50:43 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841d6ebb97bsm1271001b3a.23.2026.05.26.23.50.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2026 23:50:43 -0700 (PDT)
Message-ID: <e9fc0374-4a97-4cab-8f9d-9de39587cbec@suse.com>
Date: Wed, 27 May 2026 16:20:38 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fstests: generic/362: remove the old file to reflect new
 mount options
To: Christoph Hellwig <hch@infradead.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20260526070055.60193-1-wqu@suse.com>
 <ahaQjYYQWcuOaRaq@infradead.org>
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
In-Reply-To: <ahaQjYYQWcuOaRaq@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/27 16:04, Christoph Hellwig 写道:
> On Tue, May 26, 2026 at 04:30:55PM +0930, Qu Wenruo wrote:
>>        Silence is golden
>>       ...
>>       (Run 'diff -u /home/adam/xfstests/tests/generic/362.out /home/adam/xfstests/results//generic/362.out.bad'  to see the entire diff)
>>
>> But if one has formated TEST_DEV, run test with default mount option,
>> then change the mount option to "nodatasum", the test will not fail
>> anymore:
> 
>> [FIX]
>> Always delete the target file "$TEST_DIR/dio-append-buf-fault" before
>> running dio-append-buf-fault command.
>>
>> So that the new target file is always newly created and will follow
>> btrfs' new mount option and expose the failure for nodatasum.
> 
> I'd rather add a copy of the test that runs on the scratch device
> that can control the environment.  Or maybe just change the test
> to use the scratch device?

I'm completely happy with using scratch device instead of test dev.

If no special reason to use test dev, the next update will go scratch 
dev instead.

Thanks,
Qu
