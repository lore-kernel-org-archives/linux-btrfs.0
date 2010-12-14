From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: do not loop through raid types when looking for free extent
Date: Mon, 13 Dec 2010 20:59:51 -0500
Message-ID: <1292291723-sup-2491@think>
References: <1289942524-29637-1-git-send-email-josef@redhat.com> <AANLkTikXh1di6qoN5EgCdbH+20ZCzSdOD8UcXja-Sn_c@mail.gmail.com> <1292290233-sup-3270@think> <AANLkTimObyLj=f7W9jdqxd1f7tQ9HVeUpsKRRgKKkLwn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Yan, Zheng" <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTimObyLj=f7W9jdqxd1f7tQ9HVeUpsKRRgKKkLwn@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Yan, Zheng's message of 2010-12-13 20:54:12 -0500:
> On Tue, Dec 14, 2010 at 9:33 AM, Chris Mason <chris.mason@oracle.com>=
 wrote:
> > Excerpts from Yan, Zheng's message of 2010-11-16 20:38:23 -0500:
> >> On Wed, Nov 17, 2010 at 5:22 AM, Josef Bacik <josef@redhat.com> wr=
ote:
> >> > There is a bug in find_free_extent where if we don't find a free=
 extent in the
> >> > raid type we are looking for, we loop through to the next raid t=
ype. =C2=A0This is
> >> > not ok since we need to make sure we honor the raid types we are=
 given. =C2=A0So
> >> > instead kill this check and get the proper index for the raid ty=
pe we want from
> >> > the allocator. =C2=A0Thanks,
> >> >
> >>
> >> Loop through raid types is for handling failure in the middle of r=
aid type
> >> conversion.
> >
> > The problem is that nothing prevents it from looping back to a raid=
0
> > chunk when we really want raid1 or raid10. =C2=A0And mkfs leaves be=
hind a
> > small raid0 chunk (4MB) that is uses as it assembles all the device=
s.
>=20
> check code at end of btrfs_read_block_groups, it prevents allocating
> from raid0 when there are mirrored block groups.

We're still allocating from them though.  It's a big problem when we
mount degraded.

-chris

>=20
> >
> > I confirmed that we often use the small raid0 chunk even in raid1 o=
r
> > raid10.
> >
> > Please take a look at this commit:
> >
> > http://git.kernel.org/?p=3Dlinux/kernel/git/mason/btrfs-unstable.gi=
t;a=3Dcommit;h=3D83a50de97fe96aca82389e061862ed760ece2283
> >
> > -chris
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btr=
fs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
> >
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
