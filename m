Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52865 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726085AbeHXDWU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 23:22:20 -0400
Subject: Re: Reproducer for "compressed data + hole data corruption bug, 2018
 editiion"
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: linux-btrfs@vger.kernel.org
References: <20180823031125.GE13528@hungrycats.org>
 <8273c186-50ec-32d8-ffb3-23bb0b4fe48e@gmx.com>
 <20180823164436.GG13528@hungrycats.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <96feaecb-9450-31b4-fa40-c512bcf3e90e@gmx.com>
Date: Fri, 24 Aug 2018 07:50:06 +0800
MIME-Version: 1.0
In-Reply-To: <20180823164436.GG13528@hungrycats.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="b0ZpdIosyKEI7tIx7jhdmM3ter2rtE4cD"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--b0ZpdIosyKEI7tIx7jhdmM3ter2rtE4cD
Content-Type: multipart/mixed; boundary="gVsr3QAMAzhU9hEZGOE13n7IiHled7YVw";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <96feaecb-9450-31b4-fa40-c512bcf3e90e@gmx.com>
Subject: Re: Reproducer for "compressed data + hole data corruption bug, 2018
 editiion"
References: <20180823031125.GE13528@hungrycats.org>
 <8273c186-50ec-32d8-ffb3-23bb0b4fe48e@gmx.com>
 <20180823164436.GG13528@hungrycats.org>
In-Reply-To: <20180823164436.GG13528@hungrycats.org>

--gVsr3QAMAzhU9hEZGOE13n7IiHled7YVw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/24 =E4=B8=8A=E5=8D=8812:44, Zygo Blaxell wrote:
> On Thu, Aug 23, 2018 at 01:10:48PM +0800, Qu Wenruo wrote:
>> On 2018/8/23 =E4=B8=8A=E5=8D=8811:11, Zygo Blaxell wrote:
>>> This is a repro script for a btrfs bug that causes corrupted data rea=
ds
>>> when reading a mix of compressed extents and holes.  The bug is
>>> reproducible on at least kernels v4.1..v4.18.
>>
>> This bug already sounds more serious than previous nodatasum +
>> compression bug.
>=20
> Maybe.  "compression + holes corruption bug 2017" could be avoided with=

> the max-inline=3D0 mount option without disabling compression.  This ti=
me,
> the workaround is more intrusive:  avoid all applications that use dedu=
p
> or hole-punching.
>=20
>>> Some more observations and background follow, but first here is the
>>> script and some sample output:
>>>
>>> 	root@rescue:/test# cat repro-hole-corruption-test
>>> 	#!/bin/bash
>>>
>>> 	# Write a 4096 byte block of something
>>> 	block () { head -c 4096 /dev/zero | tr '\0' "\\$1"; }
>>>
>>> 	# Here is some test data with holes in it:
>>> 	for y in $(seq 0 100); do
>>> 		for x in 0 1; do
>>> 			block 0;
>>> 			block 21;
>>> 			block 0;
>>> 			block 22;
>>> 			block 0;
>>> 			block 0;
>>> 			block 43;
>>> 			block 44;
>>> 			block 0;
>>> 			block 0;
>>> 			block 61;
>>> 			block 62;
>>> 			block 63;
>>> 			block 64;
>>> 			block 65;
>>> 			block 66;> 		done
>>
>> Does the content has any difference on this bug?
>> It's just 16 * 4K * 2 * 101 data write *without* any hole so far.
>=20
> The content of the extents doesn't seem to matter, other than it needs =
to
> be compressible so that the extents on disk are compressed.  The bug is=

> also triggered by writing non-zero data to all blocks, and then punchin=
g
> the holes later with "fallocate -p -l 4096 -o $(( insert math here ))".=

>=20
> The layout of the extents matters a lot.  I have to loop hundreds or
> thousands of times to hit the bug if the first block in the pattern is
> not a hole, or if the non-hole extents are different sizes or positions=

> than above.
>=20
> I tried random patterns of holes and extent refs, and most of them have=

> an order of magnitude lower hit rates than the above.  This might be du=
e
> to some relationship between the alignment of read() request boundaries=

> with extent boundaries, but I haven't done any tests designed to detect=

