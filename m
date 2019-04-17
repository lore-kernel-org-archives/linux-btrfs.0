Return-Path: <SRS0=+3PB=ST=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BC31C282DA
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 20:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D0A5217F9
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 20:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731800AbfDQUpX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Apr 2019 16:45:23 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:39176 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727013AbfDQUpW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Apr 2019 16:45:22 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id E1F602BAE01; Wed, 17 Apr 2019 16:44:59 -0400 (EDT)
Date:   Wed, 17 Apr 2019 16:44:54 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Traces during logical_ino ioctl, slowdown, etc (was Re: [PATCH]
 Btrfs: do not start a transaction during fiemap)
Message-ID: <20190417204424.GC14770@hungrycats.org>
References: <20190415082900.2023-1-fdmanana@kernel.org>
 <20190417000749.GA16405@hungrycats.org>
 <CAL3q7H6dz3jJ-YpBeMW_HM5t_RD11ezPAscadR1-CwhfccPHeQ@mail.gmail.com>
 <20190417165038.GB14770@hungrycats.org>
 <CAL3q7H6S=Fzw_2FQ=0hoQHrYnm0mnzOn2dy2HEcj25KMjXdK_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="V88s5gaDVPzZ0KCq"
Content-Disposition: inline
In-Reply-To: <CAL3q7H6S=Fzw_2FQ=0hoQHrYnm0mnzOn2dy2HEcj25KMjXdK_w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--V88s5gaDVPzZ0KCq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 17, 2019 at 05:40:55PM +0000, Filipe Manana wrote:
> On Wed, Apr 17, 2019 at 5:50 PM Zygo Blaxell
> <ce3g8jdj@umail.furryterror.org> wrote:
> > > > It looks like btrfs_ioctl_logical_to_ino can set:
> > > >
> > > >         path->search_commit_root =3D 1;
> > > >
> > > > just before calling iterate_inodes_from_logical, but I tried that o=
nce,
> > > > and my test filesystem blew up a few days later, so there might be
> > > > something subtle that I missed.  Or maybe my test filesystem was go=
ing
> > > > to blow up that day anyway--I just assumed that I don't know what I=
'm
> > > > doing, and didn't repeat the test.
> > >
> > > Blew up? That's a very vague term... What do you mean with it? What
> > > happened exactly?
> >
> > Every few dozen hours of uptime with that change in the test kernel,
> > btrfs was forcing the filesystem to remount RO.  After a week of that,
> > there were parent transid verify failures, and my test filesystem stopp=
ed
> > being mountable.
>=20
> So you had plenty of other operations running at the same time?
> If so you can't take conclusion that the cause was setting
> search_commit_root to 1.

At the time it was the only difference between the test environment and
our common production one.  The timeline was:

	1.  A couple of years running a rsync + bees workload with
	daily snapshot creates and deletes.  Nothing unusual happens.

	2.  Switch to a test kernel based on 4.11.12 with this patch:

	commit 82a9f08cc7d65cb458f937467b0be00fd59eee67
	Author: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
	Date:   Wed Aug 23 21:40:20 2017 -0400

	    btrfs: try to improve LOGICAL_INO

	diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
	index c9dd3d657cf8..0d4f0dfb86f0 100644
	--- a/fs/btrfs/ioctl.c
	+++ b/fs/btrfs/ioctl.c
	@@ -4591,7 +4591,9 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_=
