Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E321243C061
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 15:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782748089; cv=none; b=dqBwbD6xXpHm+Gb9cRLXD/GtfSrtmvhbRO6wZPsKAcT709oUqP+vcAeoTedCoZb1jwkYC+cUTaf5we0kDPF9aBwzAlMRkp8tkAowWPqmLxmzIXFJ/2GMICvudhE7+sftAaofWzs9veIYKzOUVH2xhv774E3UPcqgHcJrddyDC3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782748089; c=relaxed/simple;
	bh=pMYBfAyQrREVKK3ZhINcPindahZyGoLfbdTeiuNWxBU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kW4YePW4SIztjAv1ZBLL6LZDa2slmYme6yzxhiD+KtuXVwvL+J5CdVzCQOYkJAcAJ1nGLVMy5oE4qkTUYlGzGMboCqRaIcfLeWDV0u0RmvFhqPCOKgqadww/ADN6XOgfCwb5wT57AFmodevGB8Q8vGcPchvAyEmmC+LMC5QlnLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EyTVPj3r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EyTVPj3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E011F00A3F
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 15:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782748087;
	bh=o3FyyRYl5908EABWzCXsXYbAncKihYWYQ0CyEe7djaY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EyTVPj3rBvATAKjitimJzp1plreY8+/XjuF5CMH74QhwfJWVHpdtbPzUuLZpWqU4p
	 J11mvU0sQ7DqqCl6TR7OZg7bi6TV3hMfH/0ZL90Sd97oXwX3hdoh3eaItRI658EUHV
	 Fmk4LzG72YjKovs+ghEqyZdrDdYNV2T6w7f9TiyR5wa2XQD4pfAN1qqCRP3KWFrrwI
	 EW260b93S08dTMhQ+9aI1HDQRaR7S0lyBNPsFm83QAjX9FRlk7Kql+b11mP7wzMKjb
	 4IEaYu60MbIws7iPsH33u42f9Z7wEaqy1LVOk57fdpVKj+gKNRhsvP2E42NMpzB9VD
	 yffz7KWxJSaQg==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c1214350188so435284266b.0
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 08:48:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrpAjQktbVxVXDt+HyAvlRaMuZ9fQe/tzJH96laAJDc97Unm4R1FWGijXtkd+paUoNKGkys7LMzuVyN/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwmKIEp5Ksk6O8PQVFciScT5BjJc5J/ADY8rB2mCqkTdeiADVhp
	RyIq9TCkRKrGqptqDpyBTs/fWGTitfnULzQq8sBNVi2YwUkpViEguNCrjitTkPN9weOAoGfbGEb
	hrcoLFw0ZWUxUi0Xtfg7FMAoOFQEBLxw=
X-Received: by 2002:a17:907:c25:b0:c12:5013:4b7e with SMTP id
 a640c23a62f3a-c1250134e4cmr319608466b.18.1782748086229; Mon, 29 Jun 2026
 08:48:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260629-btrfs-skip-logging-v1-1-4e3a28c1acaf@kernel.org>
 <CAL3q7H5o6vKOcQ0G4shQw6q7vCpfZYo8KO6Rg6VdChDoMB+C=g@mail.gmail.com>
 <5084d9c6b6a7025be156354194cf7d3fffebb0e2.camel@kernel.org> <CAL3q7H6cHCrcSY+Rj5TX6tEkcX33WmcF73oZbfycuCRAajYzfg@mail.gmail.com>
In-Reply-To: <CAL3q7H6cHCrcSY+Rj5TX6tEkcX33WmcF73oZbfycuCRAajYzfg@mail.gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 29 Jun 2026 16:47:28 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4nCvmMN8iO4+eVbP3aEm8oxmyfarb4bCyBPLEwU48O7w@mail.gmail.com>
X-Gm-Features: AVVi8Ccg6XQlZ9Kp8tz_NAdEbbZZRxOtM9m4I9T7jaLdxtbVfqi_mIV4C1Vh-LY
Message-ID: <CAL3q7H4nCvmMN8iO4+eVbP3aEm8oxmyfarb4bCyBPLEwU48O7w@mail.gmail.com>
Subject: Re: [PATCH] btrfs: don't let shrinker touch extent_maps that are
 being logged
