From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: btrfs on ssd and hdd
Date: Sat, 14 Jan 2012 21:18:45 +0600
Message-ID: <20120114211845.38888a94@natsu>
References: <1289964295.1201326553279203.JavaMail.root@shiva>
	<772574965.1221326553343545.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/v2hSt5rn.qFzO12JiSWY9wh"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org
To: luvar@plaintext.sk
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <772574965.1221326553343545.JavaMail.root@shiva>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/v2hSt5rn.qFzO12JiSWY9wh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 14 Jan 2012 16:02:23 +0100 (GMT+01:00)
luvar@plaintext.sk wrote:

> I am using for my workspace btrfs filesystem on ssd disk. I do not thrust=
 to my ssd and I want to have backup of all data on rotational hdd (raid5 o=
f 5 disks). If I am not wrong, this can be done when I use btrfs on top of =
two phycical media (one ssd and second md device). This I think would work =
fine.
>=20
> My question is, does btrfs recognize poor latency of md device and will p=
reform most reads from ssd? (I want to set raid1 for metadata and also to d=
ata). (side question, should be ssd in parameters of mount?)
>=20
> PS: Is this crazy idea, or normal (planned) usecase?

Hello,

This is not a crazy idea, and it's already possible in MD-based RAID.
Run 'man md' and 'man mdadm' and do a search for 'write-mostly' to read mor=
e about it.

However I don't think the same feature has been implemented in BTRFS yet.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/v2hSt5rn.qFzO12JiSWY9wh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8RnNUACgkQTLKSvz+PZwiGOgCfR6xH9qjR7IecR3E/33E/Lbh0
aVkAni6vx1iNfk5bpIK84b6o8kmaKnYx
=lkrp
-----END PGP SIGNATURE-----

--Sig_/v2hSt5rn.qFzO12JiSWY9wh--
