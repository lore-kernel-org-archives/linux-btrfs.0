Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:52999 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750705AbdLZF57 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 26 Dec 2017 00:57:59 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH] fstests: btrfs: Add new 'limit' test group for btrfs
Date: Tue, 26 Dec 2017 13:57:44 +0800
Message-Id: <20171226055744.27697-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs qgroup also supports to limit the usage of specified qgroups.

It's possible to enable qgroup but doesn't enable limit.
(Most user won't use qgroup limit for various problems)

So add a new test group 'limit' for btrfs, as a subset of existing
'qgroup' group.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/btrfs/group | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tests/btrfs/group b/tests/btrfs/group
index f68abf4d6655..6324c54d7699 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -24,7 +24,7 @@
 019 auto quick send
 020 auto quick replace
 021 auto quick balance defrag
-022 auto qgroup
+022 auto qgroup limit
 023 auto
 024 auto quick compress
 025 auto quick send clone
@@ -44,7 +44,7 @@
 039 auto quick send
 040 auto quick send
 041 auto quick compress
-042 auto quick qgroup
+042 auto quick qgroup limit
 043 auto quick send
 044 auto quick send
 045 auto quick send
@@ -101,7 +101,7 @@
 096 auto quick clone
 097 auto quick send clone
 098 auto quick metadata clone
-099 auto quick qgroup
+099 auto quick qgroup limit
 100 auto replace
 101 auto replace
 102 auto quick metadata enospc
@@ -128,7 +128,7 @@
 123 auto quick qgroup
 124 auto replace
 125 auto replace
-126 auto quick qgroup
+126 auto quick qgroup limit
 127 auto quick send
 128 auto quick send
 129 auto quick send
@@ -141,7 +141,7 @@
 136 auto convert
 137 auto quick send
 138 auto compress
-139 auto qgroup
+139 auto qgroup limit
 140 auto quick
 141 auto quick
 142 auto quick
@@ -155,7 +155,7 @@
 150 auto quick dangerous
 151 auto quick
 152 auto quick metadata qgroup send
-153 auto quick qgroup
+153 auto quick qgroup limit
 154 auto quick
 155 auto quick send
 156 auto quick trim
-- 
2.15.1

