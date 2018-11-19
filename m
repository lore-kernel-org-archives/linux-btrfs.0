Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5634DC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 11:52:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0830820831
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 11:52:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="iNN4BD2u"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0830820831
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbeKSWQT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 17:16:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728558AbeKSWQT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 17:16:19 -0500
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D1B720831
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2018 11:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542628374;
        bh=kXDpHGlw4YfUiZAhckvecL9Y7CYh/8S5zFj9LAffqgY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iNN4BD2u18ttmDiOKo9vE0GdyXfWcyl3SjQO/uUlAmDlGPbcJpLpZEgoGrPkfEH5k
         Lv/s2AdqBsVwyRIj9mwlb5RjduKHvNfAg7W7Q7r9RgrjIUOb0q8vwG6uBodYW4Jkls
         ts8+EMVSnKWS9zmjZWe4gf04DnDnKoxkv5SluQ9w=
Received: by mail-vs1-f48.google.com with SMTP id g68so17548130vsd.11
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2018 03:52:54 -0800 (PST)
X-Gm-Message-State: AGRZ1gKxds8mIUcxYqEuaLNMov4H2P4hgcBUaXTFuFf6/1ic8e1oNlmf
        CL4l01SUusnugGtMFi09zED1c9KeRwiJJZd4+Po=
X-Google-Smtp-Source: AJdET5dsb0u8R74cH7FymwJjVGzWSrwBOyocCz8Ee15XUg57vN741sRNLdIMh0p2WpmyAopr6vEBbVmRdA2wt8Hbfoc=
X-Received: by 2002:a67:4c51:: with SMTP id z78mr7576012vsa.99.1542628373377;
 Mon, 19 Nov 2018 03:52:53 -0800 (PST)
MIME-Version: 1.0
References: <20181119094823.27346-1-fdmanana@kernel.org> <f42a7622-0ebb-f431-c484-cb3c4013b7a7@gmx.com>
 <CAL3q7H6r-yLb+e84UxJ=tFLMa9MgP72MRoK9TYsyxfQ8x=DXEQ@mail.gmail.com> <89659371-3ab8-5305-746c-ab01295bac08@gmx.com>
In-Reply-To: <89659371-3ab8-5305-746c-ab01295bac08@gmx.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Mon, 19 Nov 2018 11:52:41 +0000
X-Gmail-Original-Message-ID: <CAL3q7H4FkWver_tO8vqcEdLCxgoXr1cxbiKP7AoU6a9kcipxyg@mail.gmail.com>
Message-ID: <CAL3q7H4FkWver_tO8vqcEdLCxgoXr1cxbiKP7AoU6a9kcipxyg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix deadlock when enabling quotas due to
 concurrent snapshot creation
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 19, 2018 at 11:35 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2018/11/19 =E4=B8=8B=E5=8D=887:13, Filipe Manana wrote:
> > On Mon, Nov 19, 2018 at 11:09 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
> >>
> >>
> >>
> >> On 2018/11/19 =E4=B8=8B=E5=8D=885:48, fdmanana@kernel.org wrote:
> >>> From: Filipe Manana <fdmanana@suse.com>
> >>>
> >>> If the quota enable and snapshot creation ioctls are called concurren=
tly
> >>> we can get into a deadlock where the task enabling quotas will deadlo=
ck
> >>> on the fs_info->qgroup_ioctl_lock mutex because it attempts to lock i=
t
> >>> twice. The following time diagram shows how this happens.
> >>>
> >>>            CPU 0                                    CPU 1
> >>>
> >>>  btrfs_ioctl()
> >>>   btrfs_ioctl_quota_ctl()
> >>>    btrfs_quota_enable()
> >>>     mutex_lock(fs_info->qgroup_ioctl_lock)
> >>>     btrfs_start_transaction()
> >>>
> >>>                                              btrfs_ioctl()
> >>>                                               btrfs_ioctl_snap_create=
_v2
> >>>                                                create_snapshot()
> >>>                                                 --> adds snapshot to =
the
> >>>                                                     list pending_snap=
shots
> >>>                                                     of the current
> >>>                                                     transaction
> >>>
> >>>     btrfs_commit_transaction()
> >>>      create_pending_snapshots()
> >>>        create_pending_snapshot()
> >>>         qgroup_account_snapshot()
> >>>          btrfs_qgroup_inherit()
> >>>          mutex_lock(fs_info->qgroup_ioctl_lock)
> >>>           --> deadlock, mutex already locked
> >>>               by this task at
> >>>               btrfs_quota_enable()
> >>
> >> The backtrace looks valid.
> >>
> >>>
> >>> So fix this by adding a flag to the transaction handle that signals i=
f the
> >>> transaction is being used for enabling quotas (only seen by the task =
doing
> >>> it) and do not lock the mutex qgroup_ioctl_lock at btrfs_qgroup_inher=
it()
> >>> if the transaction handle corresponds to the one being used to enable=
 the
