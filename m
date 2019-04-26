Return-Path: <SRS0=BNt3=S4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 244E6C43219
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 14:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAD772077B
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 14:52:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d/WOx4DC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbfDZOwM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Apr 2019 10:52:12 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:44879 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbfDZOwM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Apr 2019 10:52:12 -0400
Received: by mail-ua1-f66.google.com with SMTP id p13so1261653uaa.11
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Apr 2019 07:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=WxLjV27/ZINsNInvMwb/GBadOfoHGE+3Z5pXxAOBgpw=;
        b=d/WOx4DChmRsEz3wa2J0iOobtAWiY3mtCB3cc57strc1NlKSE60AaNW1CW+Hb4sulf
         mxmt+QZIJDh1tgT0rSe8rpJke5L4M+9FQyRTNIeGX9rThLfJgVPFMgntkuj26sXEzMH/
         lZP/inbU8kZX9IbbA5clxxwPlohKabDog9Rkw+9dY9Qna/iAbEXBcaFECHybng59CwBd
         S1VRUNv0/uTkyKijw2j72DM6mliEUIEk5dJjxsaLc+FY4TRcX+zTtXDrrjjgXxry38GU
         MeAykmVc20de0915EJszOuiAGyOfRDcMgeLHHjREp7amzQ2+BqT9x9xayUtU+FFdY5D7
         o8Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=WxLjV27/ZINsNInvMwb/GBadOfoHGE+3Z5pXxAOBgpw=;
        b=m/88dTRf9gB9ag81SBaxX/GpraRMNCx/dePPGhTeaPwT4dKYQQ/1rxnmk24mJ/BTV1
         Mq0PN1jNPI6Tyau56n6x8f+isInIRYE1uFY/eBOiEKx/7dy8qVv1ei1jO9Q49j0aBANM
         6bv1AFJrAbdJYk9OVUdB5hH9kfjONenHfbKJZ+KYEW+6jrD/NVP+9Uce3KGWGbP4S2IE
         FVFZ/MDFuVNF2vu5WpiXOOE4vN+ic83+oyErjGNuCqn67pMOZeCWBc4KTfkE84d+svvL
         b38IFO0Mdwbz3eQ9bi8sVcJP3AoaYrxiMqjIFtnr92guf86bb0mzVGLVHtBm+ME7sjra
         p8+Q==
X-Gm-Message-State: APjAAAXr+S5c4goVHTovPIkC58qihGCfy8i0zQGEaI8EWfAqfsFeEFzp
        1VSXpuT+YsP6dRKMM4DZj3mKndipdNsymTlTR0DhJfmv
X-Google-Smtp-Source: APXvYqx06orUitG65Rf0gAYrXx2ih+H6ukiLw2c/0HrYbeQWhJG1mnShMUEdzo/Go2Tpbnus0QQIeMmPb72uFHBpkpg=
X-Received: by 2002:ab0:1e2:: with SMTP id 89mr1988912ual.0.1556290331097;
 Fri, 26 Apr 2019 07:52:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190426120140.5956-1-wqu@suse.com>
