Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58982 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750972AbeDMF2T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Apr 2018 01:28:19 -0400
Subject: Re: [PATCH 11/16] btrfs: kill btrfs_fs_info::volume_mutex
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1522780026.git.dsterba@suse.com>
 <773c3cb3c347d102718975831837e8eb7e9f30ad.1522780026.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <aca80fac-b712-f0c6-a35a-3cd70be6884f@oracle.com>
Date: Fri, 13 Apr 2018 13:30:22 +0800
MIME-Version: 1.0
In-Reply-To: <773c3cb3c347d102718975831837e8eb7e9f30ad.1522780026.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> @@ -4569,8 +4560,10 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
>   		/* this is either (2) or (3) */
>   		if (!atomic_read(&fs_info->balance_running)) {
>   			mutex_unlock(&fs_info->balance_mutex);
> -			if (!mutex_trylock(&fs_info->volume_mutex))
> -				goto again;


> +			/*
> +			 * Lock released to allow other waiters to continue,
> +			 * we'll reexamine the status again.
> +			 */

  I wonder if there was any case where performing the unlock and lock
  sequence on the balance_mutex has helped?
  Otherwise IMO we can clean this up as well. It looks like this sequence
  was needed only to acquire the volume_mutex.

Thanks, Anand


>   			mutex_lock(&fs_info->balance_mutex);
>   
>   			if (fs_info->balance_ctl &&

