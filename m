Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83AE33CEBB
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2026 19:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781812766; cv=none; b=BQ8pgj4OnzftQRB8duqij1/jMG42gLy3sFZjBjlns/pbRv272qg7MYrXz0s8Kbtmy6fVtk/V2ZpJ2JiOW4iQ/FusVAfxu6vsKY0Gd8VvsGvQyeauLaTIbNeuj15EVZvv8W6AYBKN92QWY+mzWCEuso8+a5SPOlcEhjGJpPRJBRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781812766; c=relaxed/simple;
	bh=+/fxXP7J3vQGVFv2qS3kIjGD4FkCACjhhIbqlpawFS4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kFacvAW/06yTPKeXFwDz7qXK1o5BaoJAPAi7VJUavHz7j79NND06nflVUkZZq/7vo2oRtgNJpRzAXEwjoFDi5v4yGKuJnr+DQdgv+ipEhhKAxi0iJQVB3bjhdxerxtfYvkNZywOVuqg6G+R54zU+/QDox5c/Wh0epXZ3kpLQrhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V99Goa9f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V99Goa9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78ACD1F00A3A
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2026 19:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781812764;
	bh=zAW3+xatnYUrcXThLJ5qmW7PVfs89Y4h9D2CpJEOrdM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=V99Goa9fBjBIq5WoiKxQZJ0AGeG1l17TYSgs4hm2W5W+w4xwrvKyhiDZcAcpT6p8g
	 YMlFjgZVdjd/gFAp4KlXnB0RFyP3d8lw85FcEOeYHxfPGDUTBI/T5UG1xXcAkyuOJV
	 PPx5Ux2S4G3tEeTef9fba6mGASMncYlL1QCBKdnHBFTHDdH17LNRPnD+54yPg8x3Xt
	 LqcDKIF5mg1EnU7YEEBNPZBNAHgUyVD2nLUh8nvBhv3nV5ntb3rPGjvoQHYheI1aed
	 UcIpp3JCxtzZDEQKhaJMqUiRQBAwCNr+1vp48xUugriq5Y4xt0YgHPiM/ehB5J8cec
	 PAkdcs/KB4kAQ==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c07ea058c1aso164235866b.2
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2026 12:59:24 -0700 (PDT)
X-Gm-Message-State: AOJu0YwnNY+ev+VqTd1g3GxTTGZFE/qTCdZuuqBWt9rTsIv565Qx6KpD
	evlDAMMaQEJj2ROEccu1t6M1Axx+j3NC60l9X9eQP1DDvWNmkX4fj5fYuJlkWW0KQ2TTAHhOlWi
	SZ9dPT/esL87l/F3grWEzWn/1vOh9Wxg=
X-Received: by 2002:a17:907:1c22:b0:c07:3dc3:49ac with SMTP id
 a640c23a62f3a-c097add43ddmr31380366b.11.1781812763129; Thu, 18 Jun 2026
 12:59:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1781263239.git.fdmanana@suse.com> <62602395bf1488aa81645ea59e22405d6c06d3f7.1781263239.git.fdmanana@suse.com>
 <20260618180228.GB1049224@twin.jikos.cz>
