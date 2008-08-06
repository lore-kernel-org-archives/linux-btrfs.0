From: Yan Zheng <zheng.yan@oracle.com>
Subject: Re: Updated btrfslabel patch
Date: Wed, 06 Aug 2008 22:37:06 +0800
Message-ID: <4899B712.5030900@oracle.com>
References: <91a37e890808060718i3c6c4692g4be88444b632f0d1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Morey Roof <moreyroof@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <91a37e890808060718i3c6c4692g4be88444b632f0d1@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Morey Roof wrote:
> Here are the changes you wanted Chris.  I will work on an ioctl next.
>
> Thanks,
>
> Morey
>
>
> diff -r 3d9247dbeeec Makefile
> --- a/Makefile	Wed Jul 30 17:02:57 2008 -0400
> +++ b/Makefile	Wed Aug 06 08:14:26 2008 -0600
> @@ -15,7 +15,7 @@
>  bindir = $(prefix)/bin
>  LIBS=-luuid
>
> -progs = btrfsctl btrfsck mkfs.btrfs debug-tree btrfs-show btrfs-vol
> +progs = btrfsctl btrfsck mkfs.btrfs debug-tree btrfs-show btrfs-vol btrfslabel
>
>  # make C=1 to enable sparse
>  ifdef C
> @@ -45,6 +45,9 @@
>
>  btrfsck: $(objects) btrfsck.o bit-radix.o
>  	gcc $(CFLAGS) -o btrfsck btrfsck.o $(objects) bit-radix.o $(LDFLAGS) $(LIBS)
> +
> +btrfslabel: $(objects) btrfslabel.o
> +	gcc $(CFLAGS) -o btrfslabel btrfslabel.o $(objects) $(LDFLAGS) $(LIBS)
>
>  mkfs.btrfs: $(objects) mkfs.o
>  	gcc $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS)
> diff -r 3d9247dbeeec btrfslabel.c
> --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
> +++ b/btrfslabel.c	Wed Aug 06 08:14:26 2008 -0600
> @@ -0,0 +1,178 @@
> +/*
> + * Copyright (C) 2008 Morey Roof.   All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License v2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program; if not, write to the
> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> + * Boston, MA 021110-1307, USA.
> + */
> +
> +#define _GNU_SOURCE
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <fcntl.h>
> +#include <unistd.h>
> +#include <linux/fs.h>
> +#include <ctype.h>
> +#include "kerncompat.h"
> +#include "ctree.h"
> +#include "utils.h"
> +#include "version.h"
> +#include "disk-io.h"
> +#include "transaction.h"
> +
> +#define	MOUNTED				1
> +#define	UNMOUNTED			2
> +
> +static void print_usage(void)
> +{
> +	fprintf(stderr, "usage: btrfslabel dev [newlabel]\n");
> +	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
> +	exit(1);
> +}
> +
> +static void change_label_unmounted(char *dev, char *nLabel)
> +{
> +	struct btrfs_root *root;
> +	struct btrfs_trans_handle *trans;
> +	int ret;
> +
> +	/* Open the super_block at the default location
> +	 * and as read-write.
> +	 */
> +	root = open_ctree(dev, 0, 1);
> +
> +	strncpy(root->fs_info->super_copy.label, nLabel, BTRFS_LABEL_SIZE);
> +	trans = btrfs_start_transaction(root, 1);
> +
> +	ret = write_ctree_super(trans, root);
> +	if (ret)
> +	{
> +		fprintf(stderr, "FATAL: Failed to write new super block err %d\n", ret);
> +		exit(1);
> +	}
> +
> +	btrfs_commit_transaction(trans, root);
> +
> +	/* Now we close it since we are done. */
> +	close_ctree(root);
> +}
>   
Please don't call write_ctree_super directly. Btrfs super block should 
only be modified at
transaction committing time.  Putting the strncpy in the middle of 
btrfs_start_transaction
and btrfs_commit_transaction will be sufficient.

Regards
YZ
