Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:42904 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbbIZHq2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Sep 2015 03:46:28 -0400
Date: Sat, 26 Sep 2015 12:46:26 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Marcel Bischoff <marcel@herrbischoff.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Too many missing devices, writeable mount is not allowed
Message-ID: <20150926124626.6aee7e52@natsu>
In-Reply-To: <20150925214544.GB4639@herrbischoff.com>
References: <20150925214544.GB4639@herrbischoff.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/H+R_XGZBD6iYoFEaiursNNL"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/H+R_XGZBD6iYoFEaiursNNL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Sep 2015 23:45:44 +0200
Marcel Bischoff <marcel@herrbischoff.com> wrote:

> Hello all,
>=20
> I have kind of a serious problem with one of my disks.
>=20
> The controller of one of my external drives died (WD Studio). The disk=20
> is alright though. I cracked open the case, got the drive out and=20
> connected it via a SATA-USB interface.
>=20
> Now, mounting the filesystem is not possible. Here's the message:
>=20
> $ btrfs fi show
> warning devid 3 not found already
> Label: none  uuid: bd6090df-5179-490e-a5f8-8fbad433657f
>         Total devices 3 FS bytes used 3.02TiB
>         devid    1 size 596.17GiB used 532.03GiB path /dev/sdd
>         devid    2 size 931.51GiB used 867.03GiB path /dev/sde
>         *** Some devices missing
>=20
> Yes, I did bundle up three drives with very different sizes with the=20
> --single option on creating the file system.
>=20
> I have already asked for help on StackExchange but replies have been=20
> few. Now I thought people on this list, close to btrfs development may=20
> be able and willing to help. This would be so much appreciated.
>=20
> Here's the issue with lots of information and a record of what I/we have=
=20
> tried up until now:=20
> http://unix.stackexchange.com/questions/231174/btrfs-too-many-missing-dev=
ices-writeable-mount-is-not-allowed

What I find confusing about that post, is ...okay, sdd and sde are in the
filesystem alright. But which drive is the problematic one? You never
explicitly mention that. Then you proceed to post xxd dumps of sdb(!), and
also "strings | grep" and partition listing of sdc(!!!). So which is it, sdb
or sdc, or are you unsure at this point.

Also post stuff directly to the mailing list, as websites go away with time,
whereas the mail archives can be more resilient. (Not to mention asking thi=
ngs
like these on "stackoverflow" is a bit like expecting a useful answer on
Ubuntu Forums).

--=20
With respect,
Roman

--Sig_/H+R_XGZBD6iYoFEaiursNNL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlYGTVIACgkQTLKSvz+PZwjUVwCdGW58Wmqos2ehmKTEK9F1jLit
IYoAnikhlJsM+sVyXI1SvqApeJFJ8VTI
=er6G
-----END PGP SIGNATURE-----

--Sig_/H+R_XGZBD6iYoFEaiursNNL--
