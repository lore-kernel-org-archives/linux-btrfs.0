Return-Path: <SRS0=+3PB=ST=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15558C10F12
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 09:23:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C89A92173C
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 09:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555492979;
	bh=7jhW4IDV/T8wScjyLIP2sMdwOE3T8LqO0jXZHbIU2O8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=jQQOm4P6TgH8zGMbnqKQr9nnxKPzXpNX/4ss9BPYZS6kJmsSbZ/6+vyr5CnTNxmjk
	 leJeSO+ODEuf1g3XTB+L0/258/oQaxfHuJg4uJwh/+Ab2J52jQexJuEkjsrJlQs2jX
	 kWoNpcUXmpSSaUdP8sW6oQMceYFgt1NgzVeJBNMs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbfDQJW6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Apr 2019 05:22:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727282AbfDQJW6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Apr 2019 05:22:58 -0400
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 942172173C
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Apr 2019 09:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555492976;
        bh=7jhW4IDV/T8wScjyLIP2sMdwOE3T8LqO0jXZHbIU2O8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GG0ZZtZcuGy/+ncRigw/I2l0oZXb6RzTQHZDM4fZjLpfDGrZcVV/JmMta5T+GS/NV
         YBRQgE3KTQuayphX4o954BK/vHewEHT+C9ksY+HZ+BHOVNqbvl6dKHppiJH4gp5KqP
         hAOByHI74OKaPtcETunDcc12+o4TxtWw09yBsns4=
Received: by mail-vs1-f48.google.com with SMTP id g127so13186750vsd.6
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Apr 2019 02:22:56 -0700 (PDT)
X-Gm-Message-State: APjAAAXsIm76T4xItZeZSpqp6cqC8aSCj3Wt6XCffB0uxWE8LPb7fj5N
        Di1aalJsDfucrANaajqIxI0isHusdEEzduNoC3k=
X-Google-Smtp-Source: APXvYqyvlDtP+i3jiyYl+ibL7dHPOUno7TnT7bcyBPv9wpZCvMTYKIqMgUdb2GMSyWjeb+KNTWNrhigHg/9qQwomgmw=
X-Received: by 2002:a67:e258:: with SMTP id w24mr24402621vse.20.1555492975671;
 Wed, 17 Apr 2019 02:22:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190415082900.2023-1-fdmanana@kernel.org> <20190417000749.GA16405@hungrycats.org>
In-Reply-To: <20190417000749.GA16405@hungrycats.org>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Wed, 17 Apr 2019 09:22:44 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6dz3jJ-YpBeMW_HM5t_RD11ezPAscadR1-CwhfccPHeQ@mail.gmail.com>
Message-ID: <CAL3q7H6dz3jJ-YpBeMW_HM5t_RD11ezPAscadR1-CwhfccPHeQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: do not start a transaction during fiemap
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 17, 2019 at 1:08 AM Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
>
> On Mon, Apr 15, 2019 at 09:29:00AM +0100, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > During fiemap, for regular extents (non inline) we need to check if they
> > are shared and if they are, set the shared bit. Checking if an extent is
> > shared requires checking the delayed references of the currently running
> > transaction, since some reference might have not yet hit the extent tree
> > and be only in the in-memory delayed references.
> >
> > However we were using a transaction join for this, which creates a new
> > transaction when there is no transaction currently running. That means
> > that two more potential failures can happen: creating the transaction and
> > committing it. Further, if no write activity is currently happening in the
> > system, and fiemap calls keep being done, we end up creating and
> > committing transactions that do nothing.
>
> Cool!
>
> Any chance we can do this for the LOGICAL_INO ioctl?  Last time I checked
> (I admit that was a while ago), LOGICAL_INO cost about the same as
> fsync(), because it creates transactions with btrfs_join_transaction a
> few levels deep in the call stack, and gets blocked waiting for them
> to complete.

So iterate_extent_inodes() should definitly use the attach API and not join for
the same reasons. And I can fix that separately.

>
> It looks like btrfs_ioctl_logical_to_ino can set:
>
>         path->search_commit_root = 1;
>
> just before calling iterate_inodes_from_logical, but I tried that once,
> and my test filesystem blew up a few days later, so there might be
> something subtle that I missed.  Or maybe my test filesystem was going
> to blow up that day anyway--I just assumed that I don't know what I'm
> doing, and didn't repeat the test.

Blew up? That's a very vague term... What do you mean with it? What
happened exactly?

Setting search_commit_root should not cause any problems, the only
thing that can happen is giving you non-accurate results
because there might be relevant changes in the current transaction and
therefore they are not visible yet from the commit roots.

