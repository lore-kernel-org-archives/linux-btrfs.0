Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A4446B5
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 00:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784075793; cv=none; b=dcF7iwE9d36ip5DWk2x3sDpwRbOPrMhGBbX+oiZ9w59XoGDkKCo2Rb2C9WDO2PNqDrB6kPEjp0zet8h6o9EkdKrqhBoSQeZ1SUdUKl2FP6e6/mY5aG5qUi6V43qwaKV4BWNIa7Pog8eN1eJ8mAaHVYi5PElEcq5D9h/o+xtheiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784075793; c=relaxed/simple;
	bh=UIfpi+rgyqLylhFLmfT9iY4mzbBgZuiTp+hiWxi4QUc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZsG+LvPYlbshHUQHFeDTHlluwweU+lUgKRU/O8qTG6QGPhc+nn+W3cUqBuJ5McR0kKbaJmeF8J95xQceIalYIs5JzN/oEONBgaSZa+oHJ9X6u2Qx93kJyyFFH7y06tj6uW/IYFhUpt1+BLJLWoimuHekssySx5aRBfIq8sGWw7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RskYTDh/; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RskYTDh/"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-493ba701891so12268405e9.3
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 17:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784075785; x=1784680585; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rAscYM0wdOrOKnbIbc3sjkISmgejxKyFJX7YQ2d+Wbo=;
        b=RskYTDh/yON0s6/MKLyhivuOFGz1K1Epcc5oSvNXdx+/yeUtgSPMqG8UGTXF8kQyuk
         o1xy+/wPVfu4ctqaKVP4QS8W+aibHgL0/u906DBJYbp08H28wrhnqAvXQPd0Sx2L9VD7
         A3UeVqJ0Ot6X4ml/DgVA14E53PtNmeU8kwvE66sK0D38sQpjou15R4eIBKtKNc7kZcxc
         EEACOiaE40wb6UeVBu4x9NJhvku0d4LuKjT17V/gv0LPExL2OaG2DDKhVEs8L+HpmFHA
         Da41LRc10yy6MJE1O6+Z73ykIyt81cULrCy+nW8BDRpSVOsNcvZBz5C5PNDQ2GZrCAhR
         gwyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784075785; x=1784680585;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rAscYM0wdOrOKnbIbc3sjkISmgejxKyFJX7YQ2d+Wbo=;
        b=jZTKW9ADQTVWh4s3fstrE6IBrS5dzBkYxWEGnSdjiNGhmchF/8q8rOyPHFjFZvWe9g
         w28MwT0Xp0hSH2lu1ABHP0DoZpF3ZZK8EsvB2Tvbqt22gwOM7UYGCKE2N18LP9KZ3ubY
         xz4H1yBaKzigSO9cAIZCnJsfKX5ovLM5gBfh2d9STBGNjpEKaMT2C53Lno+Z7wR9AK/b
         eDOMScv3GCf2x+WnZsAdW6ZF7B9X1E9J6p4AfiiVqSMCs7LYdOjvQbBz5v/l+4qxfqX5
         I3m9oTS976Mg8xUHdUehUF8vpVTZEniRt18UsPbqrxUHQEywWZofd/lp603CeT3mnoJj
         rb4A==
X-Forwarded-Encrypted: i=1; AHgh+Rr4aSunuTPGQmf9VSpjoDw8kC0R7iCWc2AToCDj21OHgI0jPsxE6gzUQ6BOIL9v7bipbes+wv/Z7iKjfg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw291ECmsi1a3MTeBh7G2gtm9vRQqr37T7N4ELMGnq6kHbRhmx9
	uVmEEUhhe9A1lWVXgIJPPwcXKVMDVg8o+VRk314bpBRnUu1F+tUZ0eIQPIFi5yYlHc0=
X-Gm-Gg: AfdE7cneRCfg8kh13ba/mpXlvg6ujCjgsz0cjOlyrgK6PHXN1+Ombz3H+ujGfNqCS1y
	+wbSJsNmKIY3RSqhbRT7DUFQrEOmIFzbPukVl0dPOg8P1enwutru+5EG2c7rjYxWwIkEUb0ZXG/
	cOI5TJdAXaB4GFDI67Yd5VbOyRWM/desLtoH69OlCecfYqYyEwkdw91JlSwec5zet8f1XIAqpTj
	y2Y72QUfets10oo7KBfTtGq4GegTjykEWAN52WLBq/xI+c4PVJYAc0WaMM0qCD5I9QktD/5Lln0
	o2k7N8XlWegWXo7cET58IK0d3qGG4kLaptNp5GcbTolTXQqLyTvvfkWw5CY7R+++dO0/fDWSj5N
	LT6kfL6+jvVeTJLER0J0hddoU7+ErJKdHpGh3dS2ST2sJjCJ+2J54WVimVk+79c8Zc0dtrKtEWp
	keXv1Bpw==
