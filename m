From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: [Bug #27842] [regression?] hang with 2.6.37 on a BTRFS test machine
Date: Thu, 3 Feb 2011 12:20:32 +0100
Message-ID: <201102031220.46250.Martin@lichtvoll.de>
References: <e9vOd5LzdBK.A.dyD.h6eSNB@chimera> <-tcJxClTQPH.A.Z6D.r6eSNB@chimera> (sfid-20110203_112437_013428_B5BE5937)
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3828921.La06qhQMa0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Florian Mickler <florian@mickler.org>,
	linux-btrfs@vger.kernel.org, "Helmut Hullen" <Hullen@t-online.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <-tcJxClTQPH.A.Z6D.r6eSNB@chimera>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart3828921.La06qhQMa0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Added linux-btrfs and Helmut Hullen, who seemed to experience hangs on a=20
T23 with BTRFS as well, to Cc.

Am Thursday 03 February 2011 schrieb Rafael J. Wysocki:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.36 and 2.6.37.
>=20
> The following bug entry is on the current list of known regressions
> introduced between 2.6.36 and 2.6.37.  Please verify if it still should
> be listed and let the tracking team know (either way).
>=20
>=20
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D27842
> Subject		: [regression?] hang with 2.6.37 on a BTRFS test machine
> Submitter	: Martin Steigerwald <Martin@lichtvoll.de>
> Date		: 2011-01-23 12:06 (11 days old)
> Message-ID	: <201101231306.23069.Martin@lichtvoll.de>
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D129578445613283&w=3D2

Well I now tested with 2.6.36 for more than a week and I did not see any=20
of such hangs upto now. The machine seems table with 2.6.36. So I think=20
its really an regression of 2.6.37.

I am stuck with what to try next. Since trying to track it down to a=20
specific commit appears too involved for me and its appears also quite=20
laborious to get any value debug information out of the kernel - cause it=20
can take days for the bug to appear -, I am inclined to either test with=20
2.6.37.1 once its available or just give it a go with 2.6.38-rc3 or rc4.=20
Maybe 2.6.38-rc3/4 would be the best bet, I have seen a report on the=20
btrfs mailing list of 2.6.38 fixing a BTRFS hang bug that appeared with=20
2.6.37. I am just not sure whether its related or not.

Re: [PATCH v2]Btrfs: pwrite blocked when writing from the mmaped buffer of=
=20
the same page
http://marc.info/?l=3Dlinux-btrfs&m=3D129623925116051&w=3D2

There is another thread about 2.6.37 related BTRFS hang:

flush-btrfs-1 hangs when building openwrt
http://marc.info/?l=3Dlinux-btrfs&m=3D129594547616298&w=3D2

I will add this as comment to the bug report as well.

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart3828921.La06qhQMa0
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk1Kj4EACgkQmRvqrKWZhMdk9gCfZZcf69afgP2DUObZPHUDJ1HY
1f4AnRvhJowclcaBCaObuXaDnERtk+el
=qjQi
-----END PGP SIGNATURE-----

--nextPart3828921.La06qhQMa0--
