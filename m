Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57061 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbaHRKWs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Aug 2014 06:22:48 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id BAD0FABF3
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Aug 2014 10:22:46 +0000 (UTC)
From: David Disseldorp <ddiss@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: David Disseldorp <ddiss@suse.de>
Subject: [PATCH v2] btrfs-progs: fix typo in subvol list usage
Date: Mon, 18 Aug 2014 12:22:35 +0200
Message-Id: <1408357355-15053-1-git-send-email-ddiss@suse.de>
In-Reply-To: <1397669690-11950-1-git-send-email-ddiss@suse.de>
References: <1397669690-11950-1-git-send-email-ddiss@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 Documentation/btrfs-subvolume.txt | 2 +-
 cmds-subvolume.c                  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/btrfs-subvolume.txt b/Documentation/btrfs-subvolume.txt
index a519131..c8b9928 100644
--- a/Documentation/btrfs-subvolume.txt
+++ b/Documentation/btrfs-subvolume.txt
@@ -99,7 +99,7 @@ print the ogeneration of the subvolume, aliases: ogen or origin generation.
 -g::::
 print the generation of the subvolume.
 -o::::
-print only subvolumes bellow specified <path>.
+print only subvolumes below the specified <path>.
 -u::::
 print the UUID of the subvolume.
 -q::::
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
-- 
1.8.4.5

