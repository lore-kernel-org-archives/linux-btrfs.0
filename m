Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56854 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab3DUWtp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Apr 2013 18:49:45 -0400
Message-ID: <51746D07.5090300@sandeen.net>
Date: Sun, 21 Apr 2013 17:49:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: xfs-oss <xfs@oss.sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V2] xfstests: remove recursive include in filter.btrfs
References: <517386CC.8010406@redhat.com>
In-Reply-To: <517386CC.8010406@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Not sure how this happened, but filter.btrfs including
itself leads to immense sadness for any file that includes it.
(I got a segfault when I tried to run 307)

It should be including the common/filter not common/filter.btrfs

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/common/filter.btrfs b/common/filter.btrfs
index b1aa733..3435d8d 100644
--- a/common/filter.btrfs
+++ b/common/filter.btrfs
@@ -1,6 +1,6 @@
 # Filters for btrfs command output
 
-. ./common/filter.btrfs
+. ./filter
 
 # Some, but not all, commands emit "Btrfs <version>"
 _filter_btrfs_version()