> such a relationship.
>=20
> In the wild, corruption happens on some files much more often than othe=
rs.
> This seems to be correlated with the extent layout as well.
>=20
> I discovered the bug by examining files that were intermittently but
> repeatedly failing routine data integrity checks, and found that in eve=
ry
> case they had similar hole + extent patterns near the point where data
> was corrupted.
>=20
> I did a search on some big filesystems for the
> hole-refExtentA-hole-refExtentA pattern and found several files with
> this pattern that had passed previous data integrity checks, but would
> fail randomly in the sha1sum/drop-caches loop.
>=20
>> This should indeed cause 101 128K compressed data extent.
>> But I'm wondering the description about 'holes'.
>=20
> The holes are coming, wait for it... ;)
>=20
>>> 	done > am
>>> 	sync
>>>
>>> 	# Now replace those 101 distinct extents with 101 references to the =
first extent
>>> 	btrfs-extent-same 131072 $(for x in $(seq 0 100); do echo am $((x * =
131072)); done) 2>&1 | tail
>>
>> Will this bug still happen by creating one extent and then reflink it
>> 101 times?
>=20
> Yes.  I used btrfs-extent-same because a binary is included in the
> Debian duperemove package, but I use it only for convenience.
>=20
> It's not necessary to have hundreds of references to the same extent--e=
ven
> two refs to a single extent plus a hole can trigger the bug sometimes.
> 100 references in a single file will trigger the bug so often that it
> can be detected within the first 20 sha1sum loops.
>=20
> When the corruption occurs, it affects around 90 of the original 101
> extents.  The different sha1sum results are due to different extents
> giving bad data on different runs.
>=20
>>> 	# Punch holes into the extent refs
>>> 	fallocate -v -d am
>>
>> Hole-punch in fact happens here.
>>
>> BTW, will add a "sync" here change the result?
>=20
> No.  You can reboot the machine here if you like, it does not change
> anything that happens during reads later.

So it looks like my assumption of bad file extent interpreter is getting
more and more valid.

It has nothing to do with the race against hole punching/write, but only
the file layout and extent map cache.

>=20
> Looking at the extent tree in btrfs-debug-tree, the data on disk
> looks correct, and btrfs does read it correctly most of the time (the
> correct sha1sum below is 6926a34e0ab3e0a023e8ea85a650f5b4217acab4).
> The corruption therefore comes from btrfs read() producing incorrect
> data in some instances.
>=20
>>> 	# Do some other stuff on the machine while this runs, and watch the =
sha1sums change!
>>> 	while :; do echo $(sha1sum am); sysctl -q vm.drop_caches=3D{1,2,3}; =
sleep 1; done
>>>
>>> 	root@rescue:/test# ./repro-hole-corruption-test
>>> 	i: 91, status: 0, bytes_deduped: 131072
>>> 	i: 92, status: 0, bytes_deduped: 131072
>>> 	i: 93, status: 0, bytes_deduped: 131072
>>> 	i: 94, status: 0, bytes_deduped: 131072
>>> 	i: 95, status: 0, bytes_deduped: 131072
>>> 	i: 96, status: 0, bytes_deduped: 131072
>>> 	i: 97, status: 0, bytes_deduped: 131072
>>> 	i: 98, status: 0, bytes_deduped: 131072
>>> 	i: 99, status: 0, bytes_deduped: 131072
>>> 	13107200 total bytes deduped in this operation
>>> 	am: 4.8 MiB (4964352 bytes) converted to sparse holes.
>>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>> 	072a152355788c767b97e4e4c0e4567720988b84 am
>>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>> 	bf00d862c6ad436a1be2be606a8ab88d22166b89 am
>>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>> 	0d44cdf030fb149e103cfdc164da3da2b7474c17 am
>>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>> 	60831f0e7ffe4b49722612c18685c09f4583b1df am
>>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>> 	a19662b294a3ccdf35dbb18fdd72c62018526d7d am
>>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>>> 	^C
>>
>> It looks like we have something wrong interpreting file extent, maybe
>> related to extent map merging.
>>
>> BTW, if without dropping page cache and no read corruption happens, it=

>> would limit the range of problem we're looking for.
>=20
> The page cache drop makes reproduction easier/faster.  If you don't dro=
p
> caches, you have to wait for the data to be evicted from page cache or
> the data from read() will not change.

So it's highly possible that file extent interpreter is causing the probl=
em.

Thanks,
Qu

>=20
> In the wild, if I do a sha1sum loop on a few hundred GB of data known
> to have the hole-extent-hole pattern (so the pages are evicted between
> sha1sum runs), I see similar results without explicitly dropping caches=
=2E
>=20
> If you read the file with a cold cache from two processes at once
> (e.g. you run 'hd am' while the sha1sum/drop-cache loop is running)
> the data changes faster (different on 90% of reads instead of just 20%)=
=2E
>=20
>> Thanks,
>> Qu
>>
>>>
>>> Corruption occurs most often when there is a sequence like this in a =
file:
>>>
>>> 	ref 1: hole
>>> 	ref 2: extent A, offset 0
>>> 	ref 3: hole
>>> 	ref 4: extent A, offset 8192
>>>
>>> This scenario typically arises due to hole-punching or deduplication.=

>>> Hole-punching replaces one extent ref with two references to the same=

