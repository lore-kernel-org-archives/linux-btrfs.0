Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508CA2FE078
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 06:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774247612; cv=none; b=rKZ3IBnOeGASxjzLYNk1uhVN39wWoGKmdcQYIQW2kM0hX+OOXkhkF0gnxmLBL/5n8tpiJHLk2sVSQxfQfTo9Q4en/jFGHf1IWt37jKLPlH6kwgmslbe7lvOAMYIfm/DanVCkzbw8ndo9KZhWl6IHrdn8fQo8C52vidAZg6usvIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774247612; c=relaxed/simple;
	bh=TEU6DYkEQGRfvG4wSTCS9MsLZyPrDr/7yC/Q1P9jTVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IAF/F76KtPK3Hpr9fWvtrFNaQtwf/MzKw6GmJpJ1KiIMjkCAlV80TnLhmr6UX8XWthCREFQfQkZW6TQxp2gL0AH9EKvq0SY2MMINSRWtMNOsjiowVBrjHhjGDCi1R5jOhL8Kur0isoF5wuqJH6JhdTgEt/ZnsmgunLEtc++3he8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CZh92Vqp; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CZh92Vqp"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4853e1ce427so24938895e9.3
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Mar 2026 23:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774247610; x=1774852410; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=YGTwgK5nYvcCyOG242Pe97TZCZ73pNnFR7VrLz4Ca/Y=;
        b=CZh92Vqp71WT3svFN9TqQvz7NXrKGXJRRZSmU5xc3AZnwKVojxFqG5JRr9HODAvDBk
         Lk8Up1C3KQSF0Na/1GPWHhwIgeSRgDJB4Dex6i6hvHyNSu576AhrrltgIhb7K5hqIOgU
         zHGu9Liti7eg75xGEAB9ziENXA2iwCJJDTKfZNmSkto0T8Wbt+EmEodNGu3iqax3C/HS
         GOi0ak69EVPGLB4Odes5q0uetAnWPbcY/+M7AIiVyRGPr6Zm8jeEWsl4DTOYV3hfHxAA
         zXm/dN3GydoSgqEjqEHPsR6Pg4cY27rnnVpFncglC9orYo0ALW/bjluOdR3fLX9GVnP4
         /1bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774247610; x=1774852410;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YGTwgK5nYvcCyOG242Pe97TZCZ73pNnFR7VrLz4Ca/Y=;
        b=Xo2yvfRdN38mELsUqxLr/XppEfFIJQ02dh4VXqKyNbrs1wP1oErkfbodmOYEr3sZl6
         K8Kg3Hqo10SVTApUdrvQ4eiAlswygFB9BhaFLDxp/CROBXxtiGE+VYkoXBN+AmBJUUPo
         y1Xi99fmdfGYwGQZ/NkU1r02ZQGHmUOZq7xk/XrhWkhAuMtx01uGScQDV2TSb3xFohrS
         jHMrhrVukypL7pwToqEXqa04d+oCpLoDt0EeChxnnz2pBBYDfB2YteZTy5+N3DMcZt8U
         eGfu94AbbWxTeqt3PW/7gApJ9Vv9O4IjUGya+fMoXwtxdlvCrjDaUjZTiYs+HYjybHVu
         6IxA==
X-Gm-Message-State: AOJu0YyvxiYPf4eL86MUUm+6Zg7yeMcM8Z6w5Pf7KyVLrcVl9tkvMu0E
	c4KQLqWz86dClriE7a7JRNBtf5XmflCPX1ayuCD//Ou1PFn8nzYF0hmbVz3Dp3JcPYI=
X-Gm-Gg: ATEYQzypo0afdfX1Auy+1P2gBCZFf50hQRpz5YXYn+uBePGmnAyxxMHIKQlWdp71P2p
	tVPVGUpdUvsLDLkrt2A0Zztm635UUCDp3woEAV7P0ErctY3VZKu9vgO/T+dxYi1ianNbpzaeUn0
	ZZLw+6iDStHiSMZWH/uQWfM60Jtxl93AaFBERmIfNsIJkG14m9qApnCXDI9HyPXuy1XXUN9JAIg
	oFnmuAYe3Nh9BPHlBeuToDyxsRUKpuhf3HCpqzvnwziFV9rJ5oYjx3bJSGF6ktsxZl2XtzzWEku
	SP9pkTZ8U7zQN/0YVEcRF1W1Q4G+3VNjK8+aTiW9dfTnDcTSZx+oealtgzdy4MCuYGSyfHuauss
	psYfOX29Vu66UlEe/Q3k56wI9P8MfsJiZXCeupr8Zbd0k+ad89Aa+qwFQgV2D8BXmVujx1la79h
	UZ6qYeGTFmxc2BELb6YpyH/4uxPOKxmxZ3LVLXAtF+g/FipIT3fpM=
X-Received: by 2002:a05:600c:45c7:b0:485:3fd1:9936 with SMTP id 5b1f17b1804b1-486fede721amr142064755e9.5.1774247609567;
        Sun, 22 Mar 2026 23:33:29 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083516ab1sm127821195ad.5.2026.03.22.23.33.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2026 23:33:28 -0700 (PDT)
Message-ID: <78228756-0f0c-4ecb-86d5-da6613160a72@suse.com>
Date: Mon, 23 Mar 2026 17:03:23 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: Fix BTRFS arm64 tagged KASAN false-positive
To: Daniel J Blueman <daniel@quora.org>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, stable@vger.kernel.org
References: <20260323061827.22903-1-daniel@quora.org>
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
In-Reply-To: <20260323061827.22903-1-daniel@quora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/23 16:48, Daniel J Blueman 写道:
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
>   v2: Retag pages rather than bypass linear access optimisation
>   v1: https://lore.kernel.org/lkml/20260319053413.14771-1-daniel@quora.org/
> ---
>   fs/btrfs/extent_io.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 5f97a3d2a8d7..37836d685f21 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -10,6 +10,7 @@
>   #include <linux/spinlock.h>
>   #include <linux/blkdev.h>
>   #include <linux/swap.h>
> +#include <linux/kasan.h>
>   #include <linux/writeback.h>
>   #include <linux/pagevec.h>
>   #include <linux/prefetch.h>
> @@ -706,6 +707,18 @@ static int alloc_eb_folio_array(struct extent_buffer *eb, bool nofail)
>   	if (ret < 0)
>   		return ret;
>   
> +	/*
> +	 * Since separate page allocations are used for the same extent with
> +	 * linear addressing where physically contiguous, apply the same KASAN
> +	 * tag to prevent false-positive warnings when crossing page boundaries
> +	 */
> +	u8 tag = page_kasan_tag(page_array[0]);

We do not mix definition and code.

> +
> +	for (int i = 1; i < num_pages; i++) {
> +		page_kasan_tag_set(page_array[i], tag);

Please note that, at alloc_eb_folio_array() we have no idea if the 
folios are contig yet.

And if they are not contig, tagging them with the same tag will mask 
some real bugs.

To me, the proper re-tagging timing should be inside 
alloc_extent_buffer(), under the "if (page_contig)" branch.

Thanks,
Qu

> +		kasan_unpoison_range(page_address(page_array[i]), PAGE_SIZE);
> +	}
> +


>   	for (int i = 0; i < num_pages; i++)
>   		eb->folios[i] = page_folio(page_array[i]);
>   	eb->folio_size = PAGE_SIZE;

