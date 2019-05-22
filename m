Return-Path: <SRS0=N9Hd=TW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F17C282CE
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 May 2019 19:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5EC520862
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 May 2019 19:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558554960;
	bh=KjnceZrrK6pttVwb8hdNkEHs3mPHFshpUT6RlkLvtX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=MOv7qkk/i9NP1LVvo49Cc/YRSqJW2e3LjbFvZ+kUWsGeTJ2EPoAmwGg7IHKYGAQ7E
	 nB8glifrCIA8kSnyTOfeB0Js5LJRdQZ2Y2hvfPYOH2m7sl9Ky62Y5uzchPBKKUViXy
	 FDanJ1itORhOFCht+au6QI8Shdr40O6CZzsGYvL4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731900AbfEVTz4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 May 2019 15:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730340AbfEVTZH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 May 2019 15:25:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F70D217D9;
        Wed, 22 May 2019 19:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553107;
        bh=KjnceZrrK6pttVwb8hdNkEHs3mPHFshpUT6RlkLvtX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0n3iklGxsNkm7n0u1r4+uEGD/re/HNY5pDLq9lfhxF1LMNjt6ymwA+NWmXvu2OZIH
         L6EfakA7QR1HpKEieln5rVIGIGjIBMSuJuVnMHpHD7Qos8dgViIMMKDuwpRAA1YGPz
         LRQ0OCox19F2soKW3Ztv7STyisWjr832Wo/zN+9o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 051/317] btrfs: Don't panic when we can't find a root key
Date:   Wed, 22 May 2019 15:19:12 -0400
Message-Id: <20190522192338.23715-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 7ac1e464c4d473b517bb784f30d40da1f842482e ]

When we failed to find a root key in btrfs_update_root(), we just panic.

That's definitely not cool, fix it by outputting an unique error
message, aborting current transaction and return -EUCLEAN. This should
not normally happen as the root has been used by the callers in some
way.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/root-tree.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 65bda0682928b..f51a4a425a457 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -137,11 +137,14 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 		goto out;
 	}
 
-	if (ret != 0) {
-		btrfs_print_leaf(path->nodes[0]);
-		btrfs_crit(fs_info, "unable to update root key %llu %u %llu",
-			   key->objectid, key->type, key->offset);
-		BUG_ON(1);
+	if (ret > 0) {
+		btrfs_crit(fs_info,
+			"unable to find root key (%llu %u %llu) in tree %llu",
+			key->objectid, key->type, key->offset,
+			root->root_key.objectid);
+		ret = -EUCLEAN;
+		btrfs_abort_transaction(trans, ret);
+		goto out;
 	}
 
 	l = path->nodes[0];
-- 
2.20.1