root *root,
			goto out;
		}
	=20
	+	path->search_commit_root =3D 1;
	+
		inodes =3D init_data_container(size);
		if (IS_ERR(inodes)) {
			ret =3D PTR_ERR(inodes);

	3.  remount-RO starts happening every day, corrupted filesystem
	in a week

	4.  mkfs and start over with this patch removed

	5.  More years running a rsync + bees workload with daily snapshot
	create and delete until the present.  Nothing unusual happens.

It's possible that some random, unrelated, catastrophic failure happened
coincidentally and only during the same week and on the same machine
that was running this test kernel, but I have operational data from
thousands of machine-weeks running the same workloads with the same
kernels, and no unpatched kernels have shown this behavior for as far
back as my data goes.

Statistically, it looks like the patch I tested is probably bad, but
you are correct: it doesn't *prove* anything, it's just a correlation.

> I'm assuming during those 12 hours you were doing nothing other then
> calling the logical ino ioctl.

I'm pretty sure you can't get a corrupted filesystem with LOGICAL_INO
alone, even with insufficient locking--if nothing else is happening,
the transactions will all be empty and data structures will be race-free.

bees is a continuous stream of TREE_SEARCH_V2, openat, pread, LOGICAL_INO,
INO_PATHS, and FILE_EXTENT_SAME operations.  bees reads data from the
filesystem, indexes the hash and extent bytenr where it found the data,
and when bees finds a match in the hash table, it uses LOGICAL_INO and
INO_PATHS to map the extent bytenrs back to file name + offset for openat
and FILE_EXTENT_SAME.  LOGICAL_INO is the slowest of these operations (*),
so bees can end up saturating all of its worker threads with LOGICAL_INO
calls, keeping at least one (and sometimes two or more) thread(s) running
LOGICAL_INO at all times.

So in my test, I was running LOGICAL_INO all the time, but also making
a lot of changes to the filesystem (dedupes inside the bees process,
rsyncs outside).

(*) I think dedupe would normally be the slowest operation, but after
TREE_SEARCH_V2, reading the data, calling LOGICAL_INO, and reading the
other copy of the data, by the time bees calls FILE_EXTENT_SAME, all
the data and metadata FILE_EXTENT_SAME could want to read is already in
cache, and there's no transaction commit to wait for in dedupe because
LOGICAL_INO either just finished waiting for it, or LOGICAL_INO will
end up stuck waiting to commit changes from the previous dedupe.

> Correct me if I'm doing a wrong assumption.
> >
> > > Setting search_commit_root should not cause any problems, the only
> > > thing that can happen is giving you non-accurate results
> > > because there might be relevant changes in the current transaction and
> > > therefore they are not visible yet from the commit roots.
> >
> > That's what I thought too, but my one data point said otherwise.  I can
> > repeat the test if that will be helpful.
> >
> > > > bees spends about 30% of its time stuck in LOGICAL_INO with a stack
> > > > trace like this:
> > > >
> > > >         [<ffffffffa8400e88>] btrfs_async_run_delayed_refs+0x118/0x1=
40
> > > >         [<ffffffffa841fbaa>] __btrfs_end_transaction+0x1da/0x2e0
> > > >         [<ffffffffa848ed19>] iterate_extent_inodes+0x159/0x3a0
> > > >         [<ffffffffa848eff6>] iterate_inodes_from_logical+0x96/0xb0
> > > >         [<ffffffffa84590a8>] btrfs_ioctl_logical_to_ino+0xe8/0x190
> > > >         [<ffffffffa845f1fd>] btrfs_ioctl+0xc5d/0x26a0
> > > >         [<ffffffffa82a8a62>] do_vfs_ioctl+0x92/0x6b0
> > > >         [<ffffffffa82a90f4>] SyS_ioctl+0x74/0x80
> > > >         [<ffffffffa8003b96>] do_syscall_64+0x76/0x180
> > > >         [<ffffffffa8e00086>] entry_SYSCALL_64_after_hwframe+0x42/0x=
b7
> > > >         [<ffffffffffffffff>] 0xffffffffffffffff
> > > >
> > > > so if it's at all possible to do LOGICAL_INO without joining a
> > > > transaction, the benefits should be significant.
> > >
> > > So that is not the same problem. That means that some other task has
> > > already started a transaction, the transaction
> > > was not created by the logical_ino ioctl. It just happened that
> > > logical_ino ended up flushing delayed refs, created by some other
> > > task(s),
> > > when releasing its transaction handle.
> >
> > There is also a lot of time without the delayed_refs call on 4.14 (the
> > top of the stack is __btrfs_end_transaction).
>=20
> It's useful to know what that would be.
>=20
> And since the discussion is not related at all to this thread (fiemap
> starting transactions), should be moved to a different thread.
>=20
> > > We don't flush delayed refs when releasing a transaction handle
> > > anymore, as of commit:
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/co=
mmit/?id=3Ddb2462a6ad3dc490ac33250042e728226ef3ba00
> >
> > On 5.0.6 (which has that commit), btrfs_ioctl_logical_to_ino is still
> > floating between 30% and 40% of the total bees runtime, with a trace li=
ke:
> >
> >         [<0>] wait_current_trans+0xc3/0x100
> >         [<0>] start_transaction+0x311/0x4d0
> >         [<0>] iterate_extent_inodes+0x96/0x3c0
> >         [<0>] iterate_inodes_from_logical+0xa6/0xd0
> >         [<0>] btrfs_ioctl_logical_to_ino+0xe8/0x190
> >         [<0>] btrfs_ioctl+0xcf7/0x2cb0
> >         [<0>] do_vfs_ioctl+0xa2/0x6f0
> >         [<0>] ksys_ioctl+0x70/0x80
> >         [<0>] __x64_sys_ioctl+0x16/0x20
> >         [<0>] do_syscall_64+0x60/0x190
> >         [<0>] entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >         [<0>] 0xffffffffffffffff
> >
> > > > > In some extreme cases this can result in the commit of the transa=
ction
> > > > > created by fiemap to fail with ENOSPC when updating the root item=
 of a
> > > > > subvolume tree because a join does not reserve any space, leading=
 to a
> > > > > trace like the following:
> > > > >
> > > > >  heisenberg kernel: ------------[ cut here ]------------
> > > > >  heisenberg kernel: BTRFS: Transaction aborted (error -28)
> > > > >  heisenberg kernel: WARNING: CPU: 0 PID: 7137 at fs/btrfs/root-tr=
ee.c:136 btrfs_update_root+0x22b/0x320 [btrfs]
> > > > > (...)
> > > > >  heisenberg kernel: CPU: 0 PID: 7137 Comm: btrfs-transacti Not ta=
inted 4.19.0-4-amd64 #1 Debian 4.19.28-2
> > > > >  heisenberg kernel: Hardware name: FUJITSU LIFEBOOK U757/FJNB2A5,=
 BIOS Version 1.21 03/19/2018
> > > > >  heisenberg kernel: RIP: 0010:btrfs_update_root+0x22b/0x320 [btrf=
s]
> > > > > (...)
> > > > >  heisenberg kernel: RSP: 0018:ffffb5448828bd40 EFLAGS: 00010286
> > > > >  heisenberg kernel: RAX: 0000000000000000 RBX: ffff8ed56bccef50 R=
CX: 0000000000000006
> > > > >  heisenberg kernel: RDX: 0000000000000007 RSI: 0000000000000092 R=
DI: ffff8ed6bda166a0
> > > > >  heisenberg kernel: RBP: 00000000ffffffe4 R08: 00000000000003df R=
09: 0000000000000007
> > > > >  heisenberg kernel: R10: 0000000000000000 R11: 0000000000000001 R=
12: ffff8ed63396a078
> > > > >  heisenberg kernel: R13: ffff8ed092d7c800 R14: ffff8ed64f5db028 R=
15: ffff8ed6bd03d068
> > > > >  heisenberg kernel: FS:  0000000000000000(0000) GS:ffff8ed6bda000=
00(0000) knlGS:0000000000000000
> > > > >  heisenberg kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005=
0033
> > > > >  heisenberg kernel: CR2: 00007f46f75f8000 CR3: 0000000310a0a002 C=
R4: 00000000003606f0
> > > > >  heisenberg kernel: DR0: 0000000000000000 DR1: 0000000000000000 D=
R2: 0000000000000000
> > > > >  heisenberg kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 D=
R7: 0000000000000400
> > > > >  heisenberg kernel: Call Trace:
> > > > >  heisenberg kernel:  commit_fs_roots+0x166/0x1d0 [btrfs]
> > > > >  heisenberg kernel:  ? _cond_resched+0x15/0x30
> > > > >  heisenberg kernel:  ? btrfs_run_delayed_refs+0xac/0x180 [btrfs]
> > > > >  heisenberg kernel:  btrfs_commit_transaction+0x2bd/0x870 [btrfs]
> > > > >  heisenberg kernel:  ? start_transaction+0x9d/0x3f0 [btrfs]
> > > > >  heisenberg kernel:  transaction_kthread+0x147/0x180 [btrfs]
> > > > >  heisenberg kernel:  ? btrfs_cleanup_transaction+0x530/0x530 [btr=
fs]
> > > > >  heisenberg kernel:  kthread+0x112/0x130
> > > > >  heisenberg kernel:  ? kthread_bind+0x30/0x30
> > > > >  heisenberg kernel:  ret_from_fork+0x35/0x40
> > > > >  heisenberg kernel: ---[ end trace 05de912e30e012d9 ]---
> > > > >
> > > > > Since fiemap (and btrfs_check_shared()) is a read-only operation,=
 do not do
> > > > > a transaction join to avoid the overhead of creating a new transa=
ction (if
> > > > > there is currently no running transaction) and introducing a pote=
ntial
> > > > > point of failure when the new transaction gets committed, instead=
 use a
> > > > > transaction attach to grab a handle for the currently running tra=
nsaction
> > > > > if any.
> > > > >
> > > > > Reported-by: Christoph Anton Mitterer <calestyo@scientia.net>
> > > > > Link: https://lore.kernel.org/linux-btrfs/b2a668d7124f1d3e410367f=
587926f622b3f03a4.camel@scientia.net/
> > > > > Fixes: afce772e87c36c ("btrfs: fix check_shared for fiemap ioctl")
> > > > > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > > > > ---
> > > > >  fs/btrfs/backref.c | 11 ++++++++---
> > > > >  1 file changed, 8 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> > > > > index 11459fe84a29..876e6bb93797 100644
> > > > > --- a/fs/btrfs/backref.c
> > > > > +++ b/fs/btrfs/backref.c
> > > > > @@ -1460,8 +1460,8 @@ int btrfs_find_all_roots(struct btrfs_trans=
_handle *trans,
> > > > >   * callers (such as fiemap) which want to know whether the exten=
t is
> > > > >   * shared but do not need a ref count.
> > > > >   *
> > > > > - * This attempts to allocate a transaction in order to account f=
or
> > > > > - * delayed refs, but continues on even when the alloc fails.
> > > > > + * This attempts to attach to the running transaction in order t=
o account for
> > > > > + * delayed refs, but continues on even when no running transacti=
on exists.
> > > > >   *
> > > > >   * Return: 0 if extent is not shared, 1 if it is shared, < 0 on =
error.
> > > > >   */
> > > > > @@ -1489,8 +1489,12 @@ int btrfs_check_shared(struct btrfs_root *=
root, u64 inum, u64 bytenr)
> > > > >               return -ENOMEM;
> > > > >       }
> > > > >
> > > > > -     trans =3D btrfs_join_transaction(root);
> > > > > +     trans =3D btrfs_attach_transaction(root);
> > > > >       if (IS_ERR(trans)) {
> > > > > +             if (PTR_ERR(trans) !=3D -ENOENT) {
> > > > > +                     ret =3D PTR_ERR(trans);
> > > > > +                     goto out;
> > > > > +             }
> > > > >               trans =3D NULL;
> > > > >               down_read(&fs_info->commit_root_sem);
> > > > >       } else {
> > > > > @@ -1523,6 +1527,7 @@ int btrfs_check_shared(struct btrfs_root *r=
oot, u64 inum, u64 bytenr)
> > > > >       } else {
> > > > >               up_read(&fs_info->commit_root_sem);
> > > > >       }
> > > > > +out:
> > > > >       ulist_free(tmp);
> > > > >       ulist_free(roots);
> > > > >       return ret;
> > > > > --
> > > > > 2.11.0
> > > > >
> > >
>=20

--V88s5gaDVPzZ0KCq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCXLeQHgAKCRCB+YsaVrMb
nENmAKDrEXeypd/Vorts7LE1Ka+QqdnqVQCfUxjOGOMvYvI3hrM/j0tlkWDqrEA=
=GnjI
-----END PGP SIGNATURE-----

--V88s5gaDVPzZ0KCq--
