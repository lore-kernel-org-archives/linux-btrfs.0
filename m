Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5B234EF17
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Mar 2026 21:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774647985; cv=none; b=GHzqjgkRc8NXjxrSgVMtGi3JIG+t3XL2JivNDRz8iZgLoUMm1RTB8DT+2CwW/Ai8p6DXTjdNm41r20/9GLmJXwC0q7hyTKk1oyVJpVQVaG/bx6ZyV2DcETOFQQ4xvu1eZJOXvFsAIJHiHBl7MuMp1igMK6FvQxi/FncV0ja1MY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774647985; c=relaxed/simple;
	bh=SQeUWl33c6QDsi9zu0TJJKbLRHn3yB32jLspSrqamZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jcg4MaiG8gzp/NyGTvVnUSiUbRwiZwpRBvlBDeEXy0XpzYlTaw9WgvULyjOyDGEE20EhZ1+0uyl0KUnaqYpccAwKlfRWp2pqapCu7eC8d2ic+6o0HOvdGVLfQh3ofrAGr2IUOvahDHGYRHJeOh+rSkslKfK208T7S8CNS44hNio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QvB7DzWK; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QvB7DzWK"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-486fd27754bso24250975e9.3
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Mar 2026 14:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774647982; x=1775252782; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=FA+vLxdI5HeF7c7rhynzB4yEqQYz3+SkFF3yOKC3P34=;
        b=QvB7DzWKqa8satP6FgAz0yW2b6kQNC711tGiFqLUogIQMlCJVApq7sy2iJTW+WAmhN
         765s55ggbMd39O8hdFVbr30TRf8ZL51tzKsef7U9BYMgljLdvCY8M2YsBOxy94SRPY94
         X5I6CCXlhjjEkKGNfqqrHAPOBSSviM3YXBxoZKmeHt+f1QQx7MlLT75ufgM4F3VGcdt4
         JwqLYeSMqB+FS9tfMjWJ6SkOZmGycFcXruquwTUQ7lBw4nnq48TazuPvydPcsHAGgARA
         b9rnu4lvOlR8fyAeb1WaLyXKvDqjB243KUTsIHg1+GQiyQW+fcvWU7edmkNCAAa7MpxN
         z8OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774647982; x=1775252782;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FA+vLxdI5HeF7c7rhynzB4yEqQYz3+SkFF3yOKC3P34=;
        b=GlIE/5bOYlzMshHq5lj+RrQqkdtlMnpWFxm8yQesYGk+XSSioyAVMl2R791OlPLo2J
         xDHP3g564m7SNt2n9aL4432B3EmX/QYVSfmuY+/p3xO6UXlNCbHvCFR+SixSGV4drSUM
         CKTlKt9szSpji11DUFqSFtpyFwdbb18scYQFxaouqLoIQb7KT6oPcsy7hCjHRXx3hVku
         Drh/4wG14oiKrO8MSGc1zImpv5yUD5ClFBEwnuCxeQu53KpCC7Kx2YNkjCRmID2CW0Qn
         8UCmcmt5AU4piY/ySASoZWw2daWGWS/c0svRDHryp3xJCHRDAtK0q18D468SmMqLwOr1
         Dymg==
X-Gm-Message-State: AOJu0YwXTGNfaOjWWz6HJJX1u+KeoJLuIra7J0EhI0CEbzFd8s9JnhOs
	OFSD+xz+0mqsRWIV6Ka7VSDXwCWp31TxxxFWOOYYN1kCZ8D8EqqsoTassz/Q9F9EF+U=
X-Gm-Gg: ATEYQzyrPkre3m/tvLEcdyQgjegvXknHI16XLAkw84Ftos3vsc7KWCdP6F4vWfDB9ED
	H1EUHHHT7HPsN/3yHD5AhNR4xBXTIj9wZyzSwcz1ZuO3QimJfLKubDwGRNSidcJdZr+SRuwP7Zg
	yCbQtAkzLuAV/J0v+wxzSbSe58Dv74xZYAbvvnHIVD6R98hyt8rqpCqZ75YaD1SO3AKbGombeBc
	v1D3GHD3fSGYtcvgpQBmnTgYhNUg1nXZu/awKeaeXIz2dSOVt6w+GaP+Te6xwoohaBDgBBeiVbw
	dou3+/nAoQye7SqszQ4y+oUaPYsSkJmNCVYVK+O2In25NwF+8I8/Lf9UP0FzuJXiWcL6LzgcWdm
	R/o3r3XKkF0FXNs1qbTHiDJGRbo/fSqqN64cDB8nbDEChZ2LS1Xz9gg/Crq26srTAUZuqTtAMJX
	AiXxjaFJt1dV1frI3BGzN8QhhMPTjrFUyMklkNygRcihmnB9VDFi1yGb/KVx9uBQ==
X-Received: by 2002:a05:600c:c109:b0:485:40ed:2d1 with SMTP id 5b1f17b1804b1-48727ec777emr51375695e9.17.1774647981798;
        Fri, 27 Mar 2026 14:46:21 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2427663acsm2619455ad.46.2026.03.27.14.46.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2026 14:46:20 -0700 (PDT)
