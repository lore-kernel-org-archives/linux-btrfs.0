Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C0F1C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 16:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAFDF214DB
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 16:45:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BAFDF214DB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=angband.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730742AbeKVDU3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 22:20:29 -0500
Received: from tartarus.angband.pl ([54.37.238.230]:57278 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbeKVDU2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 22:20:28 -0500
Received: from [2a02:a31c:853f:a300::6] (helo=umbar.angband.pl)
        by tartarus.angband.pl with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <kilobyte@angband.pl>)
        id 1gPVco-0001vc-5v; Wed, 21 Nov 2018 17:45:15 +0100
Received: from kilobyte by umbar.angband.pl with local (Exim 4.91)
        (envelope-from <kilobyte@umbar.angband.pl>)
        id 1gPVcn-0007Wl-D6; Wed, 21 Nov 2018 17:45:13 +0100
From:   Adam Borowski <kilobyte@angband.pl>
To:     David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Cc:     Adam Borowski <kilobyte@angband.pl>
Date:   Wed, 21 Nov 2018 17:45:10 +0100
Message-Id: <20181121164511.28875-1-kilobyte@angband.pl>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a02:a31c:853f:a300::6
X-SA-Exim-Mail-From: kilobyte@angband.pl
Subject: [PATCH RESEND 1/2] btrfs-progs: fix kernel version parsing on some versions past 3.0
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on tartarus.angband.pl)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The code fails if the third section is missing (like "4.18") or is followed
by anything but "." or "-".  This happens for example if we're not exactly
at a tag and CONFIG_LOCALVERSION_AUTO=n (which results in "4.18.5+").

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 fsfeatures.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fsfeatures.c b/fsfeatures.c
index 7d85d60f..66111bf4 100644
--- a/fsfeatures.c
+++ b/fsfeatures.c
@@ -216,11 +216,8 @@ u32 get_running_kernel_version(void)
 		return (u32)-1;
 	version |= atoi(tmp) << 8;
 	tmp = strtok_r(NULL, ".", &saveptr);
-	if (tmp) {
-		if (!string_is_numerical(tmp))
-			return (u32)-1;
+	if (tmp && string_is_numerical(tmp))
 		version |= atoi(tmp);
-	}
 
 	return version;
 }
-- 
2.19.1

