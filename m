Return-Path: <SRS0=11YW=ZI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83877C432C3
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Nov 2019 16:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C276214DE
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Nov 2019 16:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573921633;
	bh=1UHd5Z+iO61oz8qaxXgGlqrU6/ESGUcvWsJ5GK3etOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=d72/0o/4bamgtFseBuN0z5kNFS6+ViGRdyxj/jL6b+fK2BPC7GxgLf3YCWDLpPuPw
	 hgDHah4B8nK+XTE/rsEvpt3oZKI69FeJRTQKklFGzVA/fuDZx2OEs6MoFDb+rEbaBY
	 Smr5Bl3KPor/oVglloINHh9HBdEF5TwWprPxEe8o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729439AbfKPQ1J (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 Nov 2019 11:27:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727962AbfKPPlj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:39 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2103320830;
        Sat, 16 Nov 2019 15:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918899;
        bh=1UHd5Z+iO61oz8qaxXgGlqrU6/ESGUcvWsJ5GK3etOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8MYdDZRxS10ql0g6lEnXSQiHHdYXMXNp0FddstZmy0SCLtnlLwZoSVcD7v8Diff5
         vQWCrhMRB0gJusD0dbsLL+K6dln4EG5bEO2tw1d38F67Y3ssExtp6OO0xWQcU2Cp3Z
         aQRXnIQ1uF/y5FgKi0L39YCh/ZeS4A6hFDQsgC1w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Su Yue <suy.fnst@cn.fujitsu.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 027/237] btrfs: defrag: use btrfs_mod_outstanding_extents in cluster_pages_for_defrag
Date:   Sat, 16 Nov 2019 10:37:42 -0500
Message-Id: <20191116154113.7417-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Su Yue <suy.fnst@cn.fujitsu.com>

[ Upstream commit 28c4a3e21ad030d7571ee9b1b246a5cbfd886627 ]

Since commit 8b62f87bad9c ("Btrfs: rework outstanding_extents"),
manual operations of outstanding_extent in btrfs_inode are replaced by
btrfs_mod_outstanding_extents().
The one in cluster_pages_for_defrag seems to be lost, so replace it
of btrfs_mod_outstanding_extents().

Fixes: 8b62f87bad9c ("Btrfs: rework outstanding_extents")
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7592beb53fc4e..00ff4349b4579 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1337,7 +1337,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 
 	if (i_done != page_cnt) {
 		spin_lock(&BTRFS_I(inode)->lock);
-		BTRFS_I(inode)->outstanding_extents++;
+		btrfs_mod_outstanding_extents(BTRFS_I(inode), 1);
 		spin_unlock(&BTRFS_I(inode)->lock);
 		btrfs_delalloc_release_space(inode, data_reserved,
 				start_index << PAGE_SHIFT,
-- 
2.20.1

