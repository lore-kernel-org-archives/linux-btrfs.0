Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC0D33A9F8
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2026 23:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785194025; cv=none; b=Zs8j4Zljy0pOblDLf30N9kc89G+hVA+vXaf+AltcZEjKo14QVE3DWkEkNww8IRygTqBtrVGE7m2kDu77DSSES0AJ2F3ffIOhmvD1NbdCpoA4z8IiMemG+RpaeHsa2WOeSuEhi7cwNAwoZyjNESqVy4WvMpChIAlxMq9KxLeERM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785194025; c=relaxed/simple;
	bh=VRYSrlTKDhXycG7+a7TC3EtuNWmYjWBtgfocalHv5eo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jcFO3MzCAsDMdqfQYWU/9rTlFZDD562x1mosGVQ8oO8pw5CkTpmdbWU6xnSIyItSW2KxDyXE6sZAyFm0VL0xWCwL9E6GgbYFDVpDDf6JWjXe7Ntdtmkt6eXWYerx6FcEz0qmEHf0ZRnPjYCtJ9OlHKNE0yTmoePOibU/OrOcc/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Xp4bHs0k; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Xp4bHs0k"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c160420289bso428432466b.0
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2026 16:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785194021; x=1785798821; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IHST5aazY4qzJ5QYiThDeJ2Vq7s3oHma7kDNNMs4uMc=;
        b=Xp4bHs0kMQWsXTbkneZcpn488nLPyzROFbdVciBzXw68ylFfPyw7FWHS+UzEplp+Ji
         i8pcVG5GvGINS+porX3D6jtQ8XDcHTlsMz9JJNd1SWTE+zA+Us6aINaCUfpzpeMh0UxP
         B2ktrqj0Pnf7lCf5k33xA0fcwlTuDX2utD9CaYOFkIORSxyLWYqnrJKZzeFoP7sNLM16
         BeKBg1bzBAMlJccTotU00KlgK+9c6Iccu0eBKubmCiFCtDijtsRnE0U34/031qbIvYwW
         nVvvP9AXtctEmA+UVDfXh5cKl7aFPSyB4QfOhfvexOA4YfuH91Pp24Bsjzc+ajJytdwZ
         F1Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785194021; x=1785798821;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IHST5aazY4qzJ5QYiThDeJ2Vq7s3oHma7kDNNMs4uMc=;
        b=ONcu4hTwciVZz81HFrSzyWPJ1URnTIQamZXiFDrjEuOrnL2M9lQvYWghejIdy87aRb
         anAQO0mxEKozatiPUFOpJ7icol4byTzw7SiIfJfFgdVV8fswIvY0fDyvVMrFa0wzPFks
         t0E6Vio6CIVlibGA77F0HvcSUdUnjjlnoh8pXEXU8FmiwshtraKPJ+hiLt0IR19G1Y83
         pAUWvy2BcgNef8CbIoYozmn73TMrrgCrtkjBcVmCxbqocQUaKCbCK7tB31rSYYV/OUcs
         dRapev8TgTLQZGXzBl2ngzC3gjvwCtN//sy58SuLhW0uz9ASt6Pf//j2VAagHmBNOzYV
         UI4Q==
X-Forwarded-Encrypted: i=1; AHgh+Rqn9SAnHXWEmoSoVuiQN69Ir7ipwrXM/iCDBk27Tq/jrlBtYJIXtWeDjTZ8csEaC53LWFdO47Np6RJjxQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/tPw9OBOxk731giLVB6+ockwHMU+nMyTmIiJeIK4xoYboESqS
	z4EJZShgtJ4qyH15sz3urlRFNvUxXNYmkN3qn7AczmFKTiXgRmN2+NtUwpg3ns4nc4XxWYXPJob
	j+vqbeosY0A==
X-Gm-Gg: AR+sD12qsMGR53pmgDSZhT5mpfJNUcR6XUJ5eLPa/jyOwZMb9DW0YGZfrdifBCW88pf
	PucJdomuLXnyY26EtU95h623l9Q+D3x0NY4jywYj6rEtWcDXOU2nQE1DAYEdNAYgCMQh19rDEuz
	ehEhriYo/k8kwZG/V6+C9c+nF3cjYM3IegdxADK2UIxQsegj4q4eadmrzOe5ExIEvL8CN2f9zGH
	8wOeV69tPsSZaSaZ7lXjCrtga86N3A7KjIqz9mn9siK+eFwmz0YpB5XzFu761dP71gsdaBSM6vw
	dbVdVYHXvLcF4vu5TfNk6PHJ3+4qaI7qT0WYdo9w7tWrljnj9BSE12Zttcmbj62ZwNf0stb5gv5
	de23ghL+MxxENd/BB8Gx8zvhpoLYFiXYAMwO+Xn1loisClT2NP4dSxgVV/w4BVQV6GhZ8UGA=
X-Received: by 2002:a17:907:807:b0:c1f:2b07:55aa with SMTP id a640c23a62f3a-c1f692298eemr41250966b.45.1785194020529;
        Mon, 27 Jul 2026 16:13:40 -0700 (PDT)
