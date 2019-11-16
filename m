Return-Path: <SRS0=11YW=ZI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC37C432C3
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Nov 2019 15:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE3D221843
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Nov 2019 15:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573919992;
	bh=28UcTghOrsaTsVNgqi4hwzYOQG18W8MsP+t0Js06z9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Q4wJgvECnjJqN9zghTZFjnIBWWBwY7kDDZfii5y5VCYHxeMf/WFRYVZAAJeV31fom
	 P1gr8Q+YPjifcvvmKCW1bi2pp/2JRtIJ2z/WdJA37Op91DHH4iZ3ChUg7fnIVeTtJR
	 f6QAxZ7vQNQvIZ2eCF30iLhGdI1tdKb0pSg8Dbt4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731467AbfKPP7u (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 Nov 2019 10:59:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:35110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731316AbfKPPxt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Nov 2019 10:53:49 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D86FB2168B;
        Sat, 16 Nov 2019 15:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919629;
        bh=28UcTghOrsaTsVNgqi4hwzYOQG18W8MsP+t0Js06z9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MdHoewWZan58GFI8xDKokD8D2D6Kbil5F1AUOGNHoZ4VRPx2mGBkb3Jwq1vKZYwet
         nPxYhCRDfW8GCOMpNHdpPZOZYQH4B+f7j+ubsVfwU9cvomqeUGdqteK1Kbghcb3D9w
         CXnCBgARZID61VRwfKltpf04qzQyGuHAoC1tNOEI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 10/77] btrfs: handle error of get_old_root
Date:   Sat, 16 Nov 2019 10:52:32 -0500
Message-Id: <20191116155339.11909-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155339.11909-1-sashal@kernel.org>
References: <20191116155339.11909-1-sashal@kernel.org>
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
index 51a0409e1b84a..a980b33097701 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2966,6 +2966,10 @@ int btrfs_search_old_slot(struct btrfs_root *root, struct btrfs_key *key,
 
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

