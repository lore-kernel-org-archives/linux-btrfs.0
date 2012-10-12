Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34206 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779Ab2JLIWF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Oct 2012 04:22:05 -0400
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id E5C8A3EE081
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 17:22:03 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id C264345DD78
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 17:22:03 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id A225545DE53
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 17:22:03 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 92258E08003
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 17:22:03 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 3EBC21DB802C
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 17:22:03 +0900 (JST)
Message-ID: <5077D31C.3080006@jp.fujitsu.com>
Date: Fri, 12 Oct 2012 17:21:48 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/4] Btrfs-progs: add mount-option command
References: <50778C1D.4060807@jp.fujitsu.com> <50778D72.10807@jp.fujitsu.com>
In-Reply-To: <50778D72.10807@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

(2012/10/12 12:24), Hidetoshi Seto wrote:
> This patch adds mount-option command that can set/get/clear default
> mount options.
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>   Makefile             |    4 +-
>   btrfs-parse-mntopt.c |  109 +++++++++++++++++++++++++++++
>   btrfs-parse-mntopt.h |   66 ++++++++++++++++++
>   btrfs.c              |    1 +
>   cmds-mount.c         |  185 ++++++++++++++++++++++++++++++++++++++++++++++++++
>   commands.h           |    2 +
>   ctree.h              |    7 ++-
>   7 files changed, 371 insertions(+), 3 deletions(-)
>   create mode 100644 btrfs-parse-mntopt.c
>   create mode 100644 btrfs-parse-mntopt.h
>   create mode 100644 cmds-mount.c
> 
> diff --git a/Makefile b/Makefile
> index 4894903..c25d982 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -5,10 +5,10 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
>   	  root-tree.o dir-item.o file-item.o inode-item.o \
>   	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
>   	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o \
> -	  send-stream.o send-utils.o qgroup.o
> +	  send-stream.o send-utils.o qgroup.o btrfs-parse-mntopt.o
>   cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
>   	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
> -	       cmds-quota.o cmds-qgroup.o
> +	       cmds-quota.o cmds-qgroup.o cmds-mount.o
>   
>   CHECKFLAGS= -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
>   	    -Wuninitialized -Wshadow -Wundef
> diff --git a/btrfs-parse-mntopt.c b/btrfs-parse-mntopt.c
> new file mode 100644
> index 0000000..66a924d
> --- /dev/null
> +++ b/btrfs-parse-mntopt.c
> @@ -0,0 +1,109 @@
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include "ctree.h"
> +#include "btrfs-parse-mntopt.h"
> +
> +void btrfs_parse_string2mntopt(u64 *optval, int optnum, char **options)
> +{
> +	char *p, *opts;
> +	int i, j;
> +	u64 newval = *optval;
> +	char overwrite = 0;
> +
> +	for (i = 0; i < optnum; i++) {
> +		char *token, *save_ptr;
> +		char revert = 0;
> +		u64 orders = 0;
> +
> +		opts = options[i];
> +
> +		switch (*opts) {
> +		case '=':
> +			if (overwrite) {
> +				fprintf(stderr, "'=' operator may only be specified once.\n");
> +				return;
> +			}
> +			if (i) {
> +				fprintf(stderr, "cannot use operator '=' with '+/-'.\n");
> +				return;
> +			}
> +			if (!*(opts + 1)) {
> +				fprintf(stderr, "no options after '='.\n");
> +				return;
> +			}
> +			overwrite = 1;
> +			opts++;
> +			break;
> +		case '-':
> +			revert = 1;
> +		case '+':
> +			if (overwrite) {
> +				fprintf(stderr, "cannot use operator '=' with '+/-'.\n");
> +				return;
> +			}
> +			if (!*(opts + 1)) {
> +				fprintf(stderr, "no options after '%c'.\n", *opts);
> +				return;
> +			}
> +			opts++;
> +			break;
> +		default:
> +			fprintf(stderr, "options must be specified with '+/-/='.\n");
> +			return;
> +		}
> +
> +		for (token = strtok_r(opts, ",", &save_ptr); token != NULL;
> +		     token = strtok_r(NULL, ",", &save_ptr)) {
> +			char *arg;
> +
> +			arg = strchr(token, '=');
> +			if (arg) {
> +				/* TBD: compress=<type> */
> +				fprintf(stderr, "format 'option=arg' is not supported.\n");
> +				return;
> +			}
> +
> +			for (j = 0; tokens[j].pattern != NULL; j++) {
> +				if (!strcmp(token, tokens[j].pattern)) {
> +					orders |= (1 << tokens[j].token);
> +					break;
> +				}
> +			}
> +			if (!tokens[j].pattern) {
> +				fprintf(stderr, "unknown option '%s'.\n", token);
> +				printf("supported options : ");
> +				btrfs_parse_mntopt2string(-1);
> +				return;
> +			}
> +		}
> +
> +		if (overwrite)
> +			newval = orders;
> +		else if (revert)
> +			newval &= ~orders;
> +		else
> +			newval |= orders;
> +	}
> +
> +	*optval = newval;
> +}
> +
> +void btrfs_parse_mntopt2string(u64 optval)
> +{
> +	if (!optval)
> +		printf("no default options\n");
> +	else {
> +		int i, cont = 0;
> +
> +		for (i = 0; tokens[i].pattern != NULL; i++) {
> +			if (optval & (1 << tokens[i].token)) {
> +				if (cont)
> +					printf(",");
> +				printf("%s", tokens[i].pattern);
> +				cont = 1;
> +			}
> +		}
> +		printf("\n");
> +	}
> +}
> diff --git a/btrfs-parse-mntopt.h b/btrfs-parse-mntopt.h
> new file mode 100644
> index 0000000..784a942
> --- /dev/null
> +++ b/btrfs-parse-mntopt.h
> @@ -0,0 +1,66 @@
> +/* btrfs-parse-mntopt.h */
> +
> +struct match_token {
> +	int token;
> +	const char *pattern;
> +};
> +
> +typedef struct match_token match_table_t[];
> +
> +/* copy & pasted from super.c */
> +enum {
> +	Opt_degraded, Opt_subvol, Opt_subvolid, Opt_device, Opt_nodatasum,
> +	Opt_nodatacow, Opt_max_inline, Opt_alloc_start, Opt_nobarrier, Opt_ssd,
> +	Opt_nossd, Opt_ssd_spread, Opt_thread_pool, Opt_noacl, Opt_compress,
> +	Opt_compress_type, Opt_compress_force, Opt_compress_force_type,
> +	Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_discard,
> +	Opt_space_cache, Opt_clear_cache, Opt_user_subvol_rm_allowed,
> +	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag, Opt_inode_cache,
> +	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
> +	Opt_check_integrity, Opt_check_integrity_including_extent_data,
> +	Opt_check_integrity_print_mask, Opt_fatal_errors,
> +	Opt_err,
> +};
> +
> +static match_table_t tokens = {
> +/*	{Opt_degraded, "degraded"},		... never be default */
> +/*	{Opt_subvol, "subvol=%s"},		... not supported */
> +/*	{Opt_subvolid, "subvolid=%d"},		... not supported */
> +/*	{Opt_device, "device=%s"},		... not supported */
> +	{Opt_nodatasum, "nodatasum"},
> +	{Opt_nodatacow, "nodatacow"},
> +	{Opt_nobarrier, "nobarrier"},
> +/*	{Opt_max_inline, "max_inline=%s"},	... not supported */
> +/*	{Opt_alloc_start, "alloc_start=%s"},	... not supported */
> +/*	{Opt_thread_pool, "thread_pool=%d"},	... not supported */
> +	{Opt_compress, "compress"},
> +/*	{Opt_compress_type, "compress=%s"},		... TBD? */
> +	{Opt_compress_force, "compress-force"},
> +/*	{Opt_compress_force_type, "compress-force=%s"},	... TBD? */
> +	{Opt_ssd, "ssd"},
> +	{Opt_ssd_spread, "ssd_spread"},
> +	{Opt_nossd, "nossd"},
> +	{Opt_noacl, "noacl"},
> +	{Opt_notreelog, "notreelog"},
> +	{Opt_flushoncommit, "flushoncommit"},
> +/*	{Opt_ratio, "metadata_ratio=%d"},	... not supported */
> +	{Opt_discard, "discard"},
> +	{Opt_space_cache, "space_cache"},
> +	{Opt_clear_cache, "clear_cache"},
> +	{Opt_user_subvol_rm_allowed, "user_subvol_rm_allowed"},
> +/*	{Opt_enospc_debug, "enospc_debug"},	... never be default */
> +/*	{Opt_subvolrootid, "subvolrootid=%d"},	... not supported */
> +	{Opt_defrag, "autodefrag"},
> +	{Opt_inode_cache, "inode_cache"},
> +	{Opt_no_space_cache, "nospace_cache"},
> +	{Opt_recovery, "recovery"},
> +	{Opt_skip_balance, "skip_balance"},
> +	{Opt_check_integrity, "check_int"},
> +	{Opt_check_integrity_including_extent_data, "check_int_data"},
> +/*	{Opt_check_integrity_print_mask, "check_int_print_mask=%d"},
> +	{Opt_fatal_errors, "fatal_errors=%s"},	... not supported */
> +	{Opt_err, NULL},	/* must be end */
> +};
> +
> +void btrfs_parse_string2mntopt(u64 *optval, int optnum, char **options);
> +void btrfs_parse_mntopt2string(u64 optval);
> diff --git a/btrfs.c b/btrfs.c
> index a229cee..608869d 100644
> --- a/btrfs.c
> +++ b/btrfs.c
> @@ -250,6 +250,7 @@ const struct cmd_group btrfs_cmd_group = {
>   		{ "receive", cmd_receive, NULL, &receive_cmd_group, 0 },
>   		{ "quota", cmd_quota, NULL, &quota_cmd_group, 0 },
>   		{ "qgroup", cmd_qgroup, NULL, &qgroup_cmd_group, 0 },
> +		{ "mount-option", cmd_mount, NULL, &mount_cmd_group, 0 },
>   		{ "help", cmd_help, cmd_help_usage, NULL, 0 },
>   		{ "version", cmd_version, cmd_version_usage, NULL, 0 },
>   		{ 0, 0, 0, 0, 0 }
> diff --git a/cmds-mount.c b/cmds-mount.c
> new file mode 100644
> index 0000000..1752019
> --- /dev/null
> +++ b/cmds-mount.c
> @@ -0,0 +1,185 @@
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
> +static int mount_check_device(char *device)
> +{
> +	int ret;
> +
> +	ret = check_mounted(device);
> +	if (ret == 1) {
> +		fprintf(stderr, "%s is mounted\n", device);
> +		return 1;
> +	}

I think that "btrfs mount-option get <device>" command should not be an error
even if the device is mounted.

Thanks,
Tsutomu

> +	if (ret < 0) {
> +		fprintf(stderr, "error checking %s mount status with %d(%s)\n",
> +			device, ret, strerror(-1*ret));
> +		return 1;
> +	}
> +	return 0;
> +}


