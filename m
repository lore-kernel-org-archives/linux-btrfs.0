Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34479 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbcBKNCO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 08:02:14 -0500
Received: by mail-wm0-f68.google.com with SMTP id p63so10547265wmp.1
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Feb 2016 05:02:14 -0800 (PST)
From: Alexander Fougner <fougner89@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Fougner <fougner89@gmail.com>
Subject: [PATCH 2/2] btrfs-progs: add completion for subcommand dump-tree
Date: Thu, 11 Feb 2016 14:01:56 +0100
Message-Id: <1455195716-16282-2-git-send-email-fougner89@gmail.com>
In-Reply-To: <1455195716-16282-1-git-send-email-fougner89@gmail.com>
References: <1455195716-16282-1-git-send-email-fougner89@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Alexander Fougner <fougner89@gmail.com>
---
 btrfs-completion | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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

