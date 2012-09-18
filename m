Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59661 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab2IRCbs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 22:31:48 -0400
Message-ID: <5057DD0D.1070201@cn.fujitsu.com>
Date: Tue, 18 Sep 2012 10:31:41 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs-progs: add mount-option command
References: <5057CDA7.3090201@jp.fujitsu.com> <5057CEA9.3070707@jp.fujitsu.com>
In-Reply-To: <5057CEA9.3070707@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On tue, 18 Sep 2012 10:30:17 +0900, Hidetoshi Seto wrote:
> This patch adds mount-option command.
> The command can set/get default mount options.
> Now, the command can set/get 24 options.
> These options are equal to mount options which store
> in fs_info/mount-opt.

I don't think we need implement a separate command to do this,
we can add it into btrfstune just like ext3/4. If so, the users
who used ext3/4 before can be familiar with btrfs command as soon
as possible.

Beside that, why not add a option into mkfs.btrfs?

Thanks
Miao

> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  Makefile             |    5 +-
>  btrfs-parse-mntopt.c |  111 +++++++++++++++++++++++++++++++++++++
>  btrfs-parse-mntopt.h |   65 ++++++++++++++++++++++
>  btrfs.c              |    1 +
>  cmds-mount.c         |  150 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  commands.h           |    2 +
>  ctree.h              |   41 +++++++++++++-
>  7 files changed, 372 insertions(+), 3 deletions(-)
>  create mode 100644 btrfs-parse-mntopt.c
>  create mode 100644 btrfs-parse-mntopt.h
>  create mode 100644 cmds-mount.c
> 
> diff --git a/Makefile b/Makefile
> index c0aaa3d..6f67f4c 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -5,9 +5,10 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
>  	  root-tree.o dir-item.o file-item.o inode-item.o \
>  	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
>  	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o \
> -	  send-stream.o send-utils.o
> +	  send-stream.o send-utils.o btrfs-parse-mntopt.o
>  cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
> -	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o
> +	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
> +	       cmds-mount.o
>  
>  CHECKFLAGS= -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
>  	    -Wuninitialized -Wshadow -Wundef
> diff --git a/btrfs-parse-mntopt.c b/btrfs-parse-mntopt.c
> new file mode 100644
> index 0000000..87b341c
> --- /dev/null
> +++ b/btrfs-parse-mntopt.c
> @@ -0,0 +1,111 @@
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include "ctree.h"
> +#include "btrfs-parse-mntopt.h"
> +
> +void btrfs_parse_string2mntopt(struct btrfs_root *root, char **options)
> +{
> +	struct btrfs_super_block *sb = &root->fs_info->super_copy;
> +	char *p = NULL;
> +	int i = 0;
> +
> +	memset(&sb->default_mount_opt, 0, sizeof(unsigned long));
> +	while ((p = strsep(options, ",")) != NULL) {
> +		int token = DEF_MNTOPT_NUM + 1;
> +
> +		if (!*p)
> +			continue;
> +		for (i = 0; i < DEF_MNTOPT_NUM; i++) {
> +			if (!strcmp(p, toke[i].pattern)) {
> +				token = toke[i].token;
> +				break;
> +			}
> +		}
> +		if (token > DEF_MNTOPT_NUM) {
> +			printf("error: %s\n", p);
> +			return;
> +		}
> +
> +		switch (token) {
> +		case Opt_degraded:
> +			btrfs_set_opt(sb->default_mount_opt, DEGRADED);
> +			break;
> +
> +		case Opt_nodatasum:
> +			btrfs_set_opt(sb->default_mount_opt, NODATASUM);
> +			break;
> +		case Opt_nodatacow:
> +			btrfs_set_opt(sb->default_mount_opt, NODATACOW);
> +			btrfs_set_opt(sb->default_mount_opt, NODATASUM);
> +			break;
> +		case Opt_ssd:
> +			btrfs_set_opt(sb->default_mount_opt, SSD);
> +			break;
> +		case Opt_ssd_spread:
> +			btrfs_set_opt(sb->default_mount_opt, SSD);
> +			btrfs_set_opt(sb->default_mount_opt, SSD_SPREAD);
> +			break;
> +		case Opt_nossd:
> +			btrfs_set_opt(sb->default_mount_opt, NOSSD);
> +			btrfs_clear_opt(sb->default_mount_opt, SSD);
> +			btrfs_clear_opt(sb->default_mount_opt, SSD_SPREAD);
> +			break;
> +		case Opt_nobarrier:
> +			btrfs_set_opt(sb->default_mount_opt, NOBARRIER);
> +			break;
> +		case Opt_notreelog:
> +			btrfs_set_opt(sb->default_mount_opt, NOTREELOG);
> +			break;
> +		case Opt_flushoncommit:
> +			btrfs_set_opt(sb->default_mount_opt, FLUSHONCOMMIT);
> +			break;
> +		case Opt_discard:
> +			btrfs_set_opt(sb->default_mount_opt, DISCARD);
> +			break;
> +		case Opt_space_cache:
> +			btrfs_set_opt(sb->default_mount_opt, SPACE_CACHE);
> +			break;
> +		case Opt_no_space_cache:
> +			btrfs_clear_opt(sb->default_mount_opt, SPACE_CACHE);
> +			break;
> +		case Opt_inode_cache:
> +			btrfs_set_opt(sb->default_mount_opt, INODE_MAP_CACHE);
> +			break;
> +		case Opt_clear_cache:
> +			btrfs_set_opt(sb->default_mount_opt, CLEAR_CACHE);
> +			break;
> +		case Opt_user_subvol_rm_allowed:
> +			btrfs_set_opt(sb->default_mount_opt,
> +					USER_SUBVOL_RM_ALLOWED);
> +			break;
> +		case Opt_enospc_debug:
> +			btrfs_set_opt(sb->default_mount_opt, ENOSPC_DEBUG);
> +			break;
> +		case Opt_defrag:
> +			btrfs_set_opt(sb->default_mount_opt, AUTO_DEFRAG);
> +			break;
> +		case Opt_recovery:
> +			btrfs_set_opt(sb->default_mount_opt, RECOVERY);
> +			break;
> +		case Opt_skip_balance:
> +			btrfs_set_opt(sb->default_mount_opt, SKIP_BALANCE);
> +			break;
> +		default:
> +			break;
> +		}
> +	}
> +}
> +
> +void btrfs_parse_mntopt2string(unsigned long def_opt)
> +{
> +	if (!def_opt)
> +		printf("no default options\n");
> +	else {
> +		int i = 0;
> +		for (i = 0; i < DEF_MNTOPT_NUM; i++) {
> +			if (def_opt & (1 << toke[i].token))
> +				printf("%s\n", toke[i].pattern);
> +		}
> +	}
> +}
> diff --git a/btrfs-parse-mntopt.h b/btrfs-parse-mntopt.h
> new file mode 100644
> index 0000000..a2745ee
> --- /dev/null
> +++ b/btrfs-parse-mntopt.h
> @@ -0,0 +1,65 @@
> +/*
> + * Copyright (C) 2007 Oracle.  All rights reserved.
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
> +struct match_token {
> +	int token;
> +	const char *pattern;
> +};
> +
> +typedef struct match_token match_table_t[];
> +
> +enum {
> +	Opt_nodatasum, Opt_nodatacow, Opt_nobarrier, Opt_ssd,
> +	Opt_degraded, Opt_compress, Opt_notreelog, Opt_flushoncommit,
> +	Opt_ssd_spread, Opt_nossd, Opt_discard, Opt_compress_force,
> +	Opt_space_cache, Opt_clear_cache, Opt_user_subvol_rm_allowed,
> +	Opt_enospc_debug, Opt_defrag, Opt_inode_cache, Opt_recovery,
> +	Opt_skip_balance, Opt_check_integrity,
> +	Opt_check_integrity_including_extent_data, Opt_fatal_errors,
> +	Opt_no_space_cache, DEF_MNTOPT_NUM,
> +};
> +
> +static match_table_t toke = {
> +	{Opt_degraded, "degraded"},
> +	{Opt_nodatasum, "nodatasum"},
> +	{Opt_nodatacow, "nodatacow"},
> +	{Opt_nobarrier, "nobarrier"},
> +	{Opt_compress, "compress"},
> +	{Opt_compress_force, "compress-force"},
> +	{Opt_ssd, "ssd"},
> +	{Opt_ssd_spread, "ssd_spread"},
> +	{Opt_nossd, "nossd"},
> +	{Opt_notreelog, "notreelog"},
> +	{Opt_flushoncommit, "flushoncommit"},
> +	{Opt_discard, "discard"},
> +	{Opt_space_cache, "space_cache"},
> +	{Opt_no_space_cache, "no_space_cache"},
> +	{Opt_clear_cache, "clear_cache"},
> +	{Opt_user_subvol_rm_allowed, "user_subvol_rm_allowed"},
> +	{Opt_enospc_debug, "enospc_debug"},
> +	{Opt_defrag, "auto_defrag"},
> +	{Opt_inode_cache, "inode_map_cache"},
> +	{Opt_recovery, "recovery"},
> +	{Opt_skip_balance, "skip_balance"},
> +	{Opt_check_integrity, "check_int"},
> +	{Opt_check_integrity_including_extent_data, "check_int_data"},
> +	{Opt_fatal_errors, "fatal_errors"},
> +};
> +
> +void btrfs_parse_string2mntopt(struct btrfs_root *root, char **options);
> +void btrfs_parse_mntopt2string(unsigned long def_opt);
> diff --git a/btrfs.c b/btrfs.c
> index e9d54f8..0d6c9a7 100644
> --- a/btrfs.c
> +++ b/btrfs.c
> @@ -246,6 +246,7 @@ const struct cmd_group btrfs_cmd_group = {
>  		{ "device", cmd_device, NULL, &device_cmd_group, 0 },
>  		{ "scrub", cmd_scrub, NULL, &scrub_cmd_group, 0 },
>  		{ "inspect-internal", cmd_inspect, NULL, &inspect_cmd_group, 0 },
> +		{ "mount-option", cmd_mount, NULL, &mount_cmd_group, 0 },
>  		{ "send", cmd_send, NULL, &send_cmd_group, 0 },
>  		{ "receive", cmd_receive, NULL, &receive_cmd_group, 0 },
>  		{ "help", cmd_help, cmd_help_usage, NULL, 0 },
> diff --git a/cmds-mount.c b/cmds-mount.c
> new file mode 100644
> index 0000000..cbdb006
> --- /dev/null
> +++ b/cmds-mount.c
> @@ -0,0 +1,150 @@
> +/*
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
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <sys/ioctl.h>
> +#include "ioctl.h"
> +#include "ctree.h"
> +#include "transaction.h"
> +#include "commands.h"
> +#include "disk-io.h"
> +#include "utils.h"
> +#include "btrfs-parse-mntopt.h"
> +
> +static const char * const mount_cmd_group_usage[] = {
> +	"btrfs mount-option <command> [<args>]",
> +	NULL
> +};
> +
> +static const char * const cmd_set_mntopt_usage[] = {
> +	"btrfs mount-option set [<option>,...] <device>",
> +	"Set default mount options",
> +	NULL
> +};
> +
> +static int cmd_set_mntopt(int argc, char **argv)
> +{
> +	struct btrfs_root *root = NULL;
> +	struct btrfs_trans_handle *trans = NULL;
> +	int ret = 0;
> +
> +	if (argc != 3)
> +		usage(cmd_set_mntopt_usage);
> +
> +	if (check_mounted(argv[argc - 1])) {
> +		fprintf(stderr, "%s is mounted\n", argv[argc - 1]);
> +		return 1;
> +	}
> +
> +	root = open_ctree(argv[argc - 1], 0, 1);
> +
> +	if (!root)
> +		printf("error root\n");
> +
> +	trans = btrfs_start_transaction(root, 1);
> +	btrfs_parse_string2mntopt(root, &argv[1]);
> +	ret = btrfs_commit_transaction(trans, root);
> +
> +	close_ctree(root);
> +	return ret;
> +};
> +
> +static const char * const cmd_get_mntopt_usage[] = {
> +	"btrfs mount-option get <device>",
> +	"Get default mount options",
> +	NULL
> +};
> +
> +static int cmd_get_mntopt(int argc, char **argv)
> +{
> +	struct btrfs_root *root = NULL;
> +	unsigned long def_opt;
> +
> +	memset(&def_opt, 0, sizeof(def_opt));
> +	if (argc != 2) {
> +		usage(cmd_get_mntopt_usage);
> +		return 1;
> +	}
> +
> +	if (check_mounted(argv[argc - 1])) {
> +		fprintf(stderr, "%s is mounted\n", argv[argc - 1]);
> +		return 1;
> +	}
> +
> +	root = open_ctree(argv[argc - 1], 0, 0);
> +
> +	if (!root) {
> +		printf("error root\n");
> +		return 1;
> +	}
> +
> +	def_opt = btrfs_super_default_mount_opt(&root->fs_info->super_copy);
> +
> +	btrfs_parse_mntopt2string(def_opt);
> +
> +	close_ctree(root);
> +	return 0;
> +};
> +
> +static const char * const cmd_clear_mntopt_usage[] = {
> +	"btrfs mount-option clear <device>",
> +	"Clear default mount options",
> +	NULL
> +};
> +
> +static int cmd_clear_mntopt(int argc, char **argv)
> +{
> +	struct btrfs_root *root = NULL;
> +	struct btrfs_trans_handle *trans = NULL;
> +	int ret = 0;
> +
> +	if (argc != 2) {
> +		usage(cmd_clear_mntopt_usage);
> +		return 1;
> +	}
> +
> +	if (check_mounted(argv[argc - 1])) {
> +		fprintf(stderr, "%s is mounted\n", argv[argc - 1]);
> +		return 1;
> +	}
> +
> +	root = open_ctree(argv[argc - 1], 0, 1);
> +
> +	if (!root)
> +		printf("error root\n");
> +
> +	trans = btrfs_start_transaction(root, 1);
> +	btrfs_set_super_default_mount_opt(&root->fs_info->super_copy, 0);
> +	ret = btrfs_commit_transaction(trans, root);
> +
> +	close_ctree(root);
> +	return ret;
> +};
> +
> +const struct cmd_group mount_cmd_group = {
> +	mount_cmd_group_usage, NULL, {
> +		{ "set", cmd_set_mntopt, cmd_set_mntopt_usage, NULL, 0 },
> +		{ "get", cmd_get_mntopt, cmd_get_mntopt_usage, NULL, 0 },
> +		{ "clear", cmd_clear_mntopt, cmd_clear_mntopt_usage, NULL, 0},
> +		{0, 0, 0, 0, 0 }
> +	}
> +};
> +
> +int cmd_mount(int argc, char **argv)
> +{
> +	return handle_command_group(&mount_cmd_group, argc, argv);
> +}
> diff --git a/commands.h b/commands.h
> index 1ece87a..6cf91fc 100644
> --- a/commands.h
> +++ b/commands.h
> @@ -88,6 +88,7 @@ extern const struct cmd_group balance_cmd_group;
>  extern const struct cmd_group device_cmd_group;
>  extern const struct cmd_group scrub_cmd_group;
>  extern const struct cmd_group inspect_cmd_group;
> +extern const struct cmd_group mount_cmd_group;
>  extern const struct cmd_group send_cmd_group;
>  extern const struct cmd_group receive_cmd_group;
>  
> @@ -97,5 +98,6 @@ int cmd_balance(int argc, char **argv);
>  int cmd_device(int argc, char **argv);
>  int cmd_scrub(int argc, char **argv);
>  int cmd_inspect(int argc, char **argv);
> +int cmd_mount(int argc, char **argv);
>  int cmd_send(int argc, char **argv);
>  int cmd_receive(int argc, char **argv);
> diff --git a/ctree.h b/ctree.h
> index d218b88..4a1bb5b 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -401,8 +401,11 @@ struct btrfs_super_block {
>  
>  	__le64 cache_generation;
>  
> +	/* default mount options */
> +	unsigned long default_mount_opt;
> +
>  	/* future expansion */
> -	__le64 reserved[31];
> +	__le64 reserved[30];
>  	u8 sys_chunk_array[BTRFS_SYSTEM_CHUNK_ARRAY_SIZE];
>  	struct btrfs_root_backup super_roots[BTRFS_NUM_BACKUP_ROOTS];
>  } __attribute__ ((__packed__));
> @@ -1774,6 +1777,8 @@ BTRFS_SETGET_STACK_FUNCS(super_csum_type, struct btrfs_super_block,
>  			 csum_type, 16);
>  BTRFS_SETGET_STACK_FUNCS(super_cache_generation, struct btrfs_super_block,
>  			 cache_generation, 64);
> +BTRFS_SETGET_STACK_FUNCS(super_default_mount_opt, struct btrfs_super_block,
> +			 default_mount_opt, 64);
>  
>  static inline int btrfs_super_csum_size(struct btrfs_super_block *s)
>  {
> @@ -2128,3 +2133,37 @@ int btrfs_csum_truncate(struct btrfs_trans_handle *trans,
>  			struct btrfs_root *root, struct btrfs_path *path,
>  			u64 isize);
>  #endif
> +
> +/*
> + * Flags for mount options.
> + *
> + * Note: don't forget to add new options to btrfs_show_options()
> + */
> +#define BTRFS_MOUNT_NODATASUM		(1 << 0)
> +#define BTRFS_MOUNT_NODATACOW		(1 << 1)
> +#define BTRFS_MOUNT_NOBARRIER		(1 << 2)
> +#define BTRFS_MOUNT_SSD			(1 << 3)
> +#define BTRFS_MOUNT_DEGRADED		(1 << 4)
> +#define BTRFS_MOUNT_COMPRESS		(1 << 5)
> +#define BTRFS_MOUNT_NOTREELOG           (1 << 6)
> +#define BTRFS_MOUNT_FLUSHONCOMMIT       (1 << 7)
> +#define BTRFS_MOUNT_SSD_SPREAD		(1 << 8)
> +#define BTRFS_MOUNT_NOSSD		(1 << 9)
> +#define BTRFS_MOUNT_DISCARD		(1 << 10)
> +#define BTRFS_MOUNT_FORCE_COMPRESS      (1 << 11)
> +#define BTRFS_MOUNT_SPACE_CACHE		(1 << 12)
> +#define BTRFS_MOUNT_CLEAR_CACHE		(1 << 13)
> +#define BTRFS_MOUNT_USER_SUBVOL_RM_ALLOWED (1 << 14)
> +#define BTRFS_MOUNT_ENOSPC_DEBUG	 (1 << 15)
> +#define BTRFS_MOUNT_AUTO_DEFRAG		(1 << 16)
> +#define BTRFS_MOUNT_INODE_MAP_CACHE	(1 << 17)
> +#define BTRFS_MOUNT_RECOVERY		(1 << 18)
> +#define BTRFS_MOUNT_SKIP_BALANCE	(1 << 19)
> +#define BTRFS_MOUNT_CHECK_INTEGRITY	(1 << 20)
> +#define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
> +#define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
> +
> +#define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
> +#define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
> +#define btrfs_test_opt(root, opt)	((root)->fs_info->mount_opt& \
> +					 BTRFS_MOUNT_##opt)
> 


