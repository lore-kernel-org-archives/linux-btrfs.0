From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 06/10] btrfs: fix remap_file_pages error
Date: Thu, 20 May 2010 15:21:50 +0800
Message-ID: <4BF4E30E.3070402@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

when we use remap_file_pages() to remap a file, remap_file_pages always return
error. It is because btrfs didn't set VM_CAN_NONLINEAR for vma.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/file.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index d146dde..c874833 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1150,8 +1150,15 @@ static const struct vm_operations_struct btrfs_file_vm_ops = {
 
 static int btrfs_file_mmap(struct file	*filp, struct vm_area_struct *vma)
 {
-	vma->vm_ops = &btrfs_file_vm_ops;
+	struct address_space *mapping = filp->f_mapping;
+
+	if (!mapping->a_ops->readpage)
+		return -ENOEXEC;
+
 	file_accessed(filp);
+	vma->vm_ops = &btrfs_file_vm_ops;
+	vma->vm_flags |= VM_CAN_NONLINEAR;
+
 	return 0;
 }
 
-- 
1.6.5.2


