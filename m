Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51219 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbbIYKGe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 06:06:34 -0400
Date: Fri, 25 Sep 2015 10:06:33 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?utf-8?B?VmFja8OhxZkgRnJhbnRpxaFlaw==?= <vackarf@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs check dont repair
Message-ID: <20150925100633.GE3749@carfax.org.uk>
References: <CAMH1C+r4yYU8hYfcZpFRyN1UWY8OPTs5Md7MdE=bm2RW9udREQ@mail.gmail.com>
 <20150923144334.GP5918@carfax.org.uk>
 <CAMH1C+qz76gDf=xPyph3C-PPHsHegc6L4o7LtOa7oY6QYtE8Gw@mail.gmail.com>
 <CAMH1C+qQkDrHxk1HLwqupjbrSNZvhZdOX0v78EQ=5pP+pc4R4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rgf3q3z9SdmXC6oT"
In-Reply-To: <CAMH1C+qQkDrHxk1HLwqupjbrSNZvhZdOX0v78EQ=5pP+pc4R4Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Rgf3q3z9SdmXC6oT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 25, 2015 at 11:36:55AM +0200, Vack=C3=A1=C5=99 Franti=C5=A1ek w=
rote:
> Now I have memory ok.
>=20
> I found this patch, but i am not sure, if its the correct one.
> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg33496.html
>=20
> Cay you help me please, witch patch i should use?

   Yes, that's the patch series (you'll need all three patches). David
Sterba said it didn't apply cleanly any more; I don't know how hard
it'll be to fix up the problems, though.

   Hugo.

> Frantisek
>=20
> 2015-09-23 17:22 GMT+02:00 Vack=C3=A1=C5=99 Franti=C5=A1ek <vackarf@gmail=
=2Ecom>:
> > Yes, I have bad ram. I ran memtest and memory is really bad.
> >
> > So a must buy new memory first.
> >
> > Thank you.
> >
> > Frantisek
> >
> > 2015-09-23 16:43 GMT+02:00 Hugo Mills <hugo@carfax.org.uk>:
> >> On Wed, Sep 23, 2015 at 04:39:27PM +0200, Vack=C3=A1=C5=99 Franti=C5=
=A1ek wrote:
> >>> Hello,
> >>>
> >>> i have problem with my btrfs, can you help me, please? Its on my
> >>> notebook. Sometimes it exhausted battery during sleep and died. But
> >>> everytime FS was ok. But ones mount fail.
> >>>
> >>> Do you have any idea how repair it?
> >> [snip]
> >>> [root@rak ~]# dmesg | tail
> >> [snip]
> >>> [ 4108.444472] BTRFS critical (device sdb2): corrupt leaf, bad key
> >>> order: block=3D3242455040,root=3D1, slot=3D0
> >>
> >>    You have bad RAM. You should run memtest and fix the hardware first.
> >>
> >>    After that, there's some patches that should allow btrfs repair to
> >> fix bad key orders in most situations -- I think David was picking
> >> them up again, but I don't know what state they're in right now.
> >>
> >>    Hugo.
> >>
> >>> [ 4108.444649] BTRFS critical (device sdb2): corrupt leaf, bad key
> >>> order: block=3D3242455040,root=3D1, slot=3D0
> >>> [ 4108.444681] BTRFS error (device sdb2): Error removing orphan entry,
> >>> stopping orphan cleanup
> >>> [ 4108.444684] BTRFS error (device sdb2): could not do orphan cleanup=
 -22
> >>> [ 4111.047323] BTRFS: open_ctree failed
> >>>
> >>> [root@rak ~]# uname -a
> >>> Linux rak 4.1.2-2-ARCH #1 SMP PREEMPT Wed Jul 15 08:30:32 UTC 2015
> >>> x86_64 GNU/Linux
> >>>
> >>> [root@rak ~]# btrfs fi show /dev/sdb2
> >>> Label: 'data'  uuid: 754a3186-c0ae-4680-ab28-864c8bdad8b5
> >>>         Total devices 1 FS bytes used 1.23TiB
> >>>         devid    1 size 1.72TiB used 1.24TiB path /dev/sdb2
> >>>
> >>> btrfs-progs v4.2
> >>>
> >>> [root@rak ~]# btrfs --version
> >>> btrfs-progs v4.2
> >>>
> >>> [root@rak ~]#   btrfs fi show
> >>> Label: 'data'  uuid: 754a3186-c0ae-4680-ab28-864c8bdad8b5
> >>>         Total devices 1 FS bytes used 1.23TiB
> >>>         devid    1 size 1.72TiB used 1.24TiB path /dev/sdb2
> >>>
> >>> btrfs-progs v4.2
> >>

--=20
Hugo Mills             | Do not meddle in the affairs of wizards, for they
hugo@... carfax.org.uk | are subtle, and quick to anger.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                        J.R.R. Tolk=
ein

--Rgf3q3z9SdmXC6oT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWBRypAAoJEFheFHXiqx3khZYP/2/yKhtY51jlZ2tfFeulY+ar
8K3XN/Aa82RtjwTJtdYwufU86ZqC2VP/W6eBCVdS+TzarSNQFyjn9rFyOZVl19xu
7SzzbVeAoIML1PJDvjYv8ZVxbGZLQ3mVNUKUyDl1ExacvIdTq4HXa6vcfWurQpJn
g/P1Jnvego8AbdvHVpitf86We2OhL11H9V1JVEkWm4VBbnhDELotUgYTjxiPAdHL
e5edzXsntk0R1ZG5TRDsZmMN6B5tZ6u5EFRVhMy+5cpJBR7wSUVmNRWeDKYeuwI4
IcOKWIr28rxYxlSuuCcdrcKm+YieQsPJU+Nk8AOhJ2/jYG+T9zHSYFzqEpGFwW3T
wffnypNxGo8oBjQ5I1CVkP5GjKACBfm/Q3AnQC3ZC4oqwrtUVLUkK3KC4sbB0NJJ
FR+6TWz/+v5t9Kdu35HTWd54Ld7mPDQrieV5gvlhJyp37mLXjbEmqXHt5aFmtlAS
Ppp2lDtqTr3JZSDCIopVCYga23814UXfJ9ETjqc1lRuUhcnENAp1qPh3r93Ink67
OcKuuz4eGjMqESdfFFAuX7TjlLCuvpW+09fuf9122aHO/PhbfwCYXfrd5MRaAkab
PM7LCPgfZZrBkg1l2IFt+cg0F6613fahIBbHAYV0lgyhX1ec4NBjSkp1xALlR/3L
7Nd8q0rZ5ViVEPCSaMhF
=nEJD
-----END PGP SIGNATURE-----

--Rgf3q3z9SdmXC6oT--
