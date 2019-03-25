Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B3BC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 13:03:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA74B20830
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 13:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731222AbfCYNDX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 09:03:23 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:38333 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731076AbfCYNDW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 09:03:22 -0400
Received: from wuerfel.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MMGVE-1hRapZ3ztO-00JKql; Mon, 25 Mar 2019 14:03:00 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Qu Wenruo <wqu@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Liu Bo <bo.liu@linux.alibaba.com>,
        Filipe Manana <fdmanana@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Anand Jain <Anand.Jain@oracle.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: use BUG() instead of BUG_ON(1)
Date:   Mon, 25 Mar 2019 14:02:25 +0100
Message-Id: <20190325130256.1437810-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:WqqCRr9aq0/fLvIfqpd28fO+ZL8fbeXMaYJ9mlmB6vGx3b7d52g
 Mrjh0HviXccZpcSBkqiCFR2I4XUqKw67MI9W3ERfs8+LjSPRXaBDRL6ltvjLkAq5nDpmZei
 uyCz7Q3P2IJE+hEG76WUx8rWEV2DLmYF5KqMaBKMYaBu6MuW/lZIMgxNBP/0jqXvPJ1AVWD
 NaV9rNUulQjkLPc60OqTw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:98ogSmodF9g=:wSV1b4N3opQzNtjzrfAO+P
 LuKJWRgwm7hVqKDQIxAGaFQUIxT+7DKH0/dyWQpOBt3CQntyIl19uCp8ZhPSToiqIwrQ5SnE/
 E8emxS3opGD7E11lEg3+OzS2RXlagfwFPf0jq0iCsSq+3loe7Roj62QxvRtW0Gv6M3vPFOtk7
 q8c+ULmmejsXw2y2NPGuiZIPQowmwfllOk0fuYGZboToNFC4rgge3ZoiM0S5fm8XoOFoDvEvF
 UEFLGi7T5DnCpnR89f9z3c8dyX6qIASgpyU7UtQu5zuOvEpEZDbCn90LsKFS0jKZN/2mBZ1WT
 uELH/y9YODouaeSPOrIafYqdZaYZepsgrXV+x2MKT71mEq5IuVZPCHAvcGVgX5qCNiy5ZzZQt
 R28x+Z5v+JyGO/k3yHkmg0NlR0kiduzOPHBzkO8hZKMMJFabAxF+crimMqWUWnv+LItubMje5
 p8/L8GqzDv3HioHe28MC7NTxZ4Rt7PPOcjTPQhxK8i7Tn3+GcAybUkW0QVA1WZfZYPhfnOFLI
 Mn+My4UeUFOveeY0B7htLaaKOLV3AHG/akt0A6wDL23ZY5RtDxuo3P9+CoxuLbjJlw8KRMlKh
 bb8ZGg4Z4c8g9s/sPdnRIyY0ljRNrRR9tdORyDOw1cqgG5/kmhdchUVBLl79/OCnDz0CQWbaP
 OQPF52pKk7FQ5x//fl3Vp0ozIXBgeXxrFa1MALxRwmoAiptaXMUkTjRunR8PJfX4t6qng9RzG
 ZOsTFGyjev1ZMhQnd+BCFu74LnaZQEmRTkF+vQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

BUG_ON(1) leads to bogus warnings from clang when
CONFIG_PROFILE_ANNOTATED_BRANCHES is set:

fs/btrfs/volumes.c:5041:3: error: variable 'max_chunk_size' is used uninitialized whenever 'if' condition is false
      [-Werror,-Wsometimes-uninitialized]
                BUG_ON(1);
                ^~~~~~~~~
include/asm-generic/bug.h:61:36: note: expanded from macro 'BUG_ON'
 #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
                                   ^~~~~~~~~~~~~~~~~~~
include/linux/compiler.h:48:23: note: expanded from macro 'unlikely'
 #  define unlikely(x)   (__branch_check__(x, 0, __builtin_constant_p(x)))
                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
fs/btrfs/volumes.c:5046:9: note: uninitialized use occurs here
                             max_chunk_size);
                             ^~~~~~~~~~~~~~
include/linux/kernel.h:860:36: note: expanded from macro 'min'
 #define min(x, y)       __careful_cmp(x, y, <)
                                         ^
include/linux/kernel.h:853:17: note: expanded from macro '__careful_cmp'
                __cmp_once(x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y), op))
                              ^
include/linux/kernel.h:847:25: note: expanded from macro '__cmp_once'
                typeof(y) unique_y = (y);               \
                                      ^
