Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC974A8FDF
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 13:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788440893; cv=pass; b=mVuHLyBFKc0cHm2mjMbmc3H7bXvBQAIcpfTJm6QPcNBHTCYYPGE4hUpqDj/LXfAiBlOlv40XXlivF/ZWI7Gg9VxK9M+trb7ZksxR8LHVsjJ/wTvUu5eHJSLudnKailIn8TqKBegT1/r/ZG7pU9qAz0OM/9xjsVtzYiKutWlDRXA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788440893; c=relaxed/simple;
	bh=Mqc5C+qgf+WczoqHD7gmminOaypelIS8L20wuxEHu/M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ILulEZckGcSNh8h2CJIjm3cbWlhK3j4yZK+XI6TKoKU69yhaOBMRf/PgTeU/zdAA8c3imCcuGz+W3HdSZztIkidUeFLMhH0lw/fxB5XzvV1p2oehDOB5Hu3v0/E3rxHIcThu+3WnkjZQoLGTZfKMOods2IzpySTYm7UzXKfOZWM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EgGct+J+; arc=pass smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EgGct+J+"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4858595f997so97004f8f.1
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Sep 2026 06:07:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788440874; cv=none;
        d=google.com; s=arc-20260327;
        b=hdpd/wHmyytJ1BCVx/ezqdgk6iJfeFkhFhK8UGXSXBkQFVSEMdQCn5UQp8ssd3056V
         CX7eOWF8+XMZqSxrmkLfzI/oarWYVRljq0lZ1daSp/OguOhlH0Tx1PO6MBOZMPcXR/MT
         mM294LoJuD65fOwNRRFeSxSYVu0kzWpdrYpeq4fcVGnE50k69aGa17ErI3PhRNtaj3qZ
         I9Nk40vEP4TmlHlhO0nYim7nCBdpxHEwyunokZk1vrHOHBlaYIfqDia6nMXxYotmNW8u
         xWalIXNJRUONBS6HP9Bvivwh9KRJygPPIlC6ZauirZRsy4N35YyPAqUfFItwssf/Hd5P
         E0Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7eLPEgx20fBdTv/IRYhCkECxnrMSaEdZzqxtn2hXUao=;
        fh=2IGFpDgeXw+5trzd9dqUR16v+LVBWdcPEXKlHR1uKes=;
        b=nEQQvuSsjK3f8BBfF7n8kM0hsdYnhw+zc4ofeKC6xv0HM7rpTmOy7+jhoSZgqKfBU0
         +L8Fvx/mZ3XXiVYjdsJu2ULE3bAXFwqfUyUhG/Gbq8NanKTEt/RMZpnB2HUMFVuVIy0k
         L7/FXkma4ZIRghwl/F/O46V3NhcVZqTGvlPTuT82egJKZGRBBbcwJrZ+C3cr79AGcA5m
         bd4gcIcwEXrQcz6RoZz1rcIPkChv3xY++NFgZagyY1j8Z8FE0VCW4CO1MzY3FLWZZct3
         bnte8aIS2tUkb74Zg3zJ6GrC5OkMTIMvLHZ0O4c6p/PAM9PCtqcq2UDy8sIzA1lb+gky
         ml6w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788440874; x=1789045674; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7eLPEgx20fBdTv/IRYhCkECxnrMSaEdZzqxtn2hXUao=;
        b=EgGct+J+clr8CrDDHZRI//k4hcICa7KejTjNhO4J4cjz9TrJG4j/Nru8W77G5yzyNK
         j+mCQ1+iv+mcd2SqJTrGnxkm8SeEXec1c40tWwlBuvvcdaQvdfq6qk1o/n8v/rqa5FhQ
         P8tRii0zM/xNkhV6rqrqTQfGIHKy9RnqFPYY0o8uySaJfpPGlek8RAtRmkv1ao2FQpIV
         JewIjLTdgTW1ZeNAQhfJL3CYvaBojMI+j3DXvYYE6pKvfy/9/nXLIG5JcBN34KuquanN
         yD71gdeZrMsNJORGheHNIjJQucyhSEd7GKuroQkfR1OH+eOibjclqTCuI57Vb7w3zACa
         2UhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788440874; x=1789045674;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7eLPEgx20fBdTv/IRYhCkECxnrMSaEdZzqxtn2hXUao=;
        b=eqpiNTVac7/+m79UZNJUgdI1/U17mqLYKeW4tbDhQKiaJ0YHiP2af3aZKEScyEa/y6
         PGFIwIK11FOuwqPt+GgVZybRt9q9zUQl9tbs2OMXX9lTa/bWBUEamA1f8EwFOu/oNdbk
         084qk4ujY9b1PN9dVmRlQBry70c9mqN3OnxsWftDup/hRZ2IleQ0Ed72BjyaU/qFnMoj
         jfe8nrT1Q0+jFFjwtKZzGkZL/LvZU53gs9GemGERnrO+MDvWpAJ8YAUg81HA1S4RERVA
         LurCIhTzkUq59KuqtSOBG4RK0mtTduawYSdvAwPTrbabFQkRTXOV3rJsOVe0ljzXFHyu
         qykA==
