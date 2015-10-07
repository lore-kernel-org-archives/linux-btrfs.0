Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40641 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbbJGFNR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Oct 2015 01:13:17 -0400
Subject: [PATCH 01/12] xfs: fix merge errors in fuzzer tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: Anna.Schumaker@netapp.com, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Tue, 06 Oct 2015 22:13:04 -0700
Message-ID: <20151007051304.3260.66605.stgit@birch.djwong.org>
In-Reply-To: <20151007051257.3260.73072.stgit@birch.djwong.org>
References: <20151007051257.3260.73072.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/085.out |    2 --
 tests/xfs/098.out |    1 -
 tests/xfs/099.out |    2 +-
 tests/xfs/100.out |    2 +-
 tests/xfs/101.out |    2 +-
 tests/xfs/102.out |    2 +-
 6 files changed, 4 insertions(+), 7 deletions(-)


diff --git a/tests/xfs/085.out b/tests/xfs/085.out
index 6303081..ff3dccd 100644
--- a/tests/xfs/085.out
+++ b/tests/xfs/085.out
@@ -5,8 +5,6 @@ QA output created by 085
 + check fs
 + corrupt image
 + mount image
-+ modify files
-broken: 1
 + repair fs
 + mount image (2)
 + chattr -R -i
diff --git a/tests/xfs/098.out b/tests/xfs/098.out
index 84a2b4d..ef0554d 100644
--- a/tests/xfs/098.out
+++ b/tests/xfs/098.out
@@ -5,7 +5,6 @@ QA output created by 098
 + check fs
 + corrupt image
 + mount image
-broken: 1
 + repair fs
 + mount image (2)
 + chattr -R -i
diff --git a/tests/xfs/099.out b/tests/xfs/099.out
index 4426859..773200b 100644
--- a/tests/xfs/099.out
+++ b/tests/xfs/099.out
@@ -1,4 +1,4 @@
-QA output created by 016
+QA output created by 099
 + create scratch fs
 + mount fs image
 + make some files
diff --git a/tests/xfs/100.out b/tests/xfs/100.out
index 98d8dbc..97dba7c 100644
--- a/tests/xfs/100.out
+++ b/tests/xfs/100.out
@@ -1,4 +1,4 @@
-QA output created by 017
+QA output created by 100
 + create scratch fs
 + mount fs image
 + make some files
diff --git a/tests/xfs/101.out b/tests/xfs/101.out
index 49430f7..22ca620 100644
--- a/tests/xfs/101.out
+++ b/tests/xfs/101.out
@@ -1,4 +1,4 @@
-QA output created by 018
+QA output created by 101
 + create scratch fs
 + mount fs image
 + make some files
diff --git a/tests/xfs/102.out b/tests/xfs/102.out
index 58f493c..d8a8fa1 100644
--- a/tests/xfs/102.out
+++ b/tests/xfs/102.out
@@ -1,4 +1,4 @@
-QA output created by 019
+QA output created by 102
 + create scratch fs
 + mount fs image
 + make some files

