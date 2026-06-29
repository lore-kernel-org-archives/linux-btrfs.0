Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670EA31715A
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 05:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782709914; cv=none; b=Wp0jCdtc5RYN8GHBn9tU8ujw7lVha8zG0aO2XGb7f527HuIwDS8lcUthGN511fQT/8E0Dhjxa1y3tnpAvWFezW6CfnJqU8upgmeh77ZIjH4BbyuCKVxTNgAQ6lfJUHO+WUmD8AWK2OS9qxlepGzxsO7y+PP+JpazAYtCfNtcnGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782709914; c=relaxed/simple;
	bh=zEH7vN25xXgJXTfsT89v37UX0cbgWQ3Lm6RgLE/qS8M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gofr9xT5W1b0LYO95Ix6G3Mua3lhsbenEnrknBIiXrebid/tP59lejt/9ZsK8JYuS4IQiBGCyvDcFLvQgmQDEEyd30tFspmWXqE8ZhI6Ew0VpW7JrRxilV6EKHuwxvIVXXaXUJkHZA2hHgvZFRFnY0xQxPs8ihZn5WVkNZIOlIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZwQ4J6Ic; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZwQ4J6Ic"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-493a97fad2fso9490275e9.0
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jun 2026 22:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782709911; x=1783314711; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=cXCIFla08eAVwLZojm2abl9Cvr2B9YfuV1ZnXVXpKKY=;
        b=ZwQ4J6IcV1conYMg/KwuIq6cQ1aZJ312XnKuT1obod5W+Lrcq+OsG6bozBS+orvWQq
         /ktNtadekLOAQ4kvKw3E6YQgJXAVVik3g0w9MGdNxRMY9bWhYsY/IQJ/mi1bHCoDyzDI
         Y69keQ4luISYy1l47Vlwa2U73Z9JOs6tSu8h/6o1E2DVITHuWRVkOItJbvFydZ6plFbL
         G8J8uc5f2a2IUO40DY5JGpfRgrxFLpHkQLeoYTtEmmf2Wxj2JgBjqPgOFvwSkhQffV2r
         eg/VaefNyTyMaVOKXlJT91JqsM+aory6JMIBcfTujaUggH8Suqa0Nz3AmjG639RmV5jc
         jz4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782709911; x=1783314711;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cXCIFla08eAVwLZojm2abl9Cvr2B9YfuV1ZnXVXpKKY=;
        b=iPTbCbJWAmuq5osDZoqq0m+2IherL+OXleButy9zvum3bNnXmkCHFqYLhnGFN7XdSZ
         uL0sTUZg1ilpiixgEnjj+ssOYFcmA+/HlGkofTV3riThMZB1A4Jv2980IDUAt03ZZ9it
         heTFKkmYKPUAQCmpA/eL2n+ohCziBwvSAJuWKFQtZB9ylUhsKlCWU4715fedrrDZlB2U
         MD33lOQf/oyM5DHmjnQI+IwLVATpNTpbnB/vUM1Z4ZcS7LgxlBHByZyrips9OHPucJtI
         dK3Kbcc3baeCzF6pBJ0AVzHOpJtI5Bvifk6YGSdhehDtg8FE4ptmusIhxeAF2wBXRrat
         HjmQ==
X-Forwarded-Encrypted: i=1; AFNElJ//XKvvDL4zEHj1x0SzuEIg4ImZFMZDacISvoLmHpwxEr6oZ1ZjcTw1W/jJHaW27KZmd6iudtHd8/3ypQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxSNYEjJY1quVGLK8v0ZdRLe7ZUyF8TV2dfiUAo+RPaprGozYJq
	L/9t9T66/Aj9m4z8VuNphSqvITPTrKA2Wj5/t3WvJDN4IuBKrs7aYVvTXDIm3khSgCs=
