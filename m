Return-Path: <SRS0=y50c=C6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3117C4347E
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Sep 2020 17:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B83920C09
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Sep 2020 17:38:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kaIFFhTp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbgIURi0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Sep 2020 13:38:26 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:30829 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIURi0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Sep 2020 13:38:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600709906; x=1632245906;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FAIIY2PAFRdf4cIbitlZAY7MLD9DY9hs0VtS2BGZpdM=;
  b=kaIFFhTp5hBwY7INe3N1ZtiLMxbVWyTF69BweRR5OzLv+A+l9jLZiEOP
   INBxXA3ZAehPEsM25eCcYA9/RCoktfU2JIRgZKoZqebjUaoBc1z/pWfGX
   00oPQD3dAmZkeOCoQgzdryG5UUM1Bu9gfvwmC0Jvgill444V/3YcGu5Z7
   HFaPUdUjsTCnsjDEVgX3c6vR/77yws2kjvINGhlEm2CJ0gXl+d7ncyzbf
   i8C6r1Kitx0Q3amUk6CB7Wh9LAdyVXlEiFQadem9B7DjOGPIJMc3ng7ox
   ZmaKNeA0x1xUKJuLq2kVEnp/1VDGp5kRJzTerIZVbW39pJMsGlNUkKh3y
   g==;
IronPort-SDR: jfXp14XE6F1pRqyeySUM+CwD7zhfCvBZgX6LJMWxr5B/Ulp+R73s4izVQknB7nmsiB9Twzw2wZ
 guEp0xgKyNkW9mszV16DGIiO5veABr9tKcSzU+jLyaC3U2fyPiLo6WTKlU6pGQ2xNjsHKYKS1I
 PNtYVL2T1dt8B5tV0pkNsvjXBkGq+bQMJ3/u4BJHIq/VlD6Qu/I/QbOqFGqpx7Gu075yCJc2Xe
 fNTPF/uJ3r3SXhnlva7vZQRb6eXRrASXKTsWa4uK3E2Q3jKltyX4GupUgveyXA5NgVV9PDad4l
 9QE=
X-IronPort-AV: E=Sophos;i="5.77,287,1596470400"; 
   d="scan'208";a="149143156"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Sep 2020 01:38:26 +0800
IronPort-SDR: exOsnfLoar61acedZxkVpOwGLmRC/K9lUfFaGPP9muovrjzTBeWdlw2pynwvJbxFqCS8VPAoR7
 ggebemONsIbA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 10:25:29 -0700
IronPort-SDR: vHEcO6YKd/Qjcw9PYbXjCLFi3Rk5XfmvKj0XuMg/1g5o3H8cL9x+SRUDV3PBtKYLxUoqAdicd8
 dLdExBaHYLmA==
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip01.wdc.com with ESMTP; 21 Sep 2020 10:38:24 -0700
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs: reschedule when cloning lots of extents
Date:   Tue, 22 Sep 2020 02:38:10 +0900
Message-Id: <23e7f73a25cea63f33c220c1da3daf62d9ffd3e8.1600709608.git.johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We have several occurrences of a soft lockup from generic/175. All of these
lockup reports have the call chain btrfs_clone_files() -> btrfs_clone() in
common.

btrfs_clone_files() calls btrfs_clone() with both source and destination
extents locked and loops over the source extent to create the clones.

Conditionally reschedule in the btrfs_clone() loop, to give some time back
to other processes.

Link: https://github.com/btrfs/fstests/issues/23
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/reflink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 39b3269e5760..99aa87c08912 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -520,6 +520,8 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 			ret = -EINTR;
 			goto out;
 		}
+
+		cond_resched();
 	}
 	ret = 0;
 
-- 
2.26.2

