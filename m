Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F79C10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 08:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89D5920874
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 08:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555318310;
	bh=yyxDGFIXq9wCrMEMUOQr1J39lAcXlmZJz++iVQcGniU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=v4lbQHMN4263hE8uoGkv05ZSJezsJcO/34uS+eP0R4mG+xOIEe4YtXwxeubLI4GEM
	 KAi1MmNa/Apoh2XiqPb7gVyHCDHN14N+W47FSSYUYgroyGxpOZHKEauAbWV7T/vN/3
	 MhMdn/YpB43pTQmF7gQhrKKD8UpVgXs6PLH7ofRE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfDOIvt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 04:51:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbfDOIvt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 04:51:49 -0400
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBB0520874
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2019 08:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555318308;
        bh=yyxDGFIXq9wCrMEMUOQr1J39lAcXlmZJz++iVQcGniU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eak9QnSRemq68Ai+9d6a4LCSSLQYW/zp8DRGvDXXJSfaP1NftT+kfovqSiggTogc7
         V/154dym7nyEJPdy8MhzN6HKazvIl2pOE3A2WCvoVwIQ9szoSLREiICG6YEUKnpAJD
         956yOJiTlM0cfABaORhC4sEXLdxwK2fd2IMX2xPU=
Received: by mail-vs1-f49.google.com with SMTP id w13so9005227vsc.4
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2019 01:51:47 -0700 (PDT)
X-Gm-Message-State: APjAAAXk/l6PQzAuJniR2YU0bJUbj2MEcOuTM6X1wgsddI3Mu8fLdqIl
        zyBoBNMCGb01oNWu2jabBl4pA0Vks5AsHHBkHVc=
X-Google-Smtp-Source: APXvYqwpS6hfemrpeZUplZkvDaPxuXtliOFYTlxRRcXcQnK5/0wU9Bjwg9mc4EHOLY/6/ji/NKAUajBO1xG25FEOORw=
X-Received: by 2002:a67:f3c3:: with SMTP id j3mr37506330vsn.206.1555318307115;
 Mon, 15 Apr 2019 01:51:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190415082900.2023-1-fdmanana@kernel.org> <3b22cc0c-7152-8345-e766-d439e9c34d00@gmx.com>
