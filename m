Return-Path: <SRS0=R6Ud=C3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ADDEC43463
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Sep 2020 02:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68C6F21973
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Sep 2020 02:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600396249;
	bh=VCfax6uABULRNQtKg4f0N10ZLTpviLMuoiwPAsLRLh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=1iDnvXEQk1aaevBPpLD51c8bxTM4y7cI0THvQk+VQ2a8tAvnIcPzOZrApnrJnJOzL
	 hOfP/DUXiLz4IJs2tIpu/frBiQjPk9RisOHeQNbyeV3G1rSdvps9WY96uL+/5VrxOJ
	 iaVX6J7pH58nMYKFNFXZsUmMrnsNLb53pCbT9t7A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbgIRCOc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:14:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729085AbgIRCOb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Sep 2020 22:14:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA5DF239E7;
        Fri, 18 Sep 2020 02:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395271;
        bh=VCfax6uABULRNQtKg4f0N10ZLTpviLMuoiwPAsLRLh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWf/POJD+pZYQCGzp2JriTcbm8QeYRVgqwDa7X+o7oM8gVLq83aUXIg75OjUHLI2V
         8KJvaQPj4VG0/l0Tg3fHBntrVfQz/vCEBwL/ogWKSMGw+hOWWfyAc2BKqFznPil3B9
         WdPhOIhuhfreLfiyNs6Kb/iyQr6K7sHdJ6f2Px0w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, Sasha Levin <sashal@kernel.org>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 110/127] btrfs: don't force read-only after error in drop snapshot
Date:   Thu, 17 Sep 2020 22:12:03 -0400
Message-Id: <20200918021220.2066485-110-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021220.2066485-1-sashal@kernel.org>
References: <20200918021220.2066485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: David Sterba <dsterba@suse.com>

[ Upstream commit 7c09c03091ac562ddca2b393e5d65c1d37da79f1 ]

Deleting a subvolume on a full filesystem leads to ENOSPC followed by a
forced read-only. This is not a transaction abort and the filesystem is
otherwise ok, so the error should be just propagated to the callers.

This is caused by unnecessary call to btrfs_handle_fs_error for all
errors, except EAGAIN. This does not make sense as the standard
transaction abort mechanism is in btrfs_drop_snapshot so all relevant
failures are handled.

Originally in commit cb1b69f4508a ("Btrfs: forced readonly when
btrfs_drop_snapshot() fails") there was no return value at all, so the
btrfs_std_error made some sense but once the error handling and
propagation has been implemented we don't need it anymore.

Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 63b8812ba508a..24410b0389f57 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9365,8 +9365,6 @@ out:
 	 */
 	if (!for_reloc && root_dropped == false)
 		btrfs_add_dead_root(root);
-	if (err && err != -EAGAIN)
-		btrfs_handle_fs_error(fs_info, err, NULL);
 	return err;
 }
 
-- 
2.25.1

