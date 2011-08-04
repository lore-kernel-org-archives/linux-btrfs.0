From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs Slowdown (due to Memory Handling?)
Date: Thu, 04 Aug 2011 15:09:00 -0400
Message-ID: <1312484650-sup-930@shiny>
References: <CAKcLGm_VFTjLPJjQXe9Vg2C5Cm3kwx_H8tthXsu+kJb1mxZB0g@mail.gmail.com> <1312467261-sup-951@shiny> <CAKcLGm_aDZ8L5dnETP_-NH1tkacu=1em59rocX0zTE+WTzTYFw@mail.gmail.com> <1312470248-sup-2811@shiny> <1312470311-sup-3193@shiny> <CAKcLGm_CGUOmYfs=_qC1UPm+o3OUyreXUeUYGL_1-p2CEmz_tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <CAKcLGm_CGUOmYfs=_qC1UPm+o3OUyreXUeUYGL_1-p2CEmz_tw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Mitch Harder's message of 2011-08-04 14:40:20 -0400:
> On Thu, Aug 4, 2011 at 10:05 AM, Chris Mason <chris.mason@oracle.com>=
 wrote:
> >>
> >> Ok, so I'm going to guess that your problem is really with either =
file
> >> layout or just us using more metadata pages than the others. =C2=A0=
The file
> >> layout part is easy to test, just replace your git repo with a fre=
sh
> >> clone (or completely repack it).
> >
> > Sorry, I should have said replace your git repo with a fresh,
> > non-hardlinked clone. =C2=A0git clone by default will just make har=
dlinks if
> > it can, so it has to be a fresh clone.
> >
> > -chris
> >
>=20
> Oops, sorry, I let my responses slip off the list.
>=20
> You are right about there being a potentially huge difference between
> a cloned git repo and it's parent.  I didn't realize it could make
> such a difference.
>=20
> This problem now appears to have nothing to do with btrfs.  I can
> replicate the problem on an ext4 partition also if I use a copy of th=
e
> parent git repository instead of a clone.  The problem seems to lie i=
n
> the fragmentation of the git repository.
>=20
> If I work with a clone of my linux-btrfs repository, subsequent clone=
s
> are much faster.  Cloning my parent linux-btrfs repo takes about 90
> minutes (when I have restricted free RAM).  Cloning a clone of the
> parent drops down to less than 10 minutes.
>=20
> With there being several other threads relating to btrfs 'slow downs'=
,
> I though this issue might be related.

Great, glad to hear turned out to be filesystem agnostic.

The original git file format was basically very filesystem unfriendly
and it tends to fragment very badly.=20

Linus' solution to this is the pack file format, which is space
efficient and very fast to access.  The only downside is that you need
to repack the repo from time to time or performance tends to fall off a
cliff.

There is a git-pack command and a git gc command that you can use to
restructure things, both making it smaller and much faster.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
