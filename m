Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:60720 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505AbaHUVYc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 17:24:32 -0400
Received: from lenny.home.zabbo.net (lenny.home.zabbo.net [192.168.242.10])
	by tetsuo.zabbo.net (Postfix) with ESMTP id B8F407200521
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Aug 2014 14:24:31 -0700 (PDT)
From: Zach Brown <zab@zabbo.net>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: fix unaligned loads in receive
Date: Thu, 21 Aug 2014 14:24:04 -0700
Message-Id: <1408656244-17654-1-git-send-email-zab@zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user reported corruption after receiving subvolumes.  Turning up the
logging during the receive showed that the commands and string
attributes were being received correctly but the u64 attrbutes were
sometimes corrupted by having variable number of low order bytes
introduced.

It turned out they were on a platform that corrupts unaligned userspace
loads.  Loading the u64s from the unaligned pointers into the received
command stream with get_unaligned() fixed the problem.

Reported-By: Klaus Holler <kho@gmx.at>
Tested-By: Klaus Holler <kho@gmx.at>
Signed-off-by: Zach Brown <zab@zabbo.net>
---
 send-stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/send-stream.c b/send-stream.c
index 88e18e2..4f8dd83 100644
--- a/send-stream.c
+++ b/send-stream.c
@@ -204,7 +204,7 @@ out:
 		int __len; \
 		TLV_GET(s, attr, (void**)&__tmp, &__len); \
 		TLV_CHECK_LEN(sizeof(*__tmp), __len); \
-		*v = le##bits##_to_cpu(*__tmp); \
+		*v = get_unaligned_le##bits(__tmp); \
 	} while (0)
 
 #define TLV_GET_U8(s, attr, v) TLV_GET_INT(s, attr, 8, v)
-- 
1.9.3

