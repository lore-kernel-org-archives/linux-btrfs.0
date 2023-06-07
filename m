Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 424E2C7EE25
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Jun 2023 19:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjFGTYq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Jun 2023 15:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbjFGTYo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2023 15:24:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA241FD5
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Jun 2023 12:24:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EDFD639BC
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Jun 2023 19:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557AFC433EF
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Jun 2023 19:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686165882;
        bh=nvwOE9cHo/ym8MpkZ21ZxYslS3u6sH3E00tXCkh9KY8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=tKi92EyC9+s8lS2pM72RkNs56Vo8nssWVGr3C84Fw7wPswfOYhhGcpHE3GKLzKe4d
         YXq/76ecmDWqQFbrXBAGIQlu9z62bpVKTTcd2ZwKXdmMnns2onThEc+qIuhMaUOql3
         nACKRLCvxplSqM/IH5D+jtdQSMqMrc+6ZJIhi10ALnPAqpJrJ7PTkerizEkWO3NjAY
         VI+d9Mv2BgHVstR/6V5Xf+VjceMGpF9+Y+Tix8OVc9gNaJotCBNDZAuoKInkRynXWK
         3RFT0kcJYm0sthR1zKN4bL7fFsdireLfAJV0ybgUZuAMslBBZBbrIA9Mug8pmHkInN
         9rmWiYkAuArUw==
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 02/13] btrfs: fix extent buffer leak after failure tree mod log failure at split_node()
Date:   Wed,  7 Jun 2023 20:24:26 +0100
Message-Id: <33c0bac2c25c330f773ba765c98efa3992cdc166.1686164803.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1686164789.git.fdmanana@suse.com>
References: <cover.1686164789.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

At split_node(), if we fail to log the tree mod log copy operation, we
return without unlocking the split extent buffer we just allocated and
without decrementing the reference we own on it. Fix this by unlocking
it and decrementing the ref count before returning.

Fixes: 5de865eebb83 ("Btrfs: fix tree mod logging")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 7f7f13965fe9..8496535828de 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3053,6 +3053,8 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_tree_mod_log_eb_copy(split, c, 0, mid, c_nritems - mid);
 	if (ret) {
+		btrfs_tree_unlock(split);
+		free_extent_buffer(split);
 		btrfs_abort_transaction(trans, ret);
 		return ret;
 	}
-- 
2.34.1

