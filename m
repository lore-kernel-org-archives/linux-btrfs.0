Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47E6DC433EF
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Jun 2022 13:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347739AbiFONaH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 15 Jun 2022 09:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353685AbiFON3u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Jun 2022 09:29:50 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1B33FBE4
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2022 06:29:31 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4B20621C64;
        Wed, 15 Jun 2022 13:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1655299770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NHD7owCalq3qcJ+bFob0h1EtOapHfHwQttD7pZs7gmA=;
        b=JQYqAfQnHzLqdtWNbzEaD5rrKZWwwIA9icAkxQNDM5byBt0dHVTdCoz70thoaZ+WnJj8UY
        DtayBvCaVQGzsECJoDWSY8CNvRFBnZ47ULlrNn2NCzdrdXgyqDEqfHJ+obbzFlt39O2zz8
        xAB96gQXOxJRGoEHhgrJNbgVcNG8si8=
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 43BA32C141;
        Wed, 15 Jun 2022 13:29:30 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F1E91DA85E; Wed, 15 Jun 2022 15:24:57 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 1/6] btrfs: send: add OTIME as utimes attribute for proto 2+ by default
Date:   Wed, 15 Jun 2022 15:24:57 +0200
Message-Id: <3d8cfc2c3ec7b897bd58c234779cf9fa219a1992.1655299339.git.dsterba@suse.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655299339.git.dsterba@suse.com>
References: <cover.1655299339.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When send v1 was introduced the otime (inode creation time) was not
available, however the attribute in btrfs send protocol exists. Though
it would be possible to add it for v1 too as the attribute would be
ignored by v1 receive, let's not change the layout of v1 and only add
that to v2+.  The otime cannot be changed and is only informative.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/send.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 7de6aa5056cd..63f48a2aa3d4 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2580,7 +2580,8 @@ static int send_utimes(struct send_ctx *sctx, u64 ino, u64 gen)
 	TLV_PUT_BTRFS_TIMESPEC(sctx, BTRFS_SEND_A_ATIME, eb, &ii->atime);
 	TLV_PUT_BTRFS_TIMESPEC(sctx, BTRFS_SEND_A_MTIME, eb, &ii->mtime);
 	TLV_PUT_BTRFS_TIMESPEC(sctx, BTRFS_SEND_A_CTIME, eb, &ii->ctime);
-	/* TODO Add otime support when the otime patches get into upstream */
+	if (sctx->proto >= 2)
+		TLV_PUT_BTRFS_TIMESPEC(sctx, BTRFS_SEND_A_OTIME, eb, &ii->otime);
 
 	ret = send_cmd(sctx);
 
-- 
2.36.1