Received: from [10.86.128.104] ([149.22.87.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde81dcc1sm41814435ad.84.2026.07.27.16.13.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2026 16:13:39 -0700 (PDT)
Message-ID: <a38e5dff-47b8-40bb-a075-a2ae22ec7a5d@suse.com>
Date: Tue, 28 Jul 2026 08:43:31 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: trigger cow fixup via dirty_folio()
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
Cc: willy@infradead.org
References: <9f7a81cdd022d9e3f69d347a17c0a25438ccec14.1785131713.git.boris@bur.io>
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
In-Reply-To: <9f7a81cdd022d9e3f69d347a17c0a25438ccec14.1785131713.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/27 15:30, Boris Burkov 写道:
> The problem scenario:
> If we have a folio mmapped shared and then somebody does a dio read with
> that folio as the read destination, then it is possible that the dio
> will see a dirty destination page when it starts (and thus skip
> dirtying and just gup pin it) but then while it is doing the read, btrfs
> finishes writing it back and by the endio, the folio is clean. In that
> case, the dio read must re-dirty the folio with aops->dirty_folio():
> 
> btrfs_check_read_bio()
> |- __iomap_dio_bio_end_io() from btrfs_bio_end_io()
>     |- bio_check_pages_dirty()
>        |- bio_dirty_fn()
>           |- bio_release_pages(bio, true)
>              |- __bio_release_pages(bio, mark_dirty == true)
>                 |- folio_lock()
>                 |- folio_mark_dirty()
>                    |- aops->dirty_folio()
>                 |- folio_unlock()
> 
> A data block normally moves through writeback as follows:
> TASK
>    folio_lock
>    write              clean -> dirty bit + delalloc
>    folio_unlock
> WRITEBACK
>    for-each-dirty-folio:
>      folio_lock
>      run_delalloc     delalloc consumed  -> dirty bit + OE
>      submission       dirty bit consumed -> writeback bit + OE
>      folio_unlock
> ENDIO
>    endio              OE bytes accounted
>    OE finish          writeback -> clean; destroy OE
> 
> Three critical invariants that this path maintains are:
> I1. Any dirty block is covered by delalloc xor an ordered extent
> I2. Any dirty block covered by an OE will be submitted into that OE
> I3. Any dirty block already submitted into an OE will not be submitted
>      again into the same OE.
> 
> These ensure that the block will be written exactly once. It is clear
> that not reserving delalloc for the re-dirty case violates I1.
> 
> This situation, even without bs < folio_size, has long required btrfs to
> fixup such dirty pages during writeback with an asynchronous worker that
> is allowed to do this expensive work and writeback does not proceed for
> a folio while it is doing this work.
> 
> Commit 247e743cbe6e ("Btrfs: Use async helpers to deal with pages that have been improperly dirtied")
> introduced the COW fixup to catch exactly this class at writeback, way
> back in 2008.
> 
> Since then, there have been many advances to prevent most of the causes
> of such re-dirtying and we thought we could get away with removing the
> annoying cow-fixup in the hope of simplifying writeback for large folio
> support.
> 
> Commit b2a9f217ad3f ("btrfs: remove the COW fixup mechanism")
> Commit 4927b141877c ("btrfs: remove folio ordered flag and subpage bitmap")
> 
> Since it turns out this assumption was incorrect, as evidenced by the
> report and attendant reproducers, we must reintroduce the fixup concept.
> 
> This is of course critically further complicated by bs < folio_size. In
> that case, rather than just a folio dirty bit, we have a bitmap for the
> dirty blocks in the folio. And the (also broken) invariant is:
> I4. folio dirty IFF at least one block bitmap dirty.
> 
> The original report of a stall on a misinterpreted empty bitmap is
> exactly evidence of a violation of I4.
> 
> It is exactly because of bs < folio_size we don't want to simply revert the
> removal patches. The original fixup was not properly bs < folio_size
> aware, which motivated removal in the first place. So we wish to build a
> bs < folio_size aware fixup.
> 
> One other important detail from the old design, any normal write that
> happens after a re-dirty but before a fixup is racing with the cow fixup
> to do the delalloc reservation, therefore it must cancel the fixup state.
> If it arrives after the reservation exists, it will be a normal dirty
> overwrite. This critically informs the design in a pretty clear way.
> fixup requiring re-dirty has folio granularity, while cancellation has
> delalloc (block) granularity so while we only ever produce fixup in
> chunks of folios, we must be able to clear it in blocks. Therefore we
> must track the blocks needing fixup at block granularity.
> 
> The obvious way to do this is with a new bitmap in btrfs_folio_state,
> but it is desirable to avoid that if possible. Unfortunately, I don't
> think it is possible and the reason is subtle and leans on a sort of
> extreme reproducer, but I think can be explained relatively succinctly.
> 
> Consider a folio whose two halves will land in different ordered extents
> (can be accomplished with tricks using nodatasum) and a dio read is
> running with it as the shared mmap estimation.
> 
> 1. The front half:
>     a. folio comes clean on a normal write
>     b. dio read completes into the folio marking it fixup.
>     c. a write comes for the previous folio for a range extending into
>        this folio, this is a cancellation of the fixup which reserves
>        space.
>     d. writeback runs on the range *not* overlapping the folio. This half
>        remains dirty but is now covered by an OE and is awaiting
>        writeback running on its range to be submitted and finish the OE.
> 2. The back half:
>     a. the folio is part of an OE that gets far enough along to clear
>        writeback.
>     b. dio read completes into the folio marking it fixup.
> 
> After this, the folio's front half is dirty in the "normal" sense, it
> needs to be submitted to the OE waiting for it. It's a cancelled fixup.
> Meanwhile, the second half is a true fresh fixup. So at this point if we
> run writeback on this folio, we genuinely can't know what to do without
> block level information. If we submit it, we submit unreserved dirty
> from the back half. If we don't, we will never finish the OE waiting for
> it. So it's either a corruption or a deadlock.
> 
> Thus, the full high level design picture:
> 
> - btrfs_data_dirty_folio(): For out of band non-reserving dirties,
>    mark still-clean blocks inside EOF dirty and set their fixup bits
>    (the event carries no range, so every clean block is suspect).
>    Already-dirty blocks are covered or pending and are left alone.
> 
> - Writeback: skip fixup blocks and enqueue work for them
> 
> - writepage_fixup(): for each fixup block do the fixup reservation in a
>    worker, after which the blocks can be written back normally.
> 
> - Typical reserving write paths cancel fixup state for the ranges they
>    cover with btrfs_folio_cancel_fixup()
> 
> Link: https://lore.kernel.org/linux-btrfs/20260721191152.101118-1-borntraeger@linux.ibm.com/
> Signed-off-by: Boris Burkov <boris@bur.io>
> Assisted-by: LLM

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> Changelog:
> v2:
> - removed redundant llm defensive logic overhead in wb
> - removed redundant llm defensive logic overhead in worker
> - tried to streamline the dirtying/cleanup code better into helpers and
>    shared callers
> - removed sentinel for "reserving dirties"
> - trimmed down verbose comments and removed redundant comments
> - humanized logic and prose in comments
> - removed undefined jargon variable names (punt, fund, pending)
> - various other small cleanups
> 
>   fs/btrfs/btrfs_inode.h       |   1 +
>   fs/btrfs/disk-io.c           |   6 +-
>   fs/btrfs/extent_io.c         | 113 ++++++++++++++++++
>   fs/btrfs/fs.h                |  12 ++
>   fs/btrfs/inode.c             | 190 +++++++++++++++++++++++++++++-
>   fs/btrfs/subpage.c           | 219 ++++++++++++++++++++++++++++++++++-
>   fs/btrfs/subpage.h           |  41 ++++++-
>   include/trace/events/btrfs.h |  35 ++++++
>   8 files changed, 605 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 7fdc6c3fd066..037445586b31 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -600,6 +600,7 @@ int btrfs_prealloc_file_range_trans(struct inode *inode,
>   				    loff_t actual_len, u64 *alloc_hint);
>   int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct folio *locked_folio,
>   			     u64 start, u64 end, struct writeback_control *wbc);
> +int btrfs_queue_writepage_fixup(struct btrfs_inode *inode, struct folio *folio);
>   int btrfs_encoded_io_compression_from_extent(struct btrfs_fs_info *fs_info,
>   					     int compress_type);
>   int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 467075a0ebcb..98cfc8febddd 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1757,6 +1757,7 @@ static int read_backup_root(struct btrfs_fs_info *fs_info, u8 priority)
>   /* helper to cleanup workers */
>   static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
>   {
> +	btrfs_destroy_workqueue(fs_info->fixup_workers);
>   	btrfs_destroy_workqueue(fs_info->delalloc_workers);
>   	btrfs_destroy_workqueue(fs_info->workers);
>   	if (fs_info->endio_workers)
> @@ -1964,6 +1965,9 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
>   	fs_info->caching_workers =
>   		btrfs_alloc_workqueue(fs_info, "cache", flags, max_active, 0);
>   
> +	fs_info->fixup_workers =
> +		btrfs_alloc_ordered_workqueue(fs_info, "fixup", ordered_flags);
> +
>   	fs_info->endio_workers =
>   		alloc_workqueue("btrfs-endio", flags, max_active);
>   	fs_info->endio_meta_workers =
> @@ -1989,7 +1993,7 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
>   	      fs_info->endio_workers && fs_info->endio_meta_workers &&
>   	      fs_info->endio_write_workers &&
>   	      fs_info->endio_freespace_worker && fs_info->rmw_workers &&
> -	      fs_info->caching_workers &&
> +	      fs_info->caching_workers && fs_info->fixup_workers &&
>   	      fs_info->delayed_workers && fs_info->qgroup_rescan_workers &&
>   	      fs_info->discard_ctl.discard_workers)) {
>   		return -ENOMEM;
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index d119dcf9e34b..632637c49732 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1462,6 +1462,115 @@ static bool find_next_delalloc_bitmap(struct folio *folio,
>   	return true;
>   }
>   
> +/*
> + * Debug checks for fixup selection logic to help ensure the invariants
> + * we expect for fixup marking hold in practice.
> + *
> + * - A dirty block without a fixup bit is covered by delalloc or a running
> + *   ordered extent (it was dirtied by a reserving write path).
> + * - A block with a fixup bit is never covered by delalloc: every delalloc
> + *   setter holds the folio lock and cancels the fixup state of the blocks
> + *   it covers (btrfs_folio_set_dirty()) before releasing it.
> + */
> +static void debug_check_writepage_fixup(struct btrfs_inode *inode, u64 start,
> +				       u32 len, bool needs_fixup)
> +{
> +	struct btrfs_ordered_extent *ordered;
> +	bool delalloc;
> +
> +	if (!IS_ENABLED(CONFIG_BTRFS_DEBUG))
> +		return;
> +
> +	delalloc = btrfs_test_range_bit_exists(&inode->io_tree, start,
> +					       start + len - 1, EXTENT_DELALLOC);
> +	if (needs_fixup) {
> +		if (unlikely(delalloc))
> +			DEBUG_WARN("writeback: delalloc and fixup conflict. ino %llu start %llu",
> +				   btrfs_ino(inode), start);
> +	} else {
> +		if (delalloc)
> +			return;
> +
> +		ordered = btrfs_lookup_ordered_range(inode, start, len);
> +		if (unlikely(!ordered))
> +			DEBUG_WARN("dirty block, no delalloc, fixup, ordered. ino %llu start %llu",
> +				   btrfs_ino(inode), start);
> +		else
> +			btrfs_put_ordered_extent(ordered);
> +	}
> +}
> +
> +/*
> + * Handle folios dirtied without a delalloc reservation, e.g.
> + * O_DIRECT read into a MAP_SHARED mapping dirtying via set_page_dirty_lock().
> + *
> + * btrfs_data_dirty_folio() records the affected blocks in the fixup bitmap
> + * and the folio fixup flag and we check them here in writeback.
> + *
> + * Don't submit such blocks and queue work for the fixup worker to reserve
> + * space for them so that they can be submitted properly by writeback.
> + *
> + * Return 1 if the folio needed fixup, 0 if not, and a negative error code
> + * on error.
> + */
> +static noinline_for_stack int writepage_fixup(struct btrfs_inode *inode,
> +					      struct folio *folio,
> +					      struct btrfs_bio_ctrl *bio_ctrl)
> +{
> +	struct btrfs_fs_info *fs_info = inode_to_fs_info(&inode->vfs_inode);
> +	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
> +	const u32 sectorsize = fs_info->sectorsize;
> +	const u64 page_start = folio_pos(folio);
> +	bool found_fixup = false;
> +	unsigned int bit;
> +
> +	/*
> +	 * A folio was dirtied without calling aops->dirty_folio() which we
> +	 * explicitly assert is not allowed.
> +	 */
> +	if (unlikely(bitmap_empty(bio_ctrl->submit_bitmap, blocks_per_folio))) {
> +		DEBUG_WARN();
> +		btrfs_err_rl(fs_info,
> +			     "root %lld ino %llu folio %llu is dirty with an empty dirty bitmap",
> +			     btrfs_root_id(inode->root), btrfs_ino(inode),
> +			     folio_pos(folio));
> +		return -EUCLEAN;
> +	}
> +
> +	/* Cheap check on the folio flag. Set iff the fixup bitmap is non-empty. */
> +	if (likely(!folio_test_fixup_pending(folio)))
> +		return 0;
> +
> +	for_each_set_bit(bit, bio_ctrl->submit_bitmap, blocks_per_folio) {
> +		const u64 start = page_start + (bit << fs_info->sectorsize_bits);
> +		const bool needs_fixup = btrfs_folio_test_fixup(fs_info, folio,
> +								start, sectorsize);
> +
> +		debug_check_writepage_fixup(inode, start, sectorsize, needs_fixup);
> +		if (needs_fixup) {
> +			bitmap_clear(bio_ctrl->submit_bitmap, bit, 1);
> +			found_fixup = true;
> +		}
> +	}
> +	if (likely(found_fixup)) {
> +		btrfs_queue_writepage_fixup(inode, folio);
> +		folio_redirty_for_writepage(bio_ctrl->wbc, folio);
> +		if (bitmap_empty(bio_ctrl->submit_bitmap, blocks_per_folio)) {
> +			folio_unlock(folio);
> +			return 1;
> +		}
> +		return 0;
> +	}
> +	/* We should always find fixup if the folio fixup flag was set. */
> +	DEBUG_WARN();
> +	btrfs_err_rl(fs_info,
> +		     "root %lld ino %llu folio %llu is fixup with an empty fixup bitmap",
> +		     btrfs_root_id(inode->root), btrfs_ino(inode),
> +		     folio_pos(folio));
> +
> +	return -EUCLEAN;
> +}
> +
>   /*
>    * Do all of the delayed allocation setup.
>    *
> @@ -1514,6 +1623,10 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
>   	/* Save the dirty bitmap as our submission bitmap will be a subset of it. */
>   	btrfs_copy_subpage_dirty_bitmap(fs_info, folio, bio_ctrl->submit_bitmap);
>   
> +	ret = writepage_fixup(inode, folio, bio_ctrl);
> +	if (ret)
> +		return ret;
> +
>   	for_each_set_bitrange(start_bit, end_bit, bio_ctrl->submit_bitmap,
>   			      blocks_per_folio) {
>   		u64 start = page_start + (start_bit << fs_info->sectorsize_bits);
> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
> index 06b5884a9bcd..11503848a64d 100644
> --- a/fs/btrfs/fs.h
> +++ b/fs/btrfs/fs.h
> @@ -714,6 +714,8 @@ struct btrfs_fs_info {
>   	struct btrfs_workqueue *endio_write_workers;
>   	struct btrfs_workqueue *endio_freespace_worker;
>   	struct btrfs_workqueue *caching_workers;
> +
> +	struct btrfs_workqueue *fixup_workers;
>   	struct btrfs_workqueue *delayed_workers;
>   
>   	struct task_struct *transaction_kthread;
> @@ -1198,6 +1200,16 @@ static inline void btrfs_wake_unfinished_drop(struct btrfs_fs_info *fs_info)
>   	clear_and_wake_up_bit(BTRFS_FS_UNFINISHED_DROPS, &fs_info->flags);
>   }
>   
> +/*
> + * We use the folio owner_2 flag to indicate the folio has blocks that were
> + * dirtied without a space reservation and need the writepage fixup before
> + * writeback. For bs < folio_size the fixup bitmap tracks the affected
> + * blocks.
> + */
> +#define folio_test_fixup_pending(folio) folio_test_owner_2(folio)
> +#define folio_set_fixup_pending(folio) folio_set_owner_2(folio)
> +#define folio_clear_fixup_pending(folio) folio_clear_owner_2(folio)
> +
>   #define BTRFS_FS_ERROR(fs_info)	(READ_ONCE((fs_info)->fs_error))
>   
>   #define BTRFS_FS_LOG_CLEANUP_ERROR(fs_info)				\
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index bbcbd9c44a47..965ede5dbb21 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2824,6 +2824,163 @@ int btrfs_set_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
>   				    EXTENT_DELALLOC | extra_bits, cached_state);
>   }
>   
> +struct btrfs_writepage_fixup {
> +	struct folio *folio;
> +	struct btrfs_inode *inode;
> +	struct btrfs_work work;
> +};
> +
> +/*
> + * Do the real fixup work of reserving space for the blocks a folio's fixup
> + * state records. Queued by writepage_fixup() when writeback found the bits set.
> + *
> + * Since the fixup can be cancelled by a task dirtying with a reservation, we must
> + * re-check the state of fixup under the folio lock.
> + */
> +static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
> +{
> +	struct btrfs_writepage_fixup *fixup =
> +		container_of(work, struct btrfs_writepage_fixup, work);
> +	struct extent_state *cached_state = NULL;
> +	struct extent_changeset *data_reserved = NULL;
> +	unsigned long delalloc_bitmap[BITS_TO_LONGS(BTRFS_MAX_BLOCKS_PER_FOLIO)] = { 0 };
> +	struct folio *folio = fixup->folio;
> +	struct btrfs_inode *inode = fixup->inode;
> +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> +	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
> +	const u32 sectorsize = fs_info->sectorsize;
> +	const u64 page_start = folio_pos(folio);
> +	const u64 page_end = folio_next_pos(folio) - 1;
> +	unsigned int start_bit;
> +	unsigned int end_bit;
> +	unsigned int bit;
> +	bool reserved;
> +	int ret;
> +
> +	/*
> +	 * We would prefer to reserve under the folio lock when we know exactly
> +	 * which blocks need a reservation. Unfortunately, since the reservation
> +	 * can go into flushers which can go into writeback, which takes folio
> +	 * locks, that is not possible. Therefore, we have to reserve for the
> +	 * whole folio here, then release what we didn't end up needing once we
> +	 * figure it out.
> +	 *
> +	 * Also note the slightly strange error checking. If fixup is actually
> +	 * not set, we don't need to mark an error on the mapping. So hang on to
> +	 * ret until after we lock and find out if we actually care.
> +	 */
> +	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, page_start,
> +					   folio_size(folio));
> +	reserved = (ret == 0);
> +again:
> +	folio_lock(folio);
> +
> +	if (!folio->mapping || !folio_test_fixup_pending(folio))
> +		goto out;
> +	if (ret)
> +		goto out_error;
> +
> +	btrfs_lock_extent(&inode->io_tree, page_start, page_end, &cached_state);
> +
> +	for (bit = 0; bit < blocks_per_folio; bit++) {
> +		struct btrfs_ordered_extent *ordered;
> +		const u64 start = page_start + (bit << fs_info->sectorsize_bits);
> +
> +		if (test_bit(bit, delalloc_bitmap))
> +			continue;
> +		if (!btrfs_folio_test_fixup(fs_info, folio, start, sectorsize))
> +			continue;
> +		/*
> +		 * Any task that sets EXTENT_DELALLOC clears the fixup bits
> +		 * under the folio lock, so it should be impossible to observe
> +		 * both under the lock. Setting delalloc twice would wrongly
> +		 * double account the space.
> +		 */
> +		if (IS_ENABLED(CONFIG_BTRFS_DEBUG) &&
> +		    unlikely(btrfs_test_range_bit_exists(&inode->io_tree, start,
> +							 start + sectorsize - 1,
> +							 EXTENT_DELALLOC))) {
> +			DEBUG_WARN("fixup worker: delalloc and fixup conflict. ino %llu start %llu",
> +				   btrfs_ino(inode), start);
> +			btrfs_folio_clear_fixup(fs_info, folio, start, sectorsize);
> +			continue;
> +		}
> +		ordered = btrfs_lookup_ordered_range(inode, start, sectorsize);
> +		if (ordered) {
> +			trace_btrfs_writepage_fixup_defer(inode, ordered);
> +			btrfs_unlock_extent(&inode->io_tree, page_start,
> +					    page_end, &cached_state);
> +			folio_unlock(folio);
> +			btrfs_start_ordered_extent(ordered);
> +			btrfs_put_ordered_extent(ordered);
> +			goto again;
> +		}
> +		ret = btrfs_set_extent_delalloc(inode, start,
> +						start + sectorsize - 1, 0,
> +						&cached_state);
> +		if (ret) {
> +			btrfs_unlock_extent(&inode->io_tree, page_start,
> +					    page_end, &cached_state);
> +			goto out_error;
> +		}
> +		trace_btrfs_writepage_fixup_reserve(inode, start, sectorsize);
> +		btrfs_folio_clear_fixup(fs_info, folio, start, sectorsize);
> +		set_bit(bit, delalloc_bitmap);
> +	}
> +
> +	btrfs_unlock_extent(&inode->io_tree, page_start, page_end, &cached_state);
> +	goto out;
> +
> +out_error:
> +	/* Failure here is analagous to failure in writeback. */
> +	mapping_set_error(folio->mapping, ret);
> +	btrfs_folio_clear_fixup_dirty(fs_info, folio, page_start,
> +				      folio_size(folio));
> +out:
> +	if (reserved) {
> +		btrfs_delalloc_release_extents(inode, folio_size(folio));
> +		for_each_clear_bitrange(start_bit, end_bit, delalloc_bitmap,
> +					blocks_per_folio)
> +			btrfs_delalloc_release_space(inode, data_reserved,
> +				page_start + (start_bit << fs_info->sectorsize_bits),
> +				(end_bit - start_bit) << fs_info->sectorsize_bits,
> +				true);
> +	}
> +	folio_unlock(folio);
> +	folio_put(folio);
> +	kfree(fixup);
> +	extent_changeset_free(data_reserved);
> +	btrfs_add_delayed_iput(inode);
> +}
> +
> +/*
> + * Queue space reservation fixup work for blocks dirtied without a space reservation.
> + *
> + * Should be used by writeback while holding the folio locked.
> + */
> +int btrfs_queue_writepage_fixup(struct btrfs_inode *inode, struct folio *folio)
> +{
> +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> +	struct btrfs_writepage_fixup *fixup;
> +
> +	fixup = kzalloc_obj(*fixup, GFP_NOFS);
> +	if (!fixup)
> +		return -ENOMEM;
> +
> +	/*
> +	 * The worker's space reservation happens outside the folio lock, and
> +	 * folio->mapping cannot be trusted outside of it. Pin the inode
> +	 * alongside the folio.
> +	 */
> +	ihold(&inode->vfs_inode);
> +	folio_get(folio);
> +	btrfs_init_work(&fixup->work, btrfs_writepage_fixup_worker, NULL);
> +	fixup->folio = folio;
> +	fixup->inode = inode;
> +	btrfs_queue_work(fs_info->fixup_workers, &fixup->work);
> +	return 0;
> +}
> +
>   /*
>    * Clear the old accounting flags and set EXTENT_DELALLOC for the range.
>    *
> @@ -7519,6 +7676,12 @@ static void btrfs_invalidate_folio(struct folio *folio, size_t offset,
>   	folio_wait_writeback(folio);
>   	wait_subpage_spinlock(folio);
>   
> +	/*
> +	 * The invalidated blocks are going away; drop any fixup blocks among
> +	 * them, data included, as they have no space reservation.
> +	 */
> +	btrfs_folio_clear_fixup_dirty(fs_info, folio, page_start + offset, length);
> +
>   	/*
>   	 * For subpage case, we have call sites like
>   	 * btrfs_punch_hole_lock_range() which passes range not aligned to
> @@ -10584,6 +10747,31 @@ static const struct file_operations btrfs_dir_file_operations = {
>   	.setlease	= generic_setlease,
>   };
>   
> +/*
> + * The folio is going dirty without a btrfs delalloc space reservation.
> + * This requires a fixup before writeback which we might sleep so cannot
> + * run in this context, so we merely set state on the folio indicating it
> + * needs fixup before writeback.
> + *
> + * Note that there is no range in the input, so the whole folio is marked
> + * dirty and fixup.
> + */
> +static bool btrfs_data_dirty_folio(struct address_space *mapping,
> +				   struct folio *folio)
> +{
> +	struct btrfs_inode *inode = BTRFS_I(mapping->host);
> +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> +	const u64 page_start = folio_pos(folio);
> +	const u64 range_end = min_t(u64, folio_next_pos(folio),
> +				    round_up(i_size_read(&inode->vfs_inode),
> +					     fs_info->sectorsize));
> +
> +	if (range_end > page_start)
> +		btrfs_folio_set_fixup_dirty(fs_info, folio, page_start,
> +					    range_end - page_start);
> +	return filemap_dirty_folio(mapping, folio);
> +}
> +
>   /*
>    * btrfs doesn't support the bmap operation because swapfiles
>    * use bmap to make a mapping of extents in the file.  They assume
> @@ -10604,7 +10792,7 @@ static const struct address_space_operations btrfs_aops = {
>   	.launder_folio	= btrfs_launder_folio,
>   	.release_folio	= btrfs_release_folio,
>   	.migrate_folio	= btrfs_migrate_folio,
> -	.dirty_folio	= filemap_dirty_folio,
> +	.dirty_folio	= btrfs_data_dirty_folio,
>   	.error_remove_folio = generic_error_remove_folio,
>   	.swap_activate	= btrfs_swap_activate,
>   	.swap_deactivate = btrfs_swap_deactivate,
> diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
> index 2a9397be8116..a986a4bf61c9 100644
> --- a/fs/btrfs/subpage.c
> +++ b/fs/btrfs/subpage.c
> @@ -345,18 +345,57 @@ void btrfs_subpage_clear_uptodate(const struct btrfs_fs_info *fs_info,
>   	spin_unlock_irqrestore(&bfs->lock, flags);
>   }
>   
> +/*
> + * folio_mark_dirty() for a folio we are dirtying with a space reservation.
> + *
> + * dirtiers without a reservation use btrfs_data_dirty_folio().
> + */
> +static void btrfs_folio_mark_dirty(struct folio *folio)
> +{
> +	struct address_space *mapping = folio_mapping(folio);
> +
> +	if (!mapping || !mapping->host || !is_data_inode(BTRFS_I(mapping->host))) {
> +		folio_mark_dirty(folio);
> +		return;
> +	}
> +	if (folio_test_reclaim(folio))
> +		folio_clear_reclaim(folio);
> +	filemap_dirty_folio(mapping, folio);
> +}
> +
> +/*
> + * The set helper of the dirty ops, so it only runs for folios without a
> + * fixup bitmap: for those the folio flag is the whole fixup state, and this
> + * reserving write covers the block, so retire it.  Metadata never has the
> + * flag set and only pays the test.
> + */
> +static void btrfs_folio_mark_dirty_reserved(struct folio *folio)
> +{
> +	if (folio_test_fixup_pending(folio))
> +		folio_clear_fixup_pending(folio);
> +	btrfs_folio_mark_dirty(folio);
> +}
> +
>   void btrfs_subpage_set_dirty(const struct btrfs_fs_info *fs_info,
>   			     struct folio *folio, u64 start, u32 len)
>   {
>   	struct btrfs_folio_state *bfs = folio_get_private(folio);
> -	unsigned int start_bit = subpage_calc_start_bit(fs_info, folio,
> +	unsigned int dirty_bit = subpage_calc_start_bit(fs_info, folio,
>   							dirty, start, len);
> +	unsigned int fixup_bit = subpage_calc_start_bit(fs_info, folio,
> +							fixup, start, len);
> +	const unsigned int nbits = len >> fs_info->sectorsize_bits;
>   	unsigned long flags;
>   
>   	spin_lock_irqsave(&bfs->lock, flags);
> -	bitmap_set(bfs->bitmaps, start_bit, len >> fs_info->sectorsize_bits);
> +	bitmap_set(bfs->bitmaps, dirty_bit, nbits);
> +	/* Proper dirtying obviates the need for fixup. */
> +	bitmap_clear(bfs->bitmaps, fixup_bit, nbits);
> +	if (folio_test_fixup_pending(folio) &&
> +	    subpage_test_bitmap_all_zero(fs_info, folio, fixup))
> +		folio_clear_fixup_pending(folio);
>   	spin_unlock_irqrestore(&bfs->lock, flags);
> -	folio_mark_dirty(folio);
> +	btrfs_folio_mark_dirty(folio);
>   }
>   
>   static void folio_clear_tags(struct folio *folio)
> @@ -457,6 +496,175 @@ void btrfs_subpage_clear_writeback(const struct btrfs_fs_info *fs_info,
>   	spin_unlock_irqrestore(&bfs->lock, flags);
>   }
>   
> +void btrfs_subpage_clear_fixup(const struct btrfs_fs_info *fs_info,
> +			       struct folio *folio, u64 start, u32 len)
> +{
> +	struct btrfs_folio_state *bfs = folio_get_private(folio);
> +	unsigned int start_bit = subpage_calc_start_bit(fs_info, folio,
> +							fixup, start, len);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&bfs->lock, flags);
> +	bitmap_clear(bfs->bitmaps, start_bit, len >> fs_info->sectorsize_bits);
> +	if (subpage_test_bitmap_all_zero(fs_info, folio, fixup))
> +		folio_clear_fixup_pending(folio);
> +	spin_unlock_irqrestore(&bfs->lock, flags);
> +}
> +
> +/*
> + * In one pass under bfs->lock, mark every block with a clear dirty bit in the
> + * range both dirty and needing fixup.
> + *
> + * Only called from the dirty_folio callback, which owns the folio-level
> + * dirty flag; calling folio_mark_dirty() here would recurse.
> + *
> + * The folio fixup flag is set inside the same critical section: the
> + * dirty_folio callback can run without the folio lock (e.g. a dirty pte
> + * found while unmapping), so a concurrent writeback pass that observes the
> + * new bits when it copies the dirty bitmap (under bfs->lock) must also
> + * observe the flag, or it would submit the blocks without a reservation.
> + */
> +static void btrfs_subpage_set_fixup_dirty(const struct btrfs_fs_info *fs_info,
> +					  struct folio *folio, u64 start, u32 len)
> +{
> +	struct btrfs_folio_state *bfs = folio_get_private(folio);
> +	unsigned int dirty_bit = subpage_calc_start_bit(fs_info, folio,
> +							dirty, start, len);
> +	unsigned int fixup_bit = subpage_calc_start_bit(fs_info, folio,
> +							fixup, start, len);
> +	const unsigned int nbits = len >> fs_info->sectorsize_bits;
> +	unsigned long flags;
> +	bool marked = false;
> +
> +	spin_lock_irqsave(&bfs->lock, flags);
> +	for (unsigned int i = 0; i < nbits; i++) {
> +		if (test_bit(dirty_bit + i, bfs->bitmaps))
> +			continue;
> +		set_bit(dirty_bit + i, bfs->bitmaps);
> +		set_bit(fixup_bit + i, bfs->bitmaps);
> +		marked = true;
> +	}
> +	if (marked)
> +		folio_set_fixup_pending(folio);
> +	spin_unlock_irqrestore(&bfs->lock, flags);
> +}
> +
> +/*
> + * Mark the still-clean blocks of a folio dirty and needing fixup, for
> + * btrfs_data_dirty_folio().
> + *
> + * A subpage block size folio that is not uptodate is left alone: its clean
> + * blocks may hold content that was never read in, which must not be marked
> + * dirty.
> + */
> +void btrfs_folio_set_fixup_dirty(const struct btrfs_fs_info *fs_info,
> +				 struct folio *folio, u64 start, u32 len)
> +{
> +	if (!btrfs_is_subpage(fs_info, folio)) {
> +		if (!folio_test_dirty(folio))
> +			folio_set_fixup_pending(folio);
> +		return;
> +	}
> +	if (!folio_test_uptodate(folio))
> +		return;
> +	btrfs_subpage_set_fixup_dirty(fs_info, folio, start, len);
> +}
> +
> +/*
> + * Drop the fixup blocks inside the range: clear both their fixup and dirty
> + * bits.
> + *
> + * Fixup blocks carry no space reservation, so their fixup and dirty bits
> + * must be dropped together. Clearing only the fixup bit would leave a
> + * dirty block without a reservation which is not a valid state.
> + *
> + * Returns true if the folio has no dirty blocks left.
> + */
> +static bool btrfs_subpage_clear_fixup_dirty(const struct btrfs_fs_info *fs_info,
> +					    struct folio *folio, u64 start, u32 len)
> +{
> +	struct btrfs_folio_state *bfs = folio_get_private(folio);
> +	unsigned int dirty_bit = subpage_calc_start_bit(fs_info, folio,
> +							dirty, start, len);
> +	unsigned int fixup_bit = subpage_calc_start_bit(fs_info, folio,
> +							fixup, start, len);
> +	const unsigned int nbits = len >> fs_info->sectorsize_bits;
> +	unsigned long flags;
> +	bool last;
> +
> +	spin_lock_irqsave(&bfs->lock, flags);
> +	for (unsigned int i = 0; i < nbits; i++) {
> +		if (!test_bit(fixup_bit + i, bfs->bitmaps))
> +			continue;
> +		clear_bit(fixup_bit + i, bfs->bitmaps);
> +		clear_bit(dirty_bit + i, bfs->bitmaps);
> +	}
> +	if (subpage_test_bitmap_all_zero(fs_info, folio, fixup))
> +		folio_clear_fixup_pending(folio);
> +	last = subpage_test_bitmap_all_zero(fs_info, folio, dirty);
> +	spin_unlock_irqrestore(&bfs->lock, flags);
> +	return last;
> +}
> +
> +/*
> + * Drop the fixup blocks inside the range, for callers discarding their data:
> + * btrfs_invalidate_folio() and the writepage fixup worker's error path.
> + *
> + * Callers that have just reserved space for a block want
> + * btrfs_folio_clear_fixup() instead - there the block stays dirty and gets
> + * written.
> + *
> + * The range can be byte-granular (an unaligned truncate through
> + * btrfs_invalidate_folio()); only blocks fully inside it are dropped, as a
> + * partially covered block still holds live data outside the range.  For
> + * single-block folios the folio flag is the fixup state, so it is dropped
> + * only when the range covers the whole folio.
> + */
> +void btrfs_folio_clear_fixup_dirty(const struct btrfs_fs_info *fs_info,
> +				   struct folio *folio, u64 start, u32 len)
> +{
> +	u64 aligned_start;
> +	u64 aligned_end;
> +
> +	/* The folio flag is set whenever any fixup bitmap bit is. */
> +	if (!folio_test_fixup_pending(folio))
> +		return;
> +	if (!btrfs_is_subpage(fs_info, folio)) {
> +		if (start <= folio_pos(folio) &&
> +		    start + len >= folio_next_pos(folio)) {
> +			folio_clear_fixup_pending(folio);
> +			folio_clear_dirty_for_io(folio);
> +		}
> +		return;
> +	}
> +	btrfs_subpage_clamp_range(folio, &start, &len);
> +	aligned_start = round_up(start, fs_info->sectorsize);
> +	aligned_end = round_down(start + len, fs_info->sectorsize);
> +	if (aligned_end <= aligned_start)
> +		return;
> +	if (btrfs_subpage_clear_fixup_dirty(fs_info, folio, aligned_start,
> +					    aligned_end - aligned_start))
> +		folio_clear_dirty_for_io(folio);
> +}
> +
> +bool btrfs_folio_test_fixup(const struct btrfs_fs_info *fs_info,
> +			    struct folio *folio, u64 start, u32 len)
> +{
> +	if (!btrfs_is_subpage(fs_info, folio))
> +		return folio_test_fixup_pending(folio);
> +	return btrfs_subpage_test_fixup(fs_info, folio, start, len);
> +}
> +
> +void btrfs_folio_clear_fixup(const struct btrfs_fs_info *fs_info,
> +			     struct folio *folio, u64 start, u32 len)
> +{
> +	if (!btrfs_is_subpage(fs_info, folio)) {
> +		folio_clear_fixup_pending(folio);
> +		return;
> +	}
> +	btrfs_subpage_clear_fixup(fs_info, folio, start, len);
> +}
> +
>   /*
>    * Unlike set/clear which is dependent on each page status, for test all bits
>    * are tested in the same way.
> @@ -480,6 +688,7 @@ bool btrfs_subpage_test_##name(const struct btrfs_fs_info *fs_info,	\
>   IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(uptodate);
>   IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(dirty);
>   IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(writeback);
> +IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(fixup);
>   
>   /*
>    * Note that, in selftests (extent-io-tests), we can have empty fs_info passed
> @@ -571,8 +780,8 @@ bool btrfs_meta_folio_test_##name(struct folio *folio, const struct extent_buffe
>   }
>   IMPLEMENT_BTRFS_PAGE_OPS(uptodate, folio_mark_uptodate, folio_clear_uptodate,
>   			 folio_test_uptodate);
> -IMPLEMENT_BTRFS_PAGE_OPS(dirty, folio_mark_dirty, folio_clear_dirty_for_io,
> -			 folio_test_dirty);
> +IMPLEMENT_BTRFS_PAGE_OPS(dirty, btrfs_folio_mark_dirty_reserved,
> +			 folio_clear_dirty_for_io, folio_test_dirty);
>   IMPLEMENT_BTRFS_PAGE_OPS(writeback, folio_start_writeback, folio_end_writeback,
>   			 folio_test_writeback);
>   
> diff --git a/fs/btrfs/subpage.h b/fs/btrfs/subpage.h
> index c6d7394e6418..9aceba93c818 100644
> --- a/fs/btrfs/subpage.h
> +++ b/fs/btrfs/subpage.h
> @@ -14,15 +14,15 @@ struct folio;
>   /*
>    * Extra info for subpage bitmap.
>    *
> - * For subpage we pack all uptodate/dirty/writeback bitmaps into
> + * For subpage we pack all uptodate/dirty/writeback/fixup bitmaps into
>    * one larger bitmap.
>    *
>    * This structure records how they are organized in the bitmap:
>    *
> - * /- uptodate          /- dirty        /- writeback
> - * |			|		|
> - * v			v		v
> - * |u|u|u|u|........|u|u|d|d|.......|d|d|w|w|.......|w|w|
> + * /- uptodate          /- dirty        /- writeback       /- fixup
> + * |			|		|		   |
> + * v			v		v		   v
> + * |u|u|u|u|........|u|u|d|d|.......|d|d|w|w|.....|w|w|f|f|.....|f|f|
>    * |< sectors_per_page >|
>    *
>    * Unlike regular macro-like enums, here we do not go upper-case names, as
> @@ -40,6 +40,14 @@ enum {
>   	 */
>   	btrfs_bitmap_nr_writeback,
>   
> +	/*
> +	 * Blocks dirtied by the dirty_folio callback instead of a reserving
> +	 * write path (e.g. set_page_dirty_lock() on a GUP pin).  They have
> +	 * no space reservation and need the writepage fixup before they can
> +	 * be submitted.
> +	 */
> +	btrfs_bitmap_nr_fixup,
> +
>   	btrfs_bitmap_nr_max
>   };
>   
> @@ -165,6 +173,29 @@ DECLARE_BTRFS_SUBPAGE_OPS(uptodate);
>   DECLARE_BTRFS_SUBPAGE_OPS(dirty);
>   DECLARE_BTRFS_SUBPAGE_OPS(writeback);
>   
> +/*
> + * Fixup bit helpers.
> + *
> + * The fixup bit is data-only and has no plain set helper (setting happens
> + * together with dirtying in btrfs_subpage_set_fixup_dirty()), so it does not
> + * go through DECLARE_BTRFS_SUBPAGE_OPS().  For single-block folios the
> + * folio_*_fixup_pending() flag takes the place of the bitmap.
> + */
> +void btrfs_subpage_clear_fixup(const struct btrfs_fs_info *fs_info,
> +			       struct folio *folio, u64 start, u32 len);
> +bool btrfs_subpage_test_fixup(const struct btrfs_fs_info *fs_info,
> +			      struct folio *folio, u64 start, u32 len);
> +bool btrfs_folio_test_fixup(const struct btrfs_fs_info *fs_info,
> +			    struct folio *folio, u64 start, u32 len);
> +void btrfs_folio_set_fixup_dirty(const struct btrfs_fs_info *fs_info,
> +				 struct folio *folio, u64 start, u32 len);
> +/* For a block that just got its space reserved; it stays dirty. */
> +void btrfs_folio_clear_fixup(const struct btrfs_fs_info *fs_info,
> +			     struct folio *folio, u64 start, u32 len);
> +/* For callers discarding the data; clears the dirty bits too. */
> +void btrfs_folio_clear_fixup_dirty(const struct btrfs_fs_info *fs_info,
> +				   struct folio *folio, u64 start, u32 len);
> +
>   /*
>    * Helper for error cleanup, where a folio will have its dirty flag cleared,
>    * with writeback started and finished.
> diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
> index f9d22cd71768..6ecfab97c1a9 100644
> --- a/include/trace/events/btrfs.h
> +++ b/include/trace/events/btrfs.h
> @@ -689,6 +689,41 @@ DEFINE_EVENT(btrfs__ordered_extent, btrfs_ordered_extent_lookup_first,
>   	     TP_ARGS(inode, ordered)
>   );
>   
> +/*
> + * The writepage fixup worker deferred a block because this still-running
> + * ordered extent covers it.
> + */
> +DEFINE_EVENT(btrfs__ordered_extent, btrfs_writepage_fixup_defer,
> +
> +	     TP_PROTO(const struct btrfs_inode *inode,
> +		      const struct btrfs_ordered_extent *ordered),
> +
> +	     TP_ARGS(inode, ordered)
> +);
> +
> +/* The writepage fixup worker reserved space for a block and set delalloc. */
> +TRACE_EVENT(btrfs_writepage_fixup_reserve,
> +
> +	TP_PROTO(const struct btrfs_inode *inode, u64 start, u32 len),
> +
> +	TP_ARGS(inode, start, len),
> +
> +	TP_STRUCT__entry_btrfs(
> +		__field(	u64,	ino		)
> +		__field(	u64,	start		)
> +		__field(	u32,	len		)
> +	),
> +
> +	TP_fast_assign_btrfs(inode->root->fs_info,
> +		__entry->ino	= btrfs_ino(inode);
> +		__entry->start	= start;
> +		__entry->len	= len;
> +	),
> +
> +	TP_printk_btrfs("ino=%llu start=%llu len=%u",
> +			__entry->ino, __entry->start, __entry->len)
> +);
> +
>   DEFINE_EVENT(btrfs__ordered_extent, btrfs_ordered_extent_split,
>   
>   	     TP_PROTO(const struct btrfs_inode *inode,

