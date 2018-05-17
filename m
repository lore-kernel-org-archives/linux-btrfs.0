Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44581 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751319AbeEQOqN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 10:46:13 -0400
Subject: Re: [PATCH v2 0/3] btrfs: add read mirror policy
To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <20180516100359.7752-1-anand.jain@oracle.com>
 <20180516223523.GG6649@twin.jikos.cz>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <9b32d248-6311-fa20-9d17-364310316412@suse.com>
Date: Thu, 17 May 2018 10:46:09 -0400
MIME-Version: 1.0
In-Reply-To: <20180516223523.GG6649@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pkEQNsvKDowVpnSoiO9lVoA1yogJLHOBZ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pkEQNsvKDowVpnSoiO9lVoA1yogJLHOBZ
Content-Type: multipart/mixed; boundary="hsIP3mzRSObZKpE2WyfuU7CQ11Lc68jkN";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <9b32d248-6311-fa20-9d17-364310316412@suse.com>
Subject: Re: [PATCH v2 0/3] btrfs: add read mirror policy
References: <20180516100359.7752-1-anand.jain@oracle.com>
 <20180516223523.GG6649@twin.jikos.cz>
In-Reply-To: <20180516223523.GG6649@twin.jikos.cz>

--hsIP3mzRSObZKpE2WyfuU7CQ11Lc68jkN
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/16/18 6:35 PM, David Sterba wrote:
> On Wed, May 16, 2018 at 06:03:56PM +0800, Anand Jain wrote:
>> Not yet ready for the integration. As I need to introduce
>> -o no_read_mirror_policy instead of -o read_mirror_policy=3D-<devid>
>=20
> Mount option is mostly likely not the right interface for setting such
> options, as usual.


I've seen a few alternate suggestions in the thread.  I suppose the real
question is: what and where is the intended persistence for this choice?

A mount option gets it via fstab.  How would a user be expected to set
it consistently via ioctl on each mount?  Properties could work, but
there's more discussion needed there.  Personally, I like the property
idea since it could conceivably be used on a per-file basis.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--hsIP3mzRSObZKpE2WyfuU7CQ11Lc68jkN--

--pkEQNsvKDowVpnSoiO9lVoA1yogJLHOBZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlr9lbIACgkQHntLYyF5
5bLlrBAAiVljZ3whqGIm0mWOm5q2P8REYTyOrEE3JNfpoTzX03O8W679vNYu5aah
Lk2/dk4rwcJnzx98NalwyPz6tgSFNqgQnd/WhddaPpgOXhDersibSfaVXdDI6Fge
iTvwo0ztVnC7OYQtb3ejV0g3sg8uzeL5USnH3att1Jh06yxgYgCdFFOxUX/uv+46
LFSsiAQENyjAGOjhdRUPVaTMbG6NyKmWfLm0VBwj/JxWYTx6uYg9kt98Lcsg33Vp
Xe1cSYvGaYtzrXQjIN5t38Q9UWcHu7MghGxwQs/7luDMA9mOo6s3He5DV4zm/Kqn
XM5dLPxWbFrRbVgiaJhOtPEmLtBAfckEc6AiZapv62S2gKFp1oa0PRdF7ZIRYDcB
uEYjm+T2PVslwqurOLIL871CNad/cgol0ZyMfP3VQWi3zBbn0fgYtdqx4ttca0rd
fis2CGL0qO6EanI+7thsd2YmH3z8DaYYLmeB1PsAoUJMb9/TIIbl3PKCabUXhPGi
wopZfaoNC/OKCj3XmR+ASCg3xOKYJmEvi5xdYKj5347k5gVIqX2bggZMkJtIzh8O
nwX3E51OXCNNVF23vzHnBnZ7ytRoRVgghuJDSU1kxSIahw7ixN9cUR+QhGG3MIRd
KfSFpS8Mn3vAfvHjM9yXwHP9TlXmQRIjkNO42KViVR1Yo14ZcEk=
=A3DG
-----END PGP SIGNATURE-----

--pkEQNsvKDowVpnSoiO9lVoA1yogJLHOBZ--
