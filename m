Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57715C43218
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 14:51:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 539382088F
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 14:51:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qV6ZQWRH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfDYOvz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 10:51:55 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:35726 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbfDYOvz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 10:51:55 -0400
Received: by mail-ua1-f65.google.com with SMTP id g16so79323uad.2
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 07:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=GJ8wUZpuYdD92ckmMFQmS2Fg+qAoW+hyS8RkuRln/vI=;
        b=qV6ZQWRHg0WBHAnT6JEfk9mXD4qSakIKoBhAh7nxDCRChYwJ+axiFEIMn8RZZRDtMz
         BlAt5WIi/S6hi8f4TUafaiF2EU5BVlMvNYf3E+0F5rCDu/0Ec3pIRFBln305MmDLXv9s
         TklpkkyIIMh+ecF1IWI5LNS4hKjPtOvKXHBJ3nSa/g/7JIfEuK5gbi5ANTspHbIsBceH
         t2xny6QKikxbH12iZBK6J/33OED43/EcXJ92hikxb4TlsDEOzYfZM3FadCsyfsXOjmED
         U4J0tTYz4eLsBiZ3S6S0V8HD+S/LkTxtuJ1F68ZYZsv20W0tmW+lLPjQ2FLkWiw6kltn
         2ckg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=GJ8wUZpuYdD92ckmMFQmS2Fg+qAoW+hyS8RkuRln/vI=;
        b=i0gh1D7DOXpHb3VD7HHKpHSjdSsckMi8G4X9JqPeqzhb53nRTL6fJY9FUggb6YRbei
         +17FQMe0NBr05Pq9HWaj0Mu/gTpK0/LW/zPUny5GoPXjwxJqWYnyf2Xv0xsO/9zMbiDF
         8jcRGmV/eKg9Q8Y7aUmxrc8Bctkm6z494JJMF6kdL6LSCDGN64/3KvbJZDVmLlWtAwm3
         8/DeNSEbK/7MlJx8HVgQ9X4xbTZ0gDaJbRCqa1XwANsiPm0u1fqNkOrjv7LjnIjrGUxA
         Ltv/3qu/ZAtW1cAKBmA/yKp92OwBivbmiyvxndcwhl405+wtluu2/x4ZU8PL0I5Qmbkp
         EX/w==
X-Gm-Message-State: APjAAAV7zfsHw4Dx3EoVQzHoNbR2i1LTaXEbQ41dN2kLO77GzTGOs3J2
        xhVKqXKpRmP7x48r9APBiySHm55So35wvlX8SMBssQ==
X-Google-Smtp-Source: APXvYqwuTHGbVxxrFpu8mWD3pO8T0y3LQrYbbKdn6qSTWfFUJxXzIDxgX1GBOZujzbmZR/kFNWNxZxtNSz0xdG7DZME=
X-Received: by 2002:ab0:156b:: with SMTP id p40mr19520578uae.83.1556203913906;
 Thu, 25 Apr 2019 07:51:53 -0700 (PDT)
MIME-Version: 1.0
References: <1533522630-21758-1-git-send-email-robbieko@synology.com>
 <afb5d89f-e1f9-351e-c789-ac291649d17b@gmx.com> <06b5b693-8017-7ec0-b17a-c723291f00c7@suse.com>
 <950b2924-9edd-d9d7-ace0-bc3e2ab07a6a@gmx.com>
In-Reply-To: <950b2924-9edd-d9d7-ace0-bc3e2ab07a6a@gmx.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Thu, 25 Apr 2019 15:51:42 +0100
Message-ID: <CAL3q7H6-9mxYyzi8Y0N8Vvgf4qRgrqURqHASE_4Du-jLmywuBQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix unexpected failure of nocow buffered writes
 after snapshotting when low on space
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Nikolay Borisov <nborisov@suse.com>,
        robbieko <robbieko@synology.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 25, 2019 at 2:06 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2019/4/25 =E4=B8=8B=E5=8D=885:37, Nikolay Borisov wrote:
