Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55519 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750827AbeFTGgt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 02:36:49 -0400
To: Liu Bo <bo.liu@linux.alibaba.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: About commit f8f84b2dfda5 ("btrfs: index check-integrity state hash
 by a dev_t")
Message-ID: <6c249625-8cb9-c220-a145-b5fec7d6caf4@gmx.com>
Date: Wed, 20 Jun 2018 14:36:35 +0800
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NmOn6QAjV8sCLbnYQfPdSivhWJL5DXoK4"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NmOn6QAjV8sCLbnYQfPdSivhWJL5DXoK4
Content-Type: multipart/mixed; boundary="hLoTquj95T32BqWIx4rIZugBhq0hrTZbD";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Liu Bo <bo.liu@linux.alibaba.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 David Sterba <dsterba@suse.cz>
Message-ID: <6c249625-8cb9-c220-a145-b5fec7d6caf4@gmx.com>
Subject: About commit f8f84b2dfda5 ("btrfs: index check-integrity state hash
 by a dev_t")

--hLoTquj95T32BqWIx4rIZugBhq0hrTZbD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Liu and David,

I see mainline kernel merged commit f8f84b2dfda5 ("btrfs: index
check-integrity state hash by a dev_t"), and you reviewed it but I can't
find the mail in mail list, nor it's signed by David.

Is this btrfs related commit merged without review from btrfs community?
(Well, at least Liu reviewed it, but at least the mail is not CCed to
btrfs mail list)

And in fact this patch is causing check_int mount option fail to mount
any fs degraded, by triggering a NULL pointer de-reference.

Since in btrfsci_map_block() device->bdev can be NULL for missing
device, no wonder device->bdev->bd_dev will trigger a NULL pointer
dereference.

I'm planning to fix the problem by using devid, but I'm a little
surprised that such patch is not even CCed to btrfs mail list.

Thanks,
Qu


--hLoTquj95T32BqWIx4rIZugBhq0hrTZbD--

--NmOn6QAjV8sCLbnYQfPdSivhWJL5DXoK4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsp9fMACgkQwj2R86El
/qjkwwf/ZS6I3HbbmJI+Phx0368boMF1550orjXomTpxkPhUlv1lGKcafm5Ma3VL
0e3NL2osZ2XwCdwq1sCfd8W8h1qHIh6YNBqAiOojndWlb8Y7+Czac1L7s4FFrj6u
uCygNbHtJzaw0DveUvMosX8j4IzAepTlqyQc+lFwXUDOx3GVjRk9zwENZHSuFI1d
BN6cx284ekm2b4zDuRsu+Lc+3RmR5ZMoBXrntR3DZoAj26UjY67+UwU7j3DeO0wu
/XEx6HVpnkKgSnDLYjYyQX3Ky/RFzHtSYphs5+pRl+RRPjy6b34gY2OXugnXz5Or
xQeo77+9LrFepkDXMa61uYwTe0PPBQ==
=Mzbx
-----END PGP SIGNATURE-----

--NmOn6QAjV8sCLbnYQfPdSivhWJL5DXoK4--
