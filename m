Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35695 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbcCKLuH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Mar 2016 06:50:07 -0500
Received: by mail-wm0-f65.google.com with SMTP id n205so1967642wmf.2
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Mar 2016 03:50:06 -0800 (PST)
From: Alexander Fougner <fougner89@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Fougner <fougner89@gmail.com>
Subject: [PATCH 2/2] btrfs-progs: update docs and completion for tree-stats
Date: Fri, 11 Mar 2016 12:49:46 +0100
Message-Id: <1457696986-19287-2-git-send-email-fougner89@gmail.com>
In-Reply-To: <1457696986-19287-1-git-send-email-fougner89@gmail.com>
References: <1457696986-19287-1-git-send-email-fougner89@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Alexander Fougner <fougner89@gmail.com>
---
 Documentation/btrfs-inspect-internal.asciidoc | 10 ++++++++++
 btrfs-completion                              |  2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentation/btrfs-inspect-internal.asciidoc
index bbbbc59..eb83708 100644
--- a/Documentation/btrfs-inspect-internal.asciidoc
+++ b/Documentation/btrfs-inspect-internal.asciidoc
@@ -128,6 +128,16 @@ for debugging (disables the '-f' option)
 +
 resolve the absolute path of a the subvolume id 'subvolid'
 
+*tree-stats* [options] <device>::
+(needs root privileges)
++
+Print sizes and statistics of trees.
++
+`Options`
++
+-b::::
+Print raw numbers in bytes.
+
 EXIT STATUS
 -----------
 *btrfs inspect-internal* returns a zero exit status if it succeeds. Non zero is
diff --git a/btrfs-completion b/btrfs-completion
index db0dd97..3ede77b 100644
--- a/btrfs-completion
+++ b/btrfs-completion
@@ -36,7 +36,7 @@ _btrfs()
     commands_device='scan add delete remove ready stats usage'
     commands_scrub='start cancel resume status'
     commands_rescue='chunk-recover super-recover'
-    commands_inspect_internal='inode-resolve logical-resolve subvolid-resolve rootid min-dev-size dump-tree dump-super'
+    commands_inspect_internal='inode-resolve logical-resolve subvolid-resolve rootid min-dev-size dump-tree dump-super tree-stats'
     commands_property='get set list'
     commands_quota='enable disable rescan'
     commands_qgroup='assign remove create destroy show limit'
-- 
2.7.2

