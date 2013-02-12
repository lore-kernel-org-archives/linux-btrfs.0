Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:56057 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758189Ab3BLIiB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 03:38:01 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so696838yen.4
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 00:38:00 -0800 (PST)
From: Filipe Brandenburger <filbranden@google.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Brandenburger <filbranden@google.com>
Subject: [PATCH 1/2] btrfs-progs: anchor gitignore patterns on the root of the tree
Date: Tue, 12 Feb 2013 00:37:44 -0800
Message-Id: <1360658265-6987-2-git-send-email-filbranden@google.com>
In-Reply-To: <1360658265-6987-1-git-send-email-filbranden@google.com>
References: <1360658265-6987-1-git-send-email-filbranden@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is needed in order to allow checking out fs/btrfs/, otherwise the ignore
rule for the btrfs binary would conflict with it.

Signed-off-by: Filipe Brandenburger <filbranden@google.com>
---
 .gitignore | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/.gitignore b/.gitignore
index 0e560d5..3d360b6 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,15 +1,21 @@
 *.o
 .*.o.d
-version.h
-man/*.gz
-btrfs
-btrfs-debug-tree
-btrfs-map-logical
-btrfs-show
-btrfs-vol
-btrfsck
-btrfsctl
-find-root
-mkfs.btrfs
-repair
-restore
+/version.h
+/man/*.gz
+/btrfs
+/btrfsck
+/btrfs-convert
+/btrfsctl
+/btrfs-debug-tree
+/btrfs-find-root
+/btrfs-image
+/btrfs-map-logical
+/btrfs-restore
+/btrfs-show
+/btrfstune
+/btrfs-vol
+/btrfs-zero-log
+/find-root
+/mkfs.btrfs
+/repair
+/restore
-- 
1.8.1.2

