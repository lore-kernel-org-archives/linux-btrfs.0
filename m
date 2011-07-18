From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH] btrfs-progs-unstable: replace debug-tree to btrfs-debug-tree
 in INSTALL
Date: Mon, 18 Jul 2011 15:26:56 +0800
Message-ID: <4E23E040.6040408@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

>From c04da1655df6d75db834ddbd3a3b4a58a0d9a0c9 Mon Sep 17 00:00:00 2001
From: Wang Sheng-Hui <shhuiw@gmail.com>
Date: Mon, 18 Jul 2011 02:17:31 -0500
Subject: [PATCH] btrfs-progs-unstable: replace debug-tree to btrfs-debug-tree in INSTALL

debug-tree doesn't exist after btrfs-progs installed.
Use btrfs-debug-tree to print FS metadata in text form,
not debug-tree.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 INSTALL |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/INSTALL b/INSTALL
index 16b45a5..2db6d27 100644
--- a/INSTALL
+++ b/INSTALL
@@ -42,7 +42,7 @@ btrfsctl: control program to create snapshots and subvolumes:
 
 btrfsck: do a limited check of the FS extent trees.</li>
 
-debug-tree: print all of the FS metadata in text form.  Example:
+btrfs-debug-tree: print all of the FS metadata in text form.  Example:
 
-	debug-tree /dev/sda2 >& big_output_file
+	btrfs-debug-tree /dev/sda2 >& big_output_file
 
-- 
1.7.1
