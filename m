Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbaKYSSV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 13:18:21 -0500
Date: Tue, 25 Nov 2014 19:18:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Silvio Fricke <silvio.fricke@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: convert: use task for progress
 indication of metadata creation
Message-ID: <20141125181820.GO26471@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1415549388.git.silvio.fricke@gmail.com>
 <3c426a876eb5023a239c5e814f2fc05a7d3b84fc.1415571118.git.silvio.fricke@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3c426a876eb5023a239c5e814f2fc05a7d3b84fc.1415571118.git.silvio.fricke@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fixed locally, no need to resend the patch. JFYI the changes I made

On Sun, Nov 09, 2014 at 11:16:56PM +0100, Silvio Fricke wrote:
> ---
>  Documentation/btrfs-convert.txt |  2 ++
>  Makefile                        |  6 ++--
>  btrfs-convert.c                 | 64 +++++++++++++++++++++++++++++++++++++----
>  3 files changed, 64 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/btrfs-convert.txt b/Documentation/btrfs-convert.txt
> index 555fb35..9cc326c 100644
> --- a/Documentation/btrfs-convert.txt
> +++ b/Documentation/btrfs-convert.txt
> @@ -29,6 +29,8 @@ Roll back to ext2fs.
>  set filesystem label during conversion.
>  -L::
>  use label from the converted filesystem.
> +-p::
> +Show progress of convertation.

conversion

>  EXIT STATUS
>  -----------
> diff --git a/Makefile b/Makefile
> index 203597c..f76c6b2 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -8,7 +8,7 @@ AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -DBTRFS_FLAT_INCLUDES -fno-strict-alias
>  CFLAGS = -g -O1 -fno-strict-aliasing -rdynamic
>  objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
>  	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
> -	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
> +	  extent-cache.o extent_io.o volumes.o utils.o repair.o task-util.o \
>  	  qgroup.o raid6.o free-space-cache.o list_sort.o props.o \
>  	  ulist.o qgroup-verify.o backref.o
>  cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
> @@ -20,13 +20,13 @@ libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o \
>  		   uuid-tree.o utils-lib.o rbtree-utils.o
>  libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
>  	       crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
> -	       extent_io.h ioctl.h ctree.h btrfsck.h version.h
> +	       extent_io.h ioctl.h ctree.h btrfsck.h version.h task-util.h

It's not used in library, removed

>  TESTS = fsck-tests.sh convert-tests.sh
>  
>  INSTALL = install
>  prefix ?= /usr/local
>  bindir = $(prefix)/bin
> -lib_LIBS = -luuid -lblkid -lm -lz -llzo2 -L.
> +lib_LIBS = -luuid -lblkid -lm -lz -llzo2 -L. -pthread

dtto

