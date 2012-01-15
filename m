From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] SNAPPY: Add dual GPL/BSD license to snappy module
Date: Sun, 15 Jan 2012 14:49:14 -0800
Message-ID: <1326667754-13255-1-git-send-email-andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Andi Kleen <ak@linux.intel.com>
To: chris.mason@oracle.com
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Andi Kleen <ak@linux.intel.com>

To avoid complaints from the module loader.

I made it dual because the original compression code was BSD.

Reported-by: Chris Mason
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 lib/snappy.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/snappy.c b/lib/snappy.c
index 0b39e07..3848c6c 100644
--- a/lib/snappy.c
+++ b/lib/snappy.c
@@ -1298,3 +1298,5 @@ void snappy_free_env(struct snappy_env *env)
 	memset(env, 0, sizeof(struct snappy_env));
 }
 EXPORT_SYMBOL(snappy_free_env);
+
+MODULE_LICENSE("Dual BSD/GPL");
-- 
1.7.7.4
