Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24225 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaJBHRU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Oct 2014 03:17:20 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH v2] btrfs-progs: force overwrite should wipe stale SB
Date: Thu,  2 Oct 2014 07:22:09 +0800
Message-Id: <1412205729-20938-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <20141001112606.GO11436@twin.jikos.cz>
References: <20141001112606.GO11436@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(I am unable to reproduce the issue, tried to go back with progs versions
but still the same. So as of now this code remains untested, suggest to
wait till we have a reproducible test case).

Here is a test case which says it all..

mkfs.xfs -f $DEV
mkfs.btrfs -f $DEV
mount $DEV $MNT
mount: /dev/vdiskc: more filesystems detected. This should not happen,
       use -t <type> to explicitly specify the filesystem type or
       use wipefs(8) to clean up the device.

mount: you must specify the filesystem type

with this patch btrfs_prepare_device() also wipes old FS if any,
btrfs_prepare_device() is called after we have verified that
user has provided -f option.

v2: to satisfy the backward compatibility issue, replace
blkid_do_wipe() with local wipe function.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 utils.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/utils.c b/utils.c
index fb78dd6..5f21737 100644
--- a/utils.c
+++ b/utils.c
@@ -680,6 +680,42 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+static void btrfs_wipe_existing_sb(int fd)
+{
+	const char *off = NULL;
+	size_t len = 0;
+	loff_t offset;
+	char buf[BUFSIZ];
+	int rc = 0;
+	blkid_probe pr = NULL;
+
+	pr = blkid_new_probe();
+	if (!pr)
+		return;
+
+	if (blkid_probe_set_device(pr, fd, 0, 0))
+		goto out;
+
+	rc = blkid_probe_lookup_value(pr, "SBMAGIC_OFFSET", &off, NULL);
+	if (!rc)
+		rc = blkid_probe_lookup_value(pr, "SBMAGIC", NULL, &len);
+
+	if (rc || len == 0 || off == NULL)
+		goto out;
+
+	offset = strtoll(off, NULL, 10);
+	if (len > sizeof(buf))
+		len = sizeof(buf);
+
+	memset(buf, 0, len);
+	rc = pwrite(fd, buf, len, offset);
+	fsync(fd);
+
+out:
+	blkid_free_probe(pr);
+	return;
+}
+
 int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 			   u64 max_block_count, int *mixed, int discard)
 {
@@ -731,6 +767,8 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 		return 1;
 	}
 
+	btrfs_wipe_existing_sb(fd);
+
 	*block_count_ret = block_count;
 	return 0;
 }
-- 
2.0.0.153.g79dcccc

