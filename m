Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34968 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaHLVFs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 17:05:48 -0400
Received: from ruthven.local ([10.73.18.16] helo=ruthven.carfax.org.uk)
	by frost.carfax.org.uk with esmtp (Exim 4.80)
	(envelope-from <hugo@carfax.org.uk>)
	id 1XHIbM-0005cl-Ma
	for linux-btrfs@vger.kernel.org; Tue, 12 Aug 2014 20:23:24 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH] btrfs-progs: Fix spelling in btrfs sub list help
Date: Tue, 12 Aug 2014 21:22:53 +0100
Message-Id: <1407874973-24502-2-git-send-email-hugo@carfax.org.uk>
In-Reply-To: <1407874973-24502-1-git-send-email-hugo@carfax.org.uk>
References: <1407874973-24502-1-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"below", not "bellow"

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 cmds-subvolume.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 5216e53..349d0db 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -390,7 +390,7 @@ static const char * const cmd_subvol_list_usage[] = {
 	"             to the given <path>",
 	"-c           print the ogeneration of the subvolume",
 	"-g           print the generation of the subvolume",
-	"-o           print only subvolumes bellow specified path",
+	"-o           print only subvolumes below specified path",
 	"-u           print the uuid of subvolumes (and snapshots)",
 	"-q           print the parent uuid of the snapshots",
 	"-R           print the uuid of the received snapshots",
-- 
2.0.1

