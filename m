Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:35217 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751413AbeBVAx5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 19:53:57 -0500
Subject: Re: Status of FST and mount times
To: "Ellis H. Wilson III" <ellisw@panasas.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
 <0c3fb0bb-6fd1-67f6-1c74-3ee98ae15303@gmx.com>
 <0fa921f1-9a54-e410-1305-c88136f4823c@mendix.com>
 <5773ab23-8bee-1434-522b-231c154c4c6e@panasas.com>
 <c59b3618-0dc8-f07c-391f-45b9f42e3aaf@gmx.com>
 <db1e0ee1-c1ae-cc5c-842c-1caa714ef62b@panasas.com>
 <b5b93505-13ad-2e30-8daa-b624de5512bd@gmx.com>
 <5743750c-644d-9160-c0f3-599caf92dcb6@panasas.com>
 <ccc1f937-1cdd-afdd-d164-99c3ad648387@gmail.com>
 <4590b70e-2be7-b511-1428-685dcf2c26c6@gmx.com>
 <bcb18a10-3e87-66f7-63a4-b6f9906680ec@panasas.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <dc132bf2-ac51-5535-969d-eb93dae788af@gmx.com>
Date: Thu, 22 Feb 2018 08:53:38 +0800
MIME-Version: 1.0
In-Reply-To: <bcb18a10-3e87-66f7-63a4-b6f9906680ec@panasas.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RxpVljYdRkwz15gXufZNPj3XvEbX1N944"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RxpVljYdRkwz15gXufZNPj3XvEbX1N944
Content-Type: multipart/mixed; boundary="NAl4guw83IP2XKfZ7jpej7LhSBvEjnRde";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Ellis H. Wilson III" <ellisw@panasas.com>,
 "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
 Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
 Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <dc132bf2-ac51-5535-969d-eb93dae788af@gmx.com>
Subject: Re: Status of FST and mount times
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
 <0c3fb0bb-6fd1-67f6-1c74-3ee98ae15303@gmx.com>
 <0fa921f1-9a54-e410-1305-c88136f4823c@mendix.com>
 <5773ab23-8bee-1434-522b-231c154c4c6e@panasas.com>
 <c59b3618-0dc8-f07c-391f-45b9f42e3aaf@gmx.com>
 <db1e0ee1-c1ae-cc5c-842c-1caa714ef62b@panasas.com>
 <b5b93505-13ad-2e30-8daa-b624de5512bd@gmx.com>
 <5743750c-644d-9160-c0f3-599caf92dcb6@panasas.com>
 <ccc1f937-1cdd-afdd-d164-99c3ad648387@gmail.com>
 <4590b70e-2be7-b511-1428-685dcf2c26c6@gmx.com>
 <bcb18a10-3e87-66f7-63a4-b6f9906680ec@panasas.com>
In-Reply-To: <bcb18a10-3e87-66f7-63a4-b6f9906680ec@panasas.com>

--NAl4guw83IP2XKfZ7jpej7LhSBvEjnRde
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8821=E6=97=A5 22:49, Ellis H. Wilson III wrote:
> On 02/20/2018 08:49 PM, Qu Wenruo wrote:
>>>>> On 2018=E5=B9=B402=E6=9C=8816=E6=97=A5 22:12, Ellis H. Wilson III w=
rote:
>>>>>> $ sudo btrfs-debug-tree -t chunk /dev/sdb | grep CHUNK_ITEM | wc -=
l
>>>>>> 3454
>>>>>
>> Increasing node size may reduce extent tree size. Although at most
>> reduce one level AFAIK.
>>
>> But considering that the higher the node is, the more chance it's
>> cached, reducing tree height wouldn't bring much performance impact
>> AFAIK.
>>
>> If one could do real world benchmark to beat or prove my assumption, i=
t
>> would be much better though.
>=20
> I'm willing to try this if you tell me exactly what you'd like me to do=
=2E
> =C2=A0I've not mucked with nodesize before, so I'd like to avoid changi=
ng it
> to something absurd.
>=20
>>> Qu's suggestion is actually independent of all the above reasons, but=

>>> does kind of fit in with the fourth as another case of preventative
>>> maintenance.
>>
>> My suggestion is to use balance to reduce number of block groups, so w=
e
>> could do less search at mount time.
>>
>> It's more like reason 2.
>>
>> But it only works for case where there are a lot of fragments so a lot=

>> of chunks are not fully utilized.
>> Unfortunately, that's not the case for OP, so my suggestion doesn't ma=
ke
>> sense here.
>=20
> I ran the balance all the same, and the number of chunks has not
> changed.=C2=A0 Before 3454, and after 3454:
> =C2=A0$ sudo btrfs-debug-tree -t chunk /dev/sdb | grep CHUNK_ITEM | wc =
-l
> 3454
>=20
> HOWEVER, the time to mount has gone up somewhat significantly, from
> 11.537s to 16.553s, which was very unexpected.=C2=A0 Output from previo=
usly
> run commands shows the extent tree metadata grew about 25% due to the
> balance.=C2=A0 Everything else stayed roughly the same, and no addition=
al
> data was added to the system (nor snapshots taken, nor additional
> volumes added, etc):