To: Jeff Layton <jlayton@kernel.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>, 
	Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 29, 2026 at 4:06=E2=80=AFPM Filipe Manana <fdmanana@kernel.org>=
 wrote:
>
> On Mon, Jun 29, 2026 at 3:56=E2=80=AFPM Jeff Layton <jlayton@kernel.org> =
wrote:
> >
> > On Mon, 2026-06-29 at 15:19 +0100, Filipe Manana wrote:
> > > On Mon, Jun 29, 2026 at 2:41=E2=80=AFPM Jeff Layton <jlayton@kernel.o=
rg> wrote:
> > > >
> > > > The extent map shrinker can free an extent map that is still owned =
by an
> > > > in-flight fsync and still linked on the inode's modified_extents li=
st,
> > > > corrupting that list and eventually causing an RCU stall.
> > > >
> > > > btrfs_scan_inode() currently skips EXTENT_FLAG_PINNED maps, then ca=
lls
> > > > btrfs_remove_extent_mapping() followed by btrfs_free_extent_map():
> > > >
> > > >         if (em->flags & EXTENT_FLAG_PINNED)
> > > >                 goto next;
> > > >         ...
> > > >         btrfs_remove_extent_mapping(inode, em);
> > > >         btrfs_free_extent_map(em);
> > > >
> > > > But btrfs_remove_extent_mapping() deliberately does NOT unlink a ma=
p that
> > > > has EXTENT_FLAG_LOGGING set:
> > > >
> > > >         if (!(em->flags & EXTENT_FLAG_LOGGING))
> > > >                 list_del_init(&em->list);
> > > >         remove_em(inode, em);
> > > >
> > > > This sets up a UAF situation where a later fsync() can trip over th=
e
> > > > now-freed extent_map still on the modified_extents() list.
> > >
> > > I don't see how that can happen, because fsync always takes the
> > > inode's i_mmap_lock (in write/exclusive mode), and btrfs_scan_inode()
> > > takes the same lock too (in shared/read mode).
> > > EXTENT_FLAG_LOGGING is only set and cleared during fsync, so how can
> > > the shrinker race with fsync?
> > >
> >
> > ...and yet, the vmcore shows that the shrinker hit an extent_map that
> > had LOGGING set while holding the i_mmap_lock.
>
> Yes, but we need to understand why...
>
> >
> > I had hoped to add an assertion here that LOGGING couldn't be set on
> > the em's after taking the i_mmap_lock, but that's not viable:
> >
> > The problem is that the i_mmap_lock coverage isn't complete. I had
> > Claude assist me with some analysis so take it with a hefty grain of
> > salt but the problem is that the em tree can contain em's from other
> > inodes where the i_mmap_lock is not held:
>
> And that is the problem: an em tree, which belongs to an inode, should
> only have extent maps for that inode...
> An extent map can only belong to an inode.
>
> So that's what needs investigation. The bug is elsewhere.
>
> Thanks.
>
> >
> > -----------------------8<---------------------
> >
> > ...that inode is in progress, therefore no em in its tree should have L=
OGGING set. Your invariant is the right one.
> >
> >  But it's violated, because the i_mmap_lock interlock is incomplete. Tw=
o facts:
> >
> >   1. tree-log.c never takes i_mmap_lock =E2=80=94 grep returns 0 occurr=
ences. Only btrfs_sync_file takes it (file.c:1608/1610), and only
> >   on the one inode being fsync'd.
> >   2. A single fsync logs many other inodes, and each can set LOGGING on=
 its own ems via btrfs_log_changed_extents().

A single fsync can log other inodes yes, and without taking their
i_mmap_lock, but the inodes are logged in LOG_INODE_EXISTS mode, so
extents are not logged.
The only exception is for symlink inodes, but those are logged in full
mode, only have one extent (inlined), and always have
BTRFS_INODE_NEEDS_FULL_SYNC set, so we never end up in
btrfs_log_changed_extents() for symlinks.

