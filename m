Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.gocept.net ([195.62.125.19]:46486 "EHLO mail.gocept.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752825AbdC0OuB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 10:50:01 -0400
From: Christian Theune <ct@flyingcircus.io>
Message-Id: <CDED0C65-B382-4EFF-90C6-140F5C8DFC0E@flyingcircus.io>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_27EEF382-9452-45FE-9930-E565BF66A61A";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Subject: Re: Shrinking a device - performance?
Date: Mon, 27 Mar 2017 16:49:47 +0200
In-Reply-To: <bf772a48-5181-d1ea-f7a7-5dffc524e2de@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
 <20170327130730.GN11714@carfax.org.uk>
 <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
 <20170327132404.GO11714@carfax.org.uk>
 <c2b19e0a-b345-5d72-2a60-ff86cde7cfca@gmail.com>
 <D3C6181C-2485-4CBC-AD13-A367DD6665F2@flyingcircus.io>
 <333BD058-6365-43C3-8070-E6267936D98D@flyingcircus.io>
 <bf772a48-5181-d1ea-f7a7-5dffc524e2de@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_27EEF382-9452-45FE-9930-E565BF66A61A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi,

> On Mar 27, 2017, at 4:17 PM, Austin S. Hemmelgarn =
<ahferroin7@gmail.com> wrote:
>=20
> One other thing that I just thought of:
> For a backup system, assuming some reasonable thinning system is used =
for the backups, I would personally migrate things slowly over time by =
putting new backups on the new filesystem, and shrinking the old =
filesystem as the old backups there get cleaned out.  Unfortunately, =
most backup software I've seen doesn't handle this well, so it's not all =
that easy to do, but it does save you from having to migrate data off of =
the old filesystem, and means you don't have to worry as much about the =
resize of the old FS taking forever.

Right. This is an option we can do from a software perspective (our own =
solution - https://bitbucket.org/flyingcircus/backy) but our systems in =
use can=E2=80=99t hold all the data twice. Even though we=E2=80=99re =
migrating to a backend implementation that uses less data than before I =
have to perform an =E2=80=9Cinplace=E2=80=9D migration in some way. This =
is VM block device backup. So basically we migrate one VM with all its =
previous data and that works quite fine with a little headroom. However, =
migrating all VMs to a new =E2=80=9Cfull=E2=80=9D backup and then wait =
for the old to shrink would only work if we had a completely empty =
backup server in place, which we don=E2=80=99t.

Also: the idea of migrating on btrfs also has its downside - the =
performance of =E2=80=9Cmkdir=E2=80=9D and =E2=80=9Cfsync=E2=80=9D is =
abysmal at the moment. I=E2=80=99m waiting for the current shrinking job =
to finish but this is likely limited to the =E2=80=9Cfind free space=E2=80=
=9D algorithm. We=E2=80=99re talking about a few megabytes converted per =
second. Sigh.

Cheers,
Christian Theune

--
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 http://flyingcircus.io
Forsterstra=C3=9Fe 29 =C2=B7 06112 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian. =
Theune, Christian. Zagrodnick


--Apple-Mail=_27EEF382-9452-45FE-9930-E565BF66A61A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQEcBAEBCgAGBQJY2SaLAAoJEKuh8lKpfGLOY+EIANJcSGlKks64S9nFPwJJGq5N
/BbOLXJuKj9fkEHpxbzJbUYHRVilpbZ8YYFAsrqP3Gm1Z4kabVNogqgmg/Wozd3x
nBx6X7RhhcOOpkeQR3CxmQXQHHFShmiinv0DXzgsJpAopeNne8qqD7nJlVKQVWp6
VMckHcUwkWYv5HtsVmctXl7K+1J6ZumOyFuVTHoMKzFPrshGINVdZLVw0SWZANhc
YmR5q4SLC6fX7UZ0g2/YEOXiqPsJabC6Q96pVIDLCWOxYDRMb1O3jJJAS8nFb9TZ
5oMSakWWSyyx8EPILNw07Pl8L+g/VQIPVZVhyeAJ6STOzO/UleAnogFPrO2ZwDE=
=/WY9
-----END PGP SIGNATURE-----

--Apple-Mail=_27EEF382-9452-45FE-9930-E565BF66A61A--
