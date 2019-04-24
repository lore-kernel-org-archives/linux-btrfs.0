Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A11C10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 10:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFF6D2175B
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 10:19:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VXo9NAje"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbfDXKTx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 06:19:53 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:45687 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbfDXKTx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 06:19:53 -0400
Received: by mail-vs1-f67.google.com with SMTP id o10so10052189vsp.12
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2019 03:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=juD6gbIqaW6ZOJRKuDfcBaakfr1VOCVI/u8RtHuw5TM=;
        b=VXo9NAjeZ9DN/xJfpX2es2zRyiykM/2mtqoD/URmXT3byXft1h5mtKRDYy6dmhwV4w
         2mVm1vYEGMuOcc3T4bLFuDoUUNeox/+Vj+NIcJQuug/NntAnGf5RZ8Glmo/lN3nQzTmh
         jKOp2pcpzyeIpLKnslcrvXD9PvwgNTcqOheZ709skDPt4rZPUjpGTKvsOjzjYHItKlAA
         jyYP2pwFmLzKPiCpbLMD3RMu1+5Sg9hk0xYRFmoT+fBmIkIroNE4hdhGhiy0Qvg6u+kU
         lxyJdZsxLjAHSHlWJebMTGm3uJcn7XQn28cgZgw4e7WsI2b+q+P3P94a0G/GGODY3Wcu
         qhDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=juD6gbIqaW6ZOJRKuDfcBaakfr1VOCVI/u8RtHuw5TM=;
        b=Xk6Fb+vrG0oTGbBDU5ZiDqKcxtPm1DilqG/Z33wY5ISQxgsDasZxFRU4Sii3PJCVKp
         KjRvR3WtjNUluH2jN75Mz4M1u28054Jag9+4d4QZ2l1RXChHDIxbb80FFTHA5jeg6Nlt
         lPoSba4Sbg9U8pYDjIBin/caVb5xvBozd9auhSb4oCkrlCs30X2NL9gfKV9ufNT4Sqy6
         MqNKITwN44hA/mb6SvG2AfjtibwvyZtJJaqpRmi4NH2jkSF2J9iu0zi0ccaLQy44UlVc
         dvzkHyxxt+CfeerKaYj5X/vDu64MgcHQfbYkbfvooEIRE43qeK2lngsSsRKZsgsnR/0t
         hUdA==
X-Gm-Message-State: APjAAAX/1eaUkQ9Qq5Hn661icl00NBXlzDFx5PEidHQGAmPs+8E2Zbgj
        tJefjOQklwtSfbYrpLHFWvNcfswqCxZSbOA6gwA=
X-Google-Smtp-Source: APXvYqwhhiRT1t2Urch/dDxoNJ2F54lakell5Gb1yqriVui9e2bsQmUn+YRgl3dcT1ZauNgSeQcy4FtWQ7vR2TTCajc=
X-Received: by 2002:a67:e24b:: with SMTP id w11mr16250401vse.14.1556101191776;
 Wed, 24 Apr 2019 03:19:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190423114207.7899-1-nborisov@suse.com> <CAL3q7H5VLS8h4G5A5aTxCtg0SurZR0Yt-DxCqeU6sHSHuxfg_g@mail.gmail.com>
