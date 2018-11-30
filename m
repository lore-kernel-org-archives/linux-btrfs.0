Return-Path: <SRS0=Nx1q=OJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C15CC04EB8
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 21:15:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0A8920660
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 21:15:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mLCKOh37"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0A8920660
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbeLAI0Q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 1 Dec 2018 03:26:16 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:36129 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725749AbeLAI0Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Dec 2018 03:26:16 -0500
Received: by mail-vs1-f66.google.com with SMTP id v205so4197398vsc.3;
        Fri, 30 Nov 2018 13:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=ppItycxnuT3RzcuCdEG+I81f2gyaBB4P/Hc1Qp/iKPk=;
        b=mLCKOh37qVL9dz5Nree4NnjhbMHCKiHujqvClQSPvs2AQC7KVjuYLqePjU1NnA+mUJ
         n5Fd2ijIp7rnzWp+PrcKGD7u9dN+98uWkCJ3oxp+NIpsbrCC23UFXhTk+Rfd+p+zfn3s
         SwOS+Slga7AQGTZqC+hx/sIXme9aUl/PkClEJ0OpKT9NIm2UIrxdMrdW9v+KdKa1xcqj
         rqUZtKB3s1izMGudUtrVZfevVpg/2Im/cp6cdF5vp2v16O9Smp1IXHtcQI976jA85SdJ
         C4Q9y5H7GiQaZpvAjPYLKHlSok9UkV3l+GzdbH1u+exxoULIdXMdRpeu2pEb982WX9TM
         NjEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=ppItycxnuT3RzcuCdEG+I81f2gyaBB4P/Hc1Qp/iKPk=;
        b=YXzREhx7W1goBdVXInIeuxy6s/uqsR0QidQJmHNiFrMHKh0OSZKwKS8VXE5QQnFYe+
         qryx33NOCWJdlhMNf5MV3svh6w84u57RhJwrjfhQQI+gHmNQhHlaVVAu7Qy/GoDJllSP
         eASG91SFITEa7Bz8dmHU8a/jwpzDHv+fj5Z5ZhV1tRXzzRyKWuTFAGFGvuIhn8NNPgjU
         x3+2OBYPmovdiwb5pkWUD2CjGT3rnDvCrj3PjILsplpZm408x8HRP3u7ScKgsDBMzqoB
         TbsBQ3FDx0n92hzWO/X797U5wVm9FXTuB1ASM3gJVKjmPu1PpLKyoxuOQM6qfmjSBsHY
         otfg==
X-Gm-Message-State: AA+aEWawnLtlygPwSJv3wGU03oe/0rcHNWgK8NK4nTHKEqaVVhnXDOOR
        NTV4GGkCtISo7zF4hcj/Q1H2/0EUD7zm0lZPH4E=
X-Google-Smtp-Source: AFSGD/Wazh3rV9Jz9P8uUZODv8bCdGbl4EdtiC7mMwps20UWq6GEBPsyQUiweyFOmlOmQPsHucvCB3FmxxuvxlVQLm4=
X-Received: by 2002:a67:4c51:: with SMTP id z78mr2713778vsa.99.1543612538840;
 Fri, 30 Nov 2018 13:15:38 -0800 (PST)
MIME-Version: 1.0
References: <20181130165214.17883-1-josef@toxicpanda.com> <20181130165214.17883-3-josef@toxicpanda.com>
 <CAL3q7H7N8ozNzhkTmt=s30SLaH-TptHZNv3b_Wv_Tif_c_nJVg@mail.gmail.com>
In-Reply-To: <CAL3q7H7N8ozNzhkTmt=s30SLaH-TptHZNv3b_Wv_Tif_c_nJVg@mail.gmail.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 30 Nov 2018 21:15:27 +0000
Message-ID: <CAL3q7H6jrtTC7+m8=_DG_GcmajO-bc_1cVhzMu3vthCRXutmQw@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs: run delayed items before dropping the snapshot
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 30, 2018 at 5:12 PM Filipe Manana <fdmanana@gmail.com> wrote:
>
> On Fri, Nov 30, 2018 at 4:53 PM Josef Bacik <josef@toxicpanda.com> wrote:
> >
> > From: Josef Bacik <jbacik@fb.com>
> >
> > With my delayed refs patches in place we started seeing a large amount
> > of aborts in __btrfs_free_extent
> >
> > BTRFS error (device sdb1): unable to find ref byte nr 91947008 parent 0=
 root 35964  owner 1 offset 0
