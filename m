Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C5A51AFD9
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 17:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789753479; cv=none; b=hfm5eEjapsQ+eB2kjdFUCnyqEIAEFsnqFy2lW66U+AFNUE8T6fss5lhOH8FHqSBSrrX9gkVAOnrCev9l64yMfIx4TMY2Lu54+4lBVMX14Pl8Q4SActtGLZK6WGOrqHJer8gPKlHRAuOreWk5VvqxkrAYjjxJjoiC5Lt3fgjpy5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789753479; c=relaxed/simple;
	bh=Ut+9lavTyYD+BMOEAl8/Z3iaKgWEYpebWCSdat4EHmM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qJYnZE0t5uD7/0RH89SitgDlQhZp0wmJzyec1Gov9dhWBG252z9B4b0r3SI6/Mh86kROtkLsnyMYON/9QR/3mLQoFk/fF2MP7vu1mgv8wnqdrY8tS18NnUb+jaNi3ksFRbXrYSr1aVx805f5Jd9owcLgNyBmP+SdNUfCQEGGgiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j8GUJZru; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j8GUJZru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0201F00898
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 17:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789753472;
	bh=AYqEg2XIsKI/8MUYYPGa6tp6TBRLeyG5OlNaZ5Iu8ww=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=j8GUJZruaBWh6Ydc8byS5EJehciN3BcFqyNlsggvx580CFQbxLHuGfzwDTHxAlOMw
	 9LADTPvZzjD88sjBhBsZ3gwLRNVbVVjCyAJeV36IcZ+Z1nWCoOWNlpC36duwhnWSu4
	 l/rWmIHrT/+ltDwwuq1N4KTlLqNCseKOSWpuoNzAAV9IQNzMwcVHXuvNbwJXwmXZwK
	 pWS0umoBsc4BGxfmY9ZCY4g8amnHIYQFPe1M7kQuqo0moep5Kyb80rAkUQhDfUcKgc
	 R0QrCzUawpiR0yohDmJVFBjjP0KEfcZl8zAX+Nmz8nN7V4MpBWcpJ8lMHcaGA52jyO
	 2UlR+jDI7Nzfw==
Received: by mail-oa2-f35.google.com with SMTP id 586e51a60fabf-466ccab774cso650703fac.1
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 10:44:32 -0700 (PDT)
X-Gm-Message-State: AFuF++mvxukjppw198pkEQejxOCaIUP1mCoL5SlGXc4I02HtoGXN2l03
	trptUCIrtj8O/KCXv80/p/TCO9Tg9fBcOe/Y5I2e1yZJCyt87q+6iSqnKiQgrUu3AptpiOq+LCw
	2F03UNT8/CQ/LsPEZl3tMVLxJHndPvFw=
X-Received: by 2002:a05:6870:a0b0:b0:47d:f10:686f with SMTP id
 586e51a60fabf-486e6bc2f33mr3588393fac.23.1789753471988; Fri, 18 Sep 2026
 10:44:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1789734239.git.fdmanana@suse.com> <ded35d39b9858ee6f20ee3358a8e592a36e8e33c.1789734246.git.fdmanana@suse.com>
 <20260918173655.GC2900089@zen.localdomain>
In-Reply-To: <20260918173655.GC2900089@zen.localdomain>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 18 Sep 2026 18:43:54 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7iKCsQrs=urcKV4qj6XB+nfD7z7mF8=QpzTc3zD14=2g@mail.gmail.com>
X-Gm-Features: AcwNN1W759-tLB_jVcmTt0Qac-U4L_vFH_emypSqezoTPiC-Ysf0Ily3bXt_eKk
Message-ID: <CAL3q7H7iKCsQrs=urcKV4qj6XB+nfD7z7mF8=QpzTc3zD14=2g@mail.gmail.com>
Subject: Re: [PATCH 2/3] btrfs: fix barrier usage in btrfs_record_root_in_trans()
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 18, 2026 at 6:36=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> On Fri, Sep 18, 2026 at 01:28:10PM +0100, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > The barrier usage in btrfs_record_root_in_trans() is wrong, as the writ=
er
> > side, in record_root_in_trans(), sets BTRFS_ROOT_IN_TRANS_SETUP, does a
> > write barrier and then sets the root's last transaction. This means the
> > reader side must check the root's last transaction, issue a read barrie=
r
> > and then check for BTRFS_ROOT_IN_TRANS_SETUP. However, currently we iss=
ue
> > a read barrier and then check the root's last transaction and the bit
> > BTRFS_ROOT_IN_TRANS_SETUP, which can be problematic because the CPU is
> > free to reorder the checks and the following can happen:
> >
> > 1) Before reading the root's last_trans, it checks that
> >    BTRFS_ROOT_IN_TRANS_SETUP is not set.
> >
> > 2) A writer sets BTRFS_ROOT_IN_TRANS_SETUP, does smp_wmb() and updates
> >    the root's last_trans.
> >
> > 3) The reader then sees the root's last_trans matches the current
> >    transaction and falsely concludes the root setup is completes and
> >    returns without waiting for the writer task to complete the setup
> >    (calling btrfs_init_reloc_root()).
> >
> > So fix the reading ordered as previously described: check the root's
> > last_trans, issue read barrier and then check BTRFS_ROOT_IN_TRANS_SETUP
> > (the reverse of what the writer side does).
>
> I think a comment on why we can't use release/acquire (u64) but that the
> non-atomicity is ok (we only check equality?) might be nice. Otherwise
> we are supposed to have some code like i_size_read(), right?
>
> Not blocking at all, just an observation, since those helpers are
> supposed to prevent this kind of bug.

I'm not sure what you mean. If you are mentioning the helpers for
last_trans use READ/WRITE_ONCE and that that prevents the bug being
fixed here, then that is not correct, because READ/WRITE_ONCE does not
prevent a CPU from reordering intructions (just compiler level
reordering, load/store tearing and a few other things).


>
> >
> > Assisted-by: LLM
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >  fs/btrfs/transaction.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > index c1555621ae4e..13203ea9e116 100644
> > --- a/fs/btrfs/transaction.c
> > +++ b/fs/btrfs/transaction.c
> > @@ -511,10 +511,11 @@ int btrfs_record_root_in_trans(struct btrfs_trans=
_handle *trans,
> >        * see record_root_in_trans for comments about IN_TRANS_SETUP usa=
ge
> >        * and barriers
> >        */
> > -     smp_rmb();
> > -     if (btrfs_get_root_last_trans(root) =3D=3D trans->transid &&
> > -         !test_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state))
> > -             return 0;
> > +     if (btrfs_get_root_last_trans(root) =3D=3D trans->transid) {
> > +             smp_rmb();
> > +             if (!test_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state))
> > +                     return 0;
> > +     }
> >
> >       mutex_lock(&fs_info->reloc_mutex);
> >       ret =3D record_root_in_trans(trans, root, false);
> > --
> > 2.47.2
> >
