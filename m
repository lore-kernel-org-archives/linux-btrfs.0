Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:48804 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbbIQTCI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 15:02:08 -0400
Received: from natsu (unknown [IPv6:fd39::e9:9eff:fe8f:1bcf])
	by meiko.romanrm.net (Postfix) with SMTP id 21A2FAC82C
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2015 19:02:06 +0000 (UTC)
Date: Fri, 18 Sep 2015 00:02:05 +0500
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: RAID1 storage server won't boot with one disk missing
Message-ID: <20150918000205.6e8f3998@natsu>
In-Reply-To: <55FAF198.2060106@libero.it>
References: <CAPQXdDQzkQsJrRJH3+c0x93ogDPge_hjHyW1CZ-FQRAdoMaGoA@mail.gmail.com>
	<55FAD9CC.5060206@oracle.com>
	<55FAF198.2060106@libero.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/mE18m7TpqO62a4uhiYq4RIr"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/mE18m7TpqO62a4uhiYq4RIr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Sep 2015 19:00:08 +0200
Goffredo Baroncelli <kreijack@libero.it> wrote:

> On 2015-09-17 17:18, Anand Jain wrote:
> >  it looks like -o degraded is going to be a very obvious feature,
> >  I have plans of making it a default feature, and provide -o
> >  nodegraded feature instead. Thanks for comments if any.
> >=20
> I am not sure if there is a "good" default for this kind of problem

Yes there is. It is whatever people came to expect from using other RAID
systems and/or generally expect from RAID as a concept.

Both mdadm software RAID, and I believe virtually any hardware RAID control=
ler
out there will let you to successfully boot up and give read-write(!) access
to a RAID in a non-critical failure state, because that's kind of the whole
point of a RAID, to eliminate downtime. If the removed disk is later re-add=
ed,
then it is automatically resynced. Mdadm can also make use of its 'write
intent bitmap' to resync only those areas of the array which were in any way
touched during the absence of the newly re-added disk.

If you're concerned that the user "misses" the fact that they have a disk
down, then solve *that*, make some sort of a notify daemon, e.g. mdadm has a
built-in "monitor" mode which sends E-Mail on critical events with any of t=
he
arrays.

--=20
With respect,
Roman

--Sig_/mE18m7TpqO62a4uhiYq4RIr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlX7Di0ACgkQTLKSvz+PZwiyOwCeMihaiY+OG3J5EYyA59hox0il
m80AnAj+8RLG9y8Wr5VsFBU1GrHjo043
=JuOs
-----END PGP SIGNATURE-----

--Sig_/mE18m7TpqO62a4uhiYq4RIr--
