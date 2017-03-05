Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54028 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752442AbdCEXxq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 5 Mar 2017 18:53:46 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MH0eg-1cY0nc1Uuo-00Dkkr for
 <linux-btrfs@vger.kernel.org>; Mon, 06 Mar 2017 00:53:42 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [4.7.2] btrfs_run_delayed_refs:2963: errno=-17 Object already exists
Date: Mon, 06 Mar 2017 00:53:40 +0100
Message-ID: <2713353.CA3Dyp7XXF@thetick>
In-Reply-To: <14737660.8idzxVKBRv@thetick>
References: <20160828152908.6e1325b5@jupiter.sol.kaishome.de> <63cf74bb-009a-b422-4390-7562395db31d@cn.fujitsu.com> <14737660.8idzxVKBRv@thetick>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart27084655.57BtrpTxDt"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart27084655.57BtrpTxDt
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Mittwoch, 1. M=E4rz 2017 19:14:07 CET you wrote:
>  In any
> case, I started btrfs-check on the device itself.

*Sigh*, I had to restart it, because I forgot to redirect to a file and qui=
te=20
frankly wasn't expecting this flood of output, but here's a summary of the=
=20
output after about 2 days:

% wc -l btrfs_check_output_20170303.log=20
1360252 btrfs_check_output_20170303.log
% grep -v "backref lost" btrfs_check_output_20170303.log | grep -v "check \
(leaf\|node\) failed" | grep -v "lost its parent" | grep -v "referencer cou=
nt"=20
checking extents
ERROR: block group[3879328546816 1073741824] used 1072840704 but extent ite=
ms=20
used 1129164800
ERROR: block group[4163870130176 1073741824] used 1072259072 but extent ite=
ms=20
used 0
ERROR: block group[4223999672320 1073741824] used 1073664000 but extent ite=
ms=20
used 1074188288
ERROR: block group[4278760505344 1073741824] used 1073377280 but extent ite=
ms=20
used 1073901568
ERROR: block group[4406535782400 1073741824] used 1073627136 but extent ite=
ms=20
used 0
ERROR: extent [3830028140544 4096] referencer bytenr mismatch, wanted:=20
3830028140544, have: 3826183847936
% tail btrfs_check_output_20170303.log=20
ERROR: data extent[3924538445824 4096] backref lost
ERROR: data extent[3933464903680 4096] backref lost
ERROR: data extent[3924538531840 4096] backref lost
ERROR: data extent[3839131480064 4096] backref lost
ERROR: data extent[3834701750272 4096] backref lost
ERROR: data extent[3873087918080 4096] backref lost
ERROR: data extent[3873072283648 4096] backref lost
ERROR: data extent[3873088090112 8192] backref lost
ERROR: data extent[3873072287744 4096] backref lost
ERROR: data extent[3856294449152 4096] backref lost

That's right, slowly approaching 1.5 million lines of btrfs-check output! =
=20
That's *way* more than I ran it the last time this error happened a few wee=
ks=20
ago.

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--nextPart27084655.57BtrpTxDt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEax7Ya5gDQFOJHKGQv9DmhiyIePQFAli8pQQACgkQv9DmhiyI
ePTgVxAApZVIOyq7VZqI1fWHz0oqqlgYinASWeriENryEQiOcRAtrax6qOKDCpo7
+sH/p+23IOHa+2G7wZl+ZqB7yjTkGDqsABNy8Mj23/4WbcJka/UxysJp1uZrzxpE
8yAe2YvE9lANaxWDmok+BJGTYw6wVgKeTF2RB45ATZoQ5TfB9vZBfOanvZCfj1Dv
zrvQ9nlFfpS7/Yqv/l9wFCrNLct/Disj4z489ID4TDAJBqfV+IKpL+JjXoOHrIwU
1anUXsXrTBFg1V3JHdEu4JdkbFhvonVUDN5uMasVgSl5ZsgsDK8m4+SZQjHig9vC
VwV2cxQ4a4G4i1yyF3synqqs4cynfdNj1t2FhDqD0Otfug+gWCYF6MjcAY5spw1g
T2UOZz2DK7t9/VyYaEQhejbnBw3GQVpO/M0AI1qBQ1R2BgE6m4In9dfcbZ0ztENS
YYO1SRN/BK7JLsqKTz6RHJpqu76GMmCCBILlUnut4Y2Tr/t3aesSczzBqmyZmPcW
RUeD6cWe06fwhZvvm4848ju7dKs5guJ7Q6zEe3JpdvOqWWqCH3nSqz21rjpm5Uju
P0zfEssRPkxS23XLRtTpgTV0w1nEUPUzlNXYzAdeKqaAunIO54jI4C3TRb+BSyFO
ti7IKJ7tRm7m+0+sxIo++FprjSci24wQCJFdvDxYw8jp8ylU0rA=
=+hxW
-----END PGP SIGNATURE-----

--nextPart27084655.57BtrpTxDt--

