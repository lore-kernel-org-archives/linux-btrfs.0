From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 13/16] Btrfs: remove unused members from struct extent_state
Date: Thu, 14 Jul 2011 11:18:52 +0800
Message-ID: <4E1E601C.4080405@cn.fujitsu.com>
References: <4E1E5F59.5030208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1E5F59.5030208@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

These members are not used at all.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/extent_io.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index a11a92e..d04ca37 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -108,8 +108,6 @@ struct extent_state {
 	wait_queue_head_t wq;
 	atomic_t refs;
 	unsigned long state;
-	u64 split_start;
-	u64 split_end;
 
 	/* for use by the FS */
 	u64 private;
-- 
1.7.3.1
