Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F22F2C4742C
	for <linux-btrfs@archiver.kernel.org>; Mon, 16 Nov 2020 17:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 980F320B80
	for <linux-btrfs@archiver.kernel.org>; Mon, 16 Nov 2020 17:57:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=mpdesouza.com header.i=@mpdesouza.com header.b="rTkDUdG9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387756AbgKPR5H (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 16 Nov 2020 12:57:07 -0500
Received: from gateway20.websitewelcome.com ([192.185.62.46]:34273 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730857AbgKPR5G (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Nov 2020 12:57:06 -0500
X-Greylist: delayed 1416 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Nov 2020 12:57:05 EST
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 7AAE1400D85E1
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2020 11:30:19 -0600 (CST)
Received: from br540.hostgator.com.br ([108.179.252.180])
        by cmsmtp with SMTP
        id eiNZkr8FyYLDneiNZkuHn9; Mon, 16 Nov 2020 11:33:25 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=mpdesouza.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jUQSCKI6mTIM4Af6V5qrOX0YjAnsc4zom74o4Q8WaEM=; b=rTkDUdG9sM9KS7og3sJr1NwDcS
        g+jNncFqjwEALSU2rFyjJb2UG/ftL20IVZ04mRgIrdpoM9M1SbyHvJK1z9VWHFnznYMqdgs06wI0E
        X2/JxadOjLESLJ9mGw8kO59H3Fpc5a8pQwrxcjE56Cdi4FjwrV9TWBkL6BgIDoUw7wUlPJg3SYFp5
        8QmuL3l1/NzEOJ+BcAfGCLWwuh+4sBqEiSFXDZxxNwnUZXOFAS/NBfkNSoITnO/ohfyvs+Ds4HXmM
        OXYtGC51SVwIZWLE1CqFtdxhPJYLW8nB4jE5f6IiuJ8cmMOjs3eY1XPD5CTPQHc588F3DnXSjNoLz
        hY27jtYw==;
Received: from [191.249.68.105] (port=38938 helo=localhost.suse.de)
        by br540.hostgator.com.br with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <marcos@mpdesouza.com>)
        id 1keiNY-000wCw-HB; Mon, 16 Nov 2020 14:33:24 -0300
From:   Marcos Paulo de Souza <marcos@mpdesouza.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>, wqu@suse.com,
        dsterba@suse.com
Subject: [PATCH v2 3/3] btrfs-progs: tests: Add new logical-resolve test
Date:   Mon, 16 Nov 2020 14:32:49 -0300
Message-Id: <20201116173249.11847-4-marcos@mpdesouza.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201116173249.11847-1-marcos@mpdesouza.com>
References: <20201116173249.11847-1-marcos@mpdesouza.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - br540.hostgator.com.br
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mpdesouza.com
X-BWhitelist: no
X-Source-IP: 191.249.68.105
X-Source-L: No
X-Exim-ID: 1keiNY-000wCw-HB
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (localhost.suse.de) [191.249.68.105]:38938
X-Source-Auth: marcos@mpdesouza.com
X-Email-Count: 16
X-Source-Cap: bXBkZXNvNTM7bXBkZXNvNTM7YnI1NDAuaG9zdGdhdG9yLmNvbS5icg==
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Marcos Paulo de Souza <mpdesouza@suse.com>

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 .../test.sh                                   | 60 +++++++++++++++++++
 1 file changed, 60 insertions(+)
 create mode 100755 tests/misc-tests/042-inspect-internal-logical-resolve/test.sh

diff --git a/tests/misc-tests/042-inspect-internal-logical-resolve/test.sh b/tests/misc-tests/042-inspect-internal-logical-resolve/test.sh
new file mode 100755
index 00000000..adb52289
--- /dev/null
+++ b/tests/misc-tests/042-inspect-internal-logical-resolve/test.sh
@@ -0,0 +1,60 @@
+#!/bin/bash
+# Check if logical-resolve is resolving the paths correctly for different
+# subvolume tree configurations. This used to fails when a child subvolume was
+# mounted without the parent subvolume being accessible.
+
+source "$TEST_TOP/common"
+
+setup_root_helper
+prepare_test_dev
+
+check_prereq btrfs
+check_prereq mkfs.btrfs
+
+check_logical_offset_filename()
+{
+	local filename
+	local offset
+	offset="$1"
+	filename="$2"
+
+	out=$($TOP/btrfs inspect-internal logical-resolve "$offset" "$TEST_MNT")
+	if [ ! $filename = $out ]; then
+		_fail "logical-resolve failed. Expected $filename but returned $out"
+	fi
+}
+
+run_check_mkfs_test_dev
+run_check_mount_test_dev
+
+# create top subvolume called '@'
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create "$TEST_MNT/@"
+
+# create a file in eacch subvolume of @, and each file will have 2 EXTENT_DATA item
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create "$TEST_MNT/@/vol1"
+vol1id=$($SUDO_HELPER "$TOP/btrfs" inspect-internal rootid "$TEST_MNT/@/vol1")
+run_check $SUDO_HELPER dd if=/dev/zero bs=1M count=150 of="$TEST_MNT/@/vol1/file1"
+
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create "$TEST_MNT/@/vol1/subvol1"
+subvol1id=$($SUDO_HELPER "$TOP/btrfs" inspect-internal rootid "$TEST_MNT/@/vol1/subvol1")
+run_check $SUDO_HELPER dd if=/dev/zero bs=1M count=150 of="$TEST_MNT/@/vol1/subvol1/file2"
+
+"$TOP/btrfs" filesystem sync "$TEST_MNT"
+
+run_check_umount_test_dev
+
+$SUDO_HELPER mount -o subvol=/@/vol1 $TEST_DEV "$TEST_MNT"
+for offset in $("$TOP/btrfs" inspect-internal dump-tree -t "$vol1id" \
+		"$TEST_DEV" | awk '/disk byte/ { print $5 }'); do
+	check_logical_offset_filename "$offset" "$TEST_MNT/file1"
+done
+
+run_check_umount_test_dev
+
+$SUDO_HELPER mount -o subvol=/@/vol1/subvol1 $TEST_DEV "$TEST_MNT"
+for offset in $("$TOP/btrfs" inspect-internal dump-tree -t "$subvol1id" \
+		"$TEST_DEV" | awk '/disk byte/ { print $5 }'); do
+	check_logical_offset_filename "$offset" "$TEST_MNT/file2"
+done
+
+run_check_umount_test_dev
-- 
2.26.2

