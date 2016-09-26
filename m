Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45424 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936453AbcIZAWs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Sep 2016 20:22:48 -0400
Subject: Re: unable to handle kernel paging request - btrfs
To: Rich Freeman <r-btrfs@gw.thefreemanclan.net>,
        Duncan <1i5t5.duncan@cox.net>
References: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
 <pan$afe1d$3cd285bd$f0b68da9$67150f63@cox.net>
 <CAGfcS_n+pMq0thNEM9b2ZA78xEpXTFJXjwTHRyvquLS8dR_yng@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <964e335c-76d1-f7c0-4e66-c2cabe7b9249@suse.com>
Date: Sun, 25 Sep 2016 20:22:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAGfcS_n+pMq0thNEM9b2ZA78xEpXTFJXjwTHRyvquLS8dR_yng@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UdNJ0CxH21UPncSE6wSo5mLmOR566VEbc"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UdNJ0CxH21UPncSE6wSo5mLmOR566VEbc
Content-Type: multipart/mixed; boundary="T9xfueb5PPIdFTpv6mNtewtFftDv61Nph";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Rich Freeman <r-btrfs@thefreemanclan.net>, Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <964e335c-76d1-f7c0-4e66-c2cabe7b9249@suse.com>
Subject: Re: unable to handle kernel paging request - btrfs
References: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
 <pan$afe1d$3cd285bd$f0b68da9$67150f63@cox.net>
 <CAGfcS_n+pMq0thNEM9b2ZA78xEpXTFJXjwTHRyvquLS8dR_yng@mail.gmail.com>
In-Reply-To: <CAGfcS_n+pMq0thNEM9b2ZA78xEpXTFJXjwTHRyvquLS8dR_yng@mail.gmail.com>

--T9xfueb5PPIdFTpv6mNtewtFftDv61Nph
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/25/16 9:55 AM, Rich Freeman wrote:
> On Fri, Sep 23, 2016 at 12:58 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>>
>> Btrfs raid1 you say, and you have existing compressed files it's tryin=
g
>> to read in the backtrace?
>>
>> Sounds like the issues I see sometimes and have posted about where aft=
er
>> a crash that resulted in one device of my raid1 pair getting behind th=
e
>> other, the kernel will crash if it sees too many csum-errors, even tho=

>> it's /supposed/ to check the other copy and read from it if valid (whi=
ch
>> it is as a btrfs scrub resolves the issue).
>>
>> When booted to rescue/single-user mode, can you run a scrub?
>=20
> After a few reboots trying to capture the initial panic message (even
> when I set panic_on_oops=3D1 I was getting multiple ones with only the
> tainted one staying on screen), the system managed to stay up.  I
> completed a scrub and it found no errors.  I also haven't had any
> issues with it but haven't attempted another reboot.  I figured the
> safest course was to just leave it on for a good week so that whatever
> was in the log/etc that was giving it trouble works its way out.  I'm
> also doing a balance which may or may not help (and which is useful
> anyway since I increased the size of the drive I replaced).

If it stays up, can you post the initial Oops then?

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--T9xfueb5PPIdFTpv6mNtewtFftDv61Nph--

--UdNJ0CxH21UPncSE6wSo5mLmOR566VEbc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIcBAEBCAAGBQJX6GpSAAoJEB57S2MheeWyC5IP+gPRVk3RQGg8/bpyhdVbqqW2
F5oZNVOh5fCt7llZbNwv4sUxsF6vXabCpqXKi2C3i3GPAfiGR5IifGh2udCTZ3kF
3NjvlK5BIPYtbbDaXMHfijivAzDxgGS9ecaH6e7cspsQoObr6fgeNV9xNwxfUDi7
H1i52vFGtA4RhsVkAA/KHwM5KdcUJbJAhI8B8s22GRyiWE3u8uAHNz1JrZfjbW8Z
SBuy/fuq9UIkJExKvVU4QWaJAj/z3LdbjRqELrtmXNIrKTR+1PIUl5/nUVz/L4yU
XdMZ27brHxodcJUw4rsk/nouI2xLEU26wLHbTDjgy9lsthTS1UAGcSI+0IxGqpaw
AAwMZA+blZDwuoxu6HvgJB5H+PiVgkHH+OF/YkQfOhyGU1Hj6/mgSq2eUpImzsAj
cNT62P/GiSISw9oGcP7an0fzT+8+uSZUnccEBUW5pdXwX/ZsszDsRL7DfX57hRrh
rAghyjKhGxp/8AIjgCwWboVoFFtXzFRo2TNCwGSwQYqjGvn8vVvkWHsPA5ClDQ2k
r0TmToQHo19Bs5g3222MY4Qb+fYUhRQCaLW5nQMkGQfZrkYznIXU2iKtxm1QjGWn
sRNJu2o+SBvHOKEIhtRfOsyOQJTRMZoU1Zh9TlA1L4Q/EJPQctJgeZWq610IjNIU
QvDJeUzFQLRgemIYm267
=HEjb
-----END PGP SIGNATURE-----

--UdNJ0CxH21UPncSE6wSo5mLmOR566VEbc--