X-Forwarded-Encrypted: i=1; AKwUvBy7RpZ2dmw6M9yazK5oAA4ef/NNBzmSGna+O6Q3Iyl+G+mT/1kF6WWRadsJUyy1PN7x9sbBSnzCxVzOvA==@vger.kernel.org
X-Gm-Message-State: AFuF++nNqveqOSBFzOdQ+bRSghwE+VeIcsbHuTHATZ+iDUakjj8scXYu
	00DAmnKnHMyfjoAw4ewb9a8GQtpmBofZbfAj0mmP967nsaEWW0xPeOWzrQIORGqWZPS9OX2+wTD
	h8meJ716A84Y35D5kGDUN3imMxr1N9N3NC0Nipf2Teg==
X-Gm-Gg: AYBFou2Ig1awj7Cjb1TS6Y5FUA8PKuEsOAjIFF+v5rt1iRU5R/70CNTHw5w0qFVu69Q
	A/i8pVQSXXAxu1FYsjQP3uECsFs7Or1V3sTWtlo8pjisxk8968VdkMIiG2x7GfBzx9u1Da01Bbf
	/4q8OJ1w1GpNEEuAznCtf5iwKNja44wBm0cnriEZtyfxbcxIMcyrLCYMeJIPEnwUX40oidtHBa3
	7CXpfLGn5GcT3atUz/1g4r9M+Ve5mTBMpisKuBTXDaPZZ4vqYj4KXk8CcStEC5I8/ep4oPwKLEc
	xpE8MylfJ/lM3l7mdyAB1u2VkPzKqQLIQpBmvttAbRoYIscIFUIOiUAt/YY39GJTvl+MVGfBK0o
	O5cxHpYYYHwIw4es/uvd091Tcl7iTeghVL1KTfUb15g==
X-Received: by 2002:a5d:5f47:0:b0:482:fc30:a1b4 with SMTP id
 ffacd0b85a97d-48488e03952mr19066741f8f.5.1788440874224; Thu, 03 Sep 2026
 06:07:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <700ba6c46da86ace18a502b43c5e61d16a556060.1788424754.git.wqu@suse.com>
 <CAPjX3FeQ40fcFjfiH=5EK57YvmVDtGxyz152T9FHUOmJuuaOFQ@mail.gmail.com>
 <00fc1bdb-cb69-4339-8184-afc04fceab19@gmx.com> <CAPjX3FdkWegsttPk9FiTiVUp9dcdycWWmecnpSxcgrpwnw=TEg@mail.gmail.com>
