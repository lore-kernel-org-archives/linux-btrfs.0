Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9691C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 19:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAB8E206BB
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 19:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546977096;
	bh=PRNJESv/qdBHvEf/RP/02Ds0tgIaMVCmERse6rHOygw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=NM37ymm0QvOyeQMVlnUwNfV/5UEfFdSIxYCiBssB9D6MmY1Xa6Ws+SfDQrf7AaGVf
	 eKKH0EkiH7c+xPfVPN9LtMXux50bQZp3RvU1oRP3AJzqrgkrbf2sQutJHWPfzrvqRj
	 3twBtpt/NJKexKkYZkE5IBsn/uP3xGJ78fVHYIAE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732796AbfAHTv0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 14:51:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:39482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731077AbfAHTbZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 14:31:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC6192070B;
        Tue,  8 Jan 2019 19:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546975884;
        bh=PRNJESv/qdBHvEf/RP/02Ds0tgIaMVCmERse6rHOygw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWXCOcmJsvvvlYohucJeLqz8OHlpcKFNxflKqGAgPTerj6ptLCYB37C78fqE8UEaZ
         ql3K6LMhysmeDMCvro5wB7f/OI475YzkKtL7VKIn3hXbfQMDeQxDAjNYfWsg61WzgW
         eCVbbPMkzJY/iJNK0eM2c7IyY37BLs1WgfpqLRaM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 61/97] btrfs: improve error handling of btrfs_add_link
Date:   Tue,  8 Jan 2019 14:29:10 -0500
Message-Id: <20190108192949.122407-61-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190108192949.122407-1-sashal@kernel.org>
References: <20190108192949.122407-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Johannes Thumshirn <jthumshirn@suse.de>

[ Upstream commit 1690dd41e0cb1dade80850ed8a3eb0121b96d22f ]

In the error handling block, err holds the return value of either
btrfs_del_root_ref() or btrfs_del_inode_ref() but it hasn't been checked
since it's introduction with commit fe66a05a0679 (Btrfs: improve error
handling for btrfs_insert_dir_item callers) in 2012.

If the error handling in the error handling fails, there's not much left
to do and the abort either happened earlier in the callees or is
necessary here.

So if one of btrfs_del_root_ref() or btrfs_del_inode_ref() failed, abort
the transaction, but still return the original code of the failure
stored in 'ret' as this will be reported to the user.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7158b5b77c9d..1c13b21ea13e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6427,14 +6427,19 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 		err = btrfs_del_root_ref(trans, key.objectid,
 					 root->root_key.objectid, parent_ino,
 					 &local_index, name, name_len);
-
+		if (err)
+			btrfs_abort_transaction(trans, err);
 	} else if (add_backref) {
 		u64 local_index;
 		int err;
 
 		err = btrfs_del_inode_ref(trans, root, name, name_len,
 					  ino, parent_ino, &local_index);
+		if (err)
+			btrfs_abort_transaction(trans, err);
 	}
+
+	/* Return the original error code */
 	return ret;
 }
 
-- 
2.19.1

