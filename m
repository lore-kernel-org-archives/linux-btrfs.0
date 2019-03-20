Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE62C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84FFD2184E
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfCTG17 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 02:27:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:39752 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726749AbfCTG16 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 02:27:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 74C12AD3B
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2019 06:27:57 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v5.3 02/11] btrfs: disk-io: Show the timing of corrupted tree block explicitly
Date:   Wed, 20 Mar 2019 14:27:40 +0800
Message-Id: <20190320062749.30953-3-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190320062749.30953-1-wqu@suse.com>
References: <20190320062749.30953-1-wqu@suse.com>
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
 fs/btrfs/disk-io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6a7a1e168169..e8d4e238f832 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -659,6 +659,10 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 
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
2.21.0

