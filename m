From: "yanhai zhu" <zhu.yanhai@gmail.com>
Subject: Re: Compile error of latest hotfix release of btrfs
Date: Mon, 3 Nov 2008 21:49:36 +0800
Message-ID: <977a2be20811030549l6b9a04edxafe7aec9729c3471@mail.gmail.com>
References: <490EB395.2020803@turknet.net.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Tarkan Erimer" <tarkan.erimer@turknet.net.tr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <490EB395.2020803@turknet.net.tr>
List-ID: <linux-btrfs.vger.kernel.org>

hello,
   try this.

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9b37ce6..eb01341 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2539,7 +2539,11 @@ int extent_readpages(struct extent_io_tree *tree,
                        /* open coding of lru_cache_add, also not exported */
                        page_cache_get(page);
                        if (!pagevec_add(&pvec, page))
+                       #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
+                               ____pagevec_lru_add(&pvec);
+                       #else
                                __pagevec_lru_add(&pvec);
+                       #endif
                        __extent_read_full_page(tree, page, get_extent,
                                                &bio, 0, &bio_flags);
                }

2008/11/3 Tarkan Erimer <tarkan.erimer@turknet.net.tr>:
> Hi,
>
> I use Kubuntu-8.10 with custom kernel 2.6.28-rc2 and my gcc version is "gcc
> (Ubuntu 4.3.2-1ubuntu11) 4.3.2". When I tried to compile latest btrfs
> source, I got these error messages :
>
> tarkane@tarkane:/media/disk/kernel-417d87e57364$ make
> bash version.sh
> make -C /lib/modules/`uname -r`/build M=`pwd` modules
> make[1]: Entering directory `/usr/src/linux-2.6.28-rc2'
> CC [M] /media/disk/kernel-417d87e57364/super.o
> CC [M] /media/disk/kernel-417d87e57364/ctree.o
> CC [M] /media/disk/kernel-417d87e57364/extent-tree.o
> CC [M] /media/disk/kernel-417d87e57364/print-tree.o
> CC [M] /media/disk/kernel-417d87e57364/root-tree.o
> CC [M] /media/disk/kernel-417d87e57364/dir-item.o
> CC [M] /media/disk/kernel-417d87e57364/hash.o
> CC [M] /media/disk/kernel-417d87e57364/file-item.o
> CC [M] /media/disk/kernel-417d87e57364/inode-item.o
> CC [M] /media/disk/kernel-417d87e57364/inode-map.o
> CC [M] /media/disk/kernel-417d87e57364/disk-io.o
> CC [M] /media/disk/kernel-417d87e57364/transaction.o
> CC [M] /media/disk/kernel-417d87e57364/bit-radix.o
> CC [M] /media/disk/kernel-417d87e57364/inode.o
> CC [M] /media/disk/kernel-417d87e57364/file.o
> CC [M] /media/disk/kernel-417d87e57364/tree-defrag.o
> CC [M] /media/disk/kernel-417d87e57364/extent_map.o
> CC [M] /media/disk/kernel-417d87e57364/sysfs.o
> CC [M] /media/disk/kernel-417d87e57364/struct-funcs.o
> CC [M] /media/disk/kernel-417d87e57364/xattr.o
> CC [M] /media/disk/kernel-417d87e57364/ordered-data.o
> CC [M] /media/disk/kernel-417d87e57364/extent_io.o
> /media/disk/kernel-417d87e57364/extent_io.c: In function 'extent_readpages':
> /media/disk/kernel-417d87e57364/extent_io.c:2270: error: implicit
> declaration of function '__pagevec_lru_add'
> make[2]: *** [/media/disk/kernel-417d87e57364/extent_io.o] Error 1
> make[1]: *** [_module_/media/disk/kernel-417d87e57364] Error 2
> make[1]: Leaving directory `/usr/src/linux-2.6.28-rc2'
> make: *** [all] Error 2
> tarkane@tarkane:/media/disk/kernel-417d87e57364$
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Zhu Yanhai
