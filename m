Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403D03F9A1B
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jul 2026 08:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783586824; cv=none; b=If+dpUM5uoRBaIeyfLLoniXuSA9OBU6MVhFAur1unJgwKN0hAPWuNZ7AQ1V+B5J+SxZrwgRuCFslEgoTjK3j/h+YocHCJ/2QvtEBudnOiYDFM4T9egqScrJOFOdzaU2WrMyx+PX7hXFPM/AS6S0QSWdWVLrcmYC6Rsnzqru7lKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783586824; c=relaxed/simple;
	bh=lJewBIhPErmbF+B1WhWX8oSj7vXOfOVGlFo3sn2VEKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pvtnpr7HifPsuOmrTi5mqTaAPd0qRpA0mcGdw0Mr+ghYgGdNmBRfe5YX1UkH3TcZuMTi69Y2r73+3FdbM+ckV7P66tDVE9BnQMu0W3UmOAzhfZLc9MQA2l6Tbu4EasIAtsJwKBiIoqVQd1J7qpyAjPhoB9AFgRam57ZJa23VYm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZGlcMKiJ; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZGlcMKiJ"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c128cc012b4so106551766b.1
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2026 01:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783586821; x=1784191621; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f9oUIcPtP0MKyiNDmZpoCqOdzpLf03FkmgNaMrki8TQ=;
        b=ZGlcMKiJd9mXryJd3hm++n16ymWJ3XbCbp5/lNcylbz/w2Wqg7NSwf/SwnImZAhLj+
         UdhTc+XWVFvCTmHs5m+7zW6kTW4ydE5xE94Hj37OF1nX31rElbW2kJJqUGLOb1LGZiaj
         DoW2rjTan9aCx+IPHny8u9LLeH9Hk0BEIBrmxyoaAEL1DpWcqXm0lowweW2TRYLzs9wI
         s8kkREF/ISHHomAYcsejo6uLRz/phmuQfbFD5QsxgofHzMi6oEMh698YUIV7VOlEn5y6
         ocAYV61Kxd+58wWq6kGrbmEiQnkEawPPdV8xIs372ib7cHlni0JSTGI/LsRjHEXG6Fnx
         JypA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783586821; x=1784191621;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f9oUIcPtP0MKyiNDmZpoCqOdzpLf03FkmgNaMrki8TQ=;
        b=D4qdDxoiKUEOHXd/o8VMztHZ/F0yDcXp5z8brlril/u3W/ZapufvUEXkxDNqxunKuG
         NejofAheaxTn2UMZPbkcez613LxaoTlji0SYxd02hznspq7T/smQqgVI1NtrC95CFquO
         4Xd0uZqEcSad9Am1+0QJ9u9HDI4q4R+ScWJgDVdmAS4KW/pLrEm04hRSfKz/YX3JhFiF
         GSXDatNJORSRvETWfjYz3RKqpmCw+WxruJcxLx8vJmGT/euK3T7rpdsHJ+O5WGJhzeiQ
         gYHoJ/ATSb6ys5AFfhJJgPHgBNDn4O7nAUNyO9S5WOz8QDmXahaT9/A4whPjpgIWg5ST
         wzpQ==
X-Forwarded-Encrypted: i=1; AHgh+Rox7Iw3yeVgTBRENHuLm9M+IptQF52Cjm2mFR35tKNhwuMr9UsE5LjY3REsGW7iZi/l5nGhtmqAViTvKg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzkZPqzdnGbCRQ3GPEWKy5MIC7vfFj/MmUHmYX5zqlMJuI2sU81
	5k4iCJZ5AOxu++oKTJchQcvAngbBMIOtTEqQTH+KoOWFIeexi3oVfQiCNa73mcCO2BzyrvTZ4m6
	5t4k335A=
X-Gm-Gg: AfdE7cmjNjWHPfzkUGW8CUNELqn5nYXp+UGR+2k7R/aLRVX0XxFX05DFOEonHCpTB13
	oCwcEMMt6vYZHyp6/TN7fpl9E1PBPcz9JhsILqhCrv26y0afmSrvEi96q/AXQF0xq5WxTAN0OqC
	LLHo9yyzI1HHC4n2LeWq7I66Qh7oJ54mERozR9SlzfxN+pFzQANhiDnotb3YqnHdR84U2Niej97
	xqFxqrX+VcLfyQpqVKta1shSqnGLLt6/I7WANG1agnZfOC9CW86jPO5oyzFGs9C8NljdxaSVg0J
	MYWu/ppPrmwr2G6TbAibjp84DonADdfGDaopV/fC4N20zqo9WyJ8sFEaqBexq6d7gcAifdbwpu4
	6yo3MU48myFDmyAw8A8nEHxP6OodAbl499mi8Vgj/R725/jui/2/51zGz6gLN6DUW2b2Q5GMHz2
	YrSLYzvA==
