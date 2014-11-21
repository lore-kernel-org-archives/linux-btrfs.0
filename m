Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbaKUEzq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 23:55:46 -0500
From: Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>
Subject: [PATCH] btrfs: add groups for btrfs tests
Date: Fri, 21 Nov 2014 12:54:47 +0800
Message-Id: <1416545687-19692-1-git-send-email-eguan@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some new btrfs groups have been added in the btrfs stress patchset add
other tests to proper groups too.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/btrfs/group | 110 +++++++++++++++++++++++++++---------------------------
 1 file changed, 55 insertions(+), 55 deletions(-)

diff --git a/tests/btrfs/group b/tests/btrfs/group
index b63f174..9cee026 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -3,64 +3,64 @@
 # - do not start group names with a digit
 # - comment line before each group is "new" description
 #
-001 auto quick
-002 auto
-003 auto
+001 auto quick subvol snapshot
+002 auto snapshot
+003 auto replace
 004 auto rw metadata
-005 auto
+005 auto defrag
 006 auto quick
-007 auto rw metadata
-008 auto quick
-009 auto quick
-010 auto quick
-011 auto
-012 auto
-013 auto quick
-014 auto
-015 auto quick
-016 auto quick
-017 auto quick
-018 auto quick
-019 auto quick
-020 auto quick
-021 auto quick
-022 auto
+007 auto rw metadata send
+008 auto quick send
+009 auto quick subvol
+010 auto quick defrag
+011 auto replace
+012 auto convert
+013 auto quick balance
+014 auto balance
+015 auto quick snapshot
+016 auto quick send
+017 auto quick snapshot
+018 auto quick subvol
+019 auto quick send
+020 auto quick replace
+021 auto quick balance defrag
+022 auto qgroup
 023 auto
-024 auto quick
-025 auto quick
-026 auto quick
-027 auto quick
-028 auto quick
-029 auto quick
-030 auto quick
-031 auto quick
-032 auto quick
-033 auto quick
-034 auto quick
-035 auto quick
-036 auto quick
-037 auto quick
-038 auto quick
-039 auto quick
-040 auto quick
-041 auto quick
-042 auto quick
-043 auto quick
-044 auto quick
-045 auto quick
-046 auto quick
-047 auto quick
+024 auto quick compress
+025 auto quick send clone
+026 auto quick clone
+027 auto quick clone
+028 auto quick clone
+029 auto quick clone
+030 auto quick send
+031 auto quick subvol clone
+032 auto quick remount
+033 auto quick send snapshot
+034 auto quick send
+035 auto quick clone
+036 auto quick send snapshot
+037 auto quick compress
+038 auto quick compress send
+039 auto quick send
+040 auto quick send
+041 auto quick compress
+042 auto quick qgroup
+043 auto quick send
+044 auto quick send
+045 auto quick send
+046 auto quick send
+047 auto quick send
 048 auto quick
 049 auto quick
-050 auto
-051 auto quick
-052 auto quick
-053 auto quick
-054 auto quick
-055 auto quick
-056 auto quick
+050 auto send
+051 auto quick send
+052 auto quick clone
+053 auto quick send
+054 auto quick send
+055 auto quick clone
+056 auto quick clone
 057 auto quick
-058 auto quick
+058 auto quick send snapshot
 059 auto quick
 060 auto balance subvol
 061 auto balance scrub
@@ -78,7 +78,7 @@
 073 auto scrub remount compress
 074 auto defrag remount compress
 075 auto quick subvol
-076 auto quick
-077 auto quick
-078 auto
+076 auto quick compress
+077 auto quick send snapshot
+078 auto snapshot
 079 auto
-- 
1.9.3

