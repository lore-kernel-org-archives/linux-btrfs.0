Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD5530DED0
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 06:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782281890; cv=none; b=twrR1apR/iv914mHVnWjdHrmMJJz37rrKODqr5ospITzLq00IPIViRnAkCXu3F4INq2BD/ATfNlydaW2SCCw2UaBFDzlQDHNqPo5IysGSFx4M/Jsjlb+WD9lMRuGCs36cK218kWvJt/UHeAH9dcbh13wH+3WfCocY5jy3HCKViw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782281890; c=relaxed/simple;
	bh=RDR2jF4PUdY1A6mPM+sqM4TZk+cLUfjvgYaEuCChqm8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XPpq2tqePLnmfQARc0hwCBIfIMjpYG8GsKijYhG8F/fEdAu99VS3CrxSh9ew1a815ZVFGfybhk9PxJnDsC6NtVPHxu1ANxthBd/TaiK/SG75Q+jqnTp2CtGw1R8KlkpWjFOFXQv5S7DD+2R38bv1pxi8jc/xpY0QddvNRlA5UT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=glVPDZfR; arc=none smtp.client-ip=74.125.227.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="glVPDZfR"
Received: by mail-pj2-f1.google.com with SMTP id 98e67ed59e1d1-37c6cc1eb94so32324a91.1
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 23:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782281888; x=1782886688; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lgs5nCcgwVoEVnhiwYiKqNBjSWtjj/U8zR911yE1bts=;
        b=glVPDZfRyAe3NryJU0up/EKuZDAQw3ZZ8pwhyoHD/kqToUiSMqFn4+/VeXm7wEy3YS
         TzU1pkS1+ttvpunKNM1LhvNK94TuaoWSIRZsz/jRn6xolqyL2zmd8TTw9u0bXnYyjdUM
         MJEK9NfhiFRdeGWp2g9/gzC/xphKuWlq+hfb5vV+KpmOD7U2Bpp3xNiklIe8zFfuqx1j
         XOdVdtftS9mVt34gp2vWnTWkh4vqboVSIMBuCzOI34mcOgrE2HqqBStEAD0DWApV0vcl
         Mn0tr+oUHxiZiNSpAUGz/7P+6KRBDdGnZthR6w5rbHNRVGfKSLeengKwv8VMRwPykTeZ
         TQfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782281888; x=1782886688;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lgs5nCcgwVoEVnhiwYiKqNBjSWtjj/U8zR911yE1bts=;
        b=dcw5Ov2vA4ArPmvBW4k2bF4jn9b1hPSUB91L8LK30NF7c2XG/oL41fU9xzijPD7QSb
         1vmi+N8srunvq/p0f5Hfs+u/voKt5OxTQbtHcAL01yPhIqupeOUyu6Yj2n92VB7JOYIE
         mLsLrUOklWwjC1FYboT5XByy++NkC6Ff7SLGqGYGQb9A7WUQlNKo3Ft+GyGEca5bw1qE
         4+tL0rKA8HoqY/rJiw+ew7mbpXbbPFIXOngpoSSBxviasWxPi+2RG5FQ9l8VYC+h09S+
         QQE4af7K04nt9iktx91pAoewyUYbhlE88v8vWgdeQ+OhQn77njj6uUszKRiXgnTskhDF
         Vj6w==
X-Gm-Message-State: AOJu0YwSDIsetHUdhF4IXf9eznqf87oJtC2w7h0TMvMgOltDnricaTEF
	c1+0oatTojVqweWrvzPur9GTGZEDJ57dmPXoGR3GG/pKWlpy138ekXkDw4neqwrlZKcZGg==
X-Gm-Gg: AfdE7cll/UGQ22mM2vZtPq4HHqCaE7LfdQXCsRqWGep2rT8ydzCcoRC9JMBUDbdl62T
	W/9/aTc2y7tHp6a9SALxGcdAvoDq5LlA0ETvWq7WOmpNmUJOQ8OfyfBYEONfaDhB2h67faqNo60
	0WrlJH9VsUgUlAddKXDDKIZ8GRhao47BsoE1jYR0PzK2zdpaFRM6xz+/VopYpsNQAp1KGVeOQ/q
	tkXqsih7VKv9x4DBMR5uSVhcsvM24AEfAgmVM2Uenr3NQkqLZTgs5xHsN+OxZVk1dRA/k7Vkvhj
	2oIq96f6gAGZ6NmlkPwZX5aQrQ7RNKzRKjsjLY++Q/J2ntZWRF90gVb8H7NnQs7eci4mgkvEagf
	L9Wv/RglNSkYBoQoWXXZa+tMRVZaR6zTAfkoD4bRT2GPZ4LJFjvx27WXJqVIkRZX2s59JHrQBZ0
	eq4cIuQ/2ZfsPovpp4aYyRs8g2q0k4qt4E0b8Ah4Jj3ABfpcU=