> >
> >
> > On 25.04.19 =D0=B3. 12:29 =D1=87., Qu Wenruo wrote:
> >>
> >>
> >> On 2018/8/6 =E4=B8=8A=E5=8D=8810:30, robbieko wrote:
> >>> From: Robbie Ko <robbieko@synology.com>
> >>>
> >>> Commit e9894fd3e3b3 ("Btrfs: fix snapshot vs nocow writting")
> >>> forced nocow writes to fallback to COW, during writeback,
> >>> when a snapshot is created. This resulted in writes made before
> >>> creating the snapshot to unexpectedly fail with ENOSPC during
> >>> writeback when success (0) was returned to user space through
> >>> the write system call.
> >>>
> >>> The steps leading to this problem are:
> >>>
> >>> 1. When it's not possible to allocate data space for a write,
> >>> the buffered write path checks if a NOCOW write is possible.
> >>> If it is, it will not reserve space and success (0) is returned
> >>> to user space.
> >>>
> >>> 2. Then when a snapshot is created, the root's will_be_snapshotted
> >>> atomic is incremented and writeback is triggered for all inode's
> >>> that belong to the root being snapshotted. Incrementing that atomic
> >>> forces all previous writes to fallback to COW during writeback
> >>> (running delalloc).
> >>>
> >>> 3. This results in the writeback for the inodes to fail and therefore
> >>> setting the ENOSPC error in their mappings, so that a subsequent fsyn=
c
> >>> on them will report the error to user space. So it's not a completely
> >>> silent data loss (since fsync will report ENOSPC) but it's a very
> >>> unexpected and undesirable behaviour, because if a clean
> >>> shutdown/unmount of the filesystem happens without previous calls to
> >>> fsync, it is expected to have the data present in the files after
> >>> mounting the filesystem again.
> >>>
> >>> So fix this by adding a new atomic named snapshot_force_cow to the
> >>> root structure which prevents this behaviour and works the following =
way:
> >>
> >> This fix is a little out of dated now.
> >>
> >> Since 609e804d771f ("Btrfs: fix file corruption after snapshotting due
> >> to mix of buffered/DIO writes") we will write back all dirty
> >> inodes/pages back to disk before snapshot.
> >>
> >> This makes sure that all dirty inodes/pages before a transaction will
> >> reach disk before snapshot  subvolume is created.
> >>
> >> Thus the whole will_be_snapshotted member no long makes sense, and in
> >> fact it could cause more problem if we're going back to always check
> >> NODATACOW at buffered write time.
> >>
> >> Can we just revert this patch and the will_be_snapshotted member ?
> >
> > I'm very much in favor of removing the whole will_be_snapshotted
> > mechanism. In fact I have a series which replaces it with a rwsem
> > essentially:
> >
> > 1. Serializing snapshots (acquiring write-side of the semaphore)
>
> With the new btrfs_start_delalloc_snapshot() in
> btrfs_commit_transaction(), do we really need to do anything special now?
>
> Snapshot creation will only happen in btrfs_commit_transaction(), as
> long as all dirty inodes/pages are written before pending snapshots,
> we're completely fine.
>
> Or did I miss something?

You missed the whole point of both patches.

The one I authored recently, is about ensuring we see ordered update
of an inode's disk_i_size / i_size.
That flushes delalloc a second time, during the transaction commit, to
ensure an ordered update of disk_i_size in case direct IO writes
happened during snapshotting.
btrfs/078 could detect this when not running with the no-holes feature
enabled, since fsck will report missing file extent items.

Robbie's patch is about making sure that buffered nodatacow writes
that happened before snapshotting (and success was returned to user
space), will not fail silently during the writeback triggered by
snapshot creation.
There's even a test case for this, btrfs/170, which I submitted.

So no, you can't simply revert Robbie's change, that will re-introduce
the bug it fixed.

Thanks.

>
> Thanks,
> Qu
>
> >
> > 2. Nocow writers simply acquire the readsize of the semaphore.
> >
> > the will_be_snapshoted thing is very convoluted relying on a percpu
> > counter/waitqueue  to exclude snapshots from pending nocow writers. OTO=
H
> > it depends on atomic_t and an implicit wait queue thanks to wait_var
> > infrastructure to exclude nocow writers from pending snapshots. Filipe
> > had some concerns regarding performance but if the patch you mentioned
> > fixed all issues I'm all in favor of removing the code!
> >
> >
> >>
> >> Thanks,
> >> Qu
> >>
> >>>
> >>> 1. It is incremented when we start to create a snapshot after
> >>> triggering writeback and before waiting for writeback to finish.
> >>>
> >>> 2. This new atomic is now what is used by writeback (running delalloc=
)
> >>> to decide whether we need to fallback to COW or not. Because we
> >>> incremented this new atomic after triggering writeback in the snapsho=
t
> >>> creation ioctl, we ensure that all buffered writes that happened
> >>> before snapshot creation will succeed and not fallback to COW
> >>> (which would make them fail with ENOSPC).
> >>>
> >>> 3. The existing atomic, will_be_snapshotted, is kept because it is
> >>> used to force new buffered writes, that start after we started
> >>> snapshotting, to reserve data space even when NOCOW is possible.
> >>> This makes these writes fail early with ENOSPC when there's no
> >>> available space to allocate, preventing the unexpected behaviour
> >>> of writeback later failing with ENOSPC due to a fallback to COW mode.
> >>>
> >>> Fixes: e9894fd3e3b3 ("Btrfs: fix snapshot vs nocow writting")
> >>> Signed-off-by: Robbie Ko <robbieko@synology.com>
> >>> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> >>> ---
> >>>  fs/btrfs/ctree.h   |  1 +
> >>>  fs/btrfs/disk-io.c |  1 +
> >>>  fs/btrfs/inode.c   | 26 +++++---------------------
> >>>  fs/btrfs/ioctl.c   | 16 ++++++++++++++++
> >>>  4 files changed, 23 insertions(+), 21 deletions(-)
> >>>
> >>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> >>> index 118346a..663ce05 100644
> >>> --- a/fs/btrfs/ctree.h
> >>> +++ b/fs/btrfs/ctree.h
> >>> @@ -1277,6 +1277,7 @@ struct btrfs_root {
> >>>     int send_in_progress;
> >>>     struct btrfs_subvolume_writers *subv_writers;
> >>>     atomic_t will_be_snapshotted;
> >>> +   atomic_t snapshot_force_cow;
> >>>
> >>>     /* For qgroup metadata reserved space */
> >>>     spinlock_t qgroup_meta_rsv_lock;
> >>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> >>> index 205092d..5573916 100644
> >>> --- a/fs/btrfs/disk-io.c
> >>> +++ b/fs/btrfs/disk-io.c
> >>> @@ -1216,6 +1216,7 @@ static void __setup_root(struct btrfs_root *roo=
t, struct btrfs_fs_info *fs_info,
> >>>     atomic_set(&root->log_batch, 0);
> >>>     refcount_set(&root->refs, 1);
> >>>     atomic_set(&root->will_be_snapshotted, 0);
> >>> +   atomic_set(&root->snapshot_force_cow, 0);
> >>>     root->log_transid =3D 0;
> >>>     root->log_transid_committed =3D -1;
> >>>     root->last_log_commit =3D 0;
> >>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> >>> index eba61bc..263b852 100644
> >>> --- a/fs/btrfs/inode.c
> >>> +++ b/fs/btrfs/inode.c
> >>> @@ -1275,7 +1275,7 @@ static noinline int run_delalloc_nocow(struct i=
node *inode,
> >>>     u64 disk_num_bytes;
> >>>     u64 ram_bytes;
> >>>     int extent_type;
> >>> -   int ret, err;
> >>> +   int ret;
> >>>     int type;
> >>>     int nocow;
> >>>     int check_prev =3D 1;
> >>> @@ -1407,11 +1407,9 @@ static noinline int run_delalloc_nocow(struct =
inode *inode,
> >>>                      * if there are pending snapshots for this root,
> >>>                      * we fall into common COW way.
> >>>                      */
> >>> -                   if (!nolock) {
> >>> -                           err =3D btrfs_start_write_no_snapshotting=
(root);
> >>> -                           if (!err)
> >>> -                                   goto out_check;
> >>> -                   }
> >>> +                   if (!nolock &&
> >>> +                           unlikely(atomic_read(&root->snapshot_forc=
e_cow)))
> >>> +                           goto out_check;
> >>>                     /*
> >>>                      * force cow if csum exists in the range.
> >>>                      * this ensure that csum for a given extent are
> >>> @@ -1420,9 +1418,6 @@ static noinline int run_delalloc_nocow(struct i=
node *inode,
> >>>                     ret =3D csum_exist_in_range(fs_info, disk_bytenr,
> >>>                                               num_bytes);
> >>>                     if (ret) {
> >>> -                           if (!nolock)
> >>> -                                   btrfs_end_write_no_snapshotting(r=
oot);
> >>> -
> >>>                             /*
> >>>                              * ret could be -EIO if the above fails t=
o read
> >>>                              * metadata.
> >>> @@ -1435,11 +1430,8 @@ static noinline int run_delalloc_nocow(struct =
inode *inode,
> >>>                             WARN_ON_ONCE(nolock);
> >>>                             goto out_check;
> >>>                     }
> >>> -                   if (!btrfs_inc_nocow_writers(fs_info, disk_bytenr=
)) {
> >>> -                           if (!nolock)
> >>> -                                   btrfs_end_write_no_snapshotting(r=
oot);
> >>> +                   if (!btrfs_inc_nocow_writers(fs_info, disk_bytenr=
))
> >>>                             goto out_check;
> >>> -                   }
> >>>                     nocow =3D 1;
> >>>             } else if (extent_type =3D=3D BTRFS_FILE_EXTENT_INLINE) {
> >>>                     extent_end =3D found_key.offset +
> >>> @@ -1453,8 +1445,6 @@ static noinline int run_delalloc_nocow(struct i=
node *inode,
> >>>  out_check:
> >>>             if (extent_end <=3D start) {
> >>>                     path->slots[0]++;
> >>> -                   if (!nolock && nocow)
> >>> -                           btrfs_end_write_no_snapshotting(root);
> >>>                     if (nocow)
> >>>                             btrfs_dec_nocow_writers(fs_info, disk_byt=
enr);
> >>>                     goto next_slot;
> >>> @@ -1476,8 +1466,6 @@ static noinline int run_delalloc_nocow(struct i=
node *inode,
> >>>                                          end, page_started, nr_writte=
n, 1,
> >>>                                          NULL);
> >>>                     if (ret) {
> >>> -                           if (!nolock && nocow)
> >>> -                                   btrfs_end_write_no_snapshotting(r=
oot);
> >>>                             if (nocow)
> >>>                                     btrfs_dec_nocow_writers(fs_info,
> >>>                                                             disk_byte=
nr);
> >>> @@ -1497,8 +1485,6 @@ static noinline int run_delalloc_nocow(struct i=
node *inode,
> >>>                                       ram_bytes, BTRFS_COMPRESS_NONE,
> >>>                                       BTRFS_ORDERED_PREALLOC);
> >>>                     if (IS_ERR(em)) {
> >>> -                           if (!nolock && nocow)
> >>> -                                   btrfs_end_write_no_snapshotting(r=
oot);
> >>>                             if (nocow)
> >>>                                     btrfs_dec_nocow_writers(fs_info,
> >>>                                                             disk_byte=
nr);
> >>> @@ -1537,8 +1523,6 @@ static noinline int run_delalloc_nocow(struct i=
node *inode,
> >>>                                          EXTENT_CLEAR_DATA_RESV,
> >>>                                          PAGE_UNLOCK | PAGE_SET_PRIVA=
TE2);
> >>>
> >>> -           if (!nolock && nocow)
> >>> -                   btrfs_end_write_no_snapshotting(root);
> >>>             cur_offset =3D extent_end;
> >>>
> >>>             /*
> >>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> >>> index b077544..331b495 100644
> >>> --- a/fs/btrfs/ioctl.c
> >>> +++ b/fs/btrfs/ioctl.c
> >>> @@ -761,6 +761,7 @@ static int create_snapshot(struct btrfs_root *roo=
t, struct inode *dir,
> >>>     struct btrfs_pending_snapshot *pending_snapshot;
> >>>     struct btrfs_trans_handle *trans;
> >>>     int ret;
> >>> +   bool snapshot_force_cow =3D false;
> >>>
> >>>     if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state))
> >>>             return -EINVAL;
> >>> @@ -777,6 +778,11 @@ static int create_snapshot(struct btrfs_root *ro=
ot, struct inode *dir,
> >>>             goto free_pending;
> >>>     }
> >>>
> >>> +   /*
> >>> +    * Force new buffered writes to reserve space even when NOCOW is
> >>> +    * possible. This is to avoid later writeback (running dealloc)
> >>> +    * to fallback to COW mode and unexpectedly fail with ENOSPC.
> >>> +    */
> >>>     atomic_inc(&root->will_be_snapshotted);
> >>>     smp_mb__after_atomic();
> >>>     /* wait for no snapshot writes */
> >>> @@ -787,6 +793,14 @@ static int create_snapshot(struct btrfs_root *ro=
ot, struct inode *dir,
> >>>     if (ret)
> >>>             goto dec_and_free;
> >>>
> >>> +   /*
> >>> +    * All previous writes have started writeback in NOCOW mode, so n=
ow
> >>> +    * we force future writes to fallback to COW mode during snapshot
> >>> +    * creation.
> >>> +    */
> >>> +   atomic_inc(&root->snapshot_force_cow);
> >>> +   snapshot_force_cow =3D true;
> >>> +
> >>>     btrfs_wait_ordered_extents(root, U64_MAX, 0, (u64)-1);
> >>>
> >>>     btrfs_init_block_rsv(&pending_snapshot->block_rsv,
> >>> @@ -851,6 +865,8 @@ static int create_snapshot(struct btrfs_root *roo=
t, struct inode *dir,
> >>>  fail:
> >>>     btrfs_subvolume_release_metadata(fs_info, &pending_snapshot->bloc=
k_rsv);
> >>>  dec_and_free:
> >>> +   if (snapshot_force_cow)
> >>> +           atomic_dec(&root->snapshot_force_cow);
> >>>     if (atomic_dec_and_test(&root->will_be_snapshotted))
> >>>             wake_up_var(&root->will_be_snapshotted);
> >>>  free_pending:
> >>>
> >>



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
