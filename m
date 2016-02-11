Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19504 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbcBKXjd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 18:39:33 -0500
Subject: [PATCH 01/32] generic/182: this is a dedupe test, check for dedupe
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Thu, 11 Feb 2016 15:39:23 -0800
Message-ID: <20160211233923.2202.16359.stgit@birch.djwong.org>
In-Reply-To: <20160211233916.2202.40961.stgit@birch.djwong.org>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since this test examines dedupe behavior, the documentation should
say 'dedupe', not 'reflink'.  Furthermore, the feature checks must
look for working dedupe functionality, not reflink functionality.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[hch@lst.de: add the test for dedupe support]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/182 |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/tests/generic/182 b/tests/generic/182
index bf5cd38..ef10af8 100755
--- a/tests/generic/182
+++ b/tests/generic/182
@@ -1,10 +1,10 @@
 #! /bin/bash
 # FS QA Test No. 182
 #
-# Test the convention that reflink with length == 0 means "to the end of fileA"
+# Test the convention that dedupe with length == 0 means "to the end of fileA"
 #   - Create a file.
-#   - Try to reflink "zero" bytes (which means reflink to EOF).
-#   - Check that the reflink happened.
+#   - Try to dedupe "zero" bytes (which means dedupe to EOF).
+#   - Check that the dedupe happened.
 #
 #-----------------------------------------------------------------------
 # Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
@@ -45,8 +45,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_os Linux
-_require_test_reflink
-_require_cp_reflink
+_require_test_dedupe
 
 rm -f "$seqres.full"
 

