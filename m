Return-Path: <SRS0=TRLW=RO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46D71C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 12:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 163D920657
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 12:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfCKMd3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Mar 2019 08:33:29 -0400
Received: from mout.gmx.net ([212.227.17.21]:43589 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbfCKMd3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Mar 2019 08:33:29 -0400
Received: from [0.0.0.0] ([173.82.105.236]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LfXmv-1gjxfs27mD-00p10S; Mon, 11
 Mar 2019 13:33:22 +0100
Subject: Re: [PATCH v4] btrfs-progs: dump-tree: add noscan option
To:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1551336865-9954-1-git-send-email-anand.jain@oracle.com>
From:   Su Yue <Damenly_Su@gmx.com>
Message-ID: <aab9c700-bb80-9481-3fd6-151872107612@gmx.com>
Date:   Mon, 11 Mar 2019 20:33:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:66.0)
 Gecko/20100101 Thunderbird/66.0
MIME-Version: 1.0
In-Reply-To: <1551336865-9954-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:7Pc8I48OQx5HPjDV40zFKa6JZGFANVP2eYMQNVeP3gdMbmeTnS4
 LR2FtfzQcg/nsLY54FGB9oVbObsHN2NC4g/NbpQf6G2keEFbZAgxUcUEGoqgoQMKnDObNev
 YBGwtV6ftBKJP/22PJkVRuU2BuHCNkZiUS2mfLvISdGJidg2kHe1Kqk2EuqPNSxhu6653kw
 53k+XSttumiBa+CfSTfVA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:GG4aqd01GTA=:W6EKYerGP3nohtabc09DnX
 GH1LqWfwOSnXoK+hmHCRlNlIYx0z3KI7oSZqgFSWTNUW5cLYOEkD34ZONdizW6DTdHilsj1cT
 tXy0nH4cokZ9GQflGgXjXRk9fUn2NliPbOSCh9+OIpATmo2VdZsQvKt6ZUk4exsnkQawSH45i
 hNVcoIFqjg7wUVTzzJTyFMZ48c60dFMBvzgTQyDBfK9zVDUTBQnC/omFsCas2kjrfaCKvHGTo
 2jhNpa+PViql8d0fHhBD3YqdIYjUsxtV6wJycZ3mZiow4eSJGhjxjaufs1uHKJW/7krUyIelO
 Bjtpi6v0gwgQIpob5iSSNizZtGNWW/8dU/mhY4JmWfyaYSKOD4AdSjdxkLYq8v6Mt54P/yA1m
 +9TPqqc7DoPXPE2hcdtZuS98BOWO7i08K+xuZBx7lpfrgGVdq9vCEBf/0DDtdl3o5mc/g7tXv
 ujrmaffR1/zOHmwfescY8V7A2cTPW62mzw10SkxbBshBvYcDMNGEpLBzySGBgBTy5Q72ddFrw
 ZvSkt4L6ktrnwUNYw1N/lK51lp0iWw1t8Bzo7ayeN13boPtSWFwxJUWbOvdeH3nHQeIZua1Uf
 +tdavS8majAHLDa+kjez9H/J6i4PXABWuZ5HtSvx4EDrOZAOB5Uvtko/g1zyhbTOpt4pFRMAl
 ibVH91yDr5ygD94keqMUEl84xp+Sfway+b9r81ltawuumzH89qsSWb90VMpqZYMxMqfhytQXg
 v0Pe8aGXoPnaPMfTz42Tdx8aOZJQiHQmPZIzL819yAyfy1t9ETr2Z51o9VCywipcgaIQYwtw8
 hNyHFfFCnElgEScy8CDTJOe7WomB4BDe6fb7kdKGUMeU/6bBmLY27oYX51AvHqj2mIXaAi6Ma
 Pe9nP/jvF0/DJ8ml5X+wYmG+nTkd0ObjXq8gJG4u0g6PYpqU34C9TpFv+kz8ROVuGMzprrCIs
 r5s5Yi4UT9A==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/2/28 2:54 PM, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> There is no way to dump tree from a disk in the degraded mode.
> Such as, when you specify a device for the cli 'btrfs inspect
> dump-tree /dev/sda' it would invariably scan for its partner devices
> to built and print the tree. This approach at times defeats the purpose.
> Suppose in RAID1 if you want to review each mirror separately as of now
> there is no way you can do that. So this patch adds an option --noscan
> for example:
>    'btrfs inspect dump-tree --noscan <dev> [<dev>..]'
> with which it shall not scan for the other devices to report the tree, and
> helps debug RAID1s.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> v3->v4: change the patch title.
> 	collapse scan_args() to its only parent cmd_inspect_dump_tree()
> 	(it was bit confusing).
> 	update the change log.
> 	update usage.
> 	update man page.
> v2->v3: make it scalable for more than two disks in noscan mode
> v1->v2: rename --degraded to --noscan
> ---
>   Documentation/btrfs-inspect-internal.asciidoc |  5 ++-
>   cmds-inspect-dump-tree.c                      | 57 ++++++++++++++++++++-------
>   2 files changed, 47 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentation/btrfs-inspect-internal.asciidoc
> index 381497d284b8..f9d7f1c58f00 100644
> --- a/Documentation/btrfs-inspect-internal.asciidoc
> +++ b/Documentation/btrfs-inspect-internal.asciidoc
> @@ -61,7 +61,7 @@ specify which mirror to print, valid values are 0, 1 and 2 and the superblock
>   must be present on the device with a valid signature, can be used together with
>   '--force'
>   
> -*dump-tree* [options] <device>::
> +*dump-tree* [options] <device> [device...]::
>   (replaces the standalone tool *btrfs-debug-tree*)
>   +
>   Dump tree structures from a given device in textual form, expand keys to human
> @@ -95,6 +95,9 @@ intermixed in the output
>   --bfs::::
>   use breadth-first search to print trees. the nodes are printed before all
>   leaves
> +--noscan::::
> +do not scan the system for other partner device(s), only use the device(s)
> +provided in the argument
>   -t <tree_id>::::
>   print only the tree with the specified ID, where the ID can be numerical or
>   common name in a flexible human readable form
> diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
> index ad5345b4f1db..9dd040e5de17 100644
> --- a/cmds-inspect-dump-tree.c
> +++ b/cmds-inspect-dump-tree.c
> @@ -21,6 +21,7 @@
>   #include <unistd.h>
>   #include <uuid/uuid.h>
>   #include <getopt.h>
> +#include <fcntl.h>
>   
>   #include "kerncompat.h"
>   #include "radix-tree.h"
> @@ -185,7 +186,7 @@ static u64 treeid_from_string(const char *str, const char **end)
>   }
>   
>   const char * const cmd_inspect_dump_tree_usage[] = {
> -	"btrfs inspect-internal dump-tree [options] device",
> +	"btrfs inspect-internal dump-tree [options] <device> [<device> ..]",
>   	"Dump tree structures from a given device",
>   	"Dump tree structures from a given device in textual form, expand keys to human",
>   	"readable equivalents where possible.",
> @@ -200,6 +201,7 @@ const char * const cmd_inspect_dump_tree_usage[] = {
>   	"-b|--block <block_num> print info from the specified block only",
>   	"-t|--tree <tree_id>    print only tree with the given id (string or number)",
>   	"--follow               use with -b, to show all children tree blocks of <block_num>",
> +	"--noscan               do not scan for the partner device(s)",
>   	NULL
>   };
>   
> @@ -214,7 +216,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>   	struct btrfs_disk_key disk_key;
>   	struct btrfs_key found_key;
>   	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
> -	int ret;
> +	int ret = 0;
>   	int slot;
>   	int extent_only = 0;
>   	int device_only = 0;
> @@ -222,6 +224,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>   	int roots_only = 0;
>   	int root_backups = 0;
>   	int traverse = BTRFS_PRINT_TREE_DEFAULT;
> +	int dev_optind;
>   	unsigned open_ctree_flags;
>   	u64 block_only = 0;
>   	struct btrfs_root *tree_root_scan;
> @@ -239,8 +242,8 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>   	optind = 0;
>   	while (1) {
>   		int c;
> -		enum { GETOPT_VAL_FOLLOW = 256, GETOPT_VAL_DFS,
> -		       GETOPT_VAL_BFS };
> +		enum { GETOPT_VAL_FOLLOW = 256, GETOPT_VAL_DFS, GETOPT_VAL_BFS,
> +		       GETOPT_VAL_NOSCAN};
>   		static const struct option long_options[] = {
>   			{ "extents", no_argument, NULL, 'e'},
>   			{ "device", no_argument, NULL, 'd'},
> @@ -252,6 +255,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>   			{ "follow", no_argument, NULL, GETOPT_VAL_FOLLOW },
>   			{ "bfs", no_argument, NULL, GETOPT_VAL_BFS },
>   			{ "dfs", no_argument, NULL, GETOPT_VAL_DFS },
> +			{ "noscan", no_argument, NULL, GETOPT_VAL_NOSCAN },
>   			{ NULL, 0, NULL, 0 }
>   		};
>   
> @@ -313,24 +317,49 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>   		case GETOPT_VAL_BFS:
>   			traverse = BTRFS_PRINT_TREE_BFS;
>   			break;
> +		case GETOPT_VAL_NOSCAN:
> +			open_ctree_flags |= OPEN_CTREE_NO_DEVICES;
> +			break;
>   		default:
>   			usage(cmd_inspect_dump_tree_usage);
>   		}
>   	}
>   
> -	if (check_argc_exact(argc - optind, 1))
> +	if (check_argc_min(argc - optind, 1))
>   		usage(cmd_inspect_dump_tree_usage);
>   
> -	ret = check_arg_type(argv[optind]);
> -	if (ret != BTRFS_ARG_BLKDEV && ret != BTRFS_ARG_REG) {
> -		if (ret < 0) {
> -			errno = -ret;
> -			error("invalid argument %s: %m", argv[optind]);
> -		} else {
> -			error("not a block device or regular file: %s",
> -			      argv[optind]);
> +	dev_optind = optind;
> +	while (dev_optind < argc) {
> +		int fd;
> +		struct btrfs_fs_devices *fs_devices;
> +		u64 num_devices;
> +
> +		ret = check_arg_type(argv[optind]);
> +		if (ret != BTRFS_ARG_BLKDEV && ret != BTRFS_ARG_REG) {
> +			if (ret < 0) {
> +				errno = -ret;
> +				error("invalid argument %s: %m", argv[dev_optind]);
> +			} else {
> +				error("not a block device or regular file: %s",
> +				       argv[dev_optind]);
> +			}
>   		}
> -		goto out;
> +		fd = open(argv[dev_optind], O_RDONLY);
> +		if (fd < 0) {
> +			error("cannot open %s: %m", argv[dev_optind]);
> +			return -EINVAL;
> +		}
> +		ret = btrfs_scan_one_device(fd, argv[dev_optind], &fs_devices,
> +					    &num_devices,
> +					    BTRFS_SUPER_INFO_OFFSET,
> +					    SBREAD_DEFAULT);
> +		close(fd);
> +		if (ret) {
> +			error("device scan %s: %s", argv[dev_optind],
> +			       strerror(-ret));

Nit:

Should do some change to follow current "%m" style?

Thanks
Su
> +			return ret;
> +		}
> +		dev_optind++;
>   	}
>   
>   	printf("%s\n", PACKAGE_STRING);
> 