In theory, if the extent tree height and block group usage doesn't
change dramatically, the tree block reads caused by block groups
iteration shouldn't change much.

But in your case, extent tree leaves increased, I believe it's the tree
block readahead causing the problem.

>=20
> Before balance:
> $ sudo ./show_metadata_tree_sizes.py /mnt/btrfs/
> ROOT_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=
=2E14MiB 0(=C2=A0=C2=A0=C2=A0 72) 1(=C2=A0=C2=A0=C2=A0=C2=A0 1)
> EXTENT_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 644.27MiB 0( 41101) 1(=C2=
=A0=C2=A0 131) 2(=C2=A0=C2=A0=C2=A0=C2=A0 1)
> CHUNK_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 384.00KiB 0(=C2=A0=
=C2=A0=C2=A0 23) 1(=C2=A0=C2=A0=C2=A0=C2=A0 1)
> DEV_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 272.00Ki=
B 0(=C2=A0=C2=A0=C2=A0 16) 1(=C2=A0=C2=A0=C2=A0=C2=A0 1)
> FS_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 11.55GiB 0(754442) 1(=C2=A0 2179) 2(=C2=A0=C2=A0=C2=A0=C2=A0 5) 3(=C2=A0=
=C2=A0=C2=A0=C2=A0 2)
> CSUM_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3=
=2E50GiB 0(228593) 1(=C2=A0=C2=A0 791) 2(=C2=A0=C2=A0=C2=A0=C2=A0 2) 3(=C2=
=A0=C2=A0=C2=A0=C2=A0 1)
> QUOTA_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0.00B
> UUID_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 16.00Ki=
B 0(=C2=A0=C2=A0=C2=A0=C2=A0 1)
> FREE_SPACE_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00B
> DATA_RELOC_TREE=C2=A0=C2=A0=C2=A0 16.00KiB 0(=C2=A0=C2=A0=C2=A0=C2=A0 1=
)
>=20
> After balance:
> $ sudo ./show_metadata_tree_sizes.py /mnt/btrfs/
> ROOT_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=
=2E16MiB 0(=C2=A0=C2=A0=C2=A0 73) 1(=C2=A0=C2=A0=C2=A0=C2=A0 1)
> EXTENT_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 806.50MiB 0( 51419) 1(=C2=
=A0=C2=A0 196) 2(=C2=A0=C2=A0=C2=A0=C2=A0 1)
> CHUNK_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 384.00KiB 0(=C2=A0=
=C2=A0=C2=A0 23) 1(=C2=A0=C2=A0=C2=A0=C2=A0 1)
> DEV_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 272.00Ki=
B 0(=C2=A0=C2=A0=C2=A0 16) 1(=C2=A0=C2=A0=C2=A0=C2=A0 1)
> FS_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 11.55GiB 0(754442) 1(=C2=A0 2179) 2(=C2=A0=C2=A0=C2=A0=C2=A0 5) 3(=C2=A0=
=C2=A0=C2=A0=C2=A0 2)
> CSUM_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3=
=2E49GiB 0(227920) 1(=C2=A0=C2=A0 804) 2(=C2=A0=C2=A0=C2=A0=C2=A0 2) 3(=C2=
=A0=C2=A0=C2=A0=C2=A0 1)
> QUOTA_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0.00B
> UUID_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 16.00Ki=
B 0(=C2=A0=C2=A0=C2=A0=C2=A0 1)
> FREE_SPACE_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00B
> DATA_RELOC_TREE=C2=A0=C2=A0=C2=A0 16.00KiB 0(=C2=A0=C2=A0=C2=A0=C2=A0 1=
)
>=20
>> BTW, if OP still wants to try something to possibly to reduce mount ti=
me
>> with same the fs, I could try some modification to current block group=

>> iteration code to see if it makes sense.
>=20
> I'm glad to try anything if it's helpful to improving BTRFS.=C2=A0 Just=
 let
> me know.

Glad to hear that.

I would send out some RFC patch to see if it would help to reduce mount
time (maybe only by a little)

Thanks,
Qu

>=20
> Best,
>=20
> ellis
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--NAl4guw83IP2XKfZ7jpej7LhSBvEjnRde--

--RxpVljYdRkwz15gXufZNPj3XvEbX1N944
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqOFJIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qin1wf/U/wQ1com5KlY8mUdoV4q0RzI
cXNrnp1Lq7S4WVwE6mh0ct/AgdZiotiI8dcOcpEdww4vIgt5dW4UJzQ3sujJ2G9D
sXgUJyG7AV/fX4UUGdeBWTOIDkMke5BzIXSaa6KK7Lm8HXsTwWV0GaZtPGPnWOmX
nnup5Lyw0R9aYwqLr5O6rSbZbs7UBrhuajZnWnkvPDQ0rfwxUA0CMdTZky+k32Go
rgXUC7cVHRAoHaa1LhEsj31h4pOp+y5JcFzOwEXeGC6P2lfmZt4jaF/RKjOjPujj
25VC1wjIljmoFL39Nczl07aerRqG/QaTTnYXPkr86FIfdf4X/J+M3thug5FpZg==
=Fy8f
-----END PGP SIGNATURE-----

--RxpVljYdRkwz15gXufZNPj3XvEbX1N944--
