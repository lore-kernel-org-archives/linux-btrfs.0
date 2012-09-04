Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45779 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932467Ab2IDRRI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Sep 2012 13:17:08 -0400
Date: Tue, 4 Sep 2012 18:17:01 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Petr =?iso-8859-1?Q?Tich=FD?= <spaceboy@mac.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is my btrfs full?
Message-ID: <20120904171701.GJ21990@carfax.org.uk>
References: <2878656B-C9CF-4055-8378-5F000BE84489@mac.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYo4Elh1vtcYNvbq"
In-Reply-To: <2878656B-C9CF-4055-8378-5F000BE84489@mac.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--zYo4Elh1vtcYNvbq
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 04, 2012 at 06:07:50PM +0200, Petr Tich=FD wrote:
> I have a 130 GB btrfs with rsnapshot-like backups mounted with
> compressoin=3Dzlib and now I'm getting ENOSPC, while df shows only
> some 60 % used. I'm running Linux version 3.2.0-3-amd64 (Debian
> 3.2.23-1). Is my btrfs really full? Will a more recent kernel solve
> this?

   We strongly recommend using the latest available kernel (currently
3.5 or 3.6-rc4) if you're running btrfs. The code is still moving very
quickly, and the main devs are still finding and fixing fairly serious
bugs.

> root@roura:~# btrfs filesystem show --all-devices
> Label: none  uuid: 12880174-8337-47bc-be05-f485a0b7503f
> 	Total devices 1 FS bytes used 72.67GB
> 	devid    1 size 130.00GB used 130.00GB path /dev/sdd

   You may want to read about df[1], and then about ENOSPC errors[2].

   If you've still got questions after that, please do come back and
ask them.

   Hugo.

[1] https://btrfs.wiki.kernel.org/index.php/FAQ#Why_does_df_show_incorrect_=
free_space_for_my_RAID_volume.3F
[2] https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_get_.22No_space_l=
eft_on_device.22_errors.2C_but_df_says_I.27ve_got_lots_of_space

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Geek, n.: Circus sideshow performer specialising in the ---    =20
                         eating of live animals.                        =20

--zYo4Elh1vtcYNvbq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFQRjeNIKyzvlFcI40RAhuXAJ9vdVUBS/xDbXSZFz134Hay/gDATACeJVBw
iJQU52AwflyY65htiO1OPVo=
=c2fP
-----END PGP SIGNATURE-----

--zYo4Elh1vtcYNvbq--
