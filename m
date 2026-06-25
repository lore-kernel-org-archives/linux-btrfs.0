Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B422BE034
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 05:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782364654; cv=none; b=nLu6qSZsC5/iQd5jqNJSNiiY/eiOGvZzdKm970hjlvlE134XLooM4XJNbtNL3WNUSfq2ZvxofdDHyGGILEzG9KAo+COcpmpP0Dy9qTNk4AFowYp3p3D+JHbCUELQkXPRWwPRoYZwTedUkaAHgjY0HUG+dHITUBlakoq3ErX959o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782364654; c=relaxed/simple;
	bh=EQimEhg6uOBxFCaFEAkeS4b3ZN2n95BN5koXWSC98YQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=qhbGYZVFyI9nbouMansqTX60pNJHKhwjzXqMHWIEM4LrBJVnIfXBusSeU1sixgiVNN+mFzzB7TdLObtPHlmngbpDXKC6f2LKhOHZkdASnNZoAudTsxdJKOIwlt2v1LqV8KvT3WXgYT/a01EPr3W4HyxkcqLngthEJK4K2edSJPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=R6yDAs1l; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="R6yDAs1l"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so12687005e9.0
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 22:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782364651; x=1782969451; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=QZDcasHb8Z/6w824Zb2BMHDRyGd+1BT+Ludev7nK0WM=;
        b=R6yDAs1lLduN2sgEnfLVFpeFJCOswogJnzOaa+iepGcC7QG614FRI1Kz5zslK19Ss0
         EVaFfPDmwCVUI4zMlOVAVfCsttaCAPAHVlpQmSy+0PoTbEcMexsYF5FYG8ySPCHXppau
         iVloyvApVFws9K3yRg34FuuYIhwRUfxuZ9oWNiO3MiRJ0KrIBAwcdXdtM+9q7aFQuKwg
         vZU+L7RB9RfCTCz55h7ZzLYB7bdBReqFZy4tsP2gXItoQ5SVWJYv4fR2fBcyPwNVt69k
         ZkLhDnBTiwdbC6215PuhFrt7tHg6sa7YRiDMBdyjB3k/DGz7J9SrCSy5td8ptdoc7JuP
         VRBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782364651; x=1782969451;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QZDcasHb8Z/6w824Zb2BMHDRyGd+1BT+Ludev7nK0WM=;
        b=ahTpQhsV7OxQmU9G/cPyo7dMpfLcv58N6S0yLdMLlUyB5CdoGvQQV2+YLuYDT67ou7
         EjxEvUT3TRAC727EKYjF4gYFbDk/p6GhU8N05HZq4EBBmMC/IxtIKFMhxnlGJGQKHfFC
         XnpATbUril9MP/yZp4Geleedp8YeJempsjg/57mvv7ybKjBuDyFMR9Eu+qb6o+kvKJnn
         mZJwGQm2Lqffhaa7dTgBxwa8/m5bm9bHkcYxjVQXvLOperLRPdAUkc0XyVYNRJaYGdVy
         leNJ68ImHPDqTrhwtwgtOj0VgKX1p4ELdYz0Gwvfd2TWEmOA8yIzxTvtpLF5uvOj7anc
         kjWg==
X-Gm-Message-State: AOJu0YyCNDzpN3VrnsKW7HFqjRrfevxODbecTRiKlQOGNTSMD+En+x5L
	zWQCzskbZMgSHXFnPdwt1QpHlR4ciRj2NAc3hA3n0Z86H2RvtfXDdCUMEWR9OUqBPzo=
X-Gm-Gg: AfdE7cmnOLVkZc1pWnw4gfEmLVkjfAzkiIDje9kYxGdUuolrdgZQ++9vPb2f8i5U+l1
	Apjt9dxp1QVu3kgrDRwrmLHGucuyPAtSEODPG9J5LOc9UJ15f8a8EiYomIyuEy+YInda4B+0kYT
	VfOwdbzy7eoHfD/3RtQiDUh9t0iFSVLcQkrFDdczrKPfU5mUzwjfcK5IB82jU8WwEA1LztOA2v4
	eqGvNb4qE1aMj+DJ3U0KlnjhxOktkTngyjLSd1cP8ajZZQf1o8YodATYen8d4ZiLWLuGv6Y6BKM
	w797F+ylhEUhzDJbWukPNkjlu9UWOU6HnJGP2CE9PHE0zDI8P9PBdPbUP8+iPylXn19BxOAmmpr
	zl6gKKt/QBdolfLQRS8FKjrpWe4ddkAcWnL8eCxj9TPxgDg618DsJc5Jl7UoDWd3cuiv0v2uSjX
	Qh/QblDh8GcCjAv0TXAxi0XFEj12IrCznOo2y7Umo=
X-Received: by 2002:a05:600c:5486:b0:490:601f:d776 with SMTP id 5b1f17b1804b1-492668628admr9867925e9.3.1782364650837;
        Wed, 24 Jun 2026 22:17:30 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-139d8f318f3sm4080811c88.2.2026.06.24.22.17.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2026 22:17:29 -0700 (PDT)
