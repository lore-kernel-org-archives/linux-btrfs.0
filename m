Return-Path: <SRS0=c/cW=SL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD3D8C10F0E
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 09:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 748EE2084C
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 09:34:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Z3oxGYDI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfDIJek (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Apr 2019 05:34:40 -0400
Received: from mout.gmx.net ([212.227.15.15]:46133 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbfDIJej (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Apr 2019 05:34:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554802471;
        bh=9gW0C9SvYKcFKH6Aa4bMoCnXGWPXUWSieq2Jl6j1V58=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Z3oxGYDI8pa/UgfGD03eNT4ZM2kULBQGayhBRqhEfFjDGyLvJ1E+WQTlezKasJyzb
         jcZuB2fhmIisqC2G/wIvnPpa0U9SPqj9x8coWnJJZkr+2n/3AoI/sBbdedMmFgR+YH
         6K8QPzY3WjGvGj1FcbEhyumnsjXmHCUoaX3Fm7Bs=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.2.108] ([173.82.105.236]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lxxw4-1gqk0v3I3A-015HlO; Tue, 09
 Apr 2019 11:34:31 +0200
Subject: Re: [PATCH 1/2] btrfs-progs: add 'btrfs inspect-internal csum-dump'
 command
To:     Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20190408133146.21355-1-jthumshirn@suse.de>
 <20190408133146.21355-2-jthumshirn@suse.de>
From:   Su Yue <Damenly_Su@gmx.com>
Message-ID: <adb47c0d-6c71-3b34-7f20-7764bc16e036@gmx.com>
Date:   Tue, 9 Apr 2019 17:34:22 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190408133146.21355-2-jthumshirn@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Aj0qQ06ctwz4nzoRODPRUBPPVeW7GTLzRPcvYzdff7SWrosVZLH
 iJL6YWL2tKDmHtzzGpIRbMmVRk8MncxqFpS7YvIq1armFHj0Cfo9griiobSQBkdw8GplqD/
 n7gaTeKBHBA1MXkbgT7XiZw7ZP0IbrxTS6d0Z8KcjqMAHadqYQ/M9YRCJ7e6ddw+zaJrgBv
 PrvYYdb+bXx3SRYsyoDbQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Bv7ZVNp2EDk=:bFMEorJXEd2OUWmHiuGbVs
 lSDHd4WwQIsed+8a6jKwE9qs4ZXAGdfX7Br7dbGGyydS8e76rVvv7BmpFkcoUehBccnlpPraT
 9xUSAm4C6rC2GzxabRMiIZXVMduxBUAbF0l1SCx6R1oMC/0/H5D90Vb51GLdAuzglxY7iYOkk
 VsRAQEEFayMfXiyFVG99wY1up4DkJ1CL7G7v/bzyefOcKS0G59oZOBejgBSkTW+fFNXB8uptf
 s0yzAcwIVNihFUjmLCJfBsJ3ODL93ePPxx5GgFJvpJtwX02s7N1V6y4Ipxjosoc+yKN8fiSr9
 emn6CUSvKTRrhIQ0VfdsiqKlVnRVPLKP2KrerM+Z2YNCn0C0Bg5yf456HLBLALq7npFwYmV9M
 4NsXcR8cMsAomL/vAxA0CVoBXxvHF8+AWT/SAvcTF79nBTUbzWdBkauv7UIH/HgnX3yR83jtJ
 FupswaLrjf/2xa4iCIoPL3xYQ4/JT41r5aEJ2aC3prics6D19wWfAtOTxPG5d7AnJWPwdfiKs
 aI+z8O1R9m/8wZOVHhiZkuqzvJA33Rfg11xOuechWu6mD4pWdOr0b3jXhzAMia0xx58rp0pA2
 DtGWPE1lemI0iQayHzpq8dEz3mgp9unbrMn9ljfKvZwO/ggdfh9CDtYovehkKZ0ynG1EX5Php
 wYuGTny/nxFaD7D4pL9RV/zVULTjQAFgKxK7LS97jXTu9GYHgKEzQMOn/FTKqU6ARYr8ZiTbU
 JgKD3kIh8Yw6StvZLkZy3bCrEYIar5Dia2xsEmhpsRgfRwcImCA3SyKg28nkZ/+AKA++xLVzq
 f+oH8S7w5u4T10jUhcjTOToT1ZN0hCVkWAt4fPMKqa6RxnW5tr43Y7v88M2I9DGG4owHyq3BL
 GndfQXQEhxCI0oyqPbiPiAmJrYLKV3wPJxRfbCFE58OPTyfA8/wUMj6zycIJnN/CdeDMt/6xY
 P90uROwC1Lw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/4/8 9:31 PM, Johannes Thumshirn wrote:
> Add a 'btrfs inspect-internal csum-dump' command to dump the on-disk
> checksums of a file.
>
> The dump command first uses the FIEMAP ioctl() to get a map of the file'=
s
> extents and then uses the BTRFS_TREE_SEARCH_V2 ioctl() to get the
> checksums for these extents.
>
> Using FIEMAP instead of the BTRFS_TREE_SEARCH_V2 ioctl() to get the
> extents allows us to quickly filter out any holes in the file, as this i=
s
> already done for us in the kernel.
>

Looks much better than V1. Some comments bellow.

> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>   Makefile                 |   3 +-
>   cmds-inspect-dump-csum.c | 231 +++++++++++++++++++++++++++++++++++++++=
++++++++
>   cmds-inspect.c           |   2 +
>   commands.h               |   2 +
>   4 files changed, 237 insertions(+), 1 deletion(-)
>   create mode 100644 cmds-inspect-dump-csum.c
>
> diff --git a/Makefile b/Makefile
> index e25e256f96af..f5d0c0532faf 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -130,7 +130,8 @@ cmds_objects =3D cmds-subvolume.o cmds-filesystem.o =
cmds-device.o cmds-scrub.o \
>   	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o \
>   	       cmds-property.o cmds-fi-usage.o cmds-inspect-dump-tree.o \
>   	       cmds-inspect-dump-super.o cmds-inspect-tree-stats.o cmds-fi-du=
.o \
> -	       mkfs/common.o check/mode-common.o check/mode-lowmem.o
> +	       cmds-inspect-dump-csum.o mkfs/common.o check/mode-common.o \
> +	       check/mode-lowmem.o
>   libbtrfs_objects =3D send-stream.o send-utils.o kernel-lib/rbtree.o bt=
rfs-list.o \
>   		   kernel-lib/crc32c.o messages.o \
>   		   uuid-tree.o utils-lib.o rbtree-utils.o
> diff --git a/cmds-inspect-dump-csum.c b/cmds-inspect-dump-csum.c
> new file mode 100644
> index 000000000000..7181013d0c95
> --- /dev/null
> +++ b/cmds-inspect-dump-csum.c
> @@ -0,0 +1,231 @@
> +/*
> + * Copyright (C) 2019 SUSE. All rights reserved.
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
> +#include <linux/fiemap.h>
> +#include <linux/fs.h>
> +
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <sys/ioctl.h>
> +
> +#include <stdlib.h>
> +#include <stdio.h>
> +#include <errno.h>
> +#include <unistd.h>
> +#include <string.h>
> +#include <fcntl.h>
> +#include <getopt.h>
> +
> +#include "kerncompat.h"
> +#include "ctree.h"
> +#include "messages.h"
> +#include "help.h"
> +#include "ioctl.h"
> +#include "utils.h"
> +
> +static bool debug =3D false;
> +
> +static int btrfs_lookup_csum_for_phys(int fd, u64 phys, u64 extent_csum=
s)
> +{
> +	struct btrfs_ioctl_search_args_v2 *search;
> +	struct btrfs_ioctl_search_key *sk;
> +	int bufsz =3D 1024;
> +	char buf[bufsz], *bp;
> +	unsigned int off =3D 0;
> +	const int csum_size =3D 4; // TODO figure out by runtime
> +	int ret, i, j;
> +	u64 needle =3D phys;
> +	u64 pending_csums =3D extent_csums;
> +
> +	memset(buf, 0, sizeof(buf));
> +	search =3D (struct btrfs_ioctl_search_args_v2 *)buf;
> +	sk =3D &search->key;
> +
> +again:
> +	if (debug)
> +		printf(
> +"Looking up checksums for extent at physial offset: %llu (searching at =
%llu), looking for %llu csums\n",
> +		       phys, needle, pending_csums);
> +
> +	sk->tree_id =3D BTRFS_CSUM_TREE_OBJECTID;
> +	sk->min_objectid =3D BTRFS_EXTENT_CSUM_OBJECTID;
> +	sk->max_objectid =3D BTRFS_EXTENT_CSUM_OBJECTID;
> +	sk->max_type =3D BTRFS_EXTENT_CSUM_KEY;
> +	sk->min_type =3D BTRFS_EXTENT_CSUM_KEY;
> +	sk->min_offset =3D needle;
> +	sk->max_offset =3D (u64)-1;
> +	sk->max_transid =3D (u64)-1;
> +	sk->nr_items =3D 1;
> +	search->buf_size =3D bufsz - sizeof(*search);
> +
> +	ret =3D ioctl(fd, BTRFS_IOC_TREE_SEARCH_V2, search);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (sk->nr_items =3D=3D 0) {
> +		needle -=3D 4096;
> +		goto again;
> +	}
> +
> +
> +	bp =3D (char *) search->buf;
> +
> +	for (i =3D 0; i < sk->nr_items; i++) {
> +		struct btrfs_ioctl_search_header *sh;
> +		int csums_in_item;
> +
> +		sh =3D (struct btrfs_ioctl_search_header *) (bp + off);
> +		off +=3D sizeof(*sh);
> +
> +		csums_in_item =3D btrfs_search_header_len(sh) / csum_size;
> +
> +		if (csums_in_item > pending_csums)
> +			csums_in_item =3D pending_csums;
> +
> +		for (j =3D 0; j < csums_in_item; j++) {
> +			struct btrfs_csum_item *csum_item;
> +
> +			csum_item =3D (struct btrfs_csum_item *) (bp + off + j * 4);
> +
> +			printf("Offset: %llu, checksum: 0x%08x\n",
> +			       phys + j * 4096, *(u32 *)csum_item);
> +		}
> +
> +		off +=3D btrfs_search_header_len(sh);
> +		pending_csums -=3D csums_in_item;
> +
> +	}
> +
> +	return ret;
> +}
> +
> +static int btrfs_get_extent_csum(int fd, struct stat *sb)
> +{
> +	struct fiemap *fiemap, *tmp;
> +	struct fiemap_extent *fe;
> +	size_t ext_size;
> +	int ret, i;
> +
> +	fiemap =3D calloc(1, sizeof(*fiemap));
> +	if (!fiemap)
> +		return -1;

-ENOMEM is better.
> +
> +	fiemap->fm_length =3D ~0;
> +
> +	ret =3D ioctl(fd, FS_IOC_FIEMAP, fiemap);
> +	if (ret)
> +		goto free_fiemap;
> +
> +	ext_size =3D fiemap->fm_mapped_extents * sizeof(struct fiemap_extent);
> +
> +	tmp =3D realloc(fiemap, sizeof(*fiemap) + ext_size);
> +	if (!tmp)

ret =3D -ENOMEM;
else btrfs_get_extent_csum() will return 0.

> +		goto free_fiemap;
> +
> +	fiemap =3D tmp;
> +	fiemap->fm_extent_count =3D fiemap->fm_mapped_extents;
> +	fiemap->fm_mapped_extents =3D 0;
> +
> +	ret =3D ioctl(fd, FS_IOC_FIEMAP, fiemap);
> +	if (ret)
> +		goto free_fiemap;
> +
> +	for (i =3D 0; i < fiemap->fm_mapped_extents; i++) {
> +		u64 extent_csums;
> +
> +		fe =3D &fiemap->fm_extents[i];
> +		extent_csums =3D fe->fe_length / sb->st_blksize;
> +
> +		if (debug)
> +			printf(
> +"Found extent at physial offset: %llu, length %llu, looking for %llu cs=
ums\n",
> +			       fe->fe_physical, fe->fe_length, extent_csums);
> +
> +		ret =3D btrfs_lookup_csum_for_phys(fd, fe->fe_physical,
> +						 extent_csums);
> +		if (ret)
> +			break;
> +
> +		if(fe->fe_flags & FIEMAP_EXTENT_LAST)
> +			break;
> +	}
> +
> +
> +free_fiemap:
> +	free(fiemap);
> +	return ret;
> +}
> +
> +const char * const cmd_inspect_dump_csum_usage[] =3D {
> +	"btrfs inspect-internal dump-csum <path>",
> +	"Get Checksums for a given file",
> +	"-d|--debug    Be more verbose",
> +	NULL
> +};
> +
> +int cmd_inspect_dump_csum(int argc, char **argv)
> +{
> +	struct stat sb;
> +	char *filename;
> +	int fd;
> +	int ret;
> +
> +	optind =3D 0;
> +
> +	while (1) {
> +		static const struct option longopts[] =3D {
> +			{ "debug", no_argument, NULL, 'd' },
> +			{ NULL, 0, NULL, 0 }
> +		};
> +
> +		int opt =3D getopt_long(argc, argv, "d", longopts, NULL);
> +		if (opt < 0)
> +			break;
> +
> +		switch (opt) {
> +		case 'd':
> +			debug =3D true;
> +			break;
> +		default:
> +			usage(cmd_inspect_dump_csum_usage);
> +		}
> +	}
> +
> +	if (check_argc_exact(argc - optind, 1))
> +		usage(cmd_inspect_dump_csum_usage);
> +
> +	filename =3D argv[optind];
> +
> +	fd =3D open(filename, O_RDONLY);
> +	if (fd < 0) {
> +		error("cannot open file %s:%m\n", filename);

error() does break a line, no need of '\n'.
> +		return 1;

-errno is better here.


=2D--
Su
> +	}
> +	ret =3D fstat(fd, &sb);
> +	if (ret) {
> +		error("cannot stat %s: %m\n", filename);
> +		return 1;
> +	}
> +
> +	ret =3D btrfs_get_extent_csum(fd, &sb);
> +	if (ret)
> +		error("checsum lookup for file %s (%lu) failed\n",
> +			filename, sb.st_ino);
> +	close(fd);
> +	return ret;
> +}
> diff --git a/cmds-inspect.c b/cmds-inspect.c
> index efea0331b7aa..c20decbf6fac 100644
> --- a/cmds-inspect.c
> +++ b/cmds-inspect.c
> @@ -654,6 +654,8 @@ const struct cmd_group inspect_cmd_group =3D {
>   				cmd_inspect_dump_super_usage, NULL, 0 },
>   		{ "tree-stats", cmd_inspect_tree_stats,
>   				cmd_inspect_tree_stats_usage, NULL, 0 },
> +		{ "dump-csum",  cmd_inspect_dump_csum,
> +				cmd_inspect_dump_csum_usage, NULL, 0 },
>   		NULL_CMD_STRUCT
>   	}
>   };
> diff --git a/commands.h b/commands.h
> index 76991f2b28d5..698ae532b2b8 100644
> --- a/commands.h
> +++ b/commands.h
> @@ -92,6 +92,7 @@ extern const char * const cmd_rescue_usage[];
>   extern const char * const cmd_inspect_dump_super_usage[];
>   extern const char * const cmd_inspect_dump_tree_usage[];
>   extern const char * const cmd_inspect_tree_stats_usage[];
> +extern const char * const cmd_inspect_dump_csum_usage[];
>   extern const char * const cmd_filesystem_du_usage[];
>   extern const char * const cmd_filesystem_usage_usage[];
>
> @@ -108,6 +109,7 @@ int cmd_super_recover(int argc, char **argv);
>   int cmd_inspect(int argc, char **argv);
>   int cmd_inspect_dump_super(int argc, char **argv);
>   int cmd_inspect_dump_tree(int argc, char **argv);
> +int cmd_inspect_dump_csum(int argc, char **argv);
>   int cmd_inspect_tree_stats(int argc, char **argv);
>   int cmd_property(int argc, char **argv);
>   int cmd_send(int argc, char **argv);
>
