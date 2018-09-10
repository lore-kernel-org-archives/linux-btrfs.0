Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51342 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727784AbeIJVoA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Sep 2018 17:44:00 -0400
Date: Mon, 10 Sep 2018 18:48:43 +0200
From: David Sterba <dsterba@suse.cz>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Nikolay Borisov <nborisov@suse.com>, kbuild-all@01.org,
        David Sterba <dsterba@suse.com>,
        Chris Mason <chris.mason@fusionio.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH linux-next] btrfs: btrfs_run_delayed_refs_for_head()
 can be static
Message-ID: <20180910164843.GS24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201809102215.95hxOLVe%fengguang.wu@intel.com>
 <20180910150029.GA11874@lkp-wsm-ep1.lkp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180910150029.GA11874@lkp-wsm-ep1.lkp.intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 10, 2018 at 11:00:29PM +0800, kbuild test robot wrote:
> 
> Fixes: ac75a14eb672 ("btrfs: Factor out loop processing all refs of a head")
> Signed-off-by: kbuild test robot <fengguang.wu@intel.com>
> ---
>  extent-tree.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index b0882b6..719f1bb 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2537,9 +2537,9 @@ struct btrfs_delayed_ref_head *btrfs_obtain_ref_head(
>  }
>  
>  STATIC
> -int btrfs_run_delayed_refs_for_head(struct btrfs_trans_handle *trans,
> -				    struct btrfs_delayed_ref_head *locked_ref,
> -				    unsigned long *run_refs)
> +static int btrfs_run_delayed_refs_for_head(struct btrfs_trans_handle *trans,
> +					   struct btrfs_delayed_ref_head *locked_ref,
> +					   unsigned long *run_refs)

I have a cleanup series to get rid of the STATIC macro, will result in
normal 'static' of the function. The patch will need to be updated, you
can ignore the warning for now.

>  {
>  	struct btrfs_fs_info *fs_info = trans->fs_info;
>  	struct btrfs_delayed_ref_root *delayed_refs;
