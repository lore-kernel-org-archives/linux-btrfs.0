Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AC738D3E3
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 21:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779486485; cv=none; b=X2Oo63y/X6gsdzmiDLYp3eH5HUICb0zi84kpk+vgrFtGmZdj17ZmgLh4PKYS1jmODp5tDKIvk/QoyL9wnvIqb6sMEY2BQ5ANFLpS2BxNaC2iydB/yvmk+zyn4M3/LTOeg2wRb9ZkI5uXhTreM6eedkm4hhbc0AD/orOqWlcB6VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779486485; c=relaxed/simple;
	bh=j4e1p6EW3ieHNeDEj0545nU20stzeJN6/J++zaSRnmc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rUlagqOicu0ZmbpBtdgcqiSA9cI3bI1vQDUbeYB1mYQPUIiSUkDgYDWSVwDfFpabROxt48phVMD312UaI3GZ3cNxdIa5oWiCYkUHv5xjA05JbIZLTSvpQoEa2mTjzVDfoZ+0Oq6Ewwy5u+/FYPB56RLmVhEpmahiTLIiRaan4Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GP4S+7iU; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GP4S+7iU"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4903fd19957so17931765e9.1
        for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 14:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779486482; x=1780091282; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=szr/CLVkkNMKKwOBolAev+fjb2ss7Af0XPY0TfOQjy0=;
        b=GP4S+7iUYV3pEiUAOiX9wdscnqrU2gcpYq6GiWNj9U5hMLRjClJe/PPHJySNReOFNt
         wxJkrJDwDn2oeUnFbdfghCfsLqJ5di8BXcUlSO6UAee++z22bDrVHrj9M5fbbVjTdVmR
         tkfhDU5mU0QSqk9RGEkoL5iLqP/VXbeeKOobnzzFa+/2/andcUd2vHn/shf3FO7k3nTM
         4DCMLTEKqvXNuffCOlWnn+fvCK35+OC2Fi4XOkyz2V1qa4W93L1lHaW9m6I+dHLnuxOL
         1ogP8L++jctqXKU8J1+PrTOjKy2r6bXfGIR30wL/wttOJz35WiJrF3IfuiTY8SdZdIHU
         fyQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779486482; x=1780091282;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=szr/CLVkkNMKKwOBolAev+fjb2ss7Af0XPY0TfOQjy0=;
        b=oMYCtrh2xSeAyTehdcCpKRqcX8e2b0lxmNdkTo7tthN9MKdRCwwkBKxAkyQH5LaQoa
         PFCDpRgRxKAqDEgkF68jb3pS1lbr1MGEWko70Zx3h4z6XptlPcv5IBYYTROAUAjP4bKO
         qyCR5ML1JE8joQ6vbbBK+ktHfvXwPW4637CIlzfLd53VRMpHXAdsIqsLk911yJvJBpVr
         7+kX0QZGFAbaGshtPnuV7OgQyPk7CSmV9OG11Bl6t47sH6nK8bghIrJOJ+ujDmvDi+Lw
         ILMAGD793da6FCum9M5lS4RJdl4lUCSvNaIhKwZI2b2mSvyaK9SMVzL1oOPsHXK+DBxM
         6QUA==
X-Forwarded-Encrypted: i=1; AFNElJ9LPTCMuU9MarrnL6mXpQPsIH3e57xFVe0c/PoGNWP9WIpciTj21lfkRvQse2Fw89cwmiY+/FlSoNuaPA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzVMU/izojbx+XptFC/CARsylLPmPHQy3E216usYNJNaaJ7EVd7
	pgQYIDTgNN00a1pqUV09jj+qRFThOIfbgL3W621kFtMdgvxYVKogBLIJqMYSWbHoBe4=
X-Gm-Gg: Acq92OFm7C2fgBq/cp51vH7AOcbDYqVcmv+3Zg3U/emfGTc2LzjxD4ooFyZm8K3rh4O
	8CvIGbUgXmHJURnw8GsX+oGV+RJJlVOe6auzUgn58uXrS8tLZMstgaBSKR1CmCvcXZH6osMxf5+
	/Q7Vc0Qyt2o86C7W5Gtq5pZBnK3n4WIjjYocz0+yHkSos4kxTBiinrSL956ptQnlp9k37Fwu06F
	vMZIk4fIt3LSDb6fZ8+CNsQoyG1U3ODdtZwwwRtTPByxhiFJM6nwttthavQmQ6e0I8gYzLe/pAX
	0nDq2Ke1Zgia3jQ65XYqcz4kiRIj+1gZyuKNu4ITYYWdGZOwsOjVzDr1vg1jAHLqRA1oRgK9t9p
	SsQsOl4RTj4Coj0tQ130+3PGMlabmNFFpk7XJbdq7L45/Vo9lIQThCbgvxnD8HRcnuSQ5chdsQu
	UUIPRxcWpF2I9UYvO7UtuKPSBMOhpf5xlyd5DNyk+VlFPyNJDu6vIvL0je446VqPZYMgfi6KdhK
	Han3JrdJOqk6FaBSj+iUgRiJ6R6IiaNqIwefL4PHuX6syw=
X-Received: by 2002:a05:600c:4fc9:b0:487:21c7:2885 with SMTP id 5b1f17b1804b1-49042482992mr76774305e9.5.1779486482307;
        Fri, 22 May 2026 14:48:02 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb5924211sm23646545ad.84.2026.05.22.14.47.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 14:48:01 -0700 (PDT)
Message-ID: <40359613-ee44-4799-af71-8fc515391dc9@suse.com>
Date: Sat, 23 May 2026 07:17:55 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] Three folio-related btrfs fixes
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
 Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@suse.com>,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
References: <20260522181411.2487732-1-willy@infradead.org>
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
In-Reply-To: <20260522181411.2487732-1-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/23 03:44, Matthew Wilcox (Oracle) 写道:
> All of these were discovered through auditing the (mis)uses of the folio
> API throughout the kernel; I haven't been specifically reviewing btrfs,
> nor testing.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> 
> Matthew Wilcox (Oracle) (3):
>    Revert "btrfs: fix the file offset calculation inside
>      btrfs_decompress_buf2page()"
>    btrfs: Use folio_put()
>    btrfs: Remove use of bv_page
> 
>   fs/btrfs/compression.c | 18 +-----------------
>   fs/btrfs/extent_io.c   |  6 +++---
>   fs/btrfs/inode.c       |  2 +-
>   3 files changed, 5 insertions(+), 21 deletions(-)
> 

