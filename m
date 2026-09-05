Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6503438DC79
	for <linux-btrfs@vger.kernel.org>; Sat,  5 Sep 2026 10:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788602995; cv=pass; b=ng3AzXZGAfh2g0ry4Hz0Knw38m61lxd63Ho0Nkd8heoO4o9gIk3n7VDHHPdBAMLzrwNrj/5fgasnKYNEdaU0SRfiq9cSs/Y2tO8ypliVsfM+A6mfkCl69jQ4jua/WCHZcYcW7heJLGgYO6hjJJvCbonhW36q5DtCsaPvZfcmQg4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788602995; c=relaxed/simple;
	bh=ScDwdsru78EKfDejGxIy6QlVZFav74d7f+nJIcA5OPM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E79d6NamScuQcxZ4HI3nnIP3ozl8u6jUznOUxOHUwF7XxJglnYyRm1FRlvqHRT3/ceV5MtRvxdyYCr7CJyZZoMd9Nru7XeULUYGJI+IBte1XVTTaxu7Ulkn1p0/yos/9gx2JApk+dVWbjkUEtECkYIkTXmt3YwM8M0yBNt8nvzM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LMvQ3hgL; arc=pass smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LMvQ3hgL"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4858303de5dso2282550f8f.2
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Sep 2026 03:09:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788602988; cv=none;
        d=google.com; s=arc-20260327;
        b=jW9Y+/OCP0R/I4GknsOkRtyRdsphYZP2hZyyXfNAZ5RzNsGOsw4k9/l2lXWOko9acT
         bbYSsv2K41ll2syqnC9B4c8GkHptiV0KDVte8PAKcQUeYplU7CwRBqEQYAZa/iKx4HC0
         tf9au8lZfRkbjh/gWa/RDxZFfAWBMmaRMxt/rtc+B91U29JoJSQOu8qDQsH7YXeMwkbl
         pJ04/IHUKxmZFq2YlOhVdZbqxfMJXP3UcSQKFNmzUKo78CPhfT1JyK0M2TysOqMuo9jv
         U5eXvhVsLyejNRMOtqZiIzJXqpSod14vuXMd47APGHhzFkfigS2FN112Rx/XalUVe0VP
         NHWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iYIJFsNmxRg0Tz3U+NlVHnJvhdNOz8uzlVEhQcaS12U=;
        fh=1BJU3Czfw2L9FWyHQX/w7j4FL+WYrEkP/zZHGC8F2gU=;
        b=FdYbCCoQ1cM0enRsvSbDo77/bNNiAFfRzsGB+b9YdLGBwbzfFQsHw4nvhlTK2w2dpX
         cxNOVSTOG363E+vSa8OGpCowNFewcTiB6FIPMsu/dq/kUXrRQqszYSYdf0gX/a6zIAy6
         O0Q5EoxLYAXK+vpNXkZ7p9VKwb6y5JuZVvK80cisALmFd0WbFSppad893qOAPnd6vLOU
         c25I1YzAvOhnSSpf/ZjgIu5K4O/ba7yu7fUXeGTATBYuZYo6/LJMHo7OcsnTsYiJ82ft
         IMN26G4Y68LGnzN/5YB0R5l2moyMW29LVypsBTPg/iO9yPtscko9xZf5NeNU+hGVDuSq
         HPSA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788602988; x=1789207788; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iYIJFsNmxRg0Tz3U+NlVHnJvhdNOz8uzlVEhQcaS12U=;
        b=LMvQ3hgLBV5Hg9W1y51lC0VDV8GUE6P/C5u7bnPdDjN3B+r+DAORuGSMj1u8QNoeet
         Bevo2jIRLLgV3mxfIYKMYuyIzpEqjDXvemUsFhcCXnompv+EdZBqR6LLc0Qq4TmO4Jec
         O8Mv5VNYZxuQVOBTSALeAm213jfMVgUUvn1131zvqUYCzUvoheKmhpH6Osc4ChQlBXvc
         6SQA4JlHUH7XCyeS8HTbYMiaQEDOcLkd6W6c2eydr9WcHonKpuTO8wHA8rEhzrYrt948
         BJNysIGKwIxZE5rYt5y/RDIfuUYkZvoW4LHBsppyBfQ3eNoa4948qbX/B1+96kvO55Mh
         /SEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788602988; x=1789207788;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iYIJFsNmxRg0Tz3U+NlVHnJvhdNOz8uzlVEhQcaS12U=;
        b=BEnBsL1J9MdNXfSkTbGkT3IEk+LrySPJQqdWw9Ud3Ad+pQE6JTVbvf3tEoDyqj3dEx
         6EPCCX+eMIbsDl9ADkBf0zIWaKDLpNnna95wqkGRDthlP6gFHxBIb+3O46UPHAPtWvxH
         dWHrl9TrG0/ROg9OfMNa3h6FzAc5CSDSSirJGMLkLeFMynBymfjesCxMF2aGKvc4sTDs
         6kr0FOyGZJDLjCzepwgBq2at2AMGzllLQvKWwxJKClQ/f5o7Fr18g1W3JoRPK7TbOZpW
         oQtpFNLAwaR7fD689pSzGVESb7WofBuzR5MMdr9lpBpgDHCynS5Qtvty5Uqx4xxKUM3v
         AQQQ==
