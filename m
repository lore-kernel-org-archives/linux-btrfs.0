Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68AEAC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 11:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FBBB20828
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 11:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbfCSLEI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 07:04:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:42726 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726782AbfCSLEI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 07:04:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 10276AD47;
        Tue, 19 Mar 2019 11:04:07 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, guaneryu@gmail.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] btrfs: Extend btrfs/003 device removal test
Date:   Tue, 19 Mar 2019 13:04:04 +0200
Message-Id: <20190319110404.9707-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When a device is deleted/removed from a btrfs filesystem the kernel
ensures all superblocks on said device are zeroed out. Test for this
behavior. Since btrfs inspect-internal dump-super always return success
I cannot test for the return value of the command. Instead there are 2
cases to handle:

    1. When the device is smaller than the requested super block copy, i.e.
    super block copy 2 resides at 256GB. In such cases btrfs command just
    returns blank screen

    2. When the device is removed and a valid offset of the super block is
    queried btrfs command returns a textual error to stderr.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
V2: 
	* properly assign the return value of the last command expression to ret

 tests/btrfs/003 | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tests/btrfs/003 b/tests/btrfs/003
index 22aa57aad0b9..a805826ce891 100755
--- a/tests/btrfs/003
+++ b/tests/btrfs/003
@@ -161,6 +161,14 @@ _test_remove()
 	dev_del=`echo ${SCRATCH_DEV_POOL} | awk '{print $NF}'`
 	$BTRFS_UTIL_PROG device delete $dev_del $SCRATCH_MNT || _fail "btrfs device delete failed"
 	$BTRFS_UTIL_PROG filesystem show $SCRATCH_DEV 2>&1 | grep $dev_del >> $seqres.full && _fail "btrfs still shows the deleted dev"
+	for i in {0..2}; do
+		local output=$($BTRFS_UTIL_PROG inspect-internal dump-super -s $i $dev_del 2>&1)
+		$BTRFS_UTIL_PROG inspect-internal dump-super -s $i $dev_del 2>&1 | grep -q "bad magic"
+		ret=$?
+		if [[ "$output" != "" && $ret -eq 1 ]]; then
+			_fail "Delete dev superblocks not scratched"
+		fi
+	done
 	_scratch_unmount
 }
 
-- 
2.7.4

