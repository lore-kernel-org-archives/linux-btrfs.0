Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793770008;
	b=JNC3wotZKs5oEWapxFLEUQmwYinGLqOnHNsT0mmKhrL/bBhWNKysicKJ2ZvU9ra8Qvxf
	 19HOsqMWYu/H/xAv1d4XVKUwD2DlxNx1tvU1hmUCXAGAETHnR68kv83noK8faReUP6FtQ
	 I+ImC/Ai2gX7Mn684Wu8vo8VT6GcfExceds5rD3PteeUcvb9ZtpBXte6g++x9mCO/oXd8
	 O/EgS5meM+x5kjxo4lE+Ozqgexc/AERAmTtRkKs9a3ALmFrSZmQQX9a+t0SC/AkfUF28j
	 /yMtKC4Z1MuqaMV0jkqHxUt7nVCMlHOJ3pj0+FOf75ARGn+8MW4qrRPHBdD2nh1QV4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793770008;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:From:To:References:Content-Language:
	 Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=F/cPoFug+kILXR0zsefaY2+sJsrSiyeHAbJdF7hq0wU=;
	b=ryLqALM+dmyL6VFcpWqHF30Il+H9z1j1vQSgX+RW1Pd8yDxQhog/8Z2+dWO5WN5avlrG
	 CnS/HyhENeTSXKqnXl4KDdNTXSZ7i2KEfHNSSMk/3d3ErZ0HmBlu045v8F0i+u+DTGZqf
	 7Z95qot26xlM7NLs2GrnRitZInkgNVof/j9TWYc5FEnz/WO9uWAK79BoPDBS0WcWPwZ3B
	 Sydr483SxLi37u7wnnYhqTju14sted9xzFtztE22ZaAJHRFeBPZH0bZM/gx/mnCsru89a
	 9PJOLdnI1piu0sLdfpkprsEL15NJAifBhQjNwqWTeUtWffM5yP+yhYecR+0ZaawVmiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b="X/Rb0Ki9";
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CD8606A31B
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 05:26:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3CD8606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=X/Rb0Ki9
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so1875655e9.1
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 21:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793770006; x=1794374806; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F/cPoFug+kILXR0zsefaY2+sJsrSiyeHAbJdF7hq0wU=;
        b=X/Rb0Ki9oMWuKoJanceOg+Yl/Jx9Jri5n7kW/wopGDeLShDeMWFNTdqMR1H7z4haYi
         dMkOxvBfZ81MadmXWSxM9zw4mUsHxzr/cPlb2I8ZRAhaLRCTfLe1G+MNH/QyFrcYCbHY
         Q0NeGIGkY/oAE260SU9k6DHJjySDnZbV/NMkJutFBfOkRm3jd1nHahsVLPBFJDNfBH48
         VbHxrTqmzGZu0fFCOU48BLLlDK7j6w7MohgtdzRrY5VA0bcDWE59mxpqRCe+xw2hbsf3
         N/921DnuCGwb6LN6Eqal+rTLancalES3i068ZJX8gp3AuR1GkpRw4bzwv5AMljcCotyE
         KzpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793770006; x=1794374806;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F/cPoFug+kILXR0zsefaY2+sJsrSiyeHAbJdF7hq0wU=;
        b=Lnc8QHP0k+AG7hMguiTMdsLqKbw+DAwF2Q4pnJY5AQlt07GZdYMEBlg6/1FQ9eB4Kb
         4y+AG51fOHYhKZ9ihv+6a1kQMnS7CfLzt8F7PAkFBBHFklLfe5t9kieO2aL9iHcQziMc
         1m12FuCFpSVRg9u5CVZ6QoXxh1ho/jUbW1KToDp8M6J+rzFyqugzRpo/XdmL4bnhVLXc
         Y2MWMIAYuU5qJtkIH57ejIGuS2GOkmaAp52LyLm+QjLRESX4NiQ6xRoLxK6Cn0YQ3ppu
         nbVQkDjioGoCVA73GkkScS3Ym351fv0OWA8b6LgZey9z5Y8pTbpsXDzxYTG4u33Uu/ja
         TW8A==
