Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from luka.romanrm.net ([91.121.80.162]:58874 "EHLO luka.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab3IEPQD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Sep 2013 11:16:03 -0400
Date: Thu, 5 Sep 2013 21:06:19 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: =?UTF-8?B?0KLQuNC80L7RhNC10Lkg0KLQuNGC0L7QstC10YY=?=
	<nefelim4ag@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs-convert won't convert ext* - No valid Btrfs found on
 /dev/sdb1
Message-ID: <20130905210619.65e52e23@natsu>
In-Reply-To: <20130905145407.GA25694@carfax.org.uk>
References: <CAGqmi74L9WrifDROz7Mr4r3BxqDWiyiQqy0Wn6JBdfz17qDY9A@mail.gmail.com>
	<20130905145407.GA25694@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wo62Vh45Ri4=3bwlRg6f_eH"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/wo62Vh45Ri4=3bwlRg6f_eH
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 5 Sep 2013 15:54:07 +0100
Hugo Mills <hugo@carfax.org.uk> wrote:

> On Thu, Sep 05, 2013 at 05:43:27PM +0300, =D0=A2=D0=B8=D0=BC=D0=BE=D1=84=
=D0=B5=D0=B9 =D0=A2=D0=B8=D1=82=D0=BE=D0=B2=D0=B5=D1=86 wrote:
> > Hello guys, i try to convert ext4 volume, but btrfs-convert show me err=
or:
> > "No valid Btrfs found on file
> > unable to open ctree
> > conversion aborted."
> > Ubuntu 13.04
> > Kernel: 3.11
> > btrfs-progs git version 0.20-git20130822~194aa4a13
> >=20
> > way to reproduce error:
> > $ truncate -s 4G file
> > $ mkfs.ext4 file #say yes to create fs on non block device.
> > $ btrfs-convert file
> >  No valid Btrfs found on file
> >  unable to open ctree
> >  conversion aborted.
>=20
>    I'm guessing here, but I suspect you will need to create a loopback
> device so that btrfs-convert can look at it as a block device rather
> than as a file:
>=20
> # losetup -f --show file
> /dev/loop0
> # btrfs-convert /dev/loop0
>=20
>    Hugo.
>=20

Nope, just today I saw someone report the same problem in a blog comment:
http://popey.com/blog/2013/09/02/fun-with-btrfs-on-ubuntu/#comment-9704

-------
# umount /dev/sdb1
# fsck -f /dev/sdb1
fsck =D0=B8=D0=B7 util-linux 2.20.1
e2fsck 1.42.8 (20-Jun-2013)
data500: 144653/30531584 files (0.9% non-contiguous), 102659367/122096384
blocks

# btrfs-convert /dev/sdb1
No valid Btrfs found on /dev/sdb1
unable to open ctree
conversion aborted.

Ubuntu 13.10
btrfs-tools 0.19+20130705-1
-------

It looks like a bug in btrfs-convert.

--=20
With respect,
Roman

--Sig_/wo62Vh45Ri4=3bwlRg6f_eH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlIonesACgkQTLKSvz+PZwjTAwCeOLA6WgN9zwlvGWzXh9VWzOSn
uXoAnjSyEhOG2MsmwnlVN2qutT3+8WKI
=Szfm
-----END PGP SIGNATURE-----

--Sig_/wo62Vh45Ri4=3bwlRg6f_eH--
