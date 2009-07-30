From: Giuseppe Scrivano <gscrivano@gnu.org>
Subject: Re: BTRFS file clone support for cp
Date: Thu, 30 Jul 2009 19:28:08 +0200
Message-ID: <877hxqcc7r.fsf@master.homenet>
References: <87d47o3fip.fsf@master.homenet> <4A6CEA48.5050208@draigBrady.com>
	<8763defuvq.fsf@meyering.net> <87ws5tvrq8.fsf@master.homenet>
	<4A6E3ADE.6050008@draigBrady.com> <87k51r9sxh.fsf@master.homenet>
	<4A70C4E0.9030104@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: bug-coreutils@gnu.org, linux-btrfs@vger.kernel.org
To: =?utf-8?Q?P=C3=A1draig?= Brady <P@draigBrady.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A70C4E0.9030104@draigBrady.com> (=?utf-8?Q?=22P=C3=A1draig?=
 Brady"'s message of
	"Wed, 29 Jul 2009 22:53:36 +0100")
List-ID: <linux-btrfs.vger.kernel.org>

Hi P=C3=A1draig,

thanks for the comments.

P=C3=A1draig Brady <P@draigBrady.com> writes:

> # 300MB seems to be the minimum size for a btrfs with default
> parameters.

Actually, it seems the minimum space required is 256MB.  Using a 255MB
image I get: "device btrfs.img is too small (must be at least 256 MB)"


> # FIXME: use `truncate --allocate` when it becomes available, which
> # may allow unmarking this as an expensive test.

Are you sure that this feature will make the test less expensive?  Stil=
l
the test files must be written there, so in the best case (considering
the fallocate done in 0s) only the dd cost will be saved but still it
looks like an expensive test.

In the version I attached, I am using a sparse file (truncate --size)
and it seems to work fine.  Is it correct or am I missing something?

I haven't looked yet but probably there are other tests that can take
advantage of sparse files instead of using "dd".

I am also considering the Jim's note doing the umount in the cleanup_
function.

Cheers,
Giuseppe


=46rom 7add4b337b7db0a63bca0dd0fe0f146f175163f8 Mon Sep 17 00:00:00 200=
1
=46rom: Giuseppe Scrivano <gscrivano@gnu.org>
Date: Wed, 29 Jul 2009 20:31:20 +0200
Subject: [PATCH] tests: add a test for btrfs' copy-on-write file clone =
operation

* tests/Makefile.am: Consider the new test.
* tests/cp/file-clone: New file.
---
 tests/Makefile.am   |    1 +
 tests/cp/file-clone |   58 +++++++++++++++++++++++++++++++++++++++++++=
++++++++
 2 files changed, 59 insertions(+), 0 deletions(-)
 create mode 100755 tests/cp/file-clone

diff --git a/tests/Makefile.am b/tests/Makefile.am
index 59737a0..9841aa3 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -20,6 +20,7 @@ EXTRA_DIST =3D		\
=20
 root_tests =3D					\
   chown/basic					\
+  cp/file-clone				\
   cp/cp-a-selinux				\
   cp/preserve-gid				\
   cp/special-bits				\
diff --git a/tests/cp/file-clone b/tests/cp/file-clone
new file mode 100755
index 0000000..c65b9cb
--- /dev/null
+++ b/tests/cp/file-clone
@@ -0,0 +1,58 @@
+#!/bin/sh
+# Make sure file-clone on a btrfs file system works properly.
+
+# Copyright (C) 2009 Free Software Foundation, Inc.
+
+# This program is free software: you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation, either version 3 of the License, or
+# (at your option) any later version.
+
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+
+# You should have received a copy of the GNU General Public License
+# along with this program.  If not, see <http://www.gnu.org/licenses/>=
=2E
+
+
+if test "$VERBOSE" =3D yes; then
+  set -x
+  cp --version
+fi
+
+. $srcdir/test-lib.sh
+
+require_root_
+require_sparse_support_
+#expensive_
+
+cleanup_(){ umount btrfs; }
+
+fail=3D0
+
+mkfs.btrfs --version || skip_test_ "btrfs userland tools not installed=
"
+
+# 256MB seems to be the minimum size for a btrfs with default paramete=
rs.
+truncate --size=3D256M btrfs.img  || framework_failure
+
+mkfs.btrfs btrfs.img  || framework_failure
+
+mkdir btrfs || framework_failure
+
+mount -t btrfs -o loop btrfs.img btrfs || framework_failure
+
+dd bs=3D1M count=3D200 if=3D/dev/zero of=3Dbtrfs/alloc.test || framewo=
rk_failure
+
+# If the file is cloned, only additional space for metadata is require=
d.
+# Two 200MB files can be present even if the total file system space i=
s 256MB.
+cp btrfs/alloc.test btrfs/clone.test || fail=3D1
+rm btrfs/clone.test
+
+# When --sparse=3D{always,never} is used, the file is copied without a=
ny cloning.
+# Use --sparse=3Dnever to be sure the file is copied without holes and=
 it is not
+# possible since there is not enough free space.
+cp --sparse=3Dnever btrfs/alloc.test btrfs/clone.test && fail=3D1
+
+Exit $fail
--=20
1.6.3.3
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
