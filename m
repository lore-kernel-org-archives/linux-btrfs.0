Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:48156 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750785AbcIUE4b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 00:56:31 -0400
Date: Wed, 21 Sep 2016 00:55:56 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs rare silent data corruption with kernel data leak
Message-ID: <20160921045556.GN21290@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="l3ej7W/Jb2pB3qL2"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--l3ej7W/Jb2pB3qL2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Summary:=20

There seem to be two btrfs bugs here: one loses data on writes,
and the other leaks data from the kernel to replace it on reads.  It all
happens after checksums are verified, so the corruption is entirely
silent--no EIO errors, kernel messages, or device event statistics.

Compressed extents are corrupted with kernel data leak.  Uncompressed
extents may not be corrupted, or may be corrupted by deterministically
replacing data bytes with zero, or may not be corrupted.  No preconditions
for corruption are known.  Less than one file per hundred thousand
seems to be affected.  Only specific parts of any file can be affected.
Kernels v4.0..v4.5.7 tested, all have the issue.

Background, observations, and analysis:

I've been detecting silent data corruption on btrfs for over a year.
Over time I've been improving data collection and controlling for
confounding factors (other known btrfs bugs, RAM and CPU failures, raid5,
etc).  I have recently isolated the most common remaining corruption mode,
and it seems to be a btrfs bug.

I don't have an easy recipe to create a corrupted file and I don't know
precisely how they come to exist.  In the wild, about one in 10^5..10^7
files is provably corrupted.  The corruption can only occur at one point
in each file so the rate of corruption incidents follows the number
of files.  It seems to occur most often to software builders and rsync
backup receivers.  It seems to happen mostly on busier machines with
mixed workloads and not at all on idle test VMs trying to reproduce this
issue with a script.

One way to get corruption is to set up a series of filesystems and rsync
/usr to them sequentially (i.e. rsync -a /usr /fs-A; rsync -a /fs-A /fs-B;
rsync -a /fs-B /fs-C; ...) and verify each copy by comparison afterwards.
The same host needs to be doing other filesystem workloads or it won't
seem to reproduce this issue.  It took me two weeks to intentionally
create one corrupt file this way.  Good luck.

In cases where this corruption mode is found, the files always have an
extent map following this pattern:

	# filefrag -v usr/share/icons/hicolor/icon-theme.cache
	Filesystem type is: 9123683e
	File size of usr/share/icons/hicolor/icon-theme.cache is 36456 (9 blocks o=
f 4096 bytes)
	 ext:     logical_offset:        physical_offset: length:   expected: flag=
s:
	   0:        0..    4095:          0..      4095:   4096:             enco=
ded,not_aligned,inline
	   1:        1..       8:  182785288.. 182785295:      8:          1: last=
,encoded,shared,eof
	usr/share/icons/hicolor/icon-theme.cache: 2 extents found

Note the first inline extent followed by one or more non-inline
extents.  I don't know enough about the writing side of btrfs to know
if this is a bug in and of itself.  It _looks_ wrong to me.

Once such an extent is created, the corruption is persistent but not
deterministic.  When I read the extent through btrfs, the file is
different most of the time:

	# cp usr/share/icons/hicolor/icon-theme.cache /tmp/foo
	# ls -l usr/share/icons/hicolor/icon-theme.cache /tmp/foo
	-rw-r--r-- 1 root root 36456 Sep 20 11:41 /tmp/foo
	-rw-r--r-- 1 root root 36456 Sep  6 11:52 usr/share/icons/hicolor/icon-the=
me.cache
	# while sysctl vm.drop_caches=3D1; do cmp -l usr/share/icons/hicolor/icon-=
theme.cache /tmp/foo; done
	vm.drop_caches =3D 1
	vm.drop_caches =3D 1
	 4093 213   0
	 4094 177   0
	vm.drop_caches =3D 1
	 4093 216   0
	 4094  33   0
	 4095 173   0
	 4096  15   0
	vm.drop_caches =3D 1
	 4093 352   0
	 4094   3   0
	 4095  37   0
	 4096   2   0
	vm.drop_caches =3D 1
	 4093 243   0
	 4094 372   0
	 4095 154   0
	 4096 221   0
	vm.drop_caches =3D 1
	 4093 333   0
	 4094 170   0
	 4095 356   0
	 4096 213   0
	vm.drop_caches =3D 1
	 4093 170   0
	 4094 155   0
	 4095  62   0
	 4096 233   0
	vm.drop_caches =3D 1
	 4093 263   0
	 4094   6   0
	 4095 363   0
	 4096  44   0
	vm.drop_caches =3D 1
	 4093 237   0
	 4094 330   0
	 4095 217   0
	 4096 206   0
	^C

In other runs there can be 5 or more consecutive reads with no differences
detected.

