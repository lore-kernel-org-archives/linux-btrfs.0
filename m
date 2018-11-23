Return-Path: <SRS0=1Z4l=OC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21467C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 08:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4B8820820
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 08:42:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4B8820820
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408704AbeKWTZw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Nov 2018 14:25:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:58574 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2393753AbeKWTZw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Nov 2018 14:25:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 124C3ADBE
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Nov 2018 08:42:35 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] btrfs: remove btrfs_bio_end_io_t
Date:   Fri, 23 Nov 2018 09:42:27 +0100
Message-Id: <20181123084227.25840-1-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The btrfs_bio_end_io_t typedef was introduced with commit
a1d3c4786a4b ("btrfs: btrfs_multi_bio replaced with btrfs_bio")
but never used anywhere. This commit also introduced a forward declaration
of 'struct btrfs_bio' which is only needed for btrfs_bio_end_io_t.

Remove both as they're not needed anywhere.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/volumes.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 8b092bb1e2ee..c93097b0b469 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -295,9 +295,6 @@ struct btrfs_bio_stripe {
 	u64 length; /* only used for discard mappings */
 };
 
-struct btrfs_bio;
-typedef void (btrfs_bio_end_io_t) (struct btrfs_bio *bio, int err);
-
 struct btrfs_bio {
 	refcount_t refs;
 	atomic_t stripes_pending;
-- 
2.16.4

