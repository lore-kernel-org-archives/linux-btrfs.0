From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/3] Btrfs: Don't return items more than user specified
Date: Mon, 13 Dec 2010 17:50:02 +0800
Message-ID: <4D05EC4A.8000908@cn.fujitsu.com>
References: <4D05EBC9.6020908@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Ian! D. Allen" <idallen@idallen.ca>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D05EBC9.6020908@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

We check if num_found >= sk->nr_items every time we find an
expected item, but num_found is not incremented, so we may
return items more than the user asked.

Also return -EINVAL if the user specified 0 nr_items.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 785f713..08174e2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1053,7 +1053,6 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 	int nritems;
 	int i;
 	int slot;
-	int found = 0;
 	int ret = 0;
 
 	leaf = path->nodes[0];
@@ -1100,8 +1099,8 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 					   item_off, item_len);
 			*sk_offset += item_len;
 		}
-		found++;
 
+		(*num_found)++;
 		if (*num_found >= sk->nr_items)
 			break;
 	}
@@ -1119,7 +1118,6 @@ advance_key:
 	} else
 		ret = 1;
 overflow:
-	*num_found += found;
 	return ret;
 }
 
@@ -1136,6 +1134,9 @@ static noinline int search_ioctl(struct inode *inode,
 	int num_found = 0;
 	unsigned long sk_offset = 0;
 
+	if (sk->nr_items == 0)
+		return -EINVAL;
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-- 
1.6.3
