Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89B54CDA22
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 23:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789599837; cv=none; b=g9IiIbx9PL/np+Si/+yZinvos51rcQ1Ud1U3PTBYXKYHkd5IAOZMEMdKgWEE3GCuu4TyU9tYygcvKFNqmEctH/pzoBVah5sDTRqYIv+WmIWLz16lJiI7RurNhwvjM94qAWl+qi0GuHv9346iewSwYSdk4zA0HoZbKXJv1QT5hW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789599837; c=relaxed/simple;
	bh=MBIoYq4ao4Z3ZsYeu4Bk5VYdfoLZ6smrGSyk6DajgDs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=BpDB6740pqZ7iXy39FhGo3IclE2k9+rsKJz3rYMPVy4FBIQei6xNBqTbeFSxH1uTqG/9sfRsUBGWmsGfjCPSrPKG5sYPZYFf08qPuc9PPkj/VO9IPwj9gjzRfpHX/OnagSNx658gN57uLEC89ZwbJC81gNE0TaQcIxxs6UMFtKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QxzGyD6G; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QxzGyD6G"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c25ef7a3ce9so39372366b.3
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 16:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789599825; x=1790204625; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kXGe/MjX2A6b/2mArcnPZ8WoO/4aZyz9Z1obT7e5Fns=;
        b=QxzGyD6GKPtbEHQys71YLTVmsTBLiGKMKIGstI71G3VbLHKLnSVkbe6LZnKeEwXKSA
         LWBmCHQ7fNbCMXnOgRyup0wfhLj1uinCyrXIXJQI54hEW7nT9iRJtevgZ/AJPeJ++AGh
         hnrvDoHyaReymHuxbBdEWRi2rUpneEuIrpKYYffLX9LyWgNyhwRmoXn5hxcw5YN61ZpY
         xOgcUmahb0WpbaXWUXQYBXfGbMOXhWzscjHTqaryaSqoHHN+QR4R6WAlhnsJEMB6hS10
         9qdbxCl2/EShqJH+26nKfpCWcvEzV0oDfrQunSmCmoMMe579J9ajMaWpna8rjF3yAaSM
         /Hmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789599825; x=1790204625;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kXGe/MjX2A6b/2mArcnPZ8WoO/4aZyz9Z1obT7e5Fns=;
        b=mFu1yH4+dt/8wVIESPqqJbwGjvSsqR1RbTkpDs6MPHjfNp4CdMnPkytQvrJkjfU8gH
         /aaaPX6oXsA6vTQs+QU314A8L7yqznhCdT6AxMrphbTyhBpyM+tCZzG9+ga1YiZoqQV7
         wE82iRY2Y7TsGiLzDPXXdADF+w2/HHibyWTfnHVvpOqYjwDJRatZhXRfm1kqRh0Ygx2r
         8Deok01veDwOnj4ZTXXYptlCnXRmBIqsfEovvtTHvIEZe3o6oazqSa9tQwnUNmTXR1zr
         zirhc8PFpYwixsp3tLw4U6JLgcbER6m3tgeXq4qVQDyQEJGXaF6UUrF7c4+XHyykY68S
         8HWw==
X-Gm-Message-State: AFuF++nTew8Cb1jI0tnVu/1DanhMj1CxiFQklRLijdll1Wksmt5c3vwt
	gwe+NWZdtBPfU5Pu1QeYoPJoq8/Dd81fmhxHRVtE7pFId08bznRslwyD8kKCHMAMo2m3W40Si06
	WkCCBel/LTg==
X-Gm-Gg: AYBFou1Z3T56G7iLPLnd4F2Tvh14pmzlXLZZcL7dDQZOdhDBRC8j5/3FXXfkvtZH1aw
	tIsGvQpGNIJ0zDeEz0QlJM6oVCroOAaxRq8weIltw4yWSrQ36SBuFilQGt/3vQblxyWqYF818MW
	yn/Lh5a929B0Wh+vmEKOrgmAGZww1vgwqL7bu/RDPkP1rdq0lpYLl1HxIGEnCy4ws8cW5NGtbsX
	KRyrxUb29e8LyrQkYMVCFTr6BBnSHuKU3z0sWaDz1+KYKkODM08N+h0/4VcpA6UaWwtPVAB4azS
	wg1dQvHpvCG/W11PD0jPXpPwL2JH10yGwr78C/vvEuyjMHr19cvGlYPxaiErF1W7+OGXLvTscB8
	3o9ETkgoJYrgV23nIu7LrD8Sc9pWWBj4ZHu30i8vsAinAUffrXpGiT07Y8FjEaDOZQ+hpZkRBoq
	R7OYYeF8HLe9x0fYYes6i2CbEcoCHAKniZ+BOfi5y2HZjwB8e9bBtCUq8EDqGX0gi3B8/AAwUO1
	A==
