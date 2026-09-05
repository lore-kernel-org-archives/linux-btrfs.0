Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D80C46AA88
	for <linux-btrfs@vger.kernel.org>; Sat,  5 Sep 2026 10:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788605269; cv=none; b=GUEdyEh4FiwB9OrBGWH8nsX1cKVwj8elEYGuKDfS63K40LXC/pqsRXhnCrVotVv8Y/YC6QX/yIA8fx+MGfDs2imW70/rAWoRT6gIC9p9CS9Nj/tWj0MIcBau3D1ZWjUtrv1jD3fjXjr2w/KgUcNKSbhvnBvnqUVytI6mHZxo/zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788605269; c=relaxed/simple;
	bh=HDADB5g8qyCvuPB9/Qia55junVgNt/wmtvEJ9NMs/90=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mhmgl70iTZ0JvM3HROsq9u+CB56scln/Wl6VK9z1BryB0cZyEbvOMM0SU7jL4DDw0bNZZs9ZkXgJ/7idBjw6HX3L6bOQYrqpMY6m5k+nxcngx0xQCSSeUHcvhZSYl5xw3d3/bwJ7tvXf91xEM9Ei1EH/QfwUWAH9/ZbpLfw6nWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=M1YC5RGD; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="M1YC5RGD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788605263; x=1789210063; i=quwenruo.btrfs@gmx.com;
	bh=oq6G6C15sHdkxozoj4aNTHzZ7afdaXUS3/dnerSEY7c=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=M1YC5RGDT9WNVNAVGRJvylo5cf3ob/NmlvGjVHJEwWOQlNMB2asRpRThGGKdjnwh
	 SjZ3XylVD3nSEVphedx/xYImh1HtuvsWt2g/IzngOv6/xlpgX12QjTxw8iEIdWr0a
	 17l9HD29wKzBegKFI1MzvNMBhgr8jFRVVZ7XflTfXguMG6mZwxdO0IBjqHPIv5dQO
	 f5Ho2iDgiAzErB+SRPp8quTrP03C1mwIG0F0875JgUeQOwWY2puguGetOQSe2Be0C
	 jA8Se+rDutBO4rGlcVjhyApDG4CnFR8h71TL2mFsmDtKajUyym2Sa68DQEpvmAMxR
	 YlD38CycyaU9j90B1w==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1Mt75H-1wiX3f0Cdd-00rF2i; Sat, 05
 Sep 2026 12:47:43 +0200
Message-ID: <2eb96a3b-3d93-4563-8526-3bcf13594d50@gmx.com>
Date: Sat, 5 Sep 2026 20:17:38 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: move async csum generation out of experimental
 features
To: Daniel Vacek <neelx@suse.com>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <700ba6c46da86ace18a502b43c5e61d16a556060.1788424754.git.wqu@suse.com>
 <CAPjX3FeQ40fcFjfiH=5EK57YvmVDtGxyz152T9FHUOmJuuaOFQ@mail.gmail.com>
 <00fc1bdb-cb69-4339-8184-afc04fceab19@gmx.com>
 <CAPjX3FdkWegsttPk9FiTiVUp9dcdycWWmecnpSxcgrpwnw=TEg@mail.gmail.com>
 <130fdc9a-2d51-49cd-bf7f-c8e4b8fa19aa@suse.com>
 <CAPjX3Ff6aiRURh-uufDJ2pkw9Y0SJ6X-WyayxnV6NWiV69-EXg@mail.gmail.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <CAPjX3Ff6aiRURh-uufDJ2pkw9Y0SJ6X-WyayxnV6NWiV69-EXg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ZXwkC1cH0XB2SyxTmmUsy8S7mnraQpalb33FCtqZTVQkqbw4Ioy
 86nbmgVq9NpQ0cMvhcIkc2wjYPBSMhRx0z65pStd5CPFutZGB+O9FvMH2NSyiGgPS264b5h
 nbQj8QLZ1BEyMCKkyh6Rpoj2pA3r1ELr4WBnm8QfgsQ0xhFCxol+iAW9DSH0n4XUoq5jJi4
 OXRXcJ+FmM+j/tLSpVgkA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3gNXDUiED+4=;iYe3w9evA4hu931gtEpV43VJWsu
 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
 HfV2IXyQgVv+r



