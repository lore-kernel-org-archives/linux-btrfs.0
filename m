Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26207 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab3AKJZX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 04:25:23 -0500
Message-ID: <50EFDBDD.1040104@oracle.com>
Date: Fri, 11 Jan 2013 17:31:09 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.de>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        ablock84@googlemail.com
Subject: Re: [PATCH 2/3] btrfs-progs: libify some parts of btrfs-progs
References: <1357681304-2978-1-git-send-email-mfasheh@suse.de> <1357681304-2978-3-git-send-email-mfasheh@suse.de>
In-Reply-To: <1357681304-2978-3-git-send-email-mfasheh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Mark,

test case :
  make (Do not run make all)
  make install

generates the following error..

install -m755 -d /usr/local/lib
install libbtrfs.so.1.0 libbtrfs.so.1 libbtrfs.so /usr/local/lib
install: cannot stat `libbtrfs.so.1.0': No such file or directory
install: cannot stat `libbtrfs.so.1': No such file or directory
install: cannot stat `libbtrfs.so': No such file or directory
make: *** [install] Error 1


Thanks, Anand


On 01/09/2013 05:41 AM, Mark Fasheh wrote:
> External software wanting to use the functionality provided by the btrfs
> send ioctl has a hard time doing so without replicating tons of work. Of
> particular interest are functions like btrfs_read_and_process_send_stream()
> and subvol_uuid_search(). As that functionality requires a bit more than
> just send-stream.c and send-utils.c we have to pull in some other parts of
> the progs package.
>
> This patch adds code to the Makefile and headers to create a library,
> libbtrfs which the btrfs command now links to.
>
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> ---
>   Makefile       |   38 ++++++++++++++++++++++++++++----------
>   btrfs-list.h   |    4 ++++
>   crc32c.h       |    4 ++++
>   ctree.h        |    9 +++++++++
>   extent-cache.h |    6 ++++++
>   extent_io.h    |    7 +++++++
>   radix-tree.h   |    4 ++++
>   rbtree.h       |    4 ++++
>   send-utils.h   |    5 +++++
>   9 files changed, 71 insertions(+), 10 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index 4894903..29c63b1 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,14 +1,17 @@
>   CC = gcc
> -AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2
> -CFLAGS = -g -O1
> +AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -DBTRFS_FLAT_INCLUDES
> +CFLAGS = -g -O1 -fPIC
>   objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
> -	  root-tree.o dir-item.o file-item.o inode-item.o \
> -	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
> -	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o \
> -	  send-stream.o send-utils.o qgroup.o
> +	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
> +	  extent-cache.o extent_io.o volumes.o utils.o btrfslabel.o repair.o \
> +	  qgroup.o
>   cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
>   	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
>   	       cmds-quota.o cmds-qgroup.o
> +libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o
> +libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
> +	       crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
> +	       extent_io.h ioctl.h ctree.h
>
>   CHECKFLAGS= -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
>   	    -Wuninitialized -Wshadow -Wundef
> @@ -17,13 +20,18 @@ DEPFLAGS = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
>   INSTALL = install
>   prefix ?= /usr/local
>   bindir = $(prefix)/bin
> -LIBS=-luuid -lm
> +libdir = $(prefix)/lib
> +incdir = $(prefix)/include/btrfs
> +LIBS=-luuid -lm -L. -lbtrfs
>   RESTORE_LIBS=-lz
>
>   progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
>   	btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
>   	btrfs-find-root btrfs-restore btrfstune
>
> +libs = libbtrfs.so.1.0 libbtrfs.so.1 libbtrfs.so
> +headers = $(libbtrfs_headers)
> +
>   # make C=1 to enable sparse
>   ifdef C
>   	check = sparse $(CHECKFLAGS)
> @@ -36,11 +44,16 @@ endif
>   	$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
>
>
> -all: version $(progs) manpages
> +all: version $(libs) $(progs) manpages
>
>   version:
>   	bash version.sh
>
> +$(libs): $(libbtrfs_objects) send.h
> +	$(CC) $(CFLAGS) $(libbtrfs_objects) -shared -Wl,-soname,libbtrfs.so.1 -o libbtrfs.so.1.0
> +	ln -sf libbtrfs.so.1.0 libbtrfs.so.1
> +	ln -sf libbtrfs.so.1.0 libbtrfs.so
> +
>   btrfs: $(objects) btrfs.o help.o common.o $(cmds_objects)
>   	$(CC) $(CFLAGS) -o btrfs btrfs.o help.o common.o $(cmds_objects) \
>   		$(objects) $(LDFLAGS) $(LIBS) -lpthread
> @@ -109,12 +122,17 @@ install-man:
>   	cd man; $(MAKE) install
>
>   clean :
> -	rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs-select-super \
> -	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test version.h
> +	rm -f $(progs) $(libs) cscope.out *.o .*.d btrfs-convert btrfs-image \
> +	      btrfs-select-super btrfs-zero-log btrfstune dir-test ioctl-test \
> +	      quick-test version.h
>   	cd man; $(MAKE) clean
>
>   install: $(progs) install-man
>   	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
>   	$(INSTALL) $(progs) $(DESTDIR)$(bindir)
> +	$(INSTALL) -m755 -d $(DESTDIR)$(libdir)
> +	$(INSTALL) $(libs) $(DESTDIR)$(libdir)
> +	$(INSTALL) -m755 -d $(DESTDIR)$(incdir)
> +	$(INSTALL) $(headers) $(DESTDIR)$(incdir)
>
>   -include .*.d
> diff --git a/btrfs-list.h b/btrfs-list.h
> index cde4b3c..da6bf1c 100644
> --- a/btrfs-list.h
> +++ b/btrfs-list.h
> @@ -16,7 +16,11 @@
>    * Boston, MA 021110-1307, USA.
>    */
>
> +#if BTRFS_FLAT_INCLUDES
>   #include "kerncompat.h"
> +#else
> +#include <btrfs/kerncompat.h>
> +#endif /* BTRFS_FLAT_INCLUDES */
>
>   struct root_info;
>
> diff --git a/crc32c.h b/crc32c.h
> index 7f12e77..c552ef6 100644
> --- a/crc32c.h
> +++ b/crc32c.h
> @@ -19,7 +19,11 @@
>   #ifndef __CRC32C__
>   #define __CRC32C__
>
> +#if BTRFS_FLAT_INCLUDES
>   #include "kerncompat.h"
> +#else
> +#include <btrfs/kerncompat.h>
> +#endif /* BTRFS_FLAT_INCLUDES */
>
>   u32 crc32c_le(u32 seed, unsigned char const *data, size_t length);
>   void crc32c_optimization_init(void);
> diff --git a/ctree.h b/ctree.h
> index 293b24f..7a1ffce 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -19,12 +19,21 @@
>   #ifndef __BTRFS__
>   #define __BTRFS__
>
> +#if BTRFS_FLAT_INCLUDES
>   #include "list.h"
>   #include "kerncompat.h"
>   #include "radix-tree.h"
>   #include "extent-cache.h"
>   #include "extent_io.h"
>   #include "ioctl.h"
> +#else
> +#include <btrfs/list.h>
> +#include <btrfs/kerncompat.h>
> +#include <btrfs/radix-tree.h>
> +#include <btrfs/extent-cache.h>
> +#include <btrfs/extent_io.h>
> +#include <btrfs/ioctl.h>
> +#endif /* BTRFS_FLAT_INCLUDES */
>
>   struct btrfs_root;
>   struct btrfs_trans_handle;
> diff --git a/extent-cache.h b/extent-cache.h
> index 7f2f2a6..4cd0f79 100644
> --- a/extent-cache.h
> +++ b/extent-cache.h
> @@ -18,8 +18,14 @@
>
>   #ifndef __PENDING_EXTENT__
>   #define __PENDING_EXTENT__
> +
> +#if BTRFS_FLAT_INCLUDES
>   #include "kerncompat.h"
>   #include "rbtree.h"
> +#else
> +#include <btrfs/kerncompat.h>
> +#include <btrfs/rbtree.h>
> +#endif /* BTRFS_FLAT_INCLUDES */
>
>   struct cache_tree {
>   	struct rb_root root;
> diff --git a/extent_io.h b/extent_io.h
> index a5d6bf0..4553859 100644
> --- a/extent_io.h
> +++ b/extent_io.h
> @@ -18,9 +18,16 @@
>
>   #ifndef __EXTENTMAP__
>   #define __EXTENTMAP__
> +
> +#if BTRFS_FLAT_INCLUDES
>   #include "kerncompat.h"
>   #include "extent-cache.h"
>   #include "list.h"
> +#else
> +#include <btrfs/kerncompat.h>
> +#include <btrfs/extent-cache.h>
> +#include <btrfs/list.h>
> +#endif /* BTRFS_FLAT_INCLUDES */
>
>   #define EXTENT_DIRTY 1
>   #define EXTENT_WRITEBACK (1 << 1)
> diff --git a/radix-tree.h b/radix-tree.h
> index d99ea7e..bf96d83 100644
> --- a/radix-tree.h
> +++ b/radix-tree.h
> @@ -37,7 +37,11 @@
>   #ifndef _LINUX_RADIX_TREE_H
>   #define _LINUX_RADIX_TREE_H
>
> +#if BTRFS_FLAT_INCLUDES
>   #include "kerncompat.h"
> +#else
> +#include <btrfs/kerncompat.h>
> +#endif /* BTRFS_FLAT_INCLUDES */
>
>   #define RADIX_TREE_MAX_TAGS 2
>
> diff --git a/rbtree.h b/rbtree.h
> index bed054d..b636ddd 100644
> --- a/rbtree.h
> +++ b/rbtree.h
> @@ -93,7 +93,11 @@ static inline struct page * rb_insert_page_cache(struct inode * inode,
>
>   #ifndef	_LINUX_RBTREE_H
>   #define	_LINUX_RBTREE_H
> +#if BTRFS_FLAT_INCLUDES
>   #include "kerncompat.h"
> +#else
> +#include <btrfs/kerncompat.h>
> +#endif /* BTRFS_FLAT_INCLUDES */
>   struct rb_node
>   {
>   	unsigned long  rb_parent_color;
> diff --git a/send-utils.h b/send-utils.h
> index da407eb..8040c50 100644
> --- a/send-utils.h
> +++ b/send-utils.h
> @@ -18,8 +18,13 @@
>   #ifndef SEND_UTILS_H_
>   #define SEND_UTILS_H_
>
> +#if BTRFS_FLAT_INCLUDES
>   #include "ctree.h"
>   #include "rbtree.h"
> +#else
> +#include <btrfs/ctree.h>
> +#include <btrfs/rbtree.h>
> +#endif /* BTRFS_FLAT_INCLUDES */
>
>   enum subvol_search_type {
>   	subvol_search_by_root_id,
>