X-Forwarded-Encrypted: i=1; AKwUvBwNdb3i6I3/eV3nFl+eDQYP/8DRFSoz27Qd+5oi93KY4VGAC8PzkT8i6ybjStZXCtLN07m9MI0murtM+g==@vger.kernel.org
X-Gm-Message-State: AFuF++nBlgQAnVZE032LuMTIEDUmLQxUxpvdY8+Db1VupPqPGnh5bVT4
	s1SP6+xWqin9W0t2cp00fltvhoJQ+JKoXsrA8XiQY/1vhEbtwlHExKZplJa/3OHnplLfSYZT1QM
	tPf9TPo3aEcgiAQZfBiU9aYn7R04F0/5HyXCxsEHpOQ==
X-Gm-Gg: AYBFou0HPLbHdq4OytQQVbJ+Tr8uO4ai0H+su4cknoQL0pgEZxt/jF4I26uMXNPAiKV
	n4OL6QJQt9CDKYhTHm/00o9O7ATghauZM05N4WngBZZR9pJGqdTHDfvH7rmF+pJoI837k6eCiqu
	JbpjU1t906wlzzipETVQzDka4ESKzmlIbLAlR5kmTzps6rskc21ui6cXyMo4v3IwONFX9slf+4p
	zqtUuMbpVUNK4rcV7cEAXD2YLqfBOaPXWY6XDCmrdVqmFvCTQPwog1WZyEgyfffOTmiZyl04hGJ
	9hIdA+xJ6mWSmGWwRd1D28+y6CSzMYTCVLKgVFdS+mc2zve/w4pYLYqcwU5Weaw1nORuFO2DQBr
	is5jdDvJBGyF3O+j/9ZGYq/dRQ0rBHPkZvGMvIt5AXw==
X-Received: by 2002:a05:6000:24c8:b0:485:8c16:a33e with SMTP id
 ffacd0b85a97d-4858c16a715mr9101184f8f.51.1788602988317; Sat, 05 Sep 2026
 03:09:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <700ba6c46da86ace18a502b43c5e61d16a556060.1788424754.git.wqu@suse.com>
 <CAPjX3FeQ40fcFjfiH=5EK57YvmVDtGxyz152T9FHUOmJuuaOFQ@mail.gmail.com>
 <00fc1bdb-cb69-4339-8184-afc04fceab19@gmx.com> <CAPjX3FdkWegsttPk9FiTiVUp9dcdycWWmecnpSxcgrpwnw=TEg@mail.gmail.com>
 <130fdc9a-2d51-49cd-bf7f-c8e4b8fa19aa@suse.com>
