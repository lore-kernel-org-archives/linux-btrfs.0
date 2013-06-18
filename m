Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:10689 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752247Ab3FRDMT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Jun 2013 23:12:19 -0400
Message-ID: <51BFD061.4070404@cn.fujitsu.com>
Date: Tue, 18 Jun 2013 11:13:37 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix wrong csum clone when doing relocation
References: <51878334.4000807@cn.fujitsu.com> <20130614152712.GA28783@localhost.localdomain>
In-Reply-To: <20130614152712.GA28783@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fusionio.com>

Patch "Btrfs: remove btrfs_sector_sum structure" introduced a problem
that we copied the checksum value to the wrong address when doing
relocation.

The reason is:
It is very likely that one ordered extent has two or more checksum
structures to keep the relative checksum value, and ->bytenr in each
checksum structure should point to the start of its extent, not the
start of the ordered extent. Fix it.

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/relocation.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 35c0cf7..e3108e5 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4410,11 +4410,13 @@ int btrfs_reloc_clone_csums(struct inode *inode, u64 file_pos, u64 len)
 	if (ret)
 		goto out;
 
+	disk_bytenr = ordered->start;
 	while (!list_empty(&list)) {
 		sums = list_entry(list.next, struct btrfs_ordered_sum, list);
 		list_del_init(&sums->list);
 
-		sums->bytenr = ordered->start;
+		sums->bytenr = disk_bytenr;
+		disk_bytenr += sums->len;
 
 		btrfs_add_ordered_sum(inode, ordered, sums);
 	}
-- 
1.8.1.4

