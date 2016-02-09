Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34678 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964783AbcBIQMc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Feb 2016 11:12:32 -0500
Received: by mail-wm0-f68.google.com with SMTP id p63so4306797wmp.1
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 08:12:31 -0800 (PST)
From: Alexander Fougner <fougner89@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Fougner <fougner89@gmail.com>
Subject: [PATCH 2/2] btrfs-progs: update docs for inspect-internal dump-tree
Date: Tue,  9 Feb 2016 17:12:09 +0100
Message-Id: <1455034329-27200-2-git-send-email-fougner89@gmail.com>
In-Reply-To: <1455034329-27200-1-git-send-email-fougner89@gmail.com>
References: <1455034329-27200-1-git-send-email-fougner89@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Alexander Fougner <fougner89@gmail.com>
---
 Documentation/btrfs-debug-tree.asciidoc       |  7 +++++++
 Documentation/btrfs-inspect-internal.asciidoc | 26 ++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/Documentation/btrfs-debug-tree.asciidoc b/Documentation/btrfs-debug-tree.asciidoc
index 23fc115..6d6d884 100644
--- a/Documentation/btrfs-debug-tree.asciidoc
+++ b/Documentation/btrfs-debug-tree.asciidoc
@@ -25,8 +25,15 @@ Print detailed extents info.
 Print info of btrfs device and root tree dirs only.
 -r::
 Print info of roots only.
+-R::
+Print info of roots and root backups.
+-u::
+Print info of UUID tree only.
 -b <block_num>::
 Print info of the specified block only.
+-t <tree_id>::
+Print only the tree with the specified ID.
+
 
 EXIT STATUS
 -----------
diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentation/btrfs-inspect-internal.asciidoc
index 1c7c361..25e6b8b 100644
--- a/Documentation/btrfs-inspect-internal.asciidoc
+++ b/Documentation/btrfs-inspect-internal.asciidoc
@@ -67,6 +67,32 @@ inode number 2), but such subvolume does not contain any files anyway
 +
 resolve the absolute path of a the subvolume id 'subvolid'
 
+*dump-tree* [options] <device>::
+(needs root privileges)
++
+Dump the whole tree of the given device.
+This is useful for analyzing filesystem state or inconsistence and has
+a positive educational effect on understanding the internal structure.
+<device> is the device file where the filesystem is stored.
++
+`Options`
++
+-e::::
+Print detailed extents info.
+-d::::
+Print info of btrfs device and root tree dirs only.
+-r::::
+Print info of roots only.
+-R::::
+Print info of roots and root backups.
+-u::::
+Print info of UUID tree only.
+-b <block_num>::::
+Print info of the specified block only.
+-t <tree_id>::::
+Print only the tree with the specified ID.
+
+
 EXIT STATUS
 -----------
 *btrfs inspect-internal* returns a zero exit status if it succeeds. Non zero is
-- 
2.7.1

