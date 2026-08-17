Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5C23AFD07;
	Mon, 17 Aug 2026 06:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786948685; cv=none; b=hJvad2CyFyuiM85t1sAxZfpaDao6CKn5xlJ8g3rjmVYryG5BFAWMVD6ote6b4XXC7Wd0ijfm91StmFOwYpTmY25pQycjoetTlnwsEZ7U5FM56hBjHqAvwo2ilNaJGb/lVKylfSGkdP8lkEJGrkFfXW59+ls1LVWgOSgnlSNR0Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786948685; c=relaxed/simple;
	bh=gFjQUsIqOeri08hWkhOW+opTLNCV7YocyT2TQOg7Roo=;
	h=Message-ID:Date:From:MIME-Version:To:CC:Subject:References:
	 In-Reply-To:Content-Type; b=XxjWaIApmdLuPOY3lHr8uKczlJaw67xCt+gqN3H94kV/VV15iELbXJZPmQNdpT9LfkzwyCUMo0z+WtPnWp+Pbi7B0nZFqk3o7IzUS6prLT1XM7a1EAHfefisiQXYCB/BzqWy0HYnnkDpEH0i565CjGcgzPLOKZeDjWWv0a7gYCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=BzGpGyH4; arc=none smtp.client-ip=220.197.31.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="BzGpGyH4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:From:MIME-Version:To:Subject:
	Content-Type; bh=Lv1r4r6QbT0vxH4A7ErB5Ug+Yg/i+uo1fbLDc70YPj8=;
	b=BzGpGyH40TZ+jeBliN4Iq0Hr+LUazc6hdyOs65zvjLhSQTDUi9MJR5TzJhAsHd
	eCEa9ZvVB3UHXNe/MW6RlbAOWnXknQLpBDhjIfqFg5tFYx/qRJGRSKDhgxh6tOPp
	77KvrcpFdkipBNqbNRl5grtCaFb9l41Wt1hiuWvHOjX0s=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wBnrYUorIJqDixGFg--.43082S2;
	Mon, 17 Aug 2026 14:37:29 +0800 (CST)
Message-ID: <6A82AC11.3030505@126.com>
Date: Mon, 17 Aug 2026 14:37:05 +0800
From: Hongling Zeng <zhongling0719@126.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, 
 Hongling Zeng <zenghongling@kylinos.cn>,
 clm@fb.com, dsterba@suse.com, lizetao1@huawei.com
CC: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: handle highmem folios in read_key_bytes
References: <20260817022012.19658-1-zenghongling@kylinos.cn> <8e30fed1-5879-4a26-a1a2-d1a3302bc068@gmx.com> <6A828ABB.10507@126.com> <eb3d2310-fbd0-474a-b44a-1d5da3d0a8f6@gmx.com>
In-Reply-To: <eb3d2310-fbd0-474a-b44a-1d5da3d0a8f6@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnrYUorIJqDixGFg--.43082S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWrWfZF4DtF4kuFy5AFy5urg_yoWrCw4xpF
	y8Ga1DKr4DJ34Yyr4Iqa1rtr1Fvay8tr4UWFsxJ342vas0vrn8WF4xKw1UW3W8Gr18GFy0
	vF1UA343ZF1DAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j-GYdUUUUU=
X-CM-SenderInfo: x2kr0wpolqwiqxrzqiyswou0bp/xtbBrglwQWqCrCmjcAAA3o


