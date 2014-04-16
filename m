Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbaDPRez (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 13:34:55 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 36DEBACDB
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Apr 2014 17:34:54 +0000 (UTC)
From: David Disseldorp <ddiss@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: David Disseldorp <ddiss@suse.de>
Subject: [PATCH] btrfs-progs: fix typo in subvol list usage
Date: Wed, 16 Apr 2014 19:34:50 +0200
Message-Id: <1397669690-11950-1-git-send-email-ddiss@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 cmds-subvolume.c | 2 +-
 man/btrfs.8.in   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 5e821c7..75a7385 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -390,7 +390,7 @@ static const char * const cmd_subvol_list_usage[] = {
 	"             to the given <path>",
 	"-c           print the ogeneration of the subvolume",
 	"-g           print the generation of the subvolume",
-	"-o           print only subvolumes bellow specified path",
+	"-o           print only subvolumes below the specified path",
 	"-u           print the uuid of subvolumes (and snapshots)",
 	"-q           print the parent uuid of the snapshots",
 	"-t           print the result as a table",
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 8fea115..4221cc2 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -214,7 +214,7 @@ print the ogeneration of the subvolume, aliases: ogen or origin generation.
 .IP "\fB-g\fP" 5
 print the generation of the subvolume.
 .IP "\fB-o\fP" 5
-print only subvolumes bellow specified <path>.
+print only subvolumes below the specified <path>.
 .IP "\fB-u\fP" 5
 print the UUID of the subvolume.
 .IP "\fB-q\fP" 5
-- 
1.8.4.5

