Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:58550 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750998AbcLEMK5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Dec 2016 07:10:57 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MdaiW-1c1gMp2rdc-00PNVh for
 <linux-btrfs@vger.kernel.org>; Mon, 05 Dec 2016 13:10:35 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: system hangs due to qgroups
Date: Mon, 05 Dec 2016 13:10:28 +0100
Message-ID: <2381784.qSv6VvNXox@thetick>
In-Reply-To: <29619565.vvZbx4DoIQ@thetick>
References: <1776088.42rHLKPlSp@thetick> <5f35cc2d-4c3d-b14c-01f6-4bfb0f22823b@cn.fujitsu.com> <29619565.vvZbx4DoIQ@thetick>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1484759.SqztJcU63N"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1484759.SqztJcU63N
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Monday 05 December 2016 12:01:28 Marc Joliet wrote:
> > You could try the for-next-20161125 branch from David to fix it:
> > https://github.com/kdave/btrfs-devel/tree/for-next-20161125
>=20
> OK, I'll try that, thanks!  I just have to wait for it to finish clon=
ing...

FWIW, I get this warning:

  CC      fs/btrfs/inode.o
fs/btrfs/inode.c: In Funktion =C2=BBrun_delalloc_range=C2=AB:
fs/btrfs/inode.c:1219:9: Warnung: =C2=BBcur_end=C2=AB k=C3=B6nnte in di=
eser Funktion=20
uninitialisiert verwendet werden [-Wmaybe-uninitialized]
   start =3D cur_end + 1;
         ^
fs/btrfs/inode.c:1172:6: Anmerkung: =C2=BBcur_end=C2=AB wurde hier dekl=
ariert

Should I be worried about that?  At a cursory glance, it looks like a f=
alse=20
alarm, but I just want to be sure (and even so, false alarms are annoyi=
ng).

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart1484759.SqztJcU63N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYRVk0AAoJEL/Q5oYsiHj0O8gP/2bqkCwnqqqVBRJIHA1CwJrL
nk48TT7MV9SAYVSGfyI1AHUzdmUxBdM2UsTSC9/v9LlYFq5vVooihTQEhpmUShPi
aJVvy/f+TEHDdJ2B3S1ngTZv/swgWFvyVDPAMYg8VxZGnp8gVk8P17nvoMO6ekEM
J0k8+uGIpVkbEn4ag4agQd92L6/kDYnAEjesIF4zaPUHIEkGh0ZWh3O+0Y1C5v3/
KBBDKbUO0tqNORZ67mbwvBfLKbw0vOyDLByPy0DLtDPD0AMR9jrt3xpucdIbxWVB
qTAWGc+V9v6wq3/rGrW2nTOEccvQthIVYXHR6OKBgiHrYbPD/F1OiWqZVOc/Wm4a
c2Rpv3EqLXdyvV3kAyptr8AMLD81jA1FP6gHYYQFQnNbDPKggs7q/BrjFbXEcLrn
z2l7OU1V8EXd6cZawwG+mR2dXX25hZIA5CKq8mLpmWT8xA9CNITPiVKBaI7N1fCT
gcuynDjIt+H8y90ESKTIKNZLnv/wLyR4DFn/IK1ifxED8PfLiZVqAoVWZ3bAi86f
muC2YtVQIWy+dj9y/x1op5cCjadKOBKfH1YxjL8Td1CrMbBQYwARxi8fNzv1FzSf
da0c1IyMlmCkkrxna2fRWMxhwto8ERbTAZ03M8ecCctLPEKBNpKjyWBdnRkTVTDa
HaO68OqMkrbgRmgwiES6
=xHm8
-----END PGP SIGNATURE-----

--nextPart1484759.SqztJcU63N--

