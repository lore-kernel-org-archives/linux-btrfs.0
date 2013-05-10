Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41770 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab3EJVqV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 May 2013 17:46:21 -0400
Date: Fri, 10 May 2013 22:46:18 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Marcus =?iso-8859-1?Q?L=F6vgren?= <marcuslvgrn@gmail.com>
Cc: Remco Hosman - Yerf IT <remco@yerf-it.nl>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs balance invalid argument error
Message-ID: <20130510214618.GG26072@carfax.org.uk>
References: <CAB_++mrnzWd9BNHMEK=k7rVdV1x+VjX7JW2ANnEaJ_i1PG-rUA@mail.gmail.com>
 <20130510202126.GE26072@carfax.org.uk>
 <2549B5BE-9254-4E57-A7F1-82CAD2EE0E30@yerf-it.nl>
 <CAB_++moSXQVBq=dLKHiUk3acL6Rhn9r1BAdPAFb+FphrzjHD2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RMedoP2+Pr6Rq0N2"
In-Reply-To: <CAB_++moSXQVBq=dLKHiUk3acL6Rhn9r1BAdPAFb+FphrzjHD2Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--RMedoP2+Pr6Rq0N2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 10, 2013 at 11:43:34PM +0200, Marcus L=F6vgren wrote:
> Yes, you were right! Adding another drive to the array made it continue
> without errors. Is this already reported as a bug?

   I believe it has been, yes. I think we've even had a patch out for
it. I haven't looked to see if it's got into 3.10.

   Hugo.

> Thanks for the help,
> Marcus
>=20
>=20
> 2013/5/10 Remco Hosman - Yerf IT <remco@yerf-it.nl>
>=20
> > On May 10, 2013, at 10:21 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >
> > > On Fri, May 10, 2013 at 10:07:56PM +0200, Marcus L=F6vgren wrote:
> > >> Hi list,
> > >>
> > >> I am using kernel 3.9.0, btrfs-progs 0.20-rc1-253-g7854c8b.
> > >>
> > >> I have a three disk array of level single:
> > >>
> > >> # btrfs fi sh
> > >> Label: none  uuid: 2e905f8f-e525-4114-afa6-cce48f77b629
> > >>        Total devices 3 FS bytes used 3.80TB
> > >>        devid    1 size 2.73TB used 2.25TB path /dev/sdd
> > >>        devid    2 size 2.73TB used 1.55TB path /dev/sdc
> > >>        devid    3 size 2.73TB used 0.00 path /dev/sdb
> > >>
> > >> Btrfs v0.20-rc1-253-g7854c8b
> > >>
> > >> # btrfs fi df /mnt/data
> > >> Data: total=3D3.79TB, used=3D3.79TB
> > >> System: total=3D4.00MB, used=3D420.00KB
> > >> Metadata: total=3D6.01GB, used=3D4.87GB
> > >>
> > >>
> > >> When running
> > >> # btrfs balance start -dconvert=3Draid5 -mconvert=3Draid5 /mnt/data
> > >>
> > >> I get
> > >>
> > >> ERROR: error during balancing '/mnt/data' - Invalid argument
> > >> There may be more info in syslog - try dmesg | tail
> > >>
> > >> dmesg | tail says:
> > >>
> > >> btrfs: unable to start balance with target data profile 128
> > >>
> > >> Isn't it possible to convert raid level to raid5?
> > >
> > >   Yes, it should be possible. It looks like the kernel's got a
> > > problem with it, which is odd because 3.9 should know about RAID-5.
> > >
> >
> > Wasn't there some issues that the kernel or tools wanted 4 disks when
> > converting to raid5?
> >
> > Remco
> >
> > >   Hugo.
> > >

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                       --- Strive for apathy! ---                       =20

--RMedoP2+Pr6Rq0N2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUY1qqlheFHXiqx3kAQKxYRAAj4EKUiICdawSuzozOE7PwSVVvf7CH9HH
iUSFAF4gNK2dXyenbNMG6Pon1lUMGjN62Ot3KUKvabFc6+93QW8dN2YYOQEuIZZT
nKvwaCgs/t+2iz2i4piXqupWXQWBbD2iVEWY9P7OlMMObc0IGha72oZMwJyQalc4
X5wPkFrebLYfqb4OOJxqd1VGAjH5CwJSTsIIMPwAeFiicaBJ0kidXCF1TrupTY4P
bawQIf255l+B8HCJ2IdF4PEX616q1pHxY5ee8/BrhgvRGPx02RTF8x+br/2PxZC8
ceExP4877XjgHYIeNFSWptZtYGB20HL7saCjvbfn4Jj3maywR0dz893HyNgWBDGX
shHaUKmmrNbsc3Iz7q/5eVqEJKx7fRbfbNbQwG/uuLwOHEvTUh5wXazgiKe1s5jd
gOIhkJQTyJd7mp8USliGWRCIlALFLNNIAHP39k5JpWQWVoRFQb5OupkqxBLGoSsV
xbI0Xiridm4rTOvKYhNuS5ClluHkS0UAj136nSQNQs57tMfSfeL8f3KfkrTAHdUs
Lpt4wO9B6kyU9+HIsdn5JGDLcwdvWzzFOhMs4SMP3IIb4P1d077p5epFbJBAuxWM
7TniDP6/7tMEnf3cJ/C+ELOu1dUktwbpy+vqDrDKCZpvhBL6xiQysBuif7RsU2pP
WwTGCHj1Jpo=
=pj34
-----END PGP SIGNATURE-----

--RMedoP2+Pr6Rq0N2--
