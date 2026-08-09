Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A871D4B0486
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 01:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786237256; cv=none; b=Bgp5qFjgPKIQkGNBY+aC92P8boGyOFdq8vYGEF7xrZhdrCm/Xnr5//N7XD3FGjNHfbW7nlS5UrgBOZ/1aUtkO24YeijmzUhi9vEwv04unmyQD5pq62No0MyF7gkI13XS2PpbQk2s7H5XpHUJfwfinLgoaXeq4+qUb9lYucrFLQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786237256; c=relaxed/simple;
	bh=4yFl/3imhiVRBvV+0niHXsSBim6ysjP3O791or9YWaU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i1Eqwg5/uU+nnij08SGYiMPUuNhQI2UUN7/swx0HrNHZwnWuk4m8qqXZfBL0605lvOrScBP7Hi+TsbSBzH/17rQ31QQ+901yEOBQwhKTIvvZBZInH4FCm+OS12RlYBtuSOzaQ+AZltbbaPhdkzhdQcd9ROuPiV1fl+q4FOteIlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=glEMDKEq; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="glEMDKEq"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4954afac04bso7559825e9.0
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Aug 2026 18:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786237253; x=1786842053; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nxo3OUxistENXYCbGvkaqkUJKJxmCqZDie9s9W2QX8I=;
        b=glEMDKEq1iyK0rsamggByTcMOWw5a8PsOZumASw9yftwr6IL8sIDlVPUZuVTYP+woQ
         Rli6sXanKT7OS+BYy5VxahfELESDnVGQ49d7/0lO7D5/hgZJdM1y4OgeZu7ajzqUjNpL
         vK9h6sIEYhrqrkwr4Yoa7irlcD8a5NeDt3Sl/dXrsLVaQNorc89wqMiXgR6rlE3sbxbg
         OQBqDDu+VmM3qE+0n580VqWRMv1v7fqovPGakt9GO1stbQvMQNUI7YmxefGZ1QuMhj7M
         I3aLwmaZBYggXxyRGGk1KlQhxcZry7ULg6v5bFxwTEXIMXgoEoKi2e6RBxpI8fB4pzu8
         gUwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786237253; x=1786842053;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nxo3OUxistENXYCbGvkaqkUJKJxmCqZDie9s9W2QX8I=;
        b=XSMYiWS44L8Au31VWznOulR4sQMzNJTS/7YujO7vFISMZ6AMjyt1s090e3hBhh0DVd
         3rq6W/q8GFi6/vS3+tE3pIrEZRcXdqu4KH4mjhlcifLK8JKidej+HHXZu+QT34Ra00V3
         pBx7nGMAUFMueRkOwbPjw5CT+TDYVI0cR3FUFlfegqyHf5YDFuHiqtK5f9Fgyl1Ug2t1
         XUnsZKxZlS4Vh3Kfk/BOlK3Lf1qwi5cipnxoqt7Xao0IHVnw38P4IL1VyJ3zzwvRZ+nE
         1rkQBSSlespw4GtUpixwuQNzopkJ99nKvV33iMxTkacFj/tvRf5BYwa7SfstIza3ZvtW
         HpQw==
X-Gm-Message-State: AOJu0Ywu3UY0PgdCdm0zqmdUNRvvU+pMJGx+/LMbM9jLH3z8vxpO7sTD
	ekog5lPAdVndWmDp3ufqN2nC/4ttGHWaxC0d4Y2t6zEz/0Q+3HA8UGXeJujhUxdaWS0=
X-Gm-Gg: AR+sD12Jtn8lLoC6aUQaGMnVyEfc1RQoCzFb8W2zFDdDzwR7Oo4B7CR0taKANZbIKTe
	oR57LowwlPCb+HZSBg0+DGgzEWBqWnPcdcI+Td91BGnnSSbTqJUwJAfzqlKtHzpIyBFStsl8Ge2
	E3MUgQ+dOMVk6n0VJk1+Cych8hFgZ0+C9Um+KZKf4ou7t6rhqPzgxBTKYoPHlJ6AtTyhwby8dTW
	iU+uTYg5dThMhHZ4uiRmYpdODrojkGm7Kjd+ceUXuFuONvPx5BGRG4df+2yr/FCfKXsYp3ojvwA
	D9mj5nvC4vkkDjTtD/UFq5YRXAbNs/AwJVaIe2LJ1qfv/TrxLLXJAJCuYNpiTZOcUlLPByK0xny
	vKglSY+Hlox+sPdUf1HAQvK8AJYyEfrNmhjsoc6iAi9CCcLNj7C0IoodN2C6rumXvPWvnlr0pYm
	nRFIfRHkHEQ9efsExKdW+9afi46vwYZL7vfFsjHTTL7NrWd72iX0YCoDGpLff4on4X
