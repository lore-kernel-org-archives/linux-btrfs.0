Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F135F2773E4
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 21:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788472069; cv=none; b=Ouf9fsJjmxoWgpaYm6EBTJiOdglN+60cw1u1lQYOZAG3Rd0NFtNE6FeaZK9DlyDi026VlegwI997KICbfRP+YjZlK8m3hvmjMq876s7Y8LZsUnrA7WmNFncDiEecl+55lgDVVgYbjhlDSI9bgpIupll3u9NTU6F2M+8LiwYiPBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788472069; c=relaxed/simple;
	bh=jzPTFEkjel57LoNSlAiQNFuLtdoC0eRTGMMYrjZSUD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gzAMcp2mM4TqzfL6DHS2t5rz/gdfF5ND0WVZgDmo4pH8CqQvcvS8lZusY2c2DOpzDNOBNbksv644jLFKolO2NIaMM68jCVOUSDvt2enLtAjgrfeo+ASk1tE7aZEMFFUiMwb6qmkPmo8f4MzXSpTOS4u7JjMzwv6WSdp8CVVV1LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=INL6J/O5; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="INL6J/O5"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49cf4f81d86so2645825e9.2
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Sep 2026 14:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788472066; x=1789076866; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=K8wGuThDF9jW+qv0qS//NiLHGtQmeGKjcslg4hpmgGI=;
        b=INL6J/O55KkuhhJL5ELAO+ZbSZvv1eyh7aLEF1ngYGJpTljjyMXAI76Pmmhb0XCjE0
         JHGyatSwjNcttCcXkKbj7vIC7E0e1VDdoHGBMC/aBNNCu7knGDC2NhY3d+rbGWJMRE9B
         AyS9XseaPRr4cZmu+O6B9UphpAfJYGjEZaVRLzlYqwvAxLRqt1Dt1Q9pddfCFrCy7Dj6
         YjguDOFIKmogZOearlSauOLc8EzugPDRnBwoTmX/77wJcvbTHoUCZfHlv/P3LIQCA3bj
         /G0ZGsqs+fWFduGXbB+f3iiZ9v9AUFAmW35XwDp55OxJlxeOSpG9bAS97XBjwZC9DmJ1
         yF+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788472066; x=1789076866;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K8wGuThDF9jW+qv0qS//NiLHGtQmeGKjcslg4hpmgGI=;
        b=ou94iMeSpkoamxPBNVKmikcBHzAfY9E4AuM+drmIA0gqJq9dhpyOZKq2a8NpgyFDz9
         ndgZbHbqt9tzz3IORBWliUR0gJ78nGmyRVhBRONCP7wMZK5Xrrjbq2JkSFNEF4JFMUZv
         tUvNf2H+SHE402Y9NaQzsrLiJoDytAHbt3/SbZ2V1TJc3FSZoWsbdsHFNicZmYqVGFz9
         Zp4dyjjzJ8+0RuRkUUUZ63uOEFGLfLmdWlTaoK0uie2QtMei+lHEZcF6wIs/qk4Xu+fq
         JNL7NQLMKNKwb98nxoJFZdIHRVFC67jcePXgVSADaSR643DKt5pOmPI2G+0Iam4u4eYC
         WMpA==
X-Forwarded-Encrypted: i=1; AKwUvBwVHWWBX/hWcQWw4+iQe68kdOkrXuZIt+JiX5L/sGHbzcBc1Az+mlxfNGIgYMNt0fpJY4TuS3HugEL/Rw==@vger.kernel.org
X-Gm-Message-State: AFuF++no1WcQ8tDD6ALn7du1l9iJpH6U7DGo+pDDOGFbOk6GYANttvvV
	+hcvzge+JT+bKHEdQr5rXg2azPTh3dqjCm+66tqb0mE21D9TrAUSXTHu3nfQfcgjbgsqMHqM+uK
	byZ5e9ww6hQ==
X-Gm-Gg: AYBFou0jMxpyli9GIE55qFmAQU5OGfYf5X1yZ7kB7W3bIMwpFF9iD9mlmfrPqXw+ScA
	JF41fzBXpJmJzFGMpU9nuGWKa1A3Y6hdVjNLd4zYshElWvgkhUWje+eHb2Gpc5luYPa6h4B/C4t
	5vKX6+io4cxldj5FLusveijL/lQ/GvKDQrq7kjVLhcw3YY9gEmO5dvyPz3a5FKhdzcPEZASEfbI
	lJFdticMrPWjFeREnXWEs/mf7FfNTArOE4O8LwSkZMfMFYlBNGW6YXmI6jRm2bQQRmlks1KzSRI
	ksn6XLAED+HAkgeMP7PIIw1K/sR4zEOQMh+dTlbK2Mk7y26943poMLUI2dlMxEGqNcZmsmnDucI
	VLK5JBmVCrD3Qzc3fwWRnxsPdfYam+h3PWR5knXcIp7uIST6BQsD55oUtgKBv/mBNW8zOIn13f5
	INGIhsqh3DxMpTCFe1jmeVoB4mqQjbkRF4zaM8rYgTFHAJIHlCqUJN
X-Received: by 2002:a05:600c:3551:b0:499:8b13:3a98 with SMTP id 5b1f17b1804b1-49cf8224cd8mr14506455e9.4.1788472066093;
        Thu, 03 Sep 2026 14:47:46 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08ca63b3sm7210789a91.11.2026.09.03.14.47.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2026 14:47:45 -0700 (PDT)
Message-ID: <36fc8581-6731-4d6b-8230-dc4f08863863@suse.com>
Date: Fri, 4 Sep 2026 07:17:41 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] btrfs: avoid unnecessary transaction commit and
 tree-checker updates
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1788449622.git.fdmanana@suse.com>
 <cover.1788451065.git.fdmanana@suse.com>
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
In-Reply-To: <cover.1788451065.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/4 01:30, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Details in the change logs.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> 
> V3: Fix misplaced parenthesis in patch 2/3, making a condition always
>      evaluate to false.
> 
> V2: Updated patch 1 due to sashiko's complain about lacking
>      checks in tree-checker for inode ref key offsets and unnecessarily
>      trigger assert failure instead of falling back to transaction commit.
> 
>      Added tree-checker patches to validate inode ref keys and inode extref items.
> 
> Filipe Manana (3):
>    btrfs: fix unnecessary transaction commit fallback from btrfs_log_all_parents()
>    btrfs: tree-checker: validate key offset for inode ref keys
>    btrfs: tree-checker: validate parent field for inode extref items
> 
>   fs/btrfs/tree-checker.c | 22 ++++++++++++++++++++++
>   fs/btrfs/tree-log.c     | 16 ++++++++++++++++
>   2 files changed, 38 insertions(+)
> 