X-Received: by 2002:a17:903:22d0:b0:2c7:ecbd:f48d with SMTP id d9443c01a7336-2c7ecbdf923mr62195ad.7.1782281888201;
        Tue, 23 Jun 2026 23:18:08 -0700 (PDT)
Received: from [192.168.10.237] ([154.83.91.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7436f6395sm127471865ad.28.2026.06.23.23.18.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2026 23:18:07 -0700 (PDT)
Message-ID: <26f7b745-6a8d-4fcd-9393-70b2345f24ca@gmail.com>
Date: Wed, 24 Jun 2026 14:18:05 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: change block group reclaim_mark to bool
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org
References: <20260624040232.30420-1-sunk67188@gmail.com>
 <20260624041909.GA2011094@zen.localdomain>
Content-Language: en-US
From: Sun YangKai <sunk67188@gmail.com>
In-Reply-To: <20260624041909.GA2011094@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/6/24 12:19, Boris Burkov wrote:
> On Wed, Jun 24, 2026 at 12:02:27PM +0800, Sun YangKai wrote:
>> The reclaim_mark field in struct btrfs_block_group was a u64 that was
>> incremented when marking block groups for reclaim during sweeping, but
>> the actual counter value was never used - only the zero/non-zero state
>> mattered for determining if a block group needed reclaim.
>>
>> Convert it to a bool to properly reflect its usage and reduce memory
>> footprint by 8 bytes. Update assignments to use true/false instead of
>> increment and zero.
>>
> 
> LGTM, thanks.
> Reviewed-by: Boris Burkov <boris@bur.io>
> 
>> Signed-off-by: Sun YangKai <sunk67188@gmail.com>
>> ---
>>   fs/btrfs/block-group.c | 2 +-
>>   fs/btrfs/block-group.h | 7 ++++++-
>>   fs/btrfs/space-info.c  | 2 +-
>>   3 files changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
>> index 9e937407d12a9..5829c806c4d48 100644
>> --- a/fs/btrfs/block-group.c
>> +++ b/fs/btrfs/block-group.c
>> @@ -3923,7 +3923,7 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
>>   		old_val += num_bytes;
>>   		cache->used = old_val;
>>   		cache->reserved -= num_bytes;
>> -		cache->reclaim_mark = 0;
>> +		cache->reclaim_mark = false;
>>   		space_info->bytes_reserved -= num_bytes;
>>   		space_info->bytes_used += num_bytes;
>>   		space_info->disk_used += num_bytes * factor;
>> diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
>> index 790c2d467af57..942befdf75df7 100644
>> --- a/fs/btrfs/block-group.h
>> +++ b/fs/btrfs/block-group.h
>> @@ -263,6 +263,12 @@ struct btrfs_block_group {
>>   
>>   	enum btrfs_block_group_size_class size_class:8;
>>   
>> +	/*
>> +	 * Mark this blockgroup is not used for allocation
>> +	 * between two reclaim sweeps.
> 
> nit: this grammar doesn't parse great to me. Maybe drop "Mark"?
> or change it to "We identified this for reclaim on a previous pass, so
> it stably needs reclaim across passes" or something like that.

I also think this comment should be polished but have no idea. Your nit 
helps a lot. How about this:

Tracks whether this blockgroup has been idle during the previous 
periodic sweep cycle. It is set to false on allocation, and set to true 
by the periodic sweep upon first pass. If found true on a subsequent 
scan, the blockgroup is eligible for reclamation.

>> +	 */
>> +	bool reclaim_mark;
>> +
>>   	/*
>>   	 * Number of extents in this block group used for swap files.
>>   	 * All accesses protected by the spinlock 'lock'.
>> @@ -281,7 +287,6 @@ struct btrfs_block_group {
>>   	struct list_head active_bg_list;
>>   	struct work_struct zone_finish_work;
>>   	struct extent_buffer *last_eb;
>> -	u64 reclaim_mark;
>>   };
>>   
>>   static inline u64 btrfs_block_group_end(const struct btrfs_block_group *block_group)
>> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
>> index e6641597b321e..39a28e1bec8ad 100644
>> --- a/fs/btrfs/space-info.c
>> +++ b/fs/btrfs/space-info.c
>> @@ -2156,7 +2156,7 @@ static bool do_reclaim_sweep(struct btrfs_space_info *space_info, int raid)
>>   			will_reclaim = true;
>>   			reclaim = true;
>>   		}
>> -		bg->reclaim_mark++;
>> +		bg->reclaim_mark = true;
>>   		spin_unlock(&bg->lock);
>>   		if (reclaim)
>>   			btrfs_mark_bg_to_reclaim(bg);
>> -- 
>> 2.54.0
>>

