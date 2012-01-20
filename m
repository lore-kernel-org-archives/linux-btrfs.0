From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [patch] Btrfs: fix bitwise vs logical condition
Date: Fri, 20 Jan 2012 16:24:37 +0200
Message-ID: <20120120142437.GA2499@zambezi.lan>
References: <20120120075454.GA2295@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120120075454.GA2295@elgon.mountain>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 20, 2012 at 10:54:55AM +0300, Dan Carpenter wrote:
> The intent here was to do a logical && instead of a bitwise &.  The
> original condition tests whether they have the some of same bits set.
> I have fixed that and rewritten it to be more clear.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Warning:  This is a static analysis bug and I'm not very familiar with
> the code.  Please review carefully.
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 0b4e2af..0c54027 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2376,8 +2376,8 @@ static int should_balance_chunk(struct btrfs_root *root,
>  	u64 chunk_type = btrfs_chunk_type(leaf, chunk);
>  
>  	/* type filter */
> -	if (!((chunk_type & BTRFS_BLOCK_GROUP_TYPE_MASK) &
> -	      (bctl->flags & BTRFS_BALANCE_TYPE_MASK))) {
> +	if (!(chunk_type & BTRFS_BLOCK_GROUP_TYPE_MASK) ||
> +	    !(bctl->flags & BTRFS_BALANCE_TYPE_MASK)) {
>  		return 0;
>  	}
>  

The intent here is definitely bitwise &.  The original code tests
whether at least one of the bits set in (chunk_type & MASK) is set in
(bctl_flags & MASK), and if not returns 0.  IOW,

u64 mask = chunk_type & BTRFS_BLOCK_GROUP_TYPE_MASK;

if (((bctl->flags & BTRFS_BALANCE_TYPE_MASK) & mask) == 0)
	return 0;

Your patch does something completely different.  However, I think we can
strengthen that check (and make it more idiomatic).  Can you try the
below diff with your checker ?

Thanks,

		Ilya


diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7ffdb15..9c6a074 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2375,12 +2375,11 @@ static int should_balance_chunk(struct btrfs_root *root,
 	struct btrfs_balance_control *bctl = root->fs_info->balance_ctl;
 	struct btrfs_balance_args *bargs = NULL;
 	u64 chunk_type = btrfs_chunk_type(leaf, chunk);
+	u64 mask = chunk_type & BTRFS_BLOCK_GROUP_TYPE_MASK;
 
 	/* type filter */
-	if (!((chunk_type & BTRFS_BLOCK_GROUP_TYPE_MASK) &
-	      (bctl->flags & BTRFS_BALANCE_TYPE_MASK))) {
+	if (((bctl->flags & BTRFS_BALANCE_TYPE_MASK) & mask) != mask)
 		return 0;
-	}
 
 	if (chunk_type & BTRFS_BLOCK_GROUP_DATA)
 		bargs = &bctl->data;
