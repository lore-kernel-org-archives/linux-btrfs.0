Return-Path: <SRS0=mE47=XI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15190C4CEC7
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Sep 2019 00:02:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6DDB20830
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Sep 2019 00:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbfIMACX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 12 Sep 2019 20:02:23 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:48584 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726516AbfIMACX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Sep 2019 20:02:23 -0400
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Sep 2019 20:02:22 EDT
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 3DE794232AF; Thu, 12 Sep 2019 19:55:04 -0400 (EDT)
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix balance convert to single on 32-bit host CPUs
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <20190912235507.3DE794232AF@james.kirk.hungrycats.org>
Date:   Thu, 12 Sep 2019 19:55:01 -0400 (EDT)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Currently, the command:

	btrfs balance start -dconvert=single,soft .

on a Raspberry Pi produces the following kernel message:

	BTRFS error (device mmcblk0p2): balance: invalid convert data profile single

This fails because we use is_power_of_2(unsigned long) to validate
the new data profile, the constant for 'single' profile uses bit 48,
and there are only 32 bits in a long on ARM.

Fix by open-coding the check using u64 variables.

Tested by completing the original balance command on several Raspberry
Pis.

Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
---
 fs/btrfs/volumes.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 88a323a453d8..252c6049c6b7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3906,7 +3906,11 @@ static int alloc_profile_is_valid(u64 flags, int extended)
 		return !extended; /* "0" is valid for usual profiles */
 
 	/* true if exactly one bit set */
-	return is_power_of_2(flags);
+	/*
+	 * Don't use is_power_of_2(unsigned long) because it won't work
+	 * for the single profile (1ULL << 48) on 32-bit CPUs.
+	 */
+	return flags != 0 && (flags & (flags - 1)) == 0;
 }
 
 static inline int balance_need_close(struct btrfs_fs_info *fs_info)
-- 
2.20.1

