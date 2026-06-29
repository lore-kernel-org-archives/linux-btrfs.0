Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3688731985C
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 20:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782763283; cv=none; b=bc7Qmx7mV5oP3X6zVMGRjlUgotVZwNzM6vrIF/CLHoUnyDdqww8QgBz0AcS9MPPijLF6sHIXB5xQFRlmxnQKSaPCJQ6Ycjxlx8Bx6Fm8Y4m/pzKOXEPkmCzztBzUTab3CH6/ceYIaNr5rK8u9Tr8OQNOq7sSMOWDz5W9Isc8XXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782763283; c=relaxed/simple;
	bh=F5UsF8blNj+MAIKtase0TimbmrK/C9lRkNPtmBnACt0=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=b0u38RRvRuu9SQ3Woep8fy61jue4hmMi8nURUgNV30zfo8mGzttJzODdXX8G57nhRGhnpAUXCWIvVSO2NbS/tm7Gr4mXfupPu8WgvFs8G4uS765oGl6akiUA6nzLR/ToQGNxMArsGg+WIbYLTlh6e6CpHfAqPEVqPQldhVcjWmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UHhzikC1; arc=none smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UHhzikC1"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-30cac93dfd7so1810109eec.1
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 13:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782763273; x=1783368073; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4XD8phgf43akGVTDQARcCjwmlWkMrNHOFtFyR4sgC2k=;
        b=UHhzikC1IEesxI/5jEreLzibxWId1gxm3x4vhxxyDNasAXm9nKBpsbSUw05a/pmh86
         ESk52TH/i1vofyCI6cxBOTIzwyXxyLuAr5jxjBPycKGSnhYkffWMcZCPQLn8ZgTSgCk8
         +394QPak9TepkRR9LpP+XdKOCqmByENRQh7wWgphgsud1I4Kh4D5CSSGyVzVUQ7qKIDG
         TFLUHjfE0HXaZdMH5A7vHkL50jzx5zgWv6ebM7qD7qJF9TL6MZ2XVyyq3FlUyoT6ZV+8
         iXJptXfehVrPDojVjyvc5pZaDp+VC4ig/E8xIXaaZXXGGI7qpgTqC+EfEqnbMShkDsAc
         YYTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782763273; x=1783368073;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4XD8phgf43akGVTDQARcCjwmlWkMrNHOFtFyR4sgC2k=;
        b=NPfRF9Zo97ddsJ+lgauWXDaxRaVCiaPAjncYVaq++iDfq/t38nPZZ8uDd0evx7MKi/
         PLhnoSt9MlMihX4JC+YbOvK53t0K0PYhYqzBZ+Oxs0Z5ij+vLLtY56yrLcJGlAfvY/yL
         gi7kHvqA2iKqiLANQUEJ8Ae2JjHIOPzejFHypt9RGvfmAnZCNZjIEum2dhOrQSW/wtUI
         rPuW0nyoIBlczbg0ekq6ETSGy9bIawnb+OgVrYtyNiqE+Iip7Xb/7dyqwJw1nxgt9mGJ
         oDZYZc4cebHkc94Xif+U5qgn6OvgkVKcbqsSHLY46jBQjwCyacz4hiAWJM4fFdewQREO
         bi+Q==
X-Forwarded-Encrypted: i=1; AHgh+Ro4EYcIx1bhvcWDx0lNl1QbeQyWgLtOs7eu4o1adjRm7N2ufCuYO+ccFfeCDU9HuXhNrTWkIkMs3ZI01A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz01mQb2FCQunhkYfmO2Wg2MUly05C/T+PD39xX1oMmWoxhJiVw
	gB7+z+AH3dCjO1XoVyfIYeqYVgusDusSmiMiUUFs0aBmy8Yl+88u6aKi
X-Gm-Gg: AfdE7cnSH3Brh36GSgrPRFXaYM0z0Z8QKsHNqRb7BZro+GbgJ52uHvKBsi2wS6STeCt
	EPfUEMNHCVTiZDbhO2CvMEsFgv0d2N1um6ekBlANk0h4kUKLDDaGRwWoKunnOqHSJtKbau12GLb
	900aHjaRDNBz7MOp1aioycd1EYqp2hKEpDK60jSmb2C2cGNU0WO/tqe5N/vQKT7FarOAYBHSps/
	h94rnQ4vPEkFeUsYP74hPreyTfgGQ9H6aVautFsUcJuYvG3N4nvm0CZJg+hJ2aF86G6+yVstlnB
	LFbZFw4Yr8TWR6WL4jXx0/RE0IkHs+tseQ2U4kTFm3zfSsBRqn1qeb1F+FLqEfAB43qB5R1jT4X
	2W3K7RgUVutS2hkUB3oGXnAYtWewYNUxxdNklmMyg9TESb4tJNcZ6RLO/wc9Oirxyo410Fs6M9c
	7NLkg1eSqwD6HEV14FL3kRR8oWDPNGfjPLQ8X+xmf2BjFQ3OPfou3chQCjHrC/ut+BXKEX9DlNU
	TDJJv3og0+19ORRmEov