Message-ID: <e51b3afa-751f-41e9-b454-3405252dc6e2@suse.com>
Date: Sat, 28 Mar 2026 08:16:11 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: Fix BTRFS arm64 tagged KASAN false-positive
To: Daniel J Blueman <daniel@quora.org>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, stable@vger.kernel.org
References: <20260327082419.12654-1-daniel@quora.org>
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
In-Reply-To: <20260327082419.12654-1-daniel@quora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/27 18:54, Daniel J Blueman 写道:
> When booting Linux 7.0-rc5 on a Qualcomm Snapdragon X1 with KASAN
> software tagging with a BTRFS filesystem, we see:
> 
> BUG: KASAN: invalid-access in xxh64_update (lib/xxhash.c:143 lib/xxhash.c:283)
> Read of size 8 at addr 7bff000804fe1000 by task kworker/u49:2/138
> Pointer tag: [7b], memory tag: [b2]
> 
> CPU: 0 UID: 0 PID: 138 Comm: kworker/u49:2 Not tainted 7.0.0-rc4+ #34 PREEMPTLAZY
> Hardware name: LENOVO 83ED/LNVNB161216, BIOS NHCN60WW 09/11/2025
> Workqueue: btrfs-endio-meta simple_end_io_work
> Call trace:
> show_stack (arch/arm64/kernel/stacktrace.c:501) (C)
> dump_stack_lvl (lib/dump_stack.c:122)
> print_report (mm/kasan/report.c:379 mm/kasan/report.c:482)
> kasan_report (mm/kasan/report.c:597)
> kasan_check_range (mm/kasan/sw_tags.c:86 (discriminator 1))
> __hwasan_loadN_noabort (mm/kasan/sw_tags.c:158)
> xxh64_update (lib/xxhash.c:143 lib/xxhash.c:283)
> btrfs_csum_update (fs/btrfs/fs.c:106)
> csum_tree_block (fs/btrfs/disk-io.c:103 (discriminator 3))
> btrfs_validate_extent_buffer (fs/btrfs/disk-io.c:389)
> end_bbio_meta_read (fs/btrfs/extent_io.c:3853 (discriminator 1))
> btrfs_bio_end_io (fs/btrfs/bio.c:152)
> simple_end_io_work (fs/btrfs/bio.c:388)
> process_one_work (./arch/arm64/include/asm/jump_label.h:36 ./include/trace/events/workqueue.h:110 kernel/workqueue.c:3281)
> worker_thread (kernel/workqueue.c:3353 (discriminator 2) kernel/workqueue.c:3440 (discriminator 2))
> kthread (kernel/kthread.c:436)
> ret_from_fork (arch/arm64/kernel/entry.S:861)
> 
> The buggy address belongs to the physical page:
> page: refcount:3 mapcount:0 mapping:f1ff00080055dee8 index:0x2467bd pfn:0x884fe1
> memcg:51ff000800e68ec0 aops:btree_aops ino:1
> flags: 0x9340000000004000(private|zone=2|kasantag=0x4d)
> raw: 9340000000004000 0000000000000000 dead000000000122 f1ff00080055dee8
> raw: 00000000002467bd 43ff00081d0cc6f0 00000003ffffffff 51ff000800e68ec0
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
> ffff000804fe0e00: 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b
> ffff000804fe0f00: 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b
>> ffff000804fe1000: b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2
> ^
> ffff000804fe1100: b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2
> ffff000804fe1200: b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2
> 
> This occurs as allocation in btrfs_alloc_page_array is from multiple
> discrete pages thus different KASAN tags by design, leading to a tag
> mismatch when linear access is used where the pages are physically
> contiguous.
> 
> Fix this by retagging all the EB pages with the same KASAN tag.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Daniel J Blueman <daniel@quora.org>
> Fixes: 397239ed6a6c ("btrfs: allow extent buffer helpers to skip cross-page handling")
> Changelog:
>   v3: Retag only when contiguous; fix build failure when generic KASAN configured
>   v2: https://lore.kernel.org/lkml/20260323061827.22903-1-daniel@quora.org/
>    - Retag pages rather than bypass linear access optimisation
>   v1: https://lore.kernel.org/lkml/20260319053413.14771-1-daniel@quora.org/

This one looks good to me for btrfs.

But still a question related to kasan_unpoison_range().

> ---
>   fs/btrfs/extent_io.c | 17 ++++++++++++++++-
>   1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 5f97a3d2a8d7..141092da871b 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3533,8 +3533,23 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
>   	if (uptodate)
>   		set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
>   	/* All pages are physically contiguous, can skip cross page handling. */
> -	if (page_contig)
> +	if (page_contig) {
> +#if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
> +		struct page *page = folio_page(eb->folios[0], 0);
> +		u8 tag = page_kasan_tag(page);
> +
> +		/*
> +		 * Since pages are from multiple allocations and physically
> +		 * contiguous allowing linear access, prevent KASAN warnings
> +		 * by retagging with the first tag
> +		 */
> +		for (int i = 1; i < num_extent_pages(eb); i++) {
> +			page_kasan_tag_set(page + i, tag);
> +			kasan_unpoison_range(page_address(page + i), PAGE_SIZE);

There is a LKP report that __kasan_unpoison_range() is not properly 
exported thus if btrfs is compiled as a module, we can not properly link 
the module.

   https://lore.kernel.org/linux-btrfs/202603240559.BNndaqHO-lkp@intel.com/

You may need to export __kasan_unpoison_range() to fix it, or explain 
why kasan_unpoison_range() is needed here.

AFAIK those pages are already unpoisoned at allocation, thus I'm not 
sure why we need to call kasan_unpoison_range() here again.

Thanks,
Qu

> +      }
> +#endif
>   		eb->addr = folio_address(eb->folios[0]) + offset_in_page(eb->start);
> +	}
>   again:
>   	xa_lock_irq(&fs_info->buffer_tree);
>   	existing_eb = __xa_cmpxchg(&fs_info->buffer_tree,

