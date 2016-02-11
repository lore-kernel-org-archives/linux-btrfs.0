Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20841 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbcBKXm7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 18:42:59 -0500
Subject: [PATCH 32/32] reflink: kick the slow tests out of the 'quick' group
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Thu, 11 Feb 2016 15:42:54 -0800
Message-ID: <20160211234254.2202.90445.stgit@birch.djwong.org>
In-Reply-To: <20160211233916.2202.40961.stgit@birch.djwong.org>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since 'quick' tests are supposed to run in < 15s, kick out the ones
that can't finish that soon even on fast storage.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/group |   34 +++++++++++++++++-----------------
 tests/xfs/group     |    6 +++---
 2 files changed, 20 insertions(+), 20 deletions(-)


diff --git a/tests/generic/group b/tests/generic/group
index e3c4e8a..5f699ce 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -139,7 +139,7 @@
 134 auto quick clone
 135 metadata auto quick
 136 auto quick clone dedupe
-137 auto quick clone dedupe
+137 auto clone dedupe
 138 auto quick clone
 139 auto quick clone
 140 auto quick clone
@@ -166,19 +166,19 @@
 161 auto quick clone
 162 auto quick clone dedupe
 163 auto quick clone dedupe
-164 auto quick clone
-165 auto quick clone
-166 auto quick clone
-167 auto quick clone
-168 auto quick clone
+164 auto clone
+165 auto clone
+166 auto clone
+167 auto clone
+168 auto clone
 169 rw metadata auto quick
-170 auto quick clone
+170 auto clone
 171 auto quick clone
 172 auto quick clone
 173 auto quick clone
 174 auto quick clone
-175 auto quick clone
-176 auto quick clone
+175 auto clone
+176 auto clone
 177 auto quick prealloc metadata
 178 auto quick clone
 179 auto quick clone
@@ -188,8 +188,8 @@
 183 auto quick clone
 184 metadata auto quick
 185 auto quick clone
-186 auto quick clone
-187 auto quick clone
+186 auto clone
+187 auto clone
 188 auto quick clone
 189 auto quick clone
 190 auto quick clone
@@ -244,8 +244,8 @@
 239 auto aio rw
 240 auto aio quick rw
 241 auto
-242 auto quick clone
-243 auto quick clone
+242 auto clone
+243 auto clone
 244 auto quick quota
 245 auto quick dir
 246 auto quick rw
@@ -299,8 +299,8 @@
 294 auto quick
 295 auto quick clone
 296 auto quick clone
-297 auto quick clone
-298 auto quick clone
+297 auto clone
+298 auto clone
 299 auto aio enospc rw stress
 300 auto aio enospc preallocrw stress
 301 auto quick clone
@@ -335,5 +335,5 @@
 330 auto quick clone
 331 auto quick clone
 332 auto quick clone
-333 auto quick clone
-334 auto quick clone
+333 auto clone
+334 auto clone
diff --git a/tests/xfs/group b/tests/xfs/group
index 4fb7618..eadc212 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -137,7 +137,7 @@
 137 auto metadata v2log
 138 auto quick quota
 139 auto quick clone
-140 auto quick clone
+140 auto clone
 141 auto log metadata
 142 dmapi
 143 dmapi
@@ -166,7 +166,7 @@
 166 rw metadata auto quick
 167 rw metadata auto stress
 168 dmapi
-169 auto quick clone
+169 auto clone
 170 rw filestreams auto quick
 171 rw filestreams
 172 rw filestreams
@@ -233,7 +233,7 @@
 233 auto quick rmap
 234 auto quick rmap
 235 fuzzers rmap
-236 auto quick rmap
+236 auto rmap
 237 auto quick clone
 238 auto quick metadata ioctl
 239 auto quick clone

