Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:49728 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751829AbcLFO4J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Dec 2016 09:56:09 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx102
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0LtDpH-1cgR9015ad-012tPq for
 <linux-btrfs@vger.kernel.org>; Tue, 06 Dec 2016 15:55:29 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [SOLVED] Re: system hangs due to qgroups
Date: Tue, 06 Dec 2016 15:55:24 +0100
Message-ID: <1615257.2oeV6PA6UW@thetick>
In-Reply-To: <2186923.2Z4iRAdtdf@thetick>
References: <1776088.42rHLKPlSp@thetick> <593ee12d-a353-d834-2390-a68aaf6377a8@cn.fujitsu.com> <2186923.2Z4iRAdtdf@thetick>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart98737669.x8Ms5CtC6q"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart98737669.x8Ms5CtC6q
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Tuesday 06 December 2016 11:12:12 Marc Joliet wrote:
> I have disabled quotas already (first thing I did after
> mounting).  However,  there were definitely 20-30, maybe more (enough=
 for
> 2, maybe 3, console pages -- I don't know how many lines the initramf=
s
> rescue shell has, but based on that, you could estimate the number of=

> qgroups).

Of course, you can probably check the sanitized images I posted for mor=
e=20
information.

=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart98737669.x8Ms5CtC6q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYRtFcAAoJEL/Q5oYsiHj0UgsQAJNw+IjmHNMiWk5/gVl6YrYi
tn2+AxMLGR7OHbtt229LoZc2xBunjM4Z41OrIli71u1BswgdAuCYEkt2rBo4sGi7
lnuafgFDgUAI13jlQAQSmjgO58iae9gHESVvd1JEESrCYSvtiJ4+EXlXBKbc/4Ll
6fXd62c8io/cX+yv+DjdwmkDHqCCDaVlrSlLu7YDZy3nXvSE/Woz27vR88EP3Kbf
euCJPCEV+lsSGnQL5NOsbgby9ckUuZrpTj3pOiLFBIk+gP/0E9kBK8wsi5flcPFt
Tx9fNeE1LDcy0pE6zp8retaeBzAuMWFTssHYG0y8Di0q13GSguahnD7Ra265t3hp
/gPOLksTKRKFQUHbLkzpN6C2+ccx1ZFaiPyDSVsU+RvlcINo/WdlbTkDJZFjtSHB
lpRnZ4HF7Mb7nRfWiYIrE6w8b7Daqt37T0zat8SahJyEY2j+eLi7AOAys9gx42kc
g/F0OAPYoew4zifTGLmI9PDyLWiEUwg7w7yQBaMRVgRiMP37fIktwARoQG+FCUSK
gTie3GWiSzys2XZNFemUzPXwCxVyqlcBbqxqqSIYIZd4ZzMH64YLKR6Vadn9vaTs
4yoMiEcucNt9l90Hdj6b8VtzY7mwb6Sc9Zh2x4U9xNZu6kJ96JOoZivu7pXHSqOq
7gDHZCpDphY3+JjIjjA1
=ZtOc
-----END PGP SIGNATURE-----

--nextPart98737669.x8Ms5CtC6q--

