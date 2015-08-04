Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62333 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750795AbbHDFyH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Aug 2015 01:54:07 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.com>
Subject: [PATCH] btrfs-progs: Doc: Add extra notes for qgroup
Date: Tue, 4 Aug 2015 13:52:00 +0800
Message-ID: <1438667520-29521-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add extra explaination on btrfs qgroup on the following two things:
1) Need sync to show accurate qgroup numbers
2) Cow may cause extra quota usage

Although btrfs qgroup is still buggy, especially for limit behavior, but
some strange behavior is not really a bug.
Just add these explaination for end users if they really want to try it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-qgroup.asciidoc | 40 +++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/Documentation/btrfs-qgroup.asciidoc b/Documentation/btrfs-qgroup.asciidoc
index 57cf012..f2fc514 100644
--- a/Documentation/btrfs-qgroup.asciidoc
+++ b/Documentation/btrfs-qgroup.asciidoc
@@ -127,6 +127,46 @@ If no prefix is given, use ascending order by default.
 +
 If multiple <attr>s is given, use comma to separate.
 
+EXTRA NOTES
+-----------
+1. Need sync before *btrfs qgroup show* command
++
+Sync is needed to output correct numbers, especially after kernel v4.2.
+
+2. Copy-on-write(CoW) may cause extra space usage
++
+Cow will cause extra space usage, compared to overwrite filesystem, like ext4
+or xfs.
++
+Here is a example, for a file with 12K contents:
++
+--------------------------------------
+File1:
+0	4K	8K	12K
+|<-------Extent A------>|
+--------------------------------------
++
+It takes 12K space.
++
+But after a rewrite of the 4K in the middle: +
++
+--------------------------------------
+File1:
+0	4K	8K	12K
+|<-------Extent A------>|
+	|<--B-->|
+--------------------------------------
++
+New extent B will record the new data, although the original extent A still
+exists, until none part of it is referred. +
+So in this case, it will take 12 + 4 = 16K, other than 12K as a traditional
+filesystem.
++
+The overhead can be reduced by either using *nodatacow* mount option to disable
+possible COW or defrag. +
+But it won't completely remove the extra space usage when snapshot/subvolume is
+involved.
+
 EXIT STATUS
 -----------
 *btrfs qgroup* returns a zero exit status if it succeeds. Non zero is
-- 
2.5.0

