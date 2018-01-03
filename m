Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58531 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751597AbeACOjP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Jan 2018 09:39:15 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 57391AE63
        for <linux-btrfs@vger.kernel.org>; Wed,  3 Jan 2018 14:39:14 +0000 (UTC)
Date: Wed, 3 Jan 2018 15:37:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: Don't generate UUID for non-fs tree
Message-ID: <20180103143708.GC3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171031060816.683-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171031060816.683-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 31, 2017 at 02:08:16PM +0800, Qu Wenruo wrote:
> btrfs_create_tree() will unconditionally generate UUID for any root.
> So for quota tree and data reloc tree created by kernel, they will have
> unique UUIDs.
> 
> However UUID in root item is only referred by UUID tree, which only
> records UUID for fs trees.
> This makes unique UUIDs for quota/data reloc tree meaningless.
> 
> Leave the UUID as zero for non-fs tree, making btrfs-debug-tree output
> less confusing.
> 
> Reported-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index dfdab849037b..d85e04a675fe 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1403,7 +1403,7 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
>  	struct btrfs_root *root;
>  	struct btrfs_key key;
>  	int ret = 0;
> -	uuid_le uuid;
> +	uuid_le uuid = { 0 };

I get a warning with gcc 4.8.5

fs/btrfs/disk-io.c:1236:2: warning: missing braces around initializer [-Wmissing-braces]

but no warning with gcc 7.2.1 (built as 'make ccflags-y=-Wmissing-braces
and checking that the option is really there). I think we should use
NULL_UUID_LE.
