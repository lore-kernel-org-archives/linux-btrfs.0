Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A8927BF93
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Apr 2026 15:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776783687; cv=none; b=ML7Xp055iS82sOOZNrLMaryH/kh52hAmer3r+pexPdocS0ou2ZJCzu7RevuXb/NX8AIt0R5fw5TtW7873fsAaxb2ZMcEniH99HY2uGMyogRNiBIMO/S3xKk9ZBFIhicy3R1czlFHwGWgOVdBiUXbteudpVJEOJZwsOvWIUJ2VWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776783687; c=relaxed/simple;
	bh=mFue6f/V1dHDrics7Xd+SS2PfddZSOiKB2XyzwsdCtI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=US7g1QOZEp0FnjEc3c9EyjWD3apixr69gn7b/u0E/QrfU44rod/+grpulTGeV6O18UNX5vsp7d08xvvDcVbukExuNMACX7LIV9MtGOS82vaZcyDoNZGs60uSSZEqwm6/PIztzd2T4tS+7vK1IxpbhUP1eldLrK9aYJ0e96CDIGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F47QfYqg; arc=none smtp.client-ip=209.85.214.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F47QfYqg"
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-2a9633ef0d6so3123415ad.0
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Apr 2026 08:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776783685; x=1777388485; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j15JtEEfxlQoyZLShU51/929wBUfKRNK0RJF3Kc0seo=;
        b=F47QfYqgDUVkFZ1+5a0gJ547tVNkYEkBedzkzeL/PQ0Zsg+nnYHrPAXJrZw2bvON2H
         RXOIszir9Tjz4JG6njQCn5FjHI6hmzbdJL9DosqRt1mQk0a3whU/klBw6/keCik5nbFa
         GbrGIMU7+FTSZ2/JScSgeE5x/j/62EETuaJb6A98GViQ3n+Pnhl6ae0+ti9sFZRh3Z5l
         hAv650X97gPJs/xDv87bvw+9WG9ZEdGjFnEMfkyEvGppWcSr4dXdNTRsiZ2rpTYJu7IR
         w+/G1UQBbF+36Qqr0pw01l9HIECI923gVRYP/x5nUqaMF5mjlqh04plQbeDbCFjWzG4V
         DlBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776783685; x=1777388485;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j15JtEEfxlQoyZLShU51/929wBUfKRNK0RJF3Kc0seo=;
        b=qHJWEqzGoLwcWPyr48Iv1BvTwXIlnqF4XxDxxEcJKtXVqQ10N8iUV05XDcI2HP4ZOW
         PuD7kmhnx6NafCkzwNQZkTr3wzWKfMzPXMBqYzngQlVmrQKvIkWBgsk+vLuev3L+R6QX
         xxJCxzrUlNbOL72RzWEi4JFxFmObHy/rE/STkpolBxgmutHt7jOIP0AZjJ0FDQuuy5UU
         SVuTJ4p/kOVlE7VxugPVmCZKDJsk3ODYF6v0cUccbRQjn4PdFKBzfoFAIaBhwLo1DNbZ
         2rgzR70kfS/ukkMiBb5cNUdfB2KfMGgULjKlMvUwojlVvZCPmavvvj/rYUjoYsj7v34o
         1ssg==
X-Forwarded-Encrypted: i=1; AFNElJ/jNDnZSzU2vZnUTC8Pyjmhvf2cKeI7QK0M0UJk19HO4HSWfi2RYbQF/S3DWclfO2t+gk8rM5QpA8lJyg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzImwHLVePWZxeDeOlTz7C6xVfmOIL6/ghk+QHBhEnR/SPmM7p6
	BUCFLzL3R0R4T/MSwyX2yNyi1Cf5tlhQ2sXEadAoHphLonP+Fx8CH4mgxo1Ku04VJq4=
