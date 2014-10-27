Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:49435 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbaJ0Bab (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Oct 2014 21:30:31 -0400
Received: from marcec.fritz.box ([93.181.44.4]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0LjIit-1YEcN01mBj-00dYZE for
 <linux-btrfs@vger.kernel.org>; Mon, 27 Oct 2014 02:30:29 +0100
Date: Mon, 27 Oct 2014 02:30:23 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Poll: time to switch skinny-metadata on by default?
Message-ID: <20141027023023.0732985a@marcec.fritz.box>
In-Reply-To: <20141025215808.1ad14aa0@marcec>
References: <20141016113337.GC22943@twin.jikos.cz>
	<20141020163403.GW22943@twin.jikos.cz>
	<20141025142458.5d96970b@marcec>
	<20141025215808.1ad14aa0@marcec>
Reply-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/5QsZbf8zHduCpEbYGaWiBmt"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/5QsZbf8zHduCpEbYGaWiBmt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Sat, 25 Oct 2014 21:58:08 +0200
schrieb Marc Joliet <marcec@gmx.de>:

> Am Sat, 25 Oct 2014 14:24:58 +0200
> schrieb Marc Joliet <marcec@gmx.de>:
>=20
> > I can still access files on MARCEC_BACKUP just fine, and the snapshots =
are
> > still there ("btrfs subvolume list" succeeds).
>=20
> Just an update: that was true for a while, but at one point listing direc=
tories
> and accessing the file system in general stopped working (all processes t=
hat
> touched the FS hung/zombified). This necessitated a hard reboot, since "r=
eboot"
> and "halt" (so... "shutdown", really) didn't do anything other than spit =
out the
> usual "the system is rebooting" message.
>=20
> Interestingly enough, the file system was (apparently) fine after that (j=
ust as
> Petr Janecek wrote), other than an invalid space cache file:
>=20
>   [   65.477006] BTRFS info (device sdg2): The free space cache file
>   (2466854731776) is invalid. skip it
>=20
> That is, running my backup routine worked just as before, and I can access
> files on the FS just fine.
>=20
> Oh, and apparently the rebalance continued successfully?!
>=20
>   [  342.540865] BTRFS info (device sdg2): continuing balance
>   [  342.599991] BTRFS info (device sdg2): relocating block group 2502355=
320832
>   flags 34 [  342.821608] BTRFS info (device sdg2): found 4 extents
>   [  343.056915] BTRFS info (device sdg2): relocating block group 2501818=
449920
>   flags 36 [  437.932405] BTRFS info (device sdg2): found 25086 extents
>   [  438.727197] BTRFS info (device sdg2): relocating block group 2501281=
579008
>   flags 36 [  557.319354] BTRFS info (device sdg2): found 83875 extents
>=20
>   # btrfs balance status /media/MARCEC_BACKUP
>   No balance found on '/media/MARCEC_BACKUP'
>=20
> No SEGFAULT anywhere. All I can say right now is "huh". Although I'll try
> starting a "balance -m" again tomorrow, because the continued balance only
> took about 3-4 minutes (maybe it .

Maybe it exploded, I don't know (sorry, clearly I didn't delete the entiret=
y of
that incomplete train of thought).

Anyway, I did run a full "balance -m" again, and this time it finished
successfully.  Make of that what you will, but it appears that the bug is
non-deterministic (makes me wonder if Petr Janecek or anybody else who hit =
the
bug ever got a balance to finish).

HTH
--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/5QsZbf8zHduCpEbYGaWiBmt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUTaAzAAoJEL/Q5oYsiHj0ZT4QAJXzG1yttWLMPhyE9rBFwxmq
Q/JIQI2EMvFf7AVSjyo82Uw/nPegejXTrL4l5q3ovVpcSFEru8lOEv3OQVvYgsDT
YN5S6EFUJ0Zlmqf1rKlquKoBhGFvflKmQMx7Vku72vs6G3kipts21jwBiOHJu2yR
11GURgxXpuEYKiABvybglp2CqipSlXPaOuO6R+ByRUsi8CHaw9amte7IpRH3KrIQ
k59b633m90nmIJ7/dLW9CFReWY3C1/WYGF7lhvy4FKfIqERE9WpK0+ncWNw82/Ct
aDJ0jFvf9IIMbTjTgJMG+LalAmfPJnxP4ymt50D6mTGRIKgs+FLqsvQ0RWcE2k0l
Q7Yjjlgu004fv5mtPFuila6Gv8s7ZqHLWbx96dNxJ3ITEhnChfTMnor2/jM8CSqB
lE4/ldh7dwj6BDluSZnUeVkcuNQG1ibJbkho+OwCfHPhGEe4QnWBzknKp4FHQo+V
Su+G4n1hA6u62l/D0hhqfiXnWTtOlanR1MPviF4+SfItzqU/P+3/bAjlZk4V2677
YuHs/p+dV9ehPIGPvH4/CMEq2qa4sEkFW6yuY3Orxroo7w5iNOaQBI7xBa/aKakx
ZDyquYEWscOAQuU7sh8ZRlXkYu+TqoOEGezMZ4+misU482YHvS3nRmpFKR0qCPN4
swzOeE2zvW6Pm7CXmvrm
=yaK6
-----END PGP SIGNATURE-----

--Sig_/5QsZbf8zHduCpEbYGaWiBmt--
