Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42235 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751337AbdGMO14 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 10:27:56 -0400
Subject: Re: [PATCH] btrfs-progs: add support to sort by topid
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20170713041642.27125-1-anand.jain@oracle.com>
 <d329b0b6-b8ab-1173-8084-0d5c31ce1981@suse.com>
 <1f6b1556-9b52-b976-ded1-3a77e37e1559@applied-asynchrony.com>
From: Jeffrey Mahoney <jeffm@suse.com>
Message-ID: <15530c86-cfa7-79c9-1606-1687c5fc0e3b@suse.com>
Date: Thu, 13 Jul 2017 10:27:49 -0400
MIME-Version: 1.0
In-Reply-To: <1f6b1556-9b52-b976-ded1-3a77e37e1559@applied-asynchrony.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aKWmekWsl5sgN2cSrtQCDPT30dx2wat0E"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aKWmekWsl5sgN2cSrtQCDPT30dx2wat0E
Content-Type: multipart/mixed; boundary="Bx43sgrGBjIN3F0JrR3bOhMqIJR2KvMU0";
 protected-headers="v1"
From: Jeffrey Mahoney <jeffm@suse.com>
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
 Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <15530c86-cfa7-79c9-1606-1687c5fc0e3b@suse.com>
Subject: Re: [PATCH] btrfs-progs: add support to sort by topid
References: <20170713041642.27125-1-anand.jain@oracle.com>
 <d329b0b6-b8ab-1173-8084-0d5c31ce1981@suse.com>
 <1f6b1556-9b52-b976-ded1-3a77e37e1559@applied-asynchrony.com>
In-Reply-To: <1f6b1556-9b52-b976-ded1-3a77e37e1559@applied-asynchrony.com>

--Bx43sgrGBjIN3F0JrR3bOhMqIJR2KvMU0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/13/17 9:58 AM, Holger Hoffst=C3=A4tte wrote:
> On 07/13/17 15:25, Jeffrey Mahoney wrote:
>> On 7/13/17 12:16 AM, Anand Jain wrote:
>>> As users generally organize the subvols and snapshots based on the su=
bvol
>>> directory hierarchy. So providing an ability to sort them by topid wo=
uld
>>> help. Thanks.
>>
>> What is a topid?  I needed to look at the code to discover this and it=
's
>> not even documented as part of the root_info structure.  Users are goi=
ng
>> to have no idea what this means.
>=20
> The idea seems similar to my attempt to add listing of toplevel-only
> (i.e. non-snapshot) subvolumes, which can be found here:
>=20
> https://github.com/hhoffstaette/btrfs-progs/commit/f0a065e02b
>=20
> I ended up not submitting it since nobody seemed interested at the time=

> and I could work around it for my own purposes by filtering manually on=

> parent uuid (more precisely the lack thereof).

I'm not debating the utility of the idea -- just that it is a completely
opaque name for someone not already familiar with the internals.  One of
the biggest complaints I hear consistently about using btrfs is that the
UI is difficult to use.  It's on my team's TODO list to fix some of
this, but part of that is trying to make sure that new additions are
easy to use.

This patch uses an abbreviation that's used nowhere outside of the code
and offers no documentation for it.  That's what my issue is.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--Bx43sgrGBjIN3F0JrR3bOhMqIJR2KvMU0--

--aKWmekWsl5sgN2cSrtQCDPT30dx2wat0E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWWeDaB57S2MheeWyAQgyGg//XupKvi5TEQV5NYtXJo4owTwzOm5MibkY
6L+mc85um5YlgQURiz81StTYPHAP5rmZnzGwR5dqWXxlZiSWm58zccUFc9Bp40nO
1pLXHCPHw5wJFYpvf6TSHFYmjxK2PVq84XrNOK+FNhtEDOGR2y735b8TaXA7DzoL
HltUVMRyDFHXW1RLxo7UdY4JkUJKEYgDlw+aDpoMpP60qxv7fLIhy2p+CvQd8bYk
+cQnM53PFTD3f6sHmjkpli2lrDjy4NfgQ+vuCGJ8hhPlztr+zJIhsfN+q0tZW2Zw
qCZtTyIF6ndySRutfZ1yMPYVHpmESwEW3Rq5MisxYrLl0fSsQ9dftU1pIpVi+JRF
ostuJ3tP1v8EkT4DW4iI7KRr9+KkMgBWnXPC0cq5DTyGBcueZcCjlQjgsmJMMX7u
2vC43yVW65nXa+lg2XIPGSm/9r5ihVkQCqnNh0XEdEdZA0BtSc23XuPxhEApIi/H
POk7Z1OLyOuQQenMLyB9Rg3xxj4AhFbrQ+EZQCGRZYqKWxA1nDYFAjeO3oqCdzOE
iw+u55gfFf4o1aTCx9IUwtcsJmbNEJ0k7diExv5o9h/25ujpkcjEFPZUF9zKfs+v
kQx80uHUiMv/tOAJLO2i/bB7L+rX4zCB9J979cVx+zGiQiSxw5helfV+aqkzmqcJ
K4yAgoI+lbA=
=M7bo
-----END PGP SIGNATURE-----

--aKWmekWsl5sgN2cSrtQCDPT30dx2wat0E--
