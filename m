From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 2/2] Btrfs: fix uninitialized sync_pending
Date: Fri, 05 Aug 2011 17:32:37 +0800
Message-ID: <4E3BB8B5.2040108@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

sync_pending is uninitialized before it be used, fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3c5f2fc..918adf6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -142,7 +142,7 @@ static noinline int run_scheduled_bios(struct btrfs_device *device)
 	unsigned long limit;
 	unsigned long last_waited = 0;
 	int force_reg = 0;
-	int sync_pending;
+	int sync_pending = 0;
 	struct blk_plug plug;
 
 	/*
-- 
1.7.4
