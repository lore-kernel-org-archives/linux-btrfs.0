Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36DDBC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 15:25:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5783206BB
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 15:25:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="GmCfnLDX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5783206BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbeKTBtH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 20:49:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:54892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729474AbeKTBtH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 20:49:07 -0500
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C39B92086A
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2018 15:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542641110;
        bh=kYWkv6d4ulFJawYJw8cIlYz6MUI7N/Z4XUF+FWD3Up8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GmCfnLDXr4wfnYBxr4Xh6131/0mr+J/iwPpfifl0vPQHT07ovkpaFUmJMfVJdF7bt
         d3iwkCUN7wuUo05hjL3lL1HhNSYr+pmn8YF1o7/Wo/ea1XXaHctpMvh4m0COt8Ts1e
         7ReG0MXQj6PXb80sc06CroZ0P15VfkSg4QlAEjRc=
Received: by mail-ua1-f53.google.com with SMTP id v24so10791971uap.13
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2018 07:25:10 -0800 (PST)
X-Gm-Message-State: AGRZ1gK0VK/YvkhtpOSFRQFJKHKrXcsKetk5JiGeRgJVYLGIl7DgvIez
        PkyCGd8DxqlOr/RrFcwIMrLa82f94tA6NdVANRU=
X-Google-Smtp-Source: AJdET5ca7G6Ex3M4rCkRj/+RtIAuBi7BDsMU6tgiQVoo0jQ21hvmfPL1tVZzvMXSO/QRoVgrsfTh3S1PxRUxWxnR5JA=
X-Received: by 2002:ab0:590a:: with SMTP id n10mr10018729uad.137.1542641109761;
 Mon, 19 Nov 2018 07:25:09 -0800 (PST)
MIME-Version: 1.0
References: <20181119094823.27346-1-fdmanana@kernel.org> <20181119141536.20748-1-fdmanana@kernel.org>
 <19a37acc-9b6f-7606-7ddd-2119b9bda207@gmx.com>
In-Reply-To: <19a37acc-9b6f-7606-7ddd-2119b9bda207@gmx.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Mon, 19 Nov 2018 15:24:58 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5Zb7urzHfXUEEJQOeHJb8Uxkck35-5WAOggnYY=NkFMg@mail.gmail.com>
Message-ID: <CAL3q7H5Zb7urzHfXUEEJQOeHJb8Uxkck35-5WAOggnYY=NkFMg@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix deadlock when enabling quotas due to
 concurrent snapshot creation
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 19, 2018 at 2:48 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2018/11/19 =E4=B8=8B=E5=8D=8810:15, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > If the quota enable and snapshot creation ioctls are called concurrentl=
y
> > we can get into a deadlock where the task enabling quotas will deadlock
> > on the fs_info->qgroup_ioctl_lock mutex because it attempts to lock it
> > twice, or the task creating a snapshot tries to commit the transaction
> > while the task enabling quota waits for the former task to commit the
> > transaction while holding the mutex. The following time diagrams show h=
ow
> > both cases happen.
> >
> > First scenario:
> >
> >            CPU 0                                    CPU 1
> >
> >  btrfs_ioctl()
> >   btrfs_ioctl_quota_ctl()
> >    btrfs_quota_enable()
> >     mutex_lock(fs_info->qgroup_ioctl_lock)
> >     btrfs_start_transaction()
> >
> >                                              btrfs_ioctl()
> >                                               btrfs_ioctl_snap_create_v=
2
> >                                                create_snapshot()
> >                                                 --> adds snapshot to th=
e
> >                                                     list pending_snapsh=
ots
> >                                                     of the current
> >                                                     transaction
> >
> >     btrfs_commit_transaction()
> >      create_pending_snapshots()
> >        create_pending_snapshot()
> >         qgroup_account_snapshot()
> >          btrfs_qgroup_inherit()
> >          mutex_lock(fs_info->qgroup_ioctl_lock)
> >           --> deadlock, mutex already locked
> >               by this task at
> >               btrfs_quota_enable()
> >
> > Second scenario:
> >
> >            CPU 0                                    CPU 1
> >
> >  btrfs_ioctl()
> >   btrfs_ioctl_quota_ctl()
> >    btrfs_quota_enable()
> >     mutex_lock(fs_info->qgroup_ioctl_lock)
> >     btrfs_start_transaction()
> >
> >                                              btrfs_ioctl()
> >                                               btrfs_ioctl_snap_create_v=
2
> >                                                create_snapshot()
> >                                                 --> adds snapshot to th=
e
> >                                                     list pending_snapsh=
ots
> >                                                     of the current
> >                                                     transaction
> >
> >                                                 btrfs_commit_transactio=
n()
> >                                                  --> waits for task at
> >                                                      CPU 0 to release
> >                                                      its transaction
> >                                                      handle
> >
> >     btrfs_commit_transaction()
> >      --> sees another task started
> >          the transaction commit first
> >      --> releases its transaction
> >          handle
> >      --> waits for the transaction
> >          commit to be completed by
> >          the task at CPU 1
> >
> >                                                  create_pending_snapsho=
t()
> >                                                   qgroup_account_snapsh=
ot()
> >                                                    btrfs_qgroup_inherit=
()
> >                                                     mutex_lock(fs_info-=
>qgroup_ioctl_lock)
> >                                                      --> deadlock, task=
 at CPU 0
