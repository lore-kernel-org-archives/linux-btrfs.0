Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46391 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750832AbdFZO2V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 10:28:21 -0400
Date: Mon, 26 Jun 2017 16:27:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: mkfs: Replace number with a macro
Message-ID: <20170626142711.GK2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170626101829.16021-1-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170626101829.16021-1-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 26, 2017 at 06:18:29PM +0800, Gu Jinxiang wrote:
> For code maintainability and scalability,
> replace number with a macro of member blocks in btrfs_mkfs_config.
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> ---
> Changes since v1:
> Missing a using place. And modify it.
> 
>  mkfs/common.c | 4 ++--
>  mkfs/common.h | 5 ++++-
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/mkfs/common.c b/mkfs/common.c
> index e4785c5..0d79650 100644
> --- a/mkfs/common.c
> +++ b/mkfs/common.c
> @@ -94,7 +94,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
>  	uuid_generate(chunk_tree_uuid);
>  
>  	cfg->blocks[0] = BTRFS_SUPER_INFO_OFFSET;
> -	for (i = 1; i < 7; i++) {
> +	for (i = 1; i <= BTRFS_MKFS_ROOTS_NR; i++) {

I'm not sure this is the best way to make the code more readable. "NR"
is the count of the roots and if it were used as " < NR" then it's clear
that we're iterating over a given number of items, but here the count is
also going to be used as an index to an array.

While this is correct, it's still necessary to keep in mind that some +1
or <= is needed while dealing with the blocks.

make_btrfs could use some heavy cleanup so we don't rely on the
hardcoded constants, in a similar way to reference_root_table so we can
use symbolic tree names.