Message-ID: <c2afdc0e-6e63-42b8-9a8a-fc77d2ab7383@suse.com>
Date: Thu, 25 Jun 2026 14:47:25 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: wait for ordered extents before buffered write
 fallback in direct IO
From: Qu Wenruo <wqu@suse.com>
To: Yun Zhou <yun.zhou@windriver.com>, clm@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260625021456.724803-1-yun.zhou@windriver.com>
 <aa009e0d-a629-44ed-bb68-202ff2dc5063@suse.com>
Content-Language: en-US
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
In-Reply-To: <aa009e0d-a629-44ed-bb68-202ff2dc5063@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/25 14:43, Qu Wenruo 写道:
> 
> 
> 在 2026/6/25 11:44, Yun Zhou 写道:
>> When btrfs_direct_write() falls back to buffered IO after a failed DIO
>> attempt, it may race with the asynchronous completion of DIO ordered
>> extents.  This leads to a BUG_ON in insert_ordered_extent() due to
>> overlapping ordered extents in the per-inode rb-tree.
>>
>> The race sequence is:
>>   1. DIO creates an ordered extent via btrfs_dio_iomap_begin()
>>   2. Page fault occurs (nofault=true), no bio is submitted (submitted=0)
>>   3. btrfs_dio_iomap_end() truncates and finishes the OE asynchronously
>>      via btrfs_finish_ordered_extent() which queues work
>>   4. iomap returns 0, retry logic faults in pages and retries DIO
>>   5. Second DIO attempt also fails, code reaches buffered: label
>>   6. btrfs_buffered_write() dirties pages for the same range
> 
> btrfs_buffered_write()
> |- copy_one_range()
>     |- lock_and_cleanup_extent_if_needed()
>        |- btrfs_start_ordered_extent()
> 
> So your explanation doesn't makes sense. As if there is the direct IO oe 
> remaining, we will wait for that OE to complete.
> 
> There is still something missing.
> 
>>   7. btrfs_fdatawrite_range() triggers writeback
>>   8. run_delalloc_nocow() -> fallback_to_cow() -> cow_file_range()
>>      tries to insert a new ordered extent for the same file offset
>>   9. The DIO ordered extent hasn't been removed from the rb-tree yet
>>      (btrfs_finish_ordered_io running async in workqueue) -> BUG_ON
>>
>> Fix this by waiting for any pending ordered extents in the target range
>> before starting the buffered write.
>>
>> Reported-by: syzbot+ba2afde329fc27e3f22e@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=ba2afde329fc27e3f22e
>> Fixes: acf9ed3a6c00 ("btrfs: retry faulting in the pages after a zero 
>> sized short direct write")

And the fixes tag is also incorrect.

Without that commit, we will directly fallback to buffered write without 
retry faulting in the pages.

So by your explanation it will trigger the same problem, with or without 
that commit.

>> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
>> ---
>>   fs/btrfs/direct-io.c | 24 ++++++++++++++++++++++++
>>   1 file changed, 24 insertions(+)
>>
>> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
>> index 460326d34143..e8ac9492844c 100644
>> --- a/fs/btrfs/direct-io.c
>> +++ b/fs/btrfs/direct-io.c
>> @@ -844,6 +844,7 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, 
>> struct iov_iter *from)
>>       struct file *file = iocb->ki_filp;
>>       struct inode *inode = file_inode(file);
>>       struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
>> +    struct btrfs_ordered_extent *ordered;
>>       loff_t pos;
>>       ssize_t written = 0;
>>       ssize_t written_buffered;
>> @@ -1025,6 +1026,29 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, 
>> struct iov_iter *from)
>>       }
>>       pos = iocb->ki_pos;
>> +
>> +    /*
>> +     * The DIO path may have created ordered extent(s) that are still 
>> being
>> +     * processed asynchronously in a work queue.  We must wait for 
>> them to
>> +     * be fully completed and removed from the rb-tree before doing a
>> +     * buffered write to the same or overlapping range; otherwise the
>> +     * buffered writeback path (run_delalloc_nocow -> fallback_to_cow ->
>> +     * cow_file_range) may try to insert a new ordered extent that 
>> conflicts
>> +     * with the still-pending DIO one, triggering a BUG_ON in
>> +     * insert_ordered_extent().
>> +     *
>> +     * This happens when DIO creates an ordered extent but has a 
>> short write
>> +     * (submitted < length in btrfs_dio_iomap_end()), which truncates 
>> and
>> +     * finishes the ordered extent asynchronously while we fall back to
>> +     * buffered IO for the same range.
>> +     */
>> +    while ((ordered = btrfs_lookup_ordered_range(BTRFS_I(inode),
>> +                (u64)(pos - written),
>> +                (u64)written + iov_iter_count(from))) != NULL) {
>> +        btrfs_start_ordered_extent(ordered);
>> +        btrfs_put_ordered_extent(ordered);
>> +    }
>> +
>>       written_buffered = btrfs_buffered_write(iocb, from);
>>       if (written_buffered < 0) {
>>           ret = written_buffered;
> 
> 

