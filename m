Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F14A3403E7
	for <linux-btrfs@vger.kernel.org>; Sat,  5 Sep 2026 00:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788569878; cv=none; b=NeH0/XRSlqQXLocOmgCK8pKIUw1e5DyIZV6Wy/C9qy/WfpnmEbILLx9XYSXszkRhOntY5G7i7ioR8MxR2vUmVegpUaaIj5EIrkS6QzvMJRBHoF08xj9gig0xcm+LV+hA753JFtsI4nOfdQI9j1EpQtzvZN9/AnSjMaQNha5JTtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788569878; c=relaxed/simple;
	bh=G2i/yriathJveHu4pQ26U/lw2BHlH12mK4H8CL3NNk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MNNErcecAZYUetLa1vUfZAJ7pZ+5TTRd/FELboT38NMXuPHNWcDcwfnu99KIRVbSFnq16yhw3erzxUysNU0e5LQZMRrouJSiXZQw4MTIByLR7kVth0IQNjdDNDHzdG6o5Qk3iFXkAcJ+F3jhYOIl1mgtFQiBg95hjWOcVjtL2dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=N5BykYj6; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="N5BykYj6"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49ccfae359fso13502045e9.3
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Sep 2026 17:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788569874; x=1789174674; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7Vt8t7Eos0OBQIXw0pvTlj4fdUaEKDHn4IS6Uh19zNk=;
        b=N5BykYj6wg6gliXRXbBXdRHwhzKoHMzvcaTf9303A2etHMQaX9REAOlcU8AR1GJ3Zb
         W7aiSpKDZZT7RX9ndXCjsdK0IkD9rg9EuueKC6habc3czzYNCI5ZzH+VpT56UE04RF1d
         zow+MZf5Q2MVJKtae5I0rYA8Ow0goQq+WJ3nePwoBiyjiTwJ3AGNabJmJrI5febg/FeH
         qblViEIqP6nN4b4jQyrcFJqYEYFBJr/JLdo8c+jh6Q0Nd+nqe5Q72r5yDdk6tfzrXdo9
         3o8f8oMvHFArjiWiDHZeGylLBg0QMbsivMYks96ZbqEQYm9MO+Aa4IfSB2qCqZ74cbmo
         AJJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788569874; x=1789174674;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7Vt8t7Eos0OBQIXw0pvTlj4fdUaEKDHn4IS6Uh19zNk=;
        b=eDKoDNDuBOcOh5AoJ2CYt3NiM53/GB4L7lySaHFB1QpCuR9/qJ3IXRehzufJNRAefv
         +ZBzlgZuVzumAch+v509j1SBLVXzbDLKW+SkLdA4iQrp43LjY7qZcIguzj6e013clsYj
         FCyFev0rbQ42Eoy88HSiHJ9hUp5RmMQ3AqgulAeogzZVqiZJe6TE5MEv0+bwIFLnT7CI
         /dSjzVHAxFJ6td6ntEgrqRRNtR026cVchRY4SpazWcJyqRkpah5UJOAu3pSVgVcVMPKE
         0FqDvnuy8dNZAjUBbVKxnLPxUfbqA0MT/f7yu8/VFoe3SyZAggTCW7dXuZaIaQWc1rTt
         sBUQ==
X-Gm-Message-State: AFuF++nFh9nP6QheeMrWk9vk/8la+cDt6kq0nSBLLSVCwPnJxwdl9vGQ
	nAfzSQboyn8uIpdjmCV8sMQp8PU7980VLAVL2OUFOMHbROBLI2ZWAZZ+PIGNThqr1FHeIDIqw5+
	Qjghfebs=
