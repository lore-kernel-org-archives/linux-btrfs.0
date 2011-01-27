From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 11/12] Btrfs: Fix memory leak in writepage fixup work
Date: Thu, 27 Jan 2011 16:45:50 +0800
Message-ID: <4D4130BE.8060502@cn.fujitsu.com>
References: <4D412FE6.7050101@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Miao Xie <miaox@cn.fujitsu.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D412FE6.7050101@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Miao Xie <miaox@cn.fujitsu.com>

fixup, which is allocated when starting page write to fix up the
extent without ORDERED bit set, should be freed after this work
is done.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5f91944..3a6edc4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1544,6 +1544,7 @@ out:
 out_page:
 	unlock_page(page);
 	page_cache_release(page);
+	kfree(fixup);
 }
 
 /*
-- 
1.6.3
