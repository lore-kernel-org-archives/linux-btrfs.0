Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934C71FE47B
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 09:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788774852; cv=pass; b=LPvI2+G9AyyNIJUFYcyHNmJMlLf9DokOkcKxNja19Jd3T2appXoOviwWMBHnnjfmNRzWTmwcvJ2Yb7C/Uqkw4DtBKh1+g0Ms2wd/DlbmVEROr6oR55Ie5Fm0lQ/9Z63NbqOV8x7i4bwXrr0GDH0vNUrTrk3N4vR7QJsheNeYJPc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788774852; c=relaxed/simple;
	bh=Z3y7qzDUmGNE6aQEv/tRpjFFf7SoNvNkPgX36npp/Qo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sKcgptftCIuz/jKaD/fYSWv7BlxI9Yy98un+pcSYzemv79YH1PdwxXjv82ccWsY4LiyWo0gYC9NE3MCXj1YPI/dW7mPadSSbakdYhaC3PLhZgPyuZZs/5QLJZPg/Ff/WNZaM0jO/PqwJIEY1gJ8vWH4MUnXU5x7cRzEMDnm/14c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZzP+C4Xl; arc=pass smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZzP+C4Xl"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-498028b3d5eso31791885e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 02:54:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788774849; cv=none;
        d=google.com; s=arc-20260327;
        b=A6B84BAo53d7vhbHMHtBBBtJRliOQ7eACBHsDriSRYv2O9Pt1gMrHWnDMzmRtuWMgh
         biqoPQRdD/CEFkk/hvN0bcwegUSJxQOX4Q/GO+2DapWe6O3gK8V0uPXvJFrcyaevzQ+b
         z3Rti16Qxfv0dOnV7nDc0PnUL22KrfPz9mEM6hSZciDCDCwSNeJx82hke46Sst8iWQn9
         3PdDboFYM0uxPoD1ZvjSO8VRCsp8MUSvWsNJhQ5Xx8OcSkJg8UTpX5bRBHJyoHctIdna
         XFA6NWWz4aHeMo6Ipn+lacZILcnYRJ1mUqY+knL5LuGNY1gi0Vl0Qu03ZWHITS9JNAdP
         4dzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ThKHBe2u7hzQ1qTwHVL84+q6S4Wd2qMsa/IxhoMyOCQ=;
        fh=yDVmK2OAMKTQV33xv1fC3+O8a4c5osLrg04o+lbnX8A=;
        b=VrDPZSt5TYdtWW2xZruYFOawK1GdmhIxBNUL4Te/UgUZtVnlA2bpusi/Axmu9pz7B7
         cgp0bHx7B3aoX66NuRNtHn30lgfybcZK1H+JVqmmFEBv2DmzLTRYV00dbLhqsh6B9bdX
         IQGzdzz2pGKKZrGnrLl+Yy10JsJsfh4cMyCtxr97Fmc4bBVIdaiMHttAz5bYluDIApsQ
         qBHmwQDRtLfuRXRxOxe2gXv2H+NRVDii6fN92LZAEMNb3lkcik/d5wtC1U+/DGAwRNwi
         tVaE2Obap3rOp230IQBdslL5whI8f0HFml0OT1ZfE5TrrYahekfBlfBg3Gvwo0YyEB1A
         X51g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788774849; x=1789379649; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ThKHBe2u7hzQ1qTwHVL84+q6S4Wd2qMsa/IxhoMyOCQ=;
        b=ZzP+C4XlBo1ordpIQJPqs3kxa0iwfp17u4gwG5OdLWmRHzjGWyKNQycGQudRIAu7dC
         pOVJ16IWnVBvaDIL7mHGBneL+fw39YaIMiHxc9XJefE7jJGN95eqUx8dekZDhgYAG2up
         Jf8D3vj5midL29WHU4C+mXNSQjWxqC85Eyr96qUhP0az49GYUiF6F3eUQZB4df3qAbWg
         +NndrjUSpKpGLf32DPJO8sFv4slrfBzuFHQd3uwDwfxuriiWNsPVYdUUeMiUCrveqpA1
         f++v93hU7K2ggjCtOvcxgJYoQp3BsA1TZMuw4mgSMwzv0JA6ug/Gw4giQ3qQg5mNl/7p
         hKMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788774849; x=1789379649;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ThKHBe2u7hzQ1qTwHVL84+q6S4Wd2qMsa/IxhoMyOCQ=;
        b=p6OEKbck2esfAvPR6y1GcO734XH4XW8LmmqaWvEnsXjuPlCiOl2Zhpwnmv9vv6WWUa
         4adP9fNV+cXNMuEUf3lKdKduD8L1EZpyRKp/h6d3ksrPqS8ASRQZlNKT8g1YaUpm9nL2
         YboyY8I0GCwQaAL2I5phN8XK2P5YLCAtvcp9e6d8hYfSXew3hW8uOdoceO2nvJDln1Jb
         kSXn72Tdf1eGQKujsZOeR2N/ZvVC728emnKboW4hNHpMq4AaGs8+YwO7X7a+nd5CBQLY
         mn7cqvVjvS2Vjp8sUu0k2ccMHkvOYDpbQ2bQRcgBZdFLlWHanKXaQ5uWVmZ5X7vJJzGM
         R/Yg==
