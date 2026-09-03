Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC24A3EE1F8
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 11:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788434852; cv=none; b=ujrMwEKJJRR9ggzclaQvor7LhhKzM+P3xGU5ym0umRnrfDPT7d2vW8q3Wh/yV7sZUxNyrXb7JH05YrZdG8mGoWGEnSlDYGIUVi2N3l+09d2z2jlQM60p1RXZWLT3cGS7PVdBI+KEii1sqzKvdrM/WBS9ygopt8iQgbtsBzko+1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788434852; c=relaxed/simple;
	bh=x6P+vY7zp1ijndJTKTAUz6O0zMtQU5Q6swzkjt0i4KI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CwsWdP/D3hYPrWSBef6MjTno15d+9c76Vq4TCPdSw72wcO1j3tqUszdk2Be9HMI25We4pcvTM2VjAJgApmihxAuJeyeMW3qmrnLbI9iKh4/7zEATk4en0FIvfkoc4KFl0fmXwGLsYa+KSSsuayF+LSCagJu46c3ndZIxS76cPDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=B7QIHk8e; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="B7QIHk8e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788434845; x=1789039645; i=quwenruo.btrfs@gmx.com;
	bh=EXBss20oOrGukKkXZSZmtoXCHbTlW68ErE6MRfvr7JY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=B7QIHk8edCzBxyFU8wYuaytlhYbXfT7Dx84G9jm2Twjb4vI80ik6hXidtkljXLmP
	 MEMhGUpVO0ra3HjKeteH8ea+YqBXwQv0cjBm083tXb2ti92lz7NZl+1uLZgQOUFoP
	 iM2ZL/mvphKo4I0kXAn5DbNBjMecKPKahPMLxl+q+eBNkpewUJrZw67Wid0m7p2sF
	 z14hLi+RP6CwevcaIgEicqoKzend/h4p91rR1sZ2UOTywenjTf6KuY5i4Dkc5jhzi
	 5KAHf7E1CmZs+48niLmOciDAnjKyb0YfyjswgTGR++yBeZpqZAA3X6FInuj5ejdCw
	 Gq7o8W1dxXfHNWxn+A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MmDEg-1wbrXI2yiO-00jYcc; Thu, 03
 Sep 2026 13:27:25 +0200
Message-ID: <00fc1bdb-cb69-4339-8184-afc04fceab19@gmx.com>
Date: Thu, 3 Sep 2026 20:57:22 +0930
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
In-Reply-To: <CAPjX3FeQ40fcFjfiH=5EK57YvmVDtGxyz152T9FHUOmJuuaOFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:oHGSPdYGcSEe7AE2fjG8/OkvcRvrrV8Ri8Y5A/Szaq3H5drE4TS
 3dhPB2Itu9uQJ9TiH2oytyeUVfWkscGVdKIuZRMPv3m7rC9YrUroXlUitWG0/FWDhNdyJk8
 aNPSMDGE9q4Ng/g52+ubRegUV3bf3DAbQNk7lSu1r/GciJCCfX7+4JC2kKzf0qKzv5M14CD
 ttUt/nTaE2e8iPsUHoksg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:PYpEnHsTgGU=;4VrujsCand0qh03t4tvoIhaIavZ
 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



=E5=9C=A8 2026/9/3 18:50, Daniel Vacek =E5=86=99=E9=81=93:
> On Thu, 3 Sept 2026 at 10:40, Qu Wenruo <wqu@suse.com> wrote:
>> Commit dd57c78aec39 ("btrfs: introduce btrfs_bio::async_csum")
>> introduced asynchronous data checksum generation for data writes.
>>
>> That feature can improve write performance, and was introduced in v6.19=
.
>> We have not experienced bugs related to that, so it's time to move it o=
ut
>> of experimental features for end users.
>>
>> Furthermore since the async checksum generation means
>> should_async_write() will always return false, we no longer need to
>> maintain the fs_info->workers workqueue, as the async checksum
>> generation is using the system_percpu_wq.
>=20
> I understand these are two related changes in one patch here. If
> removing async writes depends on async checksums, it would be nice to
> split this into a patch series.
>=20
> Though I guess can live with that. Looks good enough to me.
>=20
> Reviewed-by: Daniel Vacek <neelx@suse.com>

