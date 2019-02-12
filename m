Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B3A9C169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 03:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 217AC21773
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 03:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfBLDJx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 22:09:53 -0500
Received: from james.kirk.hungrycats.org ([174.142.39.145]:45960 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726655AbfBLDJw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 22:09:52 -0500
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id E389F21723D; Mon, 11 Feb 2019 22:09:04 -0500 (EST)
Date:   Mon, 11 Feb 2019 22:09:02 -0500
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     linux-btrfs@vger.kernel.org
Subject: Reproducer for "compressed data + hole data corruption bug, 2018
 edition" still works on 4.20.7
Message-ID: <20190212030838.GB9995@hungrycats.org>
References: <20180823031125.GE13528@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="i9LlY+UWpKt15+FH"
Content-Disposition: inline
In-Reply-To: <20180823031125.GE13528@hungrycats.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--i9LlY+UWpKt15+FH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Still reproducible on 4.20.7.

The behavior is slightly different on current kernels (4.20.7, 4.14.96)
which makes the problem a bit more difficult to detect.

	# repro-hole-corruption-test
	i: 91, status: 0, bytes_deduped: 131072
	i: 92, status: 0, bytes_deduped: 131072
	i: 93, status: 0, bytes_deduped: 131072
	i: 94, status: 0, bytes_deduped: 131072
	i: 95, status: 0, bytes_deduped: 131072
	i: 96, status: 0, bytes_deduped: 131072
	i: 97, status: 0, bytes_deduped: 131072
	i: 98, status: 0, bytes_deduped: 131072
	i: 99, status: 0, bytes_deduped: 131072
	13107200 total bytes deduped in this operation
	am: 4.8 MiB (4964352 bytes) converted to sparse holes.
	94a8acd3e1f6e14272f3262a8aa73ab6b25c9ce8 am
	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am

The sha1sum seems stable after the first drop_caches--until a second
process tries to read the test file:

	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
	# cat am > /dev/null              (in another shell)
	19294e695272c42edb89ceee24bb08c13473140a am                               =
                            =20
	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am

On Wed, Aug 22, 2018 at 11:11:25PM -0400, Zygo Blaxell wrote:
> This is a repro script for a btrfs bug that causes corrupted data reads
> when reading a mix of compressed extents and holes.  The bug is
> reproducible on at least kernels v4.1..v4.18.
>
> Some more observations and background follow, but first here is the
> script and some sample output:
>
> 	root@rescue:/test# cat repro-hole-corruption-test
> 	#!/bin/bash
>
> 	# Write a 4096 byte block of something
> 	block () { head -c 4096 /dev/zero | tr '\0' "\\$1"; }
>
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
> 			block 66;
> 		done
> 	done > am
> 	sync
>
> 	# Now replace those 101 distinct extents with 101 references to the firs=
t extent
> 	btrfs-extent-same 131072 $(for x in $(seq 0 100); do echo am $((x * 1310=
72)); done) 2>&1 | tail
>
> 	# Punch holes into the extent refs
> 	fallocate -v -d am
>
> 	# Do some other stuff on the machine while this runs, and watch the sha1=
sums change!
> 	while :; do echo $(sha1sum am); sysctl -q vm.drop_caches=3D{1,2,3}; slee=
p 1; done
>
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
>
> Corruption occurs most often when there is a sequence like this in a file:
>
> 	ref 1: hole
> 	ref 2: extent A, offset 0
> 	ref 3: hole
> 	ref 4: extent A, offset 8192
>
> This scenario typically arises due to hole-punching or deduplication.
> Hole-punching replaces one extent ref with two references to the same
> extent with a hole between them, so:
>
> 	ref 1:  extent A, offset 0, length 16384
>
> becomes:
>
> 	ref 1:  extent A, offset 0, length 4096
> 	ref 2:  hole, length 8192
> 	ref 3:  extent A, offset 12288, length 4096
>
> Deduplication replaces two distinct extent refs surrounding a hole with
> two references to one of the duplicate extents, turning this:
>
> 	ref 1:  extent A, offset 0, length 4096
> 	ref 2:  hole, length 8192
> 	ref 3:  extent B, offset 0, length 4096
>
> into this:
>
> 	ref 1:  extent A, offset 0, length 4096
> 	ref 2:  hole, length 8192
> 	ref 3:  extent A, offset 0, length 4096
>
> Compression is required (zlib, zstd, or lzo) for corruption to occur.
> I am not able to reproduce the issue with an uncompressed extent nor
> have I observed any such corruption in the wild.
>
> The presence or absence of the no-holes filesystem feature has no effect.
>
> Ordinary writes can lead to pairs of extent references to the same extent
> separated by a reference to a different extent; however, in this case
> there is data to be read from a real extent, instead of pages that have
> to be zero filled from a hole.  If ordinary non-hole writes could trigger
> this bug, every page-oriented database engine would be crashing all the
> time on btrfs with compression enabled, and it's unlikely that would not
> have been noticed between 2015 and now.  An ordinary write that splits
> an extent ref would look like this:
>
> 	ref 1:  extent A, offset 0, length 4096
> 	ref 2:  extent C, offset 0, length 8192
> 	ref 3:  extent A, offset 12288, length 4096
>
> Sparse writes can lead to pairs of extent references surrounding a hole;
> however, in this case the extent references will point to different
> extents, avoiding the bug.  If a sparse write could trigger the bug,
> the rsync -S option and qemu/kvm 'raw' disk image files (among many
> other tools that produce sparse files) would be unusable, and it's
> unlikely that would not have been noticed between 2015 and now either.
> Sparse writes look like this:
>
> 	ref 1:  extent A, offset 0, length 4096
> 	ref 2:  hole, length 8192
> 	ref 3:  extent B, offset 0, length 4096
>
> The pattern or timing of read() calls seems to be relevant.  It is very
> hard to see the corruption when reading files with 'hd', but 'cat | hd'
> will see the corruption just fine.  Similar problems exist with 'cmp'
> but not 'sha1sum'.  Two processes reading the same file at the same time
> seem to trigger the corruption very frequently.
>
> Some patterns of holes and data produce corruption faster than others.
> The pattern generated by the script above is based on instances of
> corruption I've found in the wild, and has a much better repro rate than
> random holes.
>
> The corruption occurs during reads, after csum verification and before
> decompression, so btrfs detects no csum failures.  The data on disk
> seems to be OK and could be read correctly once the kernel bug is fixed.
> Repeated reads do eventually return correct data, but there is no way
> for userspace to distinguish between corrupt and correct data reliably.
>
> The corrupted data is usually data replaced by a hole or a copy of other
> blocks in the same extent.
>
> The behavior is similar to some earlier bugs related to holes and
> Compressed data in btrfs, but it's new and not fixed yet--hence,
> "2018 edition."



--i9LlY+UWpKt15+FH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCXGI4swAKCRCB+YsaVrMb
nPYJAKDLC0w0uIRPHYsNd5wkWssXWHtHFQCfY+OxVsy5dB4inFl3lVDF+9TTorA=
=kV/c
-----END PGP SIGNATURE-----

--i9LlY+UWpKt15+FH--