X-Received: by 2002:a05:600c:2e15:b0:493:eb71:5cc6 with SMTP id 5b1f17b1804b1-493f88280bamr99414865e9.27.1784075785237;
        Tue, 14 Jul 2026 17:36:25 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b659c865asm92137543c88.11.2026.07.14.17.36.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2026 17:36:24 -0700 (PDT)
Message-ID: <6b84c548-4ccd-443a-bc3c-586df797ed0f@suse.com>
Date: Wed, 15 Jul 2026 10:06:19 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: write-protect folios during data writeback
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
Cc: willy@infradead.org
References: <e4721e5fdeec2f5a448c6bf25d896d58d35406bb.1784074799.git.boris@bur.io>
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
In-Reply-To: <e4721e5fdeec2f5a448c6bf25d896d58d35406bb.1784074799.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/15 09:51, Boris Burkov 写道:
> commit 095be159f3eb ("btrfs: unify folio dirty flag clearing") replaced
> the folio_clear_dirty_for_io() call in extent_write_cache_pages() with a
> plain folio_test_dirty() check. Besides clearing the dirty flag,
> folio_clear_dirty_for_io() also calls folio_mkclean(), which write-protects
> the shared mmap PTEs mapping the folio. Note that we still do call
> folio_clear_dirty_for_io() later in submit_one_sector() when we clear
> dirty on the last sector of the folio (the only sector for non-subpage
> cases). But we lost this early call in extent_write_cache_pages().
> 
> Without the extra write-protection, a process with the file mmap-ed can
> modify a sector while it is being used by writeback in a way that
> expects a stable folio (checksumming, compressing, copying, etc...)
> without faulting, which manifests as a handful of concrete bugs.
> 
> 1. For large folios or subpage sectorsize, it is possible to submit a bio
> which does not cover the whole folio. When this happens, we will have a
> bio in flight for a folio that we have *not* called
> folio_clear_dirty_for_io() on. If a task with an existing mmap-ed PTE
> writes (without faulting..) in this window, it can result in
> corruptions. If the write arrives while the checksumming or writing itself
> is underway, this can result in an invalid checksum and later corruption
> reports on read. If the write arrives after checksumming/writing is done
> but before the last sector dirty is cleared, then the write is present
> in page cache but doesn't affect the dirty tracking and will be lost
> when the the folio is fully finished being submitted and the dirty bit
> is cleared. This results in losing the write even if fsync() is called.
> 
> 2. For zoned submissions which are done in batch separate from the main
> extent_writepage() loop, we also risk csum violations for those
> submissions. Zoned writes are clamped to max_zone_append_size and are
> not aligned with folios, so a submission can span two folios. The first
> folio being processed in extent_write_cache_pages() will call
> extent_write_locked_range() which will submit the partial range of the
> next folio, while the rest of that folio could still be dirty. So
> clearing dirty on the submitted sectors doesn't call
> folio_clear_dirty_for_io() and we have the same issue. Since
> extent_write_cache_pages() skips these batch submitted folios (they are
> already marked for writeback from submission by the preceding folio), we
> must add the extra write protection in lock_delalloc_folios().
> 
> 3. For inline extents this will subtly risk losing writes that happen
> after/while we copy the inline extent but before we clear dirty on
> the folio.
> 
> 4. For folios spanning EOF, mmap could tamper with the zeroed bytes past
> EOF and cause them to be persisted where future faults would improperly
> see them instead of zeros.
> 
> 5. Finally, for compressed extents, we risk modifying the folios while we
> work on compressing them which will result in corrupted compressed data.
> Specifically, in run_delalloc_compressed() we queue up work to do
> compress_file_range() in BTRFS_COMPRESSION_CHUNK_SIZE (512K) chunks which
> will call btrfs_folio_clamp_clear_dirty() on the range. For non-subpage,
> this will always clear the whole folio, safely. For subpage, we risk a
> partial clear here as well. In particular, imagine a 2M folio broken up
> into 512K chunks of work which might start compression work on one chunk
> before all the chunks compress_file_range() workers have gotten far
> enough to finish clearing all the dirty bitmaps of the folio and getting
> to folio_clear_dirty_for_io(). Large folios on the edges of submission
> ranges are similarly at risk to be only partly cleared.
> This particular gap was introduced by a second patch in the same series:
> commit a4ef54dbb576 ("btrfs: make extent_range_clear_dirty_for_io() to handle sector size < page size cases")
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

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> Changelog:
> v2:
> - improved changelog to cover more details of the conditions needed to
>    cause the bugs.
> 
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

