Return-Path: <SRS0=ls+F=UC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34AC1C04AB5
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Jun 2019 14:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 136FC27B10
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Jun 2019 14:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbfFCO7Q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Jun 2019 10:59:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:60872 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729146AbfFCO7D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Jun 2019 10:59:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 75FEFACFA;
        Mon,  3 Jun 2019 14:59:02 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Richard Weinberger <richard@nod.at>,
        David Gstir <david@sigma-star.at>,
        Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v4 01/13] btrfs: use btrfs_csum_data() instead of directly calling crc32c
Date:   Mon,  3 Jun 2019 16:58:47 +0200
Message-Id: <20190603145859.7176-2-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190603145859.7176-1-jthumshirn@suse.de>
References: <20190603145859.7176-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfsic_test_for_metadata() directly calls the crc32c() library function
for calculating the CRC32C checksum, but then uses btrfs_csum_final() to
invert the result.

To ease further refactoring and development around checksumming in BTRFS
convert to calling btrfs_csum_data(), which is a wrapper around crc32c().

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/check-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index b0c8094528d1..85774e2fa3e5 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1728,7 +1728,7 @@ static int btrfsic_test_for_metadata(struct btrfsic_state *state,
 		size_t sublen = i ? PAGE_SIZE :
 				    (PAGE_SIZE - BTRFS_CSUM_SIZE);
 
-		crc = crc32c(crc, data, sublen);
+		crc = btrfs_csum_data(data, crc, sublen);
 	}
 	btrfs_csum_final(crc, csum);
 	if (memcmp(csum, h->csum, state->csum_size))
-- 
2.16.4

