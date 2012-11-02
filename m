Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34955 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759261Ab2KBXoX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2012 19:44:23 -0400
Date: Fri, 2 Nov 2012 23:44:19 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Gabriel <g2p.code@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH][BTRFS-PROGS] Enhance btrfs fi df
Message-ID: <20121102234419.GD28864@carfax.org.uk>
References: <1351851339-19150-1-git-send-email-kreijack@inwind.it>
 <201211021218.29778.Martin@lichtvoll.de>
 <5093B658.3000007@gmail.com>
 <k715i0$7go$1@ger.gmane.org>
 <20121102220604.GC28864@carfax.org.uk>
 <k71kl2$7go$3@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ycz6tD7Th1CMF4v7"
In-Reply-To: <k71kl2$7go$3@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Ycz6tD7Th1CMF4v7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 02, 2012 at 11:23:14PM +0000, Gabriel wrote:
> On Fri, 02 Nov 2012 22:06:04 +0000, Hugo Mills wrote:
>=20
> > On Fri, Nov 02, 2012 at 07:05:37PM +0000, Gabriel wrote:
> >> On Fri, 02 Nov 2012 13:02:32 +0100, Goffredo Baroncelli wrote:
> >> > On 2012-11-02 12:18, Martin Steigerwald wrote:
> >> >> Metadata, DUP is displayed as 3,50GB on the device level and as 1,7=
5GB
> >> >> in total. I understand the logic behind this, but this could be a b=
it
> >> >> confusing.
> >> >>=20
> >> >> But it makes sense: Showing real allocation on device level makes
> >> >> sense,
> >> >> cause thats what really allocated on disk. Total makes some sense,
> >> >> cause thats what is being used from the tree by BTRFS.
> >> >=20
> >> > Yes, me too. At the first I was confused when you noticed this
> >> > discrepancy. So I have to admit that it is not so obvious to underst=
and.
> >> > However we didn't find any way to make it more clear...
> >> >=20
> >> >> It still looks confusing at first=E2=80=A6
> >> > We could use "Chunk(s) capacity" instead of total/size ? I would lik=
e an
> >> > opinion from a "english people" point of view..
> >>=20
> >> This is easy to fix, here's a mockup:
> >>=20
> >> Metadata,DUP: Size: 1.75GB =C3=972, Used: 627.84MB =C3=972
> >>    /dev/dm-0        3.50GB
> >=20
> >    I've not considered the full semantics of all this yet -- I'll try
> > to do that tomorrow. However, I note that the "=C3=972" here could beco=
me
> > non-integer with the RAID-5/6 code (which is due Real Soon Now). In
> > the first RAID-5/6 code drop, it won't even be simple to calculate
> > where there are different-sized devices in the filesystem. Putting an
> > exact figure on that number is potentially going to be awkward. I
> > think we're going to need kernel help for working out what that number
> > should be, in the general case.
>=20
> DUP can be nested below a device because it represents same-device
> redundancy (purpose: survive smudges but not device failure).
>=20
> On the other hand raid levels should occupy the same space on all
> linked devices (a necessary consequence of the guarantee that RAID5
> can survive the loss of any device and RAID6 any two devices).

   No, the multiplier here is variable. Consider:

1 MiB stored in RAID-5 across 3 devices takes up 1.5 MiB -- multiplier =C3=
=971.5
   (1 MiB over 2 devices is 512 KiB, plus an additional 512 KiB for parity)
1 MiB stored in RAID-5 across 6 devices takes up 1.2 MiB -- multipler =C3=
=971.2
   (1 MiB over 5 devices is 204.8 KiB, plus an additional 204.8 KiB for par=
ity)

   With the (initial) proposed implementation of RAID-5, the
stripe-width (i.e. the number of devices used for any given chunk
allocation) will be *as many as can be allocated*. Chris confirmed
this today on IRC. So if I have a disk array of 2T, 2T, 2T, 1T, 1T,
1T, then the first 1T of allocation will stripe across 6 devices,
giving me 5 data+1 parity, or a multiplier of =C3=971.2. As soon as the
smaller devices are full, the stripe width will drop to 3 devices, and
we'll be using 2 data+1 parity allocation, or a multiplier of =C3=971.5 for
any subsequent chunks. So, as more data over the first 5T is stored,
the multiplier steadily decreases, until we fill the FS, and we get a
multiplier of =C3=971.35 overall. This gets more complicated if you have
devices of many different sizes. (Imagine 6 disks with sizes 500G, 1T,
1.5T, 2T, 3T, 3T).

   We probably can work out the current RAID overhead and feed it back
sensibly, but it's (a) not constant as the allocation of the chunks
increases, and (b) not trivial to compute.

> The two probably won't need to be represented at the same time
> except during a reshape, because I imagine DUP gets converted to
> RAID (1 or 5) as soon as the second device is added.
>=20
> A 1=E2=86=922 reshape would look a bit like this (doing only the data col=
umn
> and skipping totals):
>=20
> InitialDevice
>   Reserved           1.21TB
>   Used               1.21TB
> RAID1(InitialDevice, SecondDevice)
>   Reserved   1.31TB + 100GB
>   Used             2=C3=97 100GB
>=20
> RAID5, RAID6: same with fractions, n+1=E2=81=84n and n+2=E2=81=84n.

   Except that n isn't guaranteed to be constant. That was pretty much
my only point. Don't assume that it will be (or at the very least, be
aware that you are assuming it is, and be prepared for inconsistencies).

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- Well, sir, the floor is yours.  But remember, the ---       =20
                              roof is ours!                             =20

--Ycz6tD7Th1CMF4v7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUJRa079z9OVl50rAAQIXCRAAkp70qiEYoL0pNR7vBQuJ5mZb16GzSuti
mvQCcxryFp02FppXSXgog7ScJsaQl6nB/3yD//r6hIm3LhkI/JErnObeYZDDUMzR
ZyQqDmXLnPC8jCgUp/FFtyv/+LO3JCVYNdh+LUWY94gEFf6vc/fcSmFaMeDWrflS
SYqZXKrXgbsPI9LRW6My0v3xCNopM942Fq42DLjGx6K01c1Eh9tjMP9UcShlY3UT
B7Tr9yHbNSF1P8qBrhuBvaZSTt0sBmbGxZaBzdldwKSypMrz0812wcvRDPcXz1NW
zQkyQ9w1kKJh/4ZNObwSwrrB1AhInrFnnfH6bUpIw+bkO0AD0lqL+pgy+KOkwmiV
+TWuNkD+MyKeNl4SJfSYjvn77CQ6Pc7dxJ6ALiAVfC/kCakNSWnqbQHL+C+fvMNi
c5zqL4LjyKb7WsH45olUDRrPTiWHGpEdjBIIRTyn2TQcAPl240+sWojEW1noX/v2
C5eOJTwrd1cWvkhThX3UuDcJtujKuhtpoKgO8w5tkvZbOsJ5pxPJkFad72fdJNkr
oFq68iJv18oZ9JyeFNACRwHQDvE1P05dDx1OO4C8ck2VUNufTTKKF5+3pFsgc4PU
aD7/IG8okC3yJ8U6/TNMt/VmVtY/MqtGMmNjrO5J2wnc0YUGGPw8BPkspV256rIm
LAAcV2HGTPU=
=es4E
-----END PGP SIGNATURE-----

--Ycz6tD7Th1CMF4v7--
