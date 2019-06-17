Return-Path: <SRS0=jqbo=UQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99BC8C31E5D
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Jun 2019 16:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C6B220863
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Jun 2019 16:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbfFQQp7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Jun 2019 12:45:59 -0400
Received: from tartarus.angband.pl ([54.37.238.230]:55476 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfFQQp6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Jun 2019 12:45:58 -0400
Received: from [2a02:a31c:853f:a300::4] (helo=valinor.angband.pl)
        by tartarus.angband.pl with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <kilobyte@angband.pl>)
        id 1hculU-0005Qn-JE; Mon, 17 Jun 2019 18:45:54 +0200
Received: from kilobyte by valinor.angband.pl with local (Exim 4.92)
        (envelope-from <kilobyte@valinor.angband.pl>)
        id 1hculT-0001GV-UE; Mon, 17 Jun 2019 18:45:51 +0200
From:   Adam Borowski <kilobyte@angband.pl>
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc:     Adam Borowski <kilobyte@angband.pl>
Date:   Mon, 17 Jun 2019 18:45:48 +0200
Message-Id: <20190617164548.4776-1-kilobyte@angband.pl>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a02:a31c:853f:a300::4
X-SA-Exim-Mail-From: kilobyte@angband.pl
Subject: [PATCH] btrfs-progs: check: fix option parsing for -E
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on tartarus.angband.pl)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

It has a mandatory argument, thus it always crashed.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 check/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/check/main.c b/check/main.c
index 731c21d3..b2f0c810 100644
--- a/check/main.c
+++ b/check/main.c
@@ -9923,7 +9923,7 @@ int cmd_check(int argc, char **argv)
 			{ NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long(argc, argv, "as:br:pEQ", long_options, NULL);
+		c = getopt_long(argc, argv, "as:br:pE:Q", long_options, NULL);
 		if (c < 0)
 			break;
 		switch(c) {
-- 
2.20.1

