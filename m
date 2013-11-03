Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:57161 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab3KCRHS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Nov 2013 12:07:18 -0500
Received: by mail-ea0-f170.google.com with SMTP id q10so2424581eaj.15
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Nov 2013 09:07:17 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, idryomov@gmail.com,
        Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH 1/3] Btrfs: do not inc uncorrectable_errors counter on ro scrubs
Date: Sun,  3 Nov 2013 19:06:38 +0200
Message-Id: <1383498400-21009-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently if we discover an error when scrubbing in ro mode we a)
blindly increment the uncorrectable_errors counter, and b) spam the
dmesg with the 'unable to fixup (regular) error at ...' message, even
though a) we haven't tried to determine if the error is correctable or
not, and b) we haven't tried to fixup anything.  Fix this.

Cc: Stefan Behrens <sbehrens@giantdisaster.de>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/scrub.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index f21e2df..f94b98d 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -938,8 +938,10 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 				BTRFS_DEV_STAT_CORRUPTION_ERRS);
 	}
 
-	if (sctx->readonly && !sctx->is_dev_replace)
-		goto did_not_correct_error;
+	if (sctx->readonly) {
+		ASSERT(!sctx->is_dev_replace);
+		goto out;
+	}
 
 	if (!is_metadata && !have_csum) {
 		struct scrub_fixup_nodatasum *fixup_nodatasum;
-- 
1.7.10.4

