Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52618 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbbIIRTw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Sep 2015 13:19:52 -0400
Date: Wed, 9 Sep 2015 17:19:51 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Jon Keane <jkeane@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Unmountable btrfs after power failure
Message-ID: <20150909171951.GQ23944@carfax.org.uk>
References: <CAE+qdJbDCaBpiw2JQdOVPk0qmR4NE3NZV+mF8-cXk2y697a3Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="teKjxxMjPsACTz/N"
In-Reply-To: <CAE+qdJbDCaBpiw2JQdOVPk0qmR4NE3NZV+mF8-cXk2y697a3Hg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--teKjxxMjPsACTz/N
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

uOn Wed, Sep 09, 2015 at 10:30:33AM -0500, Jon Keane wrote:
> I recently had a power failure, and ever since I have been unable to
> mount one of my btrfs drives (data is the one that is failing to
> mount, store is fine). I=E2=80=99m running:
>=20
> jkeane@bet:~$  uname -a
>=20
> Linux bet 3.8.0-33-generic #48-Ubuntu SMP Wed Oct 23 09:16:58 UTC 2013
> x86_64 x86_64 x86_64 GNU/Linux

   This is almost certainly why you're having the problem in the first
place. This is an old kernel (2 years old, even by the compilation
date -- the code base is probably even older), and back then, btrfs
didn't really cope with power loss or unclean reboots very well.

[snip]
> Sep  9 10:12:06 bet kernel: [ 1515.314122]  [<ffffffffa0143efb>]
> replay_one_buffer+0x2ab/0x350 [btrfs]
>=20
> Sep  9 10:12:06 bet kernel: [ 1515.314161]  [<ffffffffa0129ff7>] ?
> alloc_extent_buffer+0x97/0x400 [btrfs]
>=20
> Sep  9 10:12:06 bet kernel: [ 1515.314200]  [<ffffffffa0124d8c>] ?
> check_buffer_tree_ref+0x3c/0x50 [btrfs]
>=20
> Sep  9 10:12:06 bet kernel: [ 1515.314239]  [<ffffffffa013f962>]
> walk_down_log_tree+0x212/0x400 [btrfs]
>=20
> Sep  9 10:12:06 bet kernel: [ 1515.314277]  [<ffffffffa013fbed>]
> walk_log_tree+0x9d/0x1f0 [btrfs]
>=20
> Sep  9 10:12:06 bet kernel: [ 1515.314313]  [<ffffffffa0108093>] ?
> btrfs_read_fs_root_no_name+0x1d3/0x310 [btrfs]
>=20
> Sep  9 10:12:06 bet kernel: [ 1515.314352]  [<ffffffffa0145d85>]
> btrfs_recover_log_trees+0x215/0x390 [btrfs]
[snip]
--
>=20
>=20
> Many of these look similar to the ones described at
> https://btrfs.wiki.kernel.org/index.php/Btrfs-zero-log I have not yet
> tried zeroing the log, because I=E2=80=99m not seeing all of the messages=
 that
> are specific on the FAQ. I suspect that is what I need to do, but I
> wanted to check here first.

   Yes, zeroing the log here will probably help.

> Please let me know if there is any more information I can provide to
> help track this down. Thanks!

   The bug you've hit is almost certainly fixed in more recent
kernels. I can't recommend stongly enough that you upgrade it (or
contact your vendor's support department to find out how they will
support your use of btrfs on a kernel that old). 3.19 is about the
earliest kernel I'd feel happy about using at this point.

   Hugo.

--=20
Hugo Mills             | UNIX: Japanese brand of food containers
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--teKjxxMjPsACTz/N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV8Go3AAoJEFheFHXiqx3kwdYP/3bIUwyfGvw+Rh7oqqptwKS+
GdHcEUGqhPJV4lqVSGIvIxFgkEdtCWJv5GkBax6pXV8+bMN1C8niaBxVO+0lf2bp
J+LItNp9OhXJlnkhOfzVEyiGMqTrbPXg4N5Vj0IKjZu5YfEu9bgjC5A9i0DSrAwg
U2GfqaI7YB2yvYxcP8gYZw8NX47mZr1LGh1gTuO1fxyxIsyj6yw4/MWLje3jXYVQ
1tF0yLEr6URUbti/4+WlRoTlNr2LNGhFglfO7IaJVfY4lxEwOEH6dmL61qSOoKAz
c458bbnoUj9nlnFVFy43tKh6+jLhx6+rnyGKR9iVdRCaReeGSgsSdOXwlc+Rlpzs
H8l+UdanTSrWgoqGYLhAi49TGdPkxPbT9jh8aWhNCr0ZPnVPkh8I8tJYcEMWTo5J
morjI/NVg9R9xZ9xon79fRkGRosYCnRpqGhMUhpR349NZL664Fszl8eILDpn/5P2
T3c3dMtonU205U2hc11nGPKOI5OpDxHSgQCBUEbWEgWF+B1oXRoE6M3RcOQxcjTm
9q7cSeBHvW0RKhhubjoNU+6H4YmU7lrSnJo0HSrdLmnHzY/u8L4mooFgmXOzAgQ6
lCIBzGPwv4Lia6coXWzqrk0fSsQqHPuzdcOFnD8FHgZtv9pJq0f29PazHwHsHnCN
Fum2O3ZfrSypxOufHE28
=Wslp
-----END PGP SIGNATURE-----

--teKjxxMjPsACTz/N--
