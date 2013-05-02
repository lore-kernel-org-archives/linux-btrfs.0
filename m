Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab3EBEcF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 May 2013 00:32:05 -0400
Message-ID: <5181EC42.6090300@redhat.com>
Date: Wed, 01 May 2013 23:32:02 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Lin Ming <mlin@kernel.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix segfault in walk_down_tree
References: <1367462803-6630-1-git-send-email-mlin@kernel.org>
In-Reply-To: <1367462803-6630-1-git-send-email-mlin@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/1/13 9:46 PM, Lin Ming wrote:
> walk_down_tree will fault when read_tree_block fails with NULL returned.
> 
> Signed-off-by: Lin Ming <mlin@kernel.org>
> ---
>  cmds-check.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index 12192fa..e4435d5 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -1256,6 +1256,8 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
>  			reada_walk_down(root, cur, path->slots[*level]);
>  			next = read_tree_block(root, bytenr, blocksize,
>  					       ptr_gen);
> +			if (!next)
> +				goto out;
>  		}
>  
>  		*level = *level - 1;
> 

I suppose that could fix a segfault . . . although, details
would be nice.  next is only used as:

	path->nodes[*level] = next;

before it gets reassigned in the loop.  So I guess someone
uses the path array and doesn't handle a NULL?

Ok, but if read_tree_block fails(), doesn't that mean some error
occurred?  And if so, walk_down_tree would still return 0, 
which looks like success to the caller.  Then what?

I guess that's what the other error returns in this function
do as well.  :(

But this seems like suboptimal behavior for a filesystem checker,
doesn't it?  Just silently ignoring errors?

And while this might fix the segfault I'm afraid it does so without
really handling the problem, and it might never be noticed again.

The caller looks like it might handle an error, if one were ever
passed up (which it's not right now):

                wret = walk_down_tree(root, &path, wc, &level);
                if (wret < 0)
                        ret = wret;
                if (wret != 0)
                        break;

Over on the kernel side, this commit at least catches the error
and passes it up:

commit 97d9a8a420444eb5b5c071d4b3b9c4100a7ae015
Author: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date:   Thu Mar 24 06:33:21 2011 +0000

    Btrfs: check return value of read_tree_block()
    
    This patch is checking return value of read_tree_block(),
    and if it is NULL, error processing.
    
    Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
    Signed-off-by: Chris Mason <chris.mason@oracle.com>

...
                next = read_tree_block(root, bytenr, blocksize, generation);
+               if (!next)
+                       return -EIO;
...

so that's probably a better way to go, though it might require some testing.

Another reason to get userspace caught up w/ kernelspace, argh.

-Eric
