From: Andrew Benton <b3nton@gmail.com>
Subject: Re: Fwd: [PATCH] Btrfs-progs: mention libattr dependency in INSTALL
 file
Date: Wed, 2 Nov 2011 22:58:59 +0000
Message-ID: <20111102225859.a303adad.b3nton@gmail.com>
References: <1320246873-25457-1-git-send-email-idryomov@gmail.com>
	<20111102204243.GA23532@zambezi.lan>
	<CAAeznTp=oSUK_rv2jsHwNzQzncqyLSoyEnYPTcuBRMqyPo56zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Leonidas Spyropoulos <artafinde@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAeznTp=oSUK_rv2jsHwNzQzncqyLSoyEnYPTcuBRMqyPo56zg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2 Nov 2011 20:52:28 +0000
Leonidas Spyropoulos <artafinde@gmail.com> wrote:

> This might interest you.

Thanks

> ---------- Forwarded message ----------
> From: Ilya Dryomov <idryomov@gmail.com>
> Date: Wed, Nov 2, 2011 at 8:42 PM
> Subject: Re: [PATCH] Btrfs-progs: mention libattr dependency in INSTA=
LL file
> To: linux-btrfs@vger.kernel.org
> Cc: Chris Mason <chris.mason@oracle.com>, Hugo Mills <hugo@carfax.org=
=2Euk>
>=20
>=20
> On Wed, Nov 02, 2011 at 05:14:33PM +0200, Ilya Dryomov wrote:
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> > =C2=A0INSTALL | =C2=A0 =C2=A03 ++-
> > =C2=A01 files changed, 2 insertions(+), 1 deletions(-)
> >
> > diff --git a/INSTALL b/INSTALL
> > index 6afbd90..11c388b 100644
> > --- a/INSTALL
> > +++ b/INSTALL
> > @@ -19,7 +19,8 @@ insmod btrfs.ko
> >
> > =C2=A0The Btrfs utility programs require libuuid to build. =C2=A0Th=
is can be found
> > =C2=A0in the e2fsprogs sources, and is usually available as libuuid=
 or
> > -e2fsprogs-devel from various distros.
> > +e2fsprogs-devel from various distros. =C2=A0The other dependency i=
s libattr
> > +(libattr1-dev in Debian-based distros).
> >
> > =C2=A0Building the utilities is just make ; make install. =C2=A0The=
 programs go
> > =C2=A0into /usr/local/bin. =C2=A0The mains commands available are:
> > --
> > 1.7.6.3

I see. I did check the INSTALL file when I first had the error but it
didn't mention any dependencies. Incidentally, I get libuuid from
util-linux.

>=20
> Scratch that, it seems it's indeed not needed. =C2=A0The thing is tha=
t every
> time a set up a new test machine I have to install libattr1-dev, but =
I
> never looked into it in detail.
>=20
> So libattr1-dev is needed because mkfs includes attr/xattr.h to be ab=
le
> to create FS from image with extended attributes. =C2=A0I think it's =
safe to
> change attr/xattr.h include to sys/xattr.h and thus get rid of this
> build dependency. =C2=A0(attr/xattr.h seems to be there for compatibi=
lity
> with SGI IRIX)
>=20
> I built mkfs with sys/xattr.h and created FS from directory containin=
g
> files with xattrs, it worked.

It does work, I used it to format the root partition I'm booted into at
the moment. But as I said before, I don't use any extended attributes.
It would be nice to have the choice and not be expected to install
libattr.

Thanks,
Andy
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
