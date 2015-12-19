Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17310 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbbLSJMM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Dec 2015 04:12:12 -0500
Subject: [PATCH 11/11] generic: create a dedupe group
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Sat, 19 Dec 2015 01:12:06 -0800
Message-ID: <20151219091206.15320.10787.stgit@birch.djwong.org>
In-Reply-To: <20151219091052.15320.94973.stgit@birch.djwong.org>
References: <20151219091052.15320.94973.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Create a group for just the deduplication tests.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/group |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)


diff --git a/tests/generic/group b/tests/generic/group
index 68853b4..2c18bce 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -123,8 +123,8 @@
 118 auto quick clone
 119 auto quick clone
 120 other auto quick
-121 auto quick clone
-122 auto quick clone
+121 auto quick clone dedupe
+122 auto quick clone dedupe
 123 perms auto quick
 124 pattern auto quick
 125 other auto
@@ -138,8 +138,8 @@
 133 rw auto
 134 auto quick clone
 135 metadata auto quick
-136 auto quick clone
-137 auto quick clone
+136 auto quick clone dedupe
+137 auto quick clone dedupe
 138 auto quick clone
 139 auto quick clone
 140 auto quick clone
@@ -160,12 +160,12 @@
 155 auto quick clone
 156 auto quick clone
 157 auto quick clone
-158 auto quick clone
+158 auto quick clone dedupe
 159 auto quick clone
-160 auto quick clone
+160 auto quick clone dedupe
 161 auto quick clone
-162 auto quick clone
-163 auto quick clone
+162 auto quick clone dedupe
+163 auto quick clone dedupe
 164 auto quick clone
 165 auto quick clone
 166 auto quick clone
@@ -261,7 +261,7 @@
 847 auto quick clone
 848 auto quick clone
 849 auto quick clone
-850 auto quick clone
+850 auto quick clone dedupe
 851 auto quick clone
 852 auto quick clone
 853 auto quick clone

