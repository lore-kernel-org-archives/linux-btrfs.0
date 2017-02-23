Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.gocept.net ([195.62.125.19]:48078 "EHLO mail.gocept.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750891AbdBWLRG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Feb 2017 06:17:06 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.gocept.net (Postfix) with ESMTP id 5074B14C0465
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Feb 2017 11:51:46 +0100 (CET)
Received: from mail.gocept.net ([127.0.0.1])
        by localhost (mail.gocept.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5qyIoDPkeiTM for <linux-btrfs@vger.kernel.org>;
        Thu, 23 Feb 2017 11:51:45 +0100 (CET)
Received: from [10.102.89.6] (vpn-rzob.services.fcio.net [195.62.126.69])
        (Authenticated sender: ct@flyingcircus.io)
        by mail.gocept.net (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Feb 2017 11:51:45 +0100 (CET)
From: Christian Theune <ct@flyingcircus.io>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_791363C4-5FE9-4275-A04A-C01B5C50BD33";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Subject: Downgrading kernel 4.9 to 4.4 with space_cache=v2 enabled?
Message-Id: <BB064A3C-6F5C-4490-80A6-F42BEFAA945A@flyingcircus.io>
Date: Thu, 23 Feb 2017 11:51:45 +0100
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_791363C4-5FE9-4275-A04A-C01B5C50BD33
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi,

not sure whether it=E2=80=99s possible, but we tried space_cache=3Dv2 =
and obviously after working fine in staging it broke in production. Or =
rather: we upgraded from 4.4 to 4.9 and enabled the space_cache. Our =
production volume is around 50TiB usable (underlying HW Raid 6).

The machine crashes silently every 15 hours or so and takes _ages_ to =
reboot. It current is stuck trying to mount the local filesystems and I =
guess btrfs is doing something, but I don=E2=80=99t have shell access =
yet.

I=E2=80=99m wondering whether we can downgrade by booting back into 4.4 =
or will this break things even further? (We=E2=80=99ve had some =
unpleasant surprises with FS=E2=80=99 in the last months, so I thought =
I=E2=80=99d rather ask.)

Kind regards,
Christian

--
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 http://flyingcircus.io
Forsterstra=C3=9Fe 29 =C2=B7 06112 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian. =
Theune, Christian. Zagrodnick


--Apple-Mail=_791363C4-5FE9-4275-A04A-C01B5C50BD33
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQEcBAEBCgAGBQJYrr7BAAoJEKuh8lKpfGLOG4IIAN5zgEVLFWJnvDj3gn1cBZ3p
GVUGlExbxs/csLFJOOvRO6nw3SEB1okXr+1l/860QDNYAa6CBp39JR3d2P3bzbTx
cphh/ZGDMbstv51O/GsdW3G9eDnw5DDdiMIPo9H6q9QuobiLSS+5PcdTaotGUM2P
/DpHqwh5WKd0+30DjSiAzPLYP2uj8F1dzudWHFwbTLHGf/lCX7eWFOgT6DdUd317
7koflpsFXi+L/4ScXt1nfoh7Oh8En+/ov0zPQV0/NVmwfTREuvGhyzM9JEZjTgvQ
xgeCJk68697Z552sA4dABzi/ywBBfMpUV+ytVcbFj4uueaveSG+14I1DJczyGlI=
=Zpi+
-----END PGP SIGNATURE-----

--Apple-Mail=_791363C4-5FE9-4275-A04A-C01B5C50BD33--
