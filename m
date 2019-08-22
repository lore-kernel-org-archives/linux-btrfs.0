Return-Path: <SRS0=CyxS=WS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C01CC3A5A1
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Aug 2019 11:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C0DC2339F
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Aug 2019 11:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731845AbfHVLkh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 07:40:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:50748 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731631AbfHVLkd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Aug 2019 07:40:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 769C1AD72
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Aug 2019 11:40:32 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 1/4] btrfs: turn checksum type define into a enum
Date:   Thu, 22 Aug 2019 13:40:26 +0200
Message-Id: <20190822114029.11225-2-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190822114029.11225-1-jthumshirn@suse.de>
References: <20190822114029.11225-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Turn the checksum type definition into a enum. This eases later addition
of new checksums.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 include/uapi/linux/btrfs_tree.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index 71246c1941aa..b65c7ee75bc7 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -300,7 +300,9 @@
 #define BTRFS_CSUM_SIZE 32
 
 /* csum types */
-#define BTRFS_CSUM_TYPE_CRC32	0
+enum btrfs_csum_type {
+	BTRFS_CSUM_TYPE_CRC32	= 0,
+};
 
 /*
  * flags definitions for directory entry item type
-- 
2.16.4

