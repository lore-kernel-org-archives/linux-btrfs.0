Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42093 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753603AbeDQRK3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 13:10:29 -0400
Date: Tue, 17 Apr 2018 19:07:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add comment about BTRFS_FS_EXCL_OP
Message-ID: <20180417170756.GH21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180416102831.12388-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180416102831.12388-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 16, 2018 at 06:28:31PM +0800, Anand Jain wrote:
> Adds comments about BTRFS_FS_EXCL_OP to existing comments
> about the device locks.

Thanks, a few comments below.

> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 3a3912a9dec9..18306165ffaa 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -202,6 +202,22 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>   *   device_list_mutex
>   *     chunk_mutex
>   *   balance_mutex
> + *
> + * BTRFS_FS_EXCL_OP
> + * ----------------
> + * Maintains the exclusivity of the following device operations.
> + *
> + * - Balance (*)
> + * - Add

device add

> + * - Remove

device remove

> + * - Replace (*)

device replace

> + * - Resize
> + *
> + * The device operation with (*) indicate it can continue after a CLI pause
> + * (only balance can be paused using CLI) or remount or unmount-mount sequence
> + * or a power-recycle, as long as the FS is still writeable. And during the

this would be more readable if is' a bullet list like above

> + * course of the pause, the BTRFS_FS_EXCL_OP remains set. BTRFS_FS_EXCL_OP flag
> + * is set and cleared using atomic functions.

Please rephrase that without the CLI and use 'ioctl' instead, as this
is the interface.

>   */
>  
>  DEFINE_MUTEX(uuid_mutex);
