Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26AD430B97
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Mar 2026 12:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772367434; cv=none; b=KJV0YgnjrmjobYJdjDO4oLXrfS6AKFaapIMpWstg/bLAqCnMYCEP6KbGRe0fo0xHTvTt/Qi7erB1452P/NF+aN3PP/tpdbdnD/ZIn0P4HzxF8k2eGsXtKZmR/Fh3jcuTuaQLq+nVNPyBsezW66BC+KlQuiK3Afq9OR5FZ+TeXs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772367434; c=relaxed/simple;
	bh=aVMKVbg7J8AqNsFOqt1vQHnzImYq3Db/nw4Gs57TjbI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oUa32V4JoCRv/A4WpNyA04SUhmd8nzX4aOUbYJsvm3XSUwiCAj803AsFPXT5tTeqIeQ6Ck1XXt4BzuquMmKlMZ3wVWj1CniKyAehT85RG2eu/ga4nVD3AShEjoeUqWaSh2F0PY001jf1BV0L7IpUQGJDGR1htqRFWeqpCVSvlaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=rNd5fygB; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rNd5fygB"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772367432; x=1803903432;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aVMKVbg7J8AqNsFOqt1vQHnzImYq3Db/nw4Gs57TjbI=;
  b=rNd5fygBa1oPUpi7XGBZmuOebi6rjGGPMdzR7j0nCghE1QoA/JOVxEKw
   mQU3R+3MdSnq3TCuCbCuNUCMG3OlmuqG1cJEU0zW0BFpAtCqvln64Etfq
   POLwEBnqusgMKl+MUs+auDKLMY4+u1uStR+q+gHNKRLohu/0jSNBp06fm
   XjqKkfsbzEK8/ZOQjw1UjO365lezgYOswV1X6rjurVL/jo7y9o+b4NAey
   eVTnNeOqBNxFX05+TLA8XV6RxAI3G5arYkdmpVDiwE4rISYj8VUjBMYfV
   UfB1CTQiztEJQZWRhLQEVhaOYexnTVyY5WQpykZwxiTY50dJOcbcROycp
   g==;
X-CSE-ConnectionGUID: u8v8hq0YRweW+FkzOCkP0A==
X-CSE-MsgGUID: r08QSHFVSq238N7yBQae/Q==
X-IronPort-AV: E=Sophos;i="6.21,318,1763395200"; 
   d="scan'208";a="141282996"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2026 20:17:06 +0800
IronPort-SDR: 69a42e42_06nBoGKv/Mki6lg1ZYla5SgfLPIhRCXMU7i8pMXU0E4QsEm
 qe+6/tzllewuVd3CX/oIHeOJimSfplAjwD5P8lQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Mar 2026 04:17:06 -0800
WDCIronportException: Internal
Received: from wdap-scnfrotg6q.ad.shared (HELO shinmob.wdc.com) ([10.224.105.28])
  by uls-op-cesaip01.wdc.com with ESMTP; 01 Mar 2026 04:17:05 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: linux-btrfs@vger.kernel.org,
	David Sterba <dsterba@suse.com>
Cc: Naohiro Aota <Naohiro.Aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] btrfs: fix leak of kobject name for sub-group space_info
Date: Sun,  1 Mar 2026 21:17:04 +0900
Message-ID: <20260301121704.45115-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When create_space_info_sub_group() allocates elements of
space_info->sub_group[], kobject_init_and_add() is called for each
element via btrfs_sysfs_add_space_info_type(). However, when
check_removing_space_info() frees these elements, it does not call
btrfs_sysfs_remove_space_info() on them. As a result, kobject_put() is
not called and the associated kobj->name objects are leaked.

This memory leak is reproduced by running the blktests test case
zbd/009 on kernels built with CONFIG_DEBUG_KMEMLEAK. The kmemleak
feature reports the following error:

unreferenced object 0xffff888112877d40 (size 16):
  comm "mount", pid 1244, jiffies 4294996972
  hex dump (first 16 bytes):
    64 61 74 61 2d 72 65 6c 6f 63 00 c4 c6 a7 cb 7f  data-reloc......
  backtrace (crc 53ffde4d):
    __kmalloc_node_track_caller_noprof+0x619/0x870
    kstrdup+0x42/0xc0
    kobject_set_name_vargs+0x44/0x110
    kobject_init_and_add+0xcf/0x150
    btrfs_sysfs_add_space_info_type+0xfc/0x210 [btrfs]
    create_space_info_sub_group.constprop.0+0xfb/0x1b0 [btrfs]
    create_space_info+0x211/0x320 [btrfs]
    btrfs_init_space_info+0x15a/0x1b0 [btrfs]
    open_ctree+0x33c7/0x4a50 [btrfs]
    btrfs_get_tree.cold+0x9f/0x1ee [btrfs]
    vfs_get_tree+0x87/0x2f0
    vfs_cmd_create+0xbd/0x280
    __do_sys_fsconfig+0x3df/0x990
    do_syscall_64+0x136/0x1540
    entry_SYSCALL_64_after_hwframe+0x76/0x7e

To avoid the leak, call btrfs_sysfs_remove_space_info() instead of
kfree() for the elements.

Fixes: f92ee31e031c ("btrfs: introduce btrfs_space_info sub-group")
Closes: https://lore.kernel.org/linux-block/b9488881-f18d-4f47-91a5-3c9bf63955a5@wdc.com/
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 fs/btrfs/block-group.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index c284f48cfae4..35e65e277f53 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4548,7 +4548,7 @@ static void check_removing_space_info(struct btrfs_space_info *space_info)
 		for (int i = 0; i < BTRFS_SPACE_INFO_SUB_GROUP_MAX; i++) {
 			if (space_info->sub_group[i]) {
 				check_removing_space_info(space_info->sub_group[i]);
-				kfree(space_info->sub_group[i]);
+				btrfs_sysfs_remove_space_info(space_info->sub_group[i]);
 				space_info->sub_group[i] = NULL;
 			}
 		}
-- 
2.53.0

