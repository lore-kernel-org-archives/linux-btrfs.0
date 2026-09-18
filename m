Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF3A443E4F
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 18:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789754764; cv=none; b=ERweM1eTc3mWoJJjhkL6toy9r8nq44yvTy80074+gIy+29KX2ciVcGhYUV4r+Fbe65Wx9N+p25oaH8Yto5PyDnAU54mjwYOjSf1Lr0RSzBApN/fq201FngpMRDCrfe1FVdlR8SBgioHemPu2+6QVfBv4CxswNPakcpyOx0Lx6rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789754764; c=relaxed/simple;
	bh=16pbSQWvbHXnY5CEn5yQI5QutZKevR7k7k10h7fTY80=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DyR9GYMypxG67flqdPW0KtgZ7mjjAKcwJZmA5z7Yn918M56cTNYKPohkHM9jAVjLPGfHnlkkQV6Q33o66iglCY5ATz+Tmxsvl/cYEI8oUBCJYtpoAhTx4TML92W5PeFcTrmotBnv/kcqk1G3jBeU/7fQWbRn+EhgplY0M8oIMfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RxOJWDQy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RxOJWDQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECB51F000FF
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 18:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789754762;
	bh=YNsXFyCWjfh73K0c2mzXLTy1wBT1u+9OD7gzBZGGG7c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RxOJWDQyMVvok2h2N7X/ls2qkC8nHtB+jouqVJHQWnHRSb5PA2Ry+/A6Mh5Ccb+8a
	 y2h30RPk0aM6PSI6+zIaEIVINkQJq4zZYICO4nPUvMQK8WzfcPdr/5Ez7yQq8trakT
	 OkW8rGDeS/n5NfdbXg4G69HnnlCQ8CBcVHtWQ71cCXwS/glPoRnTTy1Cv++/fn4dUa
	 2Gf1SATOOhtlzpM9vSe+h0OmAgaWQkVFmu4/H7HqLwQhw79FLjGA1fjNalOEH4BpFl
	 h5rPPzAnm3qDJcrzoNfgDDOcYvqiZLaO+yjIKB6cb9xQCCgydA4Z1Eh/3e+jDzbE/Y
	 OZ2PkZIzdqpyw==
Received: by mail-ua2-f12.google.com with SMTP id a1e0cc1a2514c-97ea1a712deso271952241.3
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 11:06:02 -0700 (PDT)
X-Gm-Message-State: AFuF++kryibeKBnEi7/J2NHAGGJUu2DJpSHbobLd562qWtTxqFWD62eq
	Xs2xiviltizXmGXkbsk4GPc3JMTc4ACUZ7C560aIQVCt10KtTISCLeoXZJZkntZeldIVUMpWXbi
	lKlgWU/x3nhdJdZf5bqM4IHDD750PPWQ=
X-Received: by 2002:a05:6122:17a2:b0:5c9:66f7:2f23 with SMTP id
 71dfb90a1353d-5c9b58855b7mr1777920e0c.2.1789754761608; Fri, 18 Sep 2026
 11:06:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1789734239.git.fdmanana@suse.com> <ded35d39b9858ee6f20ee3358a8e592a36e8e33c.1789734246.git.fdmanana@suse.com>
 <20260918173655.GC2900089@zen.localdomain> <CAL3q7H7iKCsQrs=urcKV4qj6XB+nfD7z7mF8=QpzTc3zD14=2g@mail.gmail.com>
 <20260918174718.GA2923381@zen.localdomain>
In-Reply-To: <20260918174718.GA2923381@zen.localdomain>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 18 Sep 2026 19:05:24 +0100
X-Gmail-Original-Message-ID: <CAL3q7H667csOQydtbgyqnSmrFDkNLbdBwz+9N2mt8tWd5MfbvQ@mail.gmail.com>
X-Gm-Features: AcwNN1WtWZn8mAgIeQhtCUQeDDdGXDeUYSPoYEwdnL0AojqAbD9lfOLVS_s0cZk
Message-ID: <CAL3q7H667csOQydtbgyqnSmrFDkNLbdBwz+9N2mt8tWd5MfbvQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] btrfs: fix barrier usage in btrfs_record_root_in_trans()
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 18, 2026 at 6:47=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> On Fri, Sep 18, 2026 at 06:43:54PM +0100, Filipe Manana wrote:
> > On Fri, Sep 18, 2026 at 6:36=E2=80=AFPM Boris Burkov <boris@bur.io> wro=
te:
> > >
> > > On Fri, Sep 18, 2026 at 01:28:10PM +0100, fdmanana@kernel.org wrote:
> > > > From: Filipe Manana <fdmanana@suse.com>
> > > >
> > > > The barrier usage in btrfs_record_root_in_trans() is wrong, as the =
writer
> > > > side, in record_root_in_trans(), sets BTRFS_ROOT_IN_TRANS_SETUP, do=
es a
> > > > write barrier and then sets the root's last transaction. This means=
 the