X-Received: by 2002:a17:906:7315:b0:c29:3d59:706b with SMTP id a640c23a62f3a-c29e532932dmr303085366b.44.1789599825063;
        Wed, 16 Sep 2026 16:03:45 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89f244bdsm17504515ad.77.2026.09.16.16.03.43
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 16:03:43 -0700 (PDT)
Message-ID: <1c7840b1-16d1-4fb4-ae12-1a3073011ac1@suse.com>
Date: Thu, 17 Sep 2026 08:33:40 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] btrfs: introduce the skeleton of delayed bbio
 endio function
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
References: <cover.1789545179.git.wqu@suse.com>
 <bd4c6b7b2f65957a5d8473c4c9b5710a1093cd90.1789545179.git.wqu@suse.com>
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
In-Reply-To: <bd4c6b7b2f65957a5d8473c4c9b5710a1093cd90.1789545179.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/16 17:23, Qu Wenruo 写道:
> A delayed bbio will not be directly submitted, but queued into a
> workqueue, to perform compression there.
> 
> The compression and uncompressed fallback are not implemented in this
> patch.
> 
> Only the main endio function and a helper to queue workload into a
> workqueue are implemented.
> 
> The endio function is mostly the same as end_bbio_data_write(), except
> for the extra memory allocation/freeing for the bbio->private.
> 
> Another point to note is that, we reuse btrfs_bio::pending_ios to track
> the lifespan of the parent delayed bbio.
> We can reuse it because the delayed bbio is never submitted for IO, thus
> it will never be split by btrfs, so we can reuse that atomic to avoid
> extra space inside delayed_bio_private.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   fs/btrfs/inode.c | 77 ++++++++++++++++++++++++++++++++++++++++++++----
>   1 file changed, 72 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 69e12cb2d7b5..10b9a7fcfadf 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -97,6 +97,11 @@ struct data_reloc_warn {
>   	int mirror_num;
>   };
>   
> +struct delayed_bio_private {
> +	struct work_struct work;
> +	struct btrfs_bio *delayed_bbio;
> +};
> +
>   /*
>    * For the file_extent_tree, we want to hold the inode lock when we lookup and
>    * update the disk_i_size, but lockdep will complain because our io_tree we hold
> @@ -7691,18 +7696,80 @@ struct extent_map *btrfs_create_delayed_em(struct btrfs_inode *inode,
>   	return em;
>   }
>   
> -void btrfs_submit_delayed_write(struct btrfs_bio *bbio)
> +static void run_delayed_bbio(struct work_struct *work)
>   {
> -	ASSERT(bbio->is_delayed);
> +	struct delayed_bio_private *dbp = container_of(work, struct delayed_bio_private, work);
> +	struct btrfs_bio *parent = dbp->delayed_bbio;
> +
> +	/* Compressed and uncompressed fallback is not yet implemented. */
> +	ASSERT(0);
>   
>   	/*
> -	 * Not yet implemented, and should not hit this path as we have no
> -	 * caller to create delayed extent map.
> +	 * Any real compressed/uncompressed bios have increased
> +	 * parent->pending_ios, the last caller of btrfs_bio_end_io()
> +	 * will execute the real endio function.
>   	 */
> -	ASSERT(0);
> +	btrfs_bio_end_io(parent, BLK_STS_OK);
> +}
> +
> +static void end_bbio_delayed(struct btrfs_bio *bbio)
> +{
> +	struct delayed_bio_private *dbp = bbio->private;
> +	struct btrfs_inode *inode = bbio->inode;
> +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> +	struct folio_iter fi;
> +	const u32 bio_size = bio_get_size(&bbio->bio);
> +	const bool uptodate = bbio->status == BLK_STS_OK;
> +
> +	ASSERT(bbio->is_delayed);
> +
> +	bio_for_each_folio_all(fi, &bbio->bio) {
> +		u64 start = folio_pos(fi.folio) + fi.offset;
> +		u32 len = fi.length;
> +
> +		btrfs_folio_clear_writeback(fs_info, fi.folio, start, len);
> +	}
> +	btrfs_mark_ordered_io_finished(inode, bbio->file_offset, bio_size, uptodate);
> +	kfree(dbp);
>   	bio_put(&bbio->bio);
>   }
>   
> +void btrfs_submit_delayed_write(struct btrfs_bio *bbio)
> +{
> +	struct delayed_bio_private *dbp;
> +
> +	ASSERT(bbio->is_delayed);
> +
> +	bbio->end_io = end_bbio_delayed;
> +	dbp = kzalloc_obj(*dbp);

Sashiko exposed the missing GFP_NOFS flag for kzalloc_obj(), which can 
lead to deadlock on the writeback path.

Already fixed in my local branch.

> +	if (!dbp) {
> +		btrfs_bio_end_io(bbio, errno_to_blk_status(-ENOMEM));
> +		return;
> +	}
> +	dbp->delayed_bbio = bbio;
> +	bbio->private = dbp;
> +	/*
> +	 * TODO: find a way to properly allow sequential extent allocation.
> +	 *
> +	 * Currently compression and submission happen in the same workload.
> +	 * We want to run compression in parallel but run allocation sequentially.
> +	 *
> +	 * The existing btrfs workqueue will execute the sequential workload
> +	 * twice, the second one to free the structure, thus the btrfs_work
> +	 * structure can have a lifespan longer than the delayed bbio.
> +	 *
> +	 * But the current structure's lifespan is bounded to the original
> +	 * bbio, if using btrfs workqueue, we need extra lifespan management
> +	 * to ensure the work structure doesn't disappear when the original
> +	 * bbio is finished.
> +	 *
> +	 * This means we have to either delay the original bbio's finish,
> +	 * or have a very complex synchronization.
> +	 */
> +	INIT_WORK(&dbp->work, run_delayed_bbio);
> +	schedule_work(&dbp->work);

Also sashiko is pointing out that using the system wide wq lacks the 
regular WQ_MEM_RECLAIM flags.

I'll add a dedicated workqueue for it, and since it will eventually 
replace the eixsting delalloc_workers, it should not be a huge burden.

Thanks,
Qu

> +}
> +
>   /*
>    * For release_folio() and invalidate_folio() we have a race window where
>    * folio_end_writeback() is called but the subpage spinlock is not yet released.

