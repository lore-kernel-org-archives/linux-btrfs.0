Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:58019 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbeHWIiz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 04:38:55 -0400
Subject: Re: Reproducer for "compressed data + hole data corruption bug, 2018
 editiion"
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, linux-btrfs@vger.kernel.org
References: <20180823031125.GE13528@hungrycats.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8273c186-50ec-32d8-ffb3-23bb0b4fe48e@gmx.com>
Date: Thu, 23 Aug 2018 13:10:48 +0800
MIME-Version: 1.0
In-Reply-To: <20180823031125.GE13528@hungrycats.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="idTC29eTx669Z5e2kp2BjszTxnJR6CHKc"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--idTC29eTx669Z5e2kp2BjszTxnJR6CHKc
Content-Type: multipart/mixed; boundary="A5z9HjdEhAg8QaAYdrTDjPlJGkQDnM23D";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, linux-btrfs@vger.kernel.org
Message-ID: <8273c186-50ec-32d8-ffb3-23bb0b4fe48e@gmx.com>
Subject: Re: Reproducer for "compressed data + hole data corruption bug, 2018
 editiion"
References: <20180823031125.GE13528@hungrycats.org>
In-Reply-To: <20180823031125.GE13528@hungrycats.org>

--A5z9HjdEhAg8QaAYdrTDjPlJGkQDnM23D
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/23 =E4=B8=8A=E5=8D=8811:11, Zygo Blaxell wrote:
> This is a repro script for a btrfs bug that causes corrupted data reads=

> when reading a mix of compressed extents and holes.  The bug is
> reproducible on at least kernels v4.1..v4.18.

This bug already sounds more serious than previous nodatasum +
compression bug.

>=20
> Some more observations and background follow, but first here is the
> script and some sample output:
>=20
> 	root@rescue:/test# cat repro-hole-corruption-test
> 	#!/bin/bash
>=20
> 	# Write a 4096 byte block of something
> 	block () { head -c 4096 /dev/zero | tr '\0' "\\$1"; }
>=20
> 	# Here is some test data with holes in it:
> 	for y in $(seq 0 100); do
> 		for x in 0 1; do
> 			block 0;
> 			block 21;
> 			block 0;
> 			block 22;
> 			block 0;
> 			block 0;
> 			block 43;
> 			block 44;
> 			block 0;
> 			block 0;
> 			block 61;
> 			block 62;
> 			block 63;
> 			block 64;
> 			block 65;
> 			block 66;> 		done

Does the content has any difference on this bug?
It's just 16 * 4K * 2 * 101 data write *without* any hole so far.

This should indeed cause 101 128K compressed data extent.
But I'm wondering the description about 'holes'.

> 	done > am
> 	sync
>=20
> 	# Now replace those 101 distinct extents with 101 references to the fi=
rst extent
> 	btrfs-extent-same 131072 $(for x in $(seq 0 100); do echo am $((x * 13=
1072)); done) 2>&1 | tail

Will this bug still happen by creating one extent and then reflink it
101 times?

>=20
> 	# Punch holes into the extent refs
> 	fallocate -v -d am

Hole-punch in fact happens here.

BTW, will add a "sync" here change the result?

>=20
> 	# Do some other stuff on the machine while this runs, and watch the sh=
a1sums change!
> 	while :; do echo $(sha1sum am); sysctl -q vm.drop_caches=3D{1,2,3}; sl=
eep 1; done
>=20
> 	root@rescue:/test# ./repro-hole-corruption-test
> 	i: 91, status: 0, bytes_deduped: 131072
> 	i: 92, status: 0, bytes_deduped: 131072
> 	i: 93, status: 0, bytes_deduped: 131072
> 	i: 94, status: 0, bytes_deduped: 131072
> 	i: 95, status: 0, bytes_deduped: 131072
> 	i: 96, status: 0, bytes_deduped: 131072
> 	i: 97, status: 0, bytes_deduped: 131072
> 	i: 98, status: 0, bytes_deduped: 131072
> 	i: 99, status: 0, bytes_deduped: 131072
> 	13107200 total bytes deduped in this operation
> 	am: 4.8 MiB (4964352 bytes) converted to sparse holes.
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	072a152355788c767b97e4e4c0e4567720988b84 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	bf00d862c6ad436a1be2be606a8ab88d22166b89 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	0d44cdf030fb149e103cfdc164da3da2b7474c17 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	60831f0e7ffe4b49722612c18685c09f4583b1df am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	a19662b294a3ccdf35dbb18fdd72c62018526d7d am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 	^C

It looks like we have something wrong interpreting file extent, maybe
related to extent map merging.

BTW, if without dropping page cache and no read corruption happens, it
would limit the range of problem we're looking for.

Thanks,
Qu

