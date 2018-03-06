Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50277 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933324AbeCFA1M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Mar 2018 19:27:12 -0500
Date: Tue, 6 Mar 2018 01:24:51 +0100
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: adjust return values of btrfs_inode_by_name
Message-ID: <20180306002451.GJ5942@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180305091337.22854-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180305091337.22854-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 05, 2018 at 05:13:37PM +0800, Su Yue wrote:
> Previously, btrfs_inode_by_name() returns 0 which leaves caller to
> check objectid of location even location type is invalid.
> 
> Let btrfs_inode_by_name() returns -EUCLEAN if found corrupted
> location of a dir entry.
> Removal of label out_err also simplifies the function.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>

> ---
>  fs/btrfs/inode.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 53ca025655fc..c7155f9d7c6f 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5448,7 +5448,8 @@ void btrfs_evict_inode(struct inode *inode)
>  
>  /*
>   * this returns the key found in the dir entry in the location pointer.
> - * If no dir entries were found, location->objectid is 0.
> + * If no dir entries were found, returns -ENOENT.
> + * If found a corrupted location in dir entry, returns -EUCLEAN.
>   */
>  static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
>  			       struct btrfs_key *location)
> @@ -5466,27 +5467,27 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
>  
>  	di = btrfs_lookup_dir_item(NULL, root, path, btrfs_ino(BTRFS_I(dir)),
>  			name, namelen, 0);
> -	if (IS_ERR(di))
> +	if (unlikely(!di)) {

unlikely is not needed here, removed
