Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.139]:26648 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934433Ab3DIRIt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 13:08:49 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp1) (RZmta 31.24 OK)
	with ESMTP id X0628ep39FGDUT for <linux-btrfs@vger.kernel.org>;
	Tue, 9 Apr 2013 19:08:46 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 04/17] Btrfs-progs: fix a small memory leak in btrfs-list.c
Date: Tue,  9 Apr 2013 19:08:32 +0200
Message-Id: <b37eb3ca53ea201aef5315b676ca8ff9ea0aa56c.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

valgrind found this very obvious issue.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 btrfs-list.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index a748d5e..38e7e53 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -577,13 +577,13 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
 
 		add_len = strlen(found->path);
 
-		/* room for / and for null */
-		tmp = malloc(add_len + 2 + len);
-		if (!tmp) {
-			perror("malloc failed");
-			exit(1);
-		}
 		if (full_path) {
+			/* room for / and for null */
+			tmp = malloc(add_len + 2 + len);
+			if (!tmp) {
+				perror("malloc failed");
+				exit(1);
+			}
 			memcpy(tmp + add_len + 1, full_path, len);
 			tmp[add_len] = '/';
 			memcpy(tmp, found->path, add_len);
-- 
1.8.2.1

