From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [patch 1/2] Btrfs: double unlock bug in error handling
Date: Wed, 18 Apr 2012 13:29:46 +0200
Message-ID: <4F8EA5AA.2080202@jan-o-sch.net>
References: <20120418065903.GE12831@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120418065903.GE12831@elgon.mountain>
List-ID: <linux-btrfs.vger.kernel.org>

On 18.04.2012 08:59, Dan Carpenter wrote:
> The caller expects this function to return with the lock held and
> releases it immediately on error.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 2b35f8d..a0bb9dc 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2301,6 +2301,7 @@ static noinline int run_clustered_refs(struct
btrfs_trans_handle *trans,
>
>  				if (ret) {
>  					printk(KERN_DEBUG "btrfs: run_delayed_extent_op returned %d\n",
ret);
> +					spin_lock(&delayed_refs->lock);
>  					return ret;
>  				}
>
> @@ -2331,6 +2332,7 @@ static noinline int run_clustered_refs(struct
btrfs_trans_handle *trans,
>
>  		if (ret) {
>  			printk(KERN_DEBUG "btrfs: run_one_delayed_ref returned %d\n", ret);
> +			spin_lock(&delayed_refs->lock);
>  			return ret;
>  		}

I think the correct way to fix this is:

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a844204..9af261a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2450,7 +2450,6 @@ again:

                ret = run_clustered_refs(trans, root, &cluster);
                if (ret < 0) {
-                       spin_unlock(&delayed_refs->lock);
                        btrfs_abort_transaction(trans, root, ret);
                        return ret;
                }

-Jan
