Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:38752 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763035Ab3DIRIs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 13:08:48 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp1) (RZmta 31.24 OK)
	with ESMTP id X0628ep39FGDUa for <linux-btrfs@vger.kernel.org>;
	Tue, 9 Apr 2013 19:08:46 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 11/17] Btrfs-progs: fix bug in find_root_gen
Date: Tue,  9 Apr 2013 19:08:39 +0200
Message-Id: <f8224d5625e844e554775ae3bd218ef7179440a0.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A copy & paste error.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 btrfs-list.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 38e7e53..1246a25 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -775,7 +775,7 @@ static u64 find_root_gen(int fd)
 
 		if (sk->min_type != BTRFS_ROOT_ITEM_KEY)
 			break;
-		if (sk->min_objectid != BTRFS_ROOT_ITEM_KEY)
+		if (sk->min_objectid != ino_args.treeid)
 			break;
 	}
 	return max_found;
-- 
1.8.2.1