Thanks a lot for the review.


I just want to mention that, Sashiko mentioned a problem that I believe=20
is valid, but not sure how realistic it will be in the real world.


Sashiko mentioned that, the old worker workqueue has WQ_MEM_RECLAIM=20
flag, thus there will always be a rescuer to ensure forward progress.
(Although for x86_64 and other common archs or EXPERIMENTAL builds, we=20
never utilize that worker anyway)

But the new schedule_work() is using system_percpu_wq, which doesn't has=
=20
that flag.

And since the csum generation is needed for data writeback, if under=20
very heavy memory pressure, there may be no worker to ensure the csum=20
work can be queued, in that case, it will hang the writeback (which is=20
triggered to reclaim memory).

If we really want to address that problem, your idea about splitting the=
=20
patch will make a lot of sense.
We will need to keep the old infrastructure first, convert the worker to=
=20
a regular workqueue, and call queue_work(), then fully remove unused code.


But on the other hand, I doubt how pratically it is for anyone to stall=20
system_percpu_wq.
It's very common utilized across the whole kernel, and if it really=20
stalls I think there are a lot of more things to bother before btrfs.

Another thing is, if we use fs_info::workers, we will follow the=20
existing wq flags, which means no PERCPU flag.
And according to the existing docs for those flags, PERCPU wq has a=20
better performance due to CPU locality.


So overall I think the current version is good enough, but not perfect.
On the other hand, using a WQ_MEM_RECLAIM seems more "correct", but will=
=20
definitely introduce some extra pentalty.

If someone else has some idea on this Sashiko review, or very familiar=20
with the WQ_MEM_RECLAIM situation, any comment will be appreciated.

Thanks,
Qu

