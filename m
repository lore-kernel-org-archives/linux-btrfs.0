Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53320 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751003AbcLDQDB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 4 Dec 2016 11:03:01 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MPm54-1cIUvh1F7i-004xAB for
 <linux-btrfs@vger.kernel.org>; Sun, 04 Dec 2016 17:02:59 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: system hangs due to qgroups
Date: Sun, 04 Dec 2016 17:02:58 +0100
Message-ID: <11661267.CWr4ZNOWmj@thetick>
In-Reply-To: <20161204021019.GA25519@angband.pl>
References: <1776088.42rHLKPlSp@thetick> <4615776.dvopQOigxY@thetick> <20161204021019.GA25519@angband.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart23506725.eed1Tjffmm"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart23506725.eed1Tjffmm
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Sunday 04 December 2016 03:10:19 Adam Borowski wrote:
> On Sat, Dec 03, 2016 at 10:46:40PM +0100, Marc Joliet wrote:
> > As it's a rescue shell, I have only the one shell AFAIK, and it's o=
ccupied
> > by mount.  So I can't tell if there are dmesg entries, however, whe=
n this
> > happens during a normal running system, I never saw any dmesg entri=
es.
>=20
> You can use "open" (might be named "openvt") to spawn a shell on
> tty2/tty3/etc.  And if you have "screen" installed, Ctrl-a c spawns n=
ew
> terminals (Ctrl-a n/p/0-9 to switch).

I was actually considering adding tmux to the list of programs in the=20=

initramfs after this experience :) .

> > The output of sysrq+t is too big to capture all of it (i.e., I can'=
t
> > scroll
> > back to the beginning)
>=20
> You may use netconsole to log everything kernel says to another machi=
ne.  I
> can't provide you with the incantations from the top of my head (got =
working
> serial (far more reliable) on all my dev boxes, and it doesn't work w=
ith
> bridging ie containers on production), but as your rescue shell has n=
o
> network sharing, assuming your network card driver supports a feature=

> netconsole needs _and_ stars were aligned right when your network car=
d was
> manufactured, netconsole is a valuable aid.
>=20
> The system might be not dead enough to stop userland network logging =
from
> getting through, too.

OK, I'll look up netconsole.

> Meow!

Thanks
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart23506725.eed1Tjffmm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYRD4yAAoJEL/Q5oYsiHj0F18P/2R4myn3EwQvB1eZHr3tCpVQ
FHH6obBCnqw78zpcgPAg8q3anPImWlWBToH5ljB615GFqyIgMgXWwqobmhnZbuDu
0hh4XDs06GG1F0c4qaORj9Zyb1fzsI27kDwe5bWn16+81UPTR06yqbYtQ+l9vK7I
LLR4OWOdHZJGT5uPjusPYenqvfIHtGmUf7AKNN4PJ1eShRKaQ9GFZAn61lUFxxy8
jY0PoEm8dv4vLfPilE0wmdyZdPnRhfJx0AqoGo+aCBknr8J1B+pOMeMmNi+3EHci
uRaoqIB2lVrqyRvNKAwrbz+JIjc7IORbaMAMes6USseMB+HPqs7zSe+mCUTkF6de
o+37MiPW5kti+ObQYUJFtCaeINAWZbvSJ9VBGcSEWCtiHW/Z0ZZF4OwXxIs16Xzz
iSZPC4y+p1rBojom8XwqBMxkCy4z4H5n7bRXH7zMmpvkyDTncjro94J5nAlW8jQW
eQv2WOSBbVZ0LWs429umcqbCeLbFXRj8o7nEgmhuko/p6yhWqLeMxDnvMigVKACD
IXOf+seHHy8hRJ/uQk/TY5H1hJbmbMd47W5158F9hfS50fLhw0dcK6QbSCc5LOLx
aeny1OQ3h49yztetSJMPP8Sj7lS/5KdRlV1ixLM0IbofHnLm8Z4WuiumU3gUsEl3
1qnOnOWEJWwk9eFBIWYY
=699O
-----END PGP SIGNATURE-----

--nextPart23506725.eed1Tjffmm--

