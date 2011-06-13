From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Btrfs updates
Date: Sun, 12 Jun 2011 21:52:21 -0400
Message-ID: <1307929838-sup-4118@shiny>
References: <1307879298-sup-3080@shiny> <m262oar1a9.fsf@firstfloor.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <m262oar1a9.fsf@firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Andi Kleen's message of 2011-06-12 21:02:54 -0400:
> Chris Mason <chris.mason@oracle.com> writes:
>=20
> > Hi everyone,
> >
> > The for-linus branch of the btrfs unstable tree:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.=
git for-linus
>=20
> >
> > Has our current queue of fixes.  Josef's is the biggest pile, mostl=
y in
> > the allocator.  Josef and I both managed to merge his patch to avoi=
d
> > mapping the extent buffer if skip_locking was set, git merge is jus=
t a
> > little too easy sometimes (I double checked the resulting code).
>=20
> The new in 3.0 btrfs warnings on every build are still there:
>=20
> fs/btrfs/sysfs.c:76: warning: =E2=80=98btrfs_root_attrs=E2=80=99 defi=
ned but not used
> fs/btrfs/sysfs.c:97: warning: =E2=80=98btrfs_super_attrs=E2=80=99 def=
ined but not used
> fs/btrfs/sysfs.c:153: warning: =E2=80=98btrfs_super_release=E2=80=99 =
defined but not used  =20
> fs/btrfs/sysfs.c:160: warning: =E2=80=98btrfs_root_release=E2=80=99 d=
efined but not used
>=20
> These are not even used inside any ifdef. It's unclear to me: were
> these supposed to be used or removed?
>=20
> Probably better to remove since they seem to be untested, unless
> it was a merge error?

Right, I've been trying to decide how much of the sysfs interface to ri=
p
out.  We're not using it the way I had planned to, and Kay's proposed
udev changes are better than my original plans for sysfs.

One way or another I'll kill these off in the next rc.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
