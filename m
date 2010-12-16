From: Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: Re: [PATCH] btrfs: fix memory leak on error path in btrfs_get_acl()
Date: Thu, 16 Dec 2010 06:56:37 +0100
Message-ID: <20101216055637.GA4826@mako-laptop>
References: <1292450256-4544-1-git-send-email-mk@lab.zgora.pl>
 <AANLkTi=Zz8eQTS+ja59eB9-F1aE2QP5DEVCwqBP50j8K@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Mariusz Kozlowski <mk@lab.zgora.pl>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=Zz8eQTS+ja59eB9-F1aE2QP5DEVCwqBP50j8K@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 15, 2010 at 11:49:39PM +0100, Miguel Ojeda wrote:
> On Wed, Dec 15, 2010 at 10:57 PM, Mariusz Kozlowski <mk@lab.zgora.pl>=
 wrote:
> > If posix_acl_from_xattr() fails we leak memory stored in 'value'.
> >
> > Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
> > ---
> > =A0fs/btrfs/acl.c | =A0 =A01 +
> > =A01 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
> > index 2222d16..11c9561 100644
> > --- a/fs/btrfs/acl.c
> > +++ b/fs/btrfs/acl.c
> > @@ -61,6 +61,7 @@ static struct posix_acl *btrfs_get_acl(struct ino=
de *inode, int type)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (size > 0) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0acl =3D posix_acl_fr=
om_xattr(value, size);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (IS_ERR(acl))
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree=
(value);
>=20
> Be careful with the evil { }

Dang. Too much python recently i guess. Will send v2 shortly.

Thanks.

> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0retu=
rn acl;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set_cached_acl(inode=
, type, acl);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > --
> > 1.7.0.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ker=
nel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> > Please read the FAQ at =A0http://www.tux.org/lkml/
> >

--=20
Mariusz Kozlowski
