Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E3DBC433F5
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Mar 2022 09:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234800AbiC2Jqg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 05:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234769AbiC2Jqd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Mar 2022 05:46:33 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FBE1480C9
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2022 02:44:51 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 090471FD33
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2022 09:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1648547090; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=th3rqhH9yPDgVPgkzTkiogIo361wmiJLoVJSTGEBwQ4=;
        b=opUwOUBk1VqD73KuPbFzwOEgV4xb6WmcoGtHJPDMBkOOxbgDomtsF7mpuKNp45s7Eg3RyZ
        aMyoZkFAvxZsUH44naDWQSDRxJR8BrV8qYPLAMprFNfGVQkW1amEQomxHNjpAYeamj8dCP
        Eyvrs8Sc1FbPHpovw45NeHK9aUpGRj0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5D1EE13A7E
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2022 09:44:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EMkmChHVQmKqUAAAMHmgww
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2022 09:44:49 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: tests/fsck: add test case for data csum check on raid5
Date:   Tue, 29 Mar 2022 17:44:26 +0800
Message-Id: <ead45d5b0951c20819a5e50369583cbccdd6ea16.1648546873.git.wqu@suse.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648546873.git.wqu@suse.com>
References: <cover.1648546873.git.wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Previously 'btrfs check --check-data-csum' will report tons of false
alerts for RAID56.

Add a test case to make sure at least no such false alerts is reported.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../056-raid56-false-alerts/test.sh           | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100755 tests/fsck-tests/056-raid56-false-alerts/test.sh

diff --git a/tests/fsck-tests/056-raid56-false-alerts/test.sh b/tests/fsck-tests/056-raid56-false-alerts/test.sh
new file mode 100755
index 000000000000..b82e999c7740
--- /dev/null
+++ b/tests/fsck-tests/056-raid56-false-alerts/test.sh
@@ -0,0 +1,31 @@
+#!/bin/bash
+#
+# Make sure "btrfs check --check-data-csum" won't report false alerts on RAID56
+# data.
+#
+
+source "$TEST_TOP/common"
+
+check_prereq btrfs
+check_prereq mkfs.btrfs
+check_global_prereq losetup
+
+setup_loopdevs 3
+prepare_loopdevs
+dev1=${loopdevs[1]}
+TEST_DEV=$dev1
+
+setup_root_helper
+
+run_check $SUDO_HELPERS "$TOP/mkfs.btrfs" -f -m raid1 -d raid5 ${loopdevs[@]}
+run_check_mount_test_dev
+
+run_check $SUDO_HELPER dd if=/dev/urandom of="$TEST_MNT/file" bs=16K count=1 \
+	status=noxfer > /dev/null 2>&1
+
+run_check_umount_test_dev
+
+# Check data csum should not report false alerts
+run_check "$TOP/btrfs" check --check-data-csum "$dev1"
+
+cleanup_loopdevs
-- 
2.35.1