In-Reply-To: <20260618180228.GB1049224@twin.jikos.cz>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 18 Jun 2026 20:58:45 +0100
X-Gmail-Original-Message-ID: <CAL3q7H44MxkOyaxJR+8hqRt52_r1K=KH0j1YDTroNJWHcRU1fA@mail.gmail.com>
X-Gm-Features: AVVi8Cdd2ploUYOPmyXz4yUEuakDApPDPJLGoeSbLxzT0imFWcFfyG7wpN77pr0
Message-ID: <CAL3q7H44MxkOyaxJR+8hqRt52_r1K=KH0j1YDTroNJWHcRU1fA@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs: fix memory barrier order in reloc_root_is_dead()
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 18, 2026 at 7:02=E2=80=AFPM David Sterba <dsterba@suse.cz> wrot=
e:
>
> On Fri, Jun 12, 2026 at 01:13:57PM +0100, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > When we set a root's reloc_root to NULL, we do it like this:
> >
> >    static void clear_reloc_root(struct btrfs_root *root)
> >    {
> >        root->reloc_root =3D NULL;
> >        /*
> >         * Need barrier to ensure clear_bit() only happens after
> >         * root->reloc_root =3D NULL. Pairs with have_reloc_root().
> >         */
> >         smp_wmb();
> >         clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
> >    }
> >
> > So that a NULL reloc_root is always seen before seeing that the bit
> > BTRFS_ROOT_DEAD_RELOC_TREE was cleared.
> >
> > But on the read side we have:
> >
> >    static bool reloc_root_is_dead(const struct btrfs_root *root)
> >    {
> >         smp_rmb();
> >         if (test_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state))
> >             return true;
> >         return false;
> >    }
> >
> > And then callers of reloc_root_is_dead() access root->reloc_root.
> >
> > Because the read memory barrier is placed before testing the bit, the C=
PU
> > is completely free to speculatively reorder those two loads. It can rea=
d
> > root->reloc_root before it actually checks the dead tree bit.
>
> The barrier placement was contentious back then when and I don't have
> the capacity now to analyze it again. The point of placing the barrier
> before the test_bit() is to have up-to-date value for the check. It does
> not make sense to place it after, because the test can have stale data
> and other CPU could have changed the related state, the reloc_root in thi=
s
> case.

It only makes sense to place the smp_rmb() after test_bit().

The write side does the following:

->reloc_root =3D NULL;
smp_wmb();
set_bit()

So the read side must do the following:

test_bit()
smp_rmb()
read ->reloc_root

Where the reads of ->reloc_root happen in the callers of reloc_root_is_dead=
().

>
> As there's part with set bit and clear bit, and using the split
> read/write barriers it's not the easy case I could have missed
> something.
>
> > Sashiko reported this as an existing problem in another patch review, s=
ee
> > the link in the Link tag below.
> >
> > Fix this by moving the read memory barrier to happen after testing the =
bit
> > and update the comment to reflect current reality.
> >
> > Link: https://sashiko.dev/#/patchset/cf84f1a217c719e25b6b69e4298dd7afd3=
6c9427.1781194426.git.fdmanana%40suse.com
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >  fs/btrfs/relocation.c | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> > index 6b5a59cb21bb..00993505c9c3 100644
> > --- a/fs/btrfs/relocation.c
> > +++ b/fs/btrfs/relocation.c
> > @@ -339,14 +339,15 @@ static struct btrfs_backref_node *walk_down_backr=
ef(
> >
> >  static bool reloc_root_is_dead(const struct btrfs_root *root)
> >  {
> > +     if (test_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state))
> > +             return true;
> >       /*
> > -      * Pair with set_bit/clear_bit in clean_dirty_subvols and
> > -      * btrfs_update_reloc_root. We need to see the updated bit before
> > -      * trying to access reloc_root
> > +      * Pairs with set_bit/clear_bit in clear_reloc_root() and
> > +      * btrfs_update_reloc_root(). We need to see the updated bit befo=
re
> > +      * trying to access root->reloc_root in our callers.
>
> The part "we need to see the updated bit" refers to the original logic
> where 'updated bit =3D=3D 'smp_rmb; if (test_bit())' and making sure it's
> consistent with reloc root. So the meaning of the comment hasn't changed
> apart from the fixups (Pairs, clear_reloc_root, root->reloc_root).
>
> As your patch changes the logic the comment should be also updated, but

The comment makes sense as it was left.
There's the added part states that smp_rmb() is needed to ensure
callers see the ->reloc_root update after testing the bit.

> then I argue the resulting code is wrong, or at least not entierly
> correct.
>
> Alternatively we can drop the barriers completely for the
> 'dead_reloc_tree' bit and reloc_root synchronization, because we've spent
> too much time in total on that one.

I'm not sure what you are trying to say. Just liteterally dropping the
barriers does not seem correct to me, in fact they were added to fix
some races that people were hitting.

>
> >        */
> >       smp_rmb();
> > -     if (test_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state))
> > -             return true;
> > +
> >       return false;
> >  }