> > Call Trace:
> >  ? btrfs_merge_delayed_refs+0xaf/0x340
> >  __btrfs_run_delayed_refs+0x6ea/0xfc0
> >  ? btrfs_set_path_blocking+0x31/0x60
> >  btrfs_run_delayed_refs+0xeb/0x180
> >  btrfs_commit_transaction+0x179/0x7f0
> >  ? btrfs_check_space_for_delayed_refs+0x30/0x50
> >  ? should_end_transaction.isra.19+0xe/0x40
> >  btrfs_drop_snapshot+0x41c/0x7c0
> >  btrfs_clean_one_deleted_snapshot+0xb5/0xd0
> >  cleaner_kthread+0xf6/0x120
> >  kthread+0xf8/0x130
> >  ? btree_invalidatepage+0x90/0x90
> >  ? kthread_bind+0x10/0x10
> >  ret_from_fork+0x35/0x40
> >
> > This was because btrfs_drop_snapshot depends on the root not being modi=
fied
> > while it's dropping the snapshot.  It will unlock the root node (and re=
ally
> > every node) as it walks down the tree, only to re-lock it when it needs=
 to do
> > something.  This is a problem because if we modify the tree we could co=
w a block
> > in our path, which free's our reference to that block.  Then once we ge=
t back to
> > that shared block we'll free our reference to it again, and get ENOENT =
when
> > trying to lookup our extent reference to that block in __btrfs_free_ext=
ent.
> >
> > This is ultimately happening because we have delayed items left to be p=
rocessed
> > for our deleted snapshot _after_ all of the inodes are closed for the s=
napshot.
> > We only run the delayed inode item if we're deleting the inode, and eve=
n then we
> > do not run the delayed insertions or delayed removals.  These can be ru=
n at any
> > point after our final inode does it's last iput, which is what triggers=
 the
> > snapshot deletion.  We can end up with the snapshot deletion happening =
and then
> > have the delayed items run on that file system, resulting in the above =
problem.
> >
> > This problem has existed forever, however my patches made it much easie=
r to hit
> > as I wake up the cleaner much more often to deal with delayed iputs, wh=
ich made
> > us more likely to start the snapshot dropping work before the transacti=
on
> > commits, which is when the delayed items would generally be run.  Befor=
e,
> > generally speaking, we would run the delayed items, commit the transact=
ion, and
> > wakeup the cleaner thread to start deleting snapshots, which means we w=
ere less
> > likely to hit this problem.  You could still hit it if you had multiple
> > snapshots to be deleted and ended up with lots of delayed items, but it=
 was
> > definitely harder.
> >
> > Fix for now by simply running all the delayed items before starting to =
drop the
> > snapshot.  We could make this smarter in the future by making the delay=
ed items
> > per-root, and then simply drop any delayed items for roots that we are =
going to
> > delete.  But for now just a quick and easy solution is the safest.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
>
> Great catch!
> I've hit this error from  __btrfs_free_extent() a handful of times
> over the years, but never managed
> to reproduce it on demand or figure out it was related to snapshot deleti=
on.
>
> > ---
> >  fs/btrfs/extent-tree.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index dcb699dd57f3..965702034b22 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -9330,6 +9330,8 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
> >                 goto out_free;
> >         }
> >
> > +       btrfs_run_delayed_items(trans);
> > +

Btw, we should check the return value of this and return it if it's an erro=
r?
We can't do nothing with it in the context of the cleaner thread,
which is why, I suppose, you chose to ignore the value (besides that
the error might have been for some other root).
But this can be used in the context of relocation, where we can return
the error back to userspace.

Thanks.

> >         if (block_rsv)
> >                 trans->block_rsv =3D block_rsv;
> >
> > --
> > 2.14.3
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
