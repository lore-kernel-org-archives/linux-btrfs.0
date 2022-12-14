Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB63CC10F1E
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Dec 2022 00:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237738AbiLNAKN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 19:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237689AbiLNAJr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Dec 2022 19:09:47 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC451ADAB;
        Tue, 13 Dec 2022 16:08:51 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4E4001F8B8;
        Wed, 14 Dec 2022 00:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670976530; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=SvyYZUy20KGYTsx17F2T1rr+WHmLLYlxkCipib8p3ts=;
        b=oub7lM7TD4IFl8XorlI3iSJrNt634adxOsZmBN3BRShuPktTrZRwd/vWTJq0kxnhYqvpIe
        ZuF2Uu/k1o03ru0y4mxzBJV5BIZx1n4cwtj/YFuAXRWcWyn1gqCnT9myH30uQcVvPkAZ7W
        wNpwZiy+9XwZsM4d0lAh/Dk++56j87g=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5BB151333E;
        Wed, 14 Dec 2022 00:08:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zFKoCBEUmWNQDAAAMHmgww
        (envelope-from <wqu@suse.com>); Wed, 14 Dec 2022 00:08:49 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH] check: call _check_dmesg even if the test case failed
Date:   Wed, 14 Dec 2022 08:08:31 +0800
Message-Id: <e8b3ba5973d9b24f33cbdbf99dc894f0ca656e02.1670976506.git.wqu@suse.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
When KEEP_DMESG=yes is specified, passed test cases will also keep their
$seqres.dmesg files.

However for failed test cases (caused by _fail calls), their dmesg files
are not saved at all:

 # rm -rf results/btrfs/219*
 # ./check btrfs/219
 # ls result/btrfs/219*
 results/btrfs/219.full  results/btrfs/219.out.bad

[CAUSE]
$seqres.dmesg is created (and later deleted depending on config) by
_check_dmesg() function.

But if a test case failed by calling _fail, then we no longer call
_check_dmesg(), thus no dmesg will be saved no matter whatever the
config is.

[FIX]
If the test case itself failed, then still call _check_dmesg() to either
save the dmesg unconditionally (KEEP_DMESG=yes case), or save the dmesg
if there is something wrong (default).

The dmesg can be pretty handy debug clue for both cases.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/check b/check
index d2e5129620bd..487da43537ad 100755
--- a/check
+++ b/check
@@ -950,6 +950,9 @@ function run_section()
 			_scratch_unmount 2> /dev/null
 			rm -f ${RESULT_DIR}/require_test*
 			rm -f ${RESULT_DIR}/require_scratch*
+			# Even we failed, there may be something interesting in
+			# dmesg which can help debugging.
+			_check_dmesg
 			tc_status="fail"
 		else
 			# The test apparently passed, so check for corruption
-- 
2.38.1

