Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:37241 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933071Ab3DIRIs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 13:08:48 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp4) (RZmta 31.24 OK)
	with ESMTP id 60630ap39GfxKn for <linux-btrfs@vger.kernel.org>;
	Tue, 9 Apr 2013 19:08:46 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 14/17] Btrfs-progs: Fix that BTRFS_FSID_SIZE is used instead of BTRFS_UUID_SIZE
Date: Tue,  9 Apr 2013 19:08:42 +0200
Message-Id: <11a938fbe224c95918815a4758cf07292930f55f.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Both are 16 but it's wrong anyway to use FSID_SIZE for UUIDs.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 cmds-receive.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index 50c1b97..f937366 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -565,7 +565,7 @@ static int process_clone(const char *path, u64 offset, u64 len,
 			subvol_search_by_received_uuid);
 	if (!si) {
 		if (memcmp(clone_uuid, r->cur_subvol->received_uuid,
-				BTRFS_FSID_SIZE) == 0) {
+				BTRFS_UUID_SIZE) == 0) {
 			/* TODO check generation of extent */
 			subvol_path = strdup(r->cur_subvol->path);
 		} else {
-- 
1.8.2.1

