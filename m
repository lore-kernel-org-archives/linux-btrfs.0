Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:46240 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527AbaAAQW0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jan 2014 11:22:26 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so5817513eae.5
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jan 2014 08:22:25 -0800 (PST)
From: Michal Nazarewicz <mina86@mina86.com>
To: fdmanana@gmail.com
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        "linux-btrfs\@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] btrfs: remove dead code
In-Reply-To: <CAL3q7H6ftrPyGK56i2EQ8fZaHa+RvaiFPR9SdJ4C9QrpFGPe=A@mail.gmail.com>
References: <1388553589-26778-1-git-send-email-mina86@mina86.com> <CAL3q7H6ftrPyGK56i2EQ8fZaHa+RvaiFPR9SdJ4C9QrpFGPe=A@mail.gmail.com>
Date: Wed, 01 Jan 2014 17:22:18 +0100
Message-ID: <xa1tiou3d64l.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> On Wed, Jan 1, 2014 at 5:19 AM, Michal Nazarewicz <mina86@mina86.com> wro=
te:
>> [commit 8185554d: fix incorrect inode acl reset] introduced a dead
>> code by adding a condition which can never be true to an else
>> branch.  The condition can never be true because it is already
>> checked by a previous if statement which causes function to return.

On Wed, Jan 01 2014, Filipe David Manana wrote:
> Josef already added this patch to btrfs-next weeks ago:
>
> http://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/?=
id=3Dc4a886e433dce2b902324a54ef2d13691a760312

Ah, sorry for the spam then.

The original thread did not mention it and this commit was not included
in linux-next's master branch.

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--

--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSxEC6AAoJECBgQBJQdR/0KC8P/0FV6QTYO3Gv0u6xZ/d+n0Re
JY2PMOLYvPkn8P4rB2B4Voh+5+rZz19A9dLPu0YEHC2HzoI+CELHjc0W42jHX3bY
oCWUOt6+JgXQJtlamFtdSj5K5oGswu0Md1j59H6sLAzndK7TJoJS88/+1e2nV5I1
Z1CxpzUVKYkQa7UPhvqDUmptFzfhmcH8ZwDKFvoixSc5geBibulKQAl3XLw0a7xb
oSlTY4fNy5/DX/Laa7pAYhac9x8SUZtfm8oxPZyTMqtg4hGfA3kq8aLYgl4NHmsb
wVOqPJBsbaF0XCDmdw/imQfrnK8XUnuw3wjjJUhe0MnLzzuHzJP0nW15/AbZ5VY7
Bql0T08U22ZwKbbSMAfs3yT3J2xP/gFQt4dMcnG2BGktmg5kHoM3k+V1DYSfkOEN
41Aw/zlsPh1m/WYU1HuHRLbP7sygRTyZVcAaeYPR4T9PoEM8nb2qOfGQEBuRtwd3
ER8tMNAVH5IfeN3H6s1qOCKNiBUxXzraPRBJWcw6UMVl5AsVcK5EY2EFjgeq6wCL
bBPsie2CAsu2quOLaMqfHMhT3DApnqoGyRDUtIgvyP6lCbCK3LSCx2t0U+jyCSrP
Rf0/RKQ/dMSfiT+AZr8vFjpifmQ3r5Tn85ZfvN4RRx4SB0mBAW+chOOHX74kclcJ
QMwQZB3IboIKmd5rC/ip
=ttg3
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
