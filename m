Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45854 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750820AbdJCQfb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Oct 2017 12:35:31 -0400
Date: Tue, 3 Oct 2017 18:33:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix fs_info->flags value
Message-ID: <20171003163354.GB31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201710020834.AA00001@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201710020834.AA00001@WIN-5MHF4RKU941.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 02, 2017 at 05:34:12PM +0900, Tsutomu Itoh wrote:
> Because the values of BTRFS_FS_QUOTA_OVERRIDE and BTRFS_FS_EXCL_OP overlap,
> we should change the value.
> 
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

Please write a more descriptive subject and changelog.

> ---
>  fs/btrfs/ctree.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 899ddaeeacec..566c0ba8dfb8 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -717,12 +717,11 @@ struct btrfs_delayed_root;
>  #define BTRFS_FS_QUOTA_OVERRIDE			14
>  /* Used to record internally whether fs has been frozen */
>  #define BTRFS_FS_FROZEN				15
> -

Unrelated change.

>  /*
>   * Indicate that a whole-filesystem exclusive operation is running
>   * (device replace, resize, device add/delete, balance)
>   */
> -#define BTRFS_FS_EXCL_OP			14
> +#define BTRFS_FS_EXCL_OP			16

Strange how this could have got there. I was suspecting a mis-merge but
the patches for number 14 went in in different releases so this actually
slipped through the review.

Please update and resend the patch with the following tags:

Fixes: f29efe292198b ("btrfs: add quota override flag to enable quota override for CAP_SYS_RESOURCE")
CC: stable@vger.kernel.org # 4.13+
