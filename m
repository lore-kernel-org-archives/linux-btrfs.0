Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:47542 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab3IKSTA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Sep 2013 14:19:00 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 2DE0E7C0444
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 12:19:00 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id VCx5jzQr7wQbKzOM (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 12:18:59 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: drop dir i_size when adding new names on replay
Date: Wed, 11 Sep 2013 14:18:57 -0400
Message-ID: <1378923537-14722-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So if we have dir_index items in the log that means we also have the inode item
as well, which means that the inode's i_size is correct.  However when we
process dir_index'es we call btrfs_add_link() which will increase the
directory's i_size for the new entry.  So to fix this just drop the name len
size before we call btrfs_add_link() so the i_size ends out properly.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/tree-log.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c91309d..f0d34f5 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1497,6 +1497,12 @@ static noinline int insert_one_name(struct btrfs_trans_handle *trans,
 		iput(inode);
 		return -EIO;
 	}
+	/*
+	 * We need to drop the name_len since add_link we re-add the size.  If
+	 * we have the dir_index items then we had to have had the inode in the
+	 * log which means we have the correct i_size.
+	 */
+	btrfs_i_size_write(dir, dir->i_size - (name_len * 2));
 	ret = btrfs_add_link(trans, dir, inode, name, name_len, 1, index);
 
 	/* FIXME, put inode into FIXUP list */
-- 
1.7.7.6