X-Gm-Gg: AfdE7cnOtL1eYH3HgfWfRQbvGmUowgVlhRozneP6sE0esPEC6kKuQMpcKvQ9bjIz1lK
	yuul9WHgtKSfsl8p0C67rb2SicxdNnBZL5yZD1LmHfwheUVKznES/S+qa/tUKN1NyekhnEIl9a8
	Ge0mDMC54nHqB9/nOq8kFyD5/AF76F8BhepAwjLCGLNDKCf2y6JYnplVCzXqaSotcpN4kJIV7p3
	6ugHUdcdbX2DeqPR3buunEX5Hi60VRFwgwQRO8sEMzhtA10qy8m9U6QX6w1odcmAd2lOOEH8u+X
	Lh6vjOQ48nBR7YNFlm72XojuB5KkObQ77lW2Oa0b1tLCKjFC3l43moKWqcSe4kRBxN38cOJ0ZEP
	zQZ6Tk83kgYOGGA3ktcPqFM12TnCbx9ztGq60Yj11fcYMnYSyGCdnQdYJMFcUFrWpwK/utTeabQ
	4SefF5Os1mG/vc0i02rau0LJW8yYKu7bs/NgvNUKA=
X-Received: by 2002:a05:600c:8b13:b0:492:3316:4b34 with SMTP id 5b1f17b1804b1-492668554afmr228478645e9.2.1782709910699;
        Sun, 28 Jun 2026 22:11:50 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c52eed6sm39804308eec.9.2026.06.28.22.11.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jun 2026 22:11:49 -0700 (PDT)
Message-ID: <d96ddcc0-a62f-40e4-9f80-34929dc3bcfd@suse.com>
Date: Mon, 29 Jun 2026 14:41:44 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: raid56: use async_tx API for parity operations
To: Rosen Penev <rosenp@gmail.com>, linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260629023912.2102700-1-rosenp@gmail.com>
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
In-Reply-To: <20260629023912.2102700-1-rosenp@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/29 12:09, Rosen Penev 写道:
> Replace the kmap-local + synchronous library call + kunmap-local
> pattern in raid56 compute and recovery paths with the async_tx API
> (async_xor_offs, async_gen_syndrome, async_raid6_datap_recov,
> async_raid6_2data_recov, async_memcpy).  The async_tx API provides
> DMA offloading when a suitable engine is available and falls back to
> the same software implementations (xor_gen, raid6_gen_syndrome, etc.)
> otherwise.
> 
> Step-loop operations inside each vertical stripe are chained as DMA
> dependency chains with ASYNC_TX_FENCE.  The chains are then extended
> across all sectors in a stripe so that the DMA engine can pipeline
> the entire stripe's parity computation before the CPU waits for
> completion.  For RMW writes, all sectors' parity generation is
> issued as a single chain; for recovery reads, the recovery chains
> for every sector are submitted together, then the CPU verifies
> checksums and marks uptodate bits after a single wait.
> 
> Each DMA chain is fully waited on before the caller touches any
> buffer pages, so there is never an in-flight DMA operation during
> cleanup.  For the typical stripe size of 4 KiB--64 KiB, per-operation
> overhead from DMA submission may outweigh the offload benefit, making
> the software fallback (which runs synchronously, returning NULL) the
> common fast path.  This trade-off is inherent in the async_tx API's
> unified interface, but on platforms with a DMA engine (e.g. Marvell
> mv_xor) and larger sectors the batching provides measurable offload.

Do you have any benchmark?

You do not need to do a full comprehensive workload, just some fixed 
basic workloads, then measure the runtime of the converted functions, 
and major entrances like rmw_rbio()/recover_rbio().

And do you have ever run the fstests on a system with async offload?