X-Gm-Message-State: APuU4Z+ZCk6Qnw8Cb+3tIXc30Nnu0TZlYgc2c4VXpwdLB7zeRobKfHwD
	GPdSp1ALrWl8J3UIjMocbb7/U5UEsirq7VvkUGq/ivFMgYosqUKjYKgssm4a2SOUF+okBbfgUQB
	Ak5V7mC4=
X-Gm-Gg: AYBFou1svX6dIuAt+LPJgVAM3Cp+DoNaZxBWBhHNLjrFr8PEA5hUqWtcY6pbwLZ8HpU
	jS4buzVcMHSL7TyyWcxZdUfhvJnZDEU5Pa8QX4+ZfN/79Eeu/I5sUwUkuyiO1Kh34Vj+hhiIDIZ
	0IhW6f3UzJNNXhQ77+hJ41Jo1PxhB5Go+P/RXZnxVf43HipvGpvNpeQ64X+hxzF5g61rJ4iiPU3
	SVIUt1RBM4zuCVgKYdvwPzJA/ajVTX2XopSxOqM2cChinPXs42rZIZYO3I7+AXD+J3dUGROV1d+
	rH4kookH0ZqhucfhQfq8rPW/KdrNCXXgJR86fIzew8yk93D3akDfEg1ososmVvqS6hc8b1rjlWe
	TL0sUPA9QIPgHoZle6Fn9SCrj7EsAwo3Vkaom8IepIAhUwdrKJcjQp9n5qpGYJqZ5/5D94NCUjq
	Z7tKFD6OkKYslUPCj4A/hkXMF09wk+rqLt78Uk2SvzcDQ/5xTfnav+n4J39wkjF9erm+joukAAp
	iZlMEV2IwumnWaHobjbvk2N35UFQWsN3gLagVm8HWOrJbT45o8oVDyEKzgeOGaVROhdtqdWPqdr
	UOrSOaUD1U9A3oy1Ad+b
X-Received: by 2002:a05:600c:2541:b0:4a5:9224:fa10 with SMTP id 5b1f17b1804b1-4aa8b060adcmr350202305e9.18.1793770005789;
        Tue, 03 Nov 2026 21:26:45 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c4706bsm5688630c88.15.2026.11.03.21.26.43
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 21:26:44 -0800 (PST)
Message-ID: <53eec5ce-3c13-43e7-a931-30b3a6e83537@suse.com>
Date: Wed, 4 Nov 2026 15:56:41 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: move async data csum generation out of
 experimental
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
References: <8eb322321cac98013cc46dfe8d89fa58c1ad3dee.1793766229.git.wqu@suse.com>
Content-Language: en-US
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <8eb322321cac98013cc46dfe8d89fa58c1ad3dee.1793766229.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/4 14:53, Qu Wenruo 写道:
> This feature has been inside the experimental features for long enough,
> it's time to expose it for end users.
> 
> This involves several cleanups:
> 
> - Completely remove the workqueue based csum generation
>    This removes the involved structure and the fs_info->workers
>    workqueue.
> 
> - Remove the @async parameter from btrfs_csum_one_bio()
> 
> - Remove btrfs_init_csum_hash() and BTRFS_FS_CSUM_IMPL_FAST flag
>    Since there is no offload for csum generation any more, the function
>    btrfs_init_csum_hash() is just a simple btrfs_info() call.
> 
>    Use that btrfs_info() to replace btrfs_init_csum_hash() call.
> 
> And introduced one minor behavior change:
> 
> - Metadata checksum generation is never delayed to workqueue
>    I strongly doubt if the metadata checksum itself should even be
>    offloaded to another workqueue.
> 
>    The offloading itself only brings nothing but more context switch and
>    less locality.
>    And metadata itself is also pretty small, 16Kib by default, the
>    context switch itself can be more costly than the metadata checksum
>    generation.
> 
>    I don't think the original introduction of the offload should even
>    include metadata in the first place.
> 
>    This should not affect most users, as their CRC32/XXHASH is already
>    not going to be offloaded.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Sashiko is find two problems, one related to the workqueue flushing, and 
one related to fast sync.

