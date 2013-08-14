Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933332Ab3HNXRW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 19:17:22 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7ENHLN3005736
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:21 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r7ENHKSo017824
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:21 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 05/15] btrfs-progs: remove variable length stack arrays
Date: Wed, 14 Aug 2013 16:16:35 -0700
Message-Id: <1376522205-16992-6-git-send-email-zab@redhat.com>
In-Reply-To: <1376522205-16992-1-git-send-email-zab@redhat.com>
References: <1376522205-16992-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

sparse hates variable length array definitions on the stack:

 btrfs-show-super.c:155:21: warning: Variable length array is used.

And it's right to.  They're a fragile construct that doesn't handle bad
input well at all.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 btrfs-show-super.c |  2 +-
 volumes.c          | 16 ++++++++++++++--
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index c2e844d..0c3c73c 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -152,7 +152,7 @@ static int load_and_dump_sb(char *filename, int fd, u64 sb_bytenr)
 
 static int check_csum_sblock(void *sb, int csum_size)
 {
-	char result[csum_size];
+	char result[BTRFS_CSUM_SIZE];
 	u32 crc = ~(u32)0;
 
 	crc = btrfs_csum_data(NULL, (char *)sb + BTRFS_CSUM_SIZE,
diff --git a/volumes.c b/volumes.c
index e460bce..dba5b0e 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1779,12 +1779,15 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 			     struct btrfs_multi_bio *multi,
 			     u64 stripe_len, u64 *raid_map)
 {
-	struct extent_buffer *ebs[multi->num_stripes], *p_eb = NULL, *q_eb = NULL;
+	struct extent_buffer **ebs, *p_eb = NULL, *q_eb = NULL;
 	int i;
 	int j;
 	int ret;
 	int alloc_size = eb->len;
 
+	ebs = kmalloc(sizeof(*ebs) * multi->num_stripes, GFP_NOFS);
+	BUG_ON(!ebs);
+
 	if (stripe_len > alloc_size)
 		alloc_size = stripe_len;
 
@@ -1813,7 +1816,12 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 			q_eb = new_eb;
 	}
 	if (q_eb) {
-		void *pointers[multi->num_stripes];
+		void **pointers;
+
+		pointers = kmalloc(sizeof(*pointers) * multi->num_stripes,
+				   GFP_NOFS);
+		BUG_ON(!pointers);
+
 		ebs[multi->num_stripes - 2] = p_eb;
 		ebs[multi->num_stripes - 1] = q_eb;
 
@@ -1821,6 +1829,7 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 			pointers[i] = ebs[i]->data;
 
 		raid6_gen_syndrome(multi->num_stripes, stripe_len, pointers);
+		kfree(pointers);
 	} else {
 		ebs[multi->num_stripes - 1] = p_eb;
 		memcpy(p_eb->data, ebs[0]->data, stripe_len);
@@ -1838,5 +1847,8 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 		if (ebs[i] != eb)
 			kfree(ebs[i]);
 	}
+
+	kfree(ebs);
+
 	return 0;
 }
-- 
1.7.11.7