X-Received: by 2002:a05:6938:a08e:20b0:c12:a556:6713 with SMTP id a640c23a62f3a-c15e7b18fbbmr52633766b.31.1783586820359;
        Thu, 09 Jul 2026 01:47:00 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d5c361sm40200045ad.80.2026.07.09.01.46.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2026 01:46:59 -0700 (PDT)
Message-ID: <bc4b48c4-9d3e-40ac-82f6-d01df950443f@suse.com>
Date: Thu, 9 Jul 2026 18:16:55 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: write-protect folios during data writeback
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
Cc: willy@infradead.org
References: <856f2a691977072386085d768b7929520e1022af.1783570200.git.boris@bur.io>
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
In-Reply-To: <856f2a691977072386085d768b7929520e1022af.1783570200.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/9 14:01, Boris Burkov 写道:
> Commit 095be159f3eb ("btrfs: unify folio dirty flag clearing") replaced
> the folio_clear_dirty_for_io() call in extent_write_cache_pages() with a
> plain folio_test_dirty() check. Besides clearing the dirty flag,
> folio_clear_dirty_for_io() also calls folio_mkclean(), which write-protects
> the shared mmap PTEs mapping the folio.
> 
> Without the write-protection, a process with the file mmap'd can modify
> a sector while it is being used by writeback in a way that expects a
> stable folio (checksumming, compressing, copying, etc...) which
> manifests as a handful of concrete bugs.
> 
> For large folios or subpage sectorsize, this will result in an invalid
> checksum and later corruption reports on read (if sectorsize ==
> folio_size() then we will always be in the case where we call
> folio_mkclean() when we clear the dirty on the sector, which is the
> whole folio).

Just want to make the cause more clear, and also explain under what 
exact situation the problem can happen.

Firstly, we still call folio_clear_dirty_for_io(), but at a much later 
timing, now it's only called when the last dirty block got its dirty 
flag cleared, instead of just before extent_writepage().

This means, if there is only a single contig dirty range inside a folio, 
and we can submit that contig range in one go, then the problem will not 
happen.

E.g. a 32K folio with 4K block size, and inside the folio the dirty 
range looks like this:

     0     8K     16K     24K    32K
     |     |//////////////|      |

Then during writeback, we clear the block dirty and mark writeback, 
queue that block into a bbio (but not yet submitted).

Finally at the last block [20K, 24K), we cleared the last dirty block, 
thus will call folio_clear_dirty_for_io() for the whole folio, then 
submit the bio for range [8K, 24K), and everything is still safe.

But another commit, "btrfs: limit size of bios submitted from 
writeback", is making the situation worse, as if we get a very large 
folio, e.g. 128KiB one, even if the whole range is dirty, it will still 
be submitted as two 64K bios, in that case, the first half will be 
submitted without folio_mkclean() called, thus causing the problems 
you're describing.


With all these said, this may help you to craft a more reliable 
reproducer, by:

1. Allocate a large folio (e.g, 64KiB on 4K ps systems)
    By doing a 64KiB sized buffered write at file offset 0.

2. Mmap range [4K, 8K) and [16K, 20K)

3. Trigger writeback with mmaped range being modified



> 
> For zoned submissions which are done in batch separate from the main
> extent_writepage() loop, we also risk csum violations for those
> submissions.
> 
> For inline extents this will subtly risk losing writes that happen
> after/while we copy the inline extent but before we clear dirty on
> the folio.

Inline is indeed affected, as we only rely on the final 
extent_clear_unlock_delalloc() -> process_one_folio() -> 
btrfs_folio_clamp_clear_dirty() to clear the block dirty, which is too late.

As the data is already copied into metadata without folio_mkclean().