>=20
>> Suggested-by: Daniel Vacek <neelx@suse.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/bio.c       | 136 +-----------------------------------------=
-
>>   fs/btrfs/disk-io.c   |  20 +------
>>   fs/btrfs/file-item.c |   6 +-
>>   fs/btrfs/file-item.h |   2 +-
>>   fs/btrfs/fs.h        |  10 ----
>>   fs/btrfs/super.c     |   1 -
>>   6 files changed, 4 insertions(+), 171 deletions(-)
>>
>> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
>> index 771b7d598aee..e08006543c3d 100644
>> --- a/fs/btrfs/bio.c
>> +++ b/fs/btrfs/bio.c
>> @@ -569,136 +569,7 @@ static int btrfs_bio_csum(struct btrfs_bio *bbio)
>>   {
>>          if (bbio->bio.bi_opf & REQ_META)
>>                  return btree_csum_one_bio(bbio);
>> -#ifdef CONFIG_BTRFS_EXPERIMENTAL
>> -       return btrfs_csum_one_bio(bbio, true);
>> -#else
>> -       return btrfs_csum_one_bio(bbio, false);
>> -#endif
>> -}
>> -
>> -/*
>> - * Async submit bios are used to offload expensive checksumming onto t=
he worker
>> - * threads.
>> - */
>> -struct async_submit_bio {
>> -       struct btrfs_bio *bbio;
>> -       struct btrfs_io_context *bioc;
>> -       struct btrfs_io_stripe smap;
>> -       int mirror_num;
>> -       struct btrfs_work work;
>> -};
>> -
>> -/*
>> - * In order to insert checksums into the metadata in large chunks, we =
wait
>> - * until bio submission time.   All the pages in the bio are checksumm=
ed and
>> - * sums are attached onto the ordered extent record.
>> - *
>> - * At IO completion time the csums attached on the ordered extent reco=
rd are
>> - * inserted into the btree.
>> - */
>> -static void run_one_async_start(struct btrfs_work *work)
>> -{
>> -       struct async_submit_bio *async =3D
>> -               container_of(work, struct async_submit_bio, work);
>> -       int ret;
>> -
>> -       ret =3D btrfs_bio_csum(async->bbio);
>> -       if (ret)
>> -               async->bbio->bio.bi_status =3D errno_to_blk_status(ret)=
;
>> -}
>> -
>> -/*
>> - * In order to insert checksums into the metadata in large chunks, we =
wait
>> - * until bio submission time.   All the pages in the bio are checksumm=
ed and
>> - * sums are attached onto the ordered extent record.
>> - *
>> - * At IO completion time the csums attached on the ordered extent reco=
rd are
>> - * inserted into the tree.
>> - *
>> - * If called with @do_free =3D=3D true, then it will free the work str=
uct.
>> - */
>> -static void run_one_async_done(struct btrfs_work *work, bool do_free)
>> -{
>> -       struct async_submit_bio *async =3D
>> -               container_of(work, struct async_submit_bio, work);
>> -       struct bio *bio =3D &async->bbio->bio;
>> -
>> -       if (do_free) {
>> -               kfree(container_of(work, struct async_submit_bio, work)=
);
>> -               return;
>> -       }
>> -
>> -       /* If an error occurred we just want to clean up the bio and mo=
ve on. */
>> -       if (bio->bi_status) {
>> -               btrfs_bio_end_io(async->bbio, bio->bi_status);
>> -               return;
>> -       }
>> -
>> -       /*
>> -        * All of the bios that pass through here are from async helper=
s.
>> -        * Use REQ_BTRFS_CGROUP_PUNT to issue them from the owning cgro=
up's
>> -        * context.  This changes nothing when cgroups aren't in use.
>> -        */
>> -       bio->bi_opf |=3D REQ_BTRFS_CGROUP_PUNT;
>> -       btrfs_submit_bio(bio, async->bioc, &async->smap, async->mirror_=
num);
>> -}
>> -
>> -static bool should_async_write(struct btrfs_bio *bbio)
>> -{
>> -       struct btrfs_fs_info *fs_info =3D bbio->inode->root->fs_info;
>> -       bool auto_csum_mode =3D true;
>> -
>> -#ifdef CONFIG_BTRFS_EXPERIMENTAL
>> -       /*
>> -        * Write bios will calculate checksum and submit bio at the sam=
e time.
>> -        * Unless explicitly required don't offload serial csum calcula=
te and bio
>> -        * submit into a workqueue.
>> -        */
>> -       return false;
>> -#endif
>> -
>> -       /* Submit synchronously if the checksum implementation is fast.=
 */
>> -       if (auto_csum_mode && test_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_inf=
o->flags))
>> -               return false;
>> -
>> -       /*
>> -        * Try to defer the submission to a workqueue to parallelize th=
e
>> -        * checksum calculation unless the I/O is issued synchronously.
>> -        */
>> -       if (op_is_sync(bbio->bio.bi_opf))
>> -               return false;
>> -
>> -       /* Zoned devices require I/O to be submitted in order. */
>> -       if ((bbio->bio.bi_opf & REQ_META) && btrfs_is_zoned(fs_info))
>> -               return false;
>> -
>> -       return true;
>> -}
>> -
>> -/*
>> - * Submit bio to an async queue.
>> - *
>> - * Return true if the work has been successfully submitted, else false=
.
>> - */
>> -static bool btrfs_wq_submit_bio(struct btrfs_bio *bbio,
>> -                               struct btrfs_io_context *bioc,
>> -                               struct btrfs_io_stripe *smap, int mirro=
r_num)
>> -{
>> -       struct btrfs_fs_info *fs_info =3D bbio->inode->root->fs_info;
>> -       struct async_submit_bio *async;
>> -
>> -       async =3D kmalloc_obj(*async, GFP_NOFS);
>> -       if (!async)
>> -               return false;
>> -
>> -       async->bbio =3D bbio;
>> -       async->bioc =3D bioc;
>> -       async->smap =3D *smap;
>> -       async->mirror_num =3D mirror_num;
>> -
>> -       btrfs_init_work(&async->work, run_one_async_start, run_one_asyn=
c_done);
>> -       btrfs_queue_work(fs_info->workers, &async->work);
>> -       return true;
>> +       return btrfs_csum_one_bio(bbio);
>>   }
>>
>>   static u64 btrfs_append_map_length(struct btrfs_bio *bbio, u64 map_le=
ngth)
>> @@ -806,10 +677,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio *b=
bio, int mirror_num)
>>                  if (!(inode->flags & BTRFS_INODE_NODATASUM) &&
>>                      !test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_info->=
fs_state) &&
>>                      !btrfs_is_data_reloc_root(inode->root) && !bbio->i=
s_remap) {
>> -                       if (should_async_write(bbio) &&
>> -                           btrfs_wq_submit_bio(bbio, bioc, &smap, mirr=
or_num))
>> -                               goto done;
>> -
>>                          ret =3D btrfs_bio_csum(bbio);
>>                          status =3D errno_to_blk_status(ret);
>>                          if (status)
>> @@ -824,7 +691,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bb=
io, int mirror_num)
>>          }
>>
>>          btrfs_submit_bio(bio, bioc, &smap, mirror_num);
>> -done:
>>          return map_length =3D=3D length;
>>
>>   fail:
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index a1d83ad9a4c0..0046f3cb75a1 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -1776,7 +1776,6 @@ static void btrfs_stop_all_workers(struct btrfs_f=
s_info *fs_info)
>>          if (fs_info->fixup_workers)
>>                  destroy_workqueue(fs_info->fixup_workers);
>>          btrfs_destroy_workqueue(fs_info->delalloc_workers);
>> -       btrfs_destroy_workqueue(fs_info->workers);
>>          if (fs_info->endio_workers)
>>                  destroy_workqueue(fs_info->endio_workers);
>>          if (fs_info->rmw_workers)
>> @@ -1968,9 +1967,6 @@ static int btrfs_init_workqueues(struct btrfs_fs_=
info *fs_info)
>>          unsigned int flags =3D WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBO=
UND;
>>          unsigned int ordered_flags =3D WQ_MEM_RECLAIM | WQ_FREEZABLE;
>>
>> -       fs_info->workers =3D
>> -               btrfs_alloc_workqueue(fs_info, "worker", flags, max_act=
ive, 16);
>> -
>>          fs_info->delalloc_workers =3D
>>                  btrfs_alloc_workqueue(fs_info, "delalloc",
>>                                        flags, max_active, 2);
>> @@ -2005,8 +2001,7 @@ static int btrfs_init_workqueues(struct btrfs_fs_=
info *fs_info)
>>          fs_info->discard_ctl.discard_workers =3D
>>                  alloc_ordered_workqueue("btrfs-discard", WQ_FREEZABLE)=
;
>>
>> -       if (!(fs_info->workers &&
>> -             fs_info->delalloc_workers && fs_info->flush_workers &&
>> +       if (!(fs_info->delalloc_workers && fs_info->flush_workers &&
>>                fs_info->endio_workers && fs_info->endio_meta_workers &&
>>                fs_info->endio_write_workers &&
>>                fs_info->endio_freespace_worker && fs_info->rmw_workers =
&&
>> @@ -4437,19 +4432,6 @@ void __cold close_ctree(struct btrfs_fs_info *fs=
_info)
>>           */
>>          btrfs_flush_workqueue(fs_info->delalloc_workers);
>>
>> -       /*
>> -        * We can have ordered extents getting their last reference dro=
pped from
>> -        * the fs_info->workers queue because for async writes for data=
 bios we
>> -        * queue a work for that queue, at btrfs_wq_submit_bio(), that =
runs
>> -        * run_one_async_done() which calls btrfs_bio_end_io() in case =
the bio
>> -        * has an error, and that later function can do the final
>> -        * btrfs_put_ordered_extent() on the ordered extent attached to=
 the bio,
>> -        * which adds a delayed iput for the inode. So we must flush th=
e queue
>> -        * so that we don't have delayed iputs after committing the cur=
rent
>> -        * transaction below and stopping the cleaner and transaction k=
threads.
>> -        */
>> -       btrfs_flush_workqueue(fs_info->workers);
>> -
>>          /*
>>           * When finishing a compressed write bio we schedule a work qu=
eue item
>>           * to finish an ordered extent - end_bbio_compressed_write()
>> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
>> index 0fed4e0d32d5..7dbd9b8eec11 100644
>> --- a/fs/btrfs/file-item.c
>> +++ b/fs/btrfs/file-item.c
>> @@ -825,7 +825,7 @@ static void csum_one_bio_work(struct work_struct *w=
ork)
>>   /*
>>    * Calculate checksums of the data contained inside a bio.
>>    */
>> -int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
>> +int btrfs_csum_one_bio(struct btrfs_bio *bbio)
>>   {
>>          struct btrfs_ordered_extent *ordered =3D bbio->ordered;
>>          struct btrfs_inode *inode =3D bbio->inode;
>> @@ -849,10 +849,6 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, boo=
l async)
>>          btrfs_add_ordered_sum(ordered, sums);
>>
>>          bbio->csum_saved_iter =3D bio->bi_iter;
>> -       if (!async) {
>> -               csum_one_bio(bbio);
>> -               return 0;
>> -       }
>>          bio_inc_remaining(bio);
>>          INIT_WORK(&bbio->csum_work, csum_one_bio_work);
>>          schedule_work(&bbio->csum_work);
>> diff --git a/fs/btrfs/file-item.h b/fs/btrfs/file-item.h
>> index 6c678787c770..60a0eb17b3f6 100644
>> --- a/fs/btrfs/file-item.h
>> +++ b/fs/btrfs/file-item.h
>> @@ -64,7 +64,7 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handl=
e *trans,
>>   int btrfs_insert_data_csums(struct btrfs_trans_handle *trans,
>>                              struct btrfs_root *root,
>>                              struct btrfs_ordered_sum *sums);
>> -int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async);
>> +int btrfs_csum_one_bio(struct btrfs_bio *bbio);
>>   int btrfs_alloc_dummy_sum(struct btrfs_bio *bbio);
>>   int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 =
end,
>>                               struct list_head *list, int search_commit=
,
>> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
>> index 3eba8438593c..203f7131f737 100644
>> --- a/fs/btrfs/fs.h
>> +++ b/fs/btrfs/fs.h
>> @@ -696,16 +696,6 @@ struct btrfs_fs_info {
>>          /* All fs/file tree roots that have delalloc inodes. */
>>          struct list_head delalloc_roots;
>>
>> -       /*
>> -        * There is a pool of worker threads for checksumming during wr=
ites and
>> -        * a pool for checksumming after reads.  This is because reader=
s can
>> -        * run with FS locks held, and the writers may be waiting for t=
hose
>> -        * locks.  We don't want ordering in the pending list to cause
>> -        * deadlocks, and so the two are serviced separately.
>> -        *
>> -        * A third pool does submit_bio to avoid deadlocking with the o=
ther two.
>> -        */
>> -       struct btrfs_workqueue *workers;
>>          struct btrfs_workqueue *delalloc_workers;
>>          struct btrfs_workqueue *flush_workers;
>>          struct workqueue_struct *endio_workers;
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 464129b1b0d4..54f2da47c567 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -1237,7 +1237,6 @@ static void btrfs_resize_thread_pool(struct btrfs=
_fs_info *fs_info,
>>          btrfs_info(fs_info, "resize thread pool %d -> %d",
>>                 old_pool_size, new_pool_size);
>>
>> -       btrfs_workqueue_set_max(fs_info->workers, new_pool_size);
>>          btrfs_workqueue_set_max(fs_info->delalloc_workers, new_pool_si=
ze);
>>          btrfs_workqueue_set_max(fs_info->caching_workers, new_pool_siz=
e);
>>          workqueue_set_max_active(fs_info->endio_workers, new_pool_size=
);
>> --
>> 2.55.0
>>
>=20

