From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Subject: Compile error of latest hotfix release of btrfs
Date: Mon, 03 Nov 2008 10:17:25 +0200
Message-ID: <490EB395.2020803@turknet.net.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I use Kubuntu-8.10 with custom kernel 2.6.28-rc2 and my gcc version is 
"gcc (Ubuntu 4.3.2-1ubuntu11) 4.3.2". When I tried to compile latest 
btrfs source, I got these error messages :

tarkane@tarkane:/media/disk/kernel-417d87e57364$ make
bash version.sh
make -C /lib/modules/`uname -r`/build M=`pwd` modules
make[1]: Entering directory `/usr/src/linux-2.6.28-rc2'
CC [M] /media/disk/kernel-417d87e57364/super.o
CC [M] /media/disk/kernel-417d87e57364/ctree.o
CC [M] /media/disk/kernel-417d87e57364/extent-tree.o
CC [M] /media/disk/kernel-417d87e57364/print-tree.o
CC [M] /media/disk/kernel-417d87e57364/root-tree.o
CC [M] /media/disk/kernel-417d87e57364/dir-item.o
CC [M] /media/disk/kernel-417d87e57364/hash.o
CC [M] /media/disk/kernel-417d87e57364/file-item.o
CC [M] /media/disk/kernel-417d87e57364/inode-item.o
CC [M] /media/disk/kernel-417d87e57364/inode-map.o
CC [M] /media/disk/kernel-417d87e57364/disk-io.o
CC [M] /media/disk/kernel-417d87e57364/transaction.o
CC [M] /media/disk/kernel-417d87e57364/bit-radix.o
CC [M] /media/disk/kernel-417d87e57364/inode.o
CC [M] /media/disk/kernel-417d87e57364/file.o
CC [M] /media/disk/kernel-417d87e57364/tree-defrag.o
CC [M] /media/disk/kernel-417d87e57364/extent_map.o
CC [M] /media/disk/kernel-417d87e57364/sysfs.o
CC [M] /media/disk/kernel-417d87e57364/struct-funcs.o
CC [M] /media/disk/kernel-417d87e57364/xattr.o
CC [M] /media/disk/kernel-417d87e57364/ordered-data.o
CC [M] /media/disk/kernel-417d87e57364/extent_io.o
/media/disk/kernel-417d87e57364/extent_io.c: In function 'extent_readpages':
/media/disk/kernel-417d87e57364/extent_io.c:2270: error: implicit 
declaration of function '__pagevec_lru_add'
make[2]: *** [/media/disk/kernel-417d87e57364/extent_io.o] Error 1
make[1]: *** [_module_/media/disk/kernel-417d87e57364] Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.28-rc2'
make: *** [all] Error 2
tarkane@tarkane:/media/disk/kernel-417d87e57364$



