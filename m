Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33159 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaILF4O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Sep 2014 01:56:14 -0400
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 6A1953EE168
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 14:56:13 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 71881AC026F
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 14:56:12 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id D69BA1DB803B
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 14:56:11 +0900 (JST)
Received: from G01JPEXCHKW14.g01.fujitsu.local (G01JPEXCHKW14.g01.fujitsu.local [10.0.194.53])
	by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id A92C769271C
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 14:56:10 +0900 (JST)
Message-ID: <54128AF5.8080202@jp.fujitsu.com>
Date: Fri, 12 Sep 2014 14:56:05 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs-progs: deal with conflict options for btrfs
 fi show
References: <1410412751-9277-1-git-send-email-guihc.fnst@cn.fujitsu.com> <1410484541-16422-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1410484541-16422-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Gui,

(2014/09/12 10:15), Gui Hecheng wrote:
> For btrfs fi show, -d|--all-devices & -m|--mounted will
> overwrite each other, so if specified both, let the user
> know that he should not use them at the same time.
> 
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> ---
> changelog:
> 	v1->v2: add option conflict descriptions to manpage and usage.
> ---
>   Documentation/btrfs-filesystem.txt |  9 ++++++---
>   cmds-filesystem.c                  | 12 ++++++++++--
>   2 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
> index c9c0b00..d3d2dcc 100644
> --- a/Documentation/btrfs-filesystem.txt
> +++ b/Documentation/btrfs-filesystem.txt
> @@ -20,15 +20,18 @@ SUBCOMMAND
>   *df* <path> [<path>...]::
>   Show space usage information for a mount point.
>   
> -*show* [--mounted|--all-devices|<path>|<uuid>|<device>|<label>]::
> +*show* [-m|--mounted|-d|--all-devices|<path>|<uuid>|<device>|<label>]::

This line seems to be too long. Please see also the
following thread.

https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg36270.html

Thanks,
Satoru


>   Show the btrfs filesystem with some additional info.
>   +
>   If no option nor <path>|<uuid>|<device>|<label> is passed, btrfs shows
>   information of all the btrfs filesystem both mounted and unmounted.
> -If '--mounted' is passed, it would probe btrfs kernel to list mounted btrfs
> +If '-m|--mounted' is passed, it would probe btrfs kernel to list mounted btrfs
>   filesystem(s);
> -If '--all-devices' is passed, all the devices under /dev are scanned;
> +If '-d|--all-devices' is passed, all the devices under /dev are scanned;
>   otherwise the devices list is extracted from the /proc/partitions file.
> +Don't combine -m|--mounted and -d|--all-devices, because these two options
> +will overwrite each other, and only one scan way will be adopted,
> +probe the kernel to scan or scan devices under /dev.
>   
>   *sync* <path>::
>   Force a sync for the filesystem identified by <path>.
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index 69c1ca5..51c4c55 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -495,6 +495,7 @@ static const char * const cmd_show_usage[] = {
>   	"-d|--all-devices   show only disks under /dev containing btrfs filesystem",
>   	"-m|--mounted       show only mounted btrfs",
>   	"If no argument is given, structure of all present filesystems is shown.",
> +	"Don't combine -d|--all-devices and -m|--mounted, refer to manpage for details.",
>   	NULL
>   };
>   
> @@ -526,16 +527,23 @@ static int cmd_show(int argc, char **argv)
>   			break;
>   		switch (c) {
>   		case 'd':
> -			where = BTRFS_SCAN_PROC;
> +			where &= ~BTRFS_SCAN_LBLKID;
> +			where |= BTRFS_SCAN_PROC;
>   			break;
>   		case 'm':
> -			where = BTRFS_SCAN_MOUNTED;
> +			where &= ~BTRFS_SCAN_LBLKID;
> +			where |= BTRFS_SCAN_MOUNTED;
>   			break;
>   		default:
>   			usage(cmd_show_usage);
>   		}
>   	}
>   
> +	if ((where & BTRFS_SCAN_PROC) && (where & BTRFS_SCAN_MOUNTED)) {
> +		fprintf(stderr, "Don't use -d|--all-devices and -m|--mounted options at the same time.\n");
> +		usage(cmd_show_usage);
> +	}
> +
>   	if (check_argc_max(argc, optind + 1))
>   		usage(cmd_show_usage);
>   
> 

