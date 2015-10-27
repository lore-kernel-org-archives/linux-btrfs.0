Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:61925 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964838AbbJ0SYs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 14:24:48 -0400
Subject: Re: btrfs-balance causes system-freeze on full disk
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <c76lfc-jfl.ln1@aldebaran.xundeenergie.at>
 <CAM9fjH4vQki-0UjdMTGZgKEbDy1pRBZNRqro8TtqzLbDPwfsvw@mail.gmail.com>
 <40k4gc-scp.ln1@aldebaran.xundeenergie.at>
 <20151027170904.GK11331@carfax.org.uk>
From: =?UTF-8?Q?Jakob_Sch=c3=bcrz?= <wertstoffe@nurfuerspam.de>
Message-ID: <562FC132.2080209@nurfuerspam.de>
Date: Tue, 27 Oct 2015 19:23:46 +0100
MIME-Version: 1.0
In-Reply-To: <20151027170904.GK11331@carfax.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="joprSXUeXxTXhOKrIliQc4RT41FgGmUgj"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--joprSXUeXxTXhOKrIliQc4RT41FgGmUgj
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 2015-10-27 um 18:09 schrieb Hugo Mills:
> On Tue, Oct 27, 2015 at 05:05:55PM +0100, Jakob Sch=C3=BCrz wrote:
>> Found a new habit...
>>
>> I have a lot Snapshots on my drive. (Take every 10 Min a new one, ever=
y
>> houry one, every day one, every system-update, every plugin after
>> external HD...)
>>
>> If there are to much snapshots (didn't find out the count how much
>> exactly) balancing fails with a system-freeze.
>> if i delete some of my snapshots, balancing is working...
>=20
>    The whole machine comes to a halt, or just the balancing?=20

The whole machine. Even magic-sysreq-keys are not reacting... I have to
reboot my machine using the power-button...

> If you
> have lots of snapshots, balance can take *insane* amounts of time --
> my big storage array, for example, takes about 60 seconds to balance a
> data block group, and something like 4+ hours to balance some of the
> metadata block groups. While it's "stuck" like that, it is actually
> making progress, but it doesn't look like it.

I know, balancint takes a huge amount of time. So my command is:

/bin/btrfs balance start -dusage=3D55 -v <mountpoint>

When balancing is running, the machine reactes a little slower than
normal... but in my case, the machine is freezing. completly and
totally... :(

greez jakob




--joprSXUeXxTXhOKrIliQc4RT41FgGmUgj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWL8EyAAoJEF2YPOCqoD05q9UH/1el1RE9qBNLSw19nNzmE6VJ
HNxStZIdNr8B+sbikrW/jcygW5jknOvXcX2OzAuYoGV07VI1Ta+ZJMXZxJwZlwKg
gJ9X53FGWEArjvUrQkeXPxOxQcTRXggpD2ZedCJh4fz5hVbE4r0xnfg9nKQVZNA3
0V9vTuEgD6qE0QWnrewNXpSuruqbKTJwE6zfdbORxLavapKWV1mM/Hc7uQCXspYs
cTulUUuQLL9z/qQyyEEAkcdH10h3SwKbxiU0mobr2nvNB8jl+KsKZ2hIoE3n9CZU
KBE/ZGk8dyKo8kRCz5djTmlSJvv+BcxnCSnhzIeH/+bCueRtpJ/EwEmmV8s9TU4=
=uDds
-----END PGP SIGNATURE-----

--joprSXUeXxTXhOKrIliQc4RT41FgGmUgj--
