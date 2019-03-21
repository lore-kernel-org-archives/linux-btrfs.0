Return-Path: <SRS0=tkEE=RY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A2EC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 15:57:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCC4F21874
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 15:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbfCUP5J (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:57:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:36690 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728057AbfCUP5J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Mar 2019 11:57:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BBFFCACEC
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2019 15:57:07 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] btrfs: Defer setting new inode mode until after do_set_acl succeeds
Date:   Thu, 21 Mar 2019 17:57:06 +0200
Message-Id: <20190321155706.16686-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Currently a reference to inode->i_mode is passed directly to
posix_acl_update_mode when setting an ACL which results in the inode's
mode always being changed. In case of errors (e.g. in do_set_acl or
even starting a transaction) the old mode needs to be re-assigned to
->i_mode. This mode recovery is done only in case do_set_acl fails,
which leads to buggy behavior in case btrfs_start_transaction fails.

Fix it by simply setting the new mode to a temporary variable which is
assigned to inode->i_mode's only when do_set_acl succeeds. This covers
both failure cases explained above.

Fixes: db0f220e98eb ("btrfs: start transaction in btrfs_set_acl")
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

Changes since v1:
 * Eliminated unrealted newline change (Johannes)
 * Fixed logic of when i_mode is set, v1 was causing an uninitialised mode
 to be assigned to inode->i_mode resulting in fs consistency problems. Fix this
 by introducing a variable which is set to true when the i_mode needs to be 
 changed. I know this variable could be eliminated by simply initialising 
 mode = inode->i_mode and always assigning it in the if (!ret) branch but I 
 find this somewhat subtle and rather be explicit with the boolean variable. 

 fs/btrfs/acl.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index b722866e1442..ac12a4530540 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -112,14 +112,16 @@ static int do_set_acl(struct btrfs_trans_handle *trans, struct inode *inode,
 int btrfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
 	int ret;
-	umode_t old_mode = inode->i_mode;
+	umode_t mode;
+	bool change_mode = false;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
 	if (type == ACL_TYPE_ACCESS && acl) {
-		ret = posix_acl_update_mode(inode, &inode->i_mode, &acl);
+		ret = posix_acl_update_mode(inode, &mode, &acl);
 		if (ret)
 			return ret;
+		change_mode = true;
 	}
 
 	trans = btrfs_start_transaction(root, 2);
@@ -127,9 +129,9 @@ int btrfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 		return PTR_ERR(trans);
 
 	ret = do_set_acl(trans, inode, acl, type);
-	if (ret) {
-		inode->i_mode = old_mode;
-	} else {
+	if (!ret) {
+		if (change_mode)
+			inode->i_mode = mode;
 		inode_inc_iversion(inode);
 		inode->i_ctime = current_time(inode);
 		set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
-- 
2.17.1

