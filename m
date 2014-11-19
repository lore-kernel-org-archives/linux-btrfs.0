Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34418 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350AbaKSPde (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Nov 2014 10:33:34 -0500
Message-ID: <546CB84B.8010200@sandeen.net>
Date: Wed, 19 Nov 2014 09:33:31 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: fstests@vger.kernel.org
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] fstests: mark replace tests in btrfs/group
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A couple tests exercise replace but were not marked as such
in the group file.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/tests/btrfs/group b/tests/btrfs/group
index 9adf862..1f23979 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -13,7 +13,7 @@
 008 auto quick
 009 auto quick
 010 auto quick
-011 auto
+011 auto replace
 012 auto
 013 auto quick
 014 auto
@@ -22,7 +22,7 @@
 017 auto quick
 018 auto quick
 019 auto quick
-020 auto quick
+020 auto quick replace
 021 auto quick
 022 auto
 023 auto

