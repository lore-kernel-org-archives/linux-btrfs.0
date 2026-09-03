Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469F84A842B
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 12:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439464; cv=pass; b=mNwIkYJwOdRpULT40rFW8zpSROHAWs+FrtToT2XiUSH/bTJDCSAJKsgGOySnHJedqvdVZRmaXZmNl3J0d6R+tGzAMGyJ8habIHy7F0/qUP9Z1NCnTExs2uzF51/PnrsRhyXYX8oY6Aeb6+QTXpgxUQoHyQAdswXKEuJui1jWSoQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439464; c=relaxed/simple;
	bh=TjFRYDo7e87Ab12GDa9AEr/YhOvVmgU/jdOlZ0ecQBU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tpoSnXg7kCnoVQR4XQA8VqxEftatTtaPTFNrNuBwBhoASIOn7eveahp4Q8OTs4SsdbeoN3U55JqYlkL+7yKchrHQhCua1EiDy23pogdl+BKzesVFkX0pjnDDdJl2QZ1JQv/TongEANwGFvGyLjCDr6iRXv7thXZLgFSpO+QO+aY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=b5M+uRyb; arc=pass smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="b5M+uRyb"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-485852d03a4so255515f8f.0
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Sep 2026 05:44:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788439460; cv=none;
        d=google.com; s=arc-20260327;
        b=ZkKN0aMf9r0tfBk8J+heWFRWkQ1xazpY4L7KabKCdhtMsDazJf2hpkgoaXHKeK8CUr
         hBt8GY5of9l9Gilbu+dKk3iGcqjlhYVWY/pTnL+pKqlpE//oxnnel78kEpvKp8+WW2db
         /9pEtUa1bU7sETP2fmI64ZpzUGRC9qE6WWcIe9wtE54PvEGeAaLx4UEZyq4vOaGn/YCu
         Ga55C9dVFjDafYB6Be7pwbTvLg/09ulXyQIwobt4KcxC5fry/28RubPX68x4405vRRSG
         3k3jNR5hnPhhTlFU7vKrMmpVby4Byivy2PSDsElwC3uBWPajejPxQmL+WDEF/VR4y/tY
         Pm+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mep0qoKfSwYZq9edmm8MV4gY37EMhfxhPvk4ApMV27c=;
        fh=5kD17xrcyHCX/qTiADs1gIVlaAQlPp3S4ptkcZr4L2M=;
        b=m9D6gTCJ5bSEEc12c6CmwULfQ/tLLCJDqJ+237bAmMoeQunbE1EiKZtInXElhmqEIv
         jinWuhBdnDs/ri+AAvbwwDgVHDPSTdb+WczhcPwCDG7DKDjtwkASOseUcya1zD5PCjLX
         0c21580UU7RtRmu7SuL4aLmm6t+tDGnSo1fjpX4c7xYzWSbFytp8imjJQhoJhxzq5oEm
         qG5dFKWJ4KCeQciQUyLeldS6y2Im3ECSVO+zseiPz8q0T5PAYgfpcJTvYjdhybibWA0R
         yAkt531kOV0t279loHXIneT/fFxd/aX88LffSAa3giLjnu+deHtJV9UvPi2S2ltzzI26
         v4tQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788439460; x=1789044260; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mep0qoKfSwYZq9edmm8MV4gY37EMhfxhPvk4ApMV27c=;
        b=b5M+uRyb35NrKkFRqnTFP1maMZEqTbEbVavw1SzkJO339n2U3lDcWhs2NS9tKhUlHj
         zW7SxO2cPucebBtM8Wza2Zhtwsfag0lRRdKGHBkhUxkI21XsDBdSOGJd2WQb1Xf8LFwC
         hKN0FbB/OPVVIGVr+FR8NM+8y4Rl/kWWn6yJ2TZBsfsFuYnGYHAsL3KAlM4KPgQsOXSV
         fJAwlh6DlmiHG6MNLyDCxkkki594sX7NDAAwSeVs9C4RJMTpG41Bbs/o6VpKgNDsYcGK
         yfxfFhXr54G8aFKDDxqqlqmSxWIOdouJ0I9+uLm46QO5EeV3G+bIussyZP5Wz70CTeKA
         1z6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788439460; x=1789044260;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mep0qoKfSwYZq9edmm8MV4gY37EMhfxhPvk4ApMV27c=;
        b=gBEvafQvOOtcpkUq6xMO6AgSKrNg5p/1HCwjRkQNQ8dfOgQs9AIl6bEMQC/Lm+mGmf
         BYCmMI50o+/DxncWzLr0CMjOX0kHqEamPEKNAqm/oqc2u3ZXA6Au6z+wJ//e81dgD8Xp
         KCpC0z1gp4CRppq6JB/CcfbADtlxmbRqWChR/P/2mOc1SzA9ZaWtvLm2Xh2dWk64m6YG
         9JCrYpW8GMU7qklljVDq0O4652FNCAHUSj9CE5OBJ/ultJi8WKiUG83WnBKaoFUKwgVP
         fP0JS7VCaA1fKfcNWG4IzbrG1AVHUhqBoUjFU7a0t+TfglbEvwuG96dknx9YfBc8oaxh
         iytg==
