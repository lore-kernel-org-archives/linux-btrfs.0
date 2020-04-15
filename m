Return-Path: <SRS0=FXaq=57=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF5CBC38A29
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Apr 2020 12:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C66BD208FE
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Apr 2020 12:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586953666;
	bh=f+MIyflL7PoUCPvmXSbksyJDbP3lDfOTiJtP3BLlWqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=In+EdBwztuarAGVwxPvalEyJ1LANEuHmD10vpnZ64YkP8V2Ab239FwNbWJvZjWc5t
	 mfKkqK1qp+gXiOViF2/+WgHAt0zVsviUnlHbOA7oDt5aegHTedFYrtQC+ARXuFlO/z
	 JhMpQAGxIZ+i1tav/8t1I/U6bRZql1leJHvACC4o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409160AbgDOLpU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 07:45:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406162AbgDOLpQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Apr 2020 07:45:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A52E820737;
        Wed, 15 Apr 2020 11:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951116;
        bh=f+MIyflL7PoUCPvmXSbksyJDbP3lDfOTiJtP3BLlWqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVKZvrjzvZKjfyxuV31HsD/pSiG7pCGZ03jzwkZ4o0wiftoAP1a3CU6rfqrNumRZZ
         w9TC8dPkVPrfkWAKwXlokfDJcyFXZraNeZqWn9TwA/a5O0zQzGzivFye5hDx7TYMBe
         t1XgEWipX14jNd1MYQRFN+CmTtIvunHjrisjq1rw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 30/84] btrfs: add RCU locks around block group initialization
Date:   Wed, 15 Apr 2020 07:43:47 -0400
Message-Id: <20200415114442.14166-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114442.14166-1-sashal@kernel.org>
References: <20200415114442.14166-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

[ Upstream commit 29566c9c773456467933ee22bbca1c2b72a3506c ]

The space_info list is normally RCU protected and should be traversed
with rcu_read_lock held. There's a warning

  [29.104756] WARNING: suspicious RCU usage
  [29.105046] 5.6.0-rc4-next-20200305 #1 Not tainted
  [29.105231] -----------------------------
  [29.105401] fs/btrfs/block-group.c:2011 RCU-list traversed in non-reader section!!

pointing out that the locking is missing in btrfs_read_block_groups.
However this is not necessary as the list traversal happens at mount
time when there's no other thread potentially accessing the list.

To fix the warning and for consistency let's add the RCU lock/unlock,
the code won't be affected much as it's doing some lightweight
operations.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 7dcfa7d7632a1..95330f40f998c 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1829,6 +1829,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 		}
 	}
 
+	rcu_read_lock();
 	list_for_each_entry_rcu(space_info, &info->space_info, list) {
 		if (!(btrfs_get_alloc_profile(info, space_info->flags) &
 		      (BTRFS_BLOCK_GROUP_RAID10 |
@@ -1849,6 +1850,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 				list)
 			inc_block_group_ro(cache, 1);
 	}
+	rcu_read_unlock();
 
 	btrfs_init_global_block_rsv(info);
 	ret = check_chunk_block_group_mappings(info);
-- 
2.20.1

