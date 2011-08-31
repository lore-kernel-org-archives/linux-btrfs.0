From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH] Btrfs: fix an oops of log replay
Date: Wed, 31 Aug 2011 10:17:03 +0200
Message-ID: <4E5DEDFF.9080909@gmx.net>
References: <1312619723-31094-1-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1312619723-31094-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06.08.2011 10:35, Liu Bo wrote:
> When btrfs recovers from a crash, it may hit the oops below:
> 
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/inode.c:4580!
> [...]
> RIP: 0010:[<ffffffffa03df251>]  [<ffffffffa03df251>] btrfs_add_link+0x161/0x1c0 [btrfs]
> [...]
> Call Trace:
>  [<ffffffffa03e7b31>] ? btrfs_inode_ref_index+0x31/0x80 [btrfs]
>  [<ffffffffa04054e9>] add_inode_ref+0x319/0x3f0 [btrfs]
>  [<ffffffffa0407087>] replay_one_buffer+0x2c7/0x390 [btrfs]
>  [<ffffffffa040444a>] walk_down_log_tree+0x32a/0x480 [btrfs]
>  [<ffffffffa0404695>] walk_log_tree+0xf5/0x240 [btrfs]
>  [<ffffffffa0406cc0>] btrfs_recover_log_trees+0x250/0x350 [btrfs]
>  [<ffffffffa0406dc0>] ? btrfs_recover_log_trees+0x350/0x350 [btrfs]
>  [<ffffffffa03d18b2>] open_ctree+0x1442/0x17d0 [btrfs]
> [...]
> 
> This comes from that while replaying an inode ref item, we forget to
> check those old conflicting DIR_ITEM and DIR_INDEX items in fs/file tree,
> then we will come to conflict corners which lead to BUG_ON().

Is this a workaround for an on-disk corruption or a bug fix for the
log replay code? It sounds like the latter, but I ask to be sure :)

-Arne

> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>  fs/btrfs/tree-log.c |   28 ++++++++++++++++++++++++----
>  1 files changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index babee65..786639f 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -799,14 +799,15 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>  				  struct extent_buffer *eb, int slot,
>  				  struct btrfs_key *key)
>  {
> -	struct inode *dir;
> -	int ret;
>  	struct btrfs_inode_ref *ref;
> +	struct btrfs_dir_item *di;
> +	struct inode *dir;
>  	struct inode *inode;
> -	char *name;
> -	int namelen;
>  	unsigned long ref_ptr;
>  	unsigned long ref_end;
> +	char *name;
> +	int namelen;
> +	int ret;
>  	int search_done = 0;
>  
>  	/*
> @@ -909,6 +910,25 @@ again:
>  	}
>  	btrfs_release_path(path);
>  
> +	/* look for a conflicting sequence number */
> +	di = btrfs_lookup_dir_index_item(trans, root, path, btrfs_ino(dir),
> +					 btrfs_inode_ref_index(eb, ref),
> +					 name, namelen, 0);
> +	if (di && !IS_ERR(di)) {
> +		ret = drop_one_dir_item(trans, root, path, dir, di);
> +		BUG_ON(ret);
> +	}
> +	btrfs_release_path(path);
> +
> +	/* look for a conflicing name */
> +	di = btrfs_lookup_dir_item(trans, root, path, btrfs_ino(dir),
> +				   name, namelen, 0);
> +	if (di && !IS_ERR(di)) {
> +		ret = drop_one_dir_item(trans, root, path, dir, di);
> +		BUG_ON(ret);
> +	}
> +	btrfs_release_path(path);
> +
>  insert:
>  	/* insert our name */
>  	ret = btrfs_add_link(trans, dir, inode, name, namelen, 0,

