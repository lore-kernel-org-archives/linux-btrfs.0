Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:59007 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758041AbdLRHSH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 02:18:07 -0500
Subject: Re: How to repair errors only found with check --mode=lowmem
To: Ravi Hale <tom@hale.ee>, linux-btrfs@vger.kernel.org
References: <abb41cea-93eb-0e35-e9b2-195968fc4fd7@hale.ee>
 <19de77b6-0017-d172-993a-438d8bc9023d@gmx.com>
 <16068704b70.277a.1243720eb903aaa2f74f5d2a8df9f525@hale.ee>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <245e7c42-2ea6-7f03-c5d2-52a326a4ed7c@gmx.com>
Date: Mon, 18 Dec 2017 15:17:58 +0800
MIME-Version: 1.0
In-Reply-To: <16068704b70.277a.1243720eb903aaa2f74f5d2a8df9f525@hale.ee>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wwn9450EKAbMlINf8IamQE675Aro5HREA"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wwn9450EKAbMlINf8IamQE675Aro5HREA
Content-Type: multipart/mixed; boundary="LrF2Fo44Hjitu48dHV5Mkxi0iGCDdxr0R";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Ravi Hale <tom@hale.ee>, linux-btrfs@vger.kernel.org
Message-ID: <245e7c42-2ea6-7f03-c5d2-52a326a4ed7c@gmx.com>
Subject: Re: How to repair errors only found with check --mode=lowmem
References: <abb41cea-93eb-0e35-e9b2-195968fc4fd7@hale.ee>
 <19de77b6-0017-d172-993a-438d8bc9023d@gmx.com>
 <16068704b70.277a.1243720eb903aaa2f74f5d2a8df9f525@hale.ee>
In-Reply-To: <16068704b70.277a.1243720eb903aaa2f74f5d2a8df9f525@hale.ee>

--LrF2Fo44Hjitu48dHV5Mkxi0iGCDdxr0R
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8818=E6=97=A5 15:04, Ravi Hale wrote:
> My bad. 4.14.

Well, things get interesting now.

Although there are several new lowmem fixes pending for v4.14.1, the
backref mismatch bug should be addressed in v4.14.

Anyway, would you please try this branch to see if it solves the false
alerts?
https://github.com/kdave/btrfs-progs/commits/devel

If the devel branch still reports error, we still have good enough
sample to dig further.

>> ERROR: extent[691815358464, 11042816] referencer count mismatch
(root: 257, owner: 1869679, offset: 613974016) wanted: 1, have: 2

This is a pretty good sample, small enough to find out what's going on.
Ff devel branch can't help you, would you please dump the output of the
following commands?

# btrfs-debug-tree -t extent /dev/mapper/vg_svelte-home |\
  grep -C10 691815358464

# btrfs-debug-tree -t 257 /dev/mapper/vg_svelte-home |\
  grep -C20 1869679

Please note that, the 2nd output may contain *FILENAMES*, so feel free
to erase any file name if it's sensitive.

Thanks,
Qu


--LrF2Fo44Hjitu48dHV5Mkxi0iGCDdxr0R--

--wwn9450EKAbMlINf8IamQE675Aro5HREA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlo3a6YXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qh5pAgAkV95RovosFXdXWhXiMaSXbbj
OZDhfDZ32ymvIwO6zltc/1+u55mz3OegChePzyVFR5w0uGhW3sU8KrARygMobCyo
XyMkzKxZzpq8SDMT5nTF5c6otc3bNXsT7OxO/ffwOUvxU/pMfwZBLVUBVXwSK5wU
T46dDpEaTJPUkX1RdT/vXHFlGN/RaqAg1vCiRvCwxrTQGpKTIqYmkqvJff/5MJmz
Sdsl8ckOj3cGbY4Zz9r4ipAq6LICIgEogZeuVYYTw8sEs+cnD3ARsaRWAiUIEPnO
j5u3/u4HQjJerVZYMKW/ScgWMMO1d88ReMDxuaGmsPtNw7LYjGn1hALt4a4dJg==
=W59E
-----END PGP SIGNATURE-----

--wwn9450EKAbMlINf8IamQE675Aro5HREA--