> >>> quotas.
> >>>
> >>> Fixes: 6426c7ad697d ("btrfs: qgroup: Fix qgroup accounting when creat=
ing snapshot")
> >>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> >>> ---
> >>>  fs/btrfs/qgroup.c      | 10 ++++++++--
> >>>  fs/btrfs/transaction.h |  1 +
> >>>  2 files changed, 9 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> >>> index d4917c0cddf5..3aec3bfa3d70 100644
> >>> --- a/fs/btrfs/qgroup.c
> >>> +++ b/fs/btrfs/qgroup.c
> >>> @@ -908,6 +908,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_i=
nfo)
> >>>               trans =3D NULL;
> >>>               goto out;
> >>>       }
> >>> +     trans->enabling_quotas =3D true;
> >>
> >> Should we put enabling_quotas bit into btrfs_transaction instead of
> >> btrfs_trans_handle?
> >
> > Why?
> > Only the task which is enabling quotas needs to know about it.
>
> But it's the btrfs_qgroup_inherit() using the trans handler to avoid
> dead lock.
>
> What makes sure btrfs_qgroup_inherit() get the exactly same trans
> handler allocated here?

If it's the other task (the one creating a snapshot) that starts the
transaction commit,
it will have to wait for the task enabling quotas to release the
transaction - once that task
also calls commit_transaction(), it will skip doing the commit itself
and wait for the snapshot
one to finish the commit, while holding the qgroup mutex (this part I
missed before).
So yes we'll have to use a bit in the transaction itself instead.

>
> >
> >>
> >> Isn't it possible to have different trans handle pointed to the same
> >> transaction?
> >
> > Yes.
> >
> >>
> >> And I'm not really sure about the naming "enabling_quotas".
> >> What about "quota_ioctl_mutex_hold"? (Well, this also sounds awful)
> >
> > Too long.
>
> Anyway, current naming doesn't really show why we could skip mutex
> locking. Just hope to get some name better.

No name will ever show you that.
You'll always have to see where  and how it's used, unless you want a
name like "dont_lock_mutex_because_we_locked_it_at_btrfs...".

>
> Thanks,
> Qu
>
> >
> >
> >>
> >> Thanks,
> >> Qu
> >>
> >>>
> >>>       fs_info->qgroup_ulist =3D ulist_alloc(GFP_KERNEL);
> >>>       if (!fs_info->qgroup_ulist) {
> >>> @@ -2250,7 +2251,11 @@ int btrfs_qgroup_inherit(struct btrfs_trans_ha=
ndle *trans, u64 srcid,
> >>>       u32 level_size =3D 0;
> >>>       u64 nums;
> >>>
> >>> -     mutex_lock(&fs_info->qgroup_ioctl_lock);
> >>> +     if (trans->enabling_quotas)
> >>> +             lockdep_assert_held(&fs_info->qgroup_ioctl_lock);
> >>> +     else
> >>> +             mutex_lock(&fs_info->qgroup_ioctl_lock);
> >>> +
> >>>       if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
> >>>               goto out;
> >>>
> >>> @@ -2413,7 +2418,8 @@ int btrfs_qgroup_inherit(struct btrfs_trans_han=
dle *trans, u64 srcid,
> >>>  unlock:
> >>>       spin_unlock(&fs_info->qgroup_lock);
> >>>  out:
> >>> -     mutex_unlock(&fs_info->qgroup_ioctl_lock);
> >>> +     if (!trans->enabling_quotas)
> >>> +             mutex_unlock(&fs_info->qgroup_ioctl_lock);
> >>>       return ret;
> >>>  }
> >>>
> >>> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> >>> index 703d5116a2fc..a5553a1dee30 100644
> >>> --- a/fs/btrfs/transaction.h
> >>> +++ b/fs/btrfs/transaction.h
> >>> @@ -122,6 +122,7 @@ struct btrfs_trans_handle {
> >>>       bool reloc_reserved;
> >>>       bool sync;
> >>>       bool dirty;
> >>> +     bool enabling_quotas;
> >>>       struct btrfs_root *root;
> >>>       struct btrfs_fs_info *fs_info;
> >>>       struct list_head new_bgs;
> >>>
> >>
>
