Return-Path: <SRS0=BvJc=RS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0DD1C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Mar 2019 11:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7693720645
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Mar 2019 11:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfCOLmY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Mar 2019 07:42:24 -0400
Received: from mout.gmx.net ([212.227.17.20]:53685 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727441AbfCOLmX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Mar 2019 07:42:23 -0400
Received: from [0.0.0.0] ([173.82.105.236]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lv9lm-1gvNI80W1a-010IqO; Fri, 15
 Mar 2019 12:42:19 +0100
Subject: Re: [RFC PATCH 1/2] btrfs-progs: add 'btrfs inspect-internal
 csum-dump' command
To:     Johannes Thumshirn <jthumshirn@suse.de>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20190228144432.17038-1-jthumshirn@suse.de>
 <20190228144432.17038-2-jthumshirn@suse.de>
From:   Su Yue <Damenly_Su@gmx.com>
Message-ID: <81928a3c-e75b-7059-cd29-660a70fa7f1e@gmx.com>
Date:   Fri, 15 Mar 2019 19:42:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:66.0)
 Gecko/20100101 Thunderbird/66.0
MIME-Version: 1.0
In-Reply-To: <20190228144432.17038-2-jthumshirn@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:gTPEJ1+CkypERduh1Bq38F40o5XONUfcBRaLrKrNRMYoOmpPomk
 GBbJhnRSZqu95rs9qEg957hpMNbJPA0wwu9MYMAMSY1Z0qm5W+oW3guGCbUM1tmivV3xhmi
 MUNJkbfK3ptFT9tZ2bG9K+rItTPB6wZqX6an99V73+QWEycaB9yVHt1jc9oRC4xIWZXsqMP
 WgoN98um0ebt57s+H89xw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:0BUXG4gLTK4=:j3JLBpZMawSjhegSJZ3rq2
 rC0+wXnEz2gcTd9Vce07Jg1FPHs6cjpEviaRpiuqtjjO0slnzSdQMn1GAimJZLU9W4Rdx8/7v
 jh/mkOaDNp/OeWR2IXEhWvE8vlrovKLCBd1HYb6PK4n66+HQlKwQ2q5OjAP4qpMco/0HoEi+2
 Up5Dv1y6oZ4fq+JEGAbmZdNuFFMIzRsRoHFSc2vy0Qva+x3HjCAuM6AhcOcQ0rEJHxJyLGi7z
 wt/bjXaeLDjqStnjiIuLMiFFp76nEToijgEI1HKQ/ip5FhBrXHrH9BzoioQ7Hs1K0eKrkfl4V
 ocBqRzUEz5XU+DxSJrIwRbEnFa8QOmhwfP2DAyZytZ/ofvw1q3DDXCUSSno5IDB8rN+z5e29A
 kBPhYNeSEfYEmjGD2SXdp4RXcLVIR1VzVSys3dtcYuPMnAdXzrU3RGrTGeKVKCZiB9PQlPa0B
 LK1/5DPhA2JKimPSLWi2D/rdWe8gKqm5OFjOkDwQfQUsE4fb/b45m3lsQ0UUBVWwbXMUwM3gy
 B5wnQmxmqtquYGxW9OJAo8V6RECHdOeIRJy1WageBWz+xuuosoot1MOGxK96hN9eI8lzzMYRq
 tzMiEqiPlzfAZe13HUnXhUdYTtgPznenuNBtrvRB1rTZw5jx6/U4fKYzxhXfCTt77Wytvfb3b
 o6ia0NgKfY6tZuHTXax25qbu9jHDy0JGaM9v0HfWGKW0wSvMfBqYuhhoica6b3yC9n7Ev7MyZ
 kDYYCWy4vVHfTkwvowCYCF4PN17KgLjXAhHmTN4DhVmM5wmNMaEFKfMNZa3ukOUMnJpJwjKkt
 GE2mWg7MWQmTlU2ydnqNQd02qQ6Elc8uUyoY5+C3olpBr1IG0+7UKZmg1TwFn2pFti+B55WR4
 LJvlUSmruEkQJPSQEG9tsIam7xoUIKhJfKcX0bBkRJP+C74symnwRZo7tD0xHxpuCGGYjiBs8
 er9SnqT+nKw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/2/28 10:44 PM, Johannes Thumshirn wrote:
> Add a 'btrfs inspect-internal csum-dump' command to dump the on-disk
> checksums of a file.
>
Little introduction may help others. One sentence is too much simple...

> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

I haven't reviewed BTRFS patch for a long time. So please
correct me if some comments are wrong.

> ---
>   Makefile                 |   3 +-
>   cmds-inspect-dump-csum.c | 266 +++++++++++++++++++++++++++++++++++++++++++++++
>   cmds-inspect.c           |   2 +
>   commands.h               |   2 +
>   4 files changed, 272 insertions(+), 1 deletion(-)
>   create mode 100644 cmds-inspect-dump-csum.c
> 
> diff --git a/Makefile b/Makefile
> index e25e256f96af..f5d0c0532faf 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -130,7 +130,8 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
>   	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o \
>   	       cmds-property.o cmds-fi-usage.o cmds-inspect-dump-tree.o \
>   	       cmds-inspect-dump-super.o cmds-inspect-tree-stats.o cmds-fi-du.o \
> -	       mkfs/common.o check/mode-common.o check/mode-lowmem.o
> +	       cmds-inspect-dump-csum.o mkfs/common.o check/mode-common.o \
> +	       check/mode-lowmem.o
>   libbtrfs_objects = send-stream.o send-utils.o kernel-lib/rbtree.o btrfs-list.o \
>   		   kernel-lib/crc32c.o messages.o \
>   		   uuid-tree.o utils-lib.o rbtree-utils.o
> diff --git a/cmds-inspect-dump-csum.c b/cmds-inspect-dump-csum.c
> new file mode 100644
> index 000000000000..beb98abcf08b
> --- /dev/null
> +++ b/cmds-inspect-dump-csum.c
> @@ -0,0 +1,266 @@
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
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +
> +#include <stdlib.h>
> +#include <stdio.h>
> +#include <errno.h>
> +#include <unistd.h>
> +#include <string.h>
> +#include <fcntl.h>
> +
> +#include "ctree.h"
> +#include "disk-io.h"
> +#include "volumes.h"
> +#include "help.h"
> +#include "utils.h"
> +
> +#ifdef DEBUG
> +#define pr_debug(fmt, ...) printf(fmt, __VA_ARGS__)
> +#else
> +#define pr_debug(fmt, ...) do {} while (0)
> +#endif
> +
> +static int btrfs_lookup_csum(struct btrfs_root *root, struct btrfs_path *path,
> +			     u64 bytenr, u64 extent_len)
> +{
> +	struct btrfs_key key;
> +	int pending_csums;
> +	int total_csums;
> +	u16 csum_size;
> +	int ret;
> +
> +	key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
> +	key.offset = bytenr;
> +	key.type = BTRFS_EXTENT_CSUM_KEY;
> +
> +	csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
> +
> +	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +	if (ret < 0) {
> +		goto out;
> +	} else if (ret > 0) {
> +		if (path->slots[0] == 0) {
> +			ret = -ENOENT;
> +			goto out;
> +		} else {
> +			path->slots[0]--;
> +		}
> +	}
> +
> +	pending_csums = total_csums = extent_len / 4096;
> +
> +	ret = -EINVAL;
> +	while (pending_csums) {
> +		struct extent_buffer *leaf;
> +		struct btrfs_key found_key;
> +		struct btrfs_csum_item *ci;
> +		u32 item_size;
> +		int nr_csums;
> +		int slot;
> +		int i;
> +
> +		leaf = path->nodes[0];
> +		slot = path->slots[0];
> +
> +		btrfs_item_key_to_cpu(leaf, &found_key, slot);
> +		if (found_key.type != BTRFS_EXTENT_CSUM_KEY)
> +			goto out;
> +
> +		ci = btrfs_item_ptr(leaf, slot, struct btrfs_csum_item);
> +		item_size = btrfs_item_size_nr(leaf, slot);
> +
> +		if (pending_csums < (item_size / 4))
> +			nr_csums = pending_csums;
> +		else
> +			nr_csums = item_size / 4;
> +
> +		for (i = 0; i < nr_csums; i++) {
> +			u32 csum;
> +
> +			read_extent_buffer(leaf, &csum,
> +					   (unsigned long) ci + i * 4,
> +					   csum_size);
> +			printf("Disk Byte: %llu, Checksum: 0x%08x\n",
> +			       bytenr + i * 4096, csum);
> +		}
> +		pending_csums -= nr_csums;
> +
> +
> +		ret = btrfs_next_item(root, path);
> +		if (ret > 0) {

Should here break the loop if ret < 0 either?

> +			ret = 0;
> +			break;
> +		}
> +	}
> +
> +out:
> +	if (ret)
> +		error("failed to lookup checksums for extent at %llu", bytenr);

Since negative @ret is meaningful, better to use %m to print info.

> +
> +	return ret;
> +}
> +
> +static int btrfs_get_extent_csum(struct btrfs_root *root,
> +				 struct btrfs_path *path, unsigned long ino)
> +{
> +	struct btrfs_fs_info *info = root->fs_info;
> +	struct btrfs_key key;
> +	int ret;
> +
> +	key.objectid = ino;
> +	key.type = BTRFS_EXTENT_DATA_KEY;
> +	key.offset = 0;
> +
> +	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +	if (ret < 0) {
> +		goto out;
> +	} else if (ret > 0) {
> +		if (path->slots[0] == 0) {
> +			ret = -ENOENT;
> +			goto out;
> +		} else {
> +			path->slots[0]--;
> +		}
> +	}
> +
> +	ret = -EINVAL;
> +	while (1) {
> +		struct btrfs_file_extent_item *fi;
> +		struct btrfs_path *csum_path;
> +		struct extent_buffer *leaf;
> +		struct btrfs_key found_key;
> +		u64 extent_len;
> +		u64 bytenr;
> +		int slot;
> +
> +		leaf = path->nodes[0];
> +		slot = path->slots[0];
> +
> +		btrfs_item_key_to_cpu(leaf, &found_key, slot);
> +		if (found_key.type != BTRFS_EXTENT_DATA_KEY)
> +			goto out;
> +
> +		fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
> +		extent_len = btrfs_file_extent_num_bytes(leaf, fi);
> +		bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
> +
> +		pr_debug("extent start: %llu, len: %llu\n", bytenr, extent_len);
> +
> +		csum_path = btrfs_alloc_path();

Hmm.. Here you allocate a path and release it after use, why not just do 
it in btrfs_lookup_csum()?

> +		ret = btrfs_lookup_csum(info->csum_root, csum_path, bytenr,
> +					extent_len);
> +		btrfs_release_path(csum_path);
> +		if (ret) {
> +			error("Error looking up checsum\n");
> +			break;
> +		}
> +
> +		ret = btrfs_next_item(root, path);
> +		if (ret > 0) {
> +			ret = 0;

Same.
> +			break;
> +		}
> +	}
> +
> +out:
> +	return ret;
> +}
> +
> +const char * const cmd_inspect_dump_csum_usage[] = {
> +	"btrfs inspect-internal dump-csum <path> <device>",
> +	"Get Checksums for a given file",
> +	NULL
> +};
> +
> +int cmd_inspect_dump_csum(int argc, char **argv)
> +{
> +	struct btrfs_fs_info *info;
> +	struct btrfs_root *root;
> +	struct btrfs_path path;
> +	struct stat sb;
> +	char *filename;
> +	u64 rootid;
> +	int fd;
> +	int ret;
> +
> +	ret = check_argc_exact(argc, 3);
> +	if (ret)
> +		usage(cmd_inspect_dump_csum_usage);
> +
> +	filename = argv[1];
> +
> +	info = open_ctree_fs_info(argv[2], 0, 0, 0, OPEN_CTREE_PARTIAL);
> +	if (!info) {
> +		error("unable to open device %s\n", argv[2]);
> +		exit(1);
> +	}
> +
> +	ret = stat(filename, &sb);
> +	if (ret) {
> +		error("cannot stat %s: %s\n", filename, strerror(errno));

Better to use %m.

> +		exit(1);
> +	}
> +
> +	if (sb.st_size < 1024) {
> +		error("file smaller than 1KB, aborting\n");
> +		exit(1);
> +	}
> +
> +	fd = open(filename, O_RDONLY);
> +	ret = lookup_path_rootid(fd, &rootid);
> +	if (ret) {
> +		error("error looking up subvolume for '%s'\n",
> +				filename);
> +		goto out_close;
> +	}
> +
> +	pr_debug("%s: '%s' is on subvolume %llu\n", __func__, filename, rootid);
> +
> +	root = info->fs_root;
> +
> +	if (rootid != BTRFS_FS_TREE_OBJECTID) {
> +		struct btrfs_key key;
> +
> +		key.objectid = rootid;
> +		key.type = BTRFS_ROOT_ITEM_KEY;
> +		key.offset = (u64)-1;
> +
> +		root = btrfs_read_fs_root(info, &key);
> +		if (IS_ERR(root)) {
> +			error("unable to read root of subvolume '%llu'\n",
> +			      rootid);
> +			goto out_close;
> +		}
> +	}
> +
> +	btrfs_init_path(&path);

Same here, if caller doesn't need the path info, doing it
inner the function is enough.


Thanks,
Su
> +	ret = btrfs_get_extent_csum(root, &path, sb.st_ino);
> +	btrfs_release_path(&path);
> +	close_ctree(info->fs_root);
> +	btrfs_close_all_devices();
> +
> +	if (ret)
> +		error("checsum lookup for file %s (%lu) failed\n",
> +			filename, sb.st_ino);
> +out_close:
> +	close(fd);
> +	return ret;
> +}
> diff --git a/cmds-inspect.c b/cmds-inspect.c
> index efea0331b7aa..c533e9f6dc0b 100644
> --- a/cmds-inspect.c
> +++ b/cmds-inspect.c
> @@ -654,6 +654,8 @@ const struct cmd_group inspect_cmd_group = {
>   				cmd_inspect_dump_super_usage, NULL, 0 },
>   		{ "tree-stats", cmd_inspect_tree_stats,
>   				cmd_inspect_tree_stats_usage, NULL, 0 },
> +		{ "dump-csum", cmd_inspect_dump_csum,
> +			cmd_inspect_dump_csum_usage, NULL, 0 },
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