> > > > reader side must check the root's last transaction, issue a read ba=
rrier
> > > > and then check for BTRFS_ROOT_IN_TRANS_SETUP. However, currently we=
 issue
> > > > a read barrier and then check the root's last transaction and the b=
it
> > > > BTRFS_ROOT_IN_TRANS_SETUP, which can be problematic because the CPU=
 is
> > > > free to reorder the checks and the following can happen:
> > > >
> > > > 1) Before reading the root's last_trans, it checks that
> > > >    BTRFS_ROOT_IN_TRANS_SETUP is not set.
> > > >
> > > > 2) A writer sets BTRFS_ROOT_IN_TRANS_SETUP, does smp_wmb() and upda=
tes
> > > >    the root's last_trans.
> > > >
> > > > 3) The reader then sees the root's last_trans matches the current
> > > >    transaction and falsely concludes the root setup is completes an=
d
> > > >    returns without waiting for the writer task to complete the setu=
p
> > > >    (calling btrfs_init_reloc_root()).
> > > >
> > > > So fix the reading ordered as previously described: check the root'=
s
> > > > last_trans, issue read barrier and then check BTRFS_ROOT_IN_TRANS_S=
ETUP
> > > > (the reverse of what the writer side does).
> > >
> > > I think a comment on why we can't use release/acquire (u64) but that =
the
> > > non-atomicity is ok (we only check equality?) might be nice. Otherwis=
e
> > > we are supposed to have some code like i_size_read(), right?
> > >
> > > Not blocking at all, just an observation, since those helpers are
> > > supposed to prevent this kind of bug.
> >
> > I'm not sure what you mean. If you are mentioning the helpers for
> > last_trans use READ/WRITE_ONCE and that that prevents the bug being
> > fixed here, then that is not correct, because READ/WRITE_ONCE does not
> > prevent a CPU from reordering intructions (just compiler level
> > reordering, load/store tearing and a few other things).
> >
> >
>
> Sorry for being unclear. No, what I mean is I think we should
> justify/document why we are not using smp_store_release/smp_load_acquire
> since those are exactly this pattern, and if we had used them, it would
> have prevented the bug.

It should work, but I don't see an advantage of one method over the
other (perhaps smp_store_release and and_load_acquire are a bit easier
to read for some).

I have no idea why that code (really old now) was written using smp_wmb/rmb=
.
Perhaps the macros for smp_store_release and and_load_acquire did not
exist back then, and that explains why we don't use them anywhere in
btrfs and always use smp_wmb/rmb.


>
> > >
> > > >
> > > > Assisted-by: LLM
> > > > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > > > ---
> > > >  fs/btrfs/transaction.c | 9 +++++----
> > > >  1 file changed, 5 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > > > index c1555621ae4e..13203ea9e116 100644
> > > > --- a/fs/btrfs/transaction.c
> > > > +++ b/fs/btrfs/transaction.c
> > > > @@ -511,10 +511,11 @@ int btrfs_record_root_in_trans(struct btrfs_t=
rans_handle *trans,
> > > >        * see record_root_in_trans for comments about IN_TRANS_SETUP=
 usage
> > > >        * and barriers
> > > >        */
> > > > -     smp_rmb();
> > > > -     if (btrfs_get_root_last_trans(root) =3D=3D trans->transid &&
> > > > -         !test_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state))
> > > > -             return 0;
> > > > +     if (btrfs_get_root_last_trans(root) =3D=3D trans->transid) {
> > > > +             smp_rmb();
> > > > +             if (!test_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state=
))
> > > > +                     return 0;
> > > > +     }
> > > >
> > > >       mutex_lock(&fs_info->reloc_mutex);
> > > >       ret =3D record_root_in_trans(trans, root, false);
> > > > --
> > > > 2.47.2
> > > >
