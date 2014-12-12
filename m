Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965571AbaLLK6U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 05:58:20 -0500
From: Karel Zak <kzak@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Karel Zak <kzak@redhat.com>
Subject: [PATCH] btrfs-progs: fix typedef
Date: Fri, 12 Dec 2014 11:58:04 +0100
Message-Id: <1418381884-6775-1-git-send-email-kzak@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Karel Zak <kzak@redhat.com>
---
 kerncompat.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kerncompat.h b/kerncompat.h
index 8afadc8..5c1cca9 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -123,7 +123,7 @@ typedef unsigned long long u64;
 typedef unsigned char u8;
 typedef unsigned short u16;
 typedef long long s64;
-typedef int s32
+typedef int s32;
 #endif
 
 
-- 
1.9.3

