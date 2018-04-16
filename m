Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52154 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752921AbeDPJlo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 05:41:44 -0400
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH 13/16] btrfs: remove redundant read-only check from
 btrfs_cancel_balance
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1522780026.git.dsterba@suse.com>
 <afdb0e99249c050b26a200ccbbc772a1ef90c1a4.1522780026.git.dsterba@suse.com>
Message-ID: <8f34dff3-63e6-4ad6-115a-57959ede2124@oracle.com>
Date: Mon, 16 Apr 2018 17:43:46 +0800
MIME-Version: 1.0
In-Reply-To: <afdb0e99249c050b26a200ccbbc772a1ef90c1a4.1522780026.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/04/2018 02:34 AM, David Sterba wrote:
> Balance cannot be started on a read-only filesystem and will have to
> finish/exit before eg. going to read-only via remount. Cancelling does
> not need to check for that.
> 
> In case the filesystem is forcibly set to read-only after an error,
> balance will finish anyway and if the cancel call is too fast it will
> just wait for that to happen. Again does not have to check.

  What if there is a power recycle and mounted as readonly
  after the reboot?

Thanks, Anand


> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/volumes.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index a0420af1fad9..2956e7b4cb9f 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4053,9 +4053,6 @@ int btrfs_pause_balance(struct btrfs_fs_info *fs_info)
>   
>   int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
>   {
> -	if (sb_rdonly(fs_info->sb))
> -		return -EROFS;
> -
>   	mutex_lock(&fs_info->balance_mutex);
>   	if (!fs_info->balance_ctl) {
>   		mutex_unlock(&fs_info->balance_mutex);
> 