>
> bees spends about 30% of its time stuck in LOGICAL_INO with a stack
> trace like this:
>
>         [<ffffffffa8400e88>] btrfs_async_run_delayed_refs+0x118/0x140
>         [<ffffffffa841fbaa>] __btrfs_end_transaction+0x1da/0x2e0
>         [<ffffffffa848ed19>] iterate_extent_inodes+0x159/0x3a0
>         [<ffffffffa848eff6>] iterate_inodes_from_logical+0x96/0xb0
>         [<ffffffffa84590a8>] btrfs_ioctl_logical_to_ino+0xe8/0x190
>         [<ffffffffa845f1fd>] btrfs_ioctl+0xc5d/0x26a0
>         [<ffffffffa82a8a62>] do_vfs_ioctl+0x92/0x6b0
>         [<ffffffffa82a90f4>] SyS_ioctl+0x74/0x80
>         [<ffffffffa8003b96>] do_syscall_64+0x76/0x180
>         [<ffffffffa8e00086>] entry_SYSCALL_64_after_hwframe+0x42/0xb7
>         [<ffffffffffffffff>] 0xffffffffffffffff
>
> so if it's at all possible to do LOGICAL_INO without joining a
> transaction, the benefits should be significant.

So that is not the same problem. That means that some other task has
already started a transaction, the transaction
was not created by the logical_ino ioctl. It just happened that
logical_ino ended up flushing delayed refs, created by some other
task(s),
when releasing its transaction handle.

We don't flush delayed refs when releasing a transaction handle
anymore, as of commit:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=db2462a6ad3dc490ac33250042e728226ef3ba00

>
> > In some extreme cases this can result in the commit of the transaction
> > created by fiemap to fail with ENOSPC when updating the root item of a
> > subvolume tree because a join does not reserve any space, leading to a
> > trace like the following:
> >
> >  heisenberg kernel: ------------[ cut here ]------------
> >  heisenberg kernel: BTRFS: Transaction aborted (error -28)
> >  heisenberg kernel: WARNING: CPU: 0 PID: 7137 at fs/btrfs/root-tree.c:136 btrfs_update_root+0x22b/0x320 [btrfs]
> > (...)
> >  heisenberg kernel: CPU: 0 PID: 7137 Comm: btrfs-transacti Not tainted 4.19.0-4-amd64 #1 Debian 4.19.28-2
> >  heisenberg kernel: Hardware name: FUJITSU LIFEBOOK U757/FJNB2A5, BIOS Version 1.21 03/19/2018
> >  heisenberg kernel: RIP: 0010:btrfs_update_root+0x22b/0x320 [btrfs]
> > (...)
> >  heisenberg kernel: RSP: 0018:ffffb5448828bd40 EFLAGS: 00010286
> >  heisenberg kernel: RAX: 0000000000000000 RBX: ffff8ed56bccef50 RCX: 0000000000000006
> >  heisenberg kernel: RDX: 0000000000000007 RSI: 0000000000000092 RDI: ffff8ed6bda166a0
> >  heisenberg kernel: RBP: 00000000ffffffe4 R08: 00000000000003df R09: 0000000000000007
> >  heisenberg kernel: R10: 0000000000000000 R11: 0000000000000001 R12: ffff8ed63396a078
> >  heisenberg kernel: R13: ffff8ed092d7c800 R14: ffff8ed64f5db028 R15: ffff8ed6bd03d068
> >  heisenberg kernel: FS:  0000000000000000(0000) GS:ffff8ed6bda00000(0000) knlGS:0000000000000000
> >  heisenberg kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >  heisenberg kernel: CR2: 00007f46f75f8000 CR3: 0000000310a0a002 CR4: 00000000003606f0
> >  heisenberg kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >  heisenberg kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
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
> > Since fiemap (and btrfs_check_shared()) is a read-only operation, do not do
> > a transaction join to avoid the overhead of creating a new transaction (if
> > there is currently no running transaction) and introducing a potential
> > point of failure when the new transaction gets committed, instead use a
> > transaction attach to grab a handle for the currently running transaction
> > if any.
> >
> > Reported-by: Christoph Anton Mitterer <calestyo@scientia.net>
> > Link: https://lore.kernel.org/linux-btrfs/b2a668d7124f1d3e410367f587926f622b3f03a4.camel@scientia.net/
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
> > @@ -1460,8 +1460,8 @@ int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
> >   * callers (such as fiemap) which want to know whether the extent is
> >   * shared but do not need a ref count.
> >   *
> > - * This attempts to allocate a transaction in order to account for
> > - * delayed refs, but continues on even when the alloc fails.
> > + * This attempts to attach to the running transaction in order to account for
> > + * delayed refs, but continues on even when no running transaction exists.
> >   *
> >   * Return: 0 if extent is not shared, 1 if it is shared, < 0 on error.
> >   */
> > @@ -1489,8 +1489,12 @@ int btrfs_check_shared(struct btrfs_root *root, u64 inum, u64 bytenr)
> >               return -ENOMEM;
> >       }
> >
> > -     trans = btrfs_join_transaction(root);
> > +     trans = btrfs_attach_transaction(root);
> >       if (IS_ERR(trans)) {
> > +             if (PTR_ERR(trans) != -ENOENT) {
> > +                     ret = PTR_ERR(trans);
> > +                     goto out;
> > +             }
> >               trans = NULL;
> >               down_read(&fs_info->commit_root_sem);
> >       } else {
> > @@ -1523,6 +1527,7 @@ int btrfs_check_shared(struct btrfs_root *root, u64 inum, u64 bytenr)
> >       } else {
> >               up_read(&fs_info->commit_root_sem);
> >       }
> > +out:
> >       ulist_free(tmp);
> >       ulist_free(roots);
> >       return ret;
> > --
> > 2.11.0
> >