> >                                                          has the mutex =
locked but
> >                                                          it is waiting =
for us to
> >                                                          finish the tra=
nsaction
> >                                                          commit
> >
> > So fix this by setting the quota enabled flag in fs_info after committi=
ng
> > the transaction at btrfs_quota_enable(). This ends up serializing quota
> > enable and snapshot creation as if the snapshot creation happened just
> > before the quota enable request. The quota rescan task, scheduled after
> > committing the transaction in btrfs_quote_enable(), will do the account=
ing.
> >
> > Fixes: 6426c7ad697d ("btrfs: qgroup: Fix qgroup accounting when creatin=
g snapshot")
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >
> > V2: Added second deadlock example to changelog and changed the fix to d=
eal
> >     with that case as well.
> >
> >  fs/btrfs/qgroup.c | 14 ++++++++++----
> >  1 file changed, 10 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> > index d4917c0cddf5..ae1358253b7b 100644
> > --- a/fs/btrfs/qgroup.c
> > +++ b/fs/btrfs/qgroup.c
> > @@ -1013,16 +1013,22 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs=
_info)
> >               btrfs_abort_transaction(trans, ret);
> >               goto out_free_path;
> >       }
> > -     spin_lock(&fs_info->qgroup_lock);
> > -     fs_info->quota_root =3D quota_root;
> > -     set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
> > -     spin_unlock(&fs_info->qgroup_lock);
> >
> >       ret =3D btrfs_commit_transaction(trans);
> >       trans =3D NULL;
> >       if (ret)
> >               goto out_free_path;
>
> The main concern here is, if we don't set qgroup enabled bit before we
> commit transaction, there will be a window where new tree modification
> could happen before QGROUP_ENABLED bit set.

That doesn't seem to make much sense to me, if I understood correctly.
Essentially you're saying stuff done to any tree in the the
transaction we use to
enable quotas must be accounted for. In that case the quota enabled bit sho=
uld
be done as soon as the transaction is started, because before we set
it and after
we started (or joined) a transaction, a lot could of modifications may
have happened.
Nevertheless I don't think it's unexpected for anyone to have the
accounting happening
only after the quota enable ioctl returns success.

>
> There may be some qgroup reserved space related problem in such case,
> but I'm not 100% sure to foresee such problem.
>
>
> The best way to do this is, commit trans first, and before any other one
> trying to start transaction, we set the bit.
> However I can't find such infrastructure now (I still remember we used
> to have a pending bit to change quota enabled flag, but removed later)
>
> Thanks,
> Qu
>
> >
> > +     /*
> > +      * Set quota enabled flag after committing the transaction, to av=
oid
> > +      * deadlocks on fs_info->qgroup_ioctl_lock with concurrent snapsh=
ot
> > +      * creation.
> > +      */
> > +     spin_lock(&fs_info->qgroup_lock);
> > +     fs_info->quota_root =3D quota_root;
> > +     set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
> > +     spin_unlock(&fs_info->qgroup_lock);
> > +
> >       ret =3D qgroup_rescan_init(fs_info, 0, 1);
> >       if (!ret) {
> >               qgroup_rescan_zero_tracking(fs_info);
> >
>
