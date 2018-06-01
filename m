Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54375 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750760AbeFAGyt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Jun 2018 02:54:49 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 190FDACFA
        for <linux-btrfs@vger.kernel.org>; Fri,  1 Jun 2018 06:54:48 +0000 (UTC)
Subject: Re: [PATCH REBASED 1/1] btrfs-progs: inspect-dump-tree: Allow
 '-b|--block' to be specified multiple times
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180601051526.19564-1-wqu@suse.com>
 <20180601051526.19564-2-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <9718afcd-3eca-2ce9-b8a1-b05d07c987b3@suse.com>
Date: Fri, 1 Jun 2018 09:54:46 +0300
MIME-Version: 1.0
In-Reply-To: <20180601051526.19564-2-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  1.06.2018 08:15, Qu Wenruo wrote:
> Reuse extent-cache facility to record multiple bytenr so '-b|--block'
> can be specified multiple times.
> 
> Despite that, add a sector size alignment check before we try to print a
> tree block.
> (Please note that, nodesize alignment check is not suitable here as meta
> chunk start bytenr could be unaligned to nodesize)
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Just one minor misspell but otherwise LGTM:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  Documentation/btrfs-inspect-internal.asciidoc |   2 +-
>  cmds-inspect-dump-tree.c                      | 109 +++++++++++++++---
>  2 files changed, 91 insertions(+), 20 deletions(-)
> 
> diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentation/btrfs-inspect-internal.asciidoc
> index e2db64660b9a..ba8529f57660 100644
> --- a/Documentation/btrfs-inspect-internal.asciidoc
> +++ b/Documentation/btrfs-inspect-internal.asciidoc
> @@ -86,7 +86,7 @@ the respective tree root block offset
>  -u|--uuid::::
>  print only the uuid tree information, empty output if the tree does not exist
>  -b <block_num>::::
> -print info of the specified block only
> +print info of the specified block only, can be specified multiple times.
>  --follow::::
>  use with '-b', print all children tree blocks of '<block_num>'
>  -t <tree_id>::::
> diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
> index 92a2a45b267e..abb9a2bcc7cb 100644
> --- a/cmds-inspect-dump-tree.c
> +++ b/cmds-inspect-dump-tree.c
> @@ -198,11 +198,92 @@ const char * const cmd_inspect_dump_tree_usage[] = {
>  	"-R|--backups           same as --roots plus print backup root info",
>  	"-u|--uuid              print only the uuid tree",
>  	"-b|--block <block_num> print info from the specified block only",
> +	"                       can be specified multile times",
nit: s/multile/multiple
