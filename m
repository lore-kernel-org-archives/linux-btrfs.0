From: "Liu Hui" <onlyflyer@gmail.com>
Subject: Re: [PATH]Fix cow semantic in run_delalloc_nocow()
Date: Thu, 20 Nov 2008 21:47:05 +0800
Message-ID: <2c3b11250811200547x4902686cicf1d7604d101275d@mail.gmail.com>
References: <2c3b11250811200102v4491b00cq1eacb633e9b46848@mail.gmail.com>
	 <3d0408630811200530h254ad68ej75df9f6b73745a40@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Yan Zheng" <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630811200530h254ad68ej75df9f6b73745a40@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Ok, this is the new patch.

-- 
Thanks & Best Regards
Liu Hui
--

diff --git a/inode.c b/inode.c
index 2c77e09..5e3789f 100644
--- a/inode.c
+++ b/inode.c
@@ -1114,10 +1114,10 @@ static int run_delalloc_range(struct inode
*inode, struct page *locked_page,
        if (btrfs_test_opt(root, NODATACOW) ||
            btrfs_test_flag(inode, NODATACOW))
                ret = run_delalloc_nocow(inode, locked_page, start, end,
-                                        page_started, 0, nr_written);
+                                        page_started, 1, nr_written);
        else if (btrfs_test_flag(inode, PREALLOC))
                ret = run_delalloc_nocow(inode, locked_page, start, end,
-                                        page_started, 1, nr_written);
+                                        page_started, 0, nr_written);
        else
                ret = cow_file_range_async(inode, locked_page, start, end,
                                     page_started, nr_written);