In-Reply-To: <20190426120140.5956-1-wqu@suse.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 26 Apr 2019 15:52:00 +0100
Message-ID: <CAL3q7H50jaOGjRSqpn1QUo_=0E_h7VJxAGRyt6YiYFJ13SBNsg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Make the critical section of will_be_snapshotted
 and snapshot_force_cow smaller
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 26, 2019 at 1:02 PM Qu Wenruo <wqu@suse.com> wrote:
>
> Btrfs uses btrfs_root::will_be_snapshotted and
> btrfs_root::snapshot_force_cow to control data space reservation and
> delalloc for NODATACOW/COW switch.
>
> To be more specific:
>
>                    /------------------------ inc(will_be_snapshotted)
>                    |                     /-- inc(snapshot_force_cow)
> -------------------|---------------------|---------------
> reserve: NOCOW     | reserve: COW        | reserve: COW
> delalloc: NOCOW    | delalloc: NOCOW     | delalloc: COW
>
> They combined together ensure btrfs data NOCOW cooperate with
> snapshot creation, and no data reservation underflow.
> - No data written into shared extents
>   This is ensured by snapshot_force_cow, as with it set, all
>   NOCOW delalloc range will be forced back to COW.
>
> - No data reserved space underflow
>   This is ensured by will_be_snapshot and snapshot_force_cow sequence.
>
> Normally, we use the following call sequence:
>   atomic_inc(&root->will_be_snapshotted)
>   smp_mb__after_atomic();
>   wait_event(root->subv_writers->wait,
>              percpu_counter_sum(&root->subv_writers->coutner) =3D=3D 0;
>   btrfs_start_delalloc_snapshot(root);
>   atomic_inc(&root->snapshot_force_cow);
>
> And such calls happens in create_snapshot().
>
> However since commit 09e804d771f ("Btrfs: fix file corruption after
> snapshotting due to mix of buffered/DIO writes"), we also call
> btrfs_start_delalloc_snapstho() in btrfs_start_delalloc_flush().
>
> This means we can make the critical section smaller, instead of doing

Which critical section? You mention a critical section but don't say
what delimits it, what it consists of.
What gains do you expect by reducing such critical section and in
which use cases? Always? Only for some cases? Which?

> above call sequence in the ioctl context, we reuse the
> btrfs_start_delalloc_snapshot() in btrfs_start_delalloc_flush() in the
> transaction commit context.
>
> So old call critical section will be changed from:
>
> /-------- snapshot ioctl
> |    /- inc will_be/force_cow and call start_delalloc_snapshot()
> |    |     /- btrfs_start_transaction()
> |    |     |                        /- btrfs_commit_transaction()
> |    |     |                        |  /- dec will_be/force_cow
> |----|/////|///////////////////////////|-----| <- ioctl return
>
> To new one:
>
> /-------- snapshot ioctl
> |    /- inc will_be/force_cow and call start_delalloc_snapshot()
> |    |     /- btrfs_start_transaction()

I don't understand these graphs.
That gives the idea the atomics are incremented before
start_transaction(), but the code increments them after that, when we
are in a transaction commit at  btrfs_start_delalloc_flush().


> |    |     |                        /- btrfs_commit_transaction()
> |    |     |                        |  /- dec will_be/force_cow
> |----|-----|--|//////////////////|--|--|-----| <- ioctl return
>               |                  |
>               |                  \- create_pending_snapshot() return
>               \- btrfs_start_delalloc_flush()
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/ioctl.c       | 31 +-------------------------
>  fs/btrfs/transaction.c | 50 ++++++++++++++++++++++++++++++++++++------
>  2 files changed, 44 insertions(+), 37 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 8c9a908d3acc..d41e8b6aa36f 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -766,7 +766,6 @@ static int create_snapshot(struct btrfs_root *root, s=
truct inode *dir,
>         struct btrfs_pending_snapshot *pending_snapshot;
>         struct btrfs_trans_handle *trans;
>         int ret;
> -       bool snapshot_force_cow =3D false;
>
>         if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state))
>                 return -EINVAL;
> @@ -789,29 +788,6 @@ static int create_snapshot(struct btrfs_root *root, =
struct inode *dir,
>                 goto free_pending;
>         }
>
> -       /*
> -        * Force new buffered writes to reserve space even when NOCOW is
> -        * possible. This is to avoid later writeback (running dealloc) t=
o
> -        * fallback to COW mode and unexpectedly fail with ENOSPC.
> -        */
> -       atomic_inc(&root->will_be_snapshotted);
> -       smp_mb__after_atomic();
> -       /* wait for no snapshot writes */
> -       wait_event(root->subv_writers->wait,
> -                  percpu_counter_sum(&root->subv_writers->counter) =3D=
=3D 0);
> -
> -       ret =3D btrfs_start_delalloc_snapshot(root);
> -       if (ret)
> -               goto dec_and_free;
> -
> -       /*
> -        * All previous writes have started writeback in NOCOW mode, so n=
ow
> -        * we force future writes to fallback to COW mode during snapshot
> -        * creation.
> -        */
> -       atomic_inc(&root->snapshot_force_cow);
> -       snapshot_force_cow =3D true;
> -
>         btrfs_wait_ordered_extents(root, U64_MAX, 0, (u64)-1);

Do you understand why we had two calls to flush and wait for delalloc
(one outside a transaction and the other inside)?

With your change we do that only inside the critical section of a
transaction commit, when the transaction state is
TRANS_STATE_COMMIT_START.

That means the transaction critical section is now much longer if a
lot of delalloc exists - it means that virtually all write filesystem
operations, for any subvolume,
that do a btrfs_start_transaction() (create file, mkdir, mknod,
truncate, link, unlink, rename, symlink, fallocate, fsync, inserting
holes when starting a write - btrfs_cont_expand, etc, etc, etc), will
now block while
all delalloc is being flushed and we are waiting for it to complete
inside the transaction commit.

Before this patch, we flush and wait for dealloc before starting a
transaction, so that we don't block other fs operations for too long.
The second flush, inside the transaction commit, ends up doing little
or no work, since the vast majority of dealloc was already flushed.

Thanks.

>
>         btrfs_init_block_rsv(&pending_snapshot->block_rsv,
> @@ -828,7 +804,7 @@ static int create_snapshot(struct btrfs_root *root, s=
truct inode *dir,
>                                         &pending_snapshot->block_rsv, 8,
>                                         false);
>         if (ret)
> -               goto dec_and_free;
> +               goto free_pending;
>
>         pending_snapshot->dentry =3D dentry;
>         pending_snapshot->root =3D root;
> @@ -875,11 +851,6 @@ static int create_snapshot(struct btrfs_root *root, =
struct inode *dir,
>         ret =3D 0;
>  fail:
>         btrfs_subvolume_release_metadata(fs_info, &pending_snapshot->bloc=
k_rsv);
> -dec_and_free:
> -       if (snapshot_force_cow)
> -               atomic_dec(&root->snapshot_force_cow);
> -       if (atomic_dec_and_test(&root->will_be_snapshotted))
> -               wake_up_var(&root->will_be_snapshotted);
>  free_pending:
>         kfree(pending_snapshot->root_item);
>         btrfs_free_path(pending_snapshot->path);
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 3f6811cdf803..67fb520fed9b 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1605,6 +1605,9 @@ static noinline int create_pending_snapshot(struct =
btrfs_trans_handle *trans,
>         }
>
>  fail:
> +       if (atomic_dec_and_test(&root->will_be_snapshotted))
> +               wake_up_var(&root->will_be_snapshotted);
> +       atomic_dec(&root->snapshot_force_cow);
>         pending->error =3D ret;
>  dir_item_existed:
>         trans->block_rsv =3D rsv;
> @@ -1852,6 +1855,10 @@ static void btrfs_cleanup_pending_block_groups(str=
uct btrfs_trans_handle *trans)
>  static inline int btrfs_start_delalloc_flush(struct btrfs_trans_handle *=
trans)
>  {
>         struct btrfs_fs_info *fs_info =3D trans->fs_info;
> +       struct btrfs_pending_snapshot *last_fail;
> +       struct btrfs_pending_snapshot *pending;
> +       struct list_head *head =3D &trans->transaction->pending_snapshots=
;
> +       int ret =3D 0;
>
>         /*
>          * We use writeback_inodes_sb here because if we used
> @@ -1865,8 +1872,6 @@ static inline int btrfs_start_delalloc_flush(struct=
 btrfs_trans_handle *trans)
>         if (btrfs_test_opt(fs_info, FLUSHONCOMMIT)) {
>                 writeback_inodes_sb(fs_info->sb, WB_REASON_SYNC);
>         } else {
> -               struct btrfs_pending_snapshot *pending;
> -               struct list_head *head =3D &trans->transaction->pending_s=
napshots;
>
>                 /*
>                  * Flush dellaloc for any root that is going to be snapsh=
otted.
> @@ -1876,14 +1881,45 @@ static inline int btrfs_start_delalloc_flush(stru=
ct btrfs_trans_handle *trans)
>                  * the inode's size on disk.
>                  */
>                 list_for_each_entry(pending, head, list) {
> -                       int ret;
> -
> -                       ret =3D btrfs_start_delalloc_snapshot(pending->ro=
ot);
> -                       if (ret)
> -                               return ret;
> +                       struct btrfs_root *root =3D pending->root;
> +
> +                       /*
> +                        * Force new buffered writes to reserve space eve=
n
> +                        * when NOCOW is possible. This is to avoid later
> +                        * writeback (running dealloc) to fallback to COW=
 mode
> +                        * and unexpectedly fail with ENOSPC.
> +                        */
> +                       atomic_inc(&root->will_be_snapshotted);
> +                       smp_mb__after_atomic();
> +                       /* wait for no snapshot writes */
> +                       wait_event(root->subv_writers->wait,
> +                                  percpu_counter_sum(&root->subv_writers=
->counter) =3D=3D 0);
> +                       ret =3D btrfs_start_delalloc_snapshot(root);
> +                       if (ret) {
> +                               atomic_dec(&root->will_be_snapshotted);
> +                               last_fail =3D pending;
> +                               goto cleanup;
> +                       }
> +                       /*
> +                        * All previous writes have started writeback in =
NOCOW
> +                        * mode, so now we force future writes to fallbac=
k
> +                        * to COW mode during snapshot creation.
> +                        */
> +                       atomic_inc(&root->snapshot_force_cow);
>                 }
>         }
>         return 0;
> +cleanup:
> +       list_for_each_entry(pending, head, list) {
> +               struct btrfs_root *root =3D pending->root;
> +
> +               if (pending =3D=3D last_fail)
> +                       break;
> +               if (atomic_dec_and_test(&root->will_be_snapshotted))
> +                       wake_up_var(&root->will_be_snapshotted);
> +               atomic_dec(&root->snapshot_force_cow);
> +       }
> +       return ret;
>  }
>
>  static inline void btrfs_wait_delalloc_flush(struct btrfs_trans_handle *=
trans)
> --
> 2.21.0
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