在 2026年08月17日 14:02, Qu Wenruo 写道:
>
>
> 在 2026/8/17 13:44, Hongling Zeng 写道:
>>
>> 在 2026年08月17日 10:55, Qu Wenruo 写道:
>>>
>>>
>>> 在 2026/8/17 11:50, Hongling Zeng 写道:
>>>> On 32-bit systems with highmem, folio_address() can return NULL for
>>>> unmapped highmem folios. When this NULL is passed as the dest 
>>>> parameter
>>>> to read_key_bytes() with a non-NULL dest_folio, it violates the 
>>>> function's
>>>> contract (which requires dest to be non-NULL when dest_folio is 
>>>> provided).
>>>
>>> But metadata folios are not allocated by page cache, but by btrfs 
>>> itself, which always use GFP_NOFS then attach the folio to page 
>>> cache, thus should not get highmem memory in the first place.
>>>
>>> And there is no way to trigger read from userspace on btree inode, 
>>> so there should be no highmem folios from the beginning.
>>    Thanks for the review.
>>
>>    I was not able to reproduce this on a real system. This was 
>> identified through code analysis with assistance from glm 5.5, not 
>> from a
>>    real-world encounter.
>>
>>    Your analysis about btrfs using ~__GFP_FS for folio allocation and 
>> the lack
>>    of userspace trigger paths makes sense.
>
> Sorry, it doesn't.
>
> I mis-read the context and considered the folio to be from btree 
> inode, but it's not.
>
> So it can still be from page cache, which can be highmem.
>
> But on the other hand, I do not think your fix is doing any good to 
> the readability either.
>
> I'll rework the involved function and caller to remove the folio 
> parameter, and instead always pass a vaddr and length to 
> read_key_bytes(), and let the caller to handle the kmap instead.
   Thanks for the feedback.

   I understand your rework plan. Will it also address the folio_unlock
   issue in the error path? The current code leaves the folio permanently
   locked after filemap_add_folio() + read_key_bytes() failure.

   If your rework doesn't cover this, could you help to review the 
folio_unlock
   fix patch?

>
>> The proposed changes are based on the
>>    generic folio_address() behavior and the theoretical dest/dest_folio
>>    invariant, but I do not currently have evidence that a highmem 
>> folio can
>>    reach read_key_bytes() in this state.
>>
>>    I will withdraw this patch rather than claim a reachable highmem bug
>>    without a reproducer.
>>
>>>
>>>>
>>>> The original bug had two symptoms:
>>>> 1. Unsigned len underflow when len -= copy_bytes executes (infinite 
>>>> loop)
>>>> 2. The folio remains uninitialized because the copy block is skipped
>>>
>>> So did you really hit the problem in the real world?
>>>
>>>>
>>>> Fix requires two changes:
>>>>
>>>> 1. Change "if (!dest)" to "if (!dest && !dest_folio)"
>>>>     - Prevents the "counting-only" mode when dest_folio is provided
>>>>     - Fixes the underflow/infinite loop
>>>>
>>>> 2. Change "if (dest)" to "if (dest || dest_folio)"
>>>>     - Ensures the copy block executes when dest_folio is provided
>>>>     - Allows kmap_local_folio() to properly map the highmem folio
>>>>     - Actually writes data to the folio
>>>>
>>>> Without the second change, the highmem folio is not populated even
>>>> though the read succeeds, causing subsequent fs-verity verification to
>>>> operate on stale or uninitialized data.
>>>>
>>>> Fixes: 884937793db5 ("btrfs: convert read_key_bytes() to take a 
>>>> folio")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
>>>
>>> Missing LLM disclosure.
>>>> ---
>>>>   fs/btrfs/verity.c | 4 ++--
>>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
>>>> index 983365a73541..80bc945c7dcb 100644
>>>> --- a/fs/btrfs/verity.c
>>>> +++ b/fs/btrfs/verity.c
>>>> @@ -351,7 +351,7 @@ static int read_key_bytes(struct btrfs_inode 
>>>> *inode, u8 key_type, u64 offset,
>>>>           }
>>>>             /* desc = NULL to just sum all the item lengths */
>>>> -        if (!dest)
>>>> +        if (!dest && !dest_folio)
>>>>               copy_end = item_end;
>>>>           else
>>>>               copy_end = min(offset + len, item_end);
>>>> @@ -362,7 +362,7 @@ static int read_key_bytes(struct btrfs_inode 
>>>> *inode, u8 key_type, u64 offset,
>>>>           /* Offset from the start of item for copying */
>>>>           copy_offset = offset - key.offset;
>>>>   -        if (dest) {
>>>> +        if (dest || dest_folio) {
>>>>               if (dest_folio)
>>>>                   kaddr = kmap_local_folio(dest_folio, 0);
>>

