Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02623A5448
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Sep 2026 06:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788934260; cv=none; b=evHRH6JF3U/WUyUn273fNmXS/nU7DbNCuw7PUc/fJjclorWIY0tCKPi6WHhPQHiBALMzhfElupu+UoGWiuON1RK54fXfqyaVyKWm/KrYJYLO0jYQsPcXnc6TaoUk+Vx7hP+IFmgqxNutTXwABtpMZZnYmhB49+P4shXJ4NGXQG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788934260; c=relaxed/simple;
	bh=2iI7+hsSt6Pmjb6ifN1OdgNX0gZcw9BkmoyEoH4S+XM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s89jb5CxkQll+h3OAz6Lq030YN1XGfJtIWqq/9BqXDR5p/NAE8cjAjvRu/bDqfbOCO/7+SY1RWkqrXaKAeNT29SA/UJmDJy8gk3Q3CqE1/RlYi598sYvfiFVPJ6aPS5B3fJlrOne7/0KpBrAYRBKv9+snmf51WD5MsYlXiWu/zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=et7hQjrU; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="et7hQjrU"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48431648f33so4067218f8f.0
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2026 23:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788934257; x=1789539057; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=os4SWo7VFONZBHRCMPqcSTHrGMNYmyYABYQjLTTOy4c=;
        b=et7hQjrUd8K8N4vaIWJBOqDiKO2Ubn9xSBRYCWfDvJv86qrZIVhgr2YiwCUGTZoAyl
         0jGaA9HCD9zWYshuZa0r0G7+3zA9NKGByGz7PdhakmwsppbEvhebiv9Dlfz/uZbbS4ib
         NaZdVHHqKn5yznmZCrIDh6Rju5PvyAUd8HrvvqdenE2Mb2B5Xc4ftLFc1eY12TjIB+w1
         usRocPOMt9jqn5kG5ITzv8zLMei1XyZcwNyUSADE14W96TbARHW9SPvjoh++XlMx4HWl
         5H496o/9eF3z0OiiwVjIoWnj/vJ5PnfY+P/eoDTNb0938Xo5PBWDFc04nTh7lsYvbDzC
         0nzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788934257; x=1789539057;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=os4SWo7VFONZBHRCMPqcSTHrGMNYmyYABYQjLTTOy4c=;
        b=nFFnjK5HTfgqHyK4iGlXqNbjRe1/8LriyMVp0fGfrkq1WxbWgwBlnOXB7nrreBQAbD
         h+Up1td3McaTHLJiPLk1VAfeX7G+syey7TtaTMINJPI8SHgaAw64oitQ5wSLDfCDb2dr
         Kj8tcz62YRJZ/Ys6PwWsr/NScKyKpX9pIcV9HTBOFe08HS4flc6TTNxvQ30k1YjuXMlX
         yJvLaoKkf984wGXRaG0GXc0z8AZAybUW5Wj6R0A3984baircJNM9JLONf55ZYpJFda8X
         GpBj9roD0QskopUk3xVOMCdnR41rnJag0QOHM4duKvK5v+W3N8iu1B9mrzfppG9grOBX
         r8sA==
X-Forwarded-Encrypted: i=1; AKwUvBzim3RcSMT1gMGutSGya+84qWxfP3N9u4li17f0lp1LwWPklZQdr5kl+cFrNgZTmyBNOKSxuiIr2w53dA==@vger.kernel.org
X-Gm-Message-State: AFuF++l21DUlsGXb6eKplu0i7l3kvV0Y92ET9UF1pF08dy6eOA2dzoN4
	LNWzVnn2ajDh5mNvH64o0AWILOqIPRWVNUCjVbrI0hHgVO7ERL25HAFb/vSNKB9IIoQ=
