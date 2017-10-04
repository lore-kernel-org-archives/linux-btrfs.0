Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41993 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752230AbdJDOn1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Oct 2017 10:43:27 -0400
Date: Wed, 4 Oct 2017 16:41:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] Btrfs: fix overlap of fs_info->flags values
Message-ID: <20171004144142.GC3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201710040205.AA00002@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201710040205.AA00002@WIN-5MHF4RKU941.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 04, 2017 at 11:05:17AM +0900, Tsutomu Itoh wrote:
> Because the values of BTRFS_FS_EXCL_OP and BTRFS_FS_QUOTA_OVERRIDE overlap,
> we should change the value.
> 
> First, BTRFS_FS_EXCL_OP was set to 14.
> 
>   commit 171938e52807 ("btrfs: track exclusive filesystem operation in flags")
> 
> Next, the value of BTRFS_FS_QUOTA_OVERRIDE was set to 14.
> 
>   commit f29efe292198 ("btrfs: add quota override flag to enable quota override for CAP_SYS_RESOURCE")
> 
> As a result, the value 14 overlapped.
> This problem is solved by defining the value of BTRFS_FS_QUOTA_OVERRIDE
> as 16.
> 
> Fixes: f29efe292198 ("btrfs: add quota override flag to enable quota override for CAP_SYS_RESOURCE")
> CC: stable@vger.kernel.org # 4.13+
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> ---
> v2: changed the value of BTRFS_FS_QUOTA_OVERRIDE instead of BTRFS_FS_EXCL_OP
>     to 16.
> 
>  fs/btrfs/ctree.h | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 899ddaeeacec..d265ea7f763e 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -714,15 +714,14 @@ struct btrfs_delayed_root;
>  #define BTRFS_FS_BTREE_ERR			11
>  #define BTRFS_FS_LOG1_ERR			12
>  #define BTRFS_FS_LOG2_ERR			13
> -#define BTRFS_FS_QUOTA_OVERRIDE			14
> -/* Used to record internally whether fs has been frozen */
> -#define BTRFS_FS_FROZEN				15
> -
>  /*
>   * Indicate that a whole-filesystem exclusive operation is running
>   * (device replace, resize, device add/delete, balance)
>   */
>  #define BTRFS_FS_EXCL_OP			14
> +/* Used to record internally whether fs has been frozen */
> +#define BTRFS_FS_FROZEN				15
> +#define BTRFS_FS_QUOTA_OVERRIDE			16

Thanks. I think we can keep the patch minimal and only change
BTRFS_FS_EXCL_OP to 16, I'll update the patch and commit.

Reviewed-by: David Sterba <dsterba@suse.com>
