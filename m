From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: copy string correctly in BTRFS_IOC_INO_LOOKUP ioctl
Date: Mon, 20 Jun 2011 13:53:37 +0800
Message-ID: <4DFEE061.1070604@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Memory areas [ptr, ptr+total_len] and [name, name+total_len]
may overlap, so it's wrong to use memcpy().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b793d11..76f52b3 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1753,11 +1753,10 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 		key.objectid = key.offset;
 		key.offset = (u64)-1;
 		dirid = key.objectid;
-
 	}
 	if (ptr < name)
 		goto out;
-	memcpy(name, ptr, total_len);
+	memmove(name, ptr, total_len);
 	name[total_len]='\0';
 	ret = 0;
 out:
-- 1.7.3.1 