Both are valid and both will need dedicated fixes.

I'd say this means the feature will be delayed again.

Thanks,
Qu> ---
>   fs/btrfs/Kconfig     |   2 -
>   fs/btrfs/bio.c       | 138 +------------------------------------------
>   fs/btrfs/disk-io.c   |  42 +------------
>   fs/btrfs/file-item.c |   6 +-
>   fs/btrfs/file-item.h |   2 +-
>   fs/btrfs/fs.h        |  16 -----
>   fs/btrfs/super.c     |   1 -
>   7 files changed, 6 insertions(+), 201 deletions(-)
> 
> diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
> index 4b10d78ed99b..47faa08d9059 100644
> --- a/fs/btrfs/Kconfig
> +++ b/fs/btrfs/Kconfig
> @@ -111,8 +111,6 @@ config BTRFS_EXPERIMENTAL
>   
>   	  - huge folios for data - folios can be as large as 2MiB now
>   
> -	  - asynchronous checksum generation for data writes
> -
>   	  - remap-tree - logical address remapping tree
>   
>   	  If unsure, say N.
> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> index 2e12a6d7e16f..4f7f7da417f7 100644
> --- a/fs/btrfs/bio.c
> +++ b/fs/btrfs/bio.c
> @@ -563,138 +563,7 @@ static int btrfs_bio_csum(struct btrfs_bio *bbio)
>   {
>   	if (bbio->bio.bi_opf & REQ_META)
>   		return btree_csum_one_bio(bbio);
> -#ifdef CONFIG_BTRFS_EXPERIMENTAL
> -	return btrfs_csum_one_bio(bbio, true);
> -#else
> -	return btrfs_csum_one_bio(bbio, false);
> -#endif
> -}
> -
> -/*
> - * Async submit bios are used to offload expensive checksumming onto the worker
> - * threads.
> - */
> -struct async_submit_bio {
> -	struct btrfs_bio *bbio;
> -	struct btrfs_io_context *bioc;
> -	struct btrfs_io_stripe smap;
> -	int mirror_num;
> -	struct btrfs_work work;
> -};
> -
> -/*
> - * In order to insert checksums into the metadata in large chunks, we wait
> - * until bio submission time.   All the pages in the bio are checksummed and
> - * sums are attached onto the ordered extent record.
> - *
> - * At IO completion time the csums attached on the ordered extent record are
> - * inserted into the btree.
> - */
> -static void run_one_async_start(struct btrfs_work *work)
> -{
> -	struct async_submit_bio *async =
> -		container_of(work, struct async_submit_bio, work);
> -	int ret;
> -
> -	ret = btrfs_bio_csum(async->bbio);
> -	if (ret)
> -		async->bbio->bio.bi_status = errno_to_blk_status(ret);
> -}
> -
> -/*
> - * In order to insert checksums into the metadata in large chunks, we wait
> - * until bio submission time.   All the pages in the bio are checksummed and
> - * sums are attached onto the ordered extent record.
> - *
> - * At IO completion time the csums attached on the ordered extent record are
> - * inserted into the tree.
> - *
> - * If called with @do_free == true, then it will free the work struct.
> - */
> -static void run_one_async_done(struct btrfs_work *work, bool do_free)
> -{
> -	struct async_submit_bio *async =
> -		container_of(work, struct async_submit_bio, work);
> -	struct bio *bio = &async->bbio->bio;
> -
> -	if (do_free) {
> -		kfree(container_of(work, struct async_submit_bio, work));
> -		return;
> -	}
> -
> -	/* If an error occurred we just want to clean up the bio and move on. */
> -	if (bio->bi_status) {
> -		btrfs_put_bioc(async->bioc);
> -		btrfs_bio_counter_dec(async->bbio->inode->root->fs_info);
> -		btrfs_bio_end_io(async->bbio, bio->bi_status);
> -		return;
> -	}
> -
> -	/*
> -	 * All of the bios that pass through here are from async helpers.
> -	 * Use REQ_BTRFS_CGROUP_PUNT to issue them from the owning cgroup's
> -	 * context.  This changes nothing when cgroups aren't in use.
> -	 */
> -	bio->bi_opf |= REQ_BTRFS_CGROUP_PUNT;
> -	btrfs_submit_bio(bio, async->bioc, &async->smap, async->mirror_num);
> -}
> -
> -static bool should_async_write(struct btrfs_bio *bbio)
> -{
> -	struct btrfs_fs_info *fs_info = bbio->inode->root->fs_info;
> -	bool auto_csum_mode = true;
> -
> -#ifdef CONFIG_BTRFS_EXPERIMENTAL
> -	/*
> -	 * Write bios will calculate checksum and submit bio at the same time.
> -	 * Unless explicitly required don't offload serial csum calculate and bio
> -	 * submit into a workqueue.
> -	 */
> -	return false;
> -#endif
> -
> -	/* Submit synchronously if the checksum implementation is fast. */
> -	if (auto_csum_mode && test_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_info->flags))
> -		return false;
> -
> -	/*
> -	 * Try to defer the submission to a workqueue to parallelize the
> -	 * checksum calculation unless the I/O is issued synchronously.
> -	 */
> -	if (op_is_sync(bbio->bio.bi_opf))
> -		return false;
> -
> -	/* Zoned devices require I/O to be submitted in order. */
> -	if ((bbio->bio.bi_opf & REQ_META) && btrfs_is_zoned(fs_info))
> -		return false;
> -
> -	return true;
> -}
> -
> -/*
> - * Submit bio to an async queue.
> - *
> - * Return true if the work has been successfully submitted, else false.
> - */
> -static bool btrfs_wq_submit_bio(struct btrfs_bio *bbio,
> -				struct btrfs_io_context *bioc,
> -				struct btrfs_io_stripe *smap, int mirror_num)
> -{
> -	struct btrfs_fs_info *fs_info = bbio->inode->root->fs_info;
> -	struct async_submit_bio *async;
> -
> -	async = kmalloc_obj(*async, GFP_NOFS);
> -	if (!async)
> -		return false;
> -
> -	async->bbio = bbio;
> -	async->bioc = bioc;
> -	async->smap = *smap;
> -	async->mirror_num = mirror_num;
> -
> -	btrfs_init_work(&async->work, run_one_async_start, run_one_async_done);
> -	btrfs_queue_work(fs_info->workers, &async->work);
> -	return true;
> +	return btrfs_csum_one_bio(bbio);
>   }
>   
>   static u64 btrfs_append_map_length(struct btrfs_bio *bbio, u64 map_length)
> @@ -803,10 +672,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
>   		if (!(inode->flags & BTRFS_INODE_NODATASUM) &&
>   		    !test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_info->fs_state) &&
>   		    !btrfs_is_data_reloc_root(inode->root) && !bbio->is_remap) {
> -			if (should_async_write(bbio) &&
> -			    btrfs_wq_submit_bio(bbio, bioc, &smap, mirror_num))
> -				goto done;
> -
>   			ret = btrfs_bio_csum(bbio);
>   			status = errno_to_blk_status(ret);
>   			if (status)
> @@ -821,7 +686,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
>   	}
>   
>   	btrfs_submit_bio(bio, bioc, &smap, mirror_num);
> -done:
>   	return map_length == length;
>   
>   fail:
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 35a43e7cb937..c7b9ca7614e0 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1829,7 +1829,6 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
>   	if (fs_info->fixup_workers)
>   		destroy_workqueue(fs_info->fixup_workers);
>   	btrfs_destroy_workqueue(fs_info->delalloc_workers);
> -	btrfs_destroy_workqueue(fs_info->workers);
>   	if (fs_info->endio_workers)
>   		destroy_workqueue(fs_info->endio_workers);
>   	if (fs_info->rmw_workers)
> @@ -2040,9 +2039,6 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
>   	unsigned int flags = WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND;
>   	unsigned int ordered_flags = WQ_MEM_RECLAIM | WQ_FREEZABLE;
>   
> -	fs_info->workers =
> -		btrfs_alloc_workqueue(fs_info, "worker", flags, max_active, 16);
> -
>   	fs_info->delalloc_workers =
>   		btrfs_alloc_workqueue(fs_info, "delalloc",
>   				      flags, max_active, 2);
> @@ -2074,8 +2070,7 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
>   	fs_info->discard_ctl.discard_workers =
>   		alloc_ordered_workqueue("btrfs-discard", WQ_FREEZABLE);
>   
> -	if (!(fs_info->workers &&
> -	      fs_info->delalloc_workers && fs_info->flush_workers &&
> +	if (!(fs_info->delalloc_workers && fs_info->flush_workers &&
>   	      fs_info->endio_workers && fs_info->endio_meta_workers &&
>   	      fs_info->endio_write_workers && fs_info->rmw_workers &&
>   	      fs_info->caching_workers && fs_info->fixup_workers &&
> @@ -2087,25 +2082,6 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
>   	return 0;
>   }
>   
> -static void btrfs_init_csum_hash(struct btrfs_fs_info *fs_info, u16 csum_type)
> -{
> -	/* Check if the checksum implementation is a fast accelerated one. */
> -	switch (csum_type) {
> -	case BTRFS_CSUM_TYPE_CRC32:
> -		if (crc32_optimizations() & CRC32C_OPTIMIZATION)
> -			set_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_info->flags);
> -		break;
> -	case BTRFS_CSUM_TYPE_XXHASH:
> -		set_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_info->flags);
> -		break;
> -	default:
> -		break;
> -	}
> -
> -	btrfs_info(fs_info, "using %s checksum algorithm",
> -		   btrfs_super_csum_name(csum_type));
> -}
> -
>   static int btrfs_replay_log(struct btrfs_fs_info *fs_info,
>   			    struct btrfs_fs_devices *fs_devices)
>   {
> @@ -3476,7 +3452,8 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
>   	fs_info->csum_size = btrfs_super_csum_size(disk_super);
>   	fs_info->csum_type = csum_type;
>   
> -	btrfs_init_csum_hash(fs_info, csum_type);
> +	btrfs_info(fs_info, "using %s checksum algorithm",
> +		   btrfs_super_csum_name(csum_type));
>   
>   	/*
>   	 * We want to check superblock checksum, the type is stored inside.
> @@ -4465,19 +4442,6 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
>   	 */
>   	btrfs_flush_workqueue(fs_info->delalloc_workers);
>   
> -	/*
> -	 * We can have ordered extents getting their last reference dropped from
> -	 * the fs_info->workers queue because for async writes for data bios we
> -	 * queue a work for that queue, at btrfs_wq_submit_bio(), that runs
> -	 * run_one_async_done() which calls btrfs_bio_end_io() in case the bio
> -	 * has an error, and that later function can do the final
> -	 * btrfs_put_ordered_extent() on the ordered extent attached to the bio,
> -	 * which adds a delayed iput for the inode. So we must flush the queue
> -	 * so that we don't have delayed iputs after committing the current
> -	 * transaction below and stopping the cleaner and transaction kthreads.
> -	 */
> -	btrfs_flush_workqueue(fs_info->workers);
> -
>   	/*
>   	 * When finishing a compressed write bio we schedule a work queue item
>   	 * to finish an ordered extent - end_bbio_compressed_write()
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index ff8f8cad00fc..53c4af76cebc 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -815,7 +815,7 @@ static void csum_one_bio_work(struct work_struct *work)
>   /*
>    * Calculate checksums of the data contained inside a bio.
>    */
> -int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
> +int btrfs_csum_one_bio(struct btrfs_bio *bbio)
>   {
>   	struct btrfs_ordered_extent *ordered = bbio->ordered;
>   	struct btrfs_inode *inode = bbio->inode;
> @@ -839,10 +839,6 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
>   	btrfs_add_ordered_sum(ordered, sums);
>   
>   	bbio->csum_saved_iter = bio->bi_iter;
> -	if (!async) {
> -		csum_one_bio(bbio);
> -		return 0;
> -	}
>   	bio_inc_remaining(bio);
>   	INIT_WORK(&bbio->csum_work, csum_one_bio_work);
>   	queue_work(fs_info->endio_workers, &bbio->csum_work);
> diff --git a/fs/btrfs/file-item.h b/fs/btrfs/file-item.h
> index 6c678787c770..60a0eb17b3f6 100644
> --- a/fs/btrfs/file-item.h
> +++ b/fs/btrfs/file-item.h
> @@ -64,7 +64,7 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
>   int btrfs_insert_data_csums(struct btrfs_trans_handle *trans,
>   			    struct btrfs_root *root,
>   			    struct btrfs_ordered_sum *sums);
> -int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async);
> +int btrfs_csum_one_bio(struct btrfs_bio *bbio);
>   int btrfs_alloc_dummy_sum(struct btrfs_bio *bbio);
>   int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
>   			     struct list_head *list, int search_commit,
> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
> index 2dd167c32d61..7062bb9b242f 100644
> --- a/fs/btrfs/fs.h
> +++ b/fs/btrfs/fs.h
> @@ -189,12 +189,6 @@ enum {
>   	/* Indicate that the cleaner thread is awake and doing something. */
>   	BTRFS_FS_CLEANER_RUNNING,
>   
> -	/*
> -	 * The checksumming has an optimized version and is considered fast,
> -	 * so we don't need to offload checksums to workqueues.
> -	 */
> -	BTRFS_FS_CSUM_IMPL_FAST,
> -
>   	/* Indicate that the discard workqueue can service discards. */
>   	BTRFS_FS_DISCARD_RUNNING,
>   
> @@ -695,16 +689,6 @@ struct btrfs_fs_info {
>   	/* All fs/file tree roots that have delalloc inodes. */
>   	struct list_head delalloc_roots;
>   
> -	/*
> -	 * There is a pool of worker threads for checksumming during writes and
> -	 * a pool for checksumming after reads.  This is because readers can
> -	 * run with FS locks held, and the writers may be waiting for those
> -	 * locks.  We don't want ordering in the pending list to cause
> -	 * deadlocks, and so the two are serviced separately.
> -	 *
> -	 * A third pool does submit_bio to avoid deadlocking with the other two.
> -	 */
> -	struct btrfs_workqueue *workers;
>   	struct btrfs_workqueue *delalloc_workers;
>   	struct btrfs_workqueue *flush_workers;
>   	struct workqueue_struct *endio_workers;
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index b424cc836bd4..032238c941bc 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1235,7 +1235,6 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
>   	btrfs_info(fs_info, "resize thread pool %d -> %d",
>   	       old_pool_size, new_pool_size);
>   
> -	btrfs_workqueue_set_max(fs_info->workers, new_pool_size);
>   	btrfs_workqueue_set_max(fs_info->delalloc_workers, new_pool_size);
>   	btrfs_workqueue_set_max(fs_info->caching_workers, new_pool_size);
>   	workqueue_set_max_active(fs_info->endio_workers, new_pool_size);

