Return-Path: <SRS0=jbNX=Q6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D55CC43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 23 Feb 2019 04:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C43F206B6
	for <linux-btrfs@archiver.kernel.org>; Sat, 23 Feb 2019 04:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbfBWEiO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 23:38:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:39700 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725821AbfBWEiN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 23:38:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C427EAC70
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Feb 2019 04:38:12 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v5.2 03/12] btrfs: disk-io: Show the timing of corrupted tree block explicitly
Date:   Sat, 23 Feb 2019 12:38:06 +0800
Message-Id: <20190223043806.13836-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190218052753.24138-4-wqu@suse.com>
References: <20190218052753.24138-4-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Just add one extra line to show when the corruption is detected.
Currently only read time detection is possible.

The planned distinguish line would be:
  read time:
    <detail report>
    block=XXXXX read time tree block corruption detected

  write time:
    <detail report>
    block=XXXXX write time tree block corruption detected

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
v5.2:
- Make the read time error message only for tree checker error.
  RAID reconstruction can cause a lot of errors which are expected.
  Avoid error message flood for such use case.
---
 fs/btrfs/disk-io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ffe891e126ff..464e47be8002 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -658,6 +658,10 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 
 	if (!ret)
 		set_extent_buffer_uptodate(eb);
+	else
+		btrfs_err(fs_info,
+			  "block=%llu read time tree block corruption detected",
+			  eb->start);
 err:
 	if (reads_done &&
 	    test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
-- 
2.20.1

