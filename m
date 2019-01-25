Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11016C282C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 05:09:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEEEE218D2
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 05:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfAYFJi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Jan 2019 00:09:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:56150 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725300AbfAYFJh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Jan 2019 00:09:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 39B48AE03
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Jan 2019 05:09:36 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v4 03/12] btrfs: disk-io: Show the timing of corrupted tree block explicitly
Date:   Fri, 25 Jan 2019 13:09:16 +0800
Message-Id: <20190125050925.30754-4-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190125050925.30754-1-wqu@suse.com>
References: <20190125050925.30754-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Just add one extra line to show when the corruption is detected.
Currently only read time detection is possible.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/disk-io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 794d5bb7fe33..426e9f450f70 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -658,6 +658,8 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 
 	if (!ret)
 		set_extent_buffer_uptodate(eb);
+	else
+		btrfs_err(fs_info, "read time tree block corrupted detected");
 err:
 	if (reads_done &&
 	    test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
-- 
2.20.1

