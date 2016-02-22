Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37492 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbcBVOuY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 09:50:24 -0500
Received: by mail-wm0-f50.google.com with SMTP id g62so167216701wme.0
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Feb 2016 06:50:23 -0800 (PST)
From: Alexander Fougner <fougner89@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Fougner <fougner89@gmail.com>
Subject: [PATCH v2 2/2] btrfs-progs: update docs and completion for inspect-internal dump-tree
Date: Mon, 22 Feb 2016 15:49:50 +0100
Message-Id: <1456152590-24601-2-git-send-email-fougner89@gmail.com>
In-Reply-To: <1456152590-24601-1-git-send-email-fougner89@gmail.com>
References: <1456152590-24601-1-git-send-email-fougner89@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Alexander Fougner <fougner89@gmail.com>
---
 Documentation/btrfs-debug-tree.asciidoc       |  7 +++++++
 Documentation/btrfs-inspect-internal.asciidoc | 26 ++++++++++++++++++++++++++
 btrfs-completion                              |  8 ++++----
 3 files changed, 37 insertions(+), 4 deletions(-)

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
diff --git a/btrfs-completion b/btrfs-completion
index a34191b..7631911 100644
--- a/btrfs-completion
+++ b/btrfs-completion
@@ -20,13 +20,13 @@ _btrfs_mnts()
 	COMPREPLY+=( $( compgen -W "$MNTS" -- "$cur" ) )
 }
 
-_btrfs() 
+_btrfs()
 {
 	local cur prev words cword
     _init_completion || return
 
     COMPREPLY=()
-    
+
 	local cmd=${words[1]}
 
     commands='subvolume filesystem balance device scrub check rescue restore inspect-internal property send receive quota qgroup replace help version'
@@ -36,7 +36,7 @@ _btrfs()
     commands_device='scan add delete remove ready stats usage'
     commands_scrub='start cancel resume status'
     commands_rescue='chunk-recover super-recover'
-    commands_inspect_internal='inode-resolve logical-resolve subvolid-resolve rootid min-dev-size'
+    commands_inspect_internal='inode-resolve logical-resolve subvolid-resolve rootid min-dev-size dump-tree'
     commands_property='get set list'
     commands_quota='enable disable rescan'
     commands_qgroup='assign remove create destroy show limit'
@@ -146,7 +146,7 @@ _btrfs()
     fi
 
     _filedir -d
-    return 0  
+    return 0
 }
 
 complete -F _btrfs btrfs
-- 
2.7.1

