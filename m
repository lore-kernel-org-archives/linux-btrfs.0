Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38890 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934509AbbI2KYy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 06:24:54 -0400
Date: Tue, 29 Sep 2015 10:24:50 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH v2] fstests: generic: Check if a bull fallocate will
 change extent number
Message-ID: <20150929102450.GE25907@carfax.org.uk>
References: <1443519264-19184-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150929100013.GD25907@carfax.org.uk>
 <560A6451.6050808@gmx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u5E4XgoOPWr4PD9E"
In-Reply-To: <560A6451.6050808@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--u5E4XgoOPWr4PD9E
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 29, 2015 at 06:13:37PM +0800, Qu Wenruo wrote:
>=20
>=20
> =E5=9C=A8 2015=E5=B9=B409=E6=9C=8829=E6=97=A5 18:00, Hugo Mills =E5=86=99=
=E9=81=93:
> >On Tue, Sep 29, 2015 at 05:34:24PM +0800, Qu Wenruo wrote:
> >>Normally, a bull fallocate call on a fully written and synced file
> >>should not add an extent.
> >
> >    What's a "bull" fallocate call? Is it a typo, or simply something
> >I'm not familiar with?
> >
> >    Hugo.
>=20
> Oh, it should be null.
> But null still seems not appropriate here.
>=20
> I mean a fallocate call which doesn't really allocate any space...
>=20
> Any good ideas?

   Not in a single word. Maybe one of the following:

Normally, an fallocate call which only touches existing extents should
not add any more extents on a fully written and synced file.

Normally, an fallocate call which does not allocate outside existing
extents should not add any more extents on a fully written and synced
file.

   I think I slightly prefer the second option.

   Hugo

> Thanks,
> Qu
> >
> >>But not all filesystem follows the correct behavior.
> >>
> >>Btrfs has a bug to always truncate the last page if the fallocate start
> >>offset is smaller than inode size.
> >>
> >>So add this test case to detect such malfunction.
> >>
> >>Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> >>---
> >>v2:
> >>   Add author info...
> >>   Fix some comment typo
> >>---
> >>  tests/generic/110     | 78 ++++++++++++++++++++++++++++++++++++++++++=
+++++++++
> >>  tests/generic/110.out |  3 ++
> >>  tests/generic/group   |  1 +
> >>  3 files changed, 82 insertions(+)
> >>  create mode 100755 tests/generic/110
> >>  create mode 100644 tests/generic/110.out
> >>
> >>diff --git a/tests/generic/110 b/tests/generic/110
> >>new file mode 100755
> >>index 0000000..b2b140c
> >>--- /dev/null
> >>+++ b/tests/generic/110
> >>@@ -0,0 +1,78 @@
> >>+#! /bin/bash
> >>+# FS QA Test 110
> >>+#
> >>+# Test if fallocate will create uneeded extra tailing extent
> >>+#
> >>+#---------------------------------------------------------------------=
--
> >>+# Copyright (c) 2015 Fujitsu.  All Rights Reserved.
> >>+#
> >>+# This program is free software; you can redistribute it and/or
> >>+# modify it under the terms of the GNU General Public License as
> >>+# published by the Free Software Foundation.
> >>+#
> >>+# This program is distributed in the hope that it would be useful,
> >>+# but WITHOUT ANY WARRANTY; without even the implied warranty of
> >>+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>+# GNU General Public License for more details.
> >>+#
> >>+# You should have received a copy of the GNU General Public License
> >>+# along with this program; if not, write the Free Software Foundation,
> >>+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> >>+#---------------------------------------------------------------------=
--
> >>+#
> >>+
> >>+seq=3D`basename $0`
> >>+seqres=3D$RESULT_DIR/$seq
> >>+echo "QA output created by $seq"
> >>+
> >>+here=3D`pwd`
> >>+tmp=3D/tmp/$$
> >>+status=3D1	# failure is the default!
> >>+trap "_cleanup; exit \$status" 0 1 2 3 15
> >>+
> >>+_cleanup()
> >>+{
> >>+	cd /
> >>+	rm -f $tmp.*
> >>+}
> >>+
> >>+# get standard environment, filters and checks
> >>+. ./common/rc
> >>+. ./common/filter
> >>+. ./common/defrag
> >>+
> >>+# remove previous $seqres.full before test
> >>+rm -f $seqres.full
> >>+
> >>+# real QA test starts here
> >>+
> >>+_supported_fs generic
> >>+_supported_os IRIX Linux
> >>+_require_scratch
> >>+_need_to_be_root
> >>+
> >>+# Use 64K file size to match any sectorsize
> >>+# And with a unaligned tailing range to ensure it will be at least 2 p=
ages
> >>+filesize=3D$(( 64 * 1024 + 1024 ))
> >>+
> >>+_scratch_mkfs > /dev/null 2>&1
> >>+_scratch_mount
> >>+$XFS_IO_PROG -f -c "pwrite 0 $filesize" $SCRATCH_MNT/foo | _filter_xfs=
_io
> >>+sync
> >>+orig_extent_nr=3D`_extent_count $SCRATCH_MNT/foo`
> >>+
> >>+# As all space are allocated and even written to disk, this falloc
> >>+# should do nothing with extent modification.
> >>+$XFS_IO_PROG -f -c "falloc 0 $filesize" $SCRATCH_MNT/foo
> >>+sync
> >>+new_extent_nr=3D`_extent_count $SCRATCH_MNT/foo`
> >>+
> >>+echo "orig: $orig_extent_nr, new: $new_extent_nr" >> $seqres.full
> >>+
> >>+if [ "x$orig_extent_nr" !=3D "x$new_extent_nr" ]; then
> >>+	echo "number of extents mis-match after bull fallocate"
> >>+fi
> >>+
> >>+# success, all done
> >>+status=3D0
> >>+exit
> >>diff --git a/tests/generic/110.out b/tests/generic/110.out
> >>new file mode 100644
> >>index 0000000..64049da
> >>--- /dev/null
> >>+++ b/tests/generic/110.out
> >>@@ -0,0 +1,3 @@
> >>+QA output created by 110
> >>+wrote 66560/66560 bytes at offset 0
> >>+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> >>diff --git a/tests/generic/group b/tests/generic/group
> >>index 4ae256f..428f3e3 100644
> >>--- a/tests/generic/group
> >>+++ b/tests/generic/group
> >>@@ -112,6 +112,7 @@
> >>  107 auto quick metadata
> >>  108 auto quick rw
> >>  109 auto metadata dir
> >>+110 auto quick prealloc
> >>  112 rw aio auto quick
> >>  113 rw aio auto quick
> >>  117 attr auto quick
> >

