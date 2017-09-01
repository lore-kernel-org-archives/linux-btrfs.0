Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37450 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751512AbdIAJKR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2017 05:10:17 -0400
Date: Fri, 1 Sep 2017 09:10:15 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Anthony Riley <anth1y@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: joining to contribute
Message-ID: <20170901091015.GE30990@carfax.org.uk>
References: <CANM+MUmnKX0UJk-SN9t=aBz7Xfq6Dfn73AhZBO5EBpdSh+HVtw@mail.gmail.com>
 <07225e42-1ffe-0289-27a1-811cd6e579a5@gmx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7CZp05NP8/gJM8Cl"
In-Reply-To: <07225e42-1ffe-0289-27a1-811cd6e579a5@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7CZp05NP8/gJM8Cl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 01, 2017 at 01:15:45PM +0800, Qu Wenruo wrote:
> On 2017=E5=B9=B409=E6=9C=8801=E6=97=A5 11:36, Anthony Riley wrote:
> >Hey folks,
> >
> >I thought I would finally take a swing at things I've wanted to be an
> >kernel/fs dev fora few years now. My current $job is as an
> >Infrastructure Engineer. I'm currently teaching myself C and have
> >background in shell scripting & python. I love doing deep dives and
> >learning about linux internals.  I've read the btrfs.wiki and can't
> >really decide which project to choose to start.
> >
> >Also should I go through this https://kernelnewbies.org/FirstKernelPatch=
 first?
> >Or should i start with something in Userspace?
>=20
> Well, personally I strongly recommended to start with btrfs on-disk
> format first, and then btrfs-progs/test cases, and kernel
> contribution as final objective.

   Pick a project which bothers you -- is there some feature that you
want to have, or a particular bug, or a sharp corner that needs
rounding off?

   This next bit is purely my opinion. Feel free to ignore it if it
doesn't float your boat.

   For a relatively easy example (from a code point of view), there's
a bug with send-receive where stuff breaks if you try snapshotting and
then sending a subvolume which already has a received-uuid set.
There's probably several ways of dealing with this.

   Alongside this, there's also a requirement for being able to do
round-trip send/receive while preserving the ability to do incremental
sends. This is likely to be related to the above bug-fix. I did a
complete write-up of what's happening, and what needs to happen, here:

http://www.spinics.net/lists/linux-btrfs/msg44089.html

   If you can fix the first bug in a way that doesn't rule out the
round-trip work, that's great. If you can also get the round-trip
stuff working, that's even better (but be warned that it will get
postponed until kdave is ready for all the stream format changes to
happen at once).

> BTW, if you want to start with btrfs on-disk format, print-tree.c
> from btrfs-progs is a good start point and btrfs wiki has relatively
> well documented entry for it.

   Seconded on this. For the on-disk format, it's also useful to
create a small test filesystem and use btrfs-debug-tree on it as you
do stuff to it (create files, create subvols, make links, modify
files). Do this in conjunction with the "Data Structures" page, and
you can see how it all actually fits together.

   It took me a couple of weeks to learn how it all worked the first
time round, but I didn't have much detailed documentation to work from
back then.

   Since you speak python, there's also Hans's python-btrfs:

https://github.com/knorrie/python-btrfs

> https://btrfs.wiki.kernel.org/index.php/Btrfs_design
> https://btrfs.wiki.kernel.org/index.php/Btree_Items

And, more generally: https://btrfs.wiki.kernel.org/index.php/Main_Page#Deve=
loper_documentation

I'd also point out the Data Structures and Trees pages linked
there. Some of the information is a bit out of date, or represents a
prototype of what it's describing. The source code is canonical -- use
the documentation as a guide to help you see where in the source to
look.

   Hugo.

--=20
Hugo Mills             | I'm always right. But I might be wrong about that.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--7CZp05NP8/gJM8Cl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZqSP3AAoJEFheFHXiqx3kl54P/AnOT36Wb57qEENX4kr9yL2E
lcf8ig40Sd+7A5TjQEyn+wkbUIFlvXG0lTGusreCq7+W17CO1ZKO/EN37qCHtGO0
ZrG+KEdqQ18PDkoYlZ8g6SF+ri1BzUummdE9aBVy0rQdjOcr+qtDeJSfdawsuiR9
Sy/1ZaY0VQVusHzH1bcKKpspEhNHtNgxf3lYnw8KYLsmNrejGB55qQHQuUzpBntl
HAwRxKzj5VOG7xOpqiCF2zDYyKKg+UR4XHhxOa/7CvGf2uh/QzJTcnfJqsDhunvN
nptqIh2+ZN9IhQQdFb0IG1IcHs1j11xojb//r6K24yimBliZvjV1iHrxtz0P2sCp
WD0WEKx5gg/jOZdMrO4T5H8A1wusRbUhgkElPRhcEEJvS6nDsrO/fjKJNzle0T5x
JcvMqP7Wm6SVew8hKltg0+bUR01kpgPh/4U+ZUgrwP/kq1WSORBEy1N237L0U/R2
3BvcxPJKsJwrpmNXRnoeicDIIBXGNQCLXZta5VniVPHA+YLgSRBXKyA0jwUFM4ve
4ycV8lmc4ucFKfU0/ZzLut2h2ktlbAO5ViqW28sfBtCxEVss0670PxtjrsOnL7nv
c68eVlBmmAADNQZt0TTINU2KsoFEdvzAzwY4H9ydIO16vncfYfSNkYMBx7rbTm1r
DcZ6qWYNyCk/kBlaIjvT
=IU6Z
-----END PGP SIGNATURE-----

--7CZp05NP8/gJM8Cl--
