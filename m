Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64DA3C43610
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 14:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FED420825
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 14:08:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2FED420825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbeKIXt2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Nov 2018 18:49:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:49786 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728520AbeKIXt1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Nov 2018 18:49:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BFB42AF80
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Nov 2018 14:08:40 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/9] btrfs: Add function to distinguish between data and btree inode
Date:   Fri,  9 Nov 2018 16:08:30 +0200
Message-Id: <20181109140838.10457-2-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181109140838.10457-1-nborisov@suse.com>
References: <20181109140838.10457-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This will be used in future patches that remove the optional
extent_io_ops callbacks.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/btrfs_inode.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 97d91e55b70a..213a6a63dac5 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -253,6 +253,11 @@ static inline bool btrfs_is_free_space_inode(struct btrfs_inode *inode)
 	return false;
 }
 
+static inline bool is_data_inode(struct inode *inode)
+{
+	return btrfs_ino(BTRFS_I(inode)) != BTRFS_BTREE_INODE_OBJECTID;
+}
+
 static inline void btrfs_mod_outstanding_extents(struct btrfs_inode *inode,
 						 int mod)
 {
-- 
2.17.1

