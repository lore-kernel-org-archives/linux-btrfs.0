Return-Path: <SRS0=y5XK=V5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EFB8C19759
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Aug 2019 17:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30865204EC
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Aug 2019 17:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387873AbfHARw3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Aug 2019 13:52:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:45916 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727508AbfHARw3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Aug 2019 13:52:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 39B01AD17
        for <linux-btrfs@vger.kernel.org>; Thu,  1 Aug 2019 17:52:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5DA02DA7D9; Thu,  1 Aug 2019 19:53:02 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 1/2] btrfs: remove unused btrfs_device::flush_bio_sent
Date:   Thu,  1 Aug 2019 19:53:02 +0200
Message-Id: <e81ad9bab030f1b4dbde91b6b0f5ef9caee42ab4.1564681931.git.dsterba@suse.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <cover.1564681931.git.dsterba@suse.com>
References: <cover.1564681931.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The status of flush bio is tracked as a status bit, changed in commit
1c3063b6dbfa ("btrfs: cleanup device states define
BTRFS_DEV_STATE_FLUSH_SENT"), the flush_bio_sent was forgotten.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index c71354fe1363..081cb734a239 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -82,7 +82,6 @@ struct btrfs_device {
 
 	unsigned long dev_state;
 	blk_status_t last_flush_error;
-	int flush_bio_sent;
 
 #ifdef __BTRFS_NEED_DEVICE_DATA_ORDERED
 	seqcount_t data_seqcount;
-- 
2.22.0

