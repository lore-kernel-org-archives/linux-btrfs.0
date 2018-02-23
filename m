Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:45517 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751367AbeBWCAy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Feb 2018 21:00:54 -0500
Subject: Re: [RFC] btrfs: Speedup btrfs_read_block_groups()
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: "Ellis H . Wilson III" <ellisw@panasas.com>
References: <20180222045215.16426-1-wqu@suse.com>
 <a4ee5d23-93c5-bf12-cb24-dd903d6f77f9@applied-asynchrony.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <cf530b0c-3e5a-d0b8-84ab-e7225e3bac80@gmx.com>
Date: Fri, 23 Feb 2018 10:00:34 +0800
MIME-Version: 1.0
In-Reply-To: <a4ee5d23-93c5-bf12-cb24-dd903d6f77f9@applied-asynchrony.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3BsYX0polP6zU0bwzbW3QnJDXQPylpXti"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3BsYX0polP6zU0bwzbW3QnJDXQPylpXti
Content-Type: multipart/mixed; boundary="x2JLy76T4xaNnT7qM1oOSAhGgkHMXigSf";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
 Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: "Ellis H . Wilson III" <ellisw@panasas.com>
Message-ID: <cf530b0c-3e5a-d0b8-84ab-e7225e3bac80@gmx.com>
Subject: Re: [RFC] btrfs: Speedup btrfs_read_block_groups()
References: <20180222045215.16426-1-wqu@suse.com>
 <a4ee5d23-93c5-bf12-cb24-dd903d6f77f9@applied-asynchrony.com>
In-Reply-To: <a4ee5d23-93c5-bf12-cb24-dd903d6f77f9@applied-asynchrony.com>

--x2JLy76T4xaNnT7qM1oOSAhGgkHMXigSf
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8823=E6=97=A5 09:12, Holger Hoffst=C3=A4tte wrot=
e:
> On 02/22/18 05:52, Qu Wenruo wrote:
>> btrfs_read_block_groups() is used to build up the block group cache fo=
r
>> all block groups, so it will iterate all block group items in extent
>> tree.
>>
>> For large filesystem (TB level), it will search for BLOCK_GROUP_ITEM
>> thousands times, which is the most time consuming part of mounting
>> btrfs.
>>
>> So this patch will try to speed it up by:
>>
>> 1) Avoid unnecessary readahead
>>    We were using READA_FORWARD to search for block group item.
>>    However block group items are in fact scattered across quite a lot =
of
>>    leaves. Doing readahead will just waste our IO (especially importan=
t
>>    for HDD).
>>
>>    In real world case, for a filesystem with 3T used space, it would
>>    have about 50K extent tree leaves, but only have 3K block group
>>    items. Meaning we need to iterate 16 leaves to meet one block group=

>>    on average.
>>
>>    So readahead won't help but waste slow HDD seeks.
>>
>> 2) Use chunk mapping to locate block group items
>>    Since one block group item always has one corresponding chunk item,=

