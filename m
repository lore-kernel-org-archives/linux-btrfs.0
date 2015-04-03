Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34768 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751335AbbDCHZV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Apr 2015 03:25:21 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t337OC9C003097
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Apr 2015 15:24:14 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v4] btrfs-progs: Doc: Add warning and note on btrfs-convert.
Date: Fri, 3 Apr 2015 15:23:13 +0800
Message-ID: <1428045793-11511-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although btrfs-convert can rollback converted btrfs, it still has some
limitation to ensure rollback.

Add a warning on the limitations.

Also add a note for users who decides to go on with btrfs and don't need
the rollback ability.

Reported-by: Vytautas D <vytdau@gmail.com>
Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Add reporter tags
v3:
  Remove 'btrfs fi defrag' from commands that may disable rollback
  ability.
  Add a little explain to make the warning more reasonable.
v4:
  Some gramma changes. Thanks Ducan and Roman.
---
 Documentation/btrfs-convert.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/btrfs-convert.txt b/Documentation/btrfs-convert.txt
index 8b3f05b..09510fa 100644
--- a/Documentation/btrfs-convert.txt
+++ b/Documentation/btrfs-convert.txt
@@ -15,6 +15,15 @@ DESCRIPTION
 and the original filesystem image is accessible as from separate subvolume
 named 'ext2_saved' as file image.
 
+WARNING: If one hopes to rollback to ext2/3/4, they should not execute
+*btrfs balance* command on converted btrfs, since it will change the extent
+layout and make *btrfs-convert* unable to rollback.
+
+NOTE: If one is satisfied with converted btrfs, and not longer wants to
+rollback to ext2/3/4, it is highly recommended to remove 'ext2_saved' subvolume
+and execute *btrfs filesystem defragment* and *btrfs balance* command on the
+converted btrfs.
+
 OPTIONS
 -------
 -d|--no-datasum::
-- 
2.3.5

