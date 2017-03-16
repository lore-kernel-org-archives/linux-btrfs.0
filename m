Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13989 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750885AbdCPDSp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Mar 2017 23:18:45 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 1/2] btrfs-progs: kerncompat: Fix re-definition of __bitwise
Date: Thu, 16 Mar 2017 11:18:30 +0800
Message-ID: <20170316031831.28006-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In latest linux api headers, __bitwise is already defined in
/usr/include/linux/types.h.

So kerncompat.h will re-define __bitwise, and cause gcc warning.

Fix it by checking if __bitwise is already define.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
The patch is based on devel branch with the following head:
commit 64abe9f619b614e589339046b6c45dfb8fa8e2a9
Author: David Sterba <dsterba@suse.com>
Date:   Wed Mar 15 12:28:16 2017 +0100

    btrfs-progs: tests: misc/019, use fssum
---
 kerncompat.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kerncompat.h b/kerncompat.h
index 958bea43..fa96715f 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -317,11 +317,13 @@ static inline void assert_trace(const char *assertion, const char *filename,
 #define container_of(ptr, type, member) ({                      \
         const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
 	        (type *)( (char *)__mptr - offsetof(type,member) );})
+#ifndef __bitwise
 #ifdef __CHECKER__
 #define __bitwise __bitwise__
 #else
 #define __bitwise
-#endif
+#endif /* __CHECKER__ */
+#endif	/* __bitwise */
 
 /* Alignment check */
 #define IS_ALIGNED(x, a)                (((x) & ((typeof(x))(a) - 1)) == 0)
-- 
2.12.0