=E5=9C=A8 2026/9/5 19:39, Daniel Vacek =E5=86=99=E9=81=93:
> On Sat, 5 Sept 2026 at 02:57, Qu Wenruo <wqu@suse.com> wrote:
[...]
>> This has one new problem though.
>>
>> The csum_one_bio_work() can queue a new work into the same endio_worker=
s.
>>
>> It happens like this:
>>
>> csum_one_bio_work()
>> |- bio_endio()
>> |  |- btrfs_simple_end_io()
>>         |- queue_work() into endio_workers again
>>
>> This can cause problems with flush_workqueue() in close_ctree(), where
>> we only flush the workqueue once, which doesn't ensure newly created
>> work is also flushed.
>=20
> Do you know of any situation where this can happen?

Check the commit message of cda76788f8b0 ("btrfs: fix non-empty delayed=20
iputs list on unmount due to async workers").

With your change, we just move the csum generation and endio workload=20
from workers to endio_workers.
Otherwise it's the same.

>=20
> If btrfs_simple_end_io() can queue a work after close_ctree() has
> flushed the wq, that would be buggy even before. IIUC, it does not
> matter whether btrfs_simple_end_io() is running from interrupt (or
> interrupt thread) or from the worker thread.
>=20
> I understand that at the point when close_ctree() flushes
> endio_workers we know there will be no new interrupt ending the io
> request (that could queue an additional work). And since we know there
> won't be a new interrupt, we also know there is no csum_one_bio_work()
> queued. Right?
>=20
> So can it even happen? Coz unless I'm mistaken in the reasoning above,
> I think we're safe regarding your suspicion.
>=20
> --nX
>=20
>> We can use drain_workqueue() instead to fix it easily though.
>>
>> Mind to send out a proper patch for it?
>>
>> Thanks,
>> Qu
>>
>>>
>>>
>>> That should make sashiko happy as well as btrfs end_io work running on
>>> btrfs end_io work queues.
>>>
>>> And we should stay on the safe side wrt memory reclaim.
>>>
>>> --nX
>>>
>>>
>>>> And since the csum generation is needed for data writeback, if under
>>>> very heavy memory pressure, there may be no worker to ensure the csum
>>>> work can be queued, in that case, it will hang the writeback (which i=
s
>>>> triggered to reclaim memory).
>>>>
>>>> If we really want to address that problem, your idea about splitting =
the
>>>> patch will make a lot of sense.
>>>> We will need to keep the old infrastructure first, convert the worker=
 to
>>>> a regular workqueue, and call queue_work(), then fully remove unused =
code.
>>>>
>>>>
>>>> But on the other hand, I doubt how pratically it is for anyone to sta=
ll
>>>> system_percpu_wq.
>>>> It's very common utilized across the whole kernel, and if it really
>>>> stalls I think there are a lot of more things to bother before btrfs.
>>>>
>>>> Another thing is, if we use fs_info::workers, we will follow the
>>>> existing wq flags, which means no PERCPU flag.
>>>> And according to the existing docs for those flags, PERCPU wq has a
>>>> better performance due to CPU locality.
>>>>
>>>>
>>>> So overall I think the current version is good enough, but not perfec=
t.
>>>> On the other hand, using a WQ_MEM_RECLAIM seems more "correct", but w=
ill
>>>> definitely introduce some extra pentalty.
>>>>
>>>> If someone else has some idea on this Sashiko review, or very familia=
r
>>>> with the WQ_MEM_RECLAIM situation, any comment will be appreciated.
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>>> Suggested-by: Daniel Vacek <neelx@suse.com>
>>>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>>>> ---
>>>>>>     fs/btrfs/bio.c       | 136 +-----------------------------------=
=2D------
>>>>>>     fs/btrfs/disk-io.c   |  20 +------
>>>>>>     fs/btrfs/file-item.c |   6 +-
>>>>>>     fs/btrfs/file-item.h |   2 +-
>>>>>>     fs/btrfs/fs.h        |  10 ----
>>>>>>     fs/btrfs/super.c     |   1 -
>>>>>>     6 files changed, 4 insertions(+), 171 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
>>>>>> index 771b7d598aee..e08006543c3d 100644
>>>>>> --- a/fs/btrfs/bio.c
>>>>>> +++ b/fs/btrfs/bio.c
>>>>>> @@ -569,136 +569,7 @@ static int btrfs_bio_csum(struct btrfs_bio *b=
bio)
>>>>>>     {
>>>>>>            if (bbio->bio.bi_opf & REQ_META)
>>>>>>                    return btree_csum_one_bio(bbio);
>>>>>> -#ifdef CONFIG_BTRFS_EXPERIMENTAL
>>>>>> -       return btrfs_csum_one_bio(bbio, true);
>>>>>> -#else
>>>>>> -       return btrfs_csum_one_bio(bbio, false);
>>>>>> -#endif
>>>>>> -}
>>>>>> -
>>>>>> -/*
>>>>>> - * Async submit bios are used to offload expensive checksumming on=
to the worker
>>>>>> - * threads.
>>>>>> - */
>>>>>> -struct async_submit_bio {
>>>>>> -       struct btrfs_bio *bbio;
>>>>>> -       struct btrfs_io_context *bioc;
>>>>>> -       struct btrfs_io_stripe smap;
>>>>>> -       int mirror_num;
>>>>>> -       struct btrfs_work work;
>>>>>> -};
>>>>>> -
>>>>>> -/*
>>>>>> - * In order to insert checksums into the metadata in large chunks,=
 we wait
>>>>>> - * until bio submission time.   All the pages in the bio are check=
summed and
>>>>>> - * sums are attached onto the ordered extent record.
>>>>>> - *
>>>>>> - * At IO completion time the csums attached on the ordered extent =
record are
>>>>>> - * inserted into the btree.
>>>>>> - */
>>>>>> -static void run_one_async_start(struct btrfs_work *work)
>>>>>> -{
>>>>>> -       struct async_submit_bio *async =3D
>>>>>> -               container_of(work, struct async_submit_bio, work);
>>>>>> -       int ret;
>>>>>> -
>>>>>> -       ret =3D btrfs_bio_csum(async->bbio);
>>>>>> -       if (ret)
>>>>>> -               async->bbio->bio.bi_status =3D errno_to_blk_status(=
ret);
>>>>>> -}
>>>>>> -
>>>>>> -/*
>>>>>> - * In order to insert checksums into the metadata in large chunks,=
 we wait
>>>>>> - * until bio submission time.   All the pages in the bio are check=
summed and
>>>>>> - * sums are attached onto the ordered extent record.
>>>>>> - *
>>>>>> - * At IO completion time the csums attached on the ordered extent =
record are
>>>>>> - * inserted into the tree.
>>>>>> - *
>>>>>> - * If called with @do_free =3D=3D true, then it will free the work=
 struct.
>>>>>> - */
>>>>>> -static void run_one_async_done(struct btrfs_work *work, bool do_fr=
ee)
>>>>>> -{
>>>>>> -       struct async_submit_bio *async =3D
>>>>>> -               container_of(work, struct async_submit_bio, work);
>>>>>> -       struct bio *bio =3D &async->bbio->bio;
>>>>>> -
>>>>>> -       if (do_free) {
>>>>>> -               kfree(container_of(work, struct async_submit_bio, w=
ork));
>>>>>> -               return;
>>>>>> -       }
>>>>>> -
>>>>>> -       /* If an error occurred we just want to clean up the bio an=
d move on. */
>>>>>> -       if (bio->bi_status) {
>>>>>> -               btrfs_bio_end_io(async->bbio, bio->bi_status);
>>>>>> -               return;
>>>>>> -       }
>>>>>> -
>>>>>> -       /*
>>>>>> -        * All of the bios that pass through here are from async he=
lpers.
>>>>>> -        * Use REQ_BTRFS_CGROUP_PUNT to issue them from the owning =
cgroup's
>>>>>> -        * context.  This changes nothing when cgroups aren't in us=
e.
>>>>>> -        */
>>>>>> -       bio->bi_opf |=3D REQ_BTRFS_CGROUP_PUNT;
>>>>>> -       btrfs_submit_bio(bio, async->bioc, &async->smap, async->mir=
ror_num);
>>>>>> -}
>>>>>> -
>>>>>> -static bool should_async_write(struct btrfs_bio *bbio)
>>>>>> -{
>>>>>> -       struct btrfs_fs_info *fs_info =3D bbio->inode->root->fs_inf=
o;
>>>>>> -       bool auto_csum_mode =3D true;
>>>>>> -
>>>>>> -#ifdef CONFIG_BTRFS_EXPERIMENTAL
>>>>>> -       /*
>>>>>> -        * Write bios will calculate checksum and submit bio at the=
 same time.
>>>>>> -        * Unless explicitly required don't offload serial csum cal=
culate and bio
>>>>>> -        * submit into a workqueue.
>>>>>> -        */
>>>>>> -       return false;
>>>>>> -#endif
>>>>>> -
>>>>>> -       /* Submit synchronously if the checksum implementation is f=
ast. */
>>>>>> -       if (auto_csum_mode && test_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs=
_info->flags))
>>>>>> -               return false;
>>>>>> -
>>>>>> -       /*
>>>>>> -        * Try to defer the submission to a workqueue to paralleliz=
e the
>>>>>> -        * checksum calculation unless the I/O is issued synchronou=
sly.
>>>>>> -        */
>>>>>> -       if (op_is_sync(bbio->bio.bi_opf))
>>>>>> -               return false;
>>>>>> -
>>>>>> -       /* Zoned devices require I/O to be submitted in order. */
>>>>>> -       if ((bbio->bio.bi_opf & REQ_META) && btrfs_is_zoned(fs_info=
))
>>>>>> -               return false;
>>>>>> -
>>>>>> -       return true;
>>>>>> -}
>>>>>> -
>>>>>> -/*
>>>>>> - * Submit bio to an async queue.
>>>>>> - *
>>>>>> - * Return true if the work has been successfully submitted, else f=
alse.
>>>>>> - */
>>>>>> -static bool btrfs_wq_submit_bio(struct btrfs_bio *bbio,
>>>>>> -                               struct btrfs_io_context *bioc,
>>>>>> -                               struct btrfs_io_stripe *smap, int m=
irror_num)
>>>>>> -{
>>>>>> -       struct btrfs_fs_info *fs_info =3D bbio->inode->root->fs_inf=
o;
>>>>>> -       struct async_submit_bio *async;
>>>>>> -
>>>>>> -       async =3D kmalloc_obj(*async, GFP_NOFS);
>>>>>> -       if (!async)
>>>>>> -               return false;
>>>>>> -
>>>>>> -       async->bbio =3D bbio;
>>>>>> -       async->bioc =3D bioc;
>>>>>> -       async->smap =3D *smap;
>>>>>> -       async->mirror_num =3D mirror_num;
>>>>>> -
>>>>>> -       btrfs_init_work(&async->work, run_one_async_start, run_one_=
async_done);
>>>>>> -       btrfs_queue_work(fs_info->workers, &async->work);
>>>>>> -       return true;
>>>>>> +       return btrfs_csum_one_bio(bbio);
>>>>>>     }
>>>>>>
>>>>>>     static u64 btrfs_append_map_length(struct btrfs_bio *bbio, u64 =
map_length)
>>>>>> @@ -806,10 +677,6 @@ static bool btrfs_submit_chunk(struct btrfs_bi=
o *bbio, int mirror_num)
>>>>>>                    if (!(inode->flags & BTRFS_INODE_NODATASUM) &&
>>>>>>                        !test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_=
info->fs_state) &&
>>>>>>                        !btrfs_is_data_reloc_root(inode->root) && !b=
bio->is_remap) {
>>>>>> -                       if (should_async_write(bbio) &&
>>>>>> -                           btrfs_wq_submit_bio(bbio, bioc, &smap, =
mirror_num))
>>>>>> -                               goto done;
>>>>>> -
>>>>>>                            ret =3D btrfs_bio_csum(bbio);
>>>>>>                            status =3D errno_to_blk_status(ret);
>>>>>>                            if (status)
>>>>>> @@ -824,7 +691,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio=
 *bbio, int mirror_num)
