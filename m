Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345115474E;
	Mon, 17 Aug 2026 04:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786940286; cv=none; b=fvyO3WzeRVMxAz9JtkqZuENlUUAigt9Th6jwazot3BvkSbk3apvwbeZIhJqVuGjxMP0u4q7RQus3dS7nbb1L5qiahBxxjXvRE8DOMoJTN1dJ2TDXSz6rm/uZGEPhugi9B7GrnHVgSwFQUY5RxgAMsOgjUjXdODlIVpgRWCWbR0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786940286; c=relaxed/simple;
	bh=sGtFL/ujPheaT9QlrQqwaXn15CTLavm9eQM73ovd4e0=;
	h=Message-ID:Date:From:MIME-Version:To:CC:Subject:References:
	 In-Reply-To:Content-Type; b=mK7mHr5QHEs7/lNWfBpMLr53jkX5N/2/qOlJwjk0i2VR7EzogaJbE5T935eyH6jmLtp0RbbrBLm87CkrlSn0Fq3epOesx5rAg1CitKtCIMcFAaCDxJR90x2MvU5kQ9tuhhn8i0LSYJSLIJv3h3MSKDgA3+ygv8hYTQwx1vNVekI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=OPOx49x9; arc=none smtp.client-ip=117.135.210.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="OPOx49x9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:From:MIME-Version:To:Subject:
	Content-Type; bh=rZnWCfy1aXR8ocL+33l1covIwlgmt6MTx7GimKPo6xU=;
	b=OPOx49x9svv3q0RwnHWsgp1hTbCqMczmiXl9t1+YL+hUoLiW+PIscoKJZJW+x9
	TfinLSTVr1iEess6UTJ6WoJo18dAnsbTpiTGel32qnHzCS1CUko6oifMYuAz68km
	I4ftWNB/uLQSRAh7JSYJ6HdHyrWgtuG7lhA/CxX1dKJRA=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wD3j03TioJqfCnTFw--.19642S2;
	Mon, 17 Aug 2026 12:15:16 +0800 (CST)
Message-ID: <6A828ABB.10507@126.com>
Date: Mon, 17 Aug 2026 12:14:51 +0800
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
References: <20260817022012.19658-1-zenghongling@kylinos.cn> <8e30fed1-5879-4a26-a1a2-d1a3302bc068@gmx.com>
In-Reply-To: <8e30fed1-5879-4a26-a1a2-d1a3302bc068@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3j03TioJqfCnTFw--.19642S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXr4kCF4xWr4DJr13trW5ZFb_yoW5Zw1fpF
	WxCas8KrWDJ34YkF4rXa1jqr1rZa9Yyr4DGFsIka12vas8Xrn0gF4Ikw45W3W8trs7AFy0
	vF4UZ343ZF1DAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j-GYdUUUUU=
X-CM-SenderInfo: x2kr0wpolqwiqxrzqiyswou0bp/xtbBrhQT42qCitR6ZAAA3i


在 2026年08月17日 10:55, Qu Wenruo 写道:
>
>
> 在 2026/8/17 11:50, Hongling Zeng 写道:
>> On 32-bit systems with highmem, folio_address() can return NULL for
>> unmapped highmem folios. When this NULL is passed as the dest parameter
>> to read_key_bytes() with a non-NULL dest_folio, it violates the 
>> function's
>> contract (which requires dest to be non-NULL when dest_folio is 
>> provided).
>
> But metadata folios are not allocated by page cache, but by btrfs 
> itself, which always use GFP_NOFS then attach the folio to page cache, 
> thus should not get highmem memory in the first place.
>
> And there is no way to trigger read from userspace on btree inode, so 
> there should be no highmem folios from the beginning.
   Thanks for the review.

   I was not able to reproduce this on a real system. This was 
identified through code analysis with assistance from glm 5.5, not from a
   real-world encounter.

   Your analysis about btrfs using ~__GFP_FS for folio allocation and 
the lack
   of userspace trigger paths makes sense. The proposed changes are 
based on the
   generic folio_address() behavior and the theoretical dest/dest_folio
   invariant, but I do not currently have evidence that a highmem folio can
   reach read_key_bytes() in this state.

   I will withdraw this patch rather than claim a reachable highmem bug
   without a reproducer.

>
>>
>> The original bug had two symptoms:
>> 1. Unsigned len underflow when len -= copy_bytes executes (infinite 
>> loop)
>> 2. The folio remains uninitialized because the copy block is skipped
>
> So did you really hit the problem in the real world?
>
>>
>> Fix requires two changes:
>>
>> 1. Change "if (!dest)" to "if (!dest && !dest_folio)"
>>     - Prevents the "counting-only" mode when dest_folio is provided
>>     - Fixes the underflow/infinite loop
>>
>> 2. Change "if (dest)" to "if (dest || dest_folio)"
>>     - Ensures the copy block executes when dest_folio is provided
>>     - Allows kmap_local_folio() to properly map the highmem folio
>>     - Actually writes data to the folio
>>
>> Without the second change, the highmem folio is not populated even
>> though the read succeeds, causing subsequent fs-verity verification to
>> operate on stale or uninitialized data.
>>
>> Fixes: 884937793db5 ("btrfs: convert read_key_bytes() to take a folio")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
>
> Missing LLM disclosure.
>> ---
>>   fs/btrfs/verity.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
>> index 983365a73541..80bc945c7dcb 100644
>> --- a/fs/btrfs/verity.c
>> +++ b/fs/btrfs/verity.c
>> @@ -351,7 +351,7 @@ static int read_key_bytes(struct btrfs_inode 
>> *inode, u8 key_type, u64 offset,
>>           }
>>             /* desc = NULL to just sum all the item lengths */
>> -        if (!dest)
>> +        if (!dest && !dest_folio)
>>               copy_end = item_end;
>>           else
>>               copy_end = min(offset + len, item_end);
>> @@ -362,7 +362,7 @@ static int read_key_bytes(struct btrfs_inode 
>> *inode, u8 key_type, u64 offset,
>>           /* Offset from the start of item for copying */
>>           copy_offset = offset - key.offset;
>>   -        if (dest) {
>> +        if (dest || dest_folio) {
>>               if (dest_folio)
>>                   kaddr = kmap_local_folio(dest_folio, 0);