X-Forwarded-Encrypted: i=1; AKwUvByZ4XmJxfYoGZN+1LMyf59MZXPTvZoCaSuxHTU+uPQc+hHf/in3jowOcbyztkgwVc/vDSSgNdh3FFayGw==@vger.kernel.org
X-Gm-Message-State: AFuF++m4c0zDAkO2GR0RRXJIwiMwjbAQup53TmZEHLTSKA4bWeE0RFqV
	J3G2sFqIWy3jMlhS55Fz7vCE8htAFwq0mvCRafT2qVdvIBVNlYIQDAbG17HICZCXpEQx5J6Hs1o
	F0imleXVnD5QsQ8n4LFwyAXcARW+W11asSKxYZH3XEORScX7/TZSBsf4=
X-Gm-Gg: AYBFou16mFAqQl01kavMHsJBozGUlROmInOTQEu045Q3eCoLsFilksmzgT190kadvPL
	Klotf+JN+lwkUMZJZNF7DNIjSD8tBmSb/graTAgjW0RJ66f3l6tSDdKzijwZudVlwdeanAfcOg6
	rKtjB52YLgabRQ8CfYmRQ5CJCYhy7R3znlWfMCkGGbyhjXat6+SX0u99XJ9zayb2SVICTXjh0/k
	DbxommzCKGcs/Cm61hCUX8RnSTe2ZN/t9cqD4Zy3PLq3xdQxaJBlle6rhFsViuTbUCgTavO6f5h
	BQTjLXFFXjGUMDym5D52u/VgdueXob02/mXIE83ETHmsn7KrBeF0IgDQltZK+YTv/ebKMPP5QUi
	ljQtdYxAjNHquxqz4HGE/lmK2W8AG3/I+Qm/PLDJAdHQ7lb+EhFSn
X-Received: by 2002:a5d:59c7:0:b0:484:40b0:ef30 with SMTP id
 ffacd0b85a97d-48586028ca9mr29344f8f.6.1788439460130; Thu, 03 Sep 2026
 05:44:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <700ba6c46da86ace18a502b43c5e61d16a556060.1788424754.git.wqu@suse.com>
 <CAPjX3FeQ40fcFjfiH=5EK57YvmVDtGxyz152T9FHUOmJuuaOFQ@mail.gmail.com> <00fc1bdb-cb69-4339-8184-afc04fceab19@gmx.com>
In-Reply-To: <00fc1bdb-cb69-4339-8184-afc04fceab19@gmx.com>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 3 Sep 2026 14:44:09 +0200
X-Gm-Features: AcwNN1WbemQb93f8T7uG0kLH2zPRqqh8cml7fP6eIpBDZLi__R9YJa0K_C99LAw
Message-ID: <CAPjX3FdkWegsttPk9FiTiVUp9dcdycWWmecnpSxcgrpwnw=TEg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: move async csum generation out of experimental features
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 3 Sept 2026 at 13:27, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> =E5=9C=A8 2026/9/3 18:50, Daniel Vacek =E5=86=99=E9=81=93:
> > On Thu, 3 Sept 2026 at 10:40, Qu Wenruo <wqu@suse.com> wrote:
> >> Commit dd57c78aec39 ("btrfs: introduce btrfs_bio::async_csum")
> >> introduced asynchronous data checksum generation for data writes.
> >>
> >> That feature can improve write performance, and was introduced in v6.1=
9.
> >> We have not experienced bugs related to that, so it's time to move it =
out
> >> of experimental features for end users.
> >>
> >> Furthermore since the async checksum generation means
> >> should_async_write() will always return false, we no longer need to
> >> maintain the fs_info->workers workqueue, as the async checksum
> >> generation is using the system_percpu_wq.
> >
> > I understand these are two related changes in one patch here. If
> > removing async writes depends on async checksums, it would be nice to
> > split this into a patch series.
> >
> > Though I guess can live with that. Looks good enough to me.
> >
> > Reviewed-by: Daniel Vacek <neelx@suse.com>
>
> Thanks a lot for the review.
>
>
> I just want to mention that, Sashiko mentioned a problem that I believe
> is valid, but not sure how realistic it will be in the real world.
>
>
> Sashiko mentioned that, the old worker workqueue has WQ_MEM_RECLAIM
> flag, thus there will always be a rescuer to ensure forward progress.
> (Although for x86_64 and other common archs or EXPERIMENTAL builds, we
> never utilize that worker anyway)
>
> But the new schedule_work() is using system_percpu_wq, which doesn't has
> that flag.

