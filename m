Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90C47C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 07:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67DAD214AF
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 07:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfCLHqG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 03:46:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:39762 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726218AbfCLHqF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 03:46:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BBAC6AF03;
        Tue, 12 Mar 2019 07:46:03 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Yoon Jungyeon <jungyeon@gatech.edu>
Subject: [PATCH] btrfs: Check the first key and level for cached extent buffer
Date:   Tue, 12 Mar 2019 15:45:58 +0800
Message-Id: <20190312074558.32393-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
When reading a file from a fuzzed image, kernel can panic like:
  BTRFS warning (device loop0): csum failed root 5 ino 270 off 0 csum 0x98f94189 expected csum 0x00000000 mirror 1
  assertion failed: !memcmp_extent_buffer(b, &disk_key, offsetof(struct btrfs_leaf, items[0].key), sizeof(disk_key)), file: fs/btrfs/ctree.c, line: 2544
  ------------[ cut here ]------------
  kernel BUG at fs/btrfs/ctree.h:3500!
  invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
  RIP: 0010:btrfs_search_slot.cold.24+0x61/0x63 [btrfs]
  Call Trace:
   btrfs_lookup_csum+0x52/0x150 [btrfs]
   __btrfs_lookup_bio_sums+0x209/0x640 [btrfs]
   btrfs_submit_bio_hook+0x103/0x170 [btrfs]
   submit_one_bio+0x59/0x80 [btrfs]
   extent_read_full_page+0x58/0x80 [btrfs]
   generic_file_read_iter+0x2f6/0x9d0
   __vfs_read+0x14d/0x1a0
   vfs_read+0x8d/0x140
   ksys_read+0x52/0xc0
   do_syscall_64+0x60/0x210
   entry_SYSCALL_64_after_hwframe+0x49/0xbe

[CAUSE]
The fuzzed image has a corrupted leaf whose first key doesn't match with its parent:
  checksum tree key (CSUM_TREE ROOT_ITEM 0)
  node 29741056 level 1 items 14 free 107 generation 19 owner CSUM_TREE
  fs uuid 3381d111-94a3-4ac7-8f39-611bbbdab7e6
  chunk uuid 9af1c3c7-2af5-488b-8553-530bd515f14c
  	...
          key (EXTENT_CSUM EXTENT_CSUM 79691776) block 29761536 gen 19

  leaf 29761536 items 1 free space 1726 generation 19 owner CSUM_TREE
  leaf 29761536 flags 0x1(WRITTEN) backref revision 1
  fs uuid 3381d111-94a3-4ac7-8f39-611bbbdab7e6
  chunk uuid 9af1c3c7-2af5-488b-8553-530bd515f14c
          item 0 key (EXTENT_CSUM EXTENT_CSUM 8798638964736) itemoff 1751 itemsize 2244
                  range start 8798638964736 end 8798641262592 length 2297856

For the first time tree read, it will not pass verify_level_key() check.
But the extent buffer will still be cached.

Also there is a pitfall in read_block_for_search(), where a cached
extent buffer will not be checked for its level and first key.

There are context where we read tree block without verifying its
first key, such as scrub.

So in that case, a corrupted leaf can sneak in and screw up the kernel.

[FIX]
Export verify_level_key() as btrfs_verify_level_key() and call it in
read_block_for_search() to fill the hole.

Please note, this will cause a lot of extra error message if we have a
bad tree block in any hot tree, but it's still much better to trigger
the final safe net in key_search_validate().

Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=202755
Link: https://bugzilla.kernel.org/show_bug.cgi?id=202757
Link: https://bugzilla.kernel.org/show_bug.cgi?id=202759
Link: https://bugzilla.kernel.org/show_bug.cgi?id=202761
Link: https://bugzilla.kernel.org/show_bug.cgi?id=202767
Link: https://bugzilla.kernel.org/show_bug.cgi?id=202769
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
There is one remaining report where I can't get any kernel message
before the VM completely lost reponse.
https://bugzilla.kernel.org/show_bug.cgi?id=202763
(out-of-bound access in end_bio_extent_readpage() when mounting and operating a crafted btrfs image)

And the above case can't be fixed by this patch. Still trying to get a
good idea of what's going wrong (AKA good kernel message).

There is also another report, which doesn't provide the fuzzed image.
https://bugzilla.kernel.org/show_bug.cgi?id=202765
(NULL pointer dereference when mounting a crafted btrfs image)
---
 fs/btrfs/ctree.c   | 10 ++++++++++
 fs/btrfs/disk-io.c | 10 +++++-----
 fs/btrfs/disk-io.h |  3 +++
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 5a6c39b44c84..37447a7c5b4d 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2401,6 +2401,16 @@ read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
 	if (tmp) {
 		/* first we do an atomic uptodate check */
 		if (btrfs_buffer_uptodate(tmp, gen, 1) > 0) {
+			/*
+			 * Do extra check for first_key, as it's possible the
+			 * eb is read from the context without first_key
+			 * requirement
+			 */
+			if (btrfs_verify_level_key(fs_info, tmp,
+					parent_level - 1, &first_key, gen)) {
+				free_extent_buffer(tmp);
+				return -EUCLEAN;
+			}
 			*eb_ret = tmp;
 			return 0;
 		}
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 298b34721bc0..e2a0cb362d28 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -423,9 +423,9 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
-static int verify_level_key(struct btrfs_fs_info *fs_info,
-			    struct extent_buffer *eb, int level,
-			    struct btrfs_key *first_key, u64 parent_transid)
+int btrfs_verify_level_key(struct btrfs_fs_info *fs_info,
+			   struct extent_buffer *eb, int level,
+			   struct btrfs_key *first_key, u64 parent_transid)
 {
 	int found_level;
 	struct btrfs_key found_key;
@@ -500,8 +500,8 @@ static int btree_read_extent_buffer_pages(struct btrfs_fs_info *fs_info,
 			if (verify_parent_transid(io_tree, eb,
 						   parent_transid, 0))
 				ret = -EIO;
-			else if (verify_level_key(fs_info, eb, level,
-						  first_key, parent_transid))
+			else if (btrfs_verify_level_key(fs_info, eb, level,
+						first_key, parent_transid))
 				ret = -EUCLEAN;
 			else
 				break;
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 987a64bc0c66..67a9fe2d29c7 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -39,6 +39,9 @@ static inline u64 btrfs_sb_offset(int mirror)
 struct btrfs_device;
 struct btrfs_fs_devices;
 
+int btrfs_verify_level_key(struct btrfs_fs_info *fs_info,
+			   struct extent_buffer *eb, int level,
+			   struct btrfs_key *first_key, u64 parent_transid);
 struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
 				      u64 parent_transid, int level,
 				      struct btrfs_key *first_key);
-- 
2.21.0

