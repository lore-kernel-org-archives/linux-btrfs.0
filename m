Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:54851 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772AbbLFL0j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 6 Dec 2015 06:26:39 -0500
Received: from thetick.localnet ([93.181.44.4]) by smtp.web.de (mrweb002) with
 ESMTPSA (Nemesis) id 0MZUjd-1ZpNU93Yab-00LFrV for
 <linux-btrfs@vger.kernel.org>; Sun, 06 Dec 2015 12:26:36 +0100
From: Marc Joliet <marcec@web.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: compression disk space saving - what are your results?
Date: Sun, 06 Dec 2015 12:26:30 +0100
Message-ID: <4340614.HYtU064l4J@thetick>
In-Reply-To: <pan$8b10f$b3ac4256$83d73f5e$98d77741@cox.net>
References: <4082684905f25f921ae4564b1c8a892e@admin.virtall.com> <1864635.CI05HQM0X6@thetick> <pan$8b10f$b3ac4256$83d73f5e$98d77741@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4502335.3r7VvZP46B"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart4502335.3r7VvZP46B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Sunday 06 December 2015 04:21:30 Duncan wrote:
>Marc Joliet posted on Sat, 05 Dec 2015 15:11:51 +0100 as excerpted:
>> I do think it's interesting that compression (even with LZO) seems t=
o
>> have offset the extra space wastage caused by autodefrag.
>
>I've seen (I think) you mention that twice now.  Perhaps I'm missing
>something... How does autodefrag trigger space wastage?
>
>What autodefrag does is watch for seriously fragmented files and queue=

>them up for later defrag by a worker thread.  How would that waste spa=
ce?
>
>Unless of course you're talking about breaking reflinks to existing
>snapshots or other (possibly partial) copies of the file.

That is in fact what I was referring to.

>But I'd call
>that wasting space due to the snapshots storing old copies, not due to=

>autodefrag keeping the current copy defragmented.  And reflinks are
>saving space by effectively storing parts of two files in the same
>extent, not autodefrag wasting it, as the default on a normal filesyst=
em
>would be separate copies, so that's the zero-point base,

Of course, the default on a normal file system is to not have any snaps=
hots=20
between which to reflink ;-) .  Also, autodefrag is not a default mount=
=20
option, so the default on BTRFS is to save space via reflinks, which is=
 undone=20
by defragmenting, hence why I see it as autodefrag triggering the waste=
 of=20
space.

>and reflinks
>save from it, with autodefrag therefore not changing things from the z=
ero-
>point base.  No snapshots, no reflinks, autodefrag no longer "wastes"
>space, so it's not autodefrag's wastage in the first place, it's the
>other mechanisms' saving space.

To my mind it is the keeping of snapshots and the breaking of reflinks =
via=20
autodefrag that together cause space wastage.  This is coming from the=20=

perspective that snapshots are *useful* and hence by themselves do not=20=

constitute wasted space.

>From my viewpoint, anyway.  I'd not ordinarily quibble over it one way=
 or
>the other if that's what you're referring to.  But just in case you ha=
d
>something else in mind that I'm not aware of, I'm posting the question=
.

And the above is my viewpoint :-) .

=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart4502335.3r7VvZP46B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWZBtrAAoJEL/Q5oYsiHj0wBcP/i0c0NSZPcPRBdp1BvwGHuL7
UGMw6YnMrySJ/6Kfmsw2CBE3wUFKZg11bm/liW/1MHYADF63DFtI5PtrF5bPoEpn
WWg5N4uTMbvJxHnUcYfWHi1YPAQfaMyg6ji1jugQtELEF81t0t+4ZN/tGdbWdePj
u1FeX7sMiSHkDaYqL37Ytb+GRYm7GH6vTi7uO/uCMMeCoq4APvB5S8mJ+QpvatZx
4JNYQzIUgCfumCQsw8eyjb8WjUYQVSryre/aOOSqW0QHTfP4/tTbnqSdvaYu1T+d
pqAQewnNDb/XA+ONJ9c46cXKpm8K0GywRrxX3pQ/IMR5S+AmxCh0k73PLn4l5POt
CuR9tqGYQAsl/00RuCI/8DygrrjEzczbOIbVBHYS2O3cgmhzDDuxwTHw+2nB27qv
OZHnNAMl+fvVMFFvVh0YEXvJvFKXuoMfgDdvFgEIFcTkbygOYfeltWWGz+AWvAEG
LaISYpa0uWZlQyqoKYaOikeXUtzLYTQtwzCCsubPJif3duMGqCcBkyQm556pn9LF
e6SFHycA/LKJc4ph5GKfCTz5YF7Nq4lF2WTle99a2bbNkeZq3NStn/m8vbLWKzZO
PuHfvIcAK7Z4ly46JX0FdRu2qZ0fpaMNO+7WEWy6v9ddXvXC3axhtVRDBOTsX054
KtUaRX8U7u93jCnH9CXJ
=6CMY
-----END PGP SIGNATURE-----

--nextPart4502335.3r7VvZP46B--

