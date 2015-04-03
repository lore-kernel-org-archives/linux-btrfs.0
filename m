Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32856 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752561AbbDCBX1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Apr 2015 21:23:27 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t331MK08013770
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Apr 2015 09:22:20 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3] btrfs-progs: Doc: Add warning and note on btrfs-convert.
Date: Fri, 3 Apr 2015 09:21:15 +0800
Message-ID: <1428024075-10211-1-git-send-email-quwenruo@cn.fujitsu.com>
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
---
 Documentation/btrfs-convert.txt | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/btrfs-convert.txt b/Documentation/btrfs-convert.txt
index 8b3f05b..b57af73 100644
--- a/Documentation/btrfs-convert.txt
+++ b/Documentation/btrfs-convert.txt
@@ -15,6 +15,16 @@ DESCRIPTION
 and the original filesystem image is accessible as from separate subvolume
 named 'ext2_saved' as file image.
 
+WARNING: If one hopes to rollback to ext2/3/4, he or she should not execute
+*btrfs balance* command on converted btrfs.
+Since it will change the extent layout and make *btrfs-convert* unable to
+rollback.
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

