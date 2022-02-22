Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BBA1C433F5
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Feb 2022 07:41:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiBVHl4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Feb 2022 02:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiBVHlx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Feb 2022 02:41:53 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4814B129BAE
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Feb 2022 23:41:29 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 017152110A
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Feb 2022 07:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645515688; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sCs/oF6ILs9odDN5xLsnl9hcJSL0pmfX5ftMkCS0fUM=;
        b=N3Jei4gnm3jdEMq5KHH2HHVa0wojFPCu5B3rxLAW7WJ5q59JxAwCpBPbVGkeO03NsO+UH8
        oNqkrXVr+NCJGdZJqK1I7vedgRRbeGnfIe1/3w5EED6wUTNtAILT0CsI5v3fgcXWZLe0MZ
        MRf1Cbtm6JKZcKdHJlnBlb9JzLoJcmA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4167413BA7
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Feb 2022 07:41:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8HGcAaeTFGJxKQAAMHmgww
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Feb 2022 07:41:27 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: unify the error handling of btrfs_read_buffer()
Date:   Tue, 22 Feb 2022 15:41:20 +0800
Message-Id: <8524adadae487c2aecaf7bc13415ed0e43858109.1645515599.git.wqu@suse.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1645515599.git.wqu@suse.com>
References: <cover.1645515599.git.wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There is one oddball error handling of btrfs_read_buffer():

		ret = btrfs_read_buffer(tmp, gen, parent_level - 1, &first_key);
		if (!ret) {
			*eb_ret = tmp;
			return 0;
		}
		free_extent_buffer(tmp);
		btrfs_release_path(p);
		return -EIO;

While all other call sites check the error first.
Unify the behavior.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 9b2d9cd41676..0eecf98d0abb 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1438,13 +1438,13 @@ read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
 
 		/* now we're allowed to do a blocking uptodate check */
 		ret = btrfs_read_buffer(tmp, gen, parent_level - 1, &first_key);
-		if (!ret) {
-			*eb_ret = tmp;
-			return 0;
+		if (ret) {
+			free_extent_buffer(tmp);
+			btrfs_release_path(p);
+			return -EIO;
 		}
-		free_extent_buffer(tmp);
-		btrfs_release_path(p);
-		return -EIO;
+		*eb_ret = tmp;
+		return 0;
 	}
 
 	/*
-- 
2.35.1