In-Reply-To: <CAPjX3FdkWegsttPk9FiTiVUp9dcdycWWmecnpSxcgrpwnw=TEg@mail.gmail.com>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 3 Sep 2026 15:07:43 +0200
X-Gm-Features: AcwNN1WJkp_UxsXk6_O1Z_vHVcawJ6uNEMvuoS_WlDKq-1tKB2oBSAQj6F5O09w
Message-ID: <CAPjX3Ff=3tvgwS56W2nahizeB9qrRu_dcpx5iZeBV_s-6OZKwg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: move async csum generation out of experimental features
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 3 Sept 2026 at 14:44, Daniel Vacek <neelx@suse.com> wrote:
> On Thu, 3 Sept 2026 at 13:27, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> > =E5=9C=A8 2026/9/3 18:50, Daniel Vacek =E5=86=99=E9=81=93:
> > > On Thu, 3 Sept 2026 at 10:40, Qu Wenruo <wqu@suse.com> wrote:
> > >> Commit dd57c78aec39 ("btrfs: introduce btrfs_bio::async_csum")
> > >> introduced asynchronous data checksum generation for data writes.
> > >>
> > >> That feature can improve write performance, and was introduced in v6=
.19.
> > >> We have not experienced bugs related to that, so it's time to move i=
t out
> > >> of experimental features for end users.
> > >>
> > >> Furthermore since the async checksum generation means
> > >> should_async_write() will always return false, we no longer need to
> > >> maintain the fs_info->workers workqueue, as the async checksum
> > >> generation is using the system_percpu_wq.
> > >
> > > I understand these are two related changes in one patch here. If
> > > removing async writes depends on async checksums, it would be nice to
> > > split this into a patch series.
> > >
> > > Though I guess can live with that. Looks good enough to me.
> > >
> > > Reviewed-by: Daniel Vacek <neelx@suse.com>
> >
> > Thanks a lot for the review.
> >
> >
> > I just want to mention that, Sashiko mentioned a problem that I believe
> > is valid, but not sure how realistic it will be in the real world.
> >
> >
> > Sashiko mentioned that, the old worker workqueue has WQ_MEM_RECLAIM
> > flag, thus there will always be a rescuer to ensure forward progress.
> > (Although for x86_64 and other common archs or EXPERIMENTAL builds, we
> > never utilize that worker anyway)
> >
> > But the new schedule_work() is using system_percpu_wq, which doesn't ha=
s
> > that flag.
>
> Well, I think squashing this fixup to my patch is the right thing to do a=
nyways:
>
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 0fed4e0d32d5..984d87ad79b0 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -855,7 +855,7 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool a=
sync)
>      }
>      bio_inc_remaining(bio);
>      INIT_WORK(&bbio->csum_work, csum_one_bio_work);
> -    schedule_work(&bbio->csum_work);
> +    queue_work(fs_info->endio_workers, &bbio->csum_work);
>      return 0;
>  }
>

And in theory this snippet also:

Fixes: dd57c78aec39 ("btrfs: introduce btrfs_bio::async_csum")

--nX