X-Gm-Gg: AYBFou18J/AM+Pf6R9Mhwv7XRlRj93BJjUrA+ZN5k5BPxy5OI3LzoXVpugftzOU5o5D
	pyRqDNzGejZpVGzWYLw63meE1843vgn2DK1GSZBpeZjlqvryRMb059aOhyMBYvIh4mJ2Syr+2J9
	pFKdjG7pL+BDsHIPpPuS/UUD2c2bLOH5aODxGQDWr08EzJuAgI6K3ys/zFgcV0Y4QoJDIo81yku
	3U2Kn7Q1aLiASvn5RqKoOsu4H6PdYBZKPYW4uUTYyECSVd2KECJuPKGj6oSwSJ3hA62qXuI8Zlt
	vWbuzsc4uc1uo6L+ove+O6wxN2rUng3d6/s/2X7g+qEk1F7XUJHP4CtBNXDqhqsFxQSjNN9OoMJ
	MtPTRcKk+zXl/8VXpljblUM83k9Jkwxt8fWNnF3EZFm7N/SpIDfn2pPg7S1o7Emy9tKH0Cltwod
	m/BQkgUvox8/ajrN+fmIZNg/rezi2chAR5glE2YbeUEbaIBm//7kl5
X-Received: by 2002:a05:600c:c173:b0:49c:fc6c:be18 with SMTP id 5b1f17b1804b1-49cfc6cc0b8mr67135105e9.30.1788569874209;
        Fri, 04 Sep 2026 17:57:54 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b083e4fafsm13010158a91.1.2026.09.04.17.57.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 17:57:53 -0700 (PDT)
Message-ID: <130fdc9a-2d51-49cd-bf7f-c8e4b8fa19aa@suse.com>
Date: Sat, 5 Sep 2026 10:27:47 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: move async csum generation out of experimental
 features
To: Daniel Vacek <neelx@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
References: <700ba6c46da86ace18a502b43c5e61d16a556060.1788424754.git.wqu@suse.com>
 <CAPjX3FeQ40fcFjfiH=5EK57YvmVDtGxyz152T9FHUOmJuuaOFQ@mail.gmail.com>
 <00fc1bdb-cb69-4339-8184-afc04fceab19@gmx.com>
 <CAPjX3FdkWegsttPk9FiTiVUp9dcdycWWmecnpSxcgrpwnw=TEg@mail.gmail.com>
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
In-Reply-To: <CAPjX3FdkWegsttPk9FiTiVUp9dcdycWWmecnpSxcgrpwnw=TEg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/3 22:14, Daniel Vacek 写道:
> On Thu, 3 Sept 2026 at 13:27, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>> 在 2026/9/3 18:50, Daniel Vacek 写道:
>>> On Thu, 3 Sept 2026 at 10:40, Qu Wenruo <wqu@suse.com> wrote:
>>>> Commit dd57c78aec39 ("btrfs: introduce btrfs_bio::async_csum")
>>>> introduced asynchronous data checksum generation for data writes.
>>>>
>>>> That feature can improve write performance, and was introduced in v6.19.
>>>> We have not experienced bugs related to that, so it's time to move it out
>>>> of experimental features for end users.
>>>>
>>>> Furthermore since the async checksum generation means
>>>> should_async_write() will always return false, we no longer need to
>>>> maintain the fs_info->workers workqueue, as the async checksum
>>>> generation is using the system_percpu_wq.
>>>
>>> I understand these are two related changes in one patch here. If
>>> removing async writes depends on async checksums, it would be nice to
>>> split this into a patch series.
>>>
>>> Though I guess can live with that. Looks good enough to me.
>>>
>>> Reviewed-by: Daniel Vacek <neelx@suse.com>
>>
>> Thanks a lot for the review.
>>
>>
>> I just want to mention that, Sashiko mentioned a problem that I believe
>> is valid, but not sure how realistic it will be in the real world.
>>
>>
>> Sashiko mentioned that, the old worker workqueue has WQ_MEM_RECLAIM
>> flag, thus there will always be a rescuer to ensure forward progress.
>> (Although for x86_64 and other common archs or EXPERIMENTAL builds, we
>> never utilize that worker anyway)
>>
>> But the new schedule_work() is using system_percpu_wq, which doesn't has
>> that flag.
> 
> Well, I think squashing this fixup to my patch is the right thing to do anyways:
> 
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 0fed4e0d32d5..984d87ad79b0 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -855,7 +855,7 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
>       }
>       bio_inc_remaining(bio);
>       INIT_WORK(&bbio->csum_work, csum_one_bio_work);
> -    schedule_work(&bbio->csum_work);
> +    queue_work(fs_info->endio_workers, &bbio->csum_work);
>       return 0;
>   }

This has one new problem though.

