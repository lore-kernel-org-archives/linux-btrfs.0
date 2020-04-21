Return-Path: <SRS0=Aqfq=6F=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 512B8C54FC9
	for <linux-btrfs@archiver.kernel.org>; Tue, 21 Apr 2020 10:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E1402064A
	for <linux-btrfs@archiver.kernel.org>; Tue, 21 Apr 2020 10:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587464736;
	bh=R9rOPjTHKjACZWwQa0YeTZnA/IV0bIMHrr6kTKd+Lzc=;
	h=From:To:Subject:Date:List-ID:From;
	b=VxT/JqniU37sBF2LyvEdNXkQj6BSGUkp/o/3uvAQ6zD8KQJ1a2e7aWBUVSLE7/8LV
	 sjh4JxRnIYny7vgWbX/LAU8aD+SePMJYzLRs+HrBxlmho2wFFOuXACF69b8g7AtMIv
	 avdGdNXXFmsQ53Ukx7Vq2Fmobvl7IyXocZulXE0U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgDUKZf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 06:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbgDUKZe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Apr 2020 06:25:34 -0400
Received: from debian6.Home (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B806C2064A
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Apr 2020 10:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587464734;
        bh=R9rOPjTHKjACZWwQa0YeTZnA/IV0bIMHrr6kTKd+Lzc=;
        h=From:To:Subject:Date:From;
        b=0x7JJ3DMPQM8daD8Ln7DqUfaIgY9rGJNKZSd9sQ39oc6nZBug2IfO/SxKiwKO45QF
         6mDQFbS3D2ZefnVMD+/p/h7rqfxJrS/pmgBV8GaLfWbCMwl+BBYxr5Z1D79bdKZhWz
         VRPV/kuP3jOWiciGbKk8Ky/bexQZck0qx9YSS3pw=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove useless check for copy_items() return value
Date:   Tue, 21 Apr 2020 11:25:31 +0100
Message-Id: <20200421102531.14736-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

At btrfs_log_prealloc_extents() we are checking if copy_items() returns a
value greater than 0. That used to happen in the past to signal the caller
that the path given to it was released and reused for other searches, but
as of commit 0e56315ca147b3 ("Btrfs: fix missing hole after hole punching
and fsync when using NO_HOLES"), the copy_items() function does not have
that behaviour anymore and always returns 0 or a negative value. So just
remove that check at btrfs_log_prealloc_extents(), which the previously
mentioned commit forgot to remove.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 9761e6d538fb..0352ba62ec2b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4336,12 +4336,9 @@ static int btrfs_log_prealloc_extents(struct btrfs_trans_handle *trans,
 			}
 		}
 	}
-	if (ins_nr > 0) {
+	if (ins_nr > 0)
 		ret = copy_items(trans, inode, dst_path, path,
 				 start_slot, ins_nr, 1, 0);
-		if (ret > 0)
-			ret = 0;
-	}
 out:
 	btrfs_release_path(path);
 	btrfs_free_path(dst_path);
-- 
2.11.0

