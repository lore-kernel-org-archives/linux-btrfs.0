Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:35246 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab3KEHJ3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Nov 2013 02:09:29 -0500
From: Aldo Iljazi <mail@aldo.io>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] BTRFS: fixed two coding style issues
Date: Tue,  5 Nov 2013 09:09:19 +0200
Message-Id: <1383635359-4640-1-git-send-email-mail@aldo.io>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Line 26 and 31: Replaced spaces with tabs at the start of the lines.

Signed-off-by: Aldo Iljazi <mail@aldo.io>
---
 fs/btrfs/struct-funcs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/struct-funcs.c b/fs/btrfs/struct-funcs.c
index b976597..09528ec 100644
--- a/fs/btrfs/struct-funcs.c
+++ b/fs/btrfs/struct-funcs.c
@@ -23,12 +23,12 @@
 
 static inline u8 get_unaligned_le8(const void *p)
 {
-       return *(u8 *)p;
+	return *(u8 *)p;
 }
 
 static inline void put_unaligned_le8(u8 val, void *p)
 {
-       *(u8 *)p = val;
+	*(u8 *)p = val;
 }
 
 /*
-- 
1.8.3.2

