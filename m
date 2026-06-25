Received: from mail-pz2-f0.google.com (mail-pz2-f0.google.com [74.125.228.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9021714F70
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 02:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.0
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782354323; cv=none; b=iQIg2lp7lUxpenh8VFw4SBBxJ9O4uyqgsK2F963YVZALcEBDcPTPpRfws29kqFjHbHknCSvAYNmkxgdeKfbqlV5B6GyEIvc+SxJe58GGUCshHTK4F61rGATJfExIu37kW+D5gjDIstwc+w3PzpLAmRcciAhp2eJAaEkjYzXBDjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782354323; c=relaxed/simple;
	bh=muAGD+J88YDNJT8pnQmwcVWt9c+QGKyU5zvVLHUYJxE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m1fHUKAaZkzT1DLLOYGA7J1Bg6pK/+c7XLn0vd1kpCNjWlcApOeSchlbShjl3Za7KaYVjBtBkWNBTuX6eRcXqtH9MlQrUnGZ2Pj3RVpn74FypziKzmEU3s4j+CSVeg7pNBpvMuXmRURLPhNSx0FUHEXrmhpY2+QbjjG6Uo3L1bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PNL+iZ5C; arc=none smtp.client-ip=74.125.228.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PNL+iZ5C"
Received: by mail-pz2-f0.google.com with SMTP id 41be03b00d2f7-c888c023387so57178a12.0
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 19:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782354321; x=1782959121; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gFwkSFSWEZbd6ne4LhoyciGee5R5aYzRqG29JROyJRQ=;
        b=PNL+iZ5Czx6OyJtMEEYcZ+sgHEQwHE+MQnbrmwGDJLKZhFqhGGAKwi29kK6vwcQETN
         wcqU848iwA/8Rq5o89zxln+aZLGYWpF/yIS9zuKzfLDFDs42uX5jNBbdODQ0DktwPWcd
         y/vW0HXUdPHrcOmW0dluhXP8UHgmYJz5FQtReoCs9P7XuWIKmm51j19IWOwWZKgSlIzq
         L6VXjR9do+E1lo4OPrqbJYp/ud73cIFc8cSzNAoYdlcSTNCl+mLv0FnqQs9O8uijA90O
         1gqWiFMirVAvp+fVux8R/bD6nL5b5Ey9o0wgvu1+ByR8axrVDkMhxt8S8Dok7V9tfAqa
         Basg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782354321; x=1782959121;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gFwkSFSWEZbd6ne4LhoyciGee5R5aYzRqG29JROyJRQ=;
        b=OzmYcLhYJOlDGjOVx3yQJrbf4Xjl+1bMEeXzplmie4Z7kJvqOivOcWBh/R+lG5TtRm
         R6DAVG2eABKcZIRX8t+deAZtFaDstnTKutBar0UQWa493rB9KnFe4q5F3PVlmEBIAuJy
         cj0EqxqVMBjzgl8Q5h0mH/PEL22KPWXhoL4XvjalVLQ61zNSctia8hteYMgtO5Zy/t//
         zKGi9dt9K7fMj82h10p5ZVozsWAfeyL4DWQ9XCxKFmF3NLqJjq6S5ERVgKYT4MphfwZD
         g4pLyyC2KImXpDaJWsDPBYq/GDyv2Y3KsRvCU6X2S6uSs1Ec1kfYKE8zfL4y7kaf2on+
         fnmw==
X-Forwarded-Encrypted: i=1; AHgh+RrLgS5EC9mbNyQypKNxfhE2QvrLQ4QyxyIqBC1apbogoy7Ks/E1c2SLP+GRUT3Z4BM4xZ25IzNEqu2/vA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxhXDRR/cYSktmszuJ2PAV45Z6/jHfgwizbFkzZetgcX3vLshur
	cjcvB15QIY6+udqQG/5w+tGUXnjcTdk/B4HPTNWO5qR0IjLsPqKHWBnD
X-Gm-Gg: AfdE7cmQ6YFZ5K3BuCVVYmmKQrXp73pwz1O3c9IuaEHTtXkugMP2kOOfJiu4TOBxRte
	WTbyPw5riMForIUCoP8PZ4OiZ9XwTHLdIee4KFt6IHl2I11GGawDXB+TE05dwM+ZcW+oERGNMVf
	PXam8whpCNRHLGjV5ntgxXNU3CFx4X4CKt8wDr1DxjyGFPJkT6jJZzgbdilv7AG1s4Oq2zchiVv
	4piEzeg6F3K6L7S1yC1TI3An11xmnOrw3LwvpfkEgVxE/gZNi88JWLHUrbwOHIL9ptLHjZqEFD8
	pQ6RmXzTT3PQtugup0lVcg4NQc5UO+7UzKIxYw8XFumXgzl27Q1UgpN3tWMYkbZKwvs8PahjZhM
	8tt5LeIHhAFyQzZaaoAN30z+cebYq2FzTxH6qALhM+S29QlaAsAYsfkGw9ROx6D2TRK6HG/HkLS
	Z/TTxAIsqblH0r+T4HMVJVwSuG5wq15icgndJp0XDBTtpiZ1M=
X-Received: by 2002:a05:6a00:2d07:b0:845:3e9c:4bc3 with SMTP id d2e1a72fcca58-845b3720497mr528270b3a.0.1782354320666;
        Wed, 24 Jun 2026 19:25:20 -0700 (PDT)
Received: from [192.168.10.237] ([154.83.91.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a3fcc696sm3593010b3a.4.2026.06.24.19.25.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2026 19:25:20 -0700 (PDT)
Message-ID: <7407611d-83cc-4a97-a5b2-acff7781e811@gmail.com>
Date: Thu, 25 Jun 2026 10:25:17 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: replace writeback inhibition xarray with a fixed
 inline buffer
To: Leo Martins <loemra.dev@gmail.com>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com, David Sterba <dsterba@suse.com>,
 Filipe Manana <fdmanana@suse.com>, Boris Burkov <boris@bur.io>
Cc: kernel test robot <oliver.sang@intel.com>
References: <e0d3d3ac7c585b023c2e14cec7e2b995b247b68e.1781728340.git.loemra.dev@gmail.com>
Content-Language: en-US
From: Sun YangKai <sunk67188@gmail.com>
In-Reply-To: <e0d3d3ac7c585b023c2e14cec7e2b995b247b68e.1781728340.git.loemra.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/6/25 01:57, Leo Martins wrote:
> Commit f9a48549a15a ("btrfs: inhibit extent buffer writeback to prevent
> COW amplification") tracks the extent buffers a transaction handle has
> inhibited in a per-handle xarray. Keying the tracking to the transaction
> handle is correct, but using an xarray for it causes two problems in
> production.
> 
> First, a write_iops regression. Every COW calls
> btrfs_inhibit_eb_writeback() from btrfs_force_cow_block() and
> should_cow_block(), which does an xa_store() keyed by eb->start. The
> kernel test robot reported a 22.6% fio.write_iops regression on a
> single-task 4k randwrite workload (ftruncate ioengine, buffered IO) on
> btrfs. The cost is the per-COW xarray store done on every COW'd block.
> Replacing it with a non-allocating fixed buffer recovers the lost
> throughput, and that buffer does more per-COW bookkeeping yet still
> recovers, so the cost is the xarray operation itself rather than the
> extra tracking work.
> 
> Second, an unbounded cleanup walk. btrfs_uninhibit_all_eb_writeback()
> iterates every eb the handle inhibited with xa_for_each(). A single
> handle that COWs a very large number of blocks (inode eviction, or
> truncate of a file with many extents, where btrfs_truncate_inode_items()
> loops over many search_again descents under one handle) makes that walk
> arbitrarily long. It runs in __btrfs_end_transaction() before
> num_writers is dropped, so it blocks the committing thread; this shows up
> as multi-second stalls and RCU stall reports.
> 
> Replace the xarray with a fixed inline array on btrfs_trans_handle,
> managed with a CLOCK (second-chance) eviction policy. Inhibiting a buffer
> becomes an array append with no allocation and no tree walk, and the
> end-of-handle cleanup is bounded by the array size.
> 
> The set that actually needs protection is the working set the handle
> revisits across search_again descents, the search path frontier, which is
> on the order of the tree height. It is not every block the handle ever
> COWs. should_cow_block() re-inhibiting an already tracked buffer marks it
> referenced, so revisited buffers survive eviction while write-once buffers
> are reclaimed first. A small fixed buffer is therefore enough where a
> non-evicting array would either overflow or have to grow without bound.
> BTRFS_INHIBITED_EBS_SLOTS is 8 and the reference bits pack into a u32.
> 
> The CLOCK eviction is what justifies the extra complexity over a plain
> non-evicting array. On a workload built to stress amplification, removing
> 16 heavily fragmented 64 MiB files in one transaction while background
> writeback keeps writing out in-use metadata, counting re-COW events (a
> buffer already COWed in the running transaction, written back, then COWed
> again) against first-COW events and summing across the eviction (n=5),
> re-COWs outnumber first COWs about 6.1 to 1 with no inhibition, 3.8 to 1
> with a non-evicting array of 32 slots, 1.6 to 1 with this 8 slot CLOCK
> array, and 1.4 to 1 with the reverted unbounded xarray. The non-evicting
> array fills with write-once buffers and stops covering the buffers the
> handle keeps revisiting, so even at four times the slots it leaves most of
> the amplification. CLOCK evicts the cold buffers and keeps the revisited
> ones, which recovers almost all of the unbounded benefit. The eviction
> policy, not the buffer size, is what closes the gap.
> 
> eb->writeback_inhibitors and the WB_SYNC_ALL bypass in
> lock_extent_buffer_for_io() are unchanged, so fsync and commit behavior
> are unaffected. A reference is taken on each tracked buffer so it cannot
> be freed while the array points at it; eviction drops that reference and
> the inhibitor count.
> 
> Fixes: f9a48549a15a ("btrfs: inhibit extent buffer writeback to prevent COW amplification")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202603112240.f7605968-lkp@intel.com
> Signed-off-by: Leo Martins <loemra.dev@gmail.com>

Reviewed-by: Sun YangKai <sunk67188@gmail.com>

Thanks for your great work. The overall direction looks nice and the 
design is clean. I've got some non‑blocking suggestions, though.


> ---
>   fs/btrfs/extent_io.c   | 78 +++++++++++++++++++++++++-----------------
>   fs/btrfs/transaction.c |  2 --
>   fs/btrfs/transaction.h | 15 ++++++--
>   3 files changed, 59 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 9d7ca80477fd..1845a617fb10 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2988,41 +2988,58 @@ static inline void btrfs_release_extent_buffer(struct extent_buffer *eb)
>    * @trans:  transaction handle that will own the inhibitor
>    * @eb:      extent buffer to inhibit writeback on
>    *
> - * Attempt to track this extent buffer in the transaction's inhibited set.  If
> - * memory allocation fails, the buffer is simply not tracked. It may be written
> - * back and need re-COW, which is the original behavior.  This is acceptable
> - * since inhibiting writeback is an optimization.
> + * Attempt to track this extent buffer in the transaction's inhibited set.  When
> + * the set is full the coldest tracked buffer is evicted instead.  An untracked
> + * buffer may be written back and need re-COW, which is the original behavior.
> + * This is acceptable since inhibiting writeback is an optimization.
>    */
> -void btrfs_inhibit_eb_writeback(struct btrfs_trans_handle *trans, struct extent_buffer *eb)
> +void btrfs_inhibit_eb_writeback(struct btrfs_trans_handle *trans,
> +				struct extent_buffer *eb)
>   {
> -	unsigned long index = eb->start >> trans->fs_info->nodesize_bits;
> -	void *old;
> +	u32 slot;
>   
>   	lockdep_assert_held(&eb->lock);
> -	/* Check if already inhibited by this handle. */
> -	old = xa_load(&trans->writeback_inhibited_ebs, index);
> -	if (old == eb)
> -		return;
> -
> -	/* Take reference for the xarray entry. */
> -	refcount_inc(&eb->refs);
>   
> -	old = xa_store(&trans->writeback_inhibited_ebs, index, eb, GFP_NOFS);
> -	if (xa_is_err(old)) {
> -		/* Allocation failed, just skip inhibiting this buffer. */
> -		free_extent_buffer(eb);
> -		return;
> +	/* Already tracked: set its reference bit (second chance) and return. */
> +	for (u32 i = 0; i < trans->nr_inhibited_ebs; i++) {
> +		if (trans->inhibited_ebs[i] == eb) {
> +			trans->inhibited_ebs_referenced |= 1U << i;
> +			return;
> +		}
>   	}
>   
> -	/* Handle replacement of different eb at same index. */
> -	if (old && old != eb) {
> -		struct extent_buffer *old_eb = old;
> +	if (trans->nr_inhibited_ebs < BTRFS_INHIBITED_EBS_SLOTS) {
> +		slot = trans->nr_inhibited_ebs++;
> +	} else {
> +		/*
> +		 * Full: advance the CLOCK hand, clearing reference bits until a
> +		 * slot without one is found and evicted. Clearing a bit per step
> +		 * bounds this to BTRFS_INHIBITED_EBS_SLOTS iterations.
> +		 */
> +		while (trans->inhibited_ebs_referenced &
> +		       (1U << trans->inhibited_ebs_hand)) {
> +			trans->inhibited_ebs_referenced &=
> +				~(1U << trans->inhibited_ebs_hand);
> +			trans->inhibited_ebs_hand =
> +				(trans->inhibited_ebs_hand + 1) %
> +				BTRFS_INHIBITED_EBS_SLOTS;

I think we can using overflowing add with ` & (SLOTS - 1)` as the index 
as long as SLOTS is power of 2, instead of `% SLOTS`. And the higher 
bits can parsed as number of "rounds" if we keep them, and I'm not sure 
if the extra info is useful for any purpose.

> +		}
> +		slot = trans->inhibited_ebs_hand;
> +		trans->inhibited_ebs_hand =
> +			(trans->inhibited_ebs_hand + 1) % BTRFS_INHIBITED_EBS_SLOTS;

the same math here.

>   
> -		atomic_dec(&old_eb->writeback_inhibitors);
> -		free_extent_buffer(old_eb);
> +		atomic_dec(&trans->inhibited_ebs[slot]->writeback_inhibitors);
> +		free_extent_buffer(trans->inhibited_ebs[slot]);
>   	}

And personally I'd love to wrap this part of logic into a helper 
function like

static inline u8 btrfs_inhibit_prepare_slot(struct btrfs_trans_handle 
*trans) {...}

Or something with a better name.

>   
> +	/*
> +	 * Pin the eb while the array holds a raw pointer to it; the counter is
> +	 * what lock_extent_buffer_for_io() checks.
> +	 */
> +	refcount_inc(&eb->refs);
>   	atomic_inc(&eb->writeback_inhibitors);
> +	trans->inhibited_ebs[slot] = eb;
> +	trans->inhibited_ebs_referenced |= 1U << slot;
>   }
>   
>   /*
> @@ -3030,14 +3047,13 @@ void btrfs_inhibit_eb_writeback(struct btrfs_trans_handle *trans, struct extent_
>    */
>   void btrfs_uninhibit_all_eb_writeback(struct btrfs_trans_handle *trans)
>   {
> -	struct extent_buffer *eb;
> -	unsigned long index;
> -
> -	xa_for_each(&trans->writeback_inhibited_ebs, index, eb) {
> -		atomic_dec(&eb->writeback_inhibitors);
> -		free_extent_buffer(eb);
> +	for (u32 i = 0; i < trans->nr_inhibited_ebs; i++) {
> +		atomic_dec(&trans->inhibited_ebs[i]->writeback_inhibitors);
> +		free_extent_buffer(trans->inhibited_ebs[i]);
>   	}
> -	xa_destroy(&trans->writeback_inhibited_ebs);
> +	trans->nr_inhibited_ebs = 0;
> +	trans->inhibited_ebs_referenced = 0;
> +	trans->inhibited_ebs_hand = 0;
>   }
>   
>   static struct extent_buffer *__alloc_extent_buffer(struct btrfs_fs_info *fs_info,
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 4358f4b63057..b4b8d587effb 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -697,8 +697,6 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
>   		goto alloc_fail;
>   	}
>   
> -	xa_init(&h->writeback_inhibited_ebs);
> -
>   	/*
>   	 * If we are JOIN_NOLOCK we're already committing a transaction and
>   	 * waiting on this guy, so we don't need to do the sb_start_intwrite
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 7d70fe486758..8f628d79d4f0 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -12,7 +12,6 @@
>   #include <linux/time64.h>
>   #include <linux/mutex.h>
>   #include <linux/wait.h>
> -#include <linux/xarray.h>
>   #include "btrfs_inode.h"
>   #include "delayed-ref.h"
>   
> @@ -23,6 +22,7 @@ struct btrfs_fs_info;
>   struct btrfs_root_item;
>   struct btrfs_root;
>   struct btrfs_path;
> +struct extent_buffer;
>   
>   /*
>    * Signal that a direct IO write is in progress, to avoid deadlock for sync
> @@ -136,6 +136,12 @@ enum {
>   
>   #define TRANS_EXTWRITERS	(__TRANS_START | __TRANS_ATTACH)
>   
> +/*
> + * Must stay <= 32: the CLOCK reference bits pack into the u32
> + * inhibited_ebs_referenced.
> + */
> +#define BTRFS_INHIBITED_EBS_SLOTS	8
> +
>   struct btrfs_trans_handle {
>   	u64 transid;
>   	u64 bytes_reserved;
> @@ -163,8 +169,11 @@ struct btrfs_trans_handle {
>   	struct btrfs_fs_info *fs_info;
>   	struct list_head new_bgs;
>   	struct btrfs_block_rsv delayed_rsv;
> -	/* Extent buffers with writeback inhibited by this handle. */
> -	struct xarray writeback_inhibited_ebs;
> +	/* Extent buffers this handle has inhibited writeback on. */
> +	struct extent_buffer *inhibited_ebs[BTRFS_INHIBITED_EBS_SLOTS];

This takes 64 bytes, which is necessary, fine.

> +	u32 inhibited_ebs_referenced;	/* CLOCK reference bit per slot */
> +	u32 nr_inhibited_ebs;

Given the 8-slot limit for inhibited_ebs (4 bits (8) for capacity, 8 
bits for bitmap), using u8 for these two fields is a clear and 
straightforward choice IMO. Even if we later extend the limit to 16, 
only the bitmap field (inhibited_ebs_referenced) would need to be 
widened to u16.

Thanks,
Sun YangKai

> +	u8 inhibited_ebs_hand;		/* CLOCK hand */
>   };
>   
>   /*