In-Reply-To: <130fdc9a-2d51-49cd-bf7f-c8e4b8fa19aa@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Sat, 5 Sep 2026 12:09:36 +0200
X-Gm-Features: AcwNN1XyJpgMP_cVQcLlA3tLc6_hcI5lZFL0595d2Bf-zN8Qk_Kp9KrBVUD95gI
Message-ID: <CAPjX3Ff6aiRURh-uufDJ2pkw9Y0SJ6X-WyayxnV6NWiV69-EXg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: move async csum generation out of experimental features
To: Qu Wenruo <wqu@suse.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 5 Sept 2026 at 02:57, Qu Wenruo <wqu@suse.com> wrote:
> =E5=9C=A8 2026/9/3 22:14, Daniel Vacek =E5=86=99=E9=81=93:
> > On Thu, 3 Sept 2026 at 13:27, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> >> =E5=9C=A8 2026/9/3 18:50, Daniel Vacek =E5=86=99=E9=81=93:
> >>> On Thu, 3 Sept 2026 at 10:40, Qu Wenruo <wqu@suse.com> wrote:
> >>>> Commit dd57c78aec39 ("btrfs: introduce btrfs_bio::async_csum")
> >>>> introduced asynchronous data checksum generation for data writes.
> >>>>
> >>>> That feature can improve write performance, and was introduced in v6=
.19.
> >>>> We have not experienced bugs related to that, so it's time to move i=
t out
> >>>> of experimental features for end users.
> >>>>
> >>>> Furthermore since the async checksum generation means
> >>>> should_async_write() will always return false, we no longer need to
> >>>> maintain the fs_info->workers workqueue, as the async checksum
> >>>> generation is using the system_percpu_wq.
> >>>
> >>> I understand these are two related changes in one patch here. If
> >>> removing async writes depends on async checksums, it would be nice to
> >>> split this into a patch series.
> >>>
> >>> Though I guess can live with that. Looks good enough to me.
> >>>
> >>> Reviewed-by: Daniel Vacek <neelx@suse.com>
> >>
> >> Thanks a lot for the review.
> >>
> >>
> >> I just want to mention that, Sashiko mentioned a problem that I believ=
e
> >> is valid, but not sure how realistic it will be in the real world.
> >>
> >>
> >> Sashiko mentioned that, the old worker workqueue has WQ_MEM_RECLAIM
> >> flag, thus there will always be a rescuer to ensure forward progress.
> >> (Although for x86_64 and other common archs or EXPERIMENTAL builds, we
> >> never utilize that worker anyway)
> >>
> >> But the new schedule_work() is using system_percpu_wq, which doesn't h=
as
> >> that flag.
> >
> > Well, I think squashing this fixup to my patch is the right thing to do=
 anyways:
> >
> > diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> > index 0fed4e0d32d5..984d87ad79b0 100644
> > --- a/fs/btrfs/file-item.c
> > +++ b/fs/btrfs/file-item.c
> > @@ -855,7 +855,7 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool=
 async)
> >       }
> >       bio_inc_remaining(bio);
> >       INIT_WORK(&bbio->csum_work, csum_one_bio_work);
> > -    schedule_work(&bbio->csum_work);
> > +    queue_work(fs_info->endio_workers, &bbio->csum_work);
> >       return 0;
> >   }
>
> This has one new problem though.
>
> The csum_one_bio_work() can queue a new work into the same endio_workers.
>
> It happens like this:
>
> csum_one_bio_work()
> |- bio_endio()
> |  |- btrfs_simple_end_io()
>        |- queue_work() into endio_workers again
>
> This can cause problems with flush_workqueue() in close_ctree(), where
> we only flush the workqueue once, which doesn't ensure newly created
> work is also flushed.

Do you know of any situation where this can happen?

If btrfs_simple_end_io() can queue a work after close_ctree() has
flushed the wq, that would be buggy even before. IIUC, it does not
matter whether btrfs_simple_end_io() is running from interrupt (or
interrupt thread) or from the worker thread.

I understand that at the point when close_ctree() flushes
endio_workers we know there will be no new interrupt ending the io
request (that could queue an additional work). And since we know there
won't be a new interrupt, we also know there is no csum_one_bio_work()
queued. Right?

So can it even happen? Coz unless I'm mistaken in the reasoning above,
I think we're safe regarding your suspicion.

--nX

