Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53596ECDE30
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 09:14:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2420321523
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 09:14:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2420321523
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=wanadoo.fr
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbeJQRIx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 13:08:53 -0400
Received: from smtp12.smtpout.orange.fr ([80.12.242.134]:42864 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbeJQRIx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 13:08:53 -0400
Received: from ubuntu-CJ.clients.t30.sncf.fr ([109.190.253.13])
        by mwinf5d23 with ME
        id oZE01y00A0J6jfR03ZE0HA; Wed, 17 Oct 2018 11:14:05 +0200
X-ME-Helo: ubuntu-CJ.clients.t30.sncf.fr
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 17 Oct 2018 11:14:05 +0200
X-ME-IP: 109.190.253.13
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc:     linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] btrfs: Fix the return value in case of error in 'btrfs_mark_extent_written()'
Date:   Wed, 17 Oct 2018 11:13:59 +0200
Message-Id: <20181017091359.3763-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We return 0 unconditionally in most of the error handling paths of
'btrfs_mark_extent_written()'.
However, 'ret' is set to some error codes in several error handling paths.

Return 'ret' instead to propagate the error code.

Fixes: 9c8e63db1de9 ("Btrfs: kill BUG_ON()'s in btrfs_mark_extent_written")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch proposal is purely speculative.
I'm not sure at all that returning 'ret' is correct (but it looks like it
is :) )

What puzzles me is when 'ret' is set, 'btrfs_abort_transaction()' is also
called.
However, the only caller of 'btrfs_mark_extent_written()' (i.e.
'btrfs_finish_ordered_io()') also calls 'btrfs_abort_transaction()' if an
error is returned.
So returning an error code here, would lead to a double call to this abort
function.

I'm usure of if it is correct and/or intented.
If returning 'ret' is correct, should we also axe the 'btrfs_abort_transaction()'
calls here, and leave the caller do the clean-up?

Before the commit in the Fixes tag, we were BUGing_ON in case of errror. So
propagating the error was pointless.
---
 fs/btrfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 15b925142793..cac0bd744de3 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1374,7 +1374,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 	}
 out:
 	btrfs_free_path(path);
-	return 0;
+	return ret;
 }
 
 /*
-- 
2.17.1

