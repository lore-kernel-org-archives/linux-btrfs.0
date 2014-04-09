Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:33146 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932712AbaDIKxu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Apr 2014 06:53:50 -0400
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>,
        Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS setup advice for laptop performance ?
Date: Wed, 09 Apr 2014 20:53:20 +1000
Message-ID: <1748210.42KeASGE2J@quad>
In-Reply-To: <5342C00F.8070001@gmail.com>
References: <2692878.dRG1K49eOP@fnix> <12471892.pAn1KAtSS4@tethys> <5342C00F.8070001@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart21173548.1mGQha3dTz"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart21173548.1mGQha3dTz
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

On Mon, 7 Apr 2014 11:11:11 AM Austin S Hemmelgarn wrote:

> This is because every other filesystem (except ZFS) doesn't use COW
> semantics.

There is an interesting article on LWN at the moment (subscriber only f=
or the=20
next day or two, but if you can afford it I'd suggest considering subsc=
ribing)=20
about the Linux Storage, Filesystem, and Memory Management (LSFMM) Summ=
it=20
discussions around the impact of the new Shingle Magnetic Recording (SM=
R)=20
drives that may change that.

Given these devices are likely to have large sequential write only area=
s it's=20
going to make getting existing Linux filesystems to work on them "inter=
esting",=20
in the section on Dave Chinners filesystem part of the discussion it sa=
ys:

# Any of the existing filesystems that do not support copy-on-write (CO=
W)
# cannot really be optimized for SMR, he said, because you can't overwr=
ite
# data in sequential zones. That would mean adding COW to ext4 and XFS,=

# Chinner said.=20

https://lwn.net/Articles/592091/

There's some background to SMR drives (available to all) from the LSFMM=
 here:

https://lwn.net/Articles/591782/

All the best,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


--nextPart21173548.1mGQha3dTz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEVAwUAU0UmoI1yjaOTJg85AQKO7QgAk94QoA3I7hxCOxdT1ijNlRcwtJq01D8X
KdG0oHyzPloEK2wUuB8ZsFNrQkbDoViGGAjgaW8LMcm7ytGb4BBnQGBjQqtlIMYa
3zLCGFDDXC8LqX3fHGGbBl2S/Hir19LmD5aHEwzJl0WsNOaZRTDkNKsULxaSe5nW
lAVlGFgdr0CgBkmMugwY4hfYojs9vGdHzQgbC6mqwDYh1/IddwBfJoB9BTRYjREl
aQy/CV6YhNGqo8FN4/ClLB7P47Aki+txy/1lUP/el1sMFnbRzdcgFxftYkONnUIN
h1HeG3BQRf/eyr6oBKjMv6zxW4VfjReIUc0bchqlWTMrwF5sUxijwA==
=qccp
-----END PGP SIGNATURE-----

--nextPart21173548.1mGQha3dTz--