> 
> For folios spanning EOF, mmap could tamper with the zeroed bytes past
> EOF and cause them to be persisted where future faults would impoperly
> see them instead of zeros.
> 
> Finally, for compressed extents, we risk modifying the folios while we
> work on compressing them which will result in corrupted compressed data.
> This particular gap was introduced by a second patch in the same series:
> Commit a4ef54dbb576 ("btrfs: make extent_range_clear_dirty_for_io() to handle sector size < page size cases")

Yes, compression corruption is still true, but only for the last/first 
folio.

Firstly compression range is always contig, only the first and last 
folio can have other dirty ranges out of the compression range.

So the middle folios will always have their folio dirty flags cleared by 
extent_range_clear_dirty_for_io() -> btrfs_folio_clamp_clear_dirty().

> 
> We cannot simply restore the call to folio_clear_dirty_for_io() because
> that also drops the dirty flag off the folio which violates invariants
> introduced for large folios by
> commit 334509ce9d07 ("btrfs: use dirty flag to check if an ordered extent needs to be truncated")
> and results in failing to invalidate clean folios past i_size, resulting
> in deadlocks.
> 
> Therefore, to fix it, leave the existing semantics w.r.t. the folio's
> dirty flag (to preserve the correct invalidate behavior) but ensure that
> the other aspect of folio_clear_dirty_for_io(), folio_mkclean(), is run
> on the folio when we lock it for writeback.
> 
> Finally, to help prevent similar regressions in the future, add a debug
> warning that triggers at the known corruption sites if we have failed to
> write protect the folio.
> 
> Assisted-by: LLM (debug, reproduce, research fix, review patch)
> Fixes: 095be159f3eb ("btrfs: unify folio dirty flag clearing")
> Fixes: a4ef54dbb576 ("btrfs: make extent_range_clear_dirty_for_io() to handle sector size < page size cases")
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>   fs/btrfs/extent_io.c | 31 +++++++++++++++++++++++++++++++
>   fs/btrfs/extent_io.h |  5 +++++
>   fs/btrfs/inode.c     | 23 +++++++++++++++++------
>   3 files changed, 53 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 8fbb798767ca..647b109ef61b 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -6,6 +6,7 @@
>   #include <linux/mm.h>
>   #include <linux/pagemap.h>
>   #include <linux/page-flags.h>
> +#include <linux/rmap.h>
>   #include <linux/sched/mm.h>
>   #include <linux/spinlock.h>
>   #include <linux/blkdev.h>
> @@ -299,6 +300,25 @@ static noinline void unlock_delalloc_folio(const struct inode *inode,
>   				PAGE_UNLOCK);
>   }
>   
> +#ifdef CONFIG_BTRFS_DEBUG
> +/*
> + * Writeback must write-protect a folio when locking it for IO, before
> + * anything consumes its data (zeroing, inline copy, compression,
> + * checksumming). If this fails, then an mmap writer would be able to
> + * modify the data concurrently while we need it to be stable.
> + */
> +void btrfs_check_folio_write_protected(struct folio *folio)
> +{
> +	if (folio_mkclean(folio)) {
> +		const struct btrfs_inode *inode = BTRFS_I(folio->mapping->host);
> +
> +		DEBUG_WARN("writable mmap PTEs, root %llu ino %llu pos %llu order %u",
> +			   btrfs_root_id(inode->root), btrfs_ino(inode), folio_pos(folio),
> +			   folio_order(folio));
> +	}
> +}
> +#endif
> +
>   static noinline int lock_delalloc_folios(struct inode *inode,
>   					 struct folio *locked_folio,
>   					 u64 start, u64 end)
> @@ -332,6 +352,8 @@ static noinline int lock_delalloc_folios(struct inode *inode,
>   				folio_unlock(folio);
>   				goto out;
>   			}
> +			/* Locked for writeback; revoke writable mmap PTEs before using the data. */
> +			folio_mkclean(folio);

I believe this is mostly for compression.

As inline folio is already cleaned by folio_mkclean() before 
extent_writepage().
The same for regular COW/NOCOW writes.

In that case, as I mentioned in another thread, I'd prefer not to call 
folio_mkclean() too early.

