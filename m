From: "yanhai zhu" <zhu.yanhai@gmail.com>
Subject: [PATCH] The length of memset in btrfs_file_write is wrong
Date: Mon, 5 Jan 2009 11:21:20 +0800
Message-ID: <977a2be20901041921l311e7333p68525623fcec496@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
  The length of memset in btrfs_file_write is wrong.

--

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 5070810..e67f8d4 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1094,7 +1094,7 @@ static ssize_t btrfs_file_write(struct file
*file, const char __user *buf,
 					PAGE_CACHE_SHIFT;

 		WARN_ON(num_pages > nrptrs);
-		memset(pages, 0, sizeof(pages));
+		memset(pages, 0, sizeof(struct page *)*nrptrs);

 		ret = btrfs_check_free_space(root, write_bytes, 0);
 		if (ret)

-- 
Regards,
Zhu Yanhai