X-Gm-Gg: AeBDievrrf1wzZ55CzoKTnRHn/tia7dZglQIlpG/6vUeKGbhK8XRjqFzd5QImGu/x4o
	OvIshBu+TlA8aEAReL8u75H2XF+Llnp9G0NX/h5Z09DONILU0HB3ToYRnZrv1wuihbSCHFyFJl1
	o4z6rhu0NytYf2PIEXnkfG8f0CkOq5NNW1+rBJZWUSCeDtnl6ipgB7kqI1tqHp6w7aTnw4KCY3S
	sV3Um3zjs6xPoioTttufuL8Tt6dqUSoTU9TRnZ1J9+WADVbb9ZR4ZeKYeFCDmmiEHOzYJc3l2wU
	ZaFRPH7c+yx2qSg1Tc89UkdyA7pgH/3adGIus9kfBjiWjtk+ebob1L3WzDpmsOUnWl0ukXhLwbV
	oQcCzHiCFODiQTa+s32TtnsFKavkk5IYiYuFos+t3VpsBShcj197SUhBSC3U80+qNUgb2ylaCpT
	YC8JOa1Y8sHDufPjRZFAcMYKxi8ZMiRCT46YxsMXWbH1QvRHuuCFfQI+nVKm20fAtJTrWHKNd1T
	/k9RXoMp6vr5vdeABNKAeTpuRQ=
X-Received: by 2002:a17:902:d60d:b0:2b0:4d17:4d6e with SMTP id d9443c01a7336-2b5f9f2d4aemr96082615ad.3.1776783683567;
        Tue, 21 Apr 2026 08:01:23 -0700 (PDT)
Received: from ?IPV6:2408:8239:502:5512:f96b:4113:6f1f:a807? ([151.241.129.36])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5faa3073asm130304115ad.27.2026.04.21.08.01.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 08:01:22 -0700 (PDT)
Message-ID: <0dd9f0e2-fe52-4050-9f44-a58b9bf58312@gmail.com>
Date: Tue, 21 Apr 2026 23:01:17 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] btrfs: skip COW for written extent buffers
 allocated in current transaction
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Leo Martins <loemra.dev@gmail.com>,
 linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Filipe Manana <fdmanana@suse.com>
References: <cover.1772097864.git.loemra.dev@gmail.com>
 <e8e4f5e396d821ba9ed6a4eee073ae8628d52aeb.1772097864.git.loemra.dev@gmail.com>
 <3f85a632-d062-4006-8bd7-1048c60197ef@gmx.com>
