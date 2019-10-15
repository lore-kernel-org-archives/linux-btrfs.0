Return-Path: <SRS0=E4Z9=YI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8003AECE58E
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Oct 2019 09:54:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 528F82089C
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Oct 2019 09:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571133285;
	bh=1BYQWQSaTL7RO3sMheEQ030qwfbqK0b147n0SbY/vlk=;
	h=From:To:Subject:Date:List-ID:From;
	b=0WrZAmqIOp8tzqQ6demggDf2Wt8Ix8DK2nKDGYcKh8J66T6CbezzEBOBC7vbsBl7p
	 x6yu+e7z6ycaaiKgoyTPcOS3H5lL0IQfkf7TWgec2jiigWZ7pHBD+3EPeUfhHNgmGF
	 c3pmfd3zKV475U1Rg5Aaya7TiAhqzz7lwoioqjuE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbfJOJyo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 05:54:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727080AbfJOJyo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Oct 2019 05:54:44 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5722720659
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Oct 2019 09:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571133283;
        bh=1BYQWQSaTL7RO3sMheEQ030qwfbqK0b147n0SbY/vlk=;
        h=From:To:Subject:Date:From;
        b=QFaAakGuv74SMVo2D9Dqq3DAnCesHiuKm5m5IZJrD5jeU4Zv+N54EPdWlJ90+VDwJ
         GBZz6OdvQ+BgiCyCprpQYyz3enuv3ezU8P0dZim4A4UsVzEaZPA2a1jPqKioMwUiLv
         QhAZLa5RAQ6UtdYzM9uFXKMQijgVxsndDEcn884A=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix qgroup double free after failure to reserve metadata for delalloc
Date:   Tue, 15 Oct 2019 10:54:39 +0100
Message-Id: <20191015095439.6511-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

If we fail to reserve metadata for delalloc operations we end up releasing
the previously reserved qgroup amount twice, once explicitly under the
'out_qgroup' label by calling btrfs_qgroup_free_meta_prealloc() and once
again, under label 'out_fail', by calling btrfs_inode_rsv_release() with a
value of 'true' for its 'qgroup_free' argument, which results in
btrfs_qgroup_free_meta_prealloc() being called again, so we end up having
a double free.

Also if we fail to reserve the necessary qgroup amount, we jump to the
label 'out_fail', which calls btrfs_inode_rsv_release() and that in turns
calls btrfs_qgroup_free_meta_prealloc(), even though we weren't able to
reserve any qgroup amount. So we freed some amount we never reserved.

So fix this by removing the call to btrfs_inode_rsv_release() in the
failure path, since it's not necessary at all as we haven't changed the
inode's block reserve in any way at this point.

Fixes: c8eaeac7b73434 ("btrfs: reserve delalloc metadata differently")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/delalloc-space.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index d949d7d2abed..fe68d0e078bd 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -381,7 +381,6 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 out_qgroup:
 	btrfs_qgroup_free_meta_prealloc(root, qgroup_reserve);
 out_fail:
-	btrfs_inode_rsv_release(inode, true);
 	if (delalloc_lock)
 		mutex_unlock(&inode->delalloc_mutex);
 	return ret;
-- 
2.11.0

