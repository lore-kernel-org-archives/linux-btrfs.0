Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62501FECCD
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 09:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776332940; cv=none; b=JBQYjzVDZ2hJvDJ1uO6xq8abgDpMb3kDRZj+crzp0OAcWIbvZnBSsoTmwx4oSvcszMzHohViIU88SjQdQC1U2GBvvwesf5QTioaJ4C9jKEGjuKufnUGvCNH4pwnVlEHFoSASDDezXOqkb0JfnKcDQkKEQJFmnFXtjWZCq7RDlLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776332940; c=relaxed/simple;
	bh=HT/21bzsAGe1dhx+1K1MfgwP90BZ/4xG1XzJAV8siHA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=mkkO853yZrArEYMGBCdIFTLhyNkEq+9D/wPdzqCXEXjsrzwJYqFUh9TIlUbsYiRvSTU16SHEibSQ8/fuoE6TcazqjKHeJCQILsuuFl692NNQBmFFQmUjbYe/pL4TcHDVJpFnQ7pwT3YxGwRK6WZ2Eor72dRb0DwOaBs9x4iJZjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Vj0MGOYg; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Vj0MGOYg"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43cfd1f9fd1so4973992f8f.3
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 02:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776332937; x=1776937737; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1f/ekMgV/f5c3g93km/i/6lghd+MCSWPb0VwMykC5xU=;
        b=Vj0MGOYgvq1e26dkaQSJ6lhk/A0KBrl9ePcDUJSJFD/I5hmG2uNihpuc+Ery9bqsdO
         HdJ5y1xfvbWy7uqwLWtw17lGMU9SI2cHGlEdO7Be86EyunrdsPiq8mHHlbmdcl74VJFZ
         ABxfTsXHcfBSFdf79Oh3r3btS1d6a3vSg7Pidd20VgBvYjAtmGhQcHH4TpjK6pX2V04t
         TpUGVjaNPQJvHJGa6GnCfI82L87dgbjOLMJGKufl2Lb2J8PsoGCfAyQ/IrdpU+DOaldA
         Q+PNsxmvaKQatH4CLz1nCajWq93lCYNBKr6vmdIq19HRa2wXHOCeHBgeWVo1avgBziEo
         sjXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776332937; x=1776937737;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1f/ekMgV/f5c3g93km/i/6lghd+MCSWPb0VwMykC5xU=;
        b=Ky7gLDBUyMqsWoH4XW/5H+Id3tAFE6ZjzDe5AGO+QAl3yV0/FelwSRdEGMvepc4+rx
         hgrPZsz6arW2Df2LR8rqZcT5Auaz/Tg0vH+SOn4ap7A6dIJ/5cSVD7/fGhlq4OJPIzbf
         PF7ykVkIFm5Cov4xCv14Xmn2NsyCKpPSui7qMPmVbCldaRFrH7ST2zzPiui3axuIZtRt
         PLNGVeHICLdbkC3E5b9Mo6tbxsSHC34UuQnhwQpsQj2u0kj3kJY0ek+zpJuMxQDOiW7d
         6quhXRB5lrx3veGNF5tISUY+ezCCOXAoL5hhaZKhJKEF1/Ftj+xT+OKhN0dW9S5WRQPo
         yNnw==
X-Gm-Message-State: AOJu0YxEKkeVxVIPip6CFYKK8UOHa9M6AVedg0b+OBJoUA8g2fmtvELI
	HRqm1DA8CZTgAnC2Mz7DqQv9lLeIQIjrOazZCU01wiMo88q2OeRG9uIAuc6lTkRQauUh0So+saf
	GBAx/ePQ=
X-Gm-Gg: AeBDiesoqkpb0UFHIwR2essK13HvfB1Otd3nNCYmmXo22zRiW1Vo6eRmT90K0bYw8+z
	ySF5mKjFrYBM3gbzFrN4TzcMDRsECoX/QvrXTioi/BUeZiLmYX70kTMtHAGcOkQPthhxcS1a5V4
	s8hnY3UpWSvgr9ivWfXQE3iXDoOTIR7DQzXqR3xpY82lroQmMaDgQNndry6uIleLSIbKCj7YatC
	TT2TjAUO5ihA1cEG5EK5SaZ6YzcEmzXx8OwW02vZfBDChpPSDkQzTcNvt23GRbynCbOTO/n71JQ
	WJuKshdHX06Fd3iQ3yIrICavCJyOdvF9hhlglaPG3Eo7xSIDzwXmckH1mRgkwjFvrrh8GyhrbWX
	STupDNamozUrCxtPhV+PlgR6VRhqXB43rB8qKDQhhE8AZcINzJ0YbQ6MS9di9AuaVpXeSwqbHPu
	Y7wU3HjRGxossIjbW5B1X1MOkrHfJRNBhv6rCSiIE3bSzTCMv1rBBb8onVcLCfpg==