In-Reply-To: <CAL3q7H5VLS8h4G5A5aTxCtg0SurZR0Yt-DxCqeU6sHSHuxfg_g@mail.gmail.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Wed, 24 Apr 2019 11:19:40 +0100
Message-ID: <CAL3q7H6H9eDwz3umRBa3bORT1FnSevsp-BUQfn7t5yJG1n22aQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs: Simplify snapshot exclusion code
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 24, 2019 at 10:49 AM Filipe Manana <fdmanana@gmail.com> wrote:
>
> On Tue, Apr 23, 2019 at 12:43 PM Nikolay Borisov <nborisov@suse.com> wrot=
e:
> >
> > BTRFS sports a mechanism to provide exclusion when a snapshot is about
> > to be created. This is implemented via btrfs_start_write_no_snapshottin=
g
> > et al. Currently the implementation of that mechanism is some perverse
> > amalgamation of a percpu variable, an explicit waitqueue, an atomic_t
> > variable and an implicit wait bit on said atomic_t via wait_var_event
> > family of API. And for good measure there is a memory barrier thrown in
> > the mix...
> >
> > Astute reader should have concluded by now that it's bordering on
> > impossible to prove whether this scheme works. What's worse - all of
> > this is required to achieve something really simple - ensure certain
> > operations cannot run during snapshot creation. Let's simplify this by
> > relying on a single atomic_t used as a boolean flag.
>
> Nop, can't work as a boolean, see below.
>
> > This commit changes
> > only the implementation and not the semantics of the existing mechanism=
.
> >
> > Now, if the atomic is 1 (snapshot is in progress) callers of
> > btrfs_start_write_no_snapshotting will get a ret val of 0 that should b=
e
> > handled accordingly.
> >
> > btrfs_wait_for_snapshot_creation OTOH will block until snapshotting is
> > in progress and return when current snapshot in progress is finished an=
d
> > will acquire the right to create a snapshot.
> >
> > Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> > ---
> >  fs/btrfs/extent-tree.c | 20 +++++---------------
> >  fs/btrfs/ioctl.c       |  9 ++-------
> >  2 files changed, 7 insertions(+), 22 deletions(-)
> >
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 8f2b7b29c3fd..d9e2e35700fd 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -11333,25 +11333,15 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_in=
fo, struct fstrim_range *range)
> >   */
> >  void btrfs_end_write_no_snapshotting(struct btrfs_root *root)
> >  {
> > -       percpu_counter_dec(&root->subv_writers->counter);
> > -       cond_wake_up(&root->subv_writers->wait);
> > +       ASSERT(atomic_read(&root->will_be_snapshotted) =3D=3D 1);
> > +       if (atomic_dec_and_test(&root->will_be_snapshotted))
> > +               wake_up_var(&root->will_be_snapshotted);
> >  }
> >
> >  int btrfs_start_write_no_snapshotting(struct btrfs_root *root)
> >  {
> > -       if (atomic_read(&root->will_be_snapshotted))
> > -               return 0;
> > -
> > -       percpu_counter_inc(&root->subv_writers->counter);
> > -       /*
> > -        * Make sure counter is updated before we check for snapshot cr=
eation.
> > -        */
> > -       smp_mb();
> > -       if (atomic_read(&root->will_be_snapshotted)) {
> > -               btrfs_end_write_no_snapshotting(root);
> > -               return 0;
> > -       }
> > -       return 1;
> > +       ASSERT(atomic_read(&root->will_be_snapshotted) >=3D 0);
> > +       return atomic_add_unless(&root->will_be_snapshotted, 1, 1);
> >  }
>
> So if two writes call btrfs_start_write_no_snapshotting(), we end up
> with root->will_be_snapshotted =3D=3D 1.
>
> One task calls btrfs_end_write_no_snapshotting(), it decrements it to
> 1 - we wake up the snapshot creation task while there's still one
> nodatacow writer - this is incorrect.
> Now the second task calls btrfs_end_write_no_snapshotting(), sees
> root->will_be_snapshotted =3D=3D 0, assertion failure.

Actually take that out, I ignored the return value of atomic_add_unless().

So this change does not allow for concurrent no snapshot writers anymore,
multiple tasks calling btrfs_start_write_no_snapshotting(), only one
succeeds and all the others fail,
so that's a regression from what we currently have.

The rest of the confusing names still applies.

>
> >
> >  void btrfs_wait_for_snapshot_creation(struct btrfs_root *root)
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index 8774d4be7c97..f9f66c8a5dad 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -794,11 +794,7 @@ static int create_snapshot(struct btrfs_root *root=
, struct inode *dir,
> >          * possible. This is to avoid later writeback (running dealloc)=
 to
> >          * fallback to COW mode and unexpectedly fail with ENOSPC.
> >          */
> > -       atomic_inc(&root->will_be_snapshotted);
> > -       smp_mb__after_atomic();
> > -       /* wait for no snapshot writes */
> > -       wait_event(root->subv_writers->wait,
> > -                  percpu_counter_sum(&root->subv_writers->counter) =3D=
=3D 0);
> > +       btrfs_wait_for_snapshot_creation(root);
>
> This naming is also confusing now. The task that creates a snapshot is
> calling btrfs_wait_for_snapshot_creation(), waiting for itself?
>
> >
> >         ret =3D btrfs_start_delalloc_snapshot(root);
> >         if (ret)
> > @@ -878,8 +874,7 @@ static int create_snapshot(struct btrfs_root *root,=
 struct inode *dir,
> >  dec_and_free:
> >         if (snapshot_force_cow)
> >                 atomic_dec(&root->snapshot_force_cow);
> > -       if (atomic_dec_and_test(&root->will_be_snapshotted))
> > -               wake_up_var(&root->will_be_snapshotted);
> > +       btrfs_end_write_no_snapshotting(root);
>
> Also confusing. We are not ending a write operation, we are ending
> snapshot creation.
>
> Thanks.
>
> >  free_pending:
> >         kfree(pending_snapshot->root_item);
> >         btrfs_free_path(pending_snapshot->path);
> > --
> > 2.17.1
> >
>
>
> --
> Filipe David Manana,
>
> =E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you'=
re right.=E2=80=9D



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
