Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:28152 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab3DVKRy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 06:17:54 -0400
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp1) (RZmta 31.27 OK)
	with ESMTP id X075dfp3LHquVV for <linux-btrfs@vger.kernel.org>;
	Mon, 22 Apr 2013 12:17:51 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: btrfs-crc: support specifying checksum in hex
Date: Mon, 22 Apr 2013 12:17:51 +0200
Message-Id: <1366625871-7228-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 btrfs-crc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/btrfs-crc.c b/btrfs-crc.c
index 6e21a0e..e4cda43 100644
--- a/btrfs-crc.c
+++ b/btrfs-crc.c
@@ -49,7 +49,7 @@ int main(int argc, char **argv)
 			length = atol(optarg);
 			break;
 		case 'c':
-			checksum = atol(optarg);
+			sscanf(optarg, "%li", &checksum);
 			loop = 1;
 			break;
 		case 's':
-- 
1.8.2.1

