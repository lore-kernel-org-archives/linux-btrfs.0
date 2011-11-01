From: Andrew Benton <b3nton@gmail.com>
Subject: btrfs-progs
Date: Tue, 1 Nov 2011 16:34:14 +0000
Message-ID: <20111101163414.b1b46d9c.b3nton@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I've just pulled btrfs-progs from the new git repo
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
However, when I come to make it fails like so:

gcc -Wp,-MMD,./.btrfsctl.o.d,-MT,btrfsctl.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -Os -c btrfsctl.c
gcc -g -Werror -Os -o btrfsctl btrfsctl.o ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o root-tree.o dir-item.o file-item.o inode-item.o inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o volumes.o utils.o btrfs-list.o btrfslabel.o  -luuid
ls mkfs.c
mkfs.c
gcc -Wp,-MMD,./.mkfs.o.d,-MT,mkfs.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -Os -c mkfs.c
mkfs.c:39:24: fatal error: attr/xattr.h: No such file or directory
compilation terminated.
make: *** [mkfs.o] Error 1
andy@eccles:~/btrfs-progs$ 

Is attr a required dependency of btrfs-progs now?
If I sed -i 's#attr/#sys/#' mkfs.c then it compiles and installs (I've
not tried to use any of the tools yet). Is it wise to do this? I don't
use any extended attributes, I don't have extended attributes enabled
in my kernel config, I have no wish to install libattr.

Please CC me as I'm not subscribed,

Andy
