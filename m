Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:37815 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762938Ab3DIRIs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 13:08:48 -0400
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp2) (RZmta 31.24 OK)
	with ESMTP id g070f0p39GGG8L for <linux-btrfs@vger.kernel.org>;
	Tue, 9 Apr 2013 19:08:46 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 02/17] Btrfs-progs: ignore subvols above BTRFS_LAST_FREE_OBJECTID
Date: Tue,  9 Apr 2013 19:08:30 +0200
Message-Id: <df80e417a21943c9c05ce6f4b8dd84b0a9bf4bde.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 send-utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/send-utils.c b/send-utils.c
index d8d3972..b1d3873 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -226,7 +226,7 @@ int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
 
 			if ((sh->objectid != 5 &&
 			    sh->objectid < BTRFS_FIRST_FREE_OBJECTID) ||
-			    sh->objectid == BTRFS_FREE_INO_OBJECTID)
+			    sh->objectid > BTRFS_LAST_FREE_OBJECTID)
 				goto skip;
 
 			if (sh->type == BTRFS_ROOT_ITEM_KEY) {
-- 
1.8.2.1

