Return-Path: <SRS0=tkEE=RY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D01C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 09:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8575218A2
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 09:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfCUJ1G (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Mar 2019 05:27:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:47724 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727903AbfCUJ1G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Mar 2019 05:27:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5EC54AE28
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2019 09:27:05 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Defer setting new inode mode until after do_set_acl succeeds
Date:   Thu, 21 Mar 2019 11:27:03 +0200
Message-Id: <20190321092703.8136-1-nborisov@suse.com>
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
 fs/btrfs/acl.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index b722866e1442..a0cfd2049ea5 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -99,7 +99,6 @@ static int do_set_acl(struct btrfs_trans_handle *trans, struct inode *inode,
 	}
 
 	ret = btrfs_setxattr(trans, inode, name, value, size, 0);
-
 out:
 	kfree(value);
 
@@ -112,12 +111,12 @@ static int do_set_acl(struct btrfs_trans_handle *trans, struct inode *inode,
 int btrfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
 	int ret;
-	umode_t old_mode = inode->i_mode;
+	umode_t mode;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
 	if (type == ACL_TYPE_ACCESS && acl) {
-		ret = posix_acl_update_mode(inode, &inode->i_mode, &acl);
+		ret = posix_acl_update_mode(inode, &mode, &acl);
 		if (ret)
 			return ret;
 	}
@@ -127,9 +126,8 @@ int btrfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 		return PTR_ERR(trans);
 
 	ret = do_set_acl(trans, inode, acl, type);
-	if (ret) {
-		inode->i_mode = old_mode;
-	} else {
+	if (!ret) {
+		inode->i_mode = mode;
 		inode_inc_iversion(inode);
 		inode->i_ctime = current_time(inode);
 		set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
-- 
2.17.1