>
> That should make sashiko happy as well as btrfs end_io work running on
> btrfs end_io work queues.
>
> And we should stay on the safe side wrt memory reclaim.
>
> --nX
>
>
> > And since the csum generation is needed for data writeback, if under
> > very heavy memory pressure, there may be no worker to ensure the csum
> > work can be queued, in that case, it will hang the writeback (which is
> > triggered to reclaim memory).
> >
> > If we really want to address that problem, your idea about splitting th=
e
> > patch will make a lot of sense.
> > We will need to keep the old infrastructure first, convert the worker t=
o
> > a regular workqueue, and call queue_work(), then fully remove unused co=
de.
> >
> >
> > But on the other hand, I doubt how pratically it is for anyone to stall
> > system_percpu_wq.
> > It's very common utilized across the whole kernel, and if it really
> > stalls I think there are a lot of more things to bother before btrfs.
> >
> > Another thing is, if we use fs_info::workers, we will follow the
> > existing wq flags, which means no PERCPU flag.
> > And according to the existing docs for those flags, PERCPU wq has a
> > better performance due to CPU locality.
> >
> >
> > So overall I think the current version is good enough, but not perfect.
> > On the other hand, using a WQ_MEM_RECLAIM seems more "correct", but wil=
l
> > definitely introduce some extra pentalty.
> >
> > If someone else has some idea on this Sashiko review, or very familiar
> > with the WQ_MEM_RECLAIM situation, any comment will be appreciated.
> >
> > Thanks,
> > Qu
> >
> > >
> > >> Suggested-by: Daniel Vacek <neelx@suse.com>
> > >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> > >> ---
> > >>   fs/btrfs/bio.c       | 136 +--------------------------------------=
----
> > >>   fs/btrfs/disk-io.c   |  20 +------
> > >>   fs/btrfs/file-item.c |   6 +-
> > >>   fs/btrfs/file-item.h |   2 +-
> > >>   fs/btrfs/fs.h        |  10 ----
> > >>   fs/btrfs/super.c     |   1 -
> > >>   6 files changed, 4 insertions(+), 171 deletions(-)
> > >>
> > >> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> > >> index 771b7d598aee..e08006543c3d 100644
> > >> --- a/fs/btrfs/bio.c
> > >> +++ b/fs/btrfs/bio.c
> > >> @@ -569,136 +569,7 @@ static int btrfs_bio_csum(struct btrfs_bio *bb=
io)
> > >>   {
> > >>          if (bbio->bio.bi_opf & REQ_META)
> > >>                  return btree_csum_one_bio(bbio);
> > >> -#ifdef CONFIG_BTRFS_EXPERIMENTAL
> > >> -       return btrfs_csum_one_bio(bbio, true);
> > >> -#else
> > >> -       return btrfs_csum_one_bio(bbio, false);
> > >> -#endif
> > >> -}
> > >> -
> > >> -/*
> > >> - * Async submit bios are used to offload expensive checksumming ont=
o the worker
> > >> - * threads.
> > >> - */
> > >> -struct async_submit_bio {
> > >> -       struct btrfs_bio *bbio;
> > >> -       struct btrfs_io_context *bioc;
> > >> -       struct btrfs_io_stripe smap;
> > >> -       int mirror_num;
> > >> -       struct btrfs_work work;
> > >> -};
> > >> -
> > >> -/*
> > >> - * In order to insert checksums into the metadata in large chunks, =
we wait
> > >> - * until bio submission time.   All the pages in the bio are checks=
ummed and
> > >> - * sums are attached onto the ordered extent record.
> > >> - *
> > >> - * At IO completion time the csums attached on the ordered extent r=
ecord are
> > >> - * inserted into the btree.
> > >> - */
> > >> -static void run_one_async_start(struct btrfs_work *work)
> > >> -{
> > >> -       struct async_submit_bio *async =3D
> > >> -               container_of(work, struct async_submit_bio, work);
> > >> -       int ret;
> > >> -
> > >> -       ret =3D btrfs_bio_csum(async->bbio);
> > >> -       if (ret)
> > >> -               async->bbio->bio.bi_status =3D errno_to_blk_status(r=
et);
> > >> -}
> > >> -
> > >> -/*
> > >> - * In order to insert checksums into the metadata in large chunks, =
we wait
> > >> - * until bio submission time.   All the pages in the bio are checks=
ummed and
> > >> - * sums are attached onto the ordered extent record.
> > >> - *
> > >> - * At IO completion time the csums attached on the ordered extent r=
ecord are
> > >> - * inserted into the tree.
> > >> - *
> > >> - * If called with @do_free =3D=3D true, then it will free the work =
struct.
> > >> - */
> > >> -static void run_one_async_done(struct btrfs_work *work, bool do_fre=
e)
> > >> -{
> > >> -       struct async_submit_bio *async =3D
> > >> -               container_of(work, struct async_submit_bio, work);
> > >> -       struct bio *bio =3D &async->bbio->bio;
> > >> -
> > >> -       if (do_free) {
> > >> -               kfree(container_of(work, struct async_submit_bio, wo=
rk));
> > >> -               return;
> > >> -       }
> > >> -
> > >> -       /* If an error occurred we just want to clean up the bio and=
 move on. */
> > >> -       if (bio->bi_status) {
> > >> -               btrfs_bio_end_io(async->bbio, bio->bi_status);
> > >> -               return;
> > >> -       }
> > >> -
> > >> -       /*
> > >> -        * All of the bios that pass through here are from async hel=
pers.
> > >> -        * Use REQ_BTRFS_CGROUP_PUNT to issue them from the owning c=
group's
> > >> -        * context.  This changes nothing when cgroups aren't in use=
.
> > >> -        */
> > >> -       bio->bi_opf |=3D REQ_BTRFS_CGROUP_PUNT;
> > >> -       btrfs_submit_bio(bio, async->bioc, &async->smap, async->mirr=
or_num);
> > >> -}
> > >> -
> > >> -static bool should_async_write(struct btrfs_bio *bbio)
> > >> -{
> > >> -       struct btrfs_fs_info *fs_info =3D bbio->inode->root->fs_info=
;
> > >> -       bool auto_csum_mode =3D true;
> > >> -
> > >> -#ifdef CONFIG_BTRFS_EXPERIMENTAL
> > >> -       /*
> > >> -        * Write bios will calculate checksum and submit bio at the =
same time.
> > >> -        * Unless explicitly required don't offload serial csum calc=
ulate and bio
> > >> -        * submit into a workqueue.
> > >> -        */
> > >> -       return false;
> > >> -#endif
> > >> -
> > >> -       /* Submit synchronously if the checksum implementation is fa=
st. */
> > >> -       if (auto_csum_mode && test_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_=
info->flags))
> > >> -               return false;
> > >> -
> > >> -       /*
> > >> -        * Try to defer the submission to a workqueue to parallelize=
 the
> > >> -        * checksum calculation unless the I/O is issued synchronous=
ly.
> > >> -        */
> > >> -       if (op_is_sync(bbio->bio.bi_opf))
> > >> -               return false;
> > >> -
> > >> -       /* Zoned devices require I/O to be submitted in order. */
> > >> -       if ((bbio->bio.bi_opf & REQ_META) && btrfs_is_zoned(fs_info)=
)
> > >> -               return false;
> > >> -
> > >> -       return true;
> > >> -}
> > >> -
> > >> -/*
> > >> - * Submit bio to an async queue.
> > >> - *
> > >> - * Return true if the work has been successfully submitted, else fa=
lse.
> > >> - */
> > >> -static bool btrfs_wq_submit_bio(struct btrfs_bio *bbio,
> > >> -                               struct btrfs_io_context *bioc,
> > >> -                               struct btrfs_io_stripe *smap, int mi=
rror_num)
> > >> -{
> > >> -       struct btrfs_fs_info *fs_info =3D bbio->inode->root->fs_info=
;
> > >> -       struct async_submit_bio *async;
> > >> -
> > >> -       async =3D kmalloc_obj(*async, GFP_NOFS);
> > >> -       if (!async)
> > >> -               return false;
> > >> -
> > >> -       async->bbio =3D bbio;
> > >> -       async->bioc =3D bioc;
> > >> -       async->smap =3D *smap;
> > >> -       async->mirror_num =3D mirror_num;
> > >> -
> > >> -       btrfs_init_work(&async->work, run_one_async_start, run_one_a=
sync_done);
> > >> -       btrfs_queue_work(fs_info->workers, &async->work);
> > >> -       return true;
> > >> +       return btrfs_csum_one_bio(bbio);
> > >>   }
> > >>
> > >>   static u64 btrfs_append_map_length(struct btrfs_bio *bbio, u64 map=
_length)
> > >> @@ -806,10 +677,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio=
 *bbio, int mirror_num)
