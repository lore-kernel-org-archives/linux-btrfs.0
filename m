Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38372 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757531Ab3FTNcJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 09:32:09 -0400
Date: Thu, 20 Jun 2013 14:32:07 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Gabriel de Perthuis <g2p.code@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Two identical copies of an image mounted result in changes to
 both images if only one is modified
Message-ID: <20130620133207.GQ11290@carfax.org.uk>
References: <CAFvQSYRgvsqMxk_yZf6cPyoECJsUzn2g+cW-j7ktrWnhRL+0jA@mail.gmail.com>
 <20130620091622.GL11290@carfax.org.uk>
 <kpul4f$ei7$1@ger.gmane.org>
 <20130620103404.GN11290@carfax.org.uk>
 <kpum9h$ei7$2@ger.gmane.org>
 <20130620105607.GO11290@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Evp0T6PXIQ26qRMT"
In-Reply-To: <20130620105607.GO11290@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Evp0T6PXIQ26qRMT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 20, 2013 at 11:56:07AM +0100, Hugo Mills wrote:
> On Thu, Jun 20, 2013 at 10:41:53AM +0000, Gabriel de Perthuis wrote:
> > >> Instead of redirecting to a different block device, Btrfs could and
> > >> should refuse to mount an already-mounted superblock when the block
> > >> device doesn't match, somewhere in or below btrfs_mount.  Registering
> > >> extra, distinct superblocks for an already mounted raid is a differe=
nt
> > >> matter, but that isn't done through the mount syscall anyway.
> > >=20
> > >    The problem here is that you could quite legitimately mount
> > > /dev/sda (with UUID=3DAA1234) on, say, /mnt/fs-a, and /dev/sdb (with
> > > UUID=3DAA1234) on /mnt/fs-b -- _provided_ that /dev/sda and /dev/sdb =
are
> > > both part of the same filesystem. So you can't simply prevent mounting
> > > based on the device that the mount's being done with.
> >=20
> > Okay.  The check should rely on a list of known block devices
> > for a given filesystem uuid.
>=20
>    And this is where we fail currently -- that list is held by the
> btrfs module in the kernel, and is constructed on the basis of what
> "btrfs dev scan" finds by looking at superblocks on block devices.
> Currently, there's no method implemented for determining whether a
> block device with a legitimate btrfs superblock on it is a duplicate
> of another device, or whether it's a newly-discovered device which is
> part of an as-yet incompletely specified multi-device FS.
>=20
>    I think it should be possible to look up the device ID as well, and
> complain (loudly, to the user, and in the kernel) at btrfs dev scan
> time if we see duplicates. That would deal with the problem at the
> earliest point of confusion.

   Incidentally, there's a conversation on IRC right now about how to
deal with this issue. A solution to prevent the data loss cases may be
arriving some time Real Soon Now=E2=84=A2...

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Computer Science is not about computers,  any more than ---    =20
                     astronomy is about telescopes.                     =20

--Evp0T6PXIQ26qRMT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUcMEV1heFHXiqx3kAQKYLhAAgKY+r2NoLoBtwjCEs2E9K3X1la6ZErBT
TNmoGfGUICweNjqPAgA76HuiwT4XyTBpp5TgiiJGW7SiSSGxFIeKHg+0PjVgp4Sf
HIJ5LOxETKftm+ODjGqkUfna1VDwR39v8vKb/r0/mHPaWgX206T9mwP7zcXGHrt5
rZWxeWF23MNqHRGi7ODp97JSdUfR/yg18XgKH1jcc8fJVo2wS+EhsP9Ihc1LnRJW
HWbdtSyfbkKeFkCqrH+m8Mh4B6B+VMHuEkGq3Z40h5DRbWJjYxwiyB8/5SPxxS4V
IgMPho9l04Ah7eEyiQ5716wKs2OR5fTGs6nQtRgJzFwpkbKqfnb48vtwizAhN8UT
g2D2fjieKbXwR4Y9NJ61blQ2C9AuJxXKzPH5RAQNPTCf5692zp7vjqRdmzdOlkh1
9uHZsl6qUIzT+ViAX4+0n2JmdC+hG9E/IMBpfDiq+12ogwhIKhIhz+aD6jRgU2wl
5cvJrc+aPtVI6IbmZ9kiL7/GzstyqZxyn7wTXY7Oevm4MsZ+2fDvOasvnnH7KrdY
ZZxQNHZg2uWAhHlsMIzyaPRWgEB5TD7n7gWWd2SugaPX9GVQ3hSbHZ0cR1rxXKhr
P8ieXmffe0JTZAFbmpNNQFdY9p1mBF8m+Qx9lrWGNio5YQnKeyLP+mCsn+fDM8X8
XkC2COxm+m4=
=sf6U
-----END PGP SIGNATURE-----

--Evp0T6PXIQ26qRMT--
