Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6DE3C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 05:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88D0721852
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 05:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfB0Ft7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 00:49:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:59896 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725933AbfB0Ft7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 00:49:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0F7E1ADD4
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2019 05:49:58 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: check: Fix false alert about uninitialized
Date:   Wed, 27 Feb 2019 13:49:52 +0800
Message-Id: <20190227054952.2811-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

GCC 8.2.1 will report the following error:

  check/main.c: In function 'try_repair_inode':
  check/main.c:2606:5: warning: 'ret' may be used uninitialized in this function [-Wmaybe-uninitialized]
    if (!ret) {
       ^
  check/main.c:2584:6: note: 'ret' was declared here
    int ret;
        ^~~

The offending code is in repair_mismatch_dir_hash():

	int ret;

	printf(
	"Deleting bad dir items with invalid hash for root %llu ino %llu\n",
		root->root_key.objectid, rec->ino);
	while (!list_empty(&rec->mismatch_dir_hash)) {
		/* do some repair */
	}
	if (!ret) { <<< Here
		/* do some fix */
	}

The truth is, to enter try_repair_inode(), we must have
I_ERR_MISMATCH_DIR_HASH bit set for rec->errors.

And just after we set I_ERR_MISMATCH_DIR_HASH, we call
add_mismatch_dir_hash() and handled its error correctly.

So it's impossible to to skip the while loop.

Fix it by initializing @ret to -EUCLEAN, so even we hit some impossible
case, repair_mismatch_dir_hash() won't falsely consider the mismatch
hash fixed.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/check/main.c b/check/main.c
index 951a23b1e26a..ea078e023d24 100644
--- a/check/main.c
+++ b/check/main.c
@@ -2581,7 +2581,7 @@ static int repair_mismatch_dir_hash(struct btrfs_trans_handle *trans,
 				    struct inode_record *rec)
 {
 	struct mismatch_dir_hash_record *hash;
-	int ret;
+	int ret = -EUCLEAN;
 
 	printf(
 	"Deleting bad dir items with invalid hash for root %llu ino %llu\n",
-- 
2.21.0