X-Received: by 2002:a05:7300:8809:b0:30c:9bf9:d9c8 with SMTP id 5a478bee46e88-30ee1816d67mr415487eec.13.1782763272477;
        Mon, 29 Jun 2026 13:01:12 -0700 (PDT)
Received: from localhost ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30ee2f5e4dcsm629262eec.5.2026.06.29.13.01.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2026 13:01:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 29 Jun 2026 13:01:09 -0700
Message-Id: <DJLSU3WAYLS8.231KSC8VIWTBB@gmail.com>
Cc: "Chris Mason" <clm@fb.com>, "David Sterba" <dsterba@suse.com>, "open
 list" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs: raid56: use async_tx API for parity operations
From: "Rosen Penev" <rosenp@gmail.com>
To: "Qu Wenruo" <wqu@suse.com>, "Rosen Penev" <rosenp@gmail.com>,
 <linux-btrfs@vger.kernel.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260629023912.2102700-1-rosenp@gmail.com>
 <d96ddcc0-a62f-40e4-9f80-34929dc3bcfd@suse.com>
In-Reply-To: <d96ddcc0-a62f-40e4-9f80-34929dc3bcfd@suse.com>

On Sun Jun 28, 2026 at 10:11 PM PDT, Qu Wenruo wrote:
>
>
> =E5=9C=A8 2026/6/29 12:09, Rosen Penev =E5=86=99=E9=81=93:
>> Replace the kmap-local + synchronous library call + kunmap-local
>> pattern in raid56 compute and recovery paths with the async_tx API
>> (async_xor_offs, async_gen_syndrome, async_raid6_datap_recov,
>> async_raid6_2data_recov, async_memcpy).  The async_tx API provides
>> DMA offloading when a suitable engine is available and falls back to
>> the same software implementations (xor_gen, raid6_gen_syndrome, etc.)
>> otherwise.
>>
>> Step-loop operations inside each vertical stripe are chained as DMA
>> dependency chains with ASYNC_TX_FENCE.  The chains are then extended
>> across all sectors in a stripe so that the DMA engine can pipeline
>> the entire stripe's parity computation before the CPU waits for
>> completion.  For RMW writes, all sectors' parity generation is
>> issued as a single chain; for recovery reads, the recovery chains
>> for every sector are submitted together, then the CPU verifies
>> checksums and marks uptodate bits after a single wait.
>>
>> Each DMA chain is fully waited on before the caller touches any
>> buffer pages, so there is never an in-flight DMA operation during
>> cleanup.  For the typical stripe size of 4 KiB--64 KiB, per-operation
>> overhead from DMA submission may outweigh the offload benefit, making
>> the software fallback (which runs synchronously, returning NULL) the
>> common fast path.  This trade-off is inherent in the async_tx API's
>> unified interface, but on platforms with a DMA engine (e.g. Marvell
>> mv_xor) and larger sectors the batching provides measurable offload.
>
> Do you have any benchmark?
Not at this time.
>
> You do not need to do a full comprehensive workload, just some fixed
> basic workloads, then measure the runtime of the converted functions,
> and major entrances like rmw_rbio()/recover_rbio().
>
> And do you have ever run the fstests on a system with async offload?
No. The system in question runs Debian 12, so I assume it would be
trivial to do so.
>
>>
>> Also select ASYNC_RAID6_RECOV and ASYNC_MEMCPY in Kconfig so that
>> the async_tx function implementations are linked; previously the
>> code used the synchronous RAID6_PQ / XOR_BLOCKS libraries directly,
>> but async_tx functions require their own Kconfig symbols.
>>
>> Converted functions:
>>    - generate_pq_vertical_step() / generate_pq_vertical()
>>    - recover_vertical_step() / recover_vertical() / recover_sectors()
>>    - verify_one_parity_step() / verify_one_parity_sector()
>>    - finish_parity_scrub()
>>    - recover_scrub_rbio()
>>    - memcpy_from_bio_to_stripe()
>>    - raid56_parity_cache_data_folios()
>>
>> Removed the now-unused btrfs_raid_bio::finish_pointers field and
>> the no-longer-needed #include <linux/raid/pq.h> and
>> #include <linux/raid/xor.h>.
>>
>> Assisted-by: opencode:big-pickle
>> Signed-off-by: Rosen Penev <rosenp@gmail.com>
>> ---
>>   fs/btrfs/Kconfig  |   4 +-
>>   fs/btrfs/raid56.c | 654 ++++++++++++++++++++++++++++++++--------------
>>   fs/btrfs/raid56.h |   3 -
>>   3 files changed, 454 insertions(+), 207 deletions(-)
>>
>> diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
>> index 43dd8ef763b8..8223b40d8ecb 100644
>> --- a/fs/btrfs/Kconfig
>> +++ b/fs/btrfs/Kconfig
>> @@ -15,7 +15,9 @@ config BTRFS_FS
>>   	select ZSTD_DECOMPRESS
>>   	select FS_IOMAP
>>   	select RAID6_PQ
>> -	select XOR_BLOCKS
>> +	select ASYNC_RAID6_RECOV
>> +	select ASYNC_MEMCPY
>> +	select ASYNC_XOR
>>   	select XXHASH
>>   	depends on PAGE_SIZE_LESS_THAN_256KB
>>
>> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
>> index 00a01b97cc0c..6e98e46df752 100644
>> --- a/fs/btrfs/raid56.c
>> +++ b/fs/btrfs/raid56.c
>> @@ -8,11 +8,10 @@
>>   #include <linux/bio.h>
>>   #include <linux/slab.h>
>>   #include <linux/blkdev.h>
>> -#include <linux/raid/pq.h>
>>   #include <linux/hash.h>
>>   #include <linux/list_sort.h>
>> -#include <linux/raid/xor.h>
>>   #include <linux/mm.h>
>> +#include <linux/async_tx.h>
>>   #include "messages.h"
>>   #include "ctree.h"
>>   #include "disk-io.h"
>> @@ -154,7 +153,6 @@ static void free_raid_bio_pointers(struct btrfs_raid=
_bio *rbio)
>>   	kfree(rbio->stripe_pages);
>>   	kfree(rbio->bio_paddrs);
>>   	kfree(rbio->stripe_paddrs);
>> -	kfree(rbio->finish_pointers);
>>   }
>>
>>   static void free_raid_bio(struct btrfs_raid_bio *rbio)
>> @@ -231,18 +229,33 @@ int btrfs_alloc_stripe_hash_table(struct btrfs_fs_=
info *info)
>>   static void memcpy_from_bio_to_stripe(struct btrfs_raid_bio *rbio, uns=
igned int sector_nr)
>>   {
>>   	const u32 step =3D min(rbio->bioc->fs_info->sectorsize, PAGE_SIZE);
>> +	struct dma_async_tx_descriptor *tx =3D NULL;
>>
>>   	ASSERT(sector_nr < rbio->nr_sectors);
>>   	for (int i =3D 0; i < rbio->sector_nsteps; i++) {
>>   		unsigned int index =3D sector_nr * rbio->sector_nsteps + i;
>>   		phys_addr_t dst =3D rbio->stripe_paddrs[index];
>>   		phys_addr_t src =3D rbio->bio_paddrs[index];
>> +		struct async_submit_ctl submit;
>>
>>   		ASSERT(dst !=3D INVALID_PADDR);
>>   		ASSERT(src !=3D INVALID_PADDR);
>>
>> -		memcpy_page(phys_to_page(dst), offset_in_page(dst),
>> -			    phys_to_page(src), offset_in_page(src), step);
>> +		init_async_submit(&submit, ASYNC_TX_FENCE, tx, NULL, NULL, NULL);
>> +		tx =3D async_memcpy(phys_to_page(dst), phys_to_page(src),
>> +				  offset_in_page(dst), offset_in_page(src),
>> +				  step, &submit);
>
> This doesn't look sane at all.
>
> If async_memcpy() returned an @tx, the next iteration will just overwrite=
.
>
> I believe most LLM review can detect this problem, you may want to
> choose a better model.
Probably.
>> +	}
>> +	/*
>> +	 * All steps are chained via ASYNC_TX_FENCE.  issue_pending and
>> +	 * dma_wait_for_async_tx on the last descriptor walk the entire
>> +	 * chain, so earlier descriptors are submitted and waited on too.
>> +	 * If every step completed synchronously, tx is NULL and no wait
>> +	 * is needed.
>> +	 */
>> +	if (tx) {
>> +		async_tx_issue_pending(tx);
>> +		dma_wait_for_async_tx(tx);
>>   	}
>>   }
>>
>> @@ -1079,12 +1092,11 @@ static struct btrfs_raid_bio *alloc_rbio(struct =
btrfs_fs_info *fs_info,
>>   	rbio->stripe_paddrs =3D kzalloc_objs(phys_addr_t,
>>   					   num_sectors * sector_nsteps,
>>   					   GFP_NOFS);
>> -	rbio->finish_pointers =3D kcalloc(real_stripes, sizeof(void *), GFP_NO=
FS);
>>   	rbio->error_bitmap =3D bitmap_zalloc(num_sectors, GFP_NOFS);
>>   	rbio->stripe_uptodate_bitmap =3D bitmap_zalloc(num_sectors, GFP_NOFS)=
;
>>
>>   	if (!rbio->stripe_pages || !rbio->bio_paddrs || !rbio->stripe_paddrs =
||
>> -	    !rbio->finish_pointers || !rbio->error_bitmap || !rbio->stripe_upt=
odate_bitmap) {
>> +	    !rbio->error_bitmap || !rbio->stripe_uptodate_bitmap) {
>>   		free_raid_bio_pointers(rbio);
>>   		kfree(rbio);
>>   		return ERR_PTR(-ENOMEM);
>> @@ -1385,49 +1397,98 @@ static inline void *kmap_local_paddr(phys_addr_t=
 paddr)
>>   	return kmap_local_page(phys_to_page(paddr)) + offset_in_page(paddr);
>>   }
>>
>> -static void generate_pq_vertical_step(struct btrfs_raid_bio *rbio, unsi=
gned int sector_nr,
>> -				      unsigned int step_nr)
>> +/*
>> + * The page/offset array model used by the async_tx helpers below repla=
ces the
>> + * old kmap-local pointer array.  Each entry in pages[] + offsets[] rep=
resents
>> + * what was previously a single kmap_local_paddr() return value.
>> + *
>> + * For example, the old pattern:
>> + *   pointers[i] =3D kmap_local_paddr(paddr);
>> + *   raid6_gen_syndrome(..., pointers);
>> + *   kunmap_local(pointers[i]);
>> + *
>> + * becomes:
>> + *   pages[i] =3D phys_to_page(paddr);
>> + *   offsets[i] =3D offset_in_page(paddr);
>> + *   async_gen_syndrome(pages, offsets, ...);
>> + *
>> + * The async_tx API handles any necessary kmap internally.
>> + */
>
> What the comment is for? There is no code.
Probably stale from various iterations.
>
> If you want to explain the change, commit message is your choice.
>
>> +
>> +/*
>> + * Maximum number of sectors per stripe.
>> + * BTRFS_STRIPE_LEN (64 KiB) divided by the minimum sector size (PAGE_S=
IZE,
>> + * typically 4 KiB) gives at most 16 entries.  If stripe length ever ch=
anges,
>> + * update this to BTRFS_STRIPE_LEN >> fs_info->sectorsize_bits.
>> + */
>> +#define RECOVER_MAX_STRIPE_SECTORS 16
>
> Leave a new line between macro and function.
>
> Move the macro either at the beginning of the file, or just before where
> it is utilized.
>
> And do not use immediate number, use (BTRFS_STRIPE_LEN /
> BTRFS_MIN_BLOCKSIZE) instead.
Sure.
>
>> +static struct dma_async_tx_descriptor *
>> +generate_pq_vertical_step(struct btrfs_raid_bio *rbio, unsigned int sec=
tor_nr,
>> +			  unsigned int step_nr,
>> +			  struct page **pages, unsigned int *offsets,
>> +			  struct dma_async_tx_descriptor *depend_tx)
>>   {
>> -	void **pointers =3D rbio->finish_pointers;
>>   	const u32 step =3D min(rbio->bioc->fs_info->sectorsize, PAGE_SIZE);
>> -	int stripe;
>>   	const bool has_qstripe =3D rbio->bioc->map_type & BTRFS_BLOCK_GROUP_R=
AID6;
>> +	struct async_submit_ctl submit;
>> +	struct dma_async_tx_descriptor *tx;
>> +	int stripe;
>>
>> -	/* First collect one sector from each data stripe */
>> -	for (stripe =3D 0; stripe < rbio->nr_data; stripe++)
>> -		pointers[stripe] =3D kmap_local_paddr(
>> -				sector_paddr_in_rbio(rbio, stripe, sector_nr, step_nr, 0));
>> +	for (stripe =3D 0; stripe < rbio->nr_data; stripe++) {
>> +		phys_addr_t paddr =3D sector_paddr_in_rbio(rbio, stripe, sector_nr, s=
tep_nr, 0);
>>
>> -	/* Then add the parity stripe */
>> -	pointers[stripe++] =3D kmap_local_paddr(rbio_pstripe_paddr(rbio, secto=
r_nr, step_nr));
>> +		pages[stripe] =3D phys_to_page(paddr);
>> +		offsets[stripe] =3D offset_in_page(paddr);
>> +	}
>> +
>> +	{
>> +		phys_addr_t paddr =3D rbio_pstripe_paddr(rbio, sector_nr, step_nr);
>> +
>> +		pages[stripe] =3D phys_to_page(paddr);
>> +		offsets[stripe] =3D offset_in_page(paddr);
>> +	}
>
> A code block for what? Just to keep paddr as a local variable?
>
> Just big NO NO, declare @paddr at the beginning of the function and
> remove the brackets.
Will do.
>
>> +	stripe++;
>>
>>   	if (has_qstripe) {
>> -		/*
>> -		 * RAID6, add the qstripe and call the library function
>> -		 * to fill in our p/q
>> -		 */
>> -		pointers[stripe++] =3D kmap_local_paddr(
>> -				rbio_qstripe_paddr(rbio, sector_nr, step_nr));
>> +		phys_addr_t paddr =3D rbio_qstripe_paddr(rbio, sector_nr, step_nr);
>> +
>> +		pages[stripe] =3D phys_to_page(paddr);
>> +		offsets[stripe] =3D offset_in_page(paddr);
>>
>>   		assert_rbio(rbio);
>> -		raid6_gen_syndrome(rbio->real_stripes, step, pointers);
>> +		init_async_submit(&submit, ASYNC_TX_FENCE, depend_tx, NULL, NULL, NUL=
L);
>> +		tx =3D async_gen_syndrome(pages, offsets, rbio->real_stripes, step, &=
submit);
>>   	} else {
>> -		/* raid5 */
>> -		memcpy(pointers[rbio->nr_data], pointers[0], step);
>> -		xor_gen(pointers[rbio->nr_data], pointers + 1, rbio->nr_data - 1,
>> -				step);
>> +		init_async_submit(&submit, ASYNC_TX_FENCE | ASYNC_TX_XOR_ZERO_DST,
>> +				  depend_tx, NULL, NULL, NULL);
>> +		tx =3D async_xor_offs(pages[rbio->nr_data], offsets[rbio->nr_data],
>> +				    pages, offsets, rbio->nr_data, step, &submit);
>>   	}
>> -	for (stripe =3D stripe - 1; stripe >=3D 0; stripe--)
>> -		kunmap_local(pointers[stripe]);
>> +	return tx;
>
> I do not like the returning of an tx.
>
> Can't you just wait for the @tx to finish and keep the old void return ty=
pe?
>
>
>>   }
>>
>> -/* Generate PQ for one vertical stripe. */
>> -static void generate_pq_vertical(struct btrfs_raid_bio *rbio, int secto=
rnr)
>> +/*
>> + * Generate PQ for one vertical stripe, chaining into @depend_tx.
>> + * The caller must issue_pending + wait for the returned descriptor
>> + * (which may be NULL if the operation completed synchronously),
>> + * then call generate_pq_vertical_finish() to mark parity uptodate.
>> + */
>> +static struct dma_async_tx_descriptor *
>> +generate_pq_vertical(struct btrfs_raid_bio *rbio, int sectornr,
>> +		     struct page **pages, unsigned int *offsets,
>> +		     struct dma_async_tx_descriptor *depend_tx)
>>   {
>> -	const bool has_qstripe =3D (rbio->bioc->map_type & BTRFS_BLOCK_GROUP_R=
AID6);
>> +	struct dma_async_tx_descriptor *tx =3D depend_tx;
>>
>>   	for (int i =3D 0; i < rbio->sector_nsteps; i++)
>> -		generate_pq_vertical_step(rbio, sectornr, i);
>> +		tx =3D generate_pq_vertical_step(rbio, sectornr, i, pages, offsets, t=
x);
>
> Again, isn't @tx overwritten for each step?
>
> Also, sashiko is reporting several critical level problems, please refer
> to the review:
>
> https://sashiko.dev/#/patchset/20260629023912.2102700-1-rosenp%40gmail.co=
m
will check out.

Although based on Cristoph's comment, this should probably be abandoned.

I originally wanted to implement:

https://lore.kernel.org/all/20210106123738.GS6430@twin.jikos.cz/

The LLM told me it would result in worse performance as the async-tx API
requires batching. So I moved on to XOR.

My current setup for my RAID is md-raid5 > btrfs instead of the latter
directly as I assume the former performs better based on
/proc/interrupts output.