X-Gm-Gg: AYBFou2UWXK0v5qxdmQ/bRcLJBx4PqLe/59IbOUrh6EkwhO5mbpytQBWYSFKHgDuQp2
	I/p+wsLP9gVQGvx7CkO9qWw73c2xHO/JYvmeddzYsbGP3zVCveVGS3hg40DOV/lGcet682O5Ass
	7IfA7YKCxpfMMwXbWDH+Saj1Vu5MhVUUI49J/uO3XsJKCA9n0L2T6SQWjJFlPRRVtMJJFeasorW
	UPzDFbXnpKqH6yrk1B7hox8EG5AwftuN4v7J2JH+NeXIAxCBiAiCWDlxlR7EX3qeekCwa4a+Cyr
	jetUnnnMry5ZHYD4PGQuBlTGmIWgb8IkEfijnBzefUjrB6xriW1HM88XKFP8C4i6pyVZkcUFE/P
	C1njQMtH27cvETIOT/dmAT1QazHeiAtJa1h8RIPPXMbBSdzd+1GKcOO9QFa9B4DPo4KFNoWLjyB
	3UTUzLtrdcLJcH8ioXEKwedlvk0NSCF0w6CE7YzqoNfZUnHzOBeo3AUFO3MsLV0Ng=
X-Received: by 2002:a05:600c:138a:b0:49c:f13d:ffeb with SMTP id 5b1f17b1804b1-49cf13e0642mr424219605e9.15.1788934257023;
        Tue, 08 Sep 2026 23:10:57 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143243767e1sm34889401c88.6.2026.09.08.23.10.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 23:10:55 -0700 (PDT)
Message-ID: <f4a415f9-1e3a-4b26-a2a4-61bcc98eb39f@suse.com>
Date: Wed, 9 Sep 2026 15:40:47 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/7] btrfs: convert some struct page users to folios
To: Tal Zussman <tz2294@columbia.edu>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260907-btrfs-folio-conversions-v2-0-b5fe79f7607b@columbia.edu>
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
In-Reply-To: <20260907-btrfs-folio-conversions-v2-0-b5fe79f7607b@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/8 05:49, Tal Zussman 写道:
> This series converts three areas of btrfs that still use struct page:
> 
> 1. The extent-io tests. test_find_delalloc() uses the page APIs, and the
>     extent buffer memory checks assume one page per folio.
> 
> 2. Compression. btrfs_compr_pool_scan() walks the folio pool as struct
>     page, the last use of page->lru in btrfs, and the heuristic sampler
>     is the last caller of find_get_page().
> 
> 3. Super block reads. btrfs_read_disk_super() and the zoned super block
>     log comparison are the last page cache lookups by page in btrfs.
> 
> Tested with KASAN, lockdep, DEBUG_VM and the btrfs selftests enabled.
> xfstests' compress group under compress=zstd and the btrfs group both
> pass.

Now pushed to for-next branch.

Thanks,
Qu

> 
> ---
> Changes in v2:
> - Add tags (Thanks Qu!)
> - Patch 2: Assert that test_find_delalloc()'s folios are order-0, per Qu
> - Drop the v1 free space cache patches (8-10), per Qu. The v1 space
>    cache will be removed instead
> - Link to v1: https://patch.msgid.link/20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu
> 
> ---
> Tal Zussman (7):
>        btrfs: tests: rename process_page_range() to process_folio_range()
>        btrfs: tests: convert test_find_delalloc() to use folios
>        btrfs: tests: use eb folio helpers in extent buffer memory checks
>        btrfs: convert btrfs_compr_pool_scan() to use folios
>        btrfs: convert heuristic_collect_sample() to use folios
>        btrfs: fix stale function references in compression comments
>        btrfs: use folios for reading super blocks from the block device
> 
>   fs/btrfs/compression.c           |  20 +++---
>   fs/btrfs/tests/extent-io-tests.c | 131 +++++++++++++++++++++------------------
>   fs/btrfs/volumes.c               |  16 +++--
>   fs/btrfs/zoned.c                 |  12 ++--
>   4 files changed, 93 insertions(+), 86 deletions(-)
> ---
> base-commit: 69b26c13e520480d1869171e2c2b8a59f0c857ec
> change-id: 20260905-btrfs-folio-conversions-47950cc1faca
> 
> Best regards,
> --
> Tal Zussman <tz2294@columbia.edu>

