Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC1F36B054
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 14:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782828412; cv=none; b=Y9ZUVHADSQ5zFD+ki9hzTw9TP8N1unwDrW0FbkRvoNxC8Q/2GQWGKzrteifO8BtehJXjP5Cmq+darnddgAiuka26jDt8wYLTO7jFXg/8H6qPa9p2s53tWUcb585jeNna0AwrQwmm3AHSj5lbf1QQhwXW9OoyMy8/IQEjuMvlawo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782828412; c=relaxed/simple;
	bh=bFZS6Qac6uT9L82WG6KbRKJDwRQ+z/NJUPBBpvMDSsc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AByAbaqBS03q6DgTR2BpMa38WHb49XrOZBWSanMSyKb24RlcDM6ULALQYLIIVNUoI1WtRwgZ0laPXLG+RD9CQCi/9fK90znS77qAg0WrZ5eee5nvdEVBVq/rdhqwbu6J2J1JtCwcSC722KBYGEOfd/uiwFSOQBDq9/xwidZk8f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eCxLlU5m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eCxLlU5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7876D1F00A3D
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 14:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782828409;
	bh=1u6u5ydd0u31m8rFPh7+2Q0cgGC4FiVYyCG9LUizmkI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=eCxLlU5mIvAuOHCvZnmsz+Z6JeO8qaaQlOZHUJCCyJeLBFI4dg9dyVhFI2AenIro2
	 pc72ftDzlaHvZSbdY7IWIYFpIl4f/OjTGACIDD12yBDARdFBo7YqMcyJ+zhr+8aX95
	 c0d1+/5vkXlWE7pvdGUxRYaWVq+oaZU83J4/6v94/fnilRbogW8O8vRqkOn7nKLZdy
	 ZbpiS+nJoH9MLAURms25xZNqUNyL2Z0xlHoLi3aUKc7UAp/AhZcNTOnakvgD3GpfEb
	 utj9+9HgT8GSrAakFlBNEesShXZ0j+VKu7r4eRpMdBRh3+WJVhY+En7bst+Okv3J5X
	 LcLyhKZXRJlZA==
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8f29ec73064so2787746d6.1
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 07:06:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rous/KpBo268wo/r69i1UbN+X3rJ6R1+SjHT9ZXT+18Q6vTY90PoVdyEgfWlCfiqkn/2XJK4n768mkuZQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJcNzGK4TUneEhYJs8svpZg1W5pi+ph0V7pM292bbbnpBHrzu/
	YTn18aj8JGFmsbCVoFkANvqpQTobBJaYtBYUCmCZL72iPbzOeI/FxSu2C//EvfRPzyH9NH1QxAS
	ZisTmkUMvm4Hh7yT282Reez464qOjZiM=
X-Received: by 2002:ad4:4305:0:b0:8cc:e87b:2cc with SMTP id
 6a1803df08f44-8f1bb32d00cmr41977886d6.34.1782828408613; Tue, 30 Jun 2026
 07:06:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260629-btrfs-skip-logging-v1-1-4e3a28c1acaf@kernel.org>
 <CAL3q7H5o6vKOcQ0G4shQw6q7vCpfZYo8KO6Rg6VdChDoMB+C=g@mail.gmail.com>
 <5084d9c6b6a7025be156354194cf7d3fffebb0e2.camel@kernel.org>
 <CAL3q7H6cHCrcSY+Rj5TX6tEkcX33WmcF73oZbfycuCRAajYzfg@mail.gmail.com>
 <CAL3q7H4nCvmMN8iO4+eVbP3aEm8oxmyfarb4bCyBPLEwU48O7w@mail.gmail.com> <2a2f3722ae7b822a48ec4ac3c641ecacc2ab052d.camel@kernel.org>
In-Reply-To: <2a2f3722ae7b822a48ec4ac3c641ecacc2ab052d.camel@kernel.org>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 30 Jun 2026 15:06:08 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5Gdz2jE1_=JhaU1wXR8izbHb_3a76zuYdBKEWDXVjN0w@mail.gmail.com>
X-Gm-Features: AVVi8CeseDBO9duzsZOBiSSL6SjnQvDdJIprYEiZxCNFGb1m4AYVs-FM4NoTXXk
Message-ID: <CAL3q7H5Gdz2jE1_=JhaU1wXR8izbHb_3a76zuYdBKEWDXVjN0w@mail.gmail.com>
Subject: Re: [PATCH] btrfs: don't let shrinker touch extent_maps that are
 being logged
To: Jeff Layton <jlayton@kernel.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>, 
	Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 30, 2026 at 1:28=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> On Mon, 2026-06-29 at 16:47 +0100, Filipe Manana wrote:
> > On Mon, Jun 29, 2026 at 4:06=E2=80=AFPM Filipe Manana <fdmanana@kernel.=
org> wrote:
> > >
> > > On Mon, Jun 29, 2026 at 3:56=E2=80=AFPM Jeff Layton <jlayton@kernel.o=
rg> wrote:
> > > >
> > > > On Mon, 2026-06-29 at 15:19 +0100, Filipe Manana wrote:
> > > > > On Mon, Jun 29, 2026 at 2:41=E2=80=AFPM Jeff Layton <jlayton@kern=
el.org> wrote:
> > > > > >
> > > > > > The extent map shrinker can free an extent map that is still ow=
ned by an
> > > > > > in-flight fsync and still linked on the inode's modified_extent=
s list,
> > > > > > corrupting that list and eventually causing an RCU stall.
> > > > > >
> > > > > > btrfs_scan_inode() currently skips EXTENT_FLAG_PINNED maps, the=
n calls
> > > > > > btrfs_remove_extent_mapping() followed by btrfs_free_extent_map=
():
> > > > > >
> > > > > >         if (em->flags & EXTENT_FLAG_PINNED)
> > > > > >                 goto next;
> > > > > >         ...
> > > > > >         btrfs_remove_extent_mapping(inode, em);
> > > > > >         btrfs_free_extent_map(em);
> > > > > >
> > > > > > But btrfs_remove_extent_mapping() deliberately does NOT unlink =
a map that
> > > > > > has EXTENT_FLAG_LOGGING set:
> > > > > >
> > > > > >         if (!(em->flags & EXTENT_FLAG_LOGGING))
> > > > > >                 list_del_init(&em->list);
> > > > > >         remove_em(inode, em);
> > > > > >
> > > > > > This sets up a UAF situation where a later fsync() can trip ove=
r the
> > > > > > now-freed extent_map still on the modified_extents() list.
> > > > >
> > > > > I don't see how that can happen, because fsync always takes the
> > > > > inode's i_mmap_lock (in write/exclusive mode), and btrfs_scan_ino=
de()
> > > > > takes the same lock too (in shared/read mode).
> > > > > EXTENT_FLAG_LOGGING is only set and cleared during fsync, so how =
can
> > > > > the shrinker race with fsync?
> > > > >
> > > >
> > > > ...and yet, the vmcore shows that the shrinker hit an extent_map th=
at
> > > > had LOGGING set while holding the i_mmap_lock.
> > >
> > > Yes, but we need to understand why...
> > >
> > > >
> > > > I had hoped to add an assertion here that LOGGING couldn't be set o=
n
> > > > the em's after taking the i_mmap_lock, but that's not viable:
> > > >
> > > > The problem is that the i_mmap_lock coverage isn't complete. I had
> > > > Claude assist me with some analysis so take it with a hefty grain o=
f
> > > > salt but the problem is that the em tree can contain em's from othe=
r
> > > > inodes where the i_mmap_lock is not held:
> > >
> > > And that is the problem: an em tree, which belongs to an inode, shoul=
d
> > > only have extent maps for that inode...
> > > An extent map can only belong to an inode.
> > >
> > > So that's what needs investigation. The bug is elsewhere.
> > >
> > > Thanks.
> > >
> > > >
> > > > -----------------------8<---------------------
> > > >
> > > > ...that inode is in progress, therefore no em in its tree should ha=
ve LOGGING set. Your invariant is the right one.
> > > >
> > > >  But it's violated, because the i_mmap_lock interlock is incomplete=
. Two facts:
> > > >
> > > >   1. tree-log.c never takes i_mmap_lock =E2=80=94 grep returns 0 oc=
currences. Only btrfs_sync_file takes it (file.c:1608/1610), and only
> > > >   on the one inode being fsync'd.
> > > >   2. A single fsync logs many other inodes, and each can set LOGGIN=
G on its own ems via btrfs_log_changed_extents().
> >
> > A single fsync can log other inodes yes, and without taking their
> > i_mmap_lock, but the inodes are logged in LOG_INODE_EXISTS mode, so
> > extents are not logged.
> > The only exception is for symlink inodes, but those are logged in full
> > mode, only have one extent (inlined), and always have
> > BTRFS_INODE_NEEDS_FULL_SYNC set, so we never end up in
> > btrfs_log_changed_extents() for symlinks.
> >
>
> Thanks for the explanation. It sounds like we should wire some warnings
> into the shrinker around these invariants. Like, if LOGGING is set and
> the inode's not a symlink, do a WARN_ON_ONCE()? I'll plan to look into
> that as well.
>
> FWIW, internally at Meta, we're turning the WARN_ON() calls in
> btrfs_free_extent_map() into BUG() calls across a swath of machines in
> the hopes we can get a vmcore earlier. We'll keep you posted.

To make it as simple as possible:

An fsync can only log extent maps for the inode being fsynced; other
inodes can be logged, but not their extent maps.
In order to log extent maps, we need to have the i_mmap_lock (in
write/exclusive mode) and the vfs lock on the inode too.