X-Forwarded-Encrypted: i=1; AKwUvBxcMu6MulU1m37RRLKU7N5GyUKciEjfW+myZVI4TRaMuFASE4beKi1P6wVxYP9ZQ+sd+3MRBmXouT4Eow==@vger.kernel.org
X-Gm-Message-State: AFuF++nqUADkFJyOgRlXMaivZ/W2VXObQqbnyTVby+6N66bkCHsAi2KL
	DYuq97Wv6uMO57JRhb1X3q9IfQ8jUA6wUi2ZQWt1EQz/UIXSlIoujb+angGwYduLCriQThFr2TL
	UPutHwE2Fp+x4nfqcA3wNYbm9JsObYAjnaDp1Z8F4og==
X-Gm-Gg: AYBFou03oXen1UQycvHW45Xo2nDseSiUVbnP3qidLzQ98gQrk+SmFV+9l248elX1A6d
	R4TJb2NCdL1Xdz5wQpF9MFXiMUqVaNCe+IvbOhb0vqEelV4wFyA8f/nfO20S9ISPRHvkvsjSRQN
	/ViGGnr/MDFXVjeLRlUh/s2J8j/6nOEG7DgH6Y1rvxV1i/1Jev1NaUJf411wi8vJGz0nN5KFPjC
	SCgT7SGgD2/kWMm4VwDkHIEAaadKsag4LUOB2iOwWarKuNRJAFHk3bChY90RpINxBm6KMX9amdP
	97nRalOu/XJTn6iEnqgGuX8ICGSrLbbPbUXM3NzY1/HlfI3BfBzUm6JZqQoYw2r35FRn6iW2gPw
	xtn5Dbs3LtWcZ005/XIfDEcsC211E/LyXoqw+cRvLfjCjgo4U63Xg
X-Received: by 2002:a05:600c:190e:b0:49c:fa21:1c82 with SMTP id
 5b1f17b1804b1-49cfa211d3dmr190464485e9.23.1788774848495; Mon, 07 Sep 2026
 02:54:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <700ba6c46da86ace18a502b43c5e61d16a556060.1788424754.git.wqu@suse.com>
 <CAPjX3FeQ40fcFjfiH=5EK57YvmVDtGxyz152T9FHUOmJuuaOFQ@mail.gmail.com>
 <00fc1bdb-cb69-4339-8184-afc04fceab19@gmx.com> <CAPjX3FdkWegsttPk9FiTiVUp9dcdycWWmecnpSxcgrpwnw=TEg@mail.gmail.com>
 <130fdc9a-2d51-49cd-bf7f-c8e4b8fa19aa@suse.com> <CAPjX3Ff6aiRURh-uufDJ2pkw9Y0SJ6X-WyayxnV6NWiV69-EXg@mail.gmail.com>
 <2eb96a3b-3d93-4563-8526-3bcf13594d50@gmx.com>
