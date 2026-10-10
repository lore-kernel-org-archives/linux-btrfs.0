Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC133D6664
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 05:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791610135; cv=none; b=P6qs0H0kqK1BlzQMtkq3R/Xu2zPVzkUHbCU43kerrA1Myj5ZVof+2Oz4Qc6QyB8miuALaGf11QiKZ0Y995Mkg/0vFbQnD7STDTTtYJkSgK6vUhuHqugHBWaWPztBAtFmXAOx9L28Y5FhZc0CIZGrZ+Ps8jxNAsO0zQPIvwcRCIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791610135; c=relaxed/simple;
	bh=2cU+LgthLPxsiRIo+y8IYrh7xyGjonZwZQkpzCZFgTY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h7k/Q81+c2Bve9xJOZs+5KijL69AEKmb9gzE/R8OYNUIMaNjxtaPOm7RKqAMWH0tKTiOHBPCsOlsFjTrZKJ/X5tdOqQTKq8BLSfQMrWkJZEukVS93UbOjcmAF/OnK8W2B4eSKjIvxtXtNccZXUYLFiozs4M9TWpjG7pgTPb5F20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IbN7aGVS; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IbN7aGVS"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a02667ccebso2799505e9.0
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Oct 2026 22:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791610131; x=1792214931; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YPA70sWQsdQzEZg3nRkvmmoDpVez9uWYb0gRPmBGYdg=;
        b=IbN7aGVS1er0SHG2psJQFF3AZt5FnOqWYpEuMLXYh3TrOyjC4UrjuFc6rXQQPIfYJm
         ytGf1Gynd+y5AnO0Lj4LeiWuFhSH6Nsl+u8XYpqUaymr3utWqvgkNgLT9R26O2CUZwui
         vb/WrpUCvG156qqJX47OwFwjy/mqLopeIJOAtvJDMVRa0Wc7rUhqw9GXaJISTL1VfjcA
         KT5Ft5jVD9k4BAT/yldZM5kq8D6iCETsKC0dKzx1lT3nB6IecCBoQKgqmEUiQRzWG7m/
         eiKz7XoVPBVZev888acqgCt57gzmyLacX94770FcAo9gu5gL6nhTllR+W7Z7s9pEwsQ5
         /3VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791610131; x=1792214931;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YPA70sWQsdQzEZg3nRkvmmoDpVez9uWYb0gRPmBGYdg=;
        b=ZetIO0AmkVTkhUDGP9sJ7WPZzZl3L1KIJGJReXpP5nJHXE7fTP0mofHz0reZELZdu1
         fUih4kogFTpKCdjyRoQceV85wAgjiMnoHUBdEem+swD9CF5KuHYZ8GG6tuE5Ec7YM7dm
         2z25wj9goTiNgZmJ4+kjEAE5TWDKecdZ/ORVbJ/VDkYflfimikiFu+NP0W0UFN3lx4gD
         LtP5KWZJYXPkHsUY+DwgDxsmLDr39WzDIcQl2hDZMyAxNEvCjkskFZKfEKUYPhUDsOZf
         pDcaUxbXfWY1ZpG9Usee18NXRB4RcKFEfG77k2Ur4ezTK/eRIRUTG9CA9/qgczQjEzYf
         f7jw==
X-Gm-Message-State: AFq9FYIep1pK3V6oA9zvECaLXwGZ5KWRXr7rgg4kVQLJtwN8rZlAJskF
	CBIgxi7an9y83g75dw5SIqUiYWMrVXcDKGeqagKGMlQljlN2cqjwULMtD7t4XoNxJzcpRudmqoL
	kDtTz3KNNKQ==
X-Gm-Gg: AYBFou2uy9ywI21bzvL5vudTSJMol7nqOru7UQSFUqgPB77jL1zwnI8XGGKYFzqjKcg
	QZz164jbFiil4fTwLjVhUi2mO/bW48c95DF1ahomfzjs6ak+ZYQcl0AS5e9v5yUJuKsElFmAiRG
	cqMPhXqw6JbvCwhSk9Kzc5R8uwnVL0d1WPiiZ8g8XOjEFFR0RHGFjdkiaLAZfLjCxZ8feakeQPg
	iSBcMuD2bEmdQbo930gVxVAXH1DP6AP8yWrxVDawqLv/QJC1TGwcM0ftOUT4QZg4/E555EkZunE
	Xkd7OHD7SLAYGzz+NrKH0w1xdCBeGREkHPHTFZy/mnc+WnURIx2z2ZVQWGs0EHQfD5HodCzQ6GZ
	zZ6PAxb9I0JH7iwcDaUADrH9U43XIUJ32VKLGZIpFBfyrEOHzWED0r8lG+zO+ZodpiapjLTwDBm
	AmAnnJK43jsaBd8C6TLhn8SEgSZ+jvntuSEQ4d31Azw1Zq3wlBIx45fenyBO1EtaM=
