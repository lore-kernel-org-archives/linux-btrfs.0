Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54311 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758463AbaGXDW5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 23:22:57 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 9C20D3EE0AE
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 12:22:55 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id A9A2AAC082D
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 12:22:54 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 59D861DB803B
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 12:22:54 +0900 (JST)
Message-ID: <53D07C07.2090302@jp.fujitsu.com>
Date: Thu, 24 Jul 2014 12:22:47 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: fix build of static target
References: <1406121381-18611-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1406121381-18611-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/07/23 22:16), David Sterba wrote:
> A user repoted that static buid fails with
> 
> utils-lib.static.o: In function `arg_strtou64':
> /home/dsterba/labs/btrfs-progs/utils-lib.c:17: multiple definition of `arg_strtou64'
> utils-lib.static.o:/home/dsterba/labs/btrfs-progs/utils-lib.c:17: first defined here
> 
> utils-lib.o was mistakenly added to linker twice.
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

> ---
>   Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 8e14d4837520..3853b8734568 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -10,7 +10,7 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
>   	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
>   	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
>   	  qgroup.o raid6.o free-space-cache.o list_sort.o props.o \
> -	  utils-lib.o ulist.o qgroup-verify.o
> +	  ulist.o qgroup-verify.o
>   cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
>   	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
>   	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
> 

