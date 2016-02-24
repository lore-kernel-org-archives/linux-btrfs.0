Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35923 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403AbcBXKxF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 05:53:05 -0500
Received: by mail-wm0-f65.google.com with SMTP id a4so2281741wme.3
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Feb 2016 02:53:04 -0800 (PST)
From: Alexander Fougner <fougner89@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Fougner <fougner89@gmail.com>
Subject: [PATCH 2/2] btrfs-progs: update docs for inspect-internal dump-super
Date: Wed, 24 Feb 2016 11:52:34 +0100
Message-Id: <1456311154-32703-2-git-send-email-fougner89@gmail.com>
In-Reply-To: <1456311154-32703-1-git-send-email-fougner89@gmail.com>
References: <1456311154-32703-1-git-send-email-fougner89@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Alexander Fougner <fougner89@gmail.com>
---
 Documentation/btrfs-inspect-internal.asciidoc | 38 +++++++++++++++++++++++++++
 btrfs-completion                              |  2 +-
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentation/btrfs-inspect-internal.asciidoc
index 25e6b8b..a151471 100644
--- a/Documentation/btrfs-inspect-internal.asciidoc
+++ b/Documentation/btrfs-inspect-internal.asciidoc
@@ -92,6 +92,44 @@ Print info of the specified block only.
 -t <tree_id>::::
 Print only the tree with the specified ID.
 
+*show-super* [options] <device> [device...]::
+(needs root privileges)
++
+Show btrfs superblock information stored in devices.
+It is used to print the information of superblock,
+you can specify which mirror to print out.
++
+By default, every device's first superblock will be printed out.
++
+Mainly used for debug purpose.
++
+`Options`
++
+
+-f::::
+Print full superblock information.
++
+Including the system chunk array and backup roots.
+
+-a::::
+Print information of all superblocks.
++
+If this option is given, '-i' option will be ignored.
+
+-i <super_mirror>::::
+Specify which mirror to print out.
++
+<super_mirror> is between 0 and 2.
+If several '-i <super_mirror>' are given, only the last one is valid.
+
+-F::::
+Attempt to print the superblock even if no superblock magic is found.  May end
+badly.
+
+-s <bytenr>::::
+specifiy offset to a superblock in a non-standard location at 'bytenr', useful
+for debugging (disables the '-f' option)
+
 
 EXIT STATUS
 -----------
diff --git a/btrfs-completion b/btrfs-completion
index 7631911..db0dd97 100644
--- a/btrfs-completion
+++ b/btrfs-completion
@@ -36,7 +36,7 @@ _btrfs()
     commands_device='scan add delete remove ready stats usage'
     commands_scrub='start cancel resume status'
     commands_rescue='chunk-recover super-recover'
-    commands_inspect_internal='inode-resolve logical-resolve subvolid-resolve rootid min-dev-size dump-tree'
+    commands_inspect_internal='inode-resolve logical-resolve subvolid-resolve rootid min-dev-size dump-tree dump-super'
     commands_property='get set list'
     commands_quota='enable disable rescan'
     commands_qgroup='assign remove create destroy show limit'
-- 
2.7.1