X-Received: by 2002:a05:600c:3b08:b0:4a0:da23:e06d with SMTP id 5b1f17b1804b1-4a18e4a380bmr74218955e9.10.1791610131423;
        Fri, 09 Oct 2026 22:28:51 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422c99b6sm19421085ad.65.2026.10.09.22.28.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 22:28:50 -0700 (PDT)
Message-ID: <062e16f1-8453-4b2c-af47-416f75b867c9@suse.com>
Date: Sat, 10 Oct 2026 15:58:46 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix the fsverity callback where unexpected range
 is verified
To: =?UTF-8?Q?Roger_Alas=C3=A0?= <vonbloom@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <c1cbf7c27ca3685b6440c04c87b70fe779a2535b.1791591949.git.wqu@suse.com>
 <CAELqY9=KEwhaJygnTvfPYY56EB5UyuXZeuQbQU9COXznehbo7A@mail.gmail.com>
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
In-Reply-To: <CAELqY9=KEwhaJygnTvfPYY56EB5UyuXZeuQbQU9COXznehbo7A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/10 15:56, Roger Alasà 写道:
> Hi Qu,
> 
> Thanks for the quick fix. Tested on top of v7.2.9 in a KVM guest
> (Arch's config, 4 vCPUs, virtio disk, btrfs root mounted with
> compress=zstd:1), vanilla vs. patched:
> 
> - the reproducers from the report: 10 "FILE CORRUPTED" messages
>    without the patch, none with it;
> 
> - a copy of /usr (34969 files, 855 MiB of binaries and text, closer
>    to the composefs repository where we hit it), SHA-512 verity on
>    every file, each pass from a cold page cache:
> 
>                                                   vanilla  patched
>      cat, sequential                     20        0
>      cat, 4 parallel readers         10        0
>      mmap page faults               11        0
>      diff -r against the original    30        0
> 
> No read errors and identical data with both kernels.
> 
> The counts are lower bounds: fsverity_msg() is rate limited, which is
> also why the report always showed 10.
> 
> A small note on the [BUG] paragraph: in all these runs read() never
> failed, only the messages were logged.

Oh sorry, I'll update the commit message during merging.

The read will not fail because the IO has copied the content into the 
page cache, and during the next retry everything is already properly 
uptodate, thus the retry will succeed, thus no read failure, just 
fs-verity warnings.

Thanks for the test and the initial report,
Qu
> 
> Tested-by: Roger Alasà <vonbloom@gmail.com>
> 
> Thanks,
> Roger
> 
> Missatge de Qu Wenruo <wqu@suse.com> del dia ds., 10 d’oct. 2026 a les 2:26:
>>
>> [BUG]
>> There is a bug report that on v7.2 kernel, compressed extents with
>> fsverity enabled can lead to read error.
>>
>> [CAUSE]
>> Since v7.2 btrfs has enabled large data folio support, now a folio can
>> contain multiple blocks even if the page size matches the fs block size.
>> And even before that, btrfs already has block size < page size support,
>> thus all involved code should assume a folio can contain multiple
>> blocks.
>>
>> However the function btrfs_verify_folio() calls fsverity_verify_folio(),
>> which verifies the whole folio, even if the read range only covers part
>> of the folio.
>>
>> This forces fsverity to verify garbage data that is not yet read from
>> disk, and causes verification failure.
>>
>> This is a long-standing bug, but previously it only affected bs < ps
>> cases which is not that common.
>> Now with the large folio support, it's much easier to trigger with bs ==
>> ps cases.
>>
>> [FIX]
>> Instead of calling fsverity_verify_folio(), call
>> fsverity_verify_blocks() to verify only the read range.
>>
>> Reported-by: Roger Alasà <vonbloom@gmail.com>
>> Link: https://lore.kernel.org/linux-btrfs/CAELqY9==Ter2XQPRp=gjW5T75T+7kcZCXpn5roF2L6tY6mQNxw@mail.gmail.com/
>> Fixes: 146054090b08 ("btrfs: initial fsverity support")
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/extent_io.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 55e9144d4759..5ff630630490 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -504,7 +504,7 @@ static bool btrfs_verify_folio(struct fsverity_info *vi, struct folio *folio,
>>
>>          if (!vi || btrfs_folio_test_uptodate(fs_info, folio, start, len))
>>                  return true;
>> -       return fsverity_verify_folio(vi, folio);
>> +       return fsverity_verify_blocks(vi, folio, len, offset_in_folio(folio, start));
>>   }
>>
>>   static void end_folio_read(struct fsverity_info *vi, struct folio *folio,
>> --
>> 2.56.0
>>

