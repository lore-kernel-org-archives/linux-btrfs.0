Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:57452 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750716AbdLGF1z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Dec 2017 00:27:55 -0500
Subject: Re: [RFC] Improve subvolume usability for a normal user
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5fc9b66b-0bcd-c2a9-7e8e-b4d4ff828200@jp.fujitsu.com>
 <3934c7d3-b601-bbba-5d16-5c3ef9bb527a@gmx.com>
 <e5bf11ce-fef2-6786-752d-4711751d284d@gmail.com>
 <43b6e90c-6461-d722-fb8c-8ad5069841fd@jp.fujitsu.com>
 <e1a297d8-28fb-980e-fd62-c261186b3a6a@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <9aa28872-5a44-5a81-d954-656b2f956033@gmx.com>
Date: Thu, 7 Dec 2017 13:27:44 +0800
MIME-Version: 1.0
In-Reply-To: <e1a297d8-28fb-980e-fd62-c261186b3a6a@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WwkCa7KeMSluQEB5RvkPdapjfMhiA39Ms"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WwkCa7KeMSluQEB5RvkPdapjfMhiA39Ms
Content-Type: multipart/mixed; boundary="mr1EFgPJs465xcctefhI21XCjhdMd4QD9";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
 "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <9aa28872-5a44-5a81-d954-656b2f956033@gmx.com>
Subject: Re: [RFC] Improve subvolume usability for a normal user
References: <5fc9b66b-0bcd-c2a9-7e8e-b4d4ff828200@jp.fujitsu.com>
 <3934c7d3-b601-bbba-5d16-5c3ef9bb527a@gmx.com>
 <e5bf11ce-fef2-6786-752d-4711751d284d@gmail.com>
 <43b6e90c-6461-d722-fb8c-8ad5069841fd@jp.fujitsu.com>
 <e1a297d8-28fb-980e-fd62-c261186b3a6a@gmail.com>
In-Reply-To: <e1a297d8-28fb-980e-fd62-c261186b3a6a@gmail.com>

--mr1EFgPJs465xcctefhI21XCjhdMd4QD9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8806=E6=97=A5 20:39, Austin S. Hemmelgarn wrote:=

> Somewhat OT, but the only operation that's remotely 'instant' is
> creating an empty subvolume.=C2=A0 Snapshot creation has to walk the tr=
ee in
> the subvolume being snapshotted, which can take a long time (and as a
> result of it's implementation, also means BTRFS snapshots are _not_
> atomic).

Nope, this is not true.

Btrfs from the very beginning is designed to speed up snapshot.
The most obvious evidence is its extent tree design.

When doing snapshot, btrfs only needs to increase reference of 2nd
highest level tree blocks of original snapshot, other than "walking the
tree".
(If tree root level is 2, then level 2 node is copied, while all
reference of level 1 tree blocks get increased)

This design hugely speeds up snapshot creation, making snapshot
obviously faster than any block level snapshot.

Although this design obviously slows down backref walk.
As btrfs must do a full walk until tree root, to see if any tree blocks
between leaf and root is shared with another snapshot.


And for btrfs snapshot atomic thing, it's just because btrfs delayed
snapshot creation to transaction commit time, and buffered write is not
triggered for snapshot creation, so it makes snapshot not so atomic.

Thanks,
Qu

>=C2=A0 Subvolume deletion has to do a bunch of cleanup work in the
> background (though it may be fairly quick if it was a snapshot and the
> source subvolume hasn't changed much).


--mr1EFgPJs465xcctefhI21XCjhdMd4QD9--

--WwkCa7KeMSluQEB5RvkPdapjfMhiA39Ms
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloo0VAXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhkaAf/WIKPYbJtnAQ44OUu3UAG+6LQ
LmkCnBk24DIjTkbJvJduw7fuKBLlJ9wOjBl4fbmFQjjm7z0KxQ4C5Lcf1pFbbFBS
ecEC1Ed8J13g5EC6qkyebiIDEe1Smvrg1bYr1H/xDWNa6JoC3HLrEDg0jHCsto1v
Z+odJOkZt+k+Y/OqThuKwfJk4MEHQFprhwp8mxdPVi6TMnt/APDW8a5I4Nte6GQp
38zorG+dDkFAgFBqIo4ga+hlVFWqaXJ+XIgFzkonEDQnyMjybKCaafqNhAT4EzqW
xa+lIBcAOBQiuNV5kgo1nO7BSju0NSPTXVEKldBTkYNcACg4U6PmB1a05V3kVg==
=+PXc
-----END PGP SIGNATURE-----

--WwkCa7KeMSluQEB5RvkPdapjfMhiA39Ms--
