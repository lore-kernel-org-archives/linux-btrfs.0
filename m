Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B54438F947
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 15:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782745613; cv=none; b=j9wQ6FB8CGnTEk2DDRpiOPJT5nlh3Kq39mPrGxHgNkqb8Pp5gOVlbokUw1f5WLJe+j1hefbgEvdhCvt1kMCZWPa5pzlqRn/pfdPHr4kxVeR9NgqalgztGvIzXLsu4eLeapcc/+cHE+OzFFcbACKi7QvzuJj65iHRo1Eht+vDfVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782745613; c=relaxed/simple;
	bh=NuIfmf4+ml2CTlj8Dgzc5/ZU5VCQc0ohu4Bzn69xoy4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dlz0bm4fkO18wqCHzprtzkWRiTqyoUmUEr9mYPdC/+W+eLqqqKhMScjISvvlnKJxrKMjZym4wMfgSgmCFJSD0E8Di74jq9ysdbblA7clIROTme9tiL6mik+I/a+sP9nXVhHXLTCu8b/yBaAhg3+bS8vX28f3dn7EZnP6/kW24P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z+mJkin/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z+mJkin/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCA51F00A3A
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 15:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782745610;
	bh=fnU4CKg+dtloHA7Y9CvyrKNgEFXtLwqWmg7L9KTjSpM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Z+mJkin/UwnFxH1dtmQxuy22qHfW6TH9e+Jk0nwKlo4c3RfTmHqX0GdpgW5CWKDdC
	 75tmnvTqq7GlmAs8YwZsfnZigAl+lTU1WNNgbSUHeGdWSk1mQ43lOA/egqKiV9iuam
	 m8uQwNP+AlXi8mU9JNprOFtOjaS7qLFyj79zXUf9WrNd2YZqboz9bmJ3U1DwU3EvTJ
	 Mo3u/dGH8zzZ3JzsoHYWHOt2OQ/gp1oJhYEz4IjSig54nm0YdZKQYZHT4nB1Zz5tmA
	 0u+RN8tPNp4AYtztYnXiwX+oiMzepRLiBTt0ThpSlNCkETq5CpjJhQTq0LWZEsbJHe
	 Y4G5Rg60uDwpg==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c125bce2294so153996866b.3
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 08:06:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq2mzg4vDDOgoMYS8h0TWw/OUTlzl4izgVWP7f7dOPWajTXs0wmokxnFfYdIu4gmqLFSCNIm4tHrppTFQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7FUl7LTXZQwwG3SrlcIkf97MQ/dwt0d3DyAa1/JZCx2rSSzar
	GlvdeUU7ClRcwGl2kVDUar9BZWvcAdosVfqPTRbGY4kEs3G75UPK9ls2mSIGCGSvOtqC+JcQgMK
	jhH6Sh+CZy1p1l+awBiO3wNwnsizhQJQ=
X-Received: by 2002:a17:907:9603:b0:c11:fe9d:2544 with SMTP id
 a640c23a62f3a-c1205dc20e5mr837225566b.22.1782745609272; Mon, 29 Jun 2026
 08:06:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260629-btrfs-skip-logging-v1-1-4e3a28c1acaf@kernel.org>
 <CAL3q7H5o6vKOcQ0G4shQw6q7vCpfZYo8KO6Rg6VdChDoMB+C=g@mail.gmail.com> <5084d9c6b6a7025be156354194cf7d3fffebb0e2.camel@kernel.org>
In-Reply-To: <5084d9c6b6a7025be156354194cf7d3fffebb0e2.camel@kernel.org>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 29 Jun 2026 16:06:11 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6cHCrcSY+Rj5TX6tEkcX33WmcF73oZbfycuCRAajYzfg@mail.gmail.com>
X-Gm-Features: AVVi8CdncOCtIyTsW2MVKJFxSUJfVtB5xX6S0rSAdgyuN_-zEgnfj6E8aafiuLo
Message-ID: <CAL3q7H6cHCrcSY+Rj5TX6tEkcX33WmcF73oZbfycuCRAajYzfg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: don't let shrinker touch extent_maps that are
 being logged
To: Jeff Layton <jlayton@kernel.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>, 
	Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 29, 2026 at 3:56=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> On Mon, 2026-06-29 at 15:19 +0100, Filipe Manana wrote:
> > On Mon, Jun 29, 2026 at 2:41=E2=80=AFPM Jeff Layton <jlayton@kernel.org=
> wrote:
> > >
> > > The extent map shrinker can free an extent map that is still owned by=
 an
> > > in-flight fsync and still linked on the inode's modified_extents list=
,
> > > corrupting that list and eventually causing an RCU stall.
> > >
> > > btrfs_scan_inode() currently skips EXTENT_FLAG_PINNED maps, then call=
s
> > > btrfs_remove_extent_mapping() followed by btrfs_free_extent_map():
> > >
> > >         if (em->flags & EXTENT_FLAG_PINNED)
> > >                 goto next;
> > >         ...
> > >         btrfs_remove_extent_mapping(inode, em);
> > >         btrfs_free_extent_map(em);
> > >
> > > But btrfs_remove_extent_mapping() deliberately does NOT unlink a map =
that
> > > has EXTENT_FLAG_LOGGING set:
> > >
> > >         if (!(em->flags & EXTENT_FLAG_LOGGING))
> > >                 list_del_init(&em->list);
> > >         remove_em(inode, em);
> > >
> > > This sets up a UAF situation where a later fsync() can trip over the
> > > now-freed extent_map still on the modified_extents() list.
> >
> > I don't see how that can happen, because fsync always takes the
> > inode's i_mmap_lock (in write/exclusive mode), and btrfs_scan_inode()
> > takes the same lock too (in shared/read mode).
> > EXTENT_FLAG_LOGGING is only set and cleared during fsync, so how can
> > the shrinker race with fsync?
> >
>
> ...and yet, the vmcore shows that the shrinker hit an extent_map that
> had LOGGING set while holding the i_mmap_lock.

