From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 01/16] Btrfs: copy string correctly in INO_LOOKUP ioctl
Date: Thu, 14 Jul 2011 11:16:00 +0800
Message-ID: <4E1E5F70.4030504@cn.fujitsu.com>
References: <4E1E5F59.5030208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1E5F59.5030208@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Memory areas [ptr, ptr+total_len] and [name, name+total_len]
may overlap, so it's wrong to use memcpy().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a3c4751..08a4580 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1755,11 +1755,10 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
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
-- 
1.7.3.1
