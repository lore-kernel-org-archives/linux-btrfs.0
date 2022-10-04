Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39674C4332F
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Oct 2022 05:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiJDFfk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 01:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiJDFfj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Oct 2022 01:35:39 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18DA92CE37
        for <linux-btrfs@vger.kernel.org>; Mon,  3 Oct 2022 22:35:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CEED021903
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Oct 2022 05:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664861734; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=e7HrKWiDb24mphiY0igsf75rmYM3vSH2kGvT4l+KFGs=;
        b=OrbiaXS3LI7UHULyet5mvjOFshh+zhhPy13zjIQZ/Wb39YBWT7o60nZoX1LHu9w/0+fsJB
        6q3yViSsdqSvqt3aD+YMd2eTi8sYbVV2KRjRM+yaQjJY+uDtjAt1dCGMVzIKXxtQ0zLlsU
        gYSB/Vl1Iv6kfzYdAfRS0s/U0eKVypw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1557913A8F
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Oct 2022 05:35:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id R6EjMyXGO2NNCAAAMHmgww
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Oct 2022 05:35:33 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: convert-tests: skip 022 if no reiserfs support
Date:   Tue,  4 Oct 2022 13:35:16 +0800
Message-Id: <d457c6d6afe4788dfede27f9d5663cbd2bae91e4.1664861686.git.wqu@suse.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
If no reiserfs is enabled, convert-test/022 will fail like this:

    [TEST]   convert-tests.sh
    WARNING: reiserfs filesystem not listed in /proc/filesystems, some tests might be skipped
    [TEST/conv]   022-reiserfs-parent-ref
    Failed system wide prerequisities: mkreiserfs
    test failed for case 022-reiserfs-parent-ref

[CAUSE]
That test case just continue without checking if the kernel even has
reiserfs support.

[FIX]
Skip the test if no kernel support for reiserfs, just like convert/010.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/convert-tests/022-reiserfs-parent-ref/test.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tests/convert-tests/022-reiserfs-parent-ref/test.sh b/tests/convert-tests/022-reiserfs-parent-ref/test.sh
index 66aaff7b6502..3d8817b91b0a 100755
--- a/tests/convert-tests/022-reiserfs-parent-ref/test.sh
+++ b/tests/convert-tests/022-reiserfs-parent-ref/test.sh
@@ -3,6 +3,10 @@
 
 source "$TEST_TOP/common"
 
+if ! check_kernel_support_reiserfs >/dev/null; then
+	_not_run "no reiserfs support"
+fi
+
 setup_root_helper
 prepare_test_dev
 check_global_prereq mkreiserfs
-- 
2.37.3

