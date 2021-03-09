Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2FD2C433DB
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Mar 2021 07:39:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DCFA652AB
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Mar 2021 07:39:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhCIHjS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 02:39:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:43574 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229714AbhCIHjO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Mar 2021 02:39:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615275553; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=C9l5UsWbagWKuCmNAzN+BP2I85qjqN0qQpivd7L1d+g=;
        b=E0cmru3SjYc9t0ueOUVCr7VeaR818WrgehCTHO2U0BDcuN14LAiymF9wIggMa2GMNk7qev
        k7JA2UzAMj18BfjTxmYKOaTsvifqLkH4ryCJuPsaxohRbRKMtMFvMehRjwvJL+IkVnD6xo
        zfCkTPTgbtlA8q+O8KX8+4oTbjVIr5g=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2F733AC1F
        for <linux-btrfs@vger.kernel.org>; Tue,  9 Mar 2021 07:39:13 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: output sectorsize related warning message into stdout
Date:   Tue,  9 Mar 2021 15:39:09 +0800
Message-Id: <20210309073909.74043-1-wqu@suse.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since commit 90020a760584 ("btrfs-progs: mkfs: refactor how we handle
sectorsize override") we have extra warning message if the sectorsize of
mkfs doesn't match page size.

But this warning is show as stderr, which makes a lot of fstests cases
failure due to golden output mismatch.

Fix this by manually output the warning message as stdout.

This is just a temporary fix, a proper fix would needs kernel
/sys/fs/btrfs/features/supported_rw_sectorsize interface to do proper
prompt.

Fixes: 90020a760584 ("btrfs-progs: mkfs: refactor how we handle sectorsize override")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 common/fsfeatures.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/common/fsfeatures.c b/common/fsfeatures.c
index 569208a9e5b1..f9492e30d57a 100644
--- a/common/fsfeatures.c
+++ b/common/fsfeatures.c
@@ -341,8 +341,16 @@ int btrfs_check_sectorsize(u32 sectorsize)
 		return -EINVAL;
 	}
 	if (page_size != sectorsize)
-		warning(
-"the filesystem may not be mountable, sectorsize %u doesn't match page size %u",
+		/*
+		 * warning() will output message into stderr, which will screw
+		 * up a lot of golden output of fstests. So here we use
+		 * printf().
+		 *
+		 * This will be replaced by proper supported rw/ro sector size
+		 * detection with kernel change in the future.
+		 */
+		printf(
+"WARNING: the filesystem may not be mountable, sectorsize %u doesn't match page size %u\n",
 			sectorsize, page_size);
 	return 0;
 }
-- 
2.30.1

