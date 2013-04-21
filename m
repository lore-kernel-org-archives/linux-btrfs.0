Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab3DUG1Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Apr 2013 02:27:24 -0400
Message-ID: <517386CC.8010406@redhat.com>
Date: Sun, 21 Apr 2013 01:27:24 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: xfs-oss <xfs@oss.sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] xfstests: remove recursive include in filter.btrfs
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Not sure how this happened, but filter.btrfs including
itself leads to immense sadness for any file that includes it.
(I got a segfault when I tried to run 307)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/common/filter.btrfs b/common/filter.btrfs
index b1aa733..99d04a6 100644
--- a/common/filter.btrfs
+++ b/common/filter.btrfs
@@ -1,7 +1,5 @@
 # Filters for btrfs command output
 
-. ./common/filter.btrfs
-
 # Some, but not all, commands emit "Btrfs <version>"
 _filter_btrfs_version()
 {