Yes, but we need to understand why...

>
> I had hoped to add an assertion here that LOGGING couldn't be set on
> the em's after taking the i_mmap_lock, but that's not viable:
>
> The problem is that the i_mmap_lock coverage isn't complete. I had
> Claude assist me with some analysis so take it with a hefty grain of
> salt but the problem is that the em tree can contain em's from other
> inodes where the i_mmap_lock is not held:

And that is the problem: an em tree, which belongs to an inode, should
only have extent maps for that inode...
An extent map can only belong to an inode.

So that's what needs investigation. The bug is elsewhere.

Thanks.

>
> -----------------------8<---------------------
>
> ...that inode is in progress, therefore no em in its tree should have LOG=
GING set. Your invariant is the right one.
>
>  But it's violated, because the i_mmap_lock interlock is incomplete. Two =
facts:
>
>   1. tree-log.c never takes i_mmap_lock =E2=80=94 grep returns 0 occurren=
ces. Only btrfs_sync_file takes it (file.c:1608/1610), and only
>   on the one inode being fsync'd.
>   2. A single fsync logs many other inodes, and each can set LOGGING on i=
ts own ems via btrfs_log_changed_extents().
>   btrfs_log_inode() is called recursively on conflicting inodes, parent d=
irectories, and referenced inodes:
>   tree-log.c:5982  btrfs_log_inode(di_inode, log_mode)        # dir dentr=
ies
>   tree-log.c:6339  btrfs_log_inode(inode, LOG_INODE_ALL)      # conflicti=
ng inodes
>   tree-log.c:6900  btrfs_log_inode(di_inode, log_mode)        # new dir d=
entries
>   tree-log.c:7389  btrfs_log_inode(dir_inode, LOG_INODE_ALL)  # log_all_p=
arents
>   tree-log.c:7488  btrfs_log_inode(inode, ...)                # reference=
d inodes
>
>   2. For all of these, btrfs_sync_file holds i_mmap_lock on the original =
fsync'd inode =E2=80=94 not on these side inodes. So a side
>   inode X gets LOGGING set on its ems while X's own i_mmap_lock is free.
>
>   So the shrinker can down_read_trylock(X->i_mmap_lock) successfully (nob=
ody holds it) and walk X's tree while X's ems are
>   LOGGING-flagged =E2=86=92 it removes+frees one =E2=86=92 corruption. Th=
e interlock only protects the directly-fsync'd inode, not the inodes
>   logged as its dependencies.
>
>
> > Also, there should be no () after modified_extents (it's not a function=
 name).
> >
> >
>
> Sorry, early morning typo. Fixed in my local repo.
>
> >
> > >
> > > Fix it by having the shrinker skip maps that are being logged, the sa=
me
> > > way it skips pinned maps. Such a map is owned by the in-flight fsync =
and
> > > will become reclaimable again once logging clears the flag.
> > >
> > > Fixes: 956a17d9d050 ("btrfs: add a shrinker for extent maps")
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > > We've started hitting a number of these problems in our fleet. It
> > > seems to mostly happen on ARM64 architecture, but there have been som=
e
> > > WARN_ONs that popped on x86_64 too.
> > > ---
> > >  fs/btrfs/extent_map.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> > > index fce9c5cc0122..128f7800e101 100644
> > > --- a/fs/btrfs/extent_map.c
> > > +++ b/fs/btrfs/extent_map.c
> > > @@ -1166,7 +1166,13 @@ static long btrfs_scan_inode(struct btrfs_inod=
e *inode, struct btrfs_em_shrink_c
> > >                 em =3D rb_entry(node, struct extent_map, rb_node);
> > >                 ctx->scanned++;
> > >
> > > -               if (em->flags & EXTENT_FLAG_PINNED)
> > > +               /*
> > > +                * Skip extent maps that are pinned or are being logg=
ed. The
> > > +                * i_mmap_lock should prevent this from seeing LOGGIN=
G on extent_maps
> > > +                * directly associated with inode, but em may be asso=
ciated with
> > > +                * other, dependent inodes and their locks are not he=
ld.
> > > +                */
> > > +               if (em->flags & (EXTENT_FLAG_PINNED | EXTENT_FLAG_LOG=
GING))
> > >                         goto next;
> > >
> > >                 /*
> > >
> > > ---
> > > base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
> > > change-id: 20260629-btrfs-skip-logging-3e31701d9647
> > >
> > > Best regards,
> > > --
> > > Jeff Layton <jlayton@kernel.org>
> > >
> > >
>
> --
> Jeff Layton <jlayton@kernel.org>
