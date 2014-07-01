Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:54832 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbaGAIAX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 04:00:23 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail.fujitsu.co.jp (Postfix) with ESMTP id CDE563EE0C5
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Jul 2014 17:00:21 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.nic.fujitsu.com [10.0.50.92])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 76325AC078F
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Jul 2014 17:00:20 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 11162E08014
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Jul 2014 17:00:20 +0900 (JST)
Message-ID: <53B26A87.4080800@jp.fujitsu.com>
Date: Tue, 1 Jul 2014 17:00:07 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <sandeen@redhat.com>, <rm@romanrm.net>,
        <koen@dominion.thruhere.net>
Subject: [PATCH v6] btrfs: label should not contain return char
References: <1400519071-5580-1-git-send-email-anand.jain@oracle.com> <1400813402-27474-1-git-send-email-anand.jain@oracle.com> <53B245AA.6060209@jp.fujitsu.com> <53B25931.2030200@cn.fujitsu.com>
In-Reply-To: <53B25931.2030200@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Wang,

(2014/07/01 15:46), Wang Shilong wrote:
> Hi Satoru and all,
> 
> I think there maybe a leftover issue.
> That is if we don't set label, in default it will output a blank line.
> 
> Steps to reproduce:
> 
> # mkfs.btrfs -f /dev/sdb
> # mount /dev/sdb
> # cat /sys/fs/btrfs/<uuid>/label -->an extra line will be outputed.
> 
> This is because in btrfs_label_show(), we did something like this directly:
> 
> return snprintf(buf, PAGE_SIZE, "%s\n", fs_info->super_copy->label);
> 
> Maybe we can have a check whether label is NULL before we output?
> otherwise,the
> extra blank line is outputed, IMO this is not so nice thing!

OK, how about it is? I also add a test for empty-label case.



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

echo "Test for empty label..." >&2
LINES="$(cat $LABELFILE | wc -l | awk '{print $1}')"
RET=0

if [ $LINES -eq 0 ] ; then
    echo '[PASS] Trailing \n is removed correctly.' >&2
else
    echo '[FAIL] Trailing \n still exists.' >&2
    RET=1
fi

echo "Test for non-empty label..." >&2

echo testlabel >$LABELFILE
LINES="$(cat $LABELFILE | wc -l | awk '{print $1}')"

if [ $LINES -eq 1 ] ; then
    echo '[PASS] Trailing \n is removed correctly.' >&2
else
    echo '[FAIL] Trailing \n still exists.' >&2
    RET=1
fi

exit $RET 
===============================================================================

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Tested-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 v6: fix empty-label case
 v5: tweak to be able to apply on the top of 402a0f4.
     add test program.
 v4: used memcpy and memset. Thanks David again
 v3: accepts review comments. Thanks David and Eric again
 v2: accepts review comments. Thanks Eric and Roman
---
 fs/btrfs/sysfs.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index df39458..68d1f63 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -363,7 +363,8 @@ static ssize_t btrfs_label_show(struct kobject *kobj,
 				struct kobj_attribute *a, char *buf)
 {
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
-	return snprintf(buf, PAGE_SIZE, "%s\n", fs_info->super_copy->label);
+	char *label = fs_info->super_copy->label;
+	return snprintf(buf, PAGE_SIZE, label[0] ? "%s\n" : "%s", label);
 }
 
 static ssize_t btrfs_label_store(struct kobject *kobj,
@@ -374,8 +375,15 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
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
@@ -383,7 +391,8 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 		return PTR_ERR(trans);
 
 	spin_lock(&root->fs_info->super_lock);
-	strcpy(fs_info->super_copy->label, buf);
+	memset(fs_info->super_copy->label, 0, BTRFS_LABEL_SIZE);
+	memcpy(fs_info->super_copy->label, buf, p_len);
 	spin_unlock(&root->fs_info->super_lock);
 	ret = btrfs_commit_transaction(trans, root);
 
-- 
1.9.3