>  libdir ?= $(prefix)/lib
>  incdir = $(prefix)/include/btrfs
>  LIBS = $(lib_LIBS) $(libs_static)
> diff --git a/btrfs-convert.c b/btrfs-convert.c
> index a544fc6..f8ba920 100644
> --- a/btrfs-convert.c
> +++ b/btrfs-convert.c
> @@ -38,6 +38,7 @@
>  #include "transaction.h"
>  #include "crc32c.h"
>  #include "utils.h"
> +#include "task-util.h"
>  #include <ext2fs/ext2_fs.h>
>  #include <ext2fs/ext2fs.h>
>  #include <ext2fs/ext2_ext_attr.h>
> @@ -45,6 +46,41 @@
>  #define INO_OFFSET (BTRFS_FIRST_FREE_OBJECTID - EXT2_ROOT_INO)
>  #define EXT2_IMAGE_SUBVOL_OBJECTID BTRFS_FIRST_FREE_OBJECTID
>  
> +struct private {

We'd still like to keep the namespace C++ clean, renamed to task_ctx

> +	uint32_t max_copy_inodes;
> +	uint32_t cur_copy_inodes;
> +	struct task_info *info;
> +};
> +
> +static void *print_copied_inodes(void *p)
> +{
> +	struct private *priv = p;
> +	const char work_indicator[] = { '.', 'o', 'O', 'o' };
> +	uint32_t count = 0;
> +
> +	task_period_start(priv->info, 1000 /* 1s */);
> +	while (1) {
> +		count++;
> +		printf("copy inodes [%c] [%10d/%10d]\r",
> +		       work_indicator[count % 4], priv->cur_copy_inodes,
> +		       priv->max_copy_inodes);
> +		fflush(stdout);
> +		task_period_wait(priv->info);
> +	}
> +
> +	return NULL;
> +}
> +
> +static int after_copied_inodes(void *p)
> +{
> +	struct private *priv = p;
> +
> +	printf("\n");
> +	task_period_stop(priv->info);
> +
> +	return 0;
> +}
> +
>  /*
>   * Open Ext2fs in readonly mode, read block allocation bitmap and
>   * inode bitmap into memory.
> @@ -1036,7 +1072,7 @@ fail:
>   * scan ext2's inode bitmap and copy all used inodes.
>   */
>  static int copy_inodes(struct btrfs_root *root, ext2_filsys ext2_fs,
> -		       int datacsum, int packing, int noxattr)
> +		       int datacsum, int packing, int noxattr, struct private *p)
>  {
>  	int ret;
>  	errcode_t err;
> @@ -1068,6 +1104,7 @@ static int copy_inodes(struct btrfs_root *root, ext2_filsys ext2_fs,
>  					objectid, ext2_fs, ext2_ino,
>  					&ext2_inode, datacsum, packing,
>  					noxattr);
> +		p->cur_copy_inodes++;
>  		if (ret)
>  			return ret;
>  		if (trans->blocks_used >= 4096) {
> @@ -2197,7 +2234,7 @@ err:
>  }
>  
>  static int do_convert(const char *devname, int datacsum, int packing, int noxattr,
> -	       int copylabel, const char *fslabel)
> +	       int copylabel, const char *fslabel, int progress)
>  {
>  	int i, ret;
>  	int fd = -1;
> @@ -2275,11 +2312,23 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
>  		goto fail;
>  	}
>  	printf("creating btrfs metadata.\n");
> -	ret = copy_inodes(root, ext2_fs, datacsum, packing, noxattr);
> +	struct private p = {

Declared at the beginning of the function, renamed from a single letter

> +		.max_copy_inodes = (ext2_fs->super->s_inodes_count - ext2_fs->super->s_free_inodes_count),
> +		.cur_copy_inodes = 0,
> +	};
> +	if (progress) {
> +		p.info = task_init(print_copied_inodes, after_copied_inodes, &p);
> +		task_start(p.info);
> +	}
> +	ret = copy_inodes(root, ext2_fs, datacsum, packing, noxattr, &p);
>  	if (ret) {
>  		fprintf(stderr, "error during copy_inodes %d\n", ret);
>  		goto fail;
>  	}
> +	if (progress) {
> +		task_stop(p.info);
> +		task_deinit(p.info);
> +	}
>  	printf("creating ext2fs image file.\n");
>  	ext2_root = link_subvol(root, "ext2_saved", EXT2_IMAGE_SUBVOL_OBJECTID);
>  	if (!ext2_root) {
> @@ -2703,6 +2752,7 @@ static void print_usage(void)
>  	printf("\t-r           roll back to ext2fs\n");
>  	printf("\t-l LABEL     set filesystem label\n");
>  	printf("\t-L           use label from converted fs\n");
> +	printf("\t-p           show converting progress\n");
>  }
>  
>  int main(int argc, char *argv[])
> @@ -2714,11 +2764,12 @@ int main(int argc, char *argv[])
>  	int rollback = 0;
>  	int copylabel = 0;
>  	int usage_error = 0;
> +	int progress = 0;
>  	char *file;
>  	char *fslabel = NULL;
>  
>  	while(1) {
> -		int c = getopt(argc, argv, "dinrl:L");
> +		int c = getopt(argc, argv, "dinrl:Lp");
>  		if (c < 0)
>  			break;
>  		switch(c) {
> @@ -2747,6 +2798,9 @@ int main(int argc, char *argv[])
>  			case 'L':
>  				copylabel = 1;
>  				break;
> +			case 'p':
> +				progress = 1;
> +				break;
>  			default:
>  				print_usage();
>  				return 1;
> @@ -2784,7 +2838,7 @@ int main(int argc, char *argv[])
>  	if (rollback) {
>  		ret = do_rollback(file);
>  	} else {
> -		ret = do_convert(file, datacsum, packing, noxattr, copylabel, fslabel);
> +		ret = do_convert(file, datacsum, packing, noxattr, copylabel, fslabel, progress);
>  	}
>  	if (ret)
>  		return 1;
> -- 
> 2.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
