Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:59115 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751716AbdKYBod (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 20:44:33 -0500
Subject: Re: About 'key type for persistent [...] items'
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
References: <3576cefb-4554-b559-0b26-3679a1e94243@mendix.com>
 <7cf492f3-d70f-360a-495e-4a014ca8737d@gmx.com>
Message-ID: <c1025a9f-5cf7-81ec-bb65-8a80c437cfcb@gmx.com>
Date: Sat, 25 Nov 2017 09:44:22 +0800
MIME-Version: 1.0
In-Reply-To: <7cf492f3-d70f-360a-495e-4a014ca8737d@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eT3A1mLoWhDTIqtQJEKtwgRtFLkOEtPim"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eT3A1mLoWhDTIqtQJEKtwgRtFLkOEtPim
Content-Type: multipart/mixed; boundary="1ChwmQwou941DwWh25HKcu1ACm37rcQXk";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Message-ID: <c1025a9f-5cf7-81ec-bb65-8a80c437cfcb@gmx.com>
Subject: Re: About 'key type for persistent [...] items'
References: <3576cefb-4554-b559-0b26-3679a1e94243@mendix.com>
 <7cf492f3-d70f-360a-495e-4a014ca8737d@gmx.com>
In-Reply-To: <7cf492f3-d70f-360a-495e-4a014ca8737d@gmx.com>

--1ChwmQwou941DwWh25HKcu1ACm37rcQXk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8825=E6=97=A5 09:12, Qu Wenruo wrote:
>=20
>=20
> On 2017=E5=B9=B411=E6=9C=8825=E6=97=A5 03:16, Hans van Kranenburg wrote=
:
>> Hi,
>>
>> Last week, when implementing the automatic classifier to dynamically
>> create tree item data objects by key type in python-btrfs, I ran into
>> the following commits in btrfs-progs:
>>
>>   commit 8609c8bad68528f668d9ce564b868aa4828107a0
>>   btrfs-progs: print-tree: factor out temporary_item dump
>> and
>>   commit a4b65f00d53deb1b495728dd58253af44fcf70df
>>   btrfs-progs: print-tree: factor out persistent_item dump
>>
>> ...which are related to kernel...
>>
>>   commit 50c2d5abe64c1726b48d292a2ab04f60e8238933
>>   btrfs: introduce key type for persistent permanent items
>> and
>>   commit 0bbbccb17fea86818e1a058faf5903aefd20b31a
>>   btrfs: introduce key type for persistent temporary items
>>
>> Afaics the goal is to overload types because there can be only 256 in
>> total.
>=20
> Personally speaking, to overload types, we can easily make different
> meanings of type based on tree owner.
>=20
>> However, I'm missing the design decisions behind the
>> implementation of it. It's not in the commit messages, and it hasn't
>> been on the mailing list.
>=20
> Btrfs_tree.h has a good enough description for it.
>=20
>>
>> Before, there was an 1:1 mapping from key types to data structures. No=
w,
>> with the new PERSISTENT_ITEM_KEY and TEMPORARY_ITEM_KEY, it seems item=
s
>> which use this type can be using any data structure they want, so it's=

>> some kind of YOLO_ITEM_KEY.
>=20
> For PERSISTENT and TEMPORARY item, they use the objectid and type to
> determine the real data structure type.
>=20
> Since in case of existing PERSISTENT/TEMPORARY item usage, their
> objectid is not really used for storing data.

PS: PERSISTENT/TEMPORARY keys are not the only keys where only
key->offset is really used.

CHUNK_ITME also has a fixed objecitd, BTRFS_FIRST_CHUNK_TREE_OBJECTID.

And QGROUP_STATUS is even a step further, with 0 as both objectid and
offset.

So from this point, such PERSISTENT/TEMPORARY design doesn't really
follow the existing type design.
It may only help for later expansion, but I doubt if we will use such
schema.

Thanks,
Qu

>=20
>>
>> The print-tree code in progs 8609c8b and a4b65f0 seems incomplete. For=

>> example, for the PERSISTENT_ITEM_KEY, there's a switch (objectid) with=

>> case BTRFS_DEV_STATS_OBJECTID.
>>
>> However, BTRFS_DEV_STATS_OBJECTID is just the value 0. So, that means
>> that if I want to have another tree where BTRFS_MOUTON_OBJECTID is als=
o
>> 0, and I'm storing a btrfs_kebab_item struct indexed at
>> (BTRFS_MOUTON_OBJECTID, PERSISTENT_ITEM_KEY, 31337), then print_tree.c=

>> will try to parse the data by calling print_dev_stats?
>=20
> In this case, you shouldn't have your "BTRFS_MOUNTON_OBJECTID" assigned=

> to 0.
>=20
>>
>> What's the idea behind that? Instead of having the key type field defi=
ne
>> the struct and meaning, we now suddenly need the tuple (tree, objectid=
,
>> type),
>=20
> Not exactly, it's (objectid, type) only to determine the data structure=

> type for PERSISTENT/TEMPORARY key type.
> Btrfs doesn't (yet) use root to determine the meaning.
>=20
> So current btrfs-progs works fine.
>=20
> Thanks,
> Qu
>=20
>> and we need all three to determine what's inside the item data?
>> So, the code in print_tree.c would also need to know about the tree
>> number and pass that into the different functions.
>>
>> Am I missing something, or is my observation correct?
>>
>> Thanks,--
>> Hans van Kranenburg
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20


--1ChwmQwou941DwWh25HKcu1ACm37rcQXk--

--eT3A1mLoWhDTIqtQJEKtwgRtFLkOEtPim
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloYyvYXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhEagf/XhMEw6JJQQZH8UVzzwllVZp5
HmJSd8t7eEVNP6bMGLJ+2J4hXjyhKPqnhg5jygxmANAaO2Zv9o4AESAaaR7/OXhp
7DNotx5C3a7K1C5AombP3koNCWxZWUA3bY1UV2zolP+Xsrrty7Ga/teFbeyYeBzt
rgu8+pfdwOqcvhdMwi/5EiEmz0yY/GAG5B1Oc7WWFNRfbe/fT0y1iSbHRNvNTaEk
ECfgw4+pA/W8C8h9HdqMLMXB2uj+L7hYflkDPUMLJyxfXtoXGV6nZz9POsIiMUXf
SAmas1Ditt/iS3bMTj3PK8/VbDDZFEjSVClgJlHw7igak3PYO+6CnT8esGfkmg==
=7HYo
-----END PGP SIGNATURE-----

--eT3A1mLoWhDTIqtQJEKtwgRtFLkOEtPim--
