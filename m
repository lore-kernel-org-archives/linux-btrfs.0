From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 1/3] Btrfs: Really return keys within specified range
Date: Mon, 13 Dec 2010 17:47:53 +0800
Message-ID: <4D05EBC9.6020908@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Ian! D. Allen" <idallen@idallen.ca>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The keys returned by tree search ioctl should be restricted to:

	key.objectid = [min_objectid, max_objectid] &&
	key.offset   = [min_offset, max_offset] &&
	key.type     = [min_type, max_type]

But actually it returns those keys:

	[(min_objectid, min_type, min_offset),
		(max_objectid, max_type, max_offset)].

And the bug can result in missing subvolumes in the output of
"btrfs subvolume list"

Reported-by: Ian! D. Allen <idallen@idallen.ca>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   20 ++++----------------
 1 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f1c9bb4..785f713 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1028,23 +1028,11 @@ out:
 static noinline int key_in_sk(struct btrfs_key *key,
 			      struct btrfs_ioctl_search_key *sk)
 {
-	struct btrfs_key test;
-	int ret;
-
-	test.objectid = sk->min_objectid;
-	test.type = sk->min_type;
-	test.offset = sk->min_offset;
-
-	ret = btrfs_comp_cpu_keys(key, &test);
-	if (ret < 0)
+	if (key->type < sk->min_type || key->type > sk->max_type)
 		return 0;
-
-	test.objectid = sk->max_objectid;
-	test.type = sk->max_type;
-	test.offset = sk->max_offset;
-
-	ret = btrfs_comp_cpu_keys(key, &test);
-	if (ret > 0)
+	if (key->offset < sk->min_offset || key->offset > sk->max_offset)
+		return 0;
+	if (key->objectid < sk->min_objectid || key->objectid > sk->max_objectid)
 		return 0;
 	return 1;
 }
-- 
1.6.3