In-Reply-To: <2eb96a3b-3d93-4563-8526-3bcf13594d50@gmx.com>
From: Daniel Vacek <neelx@suse.com>
Date: Mon, 7 Sep 2026 11:53:57 +0200
X-Gm-Features: AcwNN1UQVUElkbU2B0CTy-hw-fvTt9jqoeZWenmKhS2-_tYkCxW_lBYKssZw1P4
Message-ID: <CAPjX3FfNrvrVHtNXSe1ROje+qbGj-BobE=jKjTYuWs5W94oZNQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: move async csum generation out of experimental features
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Filipe Manana <fdmanana@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 5 Sept 2026 at 12:47, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> =E5=9C=A8 2026/9/5 19:39, Daniel Vacek =E5=86=99=E9=81=93:
> > On Sat, 5 Sept 2026 at 02:57, Qu Wenruo <wqu@suse.com> wrote:
> [...]
> >> This has one new problem though.
> >>
> >> The csum_one_bio_work() can queue a new work into the same endio_worke=
rs.
> >>
> >> It happens like this:
> >>
> >> csum_one_bio_work()
> >> |- bio_endio()
> >> |  |- btrfs_simple_end_io()
> >>         |- queue_work() into endio_workers again
> >>
> >> This can cause problems with flush_workqueue() in close_ctree(), where
> >> we only flush the workqueue once, which doesn't ensure newly created
> >> work is also flushed.
> >
> > Do you know of any situation where this can happen?
>
> Check the commit message of cda76788f8b0 ("btrfs: fix non-empty delayed
> iputs list on unmount due to async workers").
>
> With your change, we just move the csum generation and endio workload
> from workers to endio_workers.
> Otherwise it's the same.

Perhaps I'm getting lost here, but csums were never in workers and
nothing else moved. Or what am I missing?

edit: Nah, I see. I'm still thinking experimental. As basically that's
the default for me.
      But still, I don't see an issue (yet??). Perhaps Filipe can have a lo=
ok?

> >
> > If btrfs_simple_end_io() can queue a work after close_ctree() has
> > flushed the wq, that would be buggy even before. IIUC, it does not
> > matter whether btrfs_simple_end_io() is running from interrupt (or
> > interrupt thread) or from the worker thread.
> >
> > I understand that at the point when close_ctree() flushes
> > endio_workers we know there will be no new interrupt ending the io
> > request (that could queue an additional work). And since we know there
> > won't be a new interrupt, we also know there is no csum_one_bio_work()
> > queued. Right?

Does this reasoning make sense to you? I still think the logic proves
the change is correct and safe.

--nX


> > So can it even happen? Coz unless I'm mistaken in the reasoning above,
> > I think we're safe regarding your suspicion.
> >
> > --nX
> >
> >> We can use drain_workqueue() instead to fix it easily though.
> >>
> >> Mind to send out a proper patch for it?
> >>
> >> Thanks,
> >> Qu
> >>
> >>>
> >>>
> >>> That should make sashiko happy as well as btrfs end_io work running o=
n
> >>> btrfs end_io work queues.
> >>>
> >>> And we should stay on the safe side wrt memory reclaim.
> >>>
> >>> --nX
> >>>
> >>>
> >>>> And since the csum generation is needed for data writeback, if under
> >>>> very heavy memory pressure, there may be no worker to ensure the csu=
m
> >>>> work can be queued, in that case, it will hang the writeback (which =
is
> >>>> triggered to reclaim memory).
> >>>>
> >>>> If we really want to address that problem, your idea about splitting=
 the
> >>>> patch will make a lot of sense.
> >>>> We will need to keep the old infrastructure first, convert the worke=
r to
> >>>> a regular workqueue, and call queue_work(), then fully remove unused=
 code.
> >>>>
> >>>>
> >>>> But on the other hand, I doubt how pratically it is for anyone to st=
all
> >>>> system_percpu_wq.
> >>>> It's very common utilized across the whole kernel, and if it really
> >>>> stalls I think there are a lot of more things to bother before btrfs=
.
> >>>>
> >>>> Another thing is, if we use fs_info::workers, we will follow the
> >>>> existing wq flags, which means no PERCPU flag.
> >>>> And according to the existing docs for those flags, PERCPU wq has a
> >>>> better performance due to CPU locality.
> >>>>
> >>>>
> >>>> So overall I think the current version is good enough, but not perfe=
ct.
> >>>> On the other hand, using a WQ_MEM_RECLAIM seems more "correct", but =
will
> >>>> definitely introduce some extra pentalty.
> >>>>
> >>>> If someone else has some idea on this Sashiko review, or very famili=
ar
> >>>> with the WQ_MEM_RECLAIM situation, any comment will be appreciated.
> >>>>
> >>>> Thanks,
> >>>> Qu
> >>>>
> >>>>>
> >>>>>> Suggested-by: Daniel Vacek <neelx@suse.com>
> >>>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >>>>>> ---
> >>>>>>     fs/btrfs/bio.c       | 136 +----------------------------------=
--------
> >>>>>>     fs/btrfs/disk-io.c   |  20 +------
> >>>>>>     fs/btrfs/file-item.c |   6 +-
> >>>>>>     fs/btrfs/file-item.h |   2 +-
> >>>>>>     fs/btrfs/fs.h        |  10 ----
> >>>>>>     fs/btrfs/super.c     |   1 -
> >>>>>>     6 files changed, 4 insertions(+), 171 deletions(-)
> >>>>>>
> >>>>>> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> >>>>>> index 771b7d598aee..e08006543c3d 100644
> >>>>>> --- a/fs/btrfs/bio.c
> >>>>>> +++ b/fs/btrfs/bio.c
> >>>>>> @@ -569,136 +569,7 @@ static int btrfs_bio_csum(struct btrfs_bio *=
bbio)
> >>>>>>     {
> >>>>>>            if (bbio->bio.bi_opf & REQ_META)
> >>>>>>                    return btree_csum_one_bio(bbio);
> >>>>>> -#ifdef CONFIG_BTRFS_EXPERIMENTAL
> >>>>>> -       return btrfs_csum_one_bio(bbio, true);
> >>>>>> -#else
> >>>>>> -       return btrfs_csum_one_bio(bbio, false);
> >>>>>> -#endif
> >>>>>> -}
> >>>>>> -
> >>>>>> -/*
> >>>>>> - * Async submit bios are used to offload expensive checksumming o=
nto the worker
> >>>>>> - * threads.
> >>>>>> - */
> >>>>>> -struct async_submit_bio {
> >>>>>> -       struct btrfs_bio *bbio;
> >>>>>> -       struct btrfs_io_context *bioc;
> >>>>>> -       struct btrfs_io_stripe smap;
> >>>>>> -       int mirror_num;
> >>>>>> -       struct btrfs_work work;
> >>>>>> -};
> >>>>>> -
> >>>>>> -/*
> >>>>>> - * In order to insert checksums into the metadata in large chunks=
, we wait
> >>>>>> - * until bio submission time.   All the pages in the bio are chec=
ksummed and
> >>>>>> - * sums are attached onto the ordered extent record.
> >>>>>> - *
> >>>>>> - * At IO completion time the csums attached on the ordered extent=
 record are
> >>>>>> - * inserted into the btree.
> >>>>>> - */
> >>>>>> -static void run_one_async_start(struct btrfs_work *work)
> >>>>>> -{
> >>>>>> -       struct async_submit_bio *async =3D
> >>>>>> -               container_of(work, struct async_submit_bio, work);
> >>>>>> -       int ret;
> >>>>>> -
> >>>>>> -       ret =3D btrfs_bio_csum(async->bbio);
> >>>>>> -       if (ret)
> >>>>>> -               async->bbio->bio.bi_status =3D errno_to_blk_status=
(ret);
> >>>>>> -}
> >>>>>> -
> >>>>>> -/*
> >>>>>> - * In order to insert checksums into the metadata in large chunks=
, we wait
> >>>>>> - * until bio submission time.   All the pages in the bio are chec=
ksummed and
> >>>>>> - * sums are attached onto the ordered extent record.
> >>>>>> - *
> >>>>>> - * At IO completion time the csums attached on the ordered extent=
 record are
> >>>>>> - * inserted into the tree.
> >>>>>> - *
> >>>>>> - * If called with @do_free =3D=3D true, then it will free the wor=
k struct.
> >>>>>> - */
> >>>>>> -static void run_one_async_done(struct btrfs_work *work, bool do_f=
ree)
> >>>>>> -{
> >>>>>> -       struct async_submit_bio *async =3D
> >>>>>> -               container_of(work, struct async_submit_bio, work);
> >>>>>> -       struct bio *bio =3D &async->bbio->bio;
> >>>>>> -
> >>>>>> -       if (do_free) {
> >>>>>> -               kfree(container_of(work, struct async_submit_bio, =
work));
> >>>>>> -               return;
> >>>>>> -       }
> >>>>>> -
> >>>>>> -       /* If an error occurred we just want to clean up the bio a=
nd move on. */
> >>>>>> -       if (bio->bi_status) {
> >>>>>> -               btrfs_bio_end_io(async->bbio, bio->bi_status);
> >>>>>> -               return;
> >>>>>> -       }
> >>>>>> -
> >>>>>> -       /*
> >>>>>> -        * All of the bios that pass through here are from async h=
elpers.
> >>>>>> -        * Use REQ_BTRFS_CGROUP_PUNT to issue them from the owning=
 cgroup's
> >>>>>> -        * context.  This changes nothing when cgroups aren't in u=
se.
> >>>>>> -        */
> >>>>>> -       bio->bi_opf |=3D REQ_BTRFS_CGROUP_PUNT;
> >>>>>> -       btrfs_submit_bio(bio, async->bioc, &async->smap, async->mi=
rror_num);
> >>>>>> -}
> >>>>>> -
> >>>>>> -static bool should_async_write(struct btrfs_bio *bbio)
> >>>>>> -{
> >>>>>> -       struct btrfs_fs_info *fs_info =3D bbio->inode->root->fs_in=
fo;
> >>>>>> -       bool auto_csum_mode =3D true;
> >>>>>> -
> >>>>>> -#ifdef CONFIG_BTRFS_EXPERIMENTAL
> >>>>>> -       /*
> >>>>>> -        * Write bios will calculate checksum and submit bio at th=
e same time.
> >>>>>> -        * Unless explicitly required don't offload serial csum ca=
lculate and bio
> >>>>>> -        * submit into a workqueue.
> >>>>>> -        */
> >>>>>> -       return false;
> >>>>>> -#endif
> >>>>>> -
> >>>>>> -       /* Submit synchronously if the checksum implementation is =
fast. */
> >>>>>> -       if (auto_csum_mode && test_bit(BTRFS_FS_CSUM_IMPL_FAST, &f=
s_info->flags))
> >>>>>> -               return false;
> >>>>>> -
> >>>>>> -       /*
> >>>>>> -        * Try to defer the submission to a workqueue to paralleli=
ze the
> >>>>>> -        * checksum calculation unless the I/O is issued synchrono=
usly.
> >>>>>> -        */
> >>>>>> -       if (op_is_sync(bbio->bio.bi_opf))
> >>>>>> -               return false;
> >>>>>> -
> >>>>>> -       /* Zoned devices require I/O to be submitted in order. */
> >>>>>> -       if ((bbio->bio.bi_opf & REQ_META) && btrfs_is_zoned(fs_inf=
o))
> >>>>>> -               return false;
> >>>>>> -
> >>>>>> -       return true;
> >>>>>> -}
> >>>>>> -
> >>>>>> -/*
> >>>>>> - * Submit bio to an async queue.
> >>>>>> - *
> >>>>>> - * Return true if the work has been successfully submitted, else =
false.
> >>>>>> - */
> >>>>>> -static bool btrfs_wq_submit_bio(struct btrfs_bio *bbio,
> >>>>>> -                               struct btrfs_io_context *bioc,
> >>>>>> -                               struct btrfs_io_stripe *smap, int =
mirror_num)
> >>>>>> -{
> >>>>>> -       struct btrfs_fs_info *fs_info =3D bbio->inode->root->fs_in=
fo;
> >>>>>> -       struct async_submit_bio *async;
> >>>>>> -
> >>>>>> -       async =3D kmalloc_obj(*async, GFP_NOFS);
> >>>>>> -       if (!async)
> >>>>>> -               return false;
> >>>>>> -
> >>>>>> -       async->bbio =3D bbio;
> >>>>>> -       async->bioc =3D bioc;
> >>>>>> -       async->smap =3D *smap;
> >>>>>> -       async->mirror_num =3D mirror_num;
> >>>>>> -
> >>>>>> -       btrfs_init_work(&async->work, run_one_async_start, run_one=
_async_done);
> >>>>>> -       btrfs_queue_work(fs_info->workers, &async->work);
> >>>>>> -       return true;
> >>>>>> +       return btrfs_csum_one_bio(bbio);
> >>>>>>     }
> >>>>>>
> >>>>>>     static u64 btrfs_append_map_length(struct btrfs_bio *bbio, u64=
 map_length)
> >>>>>> @@ -806,10 +677,6 @@ static bool btrfs_submit_chunk(struct btrfs_b=
io *bbio, int mirror_num)
> >>>>>>                    if (!(inode->flags & BTRFS_INODE_NODATASUM) &&
> >>>>>>                        !test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs=
_info->fs_state) &&
> >>>>>>                        !btrfs_is_data_reloc_root(inode->root) && !=
bbio->is_remap) {
> >>>>>> -                       if (should_async_write(bbio) &&
> >>>>>> -                           btrfs_wq_submit_bio(bbio, bioc, &smap,=
 mirror_num))
> >>>>>> -                               goto done;
> >>>>>> -
> >>>>>>                            ret =3D btrfs_bio_csum(bbio);
> >>>>>>                            status =3D errno_to_blk_status(ret);
> >>>>>>                            if (status)
> >>>>>> @@ -824,7 +691,6 @@ static bool btrfs_submit_chunk(struct btrfs_bi=
o *bbio, int mirror_num)
> >>>>>>            }
> >>>>>>
> >>>>>>            btrfs_submit_bio(bio, bioc, &smap, mirror_num);
> >>>>>> -done:
> >>>>>>            return map_length =3D=3D length;
> >>>>>>
> >>>>>>     fail:
> >>>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> >>>>>> index a1d83ad9a4c0..0046f3cb75a1 100644
> >>>>>> --- a/fs/btrfs/disk-io.c
> >>>>>> +++ b/fs/btrfs/disk-io.c
> >>>>>> @@ -1776,7 +1776,6 @@ static void btrfs_stop_all_workers(struct bt=
rfs_fs_info *fs_info)
> >>>>>>            if (fs_info->fixup_workers)
> >>>>>>                    destroy_workqueue(fs_info->fixup_workers);
> >>>>>>            btrfs_destroy_workqueue(fs_info->delalloc_workers);
> >>>>>> -       btrfs_destroy_workqueue(fs_info->workers);
> >>>>>>            if (fs_info->endio_workers)
> >>>>>>                    destroy_workqueue(fs_info->endio_workers);
> >>>>>>            if (fs_info->rmw_workers)
> >>>>>> @@ -1968,9 +1967,6 @@ static int btrfs_init_workqueues(struct btrf=
s_fs_info *fs_info)
> >>>>>>            unsigned int flags =3D WQ_MEM_RECLAIM | WQ_FREEZABLE | =
WQ_UNBOUND;
> >>>>>>            unsigned int ordered_flags =3D WQ_MEM_RECLAIM | WQ_FREE=
ZABLE;
> >>>>>>
> >>>>>> -       fs_info->workers =3D
> >>>>>> -               btrfs_alloc_workqueue(fs_info, "worker", flags, ma=
x_active, 16);
> >>>>>> -
> >>>>>>            fs_info->delalloc_workers =3D
> >>>>>>                    btrfs_alloc_workqueue(fs_info, "delalloc",
> >>>>>>                                          flags, max_active, 2);
> >>>>>> @@ -2005,8 +2001,7 @@ static int btrfs_init_workqueues(struct btrf=
s_fs_info *fs_info)
> >>>>>>            fs_info->discard_ctl.discard_workers =3D
> >>>>>>                    alloc_ordered_workqueue("btrfs-discard", WQ_FRE=
EZABLE);
> >>>>>>
> >>>>>> -       if (!(fs_info->workers &&
> >>>>>> -             fs_info->delalloc_workers && fs_info->flush_workers =
&&
> >>>>>> +       if (!(fs_info->delalloc_workers && fs_info->flush_workers =
&&
> >>>>>>                  fs_info->endio_workers && fs_info->endio_meta_wor=
kers &&
> >>>>>>                  fs_info->endio_write_workers &&
> >>>>>>                  fs_info->endio_freespace_worker && fs_info->rmw_w=
orkers &&
> >>>>>> @@ -4437,19 +4432,6 @@ void __cold close_ctree(struct btrfs_fs_inf=
o *fs_info)
> >>>>>>             */
> >>>>>>            btrfs_flush_workqueue(fs_info->delalloc_workers);
> >>>>>>
> >>>>>> -       /*
> >>>>>> -        * We can have ordered extents getting their last referenc=
e dropped from
> >>>>>> -        * the fs_info->workers queue because for async writes for=
 data bios we
> >>>>>> -        * queue a work for that queue, at btrfs_wq_submit_bio(), =
that runs
> >>>>>> -        * run_one_async_done() which calls btrfs_bio_end_io() in =
case the bio
> >>>>>> -        * has an error, and that later function can do the final
> >>>>>> -        * btrfs_put_ordered_extent() on the ordered extent attach=
ed to the bio,
> >>>>>> -        * which adds a delayed iput for the inode. So we must flu=
sh the queue
> >>>>>> -        * so that we don't have delayed iputs after committing th=
e current
> >>>>>> -        * transaction below and stopping the cleaner and transact=
ion kthreads.
> >>>>>> -        */
> >>>>>> -       btrfs_flush_workqueue(fs_info->workers);
> >>>>>> -
> >>>>>>            /*
> >>>>>>             * When finishing a compressed write bio we schedule a =
work queue item
> >>>>>>             * to finish an ordered extent - end_bbio_compressed_wr=
ite()
> >>>>>> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> >>>>>> index 0fed4e0d32d5..7dbd9b8eec11 100644
> >>>>>> --- a/fs/btrfs/file-item.c
> >>>>>> +++ b/fs/btrfs/file-item.c
> >>>>>> @@ -825,7 +825,7 @@ static void csum_one_bio_work(struct work_stru=
ct *work)
> >>>>>>     /*
> >>>>>>      * Calculate checksums of the data contained inside a bio.
> >>>>>>      */
> >>>>>> -int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
> >>>>>> +int btrfs_csum_one_bio(struct btrfs_bio *bbio)
> >>>>>>     {
> >>>>>>            struct btrfs_ordered_extent *ordered =3D bbio->ordered;
> >>>>>>            struct btrfs_inode *inode =3D bbio->inode;
> >>>>>> @@ -849,10 +849,6 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio=
, bool async)
> >>>>>>            btrfs_add_ordered_sum(ordered, sums);
> >>>>>>
> >>>>>>            bbio->csum_saved_iter =3D bio->bi_iter;
> >>>>>> -       if (!async) {
> >>>>>> -               csum_one_bio(bbio);
> >>>>>> -               return 0;
> >>>>>> -       }
> >>>>>>            bio_inc_remaining(bio);
> >>>>>>            INIT_WORK(&bbio->csum_work, csum_one_bio_work);
> >>>>>>            schedule_work(&bbio->csum_work);
> >>>>>> diff --git a/fs/btrfs/file-item.h b/fs/btrfs/file-item.h
> >>>>>> index 6c678787c770..60a0eb17b3f6 100644
> >>>>>> --- a/fs/btrfs/file-item.h
> >>>>>> +++ b/fs/btrfs/file-item.h
> >>>>>> @@ -64,7 +64,7 @@ int btrfs_lookup_file_extent(struct btrfs_trans_=
handle *trans,
> >>>>>>     int btrfs_insert_data_csums(struct btrfs_trans_handle *trans,
> >>>>>>                                struct btrfs_root *root,
> >>>>>>                                struct btrfs_ordered_sum *sums);
> >>>>>> -int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async);
> >>>>>> +int btrfs_csum_one_bio(struct btrfs_bio *bbio);
> >>>>>>     int btrfs_alloc_dummy_sum(struct btrfs_bio *bbio);
> >>>>>>     int btrfs_lookup_csums_range(struct btrfs_root *root, u64 star=
t, u64 end,
> >>>>>>                                 struct list_head *list, int search=
_commit,
> >>>>>> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
> >>>>>> index 3eba8438593c..203f7131f737 100644
> >>>>>> --- a/fs/btrfs/fs.h
> >>>>>> +++ b/fs/btrfs/fs.h
> >>>>>> @@ -696,16 +696,6 @@ struct btrfs_fs_info {
> >>>>>>            /* All fs/file tree roots that have delalloc inodes. */
> >>>>>>            struct list_head delalloc_roots;
> >>>>>>
> >>>>>> -       /*
> >>>>>> -        * There is a pool of worker threads for checksumming duri=
ng writes and
> >>>>>> -        * a pool for checksumming after reads.  This is because r=
eaders can
> >>>>>> -        * run with FS locks held, and the writers may be waiting =
for those
> >>>>>> -        * locks.  We don't want ordering in the pending list to c=
ause
> >>>>>> -        * deadlocks, and so the two are serviced separately.
> >>>>>> -        *
> >>>>>> -        * A third pool does submit_bio to avoid deadlocking with =
the other two.
> >>>>>> -        */
> >>>>>> -       struct btrfs_workqueue *workers;
> >>>>>>            struct btrfs_workqueue *delalloc_workers;
> >>>>>>            struct btrfs_workqueue *flush_workers;
> >>>>>>            struct workqueue_struct *endio_workers;
> >>>>>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> >>>>>> index 464129b1b0d4..54f2da47c567 100644
> >>>>>> --- a/fs/btrfs/super.c
> >>>>>> +++ b/fs/btrfs/super.c
> >>>>>> @@ -1237,7 +1237,6 @@ static void btrfs_resize_thread_pool(struct =
btrfs_fs_info *fs_info,
> >>>>>>            btrfs_info(fs_info, "resize thread pool %d -> %d",
> >>>>>>                   old_pool_size, new_pool_size);
> >>>>>>
> >>>>>> -       btrfs_workqueue_set_max(fs_info->workers, new_pool_size);
> >>>>>>            btrfs_workqueue_set_max(fs_info->delalloc_workers, new_=
pool_size);
> >>>>>>            btrfs_workqueue_set_max(fs_info->caching_workers, new_p=
ool_size);
> >>>>>>            workqueue_set_max_active(fs_info->endio_workers, new_po=
ol_size);
> >>>>>> --
> >>>>>> 2.55.0
> >>>>>>
> >>>>>
> >>>>
> >>
> >
>