>>>>>>            }
>>>>>>
>>>>>>            btrfs_submit_bio(bio, bioc, &smap, mirror_num);
>>>>>> -done:
>>>>>>            return map_length =3D=3D length;
>>>>>>
>>>>>>     fail:
>>>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>>>> index a1d83ad9a4c0..0046f3cb75a1 100644
>>>>>> --- a/fs/btrfs/disk-io.c
>>>>>> +++ b/fs/btrfs/disk-io.c
>>>>>> @@ -1776,7 +1776,6 @@ static void btrfs_stop_all_workers(struct btr=
fs_fs_info *fs_info)
>>>>>>            if (fs_info->fixup_workers)
>>>>>>                    destroy_workqueue(fs_info->fixup_workers);
>>>>>>            btrfs_destroy_workqueue(fs_info->delalloc_workers);
>>>>>> -       btrfs_destroy_workqueue(fs_info->workers);
>>>>>>            if (fs_info->endio_workers)
>>>>>>                    destroy_workqueue(fs_info->endio_workers);
>>>>>>            if (fs_info->rmw_workers)
>>>>>> @@ -1968,9 +1967,6 @@ static int btrfs_init_workqueues(struct btrfs=
_fs_info *fs_info)
>>>>>>            unsigned int flags =3D WQ_MEM_RECLAIM | WQ_FREEZABLE | W=
Q_UNBOUND;
>>>>>>            unsigned int ordered_flags =3D WQ_MEM_RECLAIM | WQ_FREEZ=
ABLE;
>>>>>>
>>>>>> -       fs_info->workers =3D
>>>>>> -               btrfs_alloc_workqueue(fs_info, "worker", flags, max=
_active, 16);
>>>>>> -
>>>>>>            fs_info->delalloc_workers =3D
>>>>>>                    btrfs_alloc_workqueue(fs_info, "delalloc",
>>>>>>                                          flags, max_active, 2);
>>>>>> @@ -2005,8 +2001,7 @@ static int btrfs_init_workqueues(struct btrfs=
_fs_info *fs_info)
>>>>>>            fs_info->discard_ctl.discard_workers =3D
>>>>>>                    alloc_ordered_workqueue("btrfs-discard", WQ_FREE=
ZABLE);
>>>>>>
>>>>>> -       if (!(fs_info->workers &&
>>>>>> -             fs_info->delalloc_workers && fs_info->flush_workers &=
&
>>>>>> +       if (!(fs_info->delalloc_workers && fs_info->flush_workers &=
&
>>>>>>                  fs_info->endio_workers && fs_info->endio_meta_work=
ers &&
>>>>>>                  fs_info->endio_write_workers &&
>>>>>>                  fs_info->endio_freespace_worker && fs_info->rmw_wo=
rkers &&
>>>>>> @@ -4437,19 +4432,6 @@ void __cold close_ctree(struct btrfs_fs_info=
 *fs_info)
>>>>>>             */
>>>>>>            btrfs_flush_workqueue(fs_info->delalloc_workers);
>>>>>>
>>>>>> -       /*
>>>>>> -        * We can have ordered extents getting their last reference=
 dropped from
>>>>>> -        * the fs_info->workers queue because for async writes for =
data bios we
>>>>>> -        * queue a work for that queue, at btrfs_wq_submit_bio(), t=
hat runs
>>>>>> -        * run_one_async_done() which calls btrfs_bio_end_io() in c=
ase the bio
>>>>>> -        * has an error, and that later function can do the final
>>>>>> -        * btrfs_put_ordered_extent() on the ordered extent attache=
d to the bio,
>>>>>> -        * which adds a delayed iput for the inode. So we must flus=
h the queue
>>>>>> -        * so that we don't have delayed iputs after committing the=
 current
>>>>>> -        * transaction below and stopping the cleaner and transacti=
on kthreads.
>>>>>> -        */
>>>>>> -       btrfs_flush_workqueue(fs_info->workers);
>>>>>> -
>>>>>>            /*
>>>>>>             * When finishing a compressed write bio we schedule a w=
ork queue item
>>>>>>             * to finish an ordered extent - end_bbio_compressed_wri=
te()
>>>>>> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
>>>>>> index 0fed4e0d32d5..7dbd9b8eec11 100644
>>>>>> --- a/fs/btrfs/file-item.c
>>>>>> +++ b/fs/btrfs/file-item.c
>>>>>> @@ -825,7 +825,7 @@ static void csum_one_bio_work(struct work_struc=
t *work)
>>>>>>     /*
>>>>>>      * Calculate checksums of the data contained inside a bio.
>>>>>>      */
>>>>>> -int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
>>>>>> +int btrfs_csum_one_bio(struct btrfs_bio *bbio)
>>>>>>     {
>>>>>>            struct btrfs_ordered_extent *ordered =3D bbio->ordered;
>>>>>>            struct btrfs_inode *inode =3D bbio->inode;
>>>>>> @@ -849,10 +849,6 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio,=
 bool async)
>>>>>>            btrfs_add_ordered_sum(ordered, sums);
>>>>>>
>>>>>>            bbio->csum_saved_iter =3D bio->bi_iter;
>>>>>> -       if (!async) {
>>>>>> -               csum_one_bio(bbio);
>>>>>> -               return 0;
>>>>>> -       }
>>>>>>            bio_inc_remaining(bio);
>>>>>>            INIT_WORK(&bbio->csum_work, csum_one_bio_work);
>>>>>>            schedule_work(&bbio->csum_work);
>>>>>> diff --git a/fs/btrfs/file-item.h b/fs/btrfs/file-item.h
>>>>>> index 6c678787c770..60a0eb17b3f6 100644
>>>>>> --- a/fs/btrfs/file-item.h
>>>>>> +++ b/fs/btrfs/file-item.h
>>>>>> @@ -64,7 +64,7 @@ int btrfs_lookup_file_extent(struct btrfs_trans_h=
andle *trans,
>>>>>>     int btrfs_insert_data_csums(struct btrfs_trans_handle *trans,
>>>>>>                                struct btrfs_root *root,
>>>>>>                                struct btrfs_ordered_sum *sums);
>>>>>> -int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async);
>>>>>> +int btrfs_csum_one_bio(struct btrfs_bio *bbio);
>>>>>>     int btrfs_alloc_dummy_sum(struct btrfs_bio *bbio);
>>>>>>     int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start=
, u64 end,
>>>>>>                                 struct list_head *list, int search_=
commit,
>>>>>> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
>>>>>> index 3eba8438593c..203f7131f737 100644
>>>>>> --- a/fs/btrfs/fs.h
>>>>>> +++ b/fs/btrfs/fs.h
>>>>>> @@ -696,16 +696,6 @@ struct btrfs_fs_info {
>>>>>>            /* All fs/file tree roots that have delalloc inodes. */
>>>>>>            struct list_head delalloc_roots;
>>>>>>
>>>>>> -       /*
>>>>>> -        * There is a pool of worker threads for checksumming durin=
g writes and
>>>>>> -        * a pool for checksumming after reads.  This is because re=
aders can
>>>>>> -        * run with FS locks held, and the writers may be waiting f=
or those
>>>>>> -        * locks.  We don't want ordering in the pending list to ca=
use
>>>>>> -        * deadlocks, and so the two are serviced separately.
>>>>>> -        *
>>>>>> -        * A third pool does submit_bio to avoid deadlocking with t=
he other two.
>>>>>> -        */
>>>>>> -       struct btrfs_workqueue *workers;
>>>>>>            struct btrfs_workqueue *delalloc_workers;
>>>>>>            struct btrfs_workqueue *flush_workers;
>>>>>>            struct workqueue_struct *endio_workers;
>>>>>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>>>>>> index 464129b1b0d4..54f2da47c567 100644
>>>>>> --- a/fs/btrfs/super.c
>>>>>> +++ b/fs/btrfs/super.c
>>>>>> @@ -1237,7 +1237,6 @@ static void btrfs_resize_thread_pool(struct b=
trfs_fs_info *fs_info,
>>>>>>            btrfs_info(fs_info, "resize thread pool %d -> %d",
>>>>>>                   old_pool_size, new_pool_size);
>>>>>>
>>>>>> -       btrfs_workqueue_set_max(fs_info->workers, new_pool_size);
>>>>>>            btrfs_workqueue_set_max(fs_info->delalloc_workers, new_p=
ool_size);
>>>>>>            btrfs_workqueue_set_max(fs_info->caching_workers, new_po=
ol_size);
>>>>>>            workqueue_set_max_active(fs_info->endio_workers, new_poo=
l_size);
>>>>>> --
>>>>>> 2.55.0
>>>>>>
>>>>>
>>>>
>>
>=20