> 
> Also select ASYNC_RAID6_RECOV and ASYNC_MEMCPY in Kconfig so that
> the async_tx function implementations are linked; previously the
> code used the synchronous RAID6_PQ / XOR_BLOCKS libraries directly,
> but async_tx functions require their own Kconfig symbols.
> 
> Converted functions:
>    - generate_pq_vertical_step() / generate_pq_vertical()
>    - recover_vertical_step() / recover_vertical() / recover_sectors()
>    - verify_one_parity_step() / verify_one_parity_sector()
>    - finish_parity_scrub()
>    - recover_scrub_rbio()
>    - memcpy_from_bio_to_stripe()
>    - raid56_parity_cache_data_folios()
> 
> Removed the now-unused btrfs_raid_bio::finish_pointers field and
> the no-longer-needed #include <linux/raid/pq.h> and
> #include <linux/raid/xor.h>.
> 
> Assisted-by: opencode:big-pickle
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>   fs/btrfs/Kconfig  |   4 +-
>   fs/btrfs/raid56.c | 654 ++++++++++++++++++++++++++++++++--------------
>   fs/btrfs/raid56.h |   3 -
>   3 files changed, 454 insertions(+), 207 deletions(-)
> 
> diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
> index 43dd8ef763b8..8223b40d8ecb 100644
> --- a/fs/btrfs/Kconfig
> +++ b/fs/btrfs/Kconfig
> @@ -15,7 +15,9 @@ config BTRFS_FS
>   	select ZSTD_DECOMPRESS
>   	select FS_IOMAP
>   	select RAID6_PQ
> -	select XOR_BLOCKS
> +	select ASYNC_RAID6_RECOV
> +	select ASYNC_MEMCPY
> +	select ASYNC_XOR
>   	select XXHASH
>   	depends on PAGE_SIZE_LESS_THAN_256KB
>   
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index 00a01b97cc0c..6e98e46df752 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -8,11 +8,10 @@
>   #include <linux/bio.h>
>   #include <linux/slab.h>
>   #include <linux/blkdev.h>
> -#include <linux/raid/pq.h>
>   #include <linux/hash.h>
>   #include <linux/list_sort.h>
> -#include <linux/raid/xor.h>
>   #include <linux/mm.h>
> +#include <linux/async_tx.h>
>   #include "messages.h"
>   #include "ctree.h"
>   #include "disk-io.h"
> @@ -154,7 +153,6 @@ static void free_raid_bio_pointers(struct btrfs_raid_bio *rbio)
>   	kfree(rbio->stripe_pages);
>   	kfree(rbio->bio_paddrs);
>   	kfree(rbio->stripe_paddrs);
> -	kfree(rbio->finish_pointers);
>   }
>   
>   static void free_raid_bio(struct btrfs_raid_bio *rbio)
> @@ -231,18 +229,33 @@ int btrfs_alloc_stripe_hash_table(struct btrfs_fs_info *info)
>   static void memcpy_from_bio_to_stripe(struct btrfs_raid_bio *rbio, unsigned int sector_nr)
>   {
>   	const u32 step = min(rbio->bioc->fs_info->sectorsize, PAGE_SIZE);
> +	struct dma_async_tx_descriptor *tx = NULL;
>   
>   	ASSERT(sector_nr < rbio->nr_sectors);
>   	for (int i = 0; i < rbio->sector_nsteps; i++) {
>   		unsigned int index = sector_nr * rbio->sector_nsteps + i;
>   		phys_addr_t dst = rbio->stripe_paddrs[index];
>   		phys_addr_t src = rbio->bio_paddrs[index];
> +		struct async_submit_ctl submit;
>   
>   		ASSERT(dst != INVALID_PADDR);
>   		ASSERT(src != INVALID_PADDR);
>   
> -		memcpy_page(phys_to_page(dst), offset_in_page(dst),
> -			    phys_to_page(src), offset_in_page(src), step);
> +		init_async_submit(&submit, ASYNC_TX_FENCE, tx, NULL, NULL, NULL);
> +		tx = async_memcpy(phys_to_page(dst), phys_to_page(src),
> +				  offset_in_page(dst), offset_in_page(src),
> +				  step, &submit);

This doesn't look sane at all.

If async_memcpy() returned an @tx, the next iteration will just overwrite.

I believe most LLM review can detect this problem, you may want to 
choose a better model.
> +	}
> +	/*
> +	 * All steps are chained via ASYNC_TX_FENCE.  issue_pending and
> +	 * dma_wait_for_async_tx on the last descriptor walk the entire
> +	 * chain, so earlier descriptors are submitted and waited on too.
> +	 * If every step completed synchronously, tx is NULL and no wait
> +	 * is needed.
> +	 */
> +	if (tx) {
> +		async_tx_issue_pending(tx);
> +		dma_wait_for_async_tx(tx);
>   	}
>   }
>   
> @@ -1079,12 +1092,11 @@ static struct btrfs_raid_bio *alloc_rbio(struct btrfs_fs_info *fs_info,
>   	rbio->stripe_paddrs = kzalloc_objs(phys_addr_t,
>   					   num_sectors * sector_nsteps,
>   					   GFP_NOFS);
> -	rbio->finish_pointers = kcalloc(real_stripes, sizeof(void *), GFP_NOFS);
>   	rbio->error_bitmap = bitmap_zalloc(num_sectors, GFP_NOFS);
>   	rbio->stripe_uptodate_bitmap = bitmap_zalloc(num_sectors, GFP_NOFS);
>   
>   	if (!rbio->stripe_pages || !rbio->bio_paddrs || !rbio->stripe_paddrs ||
> -	    !rbio->finish_pointers || !rbio->error_bitmap || !rbio->stripe_uptodate_bitmap) {
> +	    !rbio->error_bitmap || !rbio->stripe_uptodate_bitmap) {
>   		free_raid_bio_pointers(rbio);
>   		kfree(rbio);
>   		return ERR_PTR(-ENOMEM);
> @@ -1385,49 +1397,98 @@ static inline void *kmap_local_paddr(phys_addr_t paddr)
>   	return kmap_local_page(phys_to_page(paddr)) + offset_in_page(paddr);
>   }
>   
> -static void generate_pq_vertical_step(struct btrfs_raid_bio *rbio, unsigned int sector_nr,
> -				      unsigned int step_nr)
> +/*
> + * The page/offset array model used by the async_tx helpers below replaces the
> + * old kmap-local pointer array.  Each entry in pages[] + offsets[] represents
> + * what was previously a single kmap_local_paddr() return value.
> + *
> + * For example, the old pattern:
> + *   pointers[i] = kmap_local_paddr(paddr);
> + *   raid6_gen_syndrome(..., pointers);
> + *   kunmap_local(pointers[i]);
> + *
> + * becomes:
> + *   pages[i] = phys_to_page(paddr);
> + *   offsets[i] = offset_in_page(paddr);
> + *   async_gen_syndrome(pages, offsets, ...);
> + *
> + * The async_tx API handles any necessary kmap internally.
> + */

What the comment is for? There is no code.

If you want to explain the change, commit message is your choice.

> +
> +/*
> + * Maximum number of sectors per stripe.
> + * BTRFS_STRIPE_LEN (64 KiB) divided by the minimum sector size (PAGE_SIZE,
> + * typically 4 KiB) gives at most 16 entries.  If stripe length ever changes,
> + * update this to BTRFS_STRIPE_LEN >> fs_info->sectorsize_bits.
> + */
> +#define RECOVER_MAX_STRIPE_SECTORS 16

Leave a new line between macro and function.

Move the macro either at the beginning of the file, or just before where 
it is utilized.

And do not use immediate number, use (BTRFS_STRIPE_LEN / 
BTRFS_MIN_BLOCKSIZE) instead.

> +static struct dma_async_tx_descriptor *
> +generate_pq_vertical_step(struct btrfs_raid_bio *rbio, unsigned int sector_nr,
> +			  unsigned int step_nr,
> +			  struct page **pages, unsigned int *offsets,
> +			  struct dma_async_tx_descriptor *depend_tx)
>   {
> -	void **pointers = rbio->finish_pointers;
>   	const u32 step = min(rbio->bioc->fs_info->sectorsize, PAGE_SIZE);
> -	int stripe;
>   	const bool has_qstripe = rbio->bioc->map_type & BTRFS_BLOCK_GROUP_RAID6;
> +	struct async_submit_ctl submit;
> +	struct dma_async_tx_descriptor *tx;
> +	int stripe;
>   
> -	/* First collect one sector from each data stripe */
> -	for (stripe = 0; stripe < rbio->nr_data; stripe++)
> -		pointers[stripe] = kmap_local_paddr(
> -				sector_paddr_in_rbio(rbio, stripe, sector_nr, step_nr, 0));
> +	for (stripe = 0; stripe < rbio->nr_data; stripe++) {
> +		phys_addr_t paddr = sector_paddr_in_rbio(rbio, stripe, sector_nr, step_nr, 0);
>   
> -	/* Then add the parity stripe */
> -	pointers[stripe++] = kmap_local_paddr(rbio_pstripe_paddr(rbio, sector_nr, step_nr));
> +		pages[stripe] = phys_to_page(paddr);
> +		offsets[stripe] = offset_in_page(paddr);
> +	}
> +
> +	{
> +		phys_addr_t paddr = rbio_pstripe_paddr(rbio, sector_nr, step_nr);
> +
> +		pages[stripe] = phys_to_page(paddr);
> +		offsets[stripe] = offset_in_page(paddr);
> +	}

A code block for what? Just to keep paddr as a local variable?

Just big NO NO, declare @paddr at the beginning of the function and 
remove the brackets.

> +	stripe++;
>   
>   	if (has_qstripe) {
> -		/*
> -		 * RAID6, add the qstripe and call the library function
> -		 * to fill in our p/q
> -		 */
> -		pointers[stripe++] = kmap_local_paddr(
> -				rbio_qstripe_paddr(rbio, sector_nr, step_nr));
> +		phys_addr_t paddr = rbio_qstripe_paddr(rbio, sector_nr, step_nr);
> +
> +		pages[stripe] = phys_to_page(paddr);
> +		offsets[stripe] = offset_in_page(paddr);
>   
>   		assert_rbio(rbio);
> -		raid6_gen_syndrome(rbio->real_stripes, step, pointers);
> +		init_async_submit(&submit, ASYNC_TX_FENCE, depend_tx, NULL, NULL, NULL);
> +		tx = async_gen_syndrome(pages, offsets, rbio->real_stripes, step, &submit);
>   	} else {
> -		/* raid5 */
> -		memcpy(pointers[rbio->nr_data], pointers[0], step);
> -		xor_gen(pointers[rbio->nr_data], pointers + 1, rbio->nr_data - 1,
> -				step);
> +		init_async_submit(&submit, ASYNC_TX_FENCE | ASYNC_TX_XOR_ZERO_DST,
> +				  depend_tx, NULL, NULL, NULL);
> +		tx = async_xor_offs(pages[rbio->nr_data], offsets[rbio->nr_data],
> +				    pages, offsets, rbio->nr_data, step, &submit);
>   	}
> -	for (stripe = stripe - 1; stripe >= 0; stripe--)
> -		kunmap_local(pointers[stripe]);
> +	return tx;

I do not like the returning of an tx.

Can't you just wait for the @tx to finish and keep the old void return type?


>   }
>   
> -/* Generate PQ for one vertical stripe. */
> -static void generate_pq_vertical(struct btrfs_raid_bio *rbio, int sectornr)
> +/*
> + * Generate PQ for one vertical stripe, chaining into @depend_tx.
> + * The caller must issue_pending + wait for the returned descriptor
> + * (which may be NULL if the operation completed synchronously),
> + * then call generate_pq_vertical_finish() to mark parity uptodate.
> + */
> +static struct dma_async_tx_descriptor *
> +generate_pq_vertical(struct btrfs_raid_bio *rbio, int sectornr,
> +		     struct page **pages, unsigned int *offsets,
> +		     struct dma_async_tx_descriptor *depend_tx)
>   {
> -	const bool has_qstripe = (rbio->bioc->map_type & BTRFS_BLOCK_GROUP_RAID6);
> +	struct dma_async_tx_descriptor *tx = depend_tx;
>   
>   	for (int i = 0; i < rbio->sector_nsteps; i++)
> -		generate_pq_vertical_step(rbio, sectornr, i);
> +		tx = generate_pq_vertical_step(rbio, sectornr, i, pages, offsets, tx);

Again, isn't @tx overwritten for each step?

Also, sashiko is reporting several critical level problems, please refer 
to the review:

https://sashiko.dev/#/patchset/20260629023912.2102700-1-rosenp%40gmail.com