I'd prefer to call folio_mkclean() inside 
extent_range_clear_dirty_for_io() instead.
>   			range_start = max_t(u64, folio_pos(folio), start);
>   			range_len = min_t(u64, folio_next_pos(folio), end + 1) - range_start;
>   			btrfs_folio_set_lock(fs_info, folio, range_start, range_len);
> @@ -1780,6 +1802,13 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
>   	ASSERT(end <= folio_end, "start=%llu len=%u folio_start=%llu folio_size=%zu",
>   	       start, len, folio_start, folio_size(folio));
>   
> +	/*
> +	 * We are about to checksum and write out the data, so it must not be
> +	 * mmap writeable, or we could corrupt the data and end up with invalid
> +	 * checksums.
> +	 */
> +	btrfs_check_folio_write_protected(folio);
> +
>   	/* Truncate the submit bitmap to the current range. */
>   	if (start > folio_start)
>   		bitmap_clear(bio_ctrl->submit_bitmap, 0,
> @@ -2590,6 +2619,8 @@ static int extent_write_cache_pages(struct address_space *mapping,
>   				continue;
>   			}
>   
> +			/* Locked for writeback; revoke writable mmap PTEs before using the data. */
> +			folio_mkclean(folio);
>   			ret = extent_writepage(folio, bio_ctrl);
>   			if (ret < 0) {
>   				done = true;
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index 9896e15ddc40..869925337699 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -255,6 +255,11 @@ bool try_release_extent_mapping(struct folio *folio, gfp_t mask);
>   int try_release_extent_buffer(struct folio *folio);
>   
>   int btrfs_read_folio(struct file *file, struct folio *folio);
> +#ifdef CONFIG_BTRFS_DEBUG
> +void btrfs_check_folio_write_protected(struct folio *folio);
> +#else
> +static inline void btrfs_check_folio_write_protected(struct folio *folio) { }
> +#endif
>   void extent_write_locked_range(struct inode *inode, const struct folio *locked_folio,
>   			       u64 start, u64 end, struct writeback_control *wbc,
>   			       bool pages_dirty);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index b47e2aa5071d..636196705fa3 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -775,19 +775,28 @@ static inline void inode_should_defrag(struct btrfs_inode *inode,
>   
>   static int extent_range_clear_dirty_for_io(struct btrfs_inode *inode, u64 start, u64 end)
>   {
> +	pgoff_t index = start >> PAGE_SHIFT;
>   	const pgoff_t end_index = end >> PAGE_SHIFT;
>   	struct folio *folio;
>   	int ret = 0;
>   
> -	for (pgoff_t index = start >> PAGE_SHIFT; index <= end_index; index++) {
> +	while (index <= end_index) {
>   		folio = filemap_get_folio(inode->vfs_inode.i_mapping, index);
>   		if (IS_ERR(folio)) {
>   			if (!ret)
>   				ret = PTR_ERR(folio);
> +			index++;
>   			continue;
>   		}
> +		/*
> +		 * We are about to compress the folio, so it must not be mmap
> +		 * writeable or we could corrupt the data as we attempt to
> +		 * compress it.
> +		 */
> +		btrfs_check_folio_write_protected(folio);
>   		btrfs_folio_clamp_clear_dirty(inode->root->fs_info, folio, start,
>   					      end + 1 - start);
> +		index = folio_next_index(folio);
>   		folio_put(folio);
>   	}
>   	return ret;
> @@ -877,11 +886,6 @@ static void compress_file_range(struct btrfs_work *work)
>   
>   	inode_should_defrag(inode, start, end, end - start + 1, SZ_16K);
>   
> -	/*
> -	 * We need to call clear_page_dirty_for_io on each page in the range.
> -	 * Otherwise applications with the file mmap'd can wander in and change
> -	 * the page contents while we are compressing them.
> -	 */

And I'm a total idiot not noticing this existing comment...

Otherwise it looks good to me.

Thanks a lot of pinning down a bug that I'm completely unfamiliar with.
Didn't notice folio_mkclean() has such an important role related to 
mmaped writes.

Thanks,
Qu

>   	ret = extent_range_clear_dirty_for_io(inode, start, end);
>   
>   	/*
> @@ -2317,6 +2321,13 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
>   	int ret;
>   
>   	ASSERT(folio_pos(locked_folio) == 0);
> +	/*
> +	 * If an mmap writer could modify the folio while we copy it into an
> +	 * inline extent we might see only part of their modification then
> +	 * wrongly mark it clean again after copying, losing that write. So the
> +	 * folio must be write protected here.
> +	 */
> +	btrfs_check_folio_write_protected(locked_folio);
>   
>   	if (btrfs_inode_can_compress(inode) &&
>   	    inode_need_compress(inode, 0, blocksize, true)) {