Well, I think squashing this fixup to my patch is the right thing to do any=
ways:

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 0fed4e0d32d5..984d87ad79b0 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -855,7 +855,7 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool asy=
nc)
     }
     bio_inc_remaining(bio);
     INIT_WORK(&bbio->csum_work, csum_one_bio_work);
-    schedule_work(&bbio->csum_work);
+    queue_work(fs_info->endio_workers, &bbio->csum_work);
     return 0;
 }


That should make sashiko happy as well as btrfs end_io work running on
btrfs end_io work queues.

And we should stay on the safe side wrt memory reclaim.

--nX


> And since the csum generation is needed for data writeback, if under
> very heavy memory pressure, there may be no worker to ensure the csum
> work can be queued, in that case, it will hang the writeback (which is
> triggered to reclaim memory).
>
> If we really want to address that problem, your idea about splitting the
> patch will make a lot of sense.
> We will need to keep the old infrastructure first, convert the worker to
> a regular workqueue, and call queue_work(), then fully remove unused code=
.
>
>
> But on the other hand, I doubt how pratically it is for anyone to stall
> system_percpu_wq.
> It's very common utilized across the whole kernel, and if it really
> stalls I think there are a lot of more things to bother before btrfs.
>
> Another thing is, if we use fs_info::workers, we will follow the
> existing wq flags, which means no PERCPU flag.
> And according to the existing docs for those flags, PERCPU wq has a
> better performance due to CPU locality.
>
>
> So overall I think the current version is good enough, but not perfect.
> On the other hand, using a WQ_MEM_RECLAIM seems more "correct", but will
> definitely introduce some extra pentalty.
>
> If someone else has some idea on this Sashiko review, or very familiar
> with the WQ_MEM_RECLAIM situation, any comment will be appreciated.
>
> Thanks,
> Qu
>
> >
> >> Suggested-by: Daniel Vacek <neelx@suse.com>
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >> ---
> >>   fs/btrfs/bio.c       | 136 +----------------------------------------=
--
> >>   fs/btrfs/disk-io.c   |  20 +------
> >>   fs/btrfs/file-item.c |   6 +-
> >>   fs/btrfs/file-item.h |   2 +-
> >>   fs/btrfs/fs.h        |  10 ----
> >>   fs/btrfs/super.c     |   1 -
> >>   6 files changed, 4 insertions(+), 171 deletions(-)
> >>
> >> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> >> index 771b7d598aee..e08006543c3d 100644
> >> --- a/fs/btrfs/bio.c
> >> +++ b/fs/btrfs/bio.c
> >> @@ -569,136 +569,7 @@ static int btrfs_bio_csum(struct btrfs_bio *bbio=
)
> >>   {
> >>          if (bbio->bio.bi_opf & REQ_META)
> >>                  return btree_csum_one_bio(bbio);
> >> -#ifdef CONFIG_BTRFS_EXPERIMENTAL
> >> -       return btrfs_csum_one_bio(bbio, true);
> >> -#else
> >> -       return btrfs_csum_one_bio(bbio, false);
> >> -#endif
> >> -}
> >> -
> >> -/*
> >> - * Async submit bios are used to offload expensive checksumming onto =
the worker
> >> - * threads.
> >> - */
> >> -struct async_submit_bio {
> >> -       struct btrfs_bio *bbio;
> >> -       struct btrfs_io_context *bioc;
> >> -       struct btrfs_io_stripe smap;
> >> -       int mirror_num;
> >> -       struct btrfs_work work;
> >> -};
> >> -
> >> -/*
> >> - * In order to insert checksums into the metadata in large chunks, we=
 wait
> >> - * until bio submission time.   All the pages in the bio are checksum=
med and
> >> - * sums are attached onto the ordered extent record.
> >> - *
> >> - * At IO completion time the csums attached on the ordered extent rec=
ord are
> >> - * inserted into the btree.
> >> - */
> >> -static void run_one_async_start(struct btrfs_work *work)
> >> -{
> >> -       struct async_submit_bio *async =3D
> >> -               container_of(work, struct async_submit_bio, work);
> >> -       int ret;
> >> -
> >> -       ret =3D btrfs_bio_csum(async->bbio);
> >> -       if (ret)
> >> -               async->bbio->bio.bi_status =3D errno_to_blk_status(ret=
);
> >> -}
> >> -
> >> -/*
> >> - * In order to insert checksums into the metadata in large chunks, we=
 wait
> >> - * until bio submission time.   All the pages in the bio are checksum=
med and
> >> - * sums are attached onto the ordered extent record.
> >> - *
> >> - * At IO completion time the csums attached on the ordered extent rec=
ord are
> >> - * inserted into the tree.
> >> - *
> >> - * If called with @do_free =3D=3D true, then it will free the work st=
ruct.
> >> - */
> >> -static void run_one_async_done(struct btrfs_work *work, bool do_free)
> >> -{
> >> -       struct async_submit_bio *async =3D
> >> -               container_of(work, struct async_submit_bio, work);
> >> -       struct bio *bio =3D &async->bbio->bio;
> >> -
> >> -       if (do_free) {
> >> -               kfree(container_of(work, struct async_submit_bio, work=
));
> >> -               return;
> >> -       }
> >> -
> >> -       /* If an error occurred we just want to clean up the bio and m=
ove on. */
> >> -       if (bio->bi_status) {
> >> -               btrfs_bio_end_io(async->bbio, bio->bi_status);
> >> -               return;
> >> -       }
> >> -
> >> -       /*
> >> -        * All of the bios that pass through here are from async helpe=
rs.
> >> -        * Use REQ_BTRFS_CGROUP_PUNT to issue them from the owning cgr=
oup's
> >> -        * context.  This changes nothing when cgroups aren't in use.
> >> -        */
> >> -       bio->bi_opf |=3D REQ_BTRFS_CGROUP_PUNT;
> >> -       btrfs_submit_bio(bio, async->bioc, &async->smap, async->mirror=
_num);
> >> -}
> >> -
> >> -static bool should_async_write(struct btrfs_bio *bbio)
> >> -{
> >> -       struct btrfs_fs_info *fs_info =3D bbio->inode->root->fs_info;
> >> -       bool auto_csum_mode =3D true;
> >> -
> >> -#ifdef CONFIG_BTRFS_EXPERIMENTAL
> >> -       /*
> >> -        * Write bios will calculate checksum and submit bio at the sa=
me time.
> >> -        * Unless explicitly required don't offload serial csum calcul=
ate and bio
> >> -        * submit into a workqueue.
> >> -        */
> >> -       return false;
> >> -#endif
> >> -
> >> -       /* Submit synchronously if the checksum implementation is fast=
. */
> >> -       if (auto_csum_mode && test_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_in=
fo->flags))
> >> -               return false;
> >> -
> >> -       /*
> >> -        * Try to defer the submission to a workqueue to parallelize t=
he
> >> -        * checksum calculation unless the I/O is issued synchronously=
.
> >> -        */
> >> -       if (op_is_sync(bbio->bio.bi_opf))
> >> -               return false;
> >> -
> >> -       /* Zoned devices require I/O to be submitted in order. */
> >> -       if ((bbio->bio.bi_opf & REQ_META) && btrfs_is_zoned(fs_info))
> >> -               return false;
> >> -
> >> -       return true;
> >> -}
> >> -
> >> -/*
> >> - * Submit bio to an async queue.
> >> - *
> >> - * Return true if the work has been successfully submitted, else fals=
e.
> >> - */
> >> -static bool btrfs_wq_submit_bio(struct btrfs_bio *bbio,
> >> -                               struct btrfs_io_context *bioc,
> >> -                               struct btrfs_io_stripe *smap, int mirr=
or_num)
> >> -{
> >> -       struct btrfs_fs_info *fs_info =3D bbio->inode->root->fs_info;
> >> -       struct async_submit_bio *async;
> >> -
> >> -       async =3D kmalloc_obj(*async, GFP_NOFS);
> >> -       if (!async)
> >> -               return false;
> >> -
> >> -       async->bbio =3D bbio;
> >> -       async->bioc =3D bioc;
> >> -       async->smap =3D *smap;
> >> -       async->mirror_num =3D mirror_num;
> >> -
> >> -       btrfs_init_work(&async->work, run_one_async_start, run_one_asy=
nc_done);
> >> -       btrfs_queue_work(fs_info->workers, &async->work);
> >> -       return true;
> >> +       return btrfs_csum_one_bio(bbio);
> >>   }
> >>
> >>   static u64 btrfs_append_map_length(struct btrfs_bio *bbio, u64 map_l=
ength)
> >> @@ -806,10 +677,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio *=
bbio, int mirror_num)
> >>                  if (!(inode->flags & BTRFS_INODE_NODATASUM) &&
> >>                      !test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_info-=
>fs_state) &&
> >>                      !btrfs_is_data_reloc_root(inode->root) && !bbio->=
is_remap) {
> >> -                       if (should_async_write(bbio) &&
> >> -                           btrfs_wq_submit_bio(bbio, bioc, &smap, mir=
ror_num))
> >> -                               goto done;
> >> -
> >>                          ret =3D btrfs_bio_csum(bbio);
> >>                          status =3D errno_to_blk_status(ret);
> >>                          if (status)
> >> @@ -824,7 +691,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio *b=
bio, int mirror_num)
> >>          }
> >>
> >>          btrfs_submit_bio(bio, bioc, &smap, mirror_num);
> >> -done:
> >>          return map_length =3D=3D length;
> >>
> >>   fail:
> >> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> >> index a1d83ad9a4c0..0046f3cb75a1 100644
> >> --- a/fs/btrfs/disk-io.c
> >> +++ b/fs/btrfs/disk-io.c
> >> @@ -1776,7 +1776,6 @@ static void btrfs_stop_all_workers(struct btrfs_=
fs_info *fs_info)
> >>          if (fs_info->fixup_workers)
> >>                  destroy_workqueue(fs_info->fixup_workers);
> >>          btrfs_destroy_workqueue(fs_info->delalloc_workers);
> >> -       btrfs_destroy_workqueue(fs_info->workers);
> >>          if (fs_info->endio_workers)
> >>                  destroy_workqueue(fs_info->endio_workers);
> >>          if (fs_info->rmw_workers)
> >> @@ -1968,9 +1967,6 @@ static int btrfs_init_workqueues(struct btrfs_fs=
_info *fs_info)
> >>          unsigned int flags =3D WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNB=
OUND;
> >>          unsigned int ordered_flags =3D WQ_MEM_RECLAIM | WQ_FREEZABLE;
> >>
> >> -       fs_info->workers =3D
> >> -               btrfs_alloc_workqueue(fs_info, "worker", flags, max_ac=
tive, 16);
> >> -
> >>          fs_info->delalloc_workers =3D
> >>                  btrfs_alloc_workqueue(fs_info, "delalloc",
> >>                                        flags, max_active, 2);
> >> @@ -2005,8 +2001,7 @@ static int btrfs_init_workqueues(struct btrfs_fs=
_info *fs_info)
> >>          fs_info->discard_ctl.discard_workers =3D
> >>                  alloc_ordered_workqueue("btrfs-discard", WQ_FREEZABLE=
);
> >>
> >> -       if (!(fs_info->workers &&
> >> -             fs_info->delalloc_workers && fs_info->flush_workers &&
> >> +       if (!(fs_info->delalloc_workers && fs_info->flush_workers &&
> >>                fs_info->endio_workers && fs_info->endio_meta_workers &=
&
> >>                fs_info->endio_write_workers &&
> >>                fs_info->endio_freespace_worker && fs_info->rmw_workers=
 &&
> >> @@ -4437,19 +4432,6 @@ void __cold close_ctree(struct btrfs_fs_info *f=
s_info)
> >>           */
> >>          btrfs_flush_workqueue(fs_info->delalloc_workers);
> >>
> >> -       /*
> >> -        * We can have ordered extents getting their last reference dr=
opped from
> >> -        * the fs_info->workers queue because for async writes for dat=
a bios we
> >> -        * queue a work for that queue, at btrfs_wq_submit_bio(), that=
 runs
> >> -        * run_one_async_done() which calls btrfs_bio_end_io() in case=
 the bio
> >> -        * has an error, and that later function can do the final
> >> -        * btrfs_put_ordered_extent() on the ordered extent attached t=
o the bio,
> >> -        * which adds a delayed iput for the inode. So we must flush t=
he queue
> >> -        * so that we don't have delayed iputs after committing the cu=
rrent
> >> -        * transaction below and stopping the cleaner and transaction =
kthreads.
> >> -        */
> >> -       btrfs_flush_workqueue(fs_info->workers);
> >> -
> >>          /*
> >>           * When finishing a compressed write bio we schedule a work q=
ueue item
> >>           * to finish an ordered extent - end_bbio_compressed_write()
> >> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> >> index 0fed4e0d32d5..7dbd9b8eec11 100644
> >> --- a/fs/btrfs/file-item.c
> >> +++ b/fs/btrfs/file-item.c
> >> @@ -825,7 +825,7 @@ static void csum_one_bio_work(struct work_struct *=
work)
> >>   /*
> >>    * Calculate checksums of the data contained inside a bio.
> >>    */
> >> -int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
> >> +int btrfs_csum_one_bio(struct btrfs_bio *bbio)
> >>   {
> >>          struct btrfs_ordered_extent *ordered =3D bbio->ordered;
> >>          struct btrfs_inode *inode =3D bbio->inode;
> >> @@ -849,10 +849,6 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bo=
ol async)
> >>          btrfs_add_ordered_sum(ordered, sums);
> >>
> >>          bbio->csum_saved_iter =3D bio->bi_iter;
> >> -       if (!async) {
> >> -               csum_one_bio(bbio);
> >> -               return 0;
> >> -       }
> >>          bio_inc_remaining(bio);
> >>          INIT_WORK(&bbio->csum_work, csum_one_bio_work);
> >>          schedule_work(&bbio->csum_work);
> >> diff --git a/fs/btrfs/file-item.h b/fs/btrfs/file-item.h
> >> index 6c678787c770..60a0eb17b3f6 100644
> >> --- a/fs/btrfs/file-item.h
> >> +++ b/fs/btrfs/file-item.h
> >> @@ -64,7 +64,7 @@ int btrfs_lookup_file_extent(struct btrfs_trans_hand=
le *trans,
> >>   int btrfs_insert_data_csums(struct btrfs_trans_handle *trans,
> >>                              struct btrfs_root *root,
> >>                              struct btrfs_ordered_sum *sums);
> >> -int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async);
> >> +int btrfs_csum_one_bio(struct btrfs_bio *bbio);
> >>   int btrfs_alloc_dummy_sum(struct btrfs_bio *bbio);
> >>   int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64=
 end,
> >>                               struct list_head *list, int search_commi=
t,
> >> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
> >> index 3eba8438593c..203f7131f737 100644
> >> --- a/fs/btrfs/fs.h
> >> +++ b/fs/btrfs/fs.h
> >> @@ -696,16 +696,6 @@ struct btrfs_fs_info {
> >>          /* All fs/file tree roots that have delalloc inodes. */
> >>          struct list_head delalloc_roots;
> >>
> >> -       /*
> >> -        * There is a pool of worker threads for checksumming during w=
rites and
> >> -        * a pool for checksumming after reads.  This is because reade=
rs can
> >> -        * run with FS locks held, and the writers may be waiting for =
those
> >> -        * locks.  We don't want ordering in the pending list to cause
> >> -        * deadlocks, and so the two are serviced separately.
> >> -        *
> >> -        * A third pool does submit_bio to avoid deadlocking with the =
other two.
> >> -        */
> >> -       struct btrfs_workqueue *workers;
> >>          struct btrfs_workqueue *delalloc_workers;
> >>          struct btrfs_workqueue *flush_workers;
> >>          struct workqueue_struct *endio_workers;
> >> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> >> index 464129b1b0d4..54f2da47c567 100644
> >> --- a/fs/btrfs/super.c
> >> +++ b/fs/btrfs/super.c
> >> @@ -1237,7 +1237,6 @@ static void btrfs_resize_thread_pool(struct btrf=
s_fs_info *fs_info,
> >>          btrfs_info(fs_info, "resize thread pool %d -> %d",
> >>                 old_pool_size, new_pool_size);
> >>
> >> -       btrfs_workqueue_set_max(fs_info->workers, new_pool_size);
> >>          btrfs_workqueue_set_max(fs_info->delalloc_workers, new_pool_s=
ize);
> >>          btrfs_workqueue_set_max(fs_info->caching_workers, new_pool_si=
ze);
> >>          workqueue_set_max_active(fs_info->endio_workers, new_pool_siz=
e);
> >> --
> >> 2.55.0
> >>
> >
>
