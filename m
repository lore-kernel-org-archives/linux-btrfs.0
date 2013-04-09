Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:38212 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932460Ab3DIRIs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 13:08:48 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp4) (RZmta 31.24 OK)
	with ESMTP id 60630ap39GfxKo for <linux-btrfs@vger.kernel.org>;
	Tue, 9 Apr 2013 19:08:46 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 16/17] Btrfs-progs: allow to receive to relative directories
Date: Tue,  9 Apr 2013 19:08:44 +0200
Message-Id: <6cc2468237eaa50d98b6af05ada8ebee0233fb11.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 cmds-receive.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index f937366..e5467d2 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -755,7 +755,7 @@ static int process_utimes(const char *path, struct timespec *at,
 
 	tv[0] = *at;
 	tv[1] = *mt;
-	ret = utimensat(-1, full_path, tv, AT_SYMLINK_NOFOLLOW);
+	ret = utimensat(AT_FDCWD, full_path, tv, AT_SYMLINK_NOFOLLOW);
 	if (ret < 0) {
 		ret = -errno;
 		fprintf(stderr, "ERROR: utimes %s failed. %s\n",
-- 
1.8.2.1