In-Reply-To: <3b22cc0c-7152-8345-e766-d439e9c34d00@gmx.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Mon, 15 Apr 2019 08:51:36 +0000
X-Gmail-Original-Message-ID: <CAL3q7H7mt=o=fMYC7YbhQ3Co_w=ESmOjw37v3G4zfoqKj0m3Lw@mail.gmail.com>
Message-ID: <CAL3q7H7mt=o=fMYC7YbhQ3Co_w=ESmOjw37v3G4zfoqKj0m3Lw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: do not start a transaction during fiemap
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 15, 2019 at 9:45 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2019/4/15 =E4=B8=8B=E5=8D=884:29, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > During fiemap, for regular extents (non inline) we need to check if the=
y
> > are shared and if they are, set the shared bit. Checking if an extent i=
s
> > shared requires checking the delayed references of the currently runnin=
g
> > transaction, since some reference might have not yet hit the extent tre=
e
> > and be only in the in-memory delayed references.
> >
> > However we were using a transaction join for this, which creates a new
> > transaction when there is no transaction currently running. That means
> > that two more potential failures can happen: creating the transaction a=
nd
> > committing it. Further, if no write activity is currently happening in =
the
> > system, and fiemap calls keep being done, we end up creating and
> > committing transactions that do nothing.
> >
> > In some extreme cases this can result in the commit of the transaction
> > created by fiemap to fail with ENOSPC when updating the root item of a
> > subvolume tree because a join does not reserve any space, leading to a
> > trace like the following:
> >
> >  heisenberg kernel: ------------[ cut here ]------------
> >  heisenberg kernel: BTRFS: Transaction aborted (error -28)
> >  heisenberg kernel: WARNING: CPU: 0 PID: 7137 at fs/btrfs/root-tree.c:1=
36 btrfs_update_root+0x22b/0x320 [btrfs]
> > (...)
> >  heisenberg kernel: CPU: 0 PID: 7137 Comm: btrfs-transacti Not tainted =
4.19.0-4-amd64 #1 Debian 4.19.28-2
> >  heisenberg kernel: Hardware name: FUJITSU LIFEBOOK U757/FJNB2A5, BIOS =
Version 1.21 03/19/2018
> >  heisenberg kernel: RIP: 0010:btrfs_update_root+0x22b/0x320 [btrfs]
> > (...)
> >  heisenberg kernel: RSP: 0018:ffffb5448828bd40 EFLAGS: 00010286
> >  heisenberg kernel: RAX: 0000000000000000 RBX: ffff8ed56bccef50 RCX: 00=
00000000000006
> >  heisenberg kernel: RDX: 0000000000000007 RSI: 0000000000000092 RDI: ff=
ff8ed6bda166a0
> >  heisenberg kernel: RBP: 00000000ffffffe4 R08: 00000000000003df R09: 00=
00000000000007
> >  heisenberg kernel: R10: 0000000000000000 R11: 0000000000000001 R12: ff=
ff8ed63396a078
> >  heisenberg kernel: R13: ffff8ed092d7c800 R14: ffff8ed64f5db028 R15: ff=
ff8ed6bd03d068
> >  heisenberg kernel: FS:  0000000000000000(0000) GS:ffff8ed6bda00000(000=
0) knlGS:0000000000000000
> >  heisenberg kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >  heisenberg kernel: CR2: 00007f46f75f8000 CR3: 0000000310a0a002 CR4: 00=
000000003606f0
> >  heisenberg kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00=
00000000000000
> >  heisenberg kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00=
00000000000400
> >  heisenberg kernel: Call Trace:
> >  heisenberg kernel:  commit_fs_roots+0x166/0x1d0 [btrfs]
> >  heisenberg kernel:  ? _cond_resched+0x15/0x30
> >  heisenberg kernel:  ? btrfs_run_delayed_refs+0xac/0x180 [btrfs]
> >  heisenberg kernel:  btrfs_commit_transaction+0x2bd/0x870 [btrfs]
> >  heisenberg kernel:  ? start_transaction+0x9d/0x3f0 [btrfs]
> >  heisenberg kernel:  transaction_kthread+0x147/0x180 [btrfs]
> >  heisenberg kernel:  ? btrfs_cleanup_transaction+0x530/0x530 [btrfs]
> >  heisenberg kernel:  kthread+0x112/0x130
> >  heisenberg kernel:  ? kthread_bind+0x30/0x30
> >  heisenberg kernel:  ret_from_fork+0x35/0x40
> >  heisenberg kernel: ---[ end trace 05de912e30e012d9 ]---
> >
> > Since fiemap (and btrfs_check_shared()) is a read-only operation, do no=
t do
> > a transaction join to avoid the overhead of creating a new transaction =
(if
> > there is currently no running transaction) and introducing a potential
> > point of failure when the new transaction gets committed, instead use a
> > transaction attach to grab a handle for the currently running transacti=
on
> > if any.
> >
> > Reported-by: Christoph Anton Mitterer <calestyo@scientia.net>
> > Link: https://lore.kernel.org/linux-btrfs/b2a668d7124f1d3e410367f587926=
f622b3f03a4.camel@scientia.net/
> > Fixes: afce772e87c36c ("btrfs: fix check_shared for fiemap ioctl")
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >  fs/btrfs/backref.c | 11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> > index 11459fe84a29..876e6bb93797 100644
> > --- a/fs/btrfs/backref.c
> > +++ b/fs/btrfs/backref.c
> > @@ -1460,8 +1460,8 @@ int btrfs_find_all_roots(struct btrfs_trans_handl=
e *trans,
> >   * callers (such as fiemap) which want to know whether the extent is
> >   * shared but do not need a ref count.
> >   *
> > - * This attempts to allocate a transaction in order to account for
> > - * delayed refs, but continues on even when the alloc fails.
> > + * This attempts to attach to the running transaction in order to acco=
unt for
> > + * delayed refs, but continues on even when no running transaction exi=
sts.
> >   *
> >   * Return: 0 if extent is not shared, 1 if it is shared, < 0 on error.
> >   */
> > @@ -1489,8 +1489,12 @@ int btrfs_check_shared(struct btrfs_root *root, =
u64 inum, u64 bytenr)
> >               return -ENOMEM;
> >       }
> >
> > -     trans =3D btrfs_join_transaction(root);
> > +     trans =3D btrfs_attach_transaction(root);
> >       if (IS_ERR(trans)) {
> > +             if (PTR_ERR(trans) !=3D -ENOENT) {
> > +                     ret =3D PTR_ERR(trans);
> > +                     goto out;
> > +             }
>
> My concern is, if at this timing there is no running transaction, so we
> continue with trans =3D=3D NULL.
>
> But before we continue, some one started a transaction and
> increased/decreased the extent reference number, this doesn't look as saf=
e.

So?

If an extent is not shared but right before btrfs_check_shared()
returns it becomes shared? We will report it as not shared.
It's the same type of "problem".

>
> Or did I miss something?
>
> Thanks,
> Qu
> >               trans =3D NULL;
> >               down_read(&fs_info->commit_root_sem);
> >       } else {
> > @@ -1523,6 +1527,7 @@ int btrfs_check_shared(struct btrfs_root *root, u=
64 inum, u64 bytenr)
> >       } else {
> >               up_read(&fs_info->commit_root_sem);
> >       }
> > +out:
> >       ulist_free(tmp);
> >       ulist_free(roots);
> >       return ret;
> >
>
