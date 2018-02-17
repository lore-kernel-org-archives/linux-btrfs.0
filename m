Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49101 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750961AbeBQBAQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Feb 2018 20:00:16 -0500
Subject: Re: Status of FST and mount times
To: "Ellis H. Wilson III" <ellisw@panasas.com>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
 <0c3fb0bb-6fd1-67f6-1c74-3ee98ae15303@gmx.com>
 <0fa921f1-9a54-e410-1305-c88136f4823c@mendix.com>
 <5773ab23-8bee-1434-522b-231c154c4c6e@panasas.com>
 <c59b3618-0dc8-f07c-391f-45b9f42e3aaf@gmx.com>
 <db1e0ee1-c1ae-cc5c-842c-1caa714ef62b@panasas.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b5b93505-13ad-2e30-8daa-b624de5512bd@gmx.com>
Date: Sat, 17 Feb 2018 08:59:56 +0800
MIME-Version: 1.0
In-Reply-To: <db1e0ee1-c1ae-cc5c-842c-1caa714ef62b@panasas.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="utCDtVVsahBFdOWE3wUftQ1vo6Sud123L"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--utCDtVVsahBFdOWE3wUftQ1vo6Sud123L
Content-Type: multipart/mixed; boundary="JeZZHX8E6TtDV1xvzQO1riTQlGLojb1Y4";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Ellis H. Wilson III" <ellisw@panasas.com>,
 Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
 Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <b5b93505-13ad-2e30-8daa-b624de5512bd@gmx.com>
Subject: Re: Status of FST and mount times
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
 <0c3fb0bb-6fd1-67f6-1c74-3ee98ae15303@gmx.com>
 <0fa921f1-9a54-e410-1305-c88136f4823c@mendix.com>
 <5773ab23-8bee-1434-522b-231c154c4c6e@panasas.com>
 <c59b3618-0dc8-f07c-391f-45b9f42e3aaf@gmx.com>
 <db1e0ee1-c1ae-cc5c-842c-1caa714ef62b@panasas.com>
In-Reply-To: <db1e0ee1-c1ae-cc5c-842c-1caa714ef62b@panasas.com>

--JeZZHX8E6TtDV1xvzQO1riTQlGLojb1Y4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8816=E6=97=A5 22:12, Ellis H. Wilson III wrote:
> On 02/15/2018 08:55 PM, Qu Wenruo wrote:
>> On 2018=E5=B9=B402=E6=9C=8816=E6=97=A5 00:30, Ellis H. Wilson III wrot=
e:
>>> Very helpful information.=C2=A0 Thank you Qu and Hans!
>>>
>>> I have about 1.7TB of homedir data newly rsync'd data on a single
>>> enterprise 7200rpm HDD and the following output for btrfs-debug:
>>>
>>> extent tree key (EXTENT_TREE ROOT_ITEM 0) 543384862720 level 2
>>> total bytes 6001175126016
>>> bytes used 1832557875200
>>>
>>> Hans' (very cool) tool reports:
>>> ROOT_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 624.00KiB 0=
(=C2=A0=C2=A0=C2=A0 38) 1(=C2=A0=C2=A0=C2=A0=C2=A0 1)
>>> EXTENT_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 327.31MiB 0( 20881) 1=
(=C2=A0=C2=A0=C2=A0 66) 2(=C2=A0=C2=A0=C2=A0=C2=A0 1)
>>
>> Extent tree is not so large, a little unexpected to see such slow moun=
t.
>>
>> BTW, how many chunks do you have?
>>
>> It could be checked by:
>>
>> # btrfs-debug-tree -t chunk <device> | grep CHUNK_ITEM | wc -l
>=20
> Since yesterday I've doubled the size by copying the homdir dataset in
> again.=C2=A0 Here are new stats:
>=20
> extent tree key (EXTENT_TREE ROOT_ITEM 0) 385990656 level 2
> total bytes 6001175126016
> bytes used 3663525969920
>=20
> $ sudo btrfs-debug-tree -t chunk /dev/sdb | grep CHUNK_ITEM | wc -l
> 3454

OK, this explains everything.

There are too many chunks.
This means at mount you need to search for block group item 3454 times.

Even each search only needs to iterate 3 tree blocks, multiply it 3454
it would still be a big work.
Although some tree blocks like the root node and level 1 nodes can be
cached, we still need to read about 3500 tree blocks.

If the fs is created using 16K nodesize, this means you need to do
random read for 54M using 16K blocksize.

No wonder it will takes some time.

Normally I would expect 1G chunk for each data and metadata chunk.

If there is nothing special, it means your filesystem is already larger
than 3T.
If your used space is way smaller (less than 30%) than 3.5T, then this
means your chunk usage is pretty low, and in that case, balance to
reduce number of chunks (block groups) would reduce mount time.

My personally estimate about mount time is O(nlogn).
So if you are able to reduce chunk number to half, you could reduce
mount time by 60%.

>=20
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
> The old mean mount time was 4.319s.=C2=A0 It now takes 11.537s for the
> doubled dataset.=C2=A0 Again please realize this is on an old version o=
f
> BTRFS (4.5.5), so perhaps newer ones will perform better, but I'd still=

> like to understand this delay more.=C2=A0 Should I expect this to scale=
 in
> this way all the way up to my proposed 60-80TB filesystem so long as th=
e
> file size distribution stays roughly similar?=C2=A0 That would definite=
ly be
> in terms of multiple minutes at that point.
>=20
>>> Taking 100 snapshots (no changes between snapshots however) of the ab=
ove
>>> subvolume doesn't appear to impact mount/umount time.
>>
>> 100 unmodified snapshots won't affect mount time.
>>
>> It needs new extents, which can be created by overwriting extents in
>> snapshots.
>> So it won't really cause much difference if all these snapshots are al=
l
>> unmodified.
>=20
> Good to know, thanks!
>=20
>>> Snapshot creation
>>> and deletion both operate at between 0.25s to 0.5s.
>>
>> IIRC snapshot deletion is delayed, so the real work doesn't happen whe=
n
>> "btrfs sub del" returns.
>=20
> I was using btrfs sub del -C for the deletions, so I believe (if that
> command truly waits for the subvolume to be utterly gone) it captures
> the entirety of the snapshot.

No, snapshot deletion is completely delayed in background.

-C only ensures that even a powerloss happen after command return, you
won't see the snapshot anywhere, but it will still be deleted in backgrou=
nd.

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



--JeZZHX8E6TtDV1xvzQO1riTQlGLojb1Y4--

--utCDtVVsahBFdOWE3wUftQ1vo6Sud123L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqHfo0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjU8wgAqPP3eG3N3Ew59v7cnEriuBZK
YdVv2/wr2KQSuajrBK3SXy53tm4IbLx4FqYwIllaPwRZPOC9hyiFlIwrjozKqYF0
seZj3i+1c+NrSXTi9f/Le4/xYz9MaBoYGgL9HnbDyRdt9P6uLM/75YDnetC1Z6+Z
IkiruSmXmv6RuN/ft5s0cCLY8aWuyp/kNVCJXEZdHOfT4W+3KxfQJ9pawThzfjXT
UAT2T0dWvEYL3U+qLjFJBdUCtiWyPTY3pxc51vYjCtZCFaraW4Jj1zTumYbFFqCs
MMhj2zZTLEJJ90Pv1jd8XLKRa9l3ukvEStEE14y7t9fFRV1vdzRs5i/f5XyOIA==
=bTy2
-----END PGP SIGNATURE-----

--utCDtVVsahBFdOWE3wUftQ1vo6Sud123L--
