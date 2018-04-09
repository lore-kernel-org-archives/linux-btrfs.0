Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48668 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750759AbeDIHlG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Apr 2018 03:41:06 -0400
Subject: Re: [PATCH 09/16] btrfs: cleanup helpers that reset balance state
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1522780026.git.dsterba@suse.com>
 <a0fff9cb92264458531b286b80cb5f07042d7d12.1522780026.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <a938728a-db93-d1a7-13b1-9639e3e1b757@oracle.com>
Date: Mon, 9 Apr 2018 15:43:04 +0800
MIME-Version: 1.0
In-Reply-To: <a0fff9cb92264458531b286b80cb5f07042d7d12.1522780026.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/04/2018 02:34 AM, David Sterba wrote:
> The function __cancel_balance name is confusing with the cancel
> operation of balance and it really resets the state of balance back to
> zero. The unset_balance_control helper is called only from one place and
> simple enough to be inlined.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

A nitpick below.

> ---
>   fs/btrfs/ioctl.c   |  8 ++++----
>   fs/btrfs/volumes.c | 27 ++++++++++++---------------
>   2 files changed, 16 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 582bde5b7eda..2f172122b63d 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4653,10 +4653,10 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
>   
>   do_balance:
>   	/*
> -	 * Ownership of bctl and filesystem flag BTRFS_FS_EXCL_OP
> -	 * goes to to btrfs_balance.  bctl is freed in __cancel_balance,
> -	 * or, if restriper was paused all the way until unmount, in
> -	 * free_fs_info.  The flag should be cleared after __cancel_balance.


> +	 * Ownership of bctl and filesystem flag BTRFS_FS_EXCL_OP goes to to

  delete one 'to'.

Thanks, Anand