> We can use drain_workqueue() instead to fix it easily though.
>
> Mind to send out a proper patch for it?
>
> Thanks,
> Qu
>
> >
> >
> > That should make sashiko happy as well as btrfs end_io work running on
> > btrfs end_io work queues.
> >
> > And we should stay on the safe side wrt memory reclaim.
> >
> > --nX
> >
> >
> >> And since the csum generation is needed for data writeback, if under
> >> very heavy memory pressure, there may be no worker to ensure the csum
> >> work can be queued, in that case, it will hang the writeback (which is
> >> triggered to reclaim memory).
> >>
> >> If we really want to address that problem, your idea about splitting t=
he
> >> patch will make a lot of sense.
> >> We will need to keep the old infrastructure first, convert the worker =
to
> >> a regular workqueue, and call queue_work(), then fully remove unused c=
ode.
> >>
> >>
> >> But on the other hand, I doubt how pratically it is for anyone to stal=
l
> >> system_percpu_wq.
> >> It's very common utilized across the whole kernel, and if it really
> >> stalls I think there are a lot of more things to bother before btrfs.
> >>
> >> Another thing is, if we use fs_info::workers, we will follow the
> >> existing wq flags, which means no PERCPU flag.
> >> And according to the existing docs for those flags, PERCPU wq has a
> >> better performance due to CPU locality.
> >>
> >>
> >> So overall I think the current version is good enough, but not perfect=
.
> >> On the other hand, using a WQ_MEM_RECLAIM seems more "correct", but wi=
ll
> >> definitely introduce some extra pentalty.
> >>
> >> If someone else has some idea on this Sashiko review, or very familiar
> >> with the WQ_MEM_RECLAIM situation, any comment will be appreciated.
> >>
> >> Thanks,
> >> Qu
> >>
> >>>
> >>>> Suggested-by: Daniel Vacek <neelx@suse.com>
> >>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >>>> ---
> >>>>    fs/btrfs/bio.c       | 136 +-------------------------------------=
-----
> >>>>    fs/btrfs/disk-io.c   |  20 +------
> >>>>    fs/btrfs/file-item.c |   6 +-
> >>>>    fs/btrfs/file-item.h |   2 +-
> >>>>    fs/btrfs/fs.h        |  10 ----
> >>>>    fs/btrfs/super.c     |   1 -
> >>>>    6 files changed, 4 insertions(+), 171 deletions(-)
> >>>>
> >>>> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> >>>> index 771b7d598aee..e08006543c3d 100644
> >>>> --- a/fs/btrfs/bio.c
> >>>> +++ b/fs/btrfs/bio.c
> >>>> @@ -569,136 +569,7 @@ static int btrfs_bio_csum(struct btrfs_bio *bb=
io)
> >>>>    {
> >>>>           if (bbio->bio.bi_opf & REQ_META)
> >>>>                   return btree_csum_one_bio(bbio);
> >>>> -#ifdef CONFIG_BTRFS_EXPERIMENTAL
> >>>> -       return btrfs_csum_one_bio(bbio, true);
> >>>> -#else
> >>>> -       return btrfs_csum_one_bio(bbio, false);
> >>>> -#endif
> >>>> -}
> >>>> -
> >>>> -/*
> >>>> - * Async submit bios are used to offload expensive checksumming ont=
o the worker
> >>>> - * threads.
> >>>> - */
> >>>> -struct async_submit_bio {
> >>>> -       struct btrfs_bio *bbio;
> >>>> -       struct btrfs_io_context *bioc;
> >>>> -       struct btrfs_io_stripe smap;
> >>>> -       int mirror_num;
> >>>> -       struct btrfs_work work;
> >>>> -};
> >>>> -
> >>>> -/*
> >>>> - * In order to insert checksums into the metadata in large chunks, =
we wait
> >>>> - * until bio submission time.   All the pages in the bio are checks=
ummed and
> >>>> - * sums are attached onto the ordered extent record.
> >>>> - *
> >>>> - * At IO completion time the csums attached on the ordered extent r=
ecord are
> >>>> - * inserted into the btree.
> >>>> - */
> >>>> -static void run_one_async_start(struct btrfs_work *work)
> >>>> -{
> >>>> -       struct async_submit_bio *async =3D
> >>>> -               container_of(work, struct async_submit_bio, work);
> >>>> -       int ret;
> >>>> -
> >>>> -       ret =3D btrfs_bio_csum(async->bbio);
> >>>> -       if (ret)
> >>>> -               async->bbio->bio.bi_status =3D errno_to_blk_status(r=
et);
> >>>> -}
> >>>> -
> >>>> -/*
> >>>> - * In order to insert checksums into the metadata in large chunks, =
we wait
> >>>> - * until bio submission time.   All the pages in the bio are checks=
ummed and
> >>>> - * sums are attached onto the ordered extent record.
> >>>> - *
> >>>> - * At IO completion time the csums attached on the ordered extent r=
ecord are
> >>>> - * inserted into the tree.
> >>>> - *
> >>>> - * If called with @do_free =3D=3D true, then it will free the work =
struct.
> >>>> - */
> >>>> -static void run_one_async_done(struct btrfs_work *work, bool do_fre=
e)
> >>>> -{
> >>>> -       struct async_submit_bio *async =3D
> >>>> -               container_of(work, struct async_submit_bio, work);
> >>>> -       struct bio *bio =3D &async->bbio->bio;
> >>>> -
> >>>> -       if (do_free) {
> >>>> -               kfree(container_of(work, struct async_submit_bio, wo=
rk));
> >>>> -               return;
> >>>> -       }
> >>>> -
> >>>> -       /* If an error occurred we just want to clean up the bio and=
 move on. */
> >>>> -       if (bio->bi_status) {
> >>>> -               btrfs_bio_end_io(async->bbio, bio->bi_status);
> >>>> -               return;
> >>>> -       }
> >>>> -
> >>>> -       /*
> >>>> -        * All of the bios that pass through here are from async hel=
pers.
> >>>> -        * Use REQ_BTRFS_CGROUP_PUNT to issue them from the owning c=
group's
> >>>> -        * context.  This changes nothing when cgroups aren't in use=
.
> >>>> -        */
> >>>> -       bio->bi_opf |=3D REQ_BTRFS_CGROUP_PUNT;
> >>>> -       btrfs_submit_bio(bio, async->bioc, &async->smap, async->mirr=
or_num);
> >>>> -}
> >>>> -
> >>>> -static bool should_async_write(struct btrfs_bio *bbio)
> >>>> -{
> >>>> -       struct btrfs_fs_info *fs_info =3D bbio->inode->root->fs_info=
;
> >>>> -       bool auto_csum_mode =3D true;
> >>>> -
> >>>> -#ifdef CONFIG_BTRFS_EXPERIMENTAL
> >>>> -       /*
> >>>> -        * Write bios will calculate checksum and submit bio at the =
same time.
> >>>> -        * Unless explicitly required don't offload serial csum calc=
ulate and bio
> >>>> -        * submit into a workqueue.
> >>>> -        */
> >>>> -       return false;
> >>>> -#endif
> >>>> -
> >>>> -       /* Submit synchronously if the checksum implementation is fa=
st. */
> >>>> -       if (auto_csum_mode && test_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_=
info->flags))
> >>>> -               return false;
> >>>> -
> >>>> -       /*
> >>>> -        * Try to defer the submission to a workqueue to parallelize=
 the
> >>>> -        * checksum calculation unless the I/O is issued synchronous=
ly.
> >>>> -        */
> >>>> -       if (op_is_sync(bbio->bio.bi_opf))
> >>>> -               return false;
> >>>> -
> >>>> -       /* Zoned devices require I/O to be submitted in order. */
> >>>> -       if ((bbio->bio.bi_opf & REQ_META) && btrfs_is_zoned(fs_info)=
)
> >>>> -               return false;
> >>>> -
> >>>> -       return true;
> >>>> -}
> >>>> -
> >>>> -/*
> >>>> - * Submit bio to an async queue.
> >>>> - *
> >>>> - * Return true if the work has been successfully submitted, else fa=
lse.
> >>>> - */
> >>>> -static bool btrfs_wq_submit_bio(struct btrfs_bio *bbio,
> >>>> -                               struct btrfs_io_context *bioc,
> >>>> -                               struct btrfs_io_stripe *smap, int mi=
rror_num)
> >>>> -{
> >>>> -       struct btrfs_fs_info *fs_info =3D bbio->inode->root->fs_info=
;
> >>>> -       struct async_submit_bio *async;
> >>>> -
> >>>> -       async =3D kmalloc_obj(*async, GFP_NOFS);
> >>>> -       if (!async)
> >>>> -               return false;
> >>>> -
> >>>> -       async->bbio =3D bbio;
> >>>> -       async->bioc =3D bioc;
> >>>> -       async->smap =3D *smap;
> >>>> -       async->mirror_num =3D mirror_num;
> >>>> -
> >>>> -       btrfs_init_work(&async->work, run_one_async_start, run_one_a=
sync_done);
> >>>> -       btrfs_queue_work(fs_info->workers, &async->work);
> >>>> -       return true;
> >>>> +       return btrfs_csum_one_bio(bbio);
> >>>>    }
> >>>>
> >>>>    static u64 btrfs_append_map_length(struct btrfs_bio *bbio, u64 ma=
p_length)
> >>>> @@ -806,10 +677,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio=
 *bbio, int mirror_num)
