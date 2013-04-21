Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56876 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618Ab3DUWv4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Apr 2013 18:51:56 -0400
Message-ID: <51746D8A.60707@sandeen.net>
Date: Sun, 21 Apr 2013 17:51:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>
Subject: [PATCH V3] xfstests: fix common filter include in filter.btrfs
References: <517386CC.8010406@redhat.com> <51746D07.5090300@sandeen.net>
In-Reply-To: <51746D07.5090300@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Not sure how this happened, but filter.btrfs including
itself leads to immense sadness for any file that includes it.
(I got a segfault when I tried to run 307)

It should be including ./common/filter not ./common/filter.btrfs

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

cripes, I'm sorry that took 3 times to get right :/

diff --git a/common/filter.btrfs b/common/filter.btrfs
index b1aa733..e9a2bc2 100644
--- a/common/filter.btrfs
+++ b/common/filter.btrfs
@@ -1,6 +1,6 @@
 # Filters for btrfs command output
 
-. ./common/filter.btrfs
+. ./common/filter
 
 # Some, but not all, commands emit "Btrfs <version>"
 _filter_btrfs_version()


