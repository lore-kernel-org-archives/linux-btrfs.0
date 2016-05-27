Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19285 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756222AbcE0RIv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 13:08:51 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u4RH2U2S027743
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 10:08:51 -0700
Received: from maileast.thefacebook.com ([199.201.65.23])
	by mx0a-00082601.pphosted.com with ESMTP id 236qsnh5d8-1
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 10:08:51 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH] Btrfs: fill relocation block rsv after allocation
Date: Fri, 27 May 2016 13:08:26 -0400
Message-ID: <1464368906-4316-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we set the reloc control before we've reserved our space for relocation we
could race with a root being dirtied and not actually have space to do our init
reloc root.  So once we've allocated it and set it up go ahead and make our
reservation before setting the relocate control, that way anybody who tries to
do the reloc root init has space to use.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/relocation.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 61efa5f..959cb4e 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3870,6 +3870,7 @@ static noinline_for_stack
 int prepare_to_relocate(struct reloc_control *rc)
 {
 	struct btrfs_trans_handle *trans;
+	int ret;
 
 	rc->block_rsv = btrfs_alloc_block_rsv(rc->extent_root,
 					      BTRFS_BLOCK_RSV_TEMP);
@@ -3884,6 +3885,11 @@ int prepare_to_relocate(struct reloc_control *rc)
 	rc->reserved_bytes = 0;
 	rc->block_rsv->size = rc->extent_root->nodesize *
 			      RELOCATION_RESERVED_NODES;
+	ret = btrfs_block_rsv_refill(rc->extent_root,
+				     rc->block_rsv, rc->block_rsv->size,
+				     BTRFS_RESERVE_FLUSH_ALL);
+	if (ret)
+		return ret;
 
 	rc->create_reloc_tree = 1;
 	set_reloc_control(rc);
-- 
1.8.3.1