X-Received: by 2002:a05:600c:c490:b0:495:4572:21af with SMTP id 5b1f17b1804b1-49961992aecmr118970835e9.9.1786237252784;
        Sat, 08 Aug 2026 18:00:52 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14101a5dcbbsm19069893c88.10.2026.08.08.18.00.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2026 18:00:51 -0700 (PDT)
Message-ID: <c5070299-46ba-460d-9ff7-0b2e4878079b@suse.com>
Date: Sun, 9 Aug 2026 10:30:45 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] btrfs: add per-inode compression levels in xattrs
To: koraynilay <koray.fra@gmail.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
 clm@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
References: <20260808023459.1494928-1-koray.fra@gmail.com>
 <52e06b50-b888-48f0-a574-91e1192eda73@gmx.com>
 <DKJZQAFIRW7H.3KE8DKWO5E3TV@gmail.com>
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
In-Reply-To: <DKJZQAFIRW7H.3KE8DKWO5E3TV@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/9 10:05, koraynilay 写道:
> On Sun Aug 9, 2026 at 2:17 AM CEST, Qu Wenruo wrote:
>> I'm not sure if this is the correct behavior in the first place.
>>
>> As you already mentioned, zstd and zlib have very different compression
>> level range, using the incorrect level makes no sense (and it's being
>> clamped anyway).
>>
>> I think we should go the default level when not specified, which makes
>> more sense, and that would definitely be something worth fixing.
> 
> Yes, I also think that would be best, but my main concern would be it
> changing how chattr +c behaves (I'm less concerned about the btrfs prop
> set file compression "zstd" case, since IMO that implies the user wants
> the default level).

Mind to explain more about the "chattr +c" problem?

IIRC "chattr +c" just set the btrfs.compression XATTR to the default 
zlib if no mount option is specified.

In that case it should be no difference compared to any existing XATTR 
based compression setting.

Thus it's just the same missing level handling, and IMHO since XATTR 
compression level is never specified in XATTR, then the behavior is 
never fully determined, and users should not depend on it.

Even if we changed the behavior to option 3, it should not be a super 
huge user affecting change.
In the end, it's just compression level, affecting compression ratio and 
speed, not really a huge behavior change.

> 
> The options I considered were:
> 1) keep the "bug", like I did for now;
> 2) keep the "bug", but only if the compress= algo is the same
>     as the btrfs.compression one, if they aren't, use the default for the
>     btrfs.compression algo (e.g. compress=zstd:15 and btrfs.compression=zlib
>     would compress the extent at zlib:3 instead of clamp(zlib, 15) = 9)
>     (suggested by Zygo);
> 3) fix the "bug" entirely, which is what I actually accidentally did at
>     first, by just setting compress_level = inode->prop_compress_level
>     without any check prior to that (which means that by default it would
>     use algo:0).

IHMO both option 2 and 3 are acceptable.


The only extra concern is, if we have a new level field in XATTR, can 
older kernels handle it?

And thankfully the existing prop apply handler is checking only the 
first several bytes for different algos, thus the existing code should 
handle the extra appended ":<level>" correctly by just ignoring the level.

So either option 2 or 3 would be fine to me. Although I personally 
prefer option 3 a little more, just because it's much cleaner code wise.

Thanks,
Qu

> 
> Option 2) is probably the best compromise between breaking existing
> scripts and the behaviour making sense, plus it shouldn't change the
> chattr +c behaviour, since btrfs takes the algorithm from compress=.
> 
> Thanks.
> 
> Best,
> koraynilay