>>> extent with a hole between them, so:
>>>
>>> 	ref 1:  extent A, offset 0, length 16384
>>>
>>> becomes:
>>>
>>> 	ref 1:  extent A, offset 0, length 4096
>>> 	ref 2:  hole, length 8192
>>> 	ref 3:  extent A, offset 12288, length 4096
>>>
>>> Deduplication replaces two distinct extent refs surrounding a hole wi=
th
>>> two references to one of the duplicate extents, turning this:
>>>
>>> 	ref 1:  extent A, offset 0, length 4096
>>> 	ref 2:  hole, length 8192
>>> 	ref 3:  extent B, offset 0, length 4096
>>>
>>> into this:
>>>
>>> 	ref 1:  extent A, offset 0, length 4096
>>> 	ref 2:  hole, length 8192
>>> 	ref 3:  extent A, offset 0, length 4096
>>>
>>> Compression is required (zlib, zstd, or lzo) for corruption to occur.=

>>> I am not able to reproduce the issue with an uncompressed extent nor
>>> have I observed any such corruption in the wild.
>>>
>>> The presence or absence of the no-holes filesystem feature has no eff=
ect.
>>>
>>> Ordinary writes can lead to pairs of extent references to the same ex=
tent
>>> separated by a reference to a different extent; however, in this case=

>>> there is data to be read from a real extent, instead of pages that ha=
ve
>>> to be zero filled from a hole.  If ordinary non-hole writes could tri=
gger
>>> this bug, every page-oriented database engine would be crashing all t=
he
>>> time on btrfs with compression enabled, and it's unlikely that would =
not
>>> have been noticed between 2015 and now.  An ordinary write that split=
s
>>> an extent ref would look like this:
>>>
>>> 	ref 1:  extent A, offset 0, length 4096
>>> 	ref 2:  extent C, offset 0, length 8192
>>> 	ref 3:  extent A, offset 12288, length 4096
>>>
>>> Sparse writes can lead to pairs of extent references surrounding a ho=
le;
>>> however, in this case the extent references will point to different
>>> extents, avoiding the bug.  If a sparse write could trigger the bug,
>>> the rsync -S option and qemu/kvm 'raw' disk image files (among many
>>> other tools that produce sparse files) would be unusable, and it's
>>> unlikely that would not have been noticed between 2015 and now either=
=2E
>>> Sparse writes look like this:
>>>
>>> 	ref 1:  extent A, offset 0, length 4096
>>> 	ref 2:  hole, length 8192
>>> 	ref 3:  extent B, offset 0, length 4096
>>>
>>> The pattern or timing of read() calls seems to be relevant.  It is ve=
ry
>>> hard to see the corruption when reading files with 'hd', but 'cat | h=
d'
>>> will see the corruption just fine.  Similar problems exist with 'cmp'=

>>> but not 'sha1sum'.  Two processes reading the same file at the same t=
ime
>>> seem to trigger the corruption very frequently.
>>>
>>> Some patterns of holes and data produce corruption faster than others=
=2E
>>> The pattern generated by the script above is based on instances of
>>> corruption I've found in the wild, and has a much better repro rate t=
han
>>> random holes.
>>>
>>> The corruption occurs during reads, after csum verification and befor=
e
>>> decompression, so btrfs detects no csum failures.  The data on disk
>>> seems to be OK and could be read correctly once the kernel bug is fix=
ed.
>>> Repeated reads do eventually return correct data, but there is no way=

>>> for userspace to distinguish between corrupt and correct data reliabl=
y.
>>>
>>> The corrupted data is usually data replaced by a hole or a copy of ot=
her
>>> blocks in the same extent.
>>>
>>> The behavior is similar to some earlier bugs related to holes and
>>> Compressed data in btrfs, but it's new and not fixed yet--hence,
>>> "2018 edition."
>>>
>>
>=20
>=20
>=20


--gVsr3QAMAzhU9hEZGOE13n7IiHled7YVw--

--b0ZpdIosyKEI7tIx7jhdmM3ter2rtE4cD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlt/SC4ACgkQwj2R86El
/qhXYQf9G6Pg4gfrXxS8j0BVuGfxlGGNl/c64R/h3cZecP/7AJeEbitSKtIS9Fro
SwIkVjpQo6dsOU/auVkKhfjVBSI+1iArHqs0UR3xoDh9VwUCerkft/NoMg3Jzwmg
Myn2Begw4B61l533b6JSm/xjWuYK125s0DPHQKKCIzWZKVR5Mzfjv5tKMS98jjuA
obnQuZksQoBAu/kouk2G97u6V/TtpvIgyfFHp1YTgICbL+nwpL9qp85l645JM5YW
bnLv/e6UUIVLIhB/lfbVqN75rVD0LzW8dyW6bqpxDxT378bErlny85DiqbNDu595
rtnDhD02poWbVYW6RBWRVGloHkPioQ==
=uvuW
-----END PGP SIGNATURE-----

--b0ZpdIosyKEI7tIx7jhdmM3ter2rtE4cD--