Content-Language: en-US
From: Sun YangKai <sunk67188@gmail.com>
In-Reply-To: <3f85a632-d062-4006-8bd7-1048c60197ef@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/3/4 14:31, Qu Wenruo wrote:
> 
> 
> 在 2026/2/26 20:21, Leo Martins 写道:
>> When memory pressure causes writeback of a recently COW'd buffer,
>> btrfs sets BTRFS_HEADER_FLAG_WRITTEN on it. Subsequent
>> btrfs_search_slot() restarts then see the WRITTEN flag and re-COW
>> the buffer unnecessarily, causing COW amplification that can exhaust
>> block reservations and degrade throughput.
>>
>> Overwriting in place is crash-safe because the committed superblock
>> does not reference buffers allocated in the current (uncommitted)
>> transaction, so no on-disk tree points to this block yet.
>>
>> When should_cow_block() encounters a WRITTEN buffer whose generation
>> matches the current transaction, instead of requesting a COW, re-dirty
>> the buffer and re-register its range in the transaction's dirty_pages.
>>
>> Both are necessary because btrfs tracks dirty metadata through two
>> independent mechanisms. set_extent_buffer_dirty() sets the
>> EXTENT_BUFFER_DIRTY flag and the buffer_tree xarray PAGECACHE_TAG_DIRTY
>> mark, which is what background writeback (btree_write_cache_pages) uses
>> to find and write dirty buffers. The transaction's dirty_pages io tree
>> is a separate structure used by btrfs_write_and_wait_transaction() at
>> commit time to ensure all buffers allocated during the transaction are
>> persisted. The dirty_pages range was originally registered in
>> btrfs_init_new_buffer() when the block was first allocated. Normally
>> dirty_pages is only cleared at commit time by
>> btrfs_write_and_wait_transaction(), but if qgroups are enabled and
>> snapshots are being created, qgroup_account_snapshot() may have already
>> called btrfs_write_and_wait_transaction() and released the range before
>> the final commit-time call.
>>
>> Keep BTRFS_HEADER_FLAG_WRITTEN set so that btrfs_free_tree_block()
>> correctly pins the block if it is freed later.
>>
>> Relax the lockdep assertion in btrfs_mark_buffer_dirty() from
>> btrfs_assert_tree_write_locked() to lockdep_assert_held() so that it
>> accepts either a read or write lock. should_cow_block() may be called
>> from btrfs_search_slot() when only a read lock is held (nodes above
>> write_lock_level are read-locked). The write lock assertion previously
>> documented the caller convention that buffer content was being modified
>> under exclusive access, but btrfs_mark_buffer_dirty() and
>> set_extent_buffer_dirty() themselves only perform independently
>> synchronized operations: atomic bit ops on bflags, folio_mark_dirty()
>> (kernel-internal folio locking), xarray mark updates (xarray spinlock),
>> and percpu counter updates. The read lock is sufficient because it
>> prevents lock_extent_buffer_for_io() from acquiring the write lock and
>> racing on the dirty state. Since rw_semaphore permits concurrent
>> readers, multiple threads can enter btrfs_mark_buffer_dirty()
>> simultaneously for the same buffer; this is safe because
>> test_and_set_bit(EXTENT_BUFFER_DIRTY) ensures only one thread performs
>> the full dirty state transition.
>>
>> Remove the CONFIG_BTRFS_DEBUG assertion in set_extent_buffer_dirty()
>> that checked folio_test_dirty() after marking the buffer dirty. This
>> assertion assumed exclusive access (only one thread in
>> set_extent_buffer_dirty() at a time), which held when the only caller
>> was btrfs_mark_buffer_dirty() under write lock. With concurrent readers
>> calling through should_cow_block(), a thread that loses the
>> test_and_set_bit race sees was_dirty=true and skips the folio dirty
>> marking, but the winning thread may not have called
>> btrfs_meta_folio_set_dirty() yet, causing the assertion to fire. This
>> is a benign race: the winning thread will complete the folio dirty
>> marking, and no writeback can clear it while readers hold their locks.
>>
>> Hoist the EXTENT_BUFFER_WRITEBACK, BTRFS_HEADER_FLAG_RELOC, and
>> BTRFS_ROOT_FORCE_COW checks before the WRITTEN block since they apply
>> regardless of whether the buffer has been written back. This
>> consolidates the exclusion logic and simplifies the WRITTEN path to
>> only handle log trees and zoned devices. Moving the RELOC checks
>> before the smp_mb__before_atomic() barrier is safe because both
>> btrfs_root_id() (immutable) and BTRFS_HEADER_FLAG_RELOC (set at COW
>> time under tree lock) are stable values not subject to concurrent
>> modification; the barrier is only needed for BTRFS_ROOT_FORCE_COW
>> which is set concurrently by create_pending_snapshot().
>>
>> Exclude cases where in-place overwrite is not safe:
>>   - EXTENT_BUFFER_WRITEBACK: buffer is mid-I/O
>>   - Zoned devices: require sequential writes
>>   - Log trees: log blocks are immediately referenced by a committed
>>     superblock via btrfs_sync_log(), so overwriting could corrupt the
>>     committed log
>>   - BTRFS_ROOT_FORCE_COW: snapshot in progress
>>   - BTRFS_HEADER_FLAG_RELOC: block being relocated
>>
>> Signed-off-by: Leo Martins <loemra.dev@gmail.com>
>> Reviewed-by: Filipe Manana <fdmanana@suse.com>
>> Reviewed-by: Sun YangKai <sunk67188@gmail.com>
> 
> Unfortunately this patch is making btrfs/232 fail.
> Bisection lead to this one.
> 
> I have hit the following errors during btrfs/232 run with this patch, 
> but not the commit before it:
> 
> - Write time tree-checker errors
>    From first key mismatch to bad key order.
> 
> - Fsck errors
>    From missing inode item other problems.
>    AKA, on-disk corruption, which is never a good sign.