>>    we could use chunk mapping to get the block group item size.
>>
>>    With block group item size, we can do a pinpoint tree search, inste=
ad
>>    of searching with some uncertain value and do forward search.
>>
>>    In some case, like next BLOCK_GROUP_ITEM is in the next leaf of
>>    current path, we could save such unnecessary tree block read.
>>
>> Cc: Ellis H. Wilson III <ellisw@panasas.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> Since all my TB level storage is all occupied by my NAS, any feedback
>> (especially for the real world mount speed change) is welcome.
>=20
> (sorry for the previous mail without results..finger salad)
>=20
> Decided to give this a try & got some nice results!
> Probably not on the same scale & nonlinear behaviour as Ellis will
> provide since I just don't have that much storage, but interesting
> nevertheless.
>=20
> $btrfs filesystem df /mnt/backup=20
> Data, single: total=3D1.10TiB, used=3D1.09TiB
> System, DUP: total=3D32.00MiB, used=3D144.00KiB
> Metadata, DUP: total=3D4.00GiB, used=3D2.23GiB
> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>=20
> $btrfs-debug-tree -t chunk /dev/sdc1 | grep CHUNK_ITEM | wc -l
> 1137
>=20
> current kernel (4.14++ with most of blk-mq+BFQ from 4.16):
> mount /mnt/backup  0.00s user 0.02s system 1% cpu 1.211 total
> mount /mnt/backup  0.00s user 0.02s system 2% cpu 1.122 total
> mount /mnt/backup  0.00s user 0.02s system 2% cpu 1.236 total
>=20
> patched:
> mount /mnt/backup  0.00s user 0.02s system 1% cpu 1.070 total
> mount /mnt/backup  0.00s user 0.02s system 1% cpu 1.056 total
> mount /mnt/backup  0.00s user 0.02s system 1% cpu 1.058 total
>=20
> That's not overwhelming, but still measurable and nice to have!

Looks pretty good.

And pretty close to my prediction, about 15% improvement.

>=20
> While I was at it I decided to fill up the drive to almost-max
> ~3.7TB and see how much slower it woul=C3=B6d get...you won't believe
> what happened next. :-)
>=20
> $btrfs-debug-tree -t chunk /dev/sdc1 | grep CHUNK_ITEM | wc -l
> 3719
>=20
> mount /mnt/backup  0.00s user 0.02s system 2% cpu 1.328 total
> mount /mnt/backup  0.00s user 0.03s system 2% cpu 1.361 total
> mount /mnt/backup  0.00s user 0.03s system 2% cpu 1.368 total
>=20
> Over three times the data, almost the same mount time as before?
> Yes please!
>=20

This is indeed out of my expectation.

But after some think, this depends on how you fill the fs.

If fill using fallocate/plain dd, it means most of them will be data
using maximum extent size (128M), that will make new data blocks quite
compact, just 8+1 items for each block group.
So a leaf can easily contain around 100 chunks.

This makes block groups iteration for new data block groups quite fast,
as all related tree blocks will be in cache (also explains why cpu usage
get increaseed).

That's to say, if I didn't miss anything, for old kernel it should also
be able to mount in 2 secs.

This in fact would be the worst case for the patch, as normally
readahead would benifit such case.
But since it's pretty much the same mount time for old kernel, I would
call this a win!


> Overall this looks like a really nice improvement. Glad to see
> that my suspicion about the (non)usefulness of the readhead turned
> out to be true. :)

Yep, readahead part is new for such speedup patch(there is similar patch
years ago, but without disabling readahead), and pretty glad to see the
result.

(Although a little sad to know readahead is of little use)

Thanks for your test,
Qu

>=20
> cheers,
> Holger
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--x2JLy76T4xaNnT7qM1oOSAhGgkHMXigSf--

--3BsYX0polP6zU0bwzbW3QnJDXQPylpXti
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqPdcIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjPSQf9EW6pzNJZLtgcXsuQuiSRlksR
QAzHcssmcu5j8+WwO831c7OgGzR/RgwyzfiSlU6KrFRmtp/vQQu4KJXk88pfCrmX
ySIIfvM9+4wXbyc3C3tbEHIbm1NQHvWPbhUBECBG6cSghZ6uXGzClquvRNEzL8hj
WaN4qj8DMWP+r9swBfi1wGy6GJYkYtdpeOjPbcDnPYNS+7MxL31LN+vi2HSeiLUD
v47lw4UaROcmQmERaxoymtNvWwbgB1tdejaSCJLU4/ckAlaj4XGnYAeVN2vBV6vs
AqqK5N+6vt9qfopXfIPXyNXQznXdcOzqTCUXDxKwCYgg+iV5sN5fhZ3hACdikw==
=6I3d
-----END PGP SIGNATURE-----

--3BsYX0polP6zU0bwzbW3QnJDXQPylpXti--
