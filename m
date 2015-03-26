Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50136 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751673AbbCZDBE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Mar 2015 23:01:04 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t2Q2KNtG021315
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Mar 2015 10:20:24 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] btrfs-progs: Doc: Add warning and note on btrfs-convert.
Date: Thu, 26 Mar 2015 10:19:24 +0800
Message-ID: <1427336364-18161-1-git-send-email-quwenruo@cn.fujitsu.com>
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
v2: Add reporters.
---
 Documentation/btrfs-convert.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/btrfs-convert.txt b/Documentation/btrfs-convert.txt
index 8b3f05b..bb2f020 100644
--- a/Documentation/btrfs-convert.txt
+++ b/Documentation/btrfs-convert.txt
@@ -15,6 +15,15 @@ DESCRIPTION
 and the original filesystem image is accessible as from separate subvolume
 named 'ext2_saved' as file image.
 
+WARNING: To ensure *btrfs-convert* be able to rollback btrfs, one should never
+execute *btrfs filesystem defragment* or *btrfs balance* command on the
+converted btrfs.
+
+NOTE: If one is satisfied with converted btrfs, and not longer wants to
+rollback to ext*, it is highly recommended to remove 'ext2_saved' subvolume
+and execute *btrfs filesystem defragment* and *btrfs balance* command on the
+converted btrfs.
+
 OPTIONS
 -------
 -d|--no-datasum::
-- 
2.3.4

