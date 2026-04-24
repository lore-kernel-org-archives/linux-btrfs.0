Received: from mail-pj1-f67.google.com (mail-pj1-f67.google.com [209.85.216.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5DB292B44
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 09:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777024111; cv=none; b=H0CfCcuvdhrbI4O8RvunPb3YE9zt6AfXM1WjSP/6xSGsygUPlaB5wdAa543lGKnnlWa5uk/IJ7jI8dal4DnLZQotev4ovnTRdOz7MVqMQVL4770rKzMZbCC7S7GBNdW/ntRfJ+Rrn4XQ7ON8PQ3WEcOKHtTogwAsYJrNucVQOxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777024111; c=relaxed/simple;
	bh=KfeEYPonFJ5TrZeN2mqvpotsvDLGz7rINvoELCNBV/c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=E6N8k6cOQB/i4pj3rVA0bHGzf+lkLPpbLb8YRtCwzyMgQ3TI602o/d724NB2EKjSCNVb5o41BjeR06aX3hrVz5+RpcjUprznCzZirQPkdWYJDsd39Uci0EQ6bcgZyrXyZPhhsK5fTnpRnpIbf2nmV4/0RK6pgVWpzxvXh3djNio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XClYe/9x; arc=none smtp.client-ip=209.85.216.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XClYe/9x"
Received: by mail-pj1-f67.google.com with SMTP id 98e67ed59e1d1-35d901060f6so1509724a91.1
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 02:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777024109; x=1777628909; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YIaZ1VterdUTr48f/HWI79Xuaq/IQPbrImaAh7jyAss=;
        b=XClYe/9xcfJ3LiqiJfjMKIeOVJTcVTvHnXskKxj3xKz1l3egPMjiA+fiogJmzOv2lX
         Vh7r3LyAY8wNXZEeHVO6NPxfbSszbLrZsRBZjLgAZGMrcdq30xAyBXS2277Aik6dP4jJ
         K4H1+f9KeqOB4tJGzjNHUFXeZGR6wjM7YHFiKkS7jkzvAhBySNDdUF2+SOvlihrspqW1
         lIgG6nEYfCYWYUqwWCQCTFWqHEpRc9zi8Kk8nSxKo6LCLQUsWQLLR88Yr4SPbPUJkO5W
         fkE90USS6cdzZfdXCpbfPsRoe5qcFKKlQxZ5zT4tLemLCIwDvgk3y8qWk+Q01dbot3rN
         PLRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777024109; x=1777628909;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YIaZ1VterdUTr48f/HWI79Xuaq/IQPbrImaAh7jyAss=;
        b=mtqZhK1f6Lc2/aAufYOrIuZI6LANRbNdKpYMqCnm/DRSZ5Jxu96Sc07WsXrsNwQXF7
         5Tn1EN2mU+kAkMv9dBtEt5mhPJzoVYcbJcFkGPrKq26OtWsOrat663XiY0D8h6o6hDdH
         mKgyzYB8ID8N9Bc88AU1GAuCq/Jt+5bcgu93YRSn4JU7R5dbgqhELhH7/cDE3v1vfHOw
         t4AOSwgL4zgZIQRtYHGGvdhxw8qyZ2vSNRdd5QEpAlVfWKlu8GZ0fn1A47HZkdQlXNMM
         5nwYgNxoQVlc5F8qF+T5BrAvWwNAPLp5hIFBS+H9KtGGC+CaVDn0O6wHK/ke6lT+Fi3J
         oMDQ==
X-Forwarded-Encrypted: i=1; AFNElJ8ciJQDIHuJMLwBZ1+c0E7gac5HXBEwlrdgX07TiVV4dxSnx0qQHncVXZ00uGN3zq0kTa8/apd+1mYNZg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxn5lHZciBHt/lPC2WYcKUGmtd86O7vOyYXbz+S7fXq59Tkr4ub
	xFkPqyrNBts/X0+B/kcmfKZycvya5hTXy5mtiP4YY7bSl+kAIhmeHoaZ
X-Gm-Gg: AeBDievI4B45UurHLDaDxRE5htxOrJ1k5kL0QwnZZM/VoDeyLe3DMaWb6d6tXB15C4q
	VnyBrNd/wuJJbEb4vbCFpr/1/A6vb1ZQ3Wk1I/d7MxiRkxYTDnYQDtlugAkWgIRCzp4TG56vg8p
	aPk/fVHRVdQrBii5vep1PYsnQhJY3j2Jo9oEvLhF/JeGs0Z/iemd2GM9TbcG9IwTw5C0N+V+4vx
	QoPMI7jUNfI/qX1wvf8fedXFD4F7XwO65m1rgfEFt+rqGE6EaoGqxXgMTmDLg9tywzW4esJje1P
	m2Tz5SQbWb9Do/iL7WmazJbqbcd8hmC1GgtWZ7DEq9tXakVT9eWNqtaLPxtYKsHRnZA9XOjcMte
	TG/xkrNegC1he6M5KFLDsaXnZc4it7AUaAaFHjY7lwZbJ7HqFMyyHn+MjUGKvsa01HcSbOebwbb
	317YzndnRF00Ab1DUgf83c0cai2ufCgDHpfy0GQrEoxsTBT8xaZQkykYu1juLSt0mXTw7Clhirq
	DcAhwvUSN3vKg+f
X-Received: by 2002:a17:90b:55cb:b0:35f:ba08:35bf with SMTP id 98e67ed59e1d1-361404648d3mr15836436a91.5.1777024109089;
        Fri, 24 Apr 2026 02:48:29 -0700 (PDT)
Received: from ?IPV6:2408:8239:502:5512:7a07:a401:bf01:6fc7? ([151.241.129.36])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-361410bac6dsm22382118a91.14.2026.04.24.02.48.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 02:48:28 -0700 (PDT)
Message-ID: <781a2579-c6ee-4dd8-ac68-cdb7503a21e1@gmail.com>
Date: Fri, 24 Apr 2026 17:48:24 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] btrfs: cap shrink_delalloc iterations to 128M
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Boris Burkov <boris@bur.io>,
 linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1775756789.git.boris@bur.io>
 <b990d13d17d8f6eeb341457801fdaabdf123f8e3.1775756790.git.boris@bur.io>
 <54030bf6-56a5-4633-9bc2-0008ca43191e@gmx.com>
Content-Language: en-US
From: Sun YangKai <sunk67188@gmail.com>
In-Reply-To: <54030bf6-56a5-4633-9bc2-0008ca43191e@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/4/24 14:38, Qu Wenruo wrote:
> 
> 
> 在 2026/4/10 03:18, Boris Burkov 写道:
> [...]
>>
>> This means iterating over to_reclaim by 128MiB at a time until it is
>> drained or we satisfy a ticket, rather than trying 3 times to do the
>> whole thing.
>>
>> Reviewed-by: Filipe Manana <fdmanana@suse.com>
>> Signed-off-by: Boris Burkov <boris@bur.io>
> 
> Hi Boris,
> 
> I'm testing the latest for-next base as the baseline for the incoming 
> huge folio support.
> 
> On arm64 64K page size, 4K fs block size, I'm seeing a very weird 
> behavior on generic/027.
> On 7.0-rc7, the test case takes less than 5 seconds and passes as expected.
> 
> But on for-next it never finished, furthermore there is always a kworker 
> taking a full core, deadlooping inside 
> btrfs_async_reclaim_metadata_space(), and you can not unmount the fs.
> 
> Here is the "echo l > /proc/sysrq-trigger" stack dump for the involved 
> btrfs kworker:
> 
> [ 6616.093728] CPU: 0 UID: 0 PID: 501715 Comm: kworker/u33:0 Not tainted 
> 7.0.0-rc7-custom-64k+ #9 PREEMPT(full)
> [ 6616.093732] Hardware name: QEMU KVM Virtual Machine, BIOS unknown 
> 2/2/2022
> [ 6616.093734] Workqueue: events_unbound 
> btrfs_async_reclaim_metadata_space [btrfs]
> [ 6616.093849] pstate: 63400005 (nZCv daif +PAN -UAO +TCO +DIT -SSBS 
> BTYPE=--)
> [ 6616.093852] pc : btrfs_start_delalloc_roots+0xf0/0x268 [btrfs]
> [ 6616.093923] lr : btrfs_start_delalloc_roots+0x88/0x268 [btrfs]
> [ 6616.093987] sp : ffff80008af0fbd0
> [...]
> [ 6616.094008] Call trace:
> [ 6616.094009]  btrfs_start_delalloc_roots+0xf0/0x268 [btrfs] (P)
> [ 6616.094073]  flush_space+0x3d4/0x6b0 [btrfs]
> [ 6616.094138]  do_async_reclaim_metadata_space+0x88/0x1d8 [btrfs]
> [ 6616.094201]  btrfs_async_reclaim_metadata_space+0x50/0x80 [btrfs]
> [ 6616.094263]  process_one_work+0x174/0x540
> [ 6616.094277]  worker_thread+0x1a0/0x318
> [ 6616.094279]  kthread+0x140/0x158
> [ 6616.094285]  ret_from_fork+0x10/0x20
> 
> So it's a regression, and bisection points to this patch.
> 
> And I tried the following steps to further confirm it's caused by this 
> commit:
> 
> - The test passes just before the commit
>    The previous commit is "btrfs: make inode->outstanding_extents a u64".
> 
> - The test failed at that commit
>    The test case never finish and one kworker dead looping.
> 
> - The test case pass at for-next with this commit reverted
>    The test case finishes in seconds as usual.
> 
> Do you have any clue on what's going wrong? I guess it's pretty hard to 
> hit on x86_64.> I have a local btrfs branch with huge folios support, with that it's
> pretty easy to hit similar problems on x86_64, but without that branch, 
> no hit is observed so far on x86_64.
> 
> Thanks,
> Qu
> 
>> ---
>>   fs/btrfs/space-info.c | 31 ++++++++++++++++++++-----------
>>   1 file changed, 20 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
>> index f0436eea1544..e931deb3d013 100644
>> --- a/fs/btrfs/space-info.c
>> +++ b/fs/btrfs/space-info.c
>> @@ -725,9 +725,8 @@ static void shrink_delalloc(struct 
>> btrfs_space_info *space_info,
>>       struct btrfs_trans_handle *trans;
>>       u64 delalloc_bytes;
>>       u64 ordered_bytes;
>> -    u64 items;
>>       long time_left;
>> -    int loops;
>> +    u64 orig_tickets_id;
>>       delalloc_bytes = percpu_counter_sum_positive(&fs_info- 
>> >delalloc_bytes);
>>       ordered_bytes = percpu_counter_sum_positive(&fs_info- 
>> >ordered_bytes);
>> @@ -735,9 +734,7 @@ static void shrink_delalloc(struct 
>> btrfs_space_info *space_info,
>>           return;
>>       /* Calc the number of the pages we need flush for space 
>> reservation */
>> -    if (to_reclaim == U64_MAX) {
>> -        items = U64_MAX;
>> -    } else {
>> +    if (to_reclaim != U64_MAX) {
>>           /*
>>            * to_reclaim is set to however much metadata we need to
>>            * reclaim, but reclaiming that much data doesn't really track
>> @@ -751,7 +748,6 @@ static void shrink_delalloc(struct 
>> btrfs_space_info *space_info,
>>            * aggressive.
>>            */
>>           to_reclaim = max(to_reclaim, delalloc_bytes >> 3);
>> -        items = calc_reclaim_items_nr(fs_info, to_reclaim) * 2;
>>       }
>>       trans = current->journal_info;
>> @@ -764,10 +760,14 @@ static void shrink_delalloc(struct 
>> btrfs_space_info *space_info,
>>       if (ordered_bytes > delalloc_bytes && !for_preempt)
>>           wait_ordered = true;
>> -    loops = 0;
>> -    while ((delalloc_bytes || ordered_bytes) && loops < 3) {
>> -        u64 temp = min(delalloc_bytes, to_reclaim) >> PAGE_SHIFT;>> -        long nr_pages = min_t(u64, temp, LONG_MAX);
>> +    spin_lock(&space_info->lock);
>> +    orig_tickets_id = space_info->tickets_id;
>> +    spin_unlock(&space_info->lock);
>> +
>> +    while ((delalloc_bytes || ordered_bytes) && to_reclaim) {
>> +        u64 iter_reclaim = min_t(u64, to_reclaim, SZ_128M);
>> +        long nr_pages = min_t(u64, delalloc_bytes, iter_reclaim) >> 
>> PAGE_SHIFT;
I wonder if it's possible that delalloc_bytes < 64k while to_reclaim == 
U64_MAX so we'll get nr_pages == 0 on 64k page size and we'll loop for a 
very long time(seems forever).

>> +        u64 items = calc_reclaim_items_nr(fs_info, iter_reclaim) * 2;
>>           int async_pages;
>>           btrfs_start_delalloc_roots(fs_info, nr_pages, true);
>> @@ -811,7 +811,7 @@ static void shrink_delalloc(struct 
>> btrfs_space_info *space_info,
>>                  atomic_read(&fs_info->async_delalloc_pages) <=
>>                  async_pages);
>>   skip_async:
>> -        loops++;
>> +        to_reclaim -= iter_reclaim;
>>           if (wait_ordered && !trans) {
>>               btrfs_wait_ordered_roots(fs_info, items, NULL);
>>           } else {
>> @@ -834,6 +834,15 @@ static void shrink_delalloc(struct 
>> btrfs_space_info *space_info,
>>               spin_unlock(&space_info->lock);
>>               break;
>>           }
>> +        /*
>> +         * If a ticket was satisfied since we started, break out
>> +         * so the async reclaim state machine can process delayed
>> +         * refs before we flush more delalloc.
>> +         */
>> +        if (space_info->tickets_id != orig_tickets_id) {
>> +            spin_unlock(&space_info->lock);
>> +            break;
>> +        }
>>           spin_unlock(&space_info->lock);
>>           delalloc_bytes = percpu_counter_sum_positive(
> 
> 

