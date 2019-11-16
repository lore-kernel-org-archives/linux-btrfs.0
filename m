Return-Path: <SRS0=11YW=ZI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABB9BC432C3
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Nov 2019 16:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 824B521845
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Nov 2019 16:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573920331;
	bh=rQC+cGTzMCq1vXMp7OOlM5NKkFtnVplMXAgO3cNKb4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=JVZsGbvFKWxlw9x/a1SRnl88rEUpOllpCcoYoWeB14okwWTqQwoeN3q78rnk742Iq
	 Bxul2CbYQMiuP4Xi7yGZ8PUvGLhrJ35N8D9m3mBLHXuMElAKwgWigjZp0uxEaBPnaS
	 TVIDDa+pAmiRiS9DHHCYkWEKzt946CmN4axgu8Os=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731308AbfKPQF2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 Nov 2019 11:05:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:59878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730713AbfKPPvS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Nov 2019 10:51:18 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED3F1208E3;
        Sat, 16 Nov 2019 15:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919477;
        bh=rQC+cGTzMCq1vXMp7OOlM5NKkFtnVplMXAgO3cNKb4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UXjQH3RlbzrKQQUmudiA398nFEcONwXB1IFbJ7Mt6yUuoudg1bij+lrpnYfzbXt6K
         AqWjBXZ+9PAZAYk6pFH5ZGb9pFAREMO/Cx6cpcEQrK4SHl0ibL/hL9jDWwT2a8HjYO
         v8TAY1zypNVA4HqTltdPxZJAl56sc+X+bAmYFSVE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 11/99] btrfs: handle error of get_old_root
Date:   Sat, 16 Nov 2019 10:49:34 -0500
Message-Id: <20191116155103.10971-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

[ Upstream commit 315bed43fea532650933e7bba316a7601d439edf ]

In btrfs_search_old_slot get_old_root is always used with the assumption
it cannot fail. However, this is not true in rare circumstance it can
fail and return null. This will lead to null point dereference when the
header is read. Fix this by checking the return value and properly
handling NULL by setting ret to -EIO and returning gracefully.

Coverity-id: 1087503
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 3df434eb14743..3faccbf35e9f4 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2973,6 +2973,10 @@ int btrfs_search_old_slot(struct btrfs_root *root, struct btrfs_key *key,
 
 again:
 	b = get_old_root(root, time_seq);
+	if (!b) {
+		ret = -EIO;
+		goto done;
+	}
 	level = btrfs_header_level(b);
 	p->locks[level] = BTRFS_READ_LOCK;
 
-- 
2.20.1