I'm trying to find out what's happening here and please correct me if
I got anything wrong.

Looks like a data race causing should_cow_block returned false so 
modifications goes into it when the eb is under writeback.

The code in this patch try to prevent this by using the bit 
EXTENT_BUFFER_WRITEBACK in bflags but it's not working.

Since should_cow_block is always called with tree lock held, and we also 
hold the tree lock when setting the WRITEBACK bit, the only place that 
may cause data race is when clearing WRITEBACK bit in 
end_bbio_meta_write, where we hold no lock.

So we have no correct happen-before relation between the test_bit in 
should_cow_block and end_bbio_meta_write. Using test_bit_acquire instead 
may fix this, but I have no idea how this data race could cause the test 
fail.

> One thing to note is, that test case itself can lead to a false alerts 
> from DEBUG_WARN() inside btrfs_remove_qgroup(), thus you may need to 
> manually remove that DEBUG_WARN() or check the failure dmesg to be extra 
> sure.
> 
> Thanks,
> Qu
> 
>> ---
>>   fs/btrfs/ctree.c     | 87 ++++++++++++++++++++++++++++++++++----------
>>   fs/btrfs/disk-io.c   |  2 +-
>>   fs/btrfs/extent_io.c |  4 --
>>   3 files changed, 69 insertions(+), 24 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>> index 7267b2502665..ea7cfc3a9e89 100644
>> --- a/fs/btrfs/ctree.c
>> +++ b/fs/btrfs/ctree.c
>> @@ -599,29 +599,40 @@ int btrfs_force_cow_block(struct 
>> btrfs_trans_handle *trans,
>>       return ret;
>>   }
>> -static inline bool should_cow_block(const struct btrfs_trans_handle 
>> *trans,
>> +/*
>> + * Check if @buf needs to be COW'd.
>> + *
>> + * Returns true if COW is required, false if the block can be reused
>> + * in place.
>> + *
>> + * We do not need to COW a block if:
>> + * 1) the block was created or changed in this transaction;
>> + * 2) the block does not belong to TREE_RELOC tree;
>> + * 3) the root is not forced COW.
>> + *
>> + * Forced COW happens when we create a snapshot during transaction 
>> commit:
>> + * after copying the src root, we must COW the shared block to ensure
>> + * metadata consistency.
>> + *
>> + * When returning false for a WRITTEN buffer allocated in the current
>> + * transaction, re-dirties the buffer for in-place overwrite instead
>> + * of requesting a new COW.
>> + */
>> +static inline bool should_cow_block(struct btrfs_trans_handle *trans,
>>                       const struct btrfs_root *root,
>> -                    const struct extent_buffer *buf)
>> +                    struct extent_buffer *buf)
>>   {
>>       if (btrfs_is_testing(root->fs_info))
>>           return false;
>> -    /*
>> -     * We do not need to cow a block if
>> -     * 1) this block is not created or changed in this transaction;
>> -     * 2) this block does not belong to TREE_RELOC tree;
>> -     * 3) the root is not forced COW.
>> -     *
>> -     * What is forced COW:
>> -     *    when we create snapshot during committing the transaction,
>> -     *    after we've finished copying src root, we must COW the shared
>> -     *    block to ensure the metadata consistency.
>> -     */
>> -
>>       if (btrfs_header_generation(buf) != trans->transid)
>>           return true;
>> -    if (btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN))
>> +    if (test_bit(EXTENT_BUFFER_WRITEBACK, &buf->bflags))
>> +        return true;
>> +
>> +    if (btrfs_root_id(root) != BTRFS_TREE_RELOC_OBJECTID &&
>> +        btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC))
>>           return true;
>>       /* Ensure we can see the FORCE_COW bit. */
>> @@ -629,11 +640,49 @@ static inline bool should_cow_block(const struct 
>> btrfs_trans_handle *trans,
>>       if (test_bit(BTRFS_ROOT_FORCE_COW, &root->state))
>>           return true;
>> -    if (btrfs_root_id(root) == BTRFS_TREE_RELOC_OBJECTID)
>> -        return false;
>> +    if (btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN)) {
>> +        /*
>> +         * The buffer was allocated in this transaction and has been
>> +         * written back to disk (WRITTEN is set). Normally we'd COW
>> +         * it again, but since the committed superblock doesn't
>> +         * reference this buffer (it was allocated in this transaction),
>> +         * we can safely overwrite it in place.
>> +         *
>> +         * We keep BTRFS_HEADER_FLAG_WRITTEN set. The block has been
>> +         * persisted at this bytenr and will be again after the
>> +         * in-place update. This is important so that
>> +         * btrfs_free_tree_block() correctly pins the block if it is
>> +         * freed later (e.g., during tree rebalancing or FORCE_COW).
>> +         *
>> +         * Log trees and zoned devices cannot use this optimization:
>> +         * - Log trees: log blocks are written and immediately
>> +         *   referenced by a committed superblock via
>> +         *   btrfs_sync_log(), bypassing the normal transaction
>> +         *   commit. Overwriting in place could corrupt the
>> +         *   committed log.
>> +         * - Zoned devices: require sequential writes.
>> +         */
>> +        if (btrfs_root_id(root) == BTRFS_TREE_LOG_OBJECTID ||
>> +            btrfs_is_zoned(root->fs_info))
>> +            return true;
>> -    if (btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC))
>> -        return true;
>> +        /*
>> +         * Re-register this block's range in the current transaction's
>> +         * dirty_pages so that btrfs_write_and_wait_transaction()
>> +         * writes it. The range was originally registered when the
>> +         * block was allocated. Normally dirty_pages is only cleared
>> +         * at commit time by btrfs_write_and_wait_transaction(), but
>> +         * if qgroups are enabled and snapshots are being created,
>> +         * qgroup_account_snapshot() may have already called
>> +         * btrfs_write_and_wait_transaction() and released the range
>> +         * before the final commit-time call.
>> +         */
>> +        btrfs_set_extent_bit(&trans->transaction->dirty_pages,
>> +                     buf->start,
>> +                     buf->start + buf->len - 1,
>> +                     EXTENT_DIRTY, NULL);
>> +        btrfs_mark_buffer_dirty(trans, buf);
>> +    }
>>       return false;
>>   }
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 32fffb0557e5..bee8f76fbfea 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -4491,7 +4491,7 @@ void btrfs_mark_buffer_dirty(struct 
>> btrfs_trans_handle *trans,
>>   #endif
>>       /* This is an active transaction (its state < 
>> TRANS_STATE_UNBLOCKED). */
>>       ASSERT(trans->transid == fs_info->generation);
>> -    btrfs_assert_tree_write_locked(buf);
>> +    lockdep_assert_held(&buf->lock);
>>       if (unlikely(transid != fs_info->generation)) {
>>           btrfs_abort_transaction(trans, -EUCLEAN);
>>           btrfs_crit(fs_info,
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index dfc17c292217..ff1fc699a6ca 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -3791,10 +3791,6 @@ void set_extent_buffer_dirty(struct 
>> extent_buffer *eb)
>>                        eb->len,
>>                        eb->fs_info->dirty_metadata_batch);
>>       }
>> -#ifdef CONFIG_BTRFS_DEBUG
>> -    for (int i = 0; i < num_extent_folios(eb); i++)
>> -        ASSERT(folio_test_dirty(eb->folios[i]));
>> -#endif
>>   }
>>   void clear_extent_buffer_uptodate(struct extent_buffer *eb)
> 

