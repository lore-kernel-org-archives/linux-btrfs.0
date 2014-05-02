Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51652 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaEBVIj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 May 2014 17:08:39 -0400
Date: Fri, 2 May 2014 22:08:35 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Help with space
Message-ID: <20140502210835.GC24298@carfax.org.uk>
References: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com>
 <2809235.lZD2oazSeA@xev>
 <pan$e723c$9c5c686c$f2068dd4$dd71b519@cox.net>
 <201405021148.07577.russell@coker.com.au>
 <pan$b29aa$ed2c5b17$e83ea42c$5e85b880@cox.net>
 <286235B8-24FE-4935-AC13-DB98F1358E32@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Izn7cH1Com+I3R9J"
In-Reply-To: <286235B8-24FE-4935-AC13-DB98F1358E32@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Izn7cH1Com+I3R9J
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 02, 2014 at 01:21:50PM -0600, Chris Murphy wrote:
>=20
> On May 2, 2014, at 2:23 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> >=20
> > Something tells me btrfs replace (not device replace, simply replace)=
=20
> > should be moved to btrfs device replace=E2=80=A6
>=20
> The syntax for "btrfs device" is different though; replace is like balanc=
e: btrfs balance start and btrfs replace start. And you can also get a stat=
us on it. We don't (yet) have options to stop, start, resume, which could m=
aybe come in handy for long rebuilds and a reboot is required (?) although =
maybe that just gets handled automatically: set it to pause, then unmount, =
then reboot, then mount and resume.
>=20
> > Well, I'd say two copies if it's only two devices in the raid1... would=
=20
> > be true raid1.  But if it's say four devices in the raid1, as is=20
> > certainly possible with btrfs raid1, that if it's not mirrored 4-way=20
> > across all devices, it's not true raid1, but rather some sort of hybrid=
=20
> > raid,  raid10 (or raid01) if the devices are so arranged, raid1+linear =
if=20
> > arranged that way, or some form that doesn't nicely fall into a well=20
> > defined raid level categorization.
>=20
> Well, md raid1 is always n-way. So if you use -n 3 and specify three devi=
ces, you'll get 3-way mirroring (3 mirrors). But I don't know any hardware =
raid that works this way. They all seem to be raid 1 is strictly two device=
s. At 4 devices it's raid10, and only in pairs.
>=20
> Btrfs raid1 with 3+ devices is unique as far as I can tell. It is somethi=
ng like raid1 (2 copies) + linear/concat. But that allocation is round robi=
n. I don't read code but based on how a 3 disk raid1 volume grows VDI files=
 as it's filled it looks like 1GB chunks are copied like this
>=20
> Disk1	Disk2	Disk3
> 134		124		235
> 679		578		689
>=20
> So 1 through 9 each represent a 1GB chunk. Disk 1 and 2 each have a chunk=
 1; disk 2 and 3 each have a chunk 2, and so on. Total of 9GB of data takin=
g up 18GB of space, 6GB on each drive. You can't do this with any other rai=
d1 as far as I know. You do definitely run out of space on one disk first t=
hough because of uneven metadata to data chunk allocation.

   The algorithm is that when the chunk allocator is asked for a block
group (in pairs of chunks for RAID-1), it picks the number of chunks
it needs, from different devices, in order of the device with the most
free space. So, with disks of size 8, 4, 4, you get:

Disk 1: 12345678
Disk 2: 1357
Disk 3: 2468

and with 8, 8, 4, you get:

Disk 1: 1234568A
Disk 2: 1234579A
Disk 3: 6789

   Hugo.

> Anyway I think we're off the rails with raid1 nomenclature as soon as we =
have 3 devices. It's probably better to call it replication, with an assume=
d default of 2 replicates unless otherwise specified.
>=20
> There's definitely a benefit to a 3 device volume with 2 replicates, effi=
ciency wise. As soon as we go to four disks 2 replicates it makes more sens=
e to do raid10, although I haven't tested odd device raid10 setups so I'm n=
ot sure what happens.
>=20
>=20
> Chris Murphy
>=20

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
               --- Prisoner unknown:  Return to Zenda. ---              =20

--Izn7cH1Com+I3R9J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU2QJU1heFHXiqx3kAQLkAg/+IOWSsYdHNIHNiFw7fpjkbfOwQr5d6LrS
aUdte9W62diy8QCitO6hmw9mdS0XS8l+9y6XdPR44BcFvSH8X+isiDyTwvQT11+0
Pc3ZDNexHE6xN92Yl+nOMAMhc9cdytvVxlSG1tG+208UvMS36SYKPJopDhavNcXC
oZRpEiWwjLpfbvXCyOaJT49AlgvsM/YuAt7TGJVyKyohFnXwjGzUxKHag5ab6TJJ
PmJuG7hzHGo/9VvoMRfgs9N4jUnGui+i6IJQbzlWcpdDpVjHrqyvYDN7A5VyzEGt
bRdfpmBz0SoVjMD0sRHAf39fHS2JYjc/Kzv7367OdODVj5I2H/EOXHM+XW7e1Tyf
85n0B7TGA1A+HUoeRSp9dpzNi/ybitPYjiNxHO6sb/VTuuvqQzjemKWx5qEtXP9K
O/kViF35EuNHeGZaapnwI/yxgDcMWmW/wXdJzF0jsTdyD+td+xGBSeKa2pkpv8sY
7FFxrHWG1VNiuKy6rXJcngr1FaXjIvmLLOzdgEjCAvPRWwQe4VmIEi8ZEx3M6Euv
0tlQMEPvC60K4hIEY/OTCpuBwFJ9kNWV9JsWnoNxs2Vhapzz7ok/SE/fHX+edqFt
QCXmSBYs75gM9f93Xq8DdEqqq8lA+JXsuGLe+SKb+0DbrlgIMbSpt4n6iOxxXl8h
ZDfSHLhwXfs=
=ALbA
-----END PGP SIGNATURE-----

--Izn7cH1Com+I3R9J--