The csum_one_bio_work() can queue a new work into the same endio_workers.

It happens like this:

csum_one_bio_work()
|- bio_endio()
|  |- btrfs_simple_end_io()
       |- queue_work() into endio_workers again

This can cause problems with flush_workqueue() in close_ctree(), where 
we only flush the workqueue once, which doesn't ensure newly created 
work is also flushed.

We can use drain_workqueue() instead to fix it easily though.

Mind to send out a proper patch for it?

Thanks,
Qu

> 
> 
> That should make sashiko happy as well as btrfs end_io work running on
> btrfs end_io work queues.
> 
> And we should stay on the safe side wrt memory reclaim.
> 
> --nX
> 
> 
>> And since the csum generation is needed for data writeback, if under
>> very heavy memory pressure, there may be no worker to ensure the csum
>> work can be queued, in that case, it will hang the writeback (which is
>> triggered to reclaim memory).
>>
>> If we really want to address that problem, your idea about splitting the
>> patch will make a lot of sense.
>> We will need to keep the old infrastructure first, convert the worker to
>> a regular workqueue, and call queue_work(), then fully remove unused code.
>>
>>
>> But on the other hand, I doubt how pratically it is for anyone to stall
>> system_percpu_wq.
>> It's very common utilized across the whole kernel, and if it really
>> stalls I think there are a lot of more things to bother before btrfs.
>>
>> Another thing is, if we use fs_info::workers, we will follow the
>> existing wq flags, which means no PERCPU flag.
>> And according to the existing docs for those flags, PERCPU wq has a
>> better performance due to CPU locality.
>>
>>
>> So overall I think the current version is good enough, but not perfect.
>> On the other hand, using a WQ_MEM_RECLAIM seems more "correct", but will
>> definitely introduce some extra pentalty.
>>
>> If someone else has some idea on this Sashiko review, or very familiar
>> with the WQ_MEM_RECLAIM situation, any comment will be appreciated.
>>
>> Thanks,
>> Qu
>>
>>>
>>>> Suggested-by: Daniel Vacek <neelx@suse.com>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>>    fs/btrfs/bio.c       | 136 +------------------------------------------
>>>>    fs/btrfs/disk-io.c   |  20 +------
>>>>    fs/btrfs/file-item.c |   6 +-
>>>>    fs/btrfs/file-item.h |   2 +-
>>>>    fs/btrfs/fs.h        |  10 ----
>>>>    fs/btrfs/super.c     |   1 -
>>>>    6 files changed, 4 insertions(+), 171 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
>>>> index 771b7d598aee..e08006543c3d 100644
>>>> --- a/fs/btrfs/bio.c
>>>> +++ b/fs/btrfs/bio.c
>>>> @@ -569,136 +569,7 @@ static int btrfs_bio_csum(struct btrfs_bio *bbio)
>>>>    {
>>>>           if (bbio->bio.bi_opf & REQ_META)
>>>>                   return btree_csum_one_bio(bbio);
>>>> -#ifdef CONFIG_BTRFS_EXPERIMENTAL
>>>> -       return btrfs_csum_one_bio(bbio, true);
>>>> -#else
>>>> -       return btrfs_csum_one_bio(bbio, false);
>>>> -#endif
>>>> -}
>>>> -
>>>> -/*
>>>> - * Async submit bios are used to offload expensive checksumming onto the worker
>>>> - * threads.
>>>> - */
>>>> -struct async_submit_bio {
>>>> -       struct btrfs_bio *bbio;
>>>> -       struct btrfs_io_context *bioc;
>>>> -       struct btrfs_io_stripe smap;
>>>> -       int mirror_num;
>>>> -       struct btrfs_work work;
>>>> -};
>>>> -
>>>> -/*
>>>> - * In order to insert checksums into the metadata in large chunks, we wait
>>>> - * until bio submission time.   All the pages in the bio are checksummed and
>>>> - * sums are attached onto the ordered extent record.
>>>> - *
>>>> - * At IO completion time the csums attached on the ordered extent record are
>>>> - * inserted into the btree.
>>>> - */
>>>> -static void run_one_async_start(struct btrfs_work *work)
>>>> -{
>>>> -       struct async_submit_bio *async =
>>>> -               container_of(work, struct async_submit_bio, work);
>>>> -       int ret;
>>>> -
>>>> -       ret = btrfs_bio_csum(async->bbio);
>>>> -       if (ret)
>>>> -               async->bbio->bio.bi_status = errno_to_blk_status(ret);
>>>> -}
>>>> -
>>>> -/*
>>>> - * In order to insert checksums into the metadata in large chunks, we wait
>>>> - * until bio submission time.   All the pages in the bio are checksummed and
>>>> - * sums are attached onto the ordered extent record.
>>>> - *
>>>> - * At IO completion time the csums attached on the ordered extent record are
>>>> - * inserted into the tree.
>>>> - *
>>>> - * If called with @do_free == true, then it will free the work struct.
>>>> - */
>>>> -static void run_one_async_done(struct btrfs_work *work, bool do_free)
>>>> -{
>>>> -       struct async_submit_bio *async =
>>>> -               container_of(work, struct async_submit_bio, work);
>>>> -       struct bio *bio = &async->bbio->bio;
>>>> -
>>>> -       if (do_free) {
>>>> -               kfree(container_of(work, struct async_submit_bio, work));
>>>> -               return;
>>>> -       }
>>>> -
>>>> -       /* If an error occurred we just want to clean up the bio and move on. */
>>>> -       if (bio->bi_status) {
>>>> -               btrfs_bio_end_io(async->bbio, bio->bi_status);
>>>> -               return;
>>>> -       }
>>>> -
>>>> -       /*
>>>> -        * All of the bios that pass through here are from async helpers.
>>>> -        * Use REQ_BTRFS_CGROUP_PUNT to issue them from the owning cgroup's
>>>> -        * context.  This changes nothing when cgroups aren't in use.
>>>> -        */
>>>> -       bio->bi_opf |= REQ_BTRFS_CGROUP_PUNT;
>>>> -       btrfs_submit_bio(bio, async->bioc, &async->smap, async->mirror_num);
>>>> -}
>>>> -
>>>> -static bool should_async_write(struct btrfs_bio *bbio)
>>>> -{
>>>> -       struct btrfs_fs_info *fs_info = bbio->inode->root->fs_info;
>>>> -       bool auto_csum_mode = true;
>>>> -
>>>> -#ifdef CONFIG_BTRFS_EXPERIMENTAL
>>>> -       /*
>>>> -        * Write bios will calculate checksum and submit bio at the same time.
>>>> -        * Unless explicitly required don't offload serial csum calculate and bio
>>>> -        * submit into a workqueue.
>>>> -        */
>>>> -       return false;
>>>> -#endif
>>>> -
>>>> -       /* Submit synchronously if the checksum implementation is fast. */
>>>> -       if (auto_csum_mode && test_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_info->flags))
>>>> -               return false;
>>>> -
>>>> -       /*
>>>> -        * Try to defer the submission to a workqueue to parallelize the
>>>> -        * checksum calculation unless the I/O is issued synchronously.
>>>> -        */
>>>> -       if (op_is_sync(bbio->bio.bi_opf))
>>>> -               return false;
>>>> -
>>>> -       /* Zoned devices require I/O to be submitted in order. */
>>>> -       if ((bbio->bio.bi_opf & REQ_META) && btrfs_is_zoned(fs_info))
>>>> -               return false;
>>>> -
>>>> -       return true;
>>>> -}
>>>> -
>>>> -/*
>>>> - * Submit bio to an async queue.
>>>> - *
>>>> - * Return true if the work has been successfully submitted, else false.
>>>> - */
>>>> -static bool btrfs_wq_submit_bio(struct btrfs_bio *bbio,
>>>> -                               struct btrfs_io_context *bioc,
>>>> -                               struct btrfs_io_stripe *smap, int mirror_num)
>>>> -{
>>>> -       struct btrfs_fs_info *fs_info = bbio->inode->root->fs_info;
>>>> -       struct async_submit_bio *async;
>>>> -
>>>> -       async = kmalloc_obj(*async, GFP_NOFS);
>>>> -       if (!async)
>>>> -               return false;
>>>> -
>>>> -       async->bbio = bbio;
>>>> -       async->bioc = bioc;
>>>> -       async->smap = *smap;
>>>> -       async->mirror_num = mirror_num;
>>>> -
>>>> -       btrfs_init_work(&async->work, run_one_async_start, run_one_async_done);
>>>> -       btrfs_queue_work(fs_info->workers, &async->work);
>>>> -       return true;
>>>> +       return btrfs_csum_one_bio(bbio);
>>>>    }
>>>>
>>>>    static u64 btrfs_append_map_length(struct btrfs_bio *bbio, u64 map_length)
>>>> @@ -806,10 +677,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
>>>>                   if (!(inode->flags & BTRFS_INODE_NODATASUM) &&
>>>>                       !test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_info->fs_state) &&
>>>>                       !btrfs_is_data_reloc_root(inode->root) && !bbio->is_remap) {
>>>> -                       if (should_async_write(bbio) &&
>>>> -                           btrfs_wq_submit_bio(bbio, bioc, &smap, mirror_num))
>>>> -                               goto done;
>>>> -
>>>>                           ret = btrfs_bio_csum(bbio);
>>>>                           status = errno_to_blk_status(ret);
>>>>                           if (status)
>>>> @@ -824,7 +691,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
>>>>           }
>>>>
>>>>           btrfs_submit_bio(bio, bioc, &smap, mirror_num);
>>>> -done:
>>>>           return map_length == length;
>>>>
>>>>    fail:
>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>> index a1d83ad9a4c0..0046f3cb75a1 100644
>>>> --- a/fs/btrfs/disk-io.c
>>>> +++ b/fs/btrfs/disk-io.c
>>>> @@ -1776,7 +1776,6 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
>>>>           if (fs_info->fixup_workers)
>>>>                   destroy_workqueue(fs_info->fixup_workers);
>>>>           btrfs_destroy_workqueue(fs_info->delalloc_workers);
>>>> -       btrfs_destroy_workqueue(fs_info->workers);
>>>>           if (fs_info->endio_workers)
>>>>                   destroy_workqueue(fs_info->endio_workers);
>>>>           if (fs_info->rmw_workers)
>>>> @@ -1968,9 +1967,6 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
>>>>           unsigned int flags = WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND;
>>>>           unsigned int ordered_flags = WQ_MEM_RECLAIM | WQ_FREEZABLE;
>>>>
>>>> -       fs_info->workers =
>>>> -               btrfs_alloc_workqueue(fs_info, "worker", flags, max_active, 16);
>>>> -
>>>>           fs_info->delalloc_workers =
>>>>                   btrfs_alloc_workqueue(fs_info, "delalloc",
>>>>                                         flags, max_active, 2);
>>>> @@ -2005,8 +2001,7 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
>>>>           fs_info->discard_ctl.discard_workers =
>>>>                   alloc_ordered_workqueue("btrfs-discard", WQ_FREEZABLE);
>>>>
>>>> -       if (!(fs_info->workers &&
>>>> -             fs_info->delalloc_workers && fs_info->flush_workers &&
>>>> +       if (!(fs_info->delalloc_workers && fs_info->flush_workers &&
>>>>                 fs_info->endio_workers && fs_info->endio_meta_workers &&
>>>>                 fs_info->endio_write_workers &&
>>>>                 fs_info->endio_freespace_worker && fs_info->rmw_workers &&
>>>> @@ -4437,19 +4432,6 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
>>>>            */
>>>>           btrfs_flush_workqueue(fs_info->delalloc_workers);
>>>>
>>>> -       /*
>>>> -        * We can have ordered extents getting their last reference dropped from
>>>> -        * the fs_info->workers queue because for async writes for data bios we
>>>> -        * queue a work for that queue, at btrfs_wq_submit_bio(), that runs
>>>> -        * run_one_async_done() which calls btrfs_bio_end_io() in case the bio
>>>> -        * has an error, and that later function can do the final
>>>> -        * btrfs_put_ordered_extent() on the ordered extent attached to the bio,
>>>> -        * which adds a delayed iput for the inode. So we must flush the queue
>>>> -        * so that we don't have delayed iputs after committing the current
>>>> -        * transaction below and stopping the cleaner and transaction kthreads.
>>>> -        */
>>>> -       btrfs_flush_workqueue(fs_info->workers);
>>>> -
>>>>           /*
>>>>            * When finishing a compressed write bio we schedule a work queue item
>>>>            * to finish an ordered extent - end_bbio_compressed_write()
>>>> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
>>>> index 0fed4e0d32d5..7dbd9b8eec11 100644
>>>> --- a/fs/btrfs/file-item.c
>>>> +++ b/fs/btrfs/file-item.c
>>>> @@ -825,7 +825,7 @@ static void csum_one_bio_work(struct work_struct *work)
>>>>    /*
>>>>     * Calculate checksums of the data contained inside a bio.
>>>>     */
>>>> -int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
>>>> +int btrfs_csum_one_bio(struct btrfs_bio *bbio)
>>>>    {
>>>>           struct btrfs_ordered_extent *ordered = bbio->ordered;
>>>>           struct btrfs_inode *inode = bbio->inode;
>>>> @@ -849,10 +849,6 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
>>>>           btrfs_add_ordered_sum(ordered, sums);
>>>>
>>>>           bbio->csum_saved_iter = bio->bi_iter;
>>>> -       if (!async) {
>>>> -               csum_one_bio(bbio);
>>>> -               return 0;
>>>> -       }
>>>>           bio_inc_remaining(bio);
>>>>           INIT_WORK(&bbio->csum_work, csum_one_bio_work);
>>>>           schedule_work(&bbio->csum_work);
>>>> diff --git a/fs/btrfs/file-item.h b/fs/btrfs/file-item.h
>>>> index 6c678787c770..60a0eb17b3f6 100644
>>>> --- a/fs/btrfs/file-item.h
>>>> +++ b/fs/btrfs/file-item.h
>>>> @@ -64,7 +64,7 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
>>>>    int btrfs_insert_data_csums(struct btrfs_trans_handle *trans,
>>>>                               struct btrfs_root *root,
>>>>                               struct btrfs_ordered_sum *sums);
>>>> -int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async);
>>>> +int btrfs_csum_one_bio(struct btrfs_bio *bbio);
>>>>    int btrfs_alloc_dummy_sum(struct btrfs_bio *bbio);
>>>>    int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
>>>>                                struct list_head *list, int search_commit,
>>>> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
>>>> index 3eba8438593c..203f7131f737 100644
>>>> --- a/fs/btrfs/fs.h
>>>> +++ b/fs/btrfs/fs.h
>>>> @@ -696,16 +696,6 @@ struct btrfs_fs_info {
>>>>           /* All fs/file tree roots that have delalloc inodes. */
>>>>           struct list_head delalloc_roots;
>>>>
>>>> -       /*
>>>> -        * There is a pool of worker threads for checksumming during writes and
>>>> -        * a pool for checksumming after reads.  This is because readers can
>>>> -        * run with FS locks held, and the writers may be waiting for those
>>>> -        * locks.  We don't want ordering in the pending list to cause
>>>> -        * deadlocks, and so the two are serviced separately.
>>>> -        *
>>>> -        * A third pool does submit_bio to avoid deadlocking with the other two.
>>>> -        */
>>>> -       struct btrfs_workqueue *workers;
>>>>           struct btrfs_workqueue *delalloc_workers;
>>>>           struct btrfs_workqueue *flush_workers;
>>>>           struct workqueue_struct *endio_workers;
>>>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>>>> index 464129b1b0d4..54f2da47c567 100644
>>>> --- a/fs/btrfs/super.c
>>>> +++ b/fs/btrfs/super.c
>>>> @@ -1237,7 +1237,6 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
>>>>           btrfs_info(fs_info, "resize thread pool %d -> %d",
>>>>                  old_pool_size, new_pool_size);
>>>>
>>>> -       btrfs_workqueue_set_max(fs_info->workers, new_pool_size);
>>>>           btrfs_workqueue_set_max(fs_info->delalloc_workers, new_pool_size);
>>>>           btrfs_workqueue_set_max(fs_info->caching_workers, new_pool_size);
>>>>           workqueue_set_max_active(fs_info->endio_workers, new_pool_size);
>>>> --
>>>> 2.55.0
>>>>
>>>
>>