> >   btrfs_log_inode() is called recursively on conflicting inodes, parent=
 directories, and referenced inodes:
> >   tree-log.c:5982  btrfs_log_inode(di_inode, log_mode)        # dir den=
tries
> >   tree-log.c:6339  btrfs_log_inode(inode, LOG_INODE_ALL)      # conflic=
ting inodes
> >   tree-log.c:6900  btrfs_log_inode(di_inode, log_mode)        # new dir=
 dentries
> >   tree-log.c:7389  btrfs_log_inode(dir_inode, LOG_INODE_ALL)  # log_all=
_parents
> >   tree-log.c:7488  btrfs_log_inode(inode, ...)                # referen=
ced inodes
> >
> >   2. For all of these, btrfs_sync_file holds i_mmap_lock on the origina=
l fsync'd inode =E2=80=94 not on these side inodes. So a side
> >   inode X gets LOGGING set on its ems while X's own i_mmap_lock is free=
.

Nop, see above.

> >
> >   So the shrinker can down_read_trylock(X->i_mmap_lock) successfully (n=
obody holds it) and walk X's tree while X's ems are
> >   LOGGING-flagged =E2=86=92 it removes+frees one =E2=86=92 corruption. =
The interlock only protects the directly-fsync'd inode, not the inodes
> >   logged as its dependencies.

Nop. Unless you can show an actual code path where while fsyncing one
inode we log another inode in LOG_INODE_ALL mode
Again, the exception is symlinks, but for those, the
BTRFS_INODE_NEEDS_FULL_SYNC flag is always set, so we never end up in
btrfs_log_changed_extents().

> >
> >
> > > Also, there should be no () after modified_extents (it's not a functi=
on name).
> > >
> > >
> >
> > Sorry, early morning typo. Fixed in my local repo.
> >
> > >
> > > >
> > > > Fix it by having the shrinker skip maps that are being logged, the =
same
> > > > way it skips pinned maps. Such a map is owned by the in-flight fsyn=
c and
> > > > will become reclaimable again once logging clears the flag.
> > > >
> > > > Fixes: 956a17d9d050 ("btrfs: add a shrinker for extent maps")
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > > We've started hitting a number of these problems in our fleet. It
> > > > seems to mostly happen on ARM64 architecture, but there have been s=
ome
> > > > WARN_ONs that popped on x86_64 too.
> > > > ---
> > > >  fs/btrfs/extent_map.c | 8 +++++++-
> > > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> > > > index fce9c5cc0122..128f7800e101 100644
> > > > --- a/fs/btrfs/extent_map.c
> > > > +++ b/fs/btrfs/extent_map.c
> > > > @@ -1166,7 +1166,13 @@ static long btrfs_scan_inode(struct btrfs_in=
ode *inode, struct btrfs_em_shrink_c
> > > >                 em =3D rb_entry(node, struct extent_map, rb_node);
> > > >                 ctx->scanned++;
> > > >
> > > > -               if (em->flags & EXTENT_FLAG_PINNED)
> > > > +               /*
> > > > +                * Skip extent maps that are pinned or are being lo=
gged. The
> > > > +                * i_mmap_lock should prevent this from seeing LOGG=
ING on extent_maps
> > > > +                * directly associated with inode, but em may be as=
sociated with
> > > > +                * other, dependent inodes and their locks are not =
held.
> > > > +                */
> > > > +               if (em->flags & (EXTENT_FLAG_PINNED | EXTENT_FLAG_L=
OGGING))
> > > >                         goto next;
> > > >
> > > >                 /*
> > > >
> > > > ---
> > > > base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
> > > > change-id: 20260629-btrfs-skip-logging-3e31701d9647
> > > >
> > > > Best regards,
> > > > --
> > > > Jeff Layton <jlayton@kernel.org>
> > > >
> > > >
> >
> > --
> > Jeff Layton <jlayton@kernel.org>
