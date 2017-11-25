Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:54716 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751053AbdKYBMr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 20:12:47 -0500
Subject: Re: About 'key type for persistent [...] items'
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
References: <3576cefb-4554-b559-0b26-3679a1e94243@mendix.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <7cf492f3-d70f-360a-495e-4a014ca8737d@gmx.com>
Date: Sat, 25 Nov 2017 09:12:35 +0800
MIME-Version: 1.0
In-Reply-To: <3576cefb-4554-b559-0b26-3679a1e94243@mendix.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Lnq6SXkuhRosqTmg9MUTouB1BrMoJNqah"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Lnq6SXkuhRosqTmg9MUTouB1BrMoJNqah
Content-Type: multipart/mixed; boundary="F4gTmD8URkSBADk2XUqO7t63K9e6Vm5JB";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Message-ID: <7cf492f3-d70f-360a-495e-4a014ca8737d@gmx.com>
Subject: Re: About 'key type for persistent [...] items'
References: <3576cefb-4554-b559-0b26-3679a1e94243@mendix.com>
In-Reply-To: <3576cefb-4554-b559-0b26-3679a1e94243@mendix.com>

--F4gTmD8URkSBADk2XUqO7t63K9e6Vm5JB
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8825=E6=97=A5 03:16, Hans van Kranenburg wrote:
> Hi,
>=20
> Last week, when implementing the automatic classifier to dynamically
> create tree item data objects by key type in python-btrfs, I ran into
> the following commits in btrfs-progs:
>=20
>   commit 8609c8bad68528f668d9ce564b868aa4828107a0
>   btrfs-progs: print-tree: factor out temporary_item dump
> and
>   commit a4b65f00d53deb1b495728dd58253af44fcf70df
>   btrfs-progs: print-tree: factor out persistent_item dump
>=20
> ...which are related to kernel...
>=20
>   commit 50c2d5abe64c1726b48d292a2ab04f60e8238933
>   btrfs: introduce key type for persistent permanent items
> and
>   commit 0bbbccb17fea86818e1a058faf5903aefd20b31a
>   btrfs: introduce key type for persistent temporary items
>=20
> Afaics the goal is to overload types because there can be only 256 in
> total.

Personally speaking, to overload types, we can easily make different
meanings of type based on tree owner.

> However, I'm missing the design decisions behind the
> implementation of it. It's not in the commit messages, and it hasn't
> been on the mailing list.

Btrfs_tree.h has a good enough description for it.

>=20
> Before, there was an 1:1 mapping from key types to data structures. Now=
,
> with the new PERSISTENT_ITEM_KEY and TEMPORARY_ITEM_KEY, it seems items=

> which use this type can be using any data structure they want, so it's
> some kind of YOLO_ITEM_KEY.

For PERSISTENT and TEMPORARY item, they use the objectid and type to
determine the real data structure type.

Since in case of existing PERSISTENT/TEMPORARY item usage, their
objectid is not really used for storing data.

>=20
> The print-tree code in progs 8609c8b and a4b65f0 seems incomplete. For
> example, for the PERSISTENT_ITEM_KEY, there's a switch (objectid) with
> case BTRFS_DEV_STATS_OBJECTID.
>=20
> However, BTRFS_DEV_STATS_OBJECTID is just the value 0. So, that means
> that if I want to have another tree where BTRFS_MOUTON_OBJECTID is also=

> 0, and I'm storing a btrfs_kebab_item struct indexed at
> (BTRFS_MOUTON_OBJECTID, PERSISTENT_ITEM_KEY, 31337), then print_tree.c
> will try to parse the data by calling print_dev_stats?

In this case, you shouldn't have your "BTRFS_MOUNTON_OBJECTID" assigned
to 0.

>=20
> What's the idea behind that? Instead of having the key type field defin=
e
> the struct and meaning, we now suddenly need the tuple (tree, objectid,=

> type),

Not exactly, it's (objectid, type) only to determine the data structure
type for PERSISTENT/TEMPORARY key type.
Btrfs doesn't (yet) use root to determine the meaning.

So current btrfs-progs works fine.

Thanks,
Qu

> and we need all three to determine what's inside the item data?
> So, the code in print_tree.c would also need to know about the tree
> number and pass that into the different functions.
>=20
> Am I missing something, or is my observation correct?
>=20
> Thanks,--
> Hans van Kranenburg
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--F4gTmD8URkSBADk2XUqO7t63K9e6Vm5JB--

--Lnq6SXkuhRosqTmg9MUTouB1BrMoJNqah
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloYw4MXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qij4Af+I+qoM+pGlstvjQ+LS2kHXFn7
6avdTAEQ4Zr7OfXKezzGW/F65NMwmWwgFedxV8RppO+NILCVmseAilKoH3wTRP9z
KB+8WP99dQsfNGHz9zL3k9Ceif4FKoXZ6tFo676ZbZUeYIPfShI3eg/VQK4J1REY
+yQhSvWp0kO5D6Z/Ts47I8CPMUZkxaMqRBf0xpG6xrFbforontq+EIRKaZiH/d76
ZxN5B3G1WJ9Xhhg9zlF4YK3M0Q9yhRHUq339AhCWL8Huhp3rwu66L9AViihebr4m
xln6+zEuRG4LtAED1GH5I+RYryejL9WCfWtX5u0KXP00cPUZm4Hwjpj33ugAYA==
=C0lm
-----END PGP SIGNATURE-----

--Lnq6SXkuhRosqTmg9MUTouB1BrMoJNqah--
