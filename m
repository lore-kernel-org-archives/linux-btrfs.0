From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Is this function used?
Date: Wed, 22 Apr 2009 09:23:26 -0400
Message-ID: <1240406606.4731.41.camel@think.oraclecorp.com>
References: <d853ebb60904220409w20ed0e55y6834cd5de0d06a2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Siddhartha Swaroop <siddhartha.swaroop@greenturtles.in>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <d853ebb60904220409w20ed0e55y6834cd5de0d06a2@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-04-22 at 16:39 +0530, Siddhartha Swaroop wrote:
> Hello ,
> 
> Inside the file ctree.c at line 762 there is a function called
> check_block( ). The source code of that function is as follows
> 
> static noinline int check_block(struct btrfs_root *root,
>                                 struct btrfs_path *path, int level)
> {
>         return 0;
>         if (level == 0)
>                 return check_leaf(root, path, level);
>         return check_node(root, path, level);
> }
> 
> This function is called by balance_level and btrfs_search_slot
> functions.
> 
> By seeing this check_block function u may come to know that this
> function will not work if it is called,it will just return zero (means
> success) without doing anyother work.
>  I need to know why this code is written?

We should put the return 0 inside  CONFIG option for more extensive
metadata checking.  I enable check_block when I'm making changes that
are likely to cause corruptions in the btree code.  It tends to find
them more quickly.

-chris


