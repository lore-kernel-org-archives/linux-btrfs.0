Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC53C433ED
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Apr 2021 23:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFFD7613FF
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Apr 2021 23:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239504AbhD0XGL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Apr 2021 19:06:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:37558 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239500AbhD0XGF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Apr 2021 19:06:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619564720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g2+TWFALsvOjYfYoe8m/JuOE62ER1DOsUFtbIK6/3Zc=;
        b=R+RtuXTzX4huJhQYQaxPdFCivSE9LBCcubVaWvpSfGPhqYHgiCwqn1EmUDGdNrsVLZKw+O
        WIc8Ztg/uqBgrOOPM7OUlafy8cVonES1dVNFvnWOVbtbjgp+SLIu4VIeF8Sn0OZ4MMJnA3
        Ge2DQIE6JbdcP4iXyrj4brq4T7lxMQ8=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 678ABAC6A
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Apr 2021 23:05:20 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [Patch v2 39/42] btrfs: reject raid5/6 fs for subpage
Date:   Wed, 28 Apr 2021 07:03:46 +0800
Message-Id: <20210427230349.369603-40-wqu@suse.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210427230349.369603-1-wqu@suse.com>
References: <20210427230349.369603-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Raid5/6 is not only unsafe due to its write-hole problem, but also has
tons of hardcoded PAGE_SIZE.

So disable it for subpage support for now.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c9a3036c23bf..e6b941932a2b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3407,6 +3407,16 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 			goto fail_alloc;
 		}
 	}
+	if (sectorsize != PAGE_SIZE) {
+		if (btrfs_super_incompat_flags(fs_info->super_copy) &
+			BTRFS_FEATURE_INCOMPAT_RAID56) {
+			btrfs_err(fs_info,
+	"raid5/6 is not yet supported for sector size %u with page size %lu",
+				sectorsize, PAGE_SIZE);
+			err = -EINVAL;
+			goto fail_alloc;
+		}
+	}
 
 	ret = btrfs_init_workqueues(fs_info, fs_devices);
 	if (ret) {
-- 
2.31.1