X-Received: by 2002:a05:600c:45c6:b0:488:a797:f0ac with SMTP id 5b1f17b1804b1-488d6ac2226mr307652165e9.28.1776332936929;
        Thu, 16 Apr 2026 02:48:56 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f6702f936sm4612290b3a.6.2026.04.16.02.48.54
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 02:48:55 -0700 (PDT)
Message-ID: <13ec4d41-49c0-4a09-a030-331457e43e17@suse.com>
Date: Thu, 16 Apr 2026 19:18:51 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: cleanup the ebs when the metadata writeback range
 failed
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
References: <81a6ca07ec1309239e263151a353ef9aa6703469.1776331057.git.wqu@suse.com>
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
In-Reply-To: <81a6ca07ec1309239e263151a353ef9aa6703469.1776331057.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/16 18:49, Qu Wenruo 写道:
> [WARNING]
> With the recent warning added by commit "btrfs: warn about extent buffer
> that can not be released", test case generic/388 can trigger the
> following warning:
> 
>   BTRFS: device fsid afbe908d-e199-4cd5-858c-a52800fed6f2 devid 1 transid 3940 /dev/mapper/test-scratch1 (253:2) scanned by mount (66844)
>   BTRFS info (device dm-2): first mount of filesystem afbe908d-e199-4cd5-858c-a52800fed6f2
>   BTRFS info (device dm-2): using crc32c checksum algorithm
>   BTRFS info (device dm-2): turning on async discard
>   BTRFS info (device dm-2): enabling free space tree
>   BTRFS critical (device dm-2 state E): emergency shutdown
>   BTRFS error (device dm-2 state E): error while writing out transaction: -30
>   BTRFS warning (device dm-2 state E): Skipping commit of aborted transaction.
>   BTRFS error (device dm-2 state EA): Transaction aborted (error -30)
>   BTRFS: error (device dm-2 state EA) in cleanup_transaction:2068: errno=-30 Readonly filesystem
>   BTRFS info (device dm-2 state EA): forced readonly
>   BTRFS warning (device dm-2 state EA): Skipping commit of aborted transaction.
>   BTRFS info (device dm-2 state EA): last unmount of filesystem afbe908d-e199-4cd5-858c-a52800fed6f2
>   ------------[ cut here ]------------
>   WARNING: fs/btrfs/disk-io.c:3304 at invalidate_btree_folios+0xd5/0x1a6 [btrfs], CPU#6: umount/66872
>   CPU: 6 UID: 0 PID: 66872 Comm: umount Tainted: G        W           7.0.0-rc6-custom+ #365 PREEMPT(full)  5804053f02137e627472d94b5128cc9fcb110e88
>   Tainted: [W]=WARN
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
>   Call Trace:
>    <TASK>
>    close_ctree+0x534/0x57a [btrfs 221aeb03de8eb7d91f94bd737554730626a2b838]
>    generic_shutdown_super+0x89/0x1a0
>    kill_anon_super+0x16/0x40
>    btrfs_kill_super+0x16/0x20 [btrfs 221aeb03de8eb7d91f94bd737554730626a2b838]
>    deactivate_locked_super+0x2d/0xb0
>    cleanup_mnt+0xdc/0x140
>    task_work_run+0x5a/0xa0
>    exit_to_user_mode_loop+0x123/0x4b0
>    do_syscall_64+0x288/0x7d0
>    entry_SYSCALL_64_after_hwframe+0x4b/0x53
>    </TASK>
>   ---[ end trace 0000000000000000 ]---
>   BTRFS warning (device dm-2 state EA): unable to release extent buffer 115638272 owner 1 refs 2 flags 0x7
>   BTRFS warning (device dm-2 state EA): unable to release extent buffer 115671040 owner 9 refs 2 flags 0x7
>   ...
>   BTRFS warning (device dm-2 state EA): unable to release extent buffer 116817920 owner 1 refs 2 flags 0x7
>   BTRFS warning (device dm-2 state EA): unable to release extent buffer 116834304 owner 1 refs 2 flags 0x7
> 
> [CAUSE]
> Inside btrfs_write_marked_extents(), we clear the @mark from
> @dirty_pages io tree.
> 
> For the above warning example, it's clearing EXTENT_DIRTY flag from
> transaction->dirty_pages io tree, which is utilized to track dirty
> metadata pages belonging to the current transaction.
> 
> But the EXTENT_DIRTY flag is converted to EXTENT_NEED_WAIT immediately,
> before we even started metadata writeback.
> 
> And furthermore, we rely on filemap_fdatawrite_range() ->
> btree_writepages() -> lock_extent_buffer_for_io() to clear the
> EXTENT_BUFFER_DIRTY flag for the involved extent buffers.
> Normally this call chain succeeds, so the involved ebs also have their
> DIRTY flag cleared.
> 
> But if filemap_fdatawrite_range() failed, there is no guarantee that all
> involved EBs are properly submitted, thus they may still have
> EXTENT_BUFFER_DIRTY flag left.
> 
> Those dirty EBs will stay there until detected by the recently
> introduced invalidate_btree_folios() and trigger the warning.
> 
> [FIX]
> Introduce a helper, btrfs_btree_cleanup_range(), to not only
> wait for any submitted ebs, but also call btrfs_clear_buffer_dirty()
> for any ebs inside the target range.
> 
> This will ensure transaction->dirty_pages have its EXTENT_DIRTY flag
> matching the underlying extent buffers' EXTENT_BUFFER_DIRTY flag, and
> avoid the warning inside invalidate_btree_folios().
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   fs/btrfs/extent_io.c   | 44 ++++++++++++++++++++++++++++++++++++++++++
>   fs/btrfs/extent_io.h   |  1 +
>   fs/btrfs/transaction.c | 11 ++++++++++-
>   3 files changed, 55 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 4eab0f9909e3..ea0f1a73d3e2 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2308,6 +2308,50 @@ void btrfs_btree_wait_writeback_range(struct btrfs_fs_info *fs_info, u64 start,
>   	}
>   }
>   
> +void __cold btrfs_btree_cleanup_range(struct btrfs_fs_info *fs_info,
> +					 u64 start, u64 end)
> +{
> +	struct eb_batch batch;
> +	unsigned long start_index = (start >> fs_info->nodesize_bits);
> +	const unsigned long end_index = (end >> fs_info->nodesize_bits);
> +
> +	eb_batch_init(&batch);
> +	/* Wait for writeback ebs first. */
> +	while (start_index <= end_index) {
> +		struct extent_buffer *eb;
> +		unsigned int nr_ebs;
> +
> +		nr_ebs = buffer_tree_get_ebs_tag(fs_info, &start_index, end_index,
> +						 PAGECACHE_TAG_WRITEBACK, &batch);
> +		if (!nr_ebs)
> +			break;
> +
> +		while ((eb = eb_batch_next(&batch)) != NULL)
> +			wait_on_extent_buffer_writeback(eb);
> +		eb_batch_release(&batch);
> +		cond_resched();
> +	}
> +	/* Clear remaining dirty ebs. */
> +	start_index = (start >> fs_info->nodesize_bits);
> +	while (start_index <= end_index) {
> +		struct extent_buffer *eb;
> +		unsigned int nr_ebs;
> +
> +		nr_ebs = buffer_tree_get_ebs_tag(fs_info, &start_index, end_index,
> +						 PAGECACHE_TAG_DIRTY, &batch);

With more runs, it turns out that PAGECACHE_TAG_DIRTY is not able to 
locate the dirty ebs.

And furthermore, there are still dirty ebs out of the cleaned up range.

So there are definitely something else.

Thanks,
Qu
> +		if (!nr_ebs)
> +			break;
> +
> +		while ((eb = eb_batch_next(&batch)) != NULL) {
> +			btrfs_tree_lock(eb);
> +			btrfs_clear_buffer_dirty(NULL, eb);
> +			btrfs_tree_unlock(eb);
> +		}
> +		eb_batch_release(&batch);
> +		cond_resched();
> +	}
> +}
> +
>   int btree_writepages(struct address_space *mapping, struct writeback_control *wbc)
>   {
>   	struct btrfs_eb_write_context ctx = { .wbc = wbc };
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index b284aee1bfb0..cf7afde0a78b 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -262,6 +262,7 @@ void extent_write_locked_range(struct inode *inode, const struct folio *locked_f
>   int btrfs_writepages(struct address_space *mapping, struct writeback_control *wbc);
>   int btree_writepages(struct address_space *mapping, struct writeback_control *wbc);
>   void btrfs_btree_wait_writeback_range(struct btrfs_fs_info *fs_info, u64 start, u64 end);
> +void __cold btrfs_btree_cleanup_range(struct btrfs_fs_info *fs_info, u64 start, u64 end);
>   void btrfs_readahead(struct readahead_control *rac);
>   int set_folio_extent_mapped(struct folio *folio);
>   void clear_folio_extent_mapped(struct folio *folio);
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 248adb785051..b19f64db9518 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1185,8 +1185,17 @@ int btrfs_write_marked_extents(struct btrfs_fs_info *fs_info,
>   		if (!ret && wait_writeback)
>   			btrfs_btree_wait_writeback_range(fs_info, start, end);
>   		btrfs_free_extent_state(cached_state);
> -		if (ret)
> +		if (ret) {
> +			/*
> +			 * The original mark of dirty_pages is cleared, but
> +			 * we hit an error, there is no guarantee the corresponding
> +			 * ebs have been submitted.
> +			 * So we need to wait for writeback range and also clear
> +			 * dirty extent buffers for the range.
> +			 */
> +			btrfs_btree_cleanup_range(fs_info, start, end);
>   			break;
> +		}
>   		cached_state = NULL;
>   		cond_resched();
>   		start = end + 1;

