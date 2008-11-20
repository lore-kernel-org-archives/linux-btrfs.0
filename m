From: "Liu Hui" <onlyflyer@gmail.com>
Subject: [PATH]Fix cow semantic in run_delalloc_nocow()
Date: Thu, 20 Nov 2008 17:02:56 +0800
Message-ID: <2c3b11250811200102v4491b00cq1eacb633e9b46848@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I found cow doesn't behave as expected in run_delalloc_nocow(). Now in
run_delalloc_now(), if it found a regular extent and the NODATACOW is
set, run_dealloc_now will cow the file range which is not as expected.
Also, if it find a regular extent and NODATACOW is not set(with
PREALLOC set), it will not take cow operation. So, the cow semantic is
opposite to the btrfs design.

I found the problem was introduced by fallocate(), so could Yan please
verify the fix? Much appreciated!

-- 
Thanks & Best Regards
Liu Hui
--

diff --git a/inode.c b/inode.c
index 2c77e09..5525594 100644
--- a/inode.c
+++ b/inode.c
@@ -1003,7 +1003,7 @@ next_slot:
                                goto out_check;
                        if (disk_bytenr == 0)
                                goto out_check;
-                       if (extent_type == BTRFS_FILE_EXTENT_REG && !force)
+                       if (extent_type == BTRFS_FILE_EXTENT_REG && force)
                                goto out_check;
                        if (btrfs_cross_ref_exist(trans, root, disk_bytenr))
                                goto out_check;
