Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE59CC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 05:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A52F5208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 05:31:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A52F5208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jp.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbeK0Q2X (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 11:28:23 -0500
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:47094 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728516AbeK0Q2X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 11:28:23 -0500
Received: from yt-mxoi1.gw.nic.fujitsu.com (unknown [192.168.229.67]) by mgwym04.jp.fujitsu.com with smtp
         id 0563_bbbf_02780552_6680_4b05_a649_3a852ed6a150;
        Tue, 27 Nov 2018 14:20:25 +0900
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 2FD9FAC014E
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 14:20:25 +0900 (JST)
Received: from g01jpexchyt37.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id 4CE476D66F4;
        Tue, 27 Nov 2018 14:20:24 +0900 (JST)
Received: from luna3.soft.fujitsu.com (10.124.196.199) by
 g01jpexchyt37.g01.fujitsu.local (10.128.193.67) with Microsoft SMTP Server id
 14.3.352.0; Tue, 27 Nov 2018 14:20:24 +0900
From:   Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     David Sterba <dsterba@suse.com>
Subject: [PATCH 8/8] btrfs-porgs: test: Add cli-test/009 to check subvolume list for both root and normal user
Date:   Tue, 27 Nov 2018 14:24:49 +0900
Message-ID: <0ed1cc0c1afd4447571680f848c0cc5d4ef8b96b.1543294426.git.misono.tomohiro@jp.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1543294426.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1543294426.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
X-TM-AS-MML: disable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 tests/cli-tests/009-subvolume-list/test.sh | 130 +++++++++++++++++++++
 1 file changed, 130 insertions(+)
 create mode 100755 tests/cli-tests/009-subvolume-list/test.sh

diff --git a/tests/cli-tests/009-subvolume-list/test.sh b/tests/cli-tests/009-subvolume-list/test.sh
new file mode 100755
index 00000000..50b7eb6b
--- /dev/null
+++ b/tests/cli-tests/009-subvolume-list/test.sh
@@ -0,0 +1,130 @@
+#!/bin/bash
+# test for "subvolume list" both for root and normal user
+
+source "$TEST_TOP/common"
+
+check_testuser
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+setup_root_helper
+prepare_test_dev
+
+
+# test if the ids returned by "sub list" match expected ids
+# $1  ... indicate run as root or test user
+# $2  ... PATH to be specified by sub list command
+# $3~ ... expected return ids
+test_list()
+{
+	local SUDO
+	if [ $1 -eq 1 ]; then
+		SUDO=$SUDO_HELPER
+	else
+		SUDO="sudo -u progs-test"
+	fi
+
+	result=$(run_check_stdout $SUDO "$TOP/btrfs" subvolume list "$2" | \
+		awk '{print $2}' | xargs | sort -n)
+
+	shift
+	shift
+	expected=($(echo "$@" | tr " " "\n" | sort -n))
+	expected=$(IFS=" "; echo "${expected[*]}")
+
+	if [ "$result" != "$expected" ]; then
+		echo "result  : $result"
+		echo "expected: $expected"
+		_fail "ids returned by sub list does not match expected ids"
+	fi
+}
+
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check_mount_test_dev
+cd "$TEST_MNT"
+
+# create subvolumes and directories and make some non-readable
+# by user 'progs-test'
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub1
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub1/subsub1
+run_check $SUDO_HELPER mkdir sub1/dir
+
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub2
+run_check $SUDO_HELPER mkdir -p sub2/dir/dirdir
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub2/dir/subsub2
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub2/dir/dirdir/subsubX
+
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub3
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub3/subsub3
+run_check $SUDO_HELPER mkdir sub3/dir
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub3/dir/subsubY
+run_check $SUDO_HELPER chmod o-r sub3
+
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub4
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub4/subsub4
+run_check $SUDO_HELPER mkdir sub4/dir
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub4/dir/subsubZ
+run_check $SUDO_HELPER setfacl -m u:progs-test:- sub4/dir
+
+run_check $SUDO_HELPER touch "file"
+
+# expected result for root at mount point:
+#
+# ID 256 gen 8 top level 5 path sub1
+# ID 258 gen 7 top level 256 path sub1/subsub1
+# ID 259 gen 10 top level 5 path sub2
+# ID 260 gen 9 top level 259 path sub2/dir/subsub2
+# ID 261 gen 10 top level 259 path sub2/dir/dirdir/subsubX
+# ID 262 gen 14 top level 5 path sub3
+# ID 263 gen 12 top level 262 path sub3/subsub3
+# ID 264 gen 13 top level 262 path sub3/dir/subsubY
+# ID 265 gen 17 top level 5 path sub4
+# ID 266 gen 15 top level 265 path sub4/subsub4
+# ID 267 gen 16 top level 265 path sub4/dir/subsubZ
+
+# check for root for both absolute/relative path
+all=(256 258 259 260 261 262 263 264 265 266 267)
+test_list 1 "$TEST_MNT" "${all[@]}"
+test_list 1 "$TEST_MNT/sub1" "256 258"
+run_mustfail "should raise invalid argument error" \
+	sudo "$TOP/btrfs" subvolume list "$TEST_MNT/sub1/dir"
+test_list 1 "$TEST_MNT/sub2" "259 260 261"
+test_list 1 "$TEST_MNT/sub3" "262 263 264"
+test_list 1 "$TEST_MNT/sub4" "265 266 267"
+run_mustfail "should fail for file" \
+	$SUDO_HELPER "$TOP/btrfs" subvolume list "$TEST_MNT/file"
+
+test_list 1 "." "${all[@]}"
+test_list 1 "sub1" "256 258"
+run_mustfail "should raise invalid argument error" \
+	sudo "$TOP/btrfs" subvolume list "sub1/dir"
+test_list 1 "sub2" "259 260 261"
+test_list 1 "sub3" "262 263 264"
+test_list 1 "sub4" "265 266 267"
+run_mustfail "should fail for file" \
+	$SUDO_HELPER "$TOP/btrfs" subvolume list "file"
+
+# check for normal user for both absolute/relative path
+test_list 0 "$TEST_MNT" "256 258 259 260 261 265 266"
+test_list 0 "$TEST_MNT/sub1" "256 258"
+run_mustfail "should raise invalid argument error" \
+	sudo "$TOP/btrfs" -u nobody subvolume list "$TEST_MNT/sub1/dir"
+test_list 0 "$TEST_MNT/sub2" "259 260 261"
+run_mustfail "should raise permission error" \
+	sudo -u nobody "$TOP/btrfs" subvolume list "$TEST_MNT/sub3"
+test_list 0 "$TEST_MNT/sub4" "265 266"
+run_mustfail "should fail for file" \
+	sudo -u nobody "$TOP/btrfs" subvolume list "$TEST_MNT/file"
+
+test_list 0 "." "256 258 259 260 261 265 266"
+run_mustfail "should raise permission error" \
+	sudo "$TOP/btrfs" -u nobody subvolume list "sub1/dir"
+test_list 0 "sub2" "259 260 261"
+run_mustfail "should raise permission error" \
+	sudo -u nobody "$TOP/btrfs" subvolume list "sub3"
+test_list 0 "sub4" "265 266"
+run_mustfail "should fail for file" \
+	sudo -u nobody "$TOP/btrfs" subvolume list "file"
+
+cd ..
+run_check_umount_test_dev
-- 
2.19.1


