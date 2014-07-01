Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:58293 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaGAFXS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 01:23:18 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail.fujitsu.co.jp (Postfix) with ESMTP id 4E9693EE0C2
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Jul 2014 14:23:16 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 5551AAC074B
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Jul 2014 14:23:15 +0900 (JST)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id F09731DB803B
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Jul 2014 14:23:14 +0900 (JST)
Message-ID: <53B245AA.6060209@jp.fujitsu.com>
Date: Tue, 1 Jul 2014 14:22:50 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <sandeen@redhat.com>, <rm@romanrm.net>,
        <koen@dominion.thruhere.net>
Subject: [PATCH v5] btrfs: label should not contain return char
References: <1400519071-5580-1-git-send-email-anand.jain@oracle.com> <1400813402-27474-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1400813402-27474-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although Anand once sent the following two patches,

 - [PATCH 1/2 v4] btrfs: label should not contain return char
 - [PATCH 2/2 v4] btrfs: usage error should not be logged into system log

only the latter patch was merged to mason/for-linus and 3.16-rc3
as 402a0f4 (by accident?). It results in that the former patch can't
be cleanly applied to 3.16-rc3.

I fixed this problem, wrote a reproducer, and tested it.

Test Result:
3.16-rc3 w/o this patch: fail
3.16-rc3 w/ this patch:  pass



Subject: [PATCH v5] btrfs: label should not contain return char

From: Anand Jain <Anand.Jain@oracle.com>

generally if you use
  echo "test" > /sys/fs/btrfs/<fsid>/label
it would introduce return char at the end and it can not
be part of the label. The correct command is
  echo -n "test" > /sys/fs/btrfs/<fsid>/label

This patch will check for this user error

reproducer.sh:
===============================================================================
#!/bin/bash

TEST_DEV=/dev/vdb
TEST_DIR=/home/sat/mnt

umount /home/sat/mnt

mkfs.btrfs -f $TEST_DEV
UUID=$(btrfs fi show $TEST_DEV | head -1 | sed -e 's/.*uuid: \([-0-9a-z]*\)$/\1/')
mount $TEST_DEV $TEST_DIR
LABELFILE=/sys/fs/btrfs/$UUID/label

echo testlabel >$LABELFILE
LINES="$(cat $LABELFILE | wc -l | awk '{print $1}')"

RET=1
if [ $LINES -eq 1 ] ; then
    echo '[PASS] Trailing \n is removed correctly.' >&2
    RET=0
else
    echo '[FAIL] Trailing \n still exists.' >&2
fi

exit $RET
===============================================================================

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Tested-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 v5: tweak to be able to apply on the top of 402a0f4.
     add test program.
 v4: used memcpy and memset. Thanks David again
 v3: accepts review comments. Thanks David and Eric again
 v2: accepts review comments. Thanks Eric and Roman

---
 fs/btrfs/sysfs.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index df39458..dcae61a 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -374,8 +374,15 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = fs_info->fs_root;
 	int ret;
+	size_t p_len;
 
-	if (len >= BTRFS_LABEL_SIZE)
+	/*
+	 * p_len is the len until the first occurrence of either
+	 * '\n' or '\0'
+	 */
+	p_len = strcspn(buf, "\n");
+
+	if (p_len >= BTRFS_LABEL_SIZE)
 		return -EINVAL;
 
 	trans = btrfs_start_transaction(root, 0);
@@ -383,7 +390,8 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 		return PTR_ERR(trans);
 
 	spin_lock(&root->fs_info->super_lock);
-	strcpy(fs_info->super_copy->label, buf);
+	memset(fs_info->super_copy->label, 0, BTRFS_LABEL_SIZE);
+	memcpy(fs_info->super_copy->label, buf, p_len);
 	spin_unlock(&root->fs_info->super_lock);
 	ret = btrfs_commit_transaction(trans, root);
 
-- 
1.9.3

