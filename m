From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH] Btrfs: fix infinite loop in btrfs_shrink_device()
Date: Sat, 26 Feb 2011 16:15:49 +0200
Message-ID: <20110226141549.GA2550@kwango.lan.net>
References: <20110225234310.GA2567@kwango.lan.net> <AANLkTik1J7q10fLp1js29_ge0HT0-=Bg9VOj6zYN-svW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTik1J7q10fLp1js29_ge0HT0-=Bg9VOj6zYN-svW@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 26, 2011 at 10:05:40AM +0800, Yan, Zheng  wrote:
> On Sat, Feb 26, 2011 at 7:43 AM, Ilya Dryomov <idryomov@gmail.com> wr=
ote:
> > In case of an ENOSPC error from btrfs_relocate_chunk() (line 2202) =
while
> > relocating a block group with offset 0 we end up endlessly looping.
> > This happens because key.offset -=3D 1 statement then unconditional=
ly
> > brings us back to the beginnig of the loop (key.offset =3D=3D (u64)=
-1).
> >
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> > =C2=A0fs/btrfs/volumes.c | =C2=A0 =C2=A03 ++-
> > =C2=A01 files changed, 2 insertions(+), 1 deletions(-)
> >
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index dd13eb8..0cb94ce 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -2212,7 +2212,8 @@ again:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0goto done;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret =3D=3D=
 -ENOSPC)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0failed++;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 key.offset -=3D =
1;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (--key.offset=
 =3D=3D -1)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>=20
> it should be  if (--key.offset =3D=3D (u64) -1)
>=20
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (failed && !retried) {
> > --
> > 1.7.2.3
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btr=
fs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
> >

I wonder how I managed to screw that up, I got it right in the commit
description..  Sorry for the noise, here is an updated version.

---

=46rom: Ilya Dryomov <idryomov@gmail.com>
Date: Sat, 26 Feb 2011 01:29:25 +0200
Subject: [PATCH] Btrfs: fix infinite loop in btrfs_shrink_device()

In case of an ENOSPC error from btrfs_relocate_chunk() (line 2202) whil=
e
relocating a block group with offset 0 we end up endlessly looping.
This happens because key.offset -=3D 1 statement then unconditionally
brings us back to the beginning of the loop (key.offset =3D=3D (u64)-1)=
=2E

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index dd13eb8..cd334ae 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2212,7 +2212,8 @@ again:
 			goto done;
 		if (ret =3D=3D -ENOSPC)
 			failed++;
-		key.offset -=3D 1;
+		if (--key.offset =3D=3D (u64)-1)
+			break;
 	}
=20
 	if (failed && !retried) {
--=20
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
