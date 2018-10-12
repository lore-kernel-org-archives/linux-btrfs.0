Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF9AC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 07:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D732B2087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 07:42:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D732B2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbeJLPNj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 11:13:39 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:30593 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726761AbeJLPNj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 11:13:39 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46021602"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 12 Oct 2018 15:42:27 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 98DE24B6ED70
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 15:42:29 +0800 (CST)
Received: from localhost.localdomain (10.167.226.155) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 id 14.3.408.0; Fri, 12 Oct 2018 15:42:28 +0800
From:   Su Yanjun <suyj.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     Su Yanjun <suyj.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: fix compile warning when using gcc8 to compile btrfs-progs
Date:   Fri, 12 Oct 2018 15:41:53 +0800
Message-ID: <20181012074153.3844-1-suyj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 98DE24B6ED70.ABFAF
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suyj.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When using gcc8 to compile btrfs-progs, it complains as below:

ctree.c: In function 'btrfs_search_slot_for_read':
    ctree.c:1249:45: warning: passing argument 3 of 'btrfs_search_slot'
    discards 'const' qualifier from pointer target type
    [-Wdiscarded-qualifiers]
             ret = btrfs_search_slot(NULL, root, key, p, 0, 0);

Change btrfs_search_slot prototype with 'const' qualifier for argument 3.
Also fix similar problems as above change.

Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
---
 ctree.c | 19 ++++++++++---------
 ctree.h | 10 +++++-----
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/ctree.c b/ctree.c
index aa1568620205..c8dd73cf2ce2 100644
--- a/ctree.c
+++ b/ctree.c
@@ -27,7 +27,7 @@
 static int split_node(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_path *path, int level);
 static int split_leaf(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, struct btrfs_key *ins_key,
+		      *root, const struct btrfs_key *ins_key,
 		      struct btrfs_path *path, int data_size, int extend);
 static int push_node_left(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, struct extent_buffer *dst,
@@ -389,7 +389,7 @@ int btrfs_cow_block(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int btrfs_comp_cpu_keys(struct btrfs_key *k1, struct btrfs_key *k2)
+int btrfs_comp_cpu_keys(const struct btrfs_key *k1, const struct btrfs_key *k2)
 {
 	if (k1->objectid > k2->objectid)
 		return 1;
@@ -409,7 +409,8 @@ int btrfs_comp_cpu_keys(struct btrfs_key *k1, struct btrfs_key *k2)
 /*
  * compare two keys in a memcmp fashion
  */
-static int btrfs_comp_keys(struct btrfs_disk_key *disk, struct btrfs_key *k2)
+static int btrfs_comp_keys(struct btrfs_disk_key *disk,
+		const struct btrfs_key *k2)
 {
 	struct btrfs_key k1;
 
@@ -602,7 +603,7 @@ static int noinline check_block(struct btrfs_root *root,
  * slot may point to max if the key is bigger than all of the keys
  */
 static int generic_bin_search(struct extent_buffer *eb, unsigned long p,
-			      int item_size, struct btrfs_key *key,
+			      int item_size, const struct btrfs_key *key,
 			      int max, int *slot)
 {
 	int low = 0;
@@ -636,7 +637,7 @@ static int generic_bin_search(struct extent_buffer *eb, unsigned long p,
  * simple bin_search frontend that does the right thing for
  * leaves vs nodes
  */
-static int bin_search(struct extent_buffer *eb, struct btrfs_key *key,
+static int bin_search(struct extent_buffer *eb, const struct btrfs_key *key,
 		      int level, int *slot)
 {
 	if (level == 0)
@@ -1129,9 +1130,9 @@ out:
  * tree.  if ins_len < 0, nodes will be merged as we walk down the tree (if
  * possible)
  */
-int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, struct btrfs_key *key, struct btrfs_path *p, int
-		      ins_len, int cow)
+int btrfs_search_slot(struct btrfs_trans_handle *trans,
+		struct btrfs_root *root, const struct btrfs_key *key,
+		struct btrfs_path *p, int ins_len, int cow)
 {
 	struct extent_buffer *b;
 	int slot;
@@ -2150,7 +2151,7 @@ static noinline int copy_for_split(struct btrfs_trans_handle *trans,
  */
 static noinline int split_leaf(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
-			       struct btrfs_key *ins_key,
+			       const struct btrfs_key *ins_key,
 			       struct btrfs_path *path, int data_size,
 			       int extend)
 {
diff --git a/ctree.h b/ctree.h
index 2a2437070ef9..cf0efae9c185 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1973,7 +1973,7 @@ static inline void btrfs_disk_key_to_cpu(struct btrfs_key *cpu,
 }
 
 static inline void btrfs_cpu_key_to_disk(struct btrfs_disk_key *disk,
-					 struct btrfs_key *cpu)
+					 const struct btrfs_key *cpu)
 {
 	disk->offset = cpu_to_le64(cpu->offset);
 	disk->type = cpu->type;
@@ -2552,7 +2552,7 @@ u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 u64 hash_extent_data_ref(u64 root_objectid, u64 owner, u64 offset);
 
 /* ctree.c */
-int btrfs_comp_cpu_keys(struct btrfs_key *k1, struct btrfs_key *k2);
+int btrfs_comp_cpu_keys(const struct btrfs_key *k1, const struct btrfs_key *k2);
 int btrfs_del_ptr(struct btrfs_root *root, struct btrfs_path *path,
 		int level, int slot);
 enum btrfs_tree_block_status
@@ -2595,9 +2595,9 @@ int btrfs_split_item(struct btrfs_trans_handle *trans,
 		     struct btrfs_path *path,
 		     struct btrfs_key *new_key,
 		     unsigned long split_offset);
-int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, struct btrfs_key *key, struct btrfs_path *p, int
-		      ins_len, int cow);
+int btrfs_search_slot(struct btrfs_trans_handle *trans,
+		struct btrfs_root *root, const struct btrfs_key *key,
+		struct btrfs_path *p, int ins_len, int cow);
 int btrfs_search_slot_for_read(struct btrfs_root *root,
                                const struct btrfs_key *key,
                                struct btrfs_path *p, int find_higher,
-- 
2.19.1