fs/btrfs/volumes.c:5041:3: note: remove the 'if' if its condition is always true
                BUG_ON(1);
                ^
include/asm-generic/bug.h:61:32: note: expanded from macro 'BUG_ON'
 #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
                               ^
fs/btrfs/volumes.c:4993:20: note: initialize the variable 'max_chunk_size' to silence this warning
        u64 max_chunk_size;
                          ^
                           = 0

Change it to BUG() so clang can see that this code path can never
continue.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/btrfs/backref.c   | 4 ++--
 fs/btrfs/ctree.c     | 4 ++--
 fs/btrfs/extent_io.c | 8 ++++----
 fs/btrfs/file.c      | 2 +-
 fs/btrfs/inode.c     | 2 +-
 fs/btrfs/root-tree.c | 2 +-
 fs/btrfs/volumes.c   | 2 +-
 7 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 11459fe84a29..2602072ed906 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -791,7 +791,7 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 			count = node->ref_mod * -1;
 			break;
 		default:
-			BUG_ON(1);
+			BUG();
 		}
 		*total_refs += count;
 		switch (node->type) {
@@ -1747,7 +1747,7 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
 		else if (flags & BTRFS_EXTENT_FLAG_DATA)
 			*flags_ret = BTRFS_EXTENT_FLAG_DATA;
 		else
-			BUG_ON(1);
+			BUG();
 		return 0;
 	}
 
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 324df36d28bf..75c69829d975 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4674,7 +4674,7 @@ void btrfs_extend_item(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 		btrfs_print_leaf(leaf);
 		btrfs_crit(fs_info, "slot %d too large, nritems %d",
 			   slot, nritems);
-		BUG_ON(1);
+		BUG();
 	}
 
 	/*
@@ -4754,7 +4754,7 @@ void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 			btrfs_print_leaf(leaf);
 			btrfs_crit(fs_info, "slot %d old_data %d data_end %d",
 				   slot, old_data, data_end);
-			BUG_ON(1);
+			BUG();
 		}
 		/*
 		 * item0..itemN ... dataN.offset..dataN.size .. data0.size
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ca8b8e785cf3..610a98857e22 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5746,13 +5746,13 @@ void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 		btrfs_err(fs_info,
 			"memmove bogus src_offset %lu move len %lu dst len %lu",
 			 src_offset, len, dst->len);
-		BUG_ON(1);
+		BUG();
 	}
 	if (dst_offset + len > dst->len) {
 		btrfs_err(fs_info,
 			"memmove bogus dst_offset %lu move len %lu dst len %lu",
 			 dst_offset, len, dst->len);
-		BUG_ON(1);
+		BUG();
 	}
 
 	while (len > 0) {
@@ -5793,13 +5793,13 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 		btrfs_err(fs_info,
 			  "memmove bogus src_offset %lu move len %lu len %lu",
 			  src_offset, len, dst->len);
-		BUG_ON(1);
+		BUG();
 	}
 	if (dst_offset + len > dst->len) {
 		btrfs_err(fs_info,
 			  "memmove bogus dst_offset %lu move len %lu len %lu",
 			  dst_offset, len, dst->len);
-		BUG_ON(1);
+		BUG();
 	}
 	if (dst_offset < src_offset) {
 		memcpy_extent_buffer(dst, dst_offset, src_offset, len);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 34fe8a58b0e9..f28aed471693 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1025,7 +1025,7 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
 			continue;
 		}
 
-		BUG_ON(1);
+		BUG();
 	}
 
 	if (!ret && del_nr > 0) {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 82fdda8ff5ab..98bc66d34e6c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1451,7 +1451,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 			extent_end = ALIGN(extent_end,
 					   fs_info->sectorsize);
 		} else {
-			BUG_ON(1);
+			BUG();
 		}
 out_check:
 		if (extent_end <= start) {
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 893d12fbfda0..552efc88a016 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -141,7 +141,7 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 		btrfs_print_leaf(path->nodes[0]);
 		btrfs_crit(fs_info, "unable to update root key %llu %u %llu",
 			   key->objectid, key->type, key->offset);
-		BUG_ON(1);
+		BUG();
 	}
 
 	l = path->nodes[0];
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9024eee889b9..95223fd9f9d0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5038,7 +5038,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	} else {
 		btrfs_err(info, "invalid chunk type 0x%llx requested",
 		       type);
-		BUG_ON(1);
+		BUG();
 	}
 
 	/* We don't want a chunk larger than 10% of writable space */
-- 
2.20.0

