Return-Path: <SRS0=dRQQ=6M=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DF62C83001
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Apr 2020 15:11:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34C65205C9
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Apr 2020 15:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgD1PLQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 11:11:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:56346 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727915AbgD1PLQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Apr 2020 11:11:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3D8E8AFAC;
        Tue, 28 Apr 2020 15:11:14 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F16B6DA8C9; Tue, 28 Apr 2020 17:10:29 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 2/2] btrfs: add more codes to decoder table
Date:   Tue, 28 Apr 2020 17:10:29 +0200
Message-Id: <7557462b9680ecf965016165e100ae57f67d1182.1588086487.git.dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <cover.1588086487.git.dsterba@suse.com>
References: <cover.1588086487.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I've grepped logs for 'errno=.*unknown' and found -95, -117 and -122,
now added to the table. The wording is adjusted so it makes sense in
context of filesystem.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/super.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9e5d723a0d99..438ecba26557 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -90,6 +90,15 @@ const char * __attribute_const__ btrfs_decode_error(int errno)
 	case -EROFS:		/* -30 */
 		errstr = "Readonly filesystem";
 		break;
+	case -EOPNOTSUPP:	/* -95 */
+		errstr = "Operation not supported";
+		break;
+	case -EUCLEAN:		/* -117 */
+		errstr = "Filesystem corrupted";
+		break;
+	case -EDQUOT:		/* -122 */
+		errstr = "Quota exceeded";
+		break;
 	}
 
 	return errstr;
-- 
2.25.0

