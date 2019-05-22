Return-Path: <SRS0=N9Hd=TW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4792C282CE
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 May 2019 19:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAD5520675
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 May 2019 19:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558554029;
	bh=aFIvxDwgLQtxByVGxwRnPQ/NnvxhKoDJ7f2NCtg+tY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=zWw+xi2UHi1WWZQBWeffK7wX7UJnH6mG+1uwyoUYOlyLLOf2xQjGyVyKJsj+SBIye
	 Z1lLDNTjxDatVAZtmxjSCr08V0NoQoQOls5wW77Xf5Cz2FLIu+6b2PlM0+EsGkTPN6
	 HHGfYrsWrit/qi4hMrWHKVxVdrbnbA0gdJnOaB3k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732888AbfEVT32 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 May 2019 15:29:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732488AbfEVT31 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 May 2019 15:29:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D151D20675;
        Wed, 22 May 2019 19:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553366;
        bh=aFIvxDwgLQtxByVGxwRnPQ/NnvxhKoDJ7f2NCtg+tY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGA4mfhKHXNAf7J0gb0RLq3ZNwOLwnFOYBC3weaZBJjn2Z1Wkyo1DxdmKJqMvHBw6
         /zLS1Qet0zcHyy6YzSm4Zf1QSIIiwqVxSNWQgDHFhg7bPwtePtLIOTHIpERVHcHJmI
         1Ba6BIC1MdX1W1FWO2I26fJ0al2adtk1rJEQIQQ0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 028/167] btrfs: Don't panic when we can't find a root key
Date:   Wed, 22 May 2019 15:26:23 -0400
Message-Id: <20190522192842.25858-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192842.25858-1-sashal@kernel.org>
References: <20190522192842.25858-1-sashal@kernel.org>
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
index 95bcc3cce78f8..f737513b53e3b 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -150,11 +150,14 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
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