> >>>>                   if (!(inode->flags & BTRFS_INODE_NODATASUM) &&
> >>>>                       !test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_in=
fo->fs_state) &&
> >>>>                       !btrfs_is_data_reloc_root(inode->root) && !bbi=
o->is_remap) {
> >>>> -                       if (should_async_write(bbio) &&
> >>>> -                           btrfs_wq_submit_bio(bbio, bioc, &smap, m=
irror_num))
> >>>> -                               goto done;
> >>>> -
> >>>>                           ret =3D btrfs_bio_csum(bbio);
> >>>>                           status =3D errno_to_blk_status(ret);
> >>>>                           if (status)
> >>>> @@ -824,7 +691,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio =
*bbio, int mirror_num)
> >>>>           }
> >>>>
> >>>>           btrfs_submit_bio(bio, bioc, &smap, mirror_num);
> >>>> -done:
> >>>>           return map_length =3D=3D length;
> >>>>
> >>>>    fail:
> >>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> >>>> index a1d83ad9a4c0..0046f3cb75a1 100644
> >>>> --- a/fs/btrfs/disk-io.c
> >>>> +++ b/fs/btrfs/disk-io.c
> >>>> @@ -1776,7 +1776,6 @@ static void btrfs_stop_all_workers(struct btrf=
s_fs_info *fs_info)
> >>>>           if (fs_info->fixup_workers)
> >>>>                   destroy_workqueue(fs_info->fixup_workers);
> >>>>           btrfs_destroy_workqueue(fs_info->delalloc_workers);
> >>>> -       btrfs_destroy_workqueue(fs_info->workers);
> >>>>           if (fs_info->endio_workers)
> >>>>                   destroy_workqueue(fs_info->endio_workers);
> >>>>           if (fs_info->rmw_workers)
> >>>> @@ -1968,9 +1967,6 @@ static int btrfs_init_workqueues(struct btrfs_=
fs_info *fs_info)
> >>>>           unsigned int flags =3D WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_=
UNBOUND;
> >>>>           unsigned int ordered_flags =3D WQ_MEM_RECLAIM | WQ_FREEZAB=
LE;
> >>>>
> >>>> -       fs_info->workers =3D
> >>>> -               btrfs_alloc_workqueue(fs_info, "worker", flags, max_=
active, 16);
> >>>> -
> >>>>           fs_info->delalloc_workers =3D
> >>>>                   btrfs_alloc_workqueue(fs_info, "delalloc",
> >>>>                                         flags, max_active, 2);
> >>>> @@ -2005,8 +2001,7 @@ static int btrfs_init_workqueues(struct btrfs_=
fs_info *fs_info)
> >>>>           fs_info->discard_ctl.discard_workers =3D
> >>>>                   alloc_ordered_workqueue("btrfs-discard", WQ_FREEZA=
BLE);
> >>>>
> >>>> -       if (!(fs_info->workers &&
> >>>> -             fs_info->delalloc_workers && fs_info->flush_workers &&
> >>>> +       if (!(fs_info->delalloc_workers && fs_info->flush_workers &&
> >>>>                 fs_info->endio_workers && fs_info->endio_meta_worker=
s &&
> >>>>                 fs_info->endio_write_workers &&
> >>>>                 fs_info->endio_freespace_worker && fs_info->rmw_work=
ers &&
> >>>> @@ -4437,19 +4432,6 @@ void __cold close_ctree(struct btrfs_fs_info =
*fs_info)
> >>>>            */
> >>>>           btrfs_flush_workqueue(fs_info->delalloc_workers);
> >>>>
> >>>> -       /*
> >>>> -        * We can have ordered extents getting their last reference =
dropped from
> >>>> -        * the fs_info->workers queue because for async writes for d=
ata bios we
> >>>> -        * queue a work for that queue, at btrfs_wq_submit_bio(), th=
at runs
> >>>> -        * run_one_async_done() which calls btrfs_bio_end_io() in ca=
se the bio
> >>>> -        * has an error, and that later function can do the final
> >>>> -        * btrfs_put_ordered_extent() on the ordered extent attached=
 to the bio,
> >>>> -        * which adds a delayed iput for the inode. So we must flush=
 the queue
> >>>> -        * so that we don't have delayed iputs after committing the =
current
> >>>> -        * transaction below and stopping the cleaner and transactio=
n kthreads.
> >>>> -        */
> >>>> -       btrfs_flush_workqueue(fs_info->workers);
> >>>> -
> >>>>           /*
> >>>>            * When finishing a compressed write bio we schedule a wor=
k queue item
> >>>>            * to finish an ordered extent - end_bbio_compressed_write=
()
> >>>> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> >>>> index 0fed4e0d32d5..7dbd9b8eec11 100644
> >>>> --- a/fs/btrfs/file-item.c
> >>>> +++ b/fs/btrfs/file-item.c
> >>>> @@ -825,7 +825,7 @@ static void csum_one_bio_work(struct work_struct=
 *work)
> >>>>    /*
> >>>>     * Calculate checksums of the data contained inside a bio.
> >>>>     */
> >>>> -int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
> >>>> +int btrfs_csum_one_bio(struct btrfs_bio *bbio)
> >>>>    {
> >>>>           struct btrfs_ordered_extent *ordered =3D bbio->ordered;
> >>>>           struct btrfs_inode *inode =3D bbio->inode;
> >>>> @@ -849,10 +849,6 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, =
bool async)
> >>>>           btrfs_add_ordered_sum(ordered, sums);
> >>>>
> >>>>           bbio->csum_saved_iter =3D bio->bi_iter;
> >>>> -       if (!async) {
> >>>> -               csum_one_bio(bbio);
> >>>> -               return 0;
> >>>> -       }
> >>>>           bio_inc_remaining(bio);
> >>>>           INIT_WORK(&bbio->csum_work, csum_one_bio_work);
> >>>>           schedule_work(&bbio->csum_work);
> >>>> diff --git a/fs/btrfs/file-item.h b/fs/btrfs/file-item.h
> >>>> index 6c678787c770..60a0eb17b3f6 100644
> >>>> --- a/fs/btrfs/file-item.h
> >>>> +++ b/fs/btrfs/file-item.h
> >>>> @@ -64,7 +64,7 @@ int btrfs_lookup_file_extent(struct btrfs_trans_ha=
ndle *trans,
> >>>>    int btrfs_insert_data_csums(struct btrfs_trans_handle *trans,
> >>>>                               struct btrfs_root *root,
> >>>>                               struct btrfs_ordered_sum *sums);
> >>>> -int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async);
> >>>> +int btrfs_csum_one_bio(struct btrfs_bio *bbio);
> >>>>    int btrfs_alloc_dummy_sum(struct btrfs_bio *bbio);
> >>>>    int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, =
u64 end,
> >>>>                                struct list_head *list, int search_co=
mmit,
> >>>> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
> >>>> index 3eba8438593c..203f7131f737 100644
> >>>> --- a/fs/btrfs/fs.h
> >>>> +++ b/fs/btrfs/fs.h
> >>>> @@ -696,16 +696,6 @@ struct btrfs_fs_info {
> >>>>           /* All fs/file tree roots that have delalloc inodes. */
> >>>>           struct list_head delalloc_roots;
> >>>>
> >>>> -       /*
> >>>> -        * There is a pool of worker threads for checksumming during=
 writes and
> >>>> -        * a pool for checksumming after reads.  This is because rea=
ders can
> >>>> -        * run with FS locks held, and the writers may be waiting fo=
r those
> >>>> -        * locks.  We don't want ordering in the pending list to cau=
se
> >>>> -        * deadlocks, and so the two are serviced separately.
> >>>> -        *
> >>>> -        * A third pool does submit_bio to avoid deadlocking with th=
e other two.
> >>>> -        */
> >>>> -       struct btrfs_workqueue *workers;
> >>>>           struct btrfs_workqueue *delalloc_workers;
> >>>>           struct btrfs_workqueue *flush_workers;
> >>>>           struct workqueue_struct *endio_workers;
> >>>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> >>>> index 464129b1b0d4..54f2da47c567 100644
> >>>> --- a/fs/btrfs/super.c
> >>>> +++ b/fs/btrfs/super.c
> >>>> @@ -1237,7 +1237,6 @@ static void btrfs_resize_thread_pool(struct bt=
rfs_fs_info *fs_info,
> >>>>           btrfs_info(fs_info, "resize thread pool %d -> %d",
> >>>>                  old_pool_size, new_pool_size);
> >>>>
> >>>> -       btrfs_workqueue_set_max(fs_info->workers, new_pool_size);
> >>>>           btrfs_workqueue_set_max(fs_info->delalloc_workers, new_poo=
l_size);
> >>>>           btrfs_workqueue_set_max(fs_info->caching_workers, new_pool=
_size);
> >>>>           workqueue_set_max_active(fs_info->endio_workers, new_pool_=
size);
> >>>> --
> >>>> 2.55.0
> >>>>
> >>>
> >>
>