--=20
Hugo Mills             | For months now, we have been making triumphant
hugo@... carfax.org.uk | retreats before a demoralised enemy who is advanci=
ng
http://carfax.org.uk/  | in utter disorder.
PGP: E2AB1DE4          |                              Eric Frank Russell, W=
asp

--u5E4XgoOPWr4PD9E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWCmbyAAoJEFheFHXiqx3kx9wP/3XIK7NCmzU3e8XwD85K1HIg
Pfmy2DpPSoiI5xyxsDn0f1hiLe2yk5hRRCrAmXEnaF79oiq4HxqJ8DjIJ1TIKV29
is4vXuhld7RddgAPI4ZjbD64WIePTEE5NfMdkRfOMYUN4e1RP47qe92/FNYroIL0
kDPtuvAqr+hO127Y0P53M+yseyxBjudXM53Y8vvSLXO9zyK/ehVb9Kbn3QqqQ4E0
6Ya/iBf4UH6PBYkEDteP2TrEAI69/aofquf+a4Fp5nkrNKMVbS83D/LbbcrmLO+B
yrRhf1qsuaGKaBqoPWs64zhB9NyIFJCGIzprLAioX8Kupret71KvYs4x8fVuP63F
/WCPV8Q5Z0rRD5YavUt9jnxzZIrAUYnkNq+2EkSIbCjm6kv0CMMv1a/b7tU0+kj2
QsVLfyJg6ZS59QLH2XrDr0fSCVuy7Fz0ikSbtfV+pHkjNCZwartJVuC04NApUk2u
a326/yNXH08Ni4bHg6VACWEfsehTAA/MU+iPQDvG6GY2V/136KCrMbrVrxV1dzOC
FbKVyt+l8Q6n9c7uDAuDjytkWEeApXplBSn+MqPL+NUbaRYkHDQTmZfj7rQt84DG
+3HEgdefzPy6t0rIFIUXNTsDrWhAgYeTMB3ECFkHDIAO7+zDYV0cMdCjS7oizMG4
XBQcrZXnROE4BiLZVtv3
=TaFT
-----END PGP SIGNATURE-----

--u5E4XgoOPWr4PD9E--