> > >>                  if (!(inode->flags & BTRFS_INODE_NODATASUM) &&
> > >>                      !test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_inf=
o->fs_state) &&
> > >>                      !btrfs_is_data_reloc_root(inode->root) && !bbio=
->is_remap) {
> > >> -                       if (should_async_write(bbio) &&
> > >> -                           btrfs_wq_submit_bio(bbio, bioc, &smap, m=
irror_num))
> > >> -                               goto done;
> > >> -
> > >>                          ret =3D btrfs_bio_csum(bbio);
> > >>                          status =3D errno_to_blk_status(ret);
> > >>                          if (status)
> > >> @@ -824,7 +691,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio =
*bbio, int mirror_num)
> > >>          }
> > >>
> > >>          btrfs_submit_bio(bio, bioc, &smap, mirror_num);
> > >> -done:
> > >>          return map_length =3D=3D length;
> > >>
> > >>   fail:
> > >> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > >> index a1d83ad9a4c0..0046f3cb75a1 100644
> > >> --- a/fs/btrfs/disk-io.c
> > >> +++ b/fs/btrfs/disk-io.c
> > >> @@ -1776,7 +1776,6 @@ static void btrfs_stop_all_workers(struct btrf=
s_fs_info *fs_info)
> > >>          if (fs_info->fixup_workers)
> > >>                  destroy_workqueue(fs_info->fixup_workers);
> > >>          btrfs_destroy_workqueue(fs_info->delalloc_workers);
> > >> -       btrfs_destroy_workqueue(fs_info->workers);
> > >>          if (fs_info->endio_workers)
> > >>                  destroy_workqueue(fs_info->endio_workers);
> > >>          if (fs_info->rmw_workers)
> > >> @@ -1968,9 +1967,6 @@ static int btrfs_init_workqueues(struct btrfs_=
fs_info *fs_info)
> > >>          unsigned int flags =3D WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_U=
NBOUND;
> > >>          unsigned int ordered_flags =3D WQ_MEM_RECLAIM | WQ_FREEZABL=
E;
> > >>
> > >> -       fs_info->workers =3D
> > >> -               btrfs_alloc_workqueue(fs_info, "worker", flags, max_=
active, 16);
> > >> -
> > >>          fs_info->delalloc_workers =3D
> > >>                  btrfs_alloc_workqueue(fs_info, "delalloc",
> > >>                                        flags, max_active, 2);
> > >> @@ -2005,8 +2001,7 @@ static int btrfs_init_workqueues(struct btrfs_=
fs_info *fs_info)
> > >>          fs_info->discard_ctl.discard_workers =3D
> > >>                  alloc_ordered_workqueue("btrfs-discard", WQ_FREEZAB=
LE);
> > >>
> > >> -       if (!(fs_info->workers &&
> > >> -             fs_info->delalloc_workers && fs_info->flush_workers &&
> > >> +       if (!(fs_info->delalloc_workers && fs_info->flush_workers &&
> > >>                fs_info->endio_workers && fs_info->endio_meta_workers=
 &&
> > >>                fs_info->endio_write_workers &&
> > >>                fs_info->endio_freespace_worker && fs_info->rmw_worke=
rs &&
> > >> @@ -4437,19 +4432,6 @@ void __cold close_ctree(struct btrfs_fs_info =
*fs_info)
> > >>           */
> > >>          btrfs_flush_workqueue(fs_info->delalloc_workers);
> > >>
> > >> -       /*
> > >> -        * We can have ordered extents getting their last reference =
dropped from
> > >> -        * the fs_info->workers queue because for async writes for d=
ata bios we
> > >> -        * queue a work for that queue, at btrfs_wq_submit_bio(), th=
at runs
> > >> -        * run_one_async_done() which calls btrfs_bio_end_io() in ca=
se the bio
> > >> -        * has an error, and that later function can do the final
> > >> -        * btrfs_put_ordered_extent() on the ordered extent attached=
 to the bio,
> > >> -        * which adds a delayed iput for the inode. So we must flush=
 the queue
> > >> -        * so that we don't have delayed iputs after committing the =
current
> > >> -        * transaction below and stopping the cleaner and transactio=
n kthreads.
> > >> -        */
> > >> -       btrfs_flush_workqueue(fs_info->workers);
> > >> -
> > >>          /*
> > >>           * When finishing a compressed write bio we schedule a work=
 queue item
> > >>           * to finish an ordered extent - end_bbio_compressed_write(=
)
> > >> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> > >> index 0fed4e0d32d5..7dbd9b8eec11 100644
> > >> --- a/fs/btrfs/file-item.c
> > >> +++ b/fs/btrfs/file-item.c
> > >> @@ -825,7 +825,7 @@ static void csum_one_bio_work(struct work_struct=
 *work)
> > >>   /*
> > >>    * Calculate checksums of the data contained inside a bio.
> > >>    */
> > >> -int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
> > >> +int btrfs_csum_one_bio(struct btrfs_bio *bbio)
> > >>   {
> > >>          struct btrfs_ordered_extent *ordered =3D bbio->ordered;
> > >>          struct btrfs_inode *inode =3D bbio->inode;
> > >> @@ -849,10 +849,6 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, =
bool async)
> > >>          btrfs_add_ordered_sum(ordered, sums);
> > >>
> > >>          bbio->csum_saved_iter =3D bio->bi_iter;
> > >> -       if (!async) {
> > >> -               csum_one_bio(bbio);
> > >> -               return 0;
> > >> -       }
> > >>          bio_inc_remaining(bio);
> > >>          INIT_WORK(&bbio->csum_work, csum_one_bio_work);
> > >>          schedule_work(&bbio->csum_work);
> > >> diff --git a/fs/btrfs/file-item.h b/fs/btrfs/file-item.h
> > >> index 6c678787c770..60a0eb17b3f6 100644
> > >> --- a/fs/btrfs/file-item.h
> > >> +++ b/fs/btrfs/file-item.h
> > >> @@ -64,7 +64,7 @@ int btrfs_lookup_file_extent(struct btrfs_trans_ha=
ndle *trans,
> > >>   int btrfs_insert_data_csums(struct btrfs_trans_handle *trans,
> > >>                              struct btrfs_root *root,
> > >>                              struct btrfs_ordered_sum *sums);
> > >> -int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async);
> > >> +int btrfs_csum_one_bio(struct btrfs_bio *bbio);
> > >>   int btrfs_alloc_dummy_sum(struct btrfs_bio *bbio);
> > >>   int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u=
64 end,
> > >>                               struct list_head *list, int search_com=
mit,
> > >> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
> > >> index 3eba8438593c..203f7131f737 100644
> > >> --- a/fs/btrfs/fs.h
> > >> +++ b/fs/btrfs/fs.h
> > >> @@ -696,16 +696,6 @@ struct btrfs_fs_info {
> > >>          /* All fs/file tree roots that have delalloc inodes. */
> > >>          struct list_head delalloc_roots;
> > >>
> > >> -       /*
> > >> -        * There is a pool of worker threads for checksumming during=
 writes and
> > >> -        * a pool for checksumming after reads.  This is because rea=
ders can
> > >> -        * run with FS locks held, and the writers may be waiting fo=
r those
> > >> -        * locks.  We don't want ordering in the pending list to cau=
se
> > >> -        * deadlocks, and so the two are serviced separately.
> > >> -        *
> > >> -        * A third pool does submit_bio to avoid deadlocking with th=
e other two.
> > >> -        */
> > >> -       struct btrfs_workqueue *workers;
> > >>          struct btrfs_workqueue *delalloc_workers;
> > >>          struct btrfs_workqueue *flush_workers;
> > >>          struct workqueue_struct *endio_workers;
> > >> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > >> index 464129b1b0d4..54f2da47c567 100644
> > >> --- a/fs/btrfs/super.c
> > >> +++ b/fs/btrfs/super.c
> > >> @@ -1237,7 +1237,6 @@ static void btrfs_resize_thread_pool(struct bt=
rfs_fs_info *fs_info,
> > >>          btrfs_info(fs_info, "resize thread pool %d -> %d",
> > >>                 old_pool_size, new_pool_size);
> > >>
> > >> -       btrfs_workqueue_set_max(fs_info->workers, new_pool_size);
> > >>          btrfs_workqueue_set_max(fs_info->delalloc_workers, new_pool=
_size);
> > >>          btrfs_workqueue_set_max(fs_info->caching_workers, new_pool_=
size);
> > >>          workqueue_set_max_active(fs_info->endio_workers, new_pool_s=
ize);
> > >> --
> > >> 2.55.0
> > >>
> > >
> >
