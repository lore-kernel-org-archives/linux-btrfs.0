From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: btrfs: fix race in reada
Date: Mon, 30 Apr 2012 14:11:28 +0300
Message-ID: <20120430111128.GA22734@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: sensille@gmx.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Arne Jansen,

The patch 8c9c2bf7a3c4: "btrfs: fix race in reada" from Feb 25, 2012, 
leads to the following warning:
fs/btrfs/reada.c:308 reada_find_zone()
	 warn: 'zone' was already freed.

@@ -307,13 +302,15 @@ again:
        ret = radix_tree_insert(&dev->reada_zones,
                                (unsigned long)(zone->end >> PAGE_CACHE_SHIFT),
                                zone);
-       spin_unlock(&fs_info->reada_lock);
 
-       if (ret) {
+       if (ret == -EEXIST) {
                kfree(zone);
                ^^^^^^^^^^^
Freed here.

-               looped = 1;
-               goto again;
+               ret = radix_tree_gang_lookup(&dev->reada_zones, (void **)&zone,
                                                                          ^^^^
Use after free inside radix_tree_gang_lookup() function.

+                                            logical >> PAGE_CACHE_SHIFT, 1);
+               if (ret == 1)
+                       kref_get(&zone->refcnt);
        }
+       spin_unlock(&fs_info->reada_lock);
 
        return zone;
 }

regards,
dan carpenter

