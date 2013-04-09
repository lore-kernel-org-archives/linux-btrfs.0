Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:51077 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759921Ab3DIRIs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 13:08:48 -0400
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp2) (RZmta 31.24 OK)
	with ESMTP id g070f0p39GGG8M for <linux-btrfs@vger.kernel.org>;
	Tue, 9 Apr 2013 19:08:46 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 15/17] Btrfs-progs: remove some unused code
Date: Tue,  9 Apr 2013 19:08:43 +0200
Message-Id: <1f7d2465ba97630b0b0f48e9df4c2cf15a23bc50.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 send-stream.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/send-stream.c b/send-stream.c
index 1a498f3..88e18e2 100644
--- a/send-stream.c
+++ b/send-stream.c
@@ -410,9 +410,6 @@ static int read_and_process_cmd(struct btrfs_send_stream *s)
 		break;
 	case BTRFS_SEND_C_UTIMES:
 		TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
-		if (strstr(path, ".bak_1.log")) {
-			ret = 0;
-		}
 		TLV_GET_TIMESPEC(s, BTRFS_SEND_A_ATIME, &at);
 		TLV_GET_TIMESPEC(s, BTRFS_SEND_A_MTIME, &mt);
 		TLV_GET_TIMESPEC(s, BTRFS_SEND_A_CTIME, &ct);
-- 
1.8.2.1