>=20
> Corruption occurs most often when there is a sequence like this in a fi=
le:
>=20
> 	ref 1: hole
> 	ref 2: extent A, offset 0
> 	ref 3: hole
> 	ref 4: extent A, offset 8192
>=20
> This scenario typically arises due to hole-punching or deduplication.
> Hole-punching replaces one extent ref with two references to the same
> extent with a hole between them, so:
>=20
> 	ref 1:  extent A, offset 0, length 16384
>=20
> becomes:
>=20
> 	ref 1:  extent A, offset 0, length 4096
> 	ref 2:  hole, length 8192
> 	ref 3:  extent A, offset 12288, length 4096
>=20
> Deduplication replaces two distinct extent refs surrounding a hole with=

> two references to one of the duplicate extents, turning this:
>=20
> 	ref 1:  extent A, offset 0, length 4096
> 	ref 2:  hole, length 8192
> 	ref 3:  extent B, offset 0, length 4096
>=20
> into this:
>=20
> 	ref 1:  extent A, offset 0, length 4096
> 	ref 2:  hole, length 8192
> 	ref 3:  extent A, offset 0, length 4096
>=20
> Compression is required (zlib, zstd, or lzo) for corruption to occur.
> I am not able to reproduce the issue with an uncompressed extent nor
> have I observed any such corruption in the wild.
>=20
> The presence or absence of the no-holes filesystem feature has no effec=
t.
>=20
> Ordinary writes can lead to pairs of extent references to the same exte=
nt
> separated by a reference to a different extent; however, in this case
> there is data to be read from a real extent, instead of pages that have=

> to be zero filled from a hole.  If ordinary non-hole writes could trigg=
er
> this bug, every page-oriented database engine would be crashing all the=

> time on btrfs with compression enabled, and it's unlikely that would no=
t
> have been noticed between 2015 and now.  An ordinary write that splits
> an extent ref would look like this:
>=20
> 	ref 1:  extent A, offset 0, length 4096
> 	ref 2:  extent C, offset 0, length 8192
> 	ref 3:  extent A, offset 12288, length 4096
>=20
> Sparse writes can lead to pairs of extent references surrounding a hole=
;
> however, in this case the extent references will point to different
> extents, avoiding the bug.  If a sparse write could trigger the bug,
> the rsync -S option and qemu/kvm 'raw' disk image files (among many
> other tools that produce sparse files) would be unusable, and it's
> unlikely that would not have been noticed between 2015 and now either.
> Sparse writes look like this:
>=20
> 	ref 1:  extent A, offset 0, length 4096
> 	ref 2:  hole, length 8192
> 	ref 3:  extent B, offset 0, length 4096
>=20
> The pattern or timing of read() calls seems to be relevant.  It is very=

> hard to see the corruption when reading files with 'hd', but 'cat | hd'=

> will see the corruption just fine.  Similar problems exist with 'cmp'
> but not 'sha1sum'.  Two processes reading the same file at the same tim=
e
> seem to trigger the corruption very frequently.
>=20
> Some patterns of holes and data produce corruption faster than others.
> The pattern generated by the script above is based on instances of
> corruption I've found in the wild, and has a much better repro rate tha=
n
> random holes.
>=20
> The corruption occurs during reads, after csum verification and before
> decompression, so btrfs detects no csum failures.  The data on disk
> seems to be OK and could be read correctly once the kernel bug is fixed=
=2E
> Repeated reads do eventually return correct data, but there is no way
> for userspace to distinguish between corrupt and correct data reliably.=

>=20
> The corrupted data is usually data replaced by a hole or a copy of othe=
r
> blocks in the same extent.
>=20
> The behavior is similar to some earlier bugs related to holes and
> Compressed data in btrfs, but it's new and not fixed yet--hence,
> "2018 edition."
>=20


--A5z9HjdEhAg8QaAYdrTDjPlJGkQDnM23D--

--idTC29eTx669Z5e2kp2BjszTxnJR6CHKc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlt+QdgACgkQwj2R86El
/qhU+wgAlGUctmZq7W6sGGUUsNgUmK8FHpV50Ie0hKirTHonJDsNikX2AEMFm0/u
ssM7omo+NX1YgcAA6A7OLjQoloaWY4aYhc96mk2y/RW1ycPuoDkLREcvLU7AwU6l
8yByQjfH5W5PTCOp4iV7uCZ0zurqoEursm2oAGlRkOMa+j5EEXp9CC8JMZHCQp0Z
PBnInZyMCW2xlZDMm8khBlNghmaRw5cOn06C3H6480jOYd6Y0YB+XvRmqAIEU/9w
LHaqRnBMArpQT8FfvgHpv1LtfPnxi5oxuPEa8FRuRf8tvv2dggza2uHzImM3r/jd
kFU2cUS/VpnydACYlv1kaU39VhscYg==
=tiVp
-----END PGP SIGNATURE-----

--idTC29eTx669Z5e2kp2BjszTxnJR6CHKc--