Symlinks have an inline extent but no extent map.
Directories never have extents.

So if the shrinker gets an extent map with the LOGGING flag, one of
two things is happening:

1) An fsync of one inode is logging extent maps of another. This bug
can cause corruption and data loss, because we must hold those two
locks to prevent races with writes (buffered, direct IO, mmap) and
other operations (truncate, hole punching, etc.), as previously
stated.

2) Something is corrupting an extent map, either inside or outside
(most likely) the fsync code.

Thanks.

>
> Thanks for the help so far!
>
> > > >   btrfs_log_inode() is called recursively on conflicting inodes, pa=
rent directories, and referenced inodes:
> > > >   tree-log.c:5982  btrfs_log_inode(di_inode, log_mode)        # dir=
 dentries
> > > >   tree-log.c:6339  btrfs_log_inode(inode, LOG_INODE_ALL)      # con=
flicting inodes
> > > >   tree-log.c:6900  btrfs_log_inode(di_inode, log_mode)        # new=
 dir dentries
> > > >   tree-log.c:7389  btrfs_log_inode(dir_inode, LOG_INODE_ALL)  # log=
_all_parents
> > > >   tree-log.c:7488  btrfs_log_inode(inode, ...)                # ref=
erenced inodes
> > > >
> > > >   2. For all of these, btrfs_sync_file holds i_mmap_lock on the ori=
ginal fsync'd inode =E2=80=94 not on these side inodes. So a side
> > > >   inode X gets LOGGING set on its ems while X's own i_mmap_lock is =
free.
> >
> > Nop, see above.
> >
> > > >
> > > >   So the shrinker can down_read_trylock(X->i_mmap_lock) successfull=
y (nobody holds it) and walk X's tree while X's ems are
> > > >   LOGGING-flagged =E2=86=92 it removes+frees one =E2=86=92 corrupti=
on. The interlock only protects the directly-fsync'd inode, not the inodes
> > > >   logged as its dependencies.
> >
> > Nop. Unless you can show an actual code path where while fsyncing one
> > inode we log another inode in LOG_INODE_ALL mode
> > Again, the exception is symlinks, but for those, the
> > BTRFS_INODE_NEEDS_FULL_SYNC flag is always set, so we never end up in
> > btrfs_log_changed_extents().
> >
> > > >
> > > >
> > > > > Also, there should be no () after modified_extents (it's not a fu=
nction name).
> > > > >
> > > > >
> > > >
> > > > Sorry, early morning typo. Fixed in my local repo.
> > > >
> > > > >
> > > > > >
> > > > > > Fix it by having the shrinker skip maps that are being logged, =
the same
> > > > > > way it skips pinned maps. Such a map is owned by the in-flight =
fsync and
> > > > > > will become reclaimable again once logging clears the flag.
> > > > > >
> > > > > > Fixes: 956a17d9d050 ("btrfs: add a shrinker for extent maps")
> > > > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > > > ---
> > > > > > We've started hitting a number of these problems in our fleet. =
It
> > > > > > seems to mostly happen on ARM64 architecture, but there have be=
en some
> > > > > > WARN_ONs that popped on x86_64 too.
> > > > > > ---
> > > > > >  fs/btrfs/extent_map.c | 8 +++++++-
> > > > > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> > > > > > index fce9c5cc0122..128f7800e101 100644
> > > > > > --- a/fs/btrfs/extent_map.c
> > > > > > +++ b/fs/btrfs/extent_map.c
> > > > > > @@ -1166,7 +1166,13 @@ static long btrfs_scan_inode(struct btrf=
s_inode *inode, struct btrfs_em_shrink_c
> > > > > >                 em =3D rb_entry(node, struct extent_map, rb_nod=
e);
> > > > > >                 ctx->scanned++;
> > > > > >
> > > > > > -               if (em->flags & EXTENT_FLAG_PINNED)
> > > > > > +               /*
> > > > > > +                * Skip extent maps that are pinned or are bein=
g logged. The
> > > > > > +                * i_mmap_lock should prevent this from seeing =
LOGGING on extent_maps
> > > > > > +                * directly associated with inode, but em may b=
e associated with
> > > > > > +                * other, dependent inodes and their locks are =
not held.
> > > > > > +                */
> > > > > > +               if (em->flags & (EXTENT_FLAG_PINNED | EXTENT_FL=
AG_LOGGING))
> > > > > >                         goto next;
> > > > > >
> > > > > >                 /*
> > > > > >
> > > > > > ---
> > > > > > base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
> > > > > > change-id: 20260629-btrfs-skip-logging-3e31701d9647
> > > > > >
> > > > > > Best regards,
> > > > > > --
> > > > > > Jeff Layton <jlayton@kernel.org>
> > > > > >
> > > > > >
> > > >
> > > > --
> > > > Jeff Layton <jlayton@kernel.org>
>
> --
> Jeff Layton <jlayton@kernel.org>