I fetched the raw inline extent item for this file through the SEARCH_V2
ioctl and decoded it:

	# head /tmp/bar
	27 5e 06 00 00 00 00 00 [generation 417319]
	fc 0f 00 00 00 00 00 00 [ram_bytes =3D 0xffc, compression =3D 1]
	01 00 00 00 00 78 5e 9c [zlib data starts at "78 5e..."]
	97 3d 74 14 55 14 c7 6f
	60 77 b3 9f d9 20 20 08
	28 11 22 a0 66 90 8f a0
	a8 01 a2 80 80 a2 20 e6
	28 20 42 26 bb 93 cd 30
	b3 33 9b d9 99 24 62 d4
	20 f8 51 58 58 50 58 58

Notice ram_bytes is 0xffc, or 4092, but the inline extent's position in
the file covers the offset range 0..4095.

When an inline extent is read in btrfs, any difference between the read
buffer page size and the size of the data should be memset to zero.
For uncompressed extents, the memset target size is PAGE_CACHE_SIZE in
btrfs_get_extent.  For compressed extents, the decompression function
is passed the ram_bytes field from the extent as the size of the buffer.

Unfortunately, in this case, ram_bytes is only 4092 bytes.  The inline
extent is not the last extent in the file, so read() can retrieve data
beyond the end of the extent.  Ideally this data comes from the next
extent, but the next extent's offset (4096) is 4 bytes later.  The last
4 bytes of the first page of the file end up with uninitialized data.
vm.drop_caches triggers an aggressive nondeterminstic rearrangement of
buffers in physical kernel memory, which would result in different data
on each read.

If I extract the zlib compressed data from the inline extent item, I
can verify that the compressed data decompresses OK and is really 4092
bytes long:

	# perl -MCompress::Zlib -e '$/=3Dundef; open(BAR, "/tmp/bar"); $x =3D <BAR=
>; for my $y (split(" ", $x)) { $z .=3D chr(hex($y)); } print uncompress(su=
bstr($z, 21))' | hd | diff -u - <(hd /tmp/foo) | head
	--- -   2016-09-20 23:40:41.168981367 -0400
	+++ /dev/fd/63  2016-09-20 23:40:41.167445549 -0400
	@@ -253,5 +253,2028 @@
	 00000fc0  00 00 00 00 00 09 00 04  00 00 00 00 00 01 00 04  |............=
=2E...|
	 00000fd0  00 00 00 00 00 00 10 20  00 00 0f e0 00 00 0f ec  |....... ....=
=2E...|
	 00000fe0  6b 73 71 75 61 72 65 73  00 00 00 00 00 00 00 06  |ksquares....=
=2E...|
	-00000ff0  00 38 00 04 00 00 00 00  00 30 00 04              |.8.......0..|
	-00000ffc
	+00000ff0  00 38 00 04 00 00 00 00  00 30 00 04 00 00 00 00  |.8.......0..=
=2E...|
	+00001000  00 24 00 04 00 00 00 00  00 13 00 04 00 00 00 00  |.$..........=
=2E...|

I have not found instances of this bug involving uncompressed extents.
Uncompressed extents may have deterministic data corruption (all missing
bytes replaced with zero) without the kernel data leak, or they may not
be corrupted at all.

In the wild I've encountered corrupted files with errors as long as
3000 bytes in the first page.  At the time the data wasn't clean enough
to make a statement about whether all of the bytes in the uncorrupted
version of the files were zero.  The vast majority of the time one side
or the other of the comparison was all-zero, but my testing environment
was not set up to reliably identify which version of the affected files
was the correct one or separate this corruption mode from other modes.

What next:

The bug where ram_bytes is trusted instead of calculating an acceptable
output buffer size should be fixed to prevent the kernel data leak
(not to mention possible fuzzing vulnerabilities).

The bug that is causing broken inline extents to be created needs to
be fixed.

What do we do with all the existing broken inline extents on filesystems?
We could detect this case and return EIO.  Since some of the data is
missing, we can't guess what the missing data was, and we can't attest
to userspace that we have read it all correctly.

If we can *prove* that the writing side of this bug *only* occurs in
cases when the missing data is zero (e.g because we find it is triggered
only by a sequence like "create/truncate write(4092) lseek(+4) write"
so the missing data is a hole) then we can safely fill in the missing
data with zeros.  The low rate of occurrence of the bug means that even
a high false positive EIO rate is still a low absolute rate.

Maybe it's enough to assume the missing data is zero, and issue a release
note telling people to verify and correct their own data after applying
the bug fix to prevent any more corrupted writes.


--l3ej7W/Jb2pB3qL2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlfiEtwACgkQgfmLGlazG5z3fwCfQufg1fiBFQQRRHnAo5eqCyio
lWwAnRJ1URaAxe6N5q5EdJRiEIYfFvBK
=PK4K
-----END PGP SIGNATURE-----

--l3ej7W/Jb2pB3qL2--
