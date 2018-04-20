Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:44496 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754843AbeDTNav (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 09:30:51 -0400
Subject: Re: [PATCH v2 12/16] btrfs: track running balance in a simpler way
To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1524146555.git.dsterba@suse.com>
 <6d512cf2c8f825592703ee0d45c51f22396e6078.1524146556.git.dsterba@suse.com>
 <6ab5bdc1-45a2-d0a4-cdc7-587731c4103a@oracle.com>
 <20180420115811.GM21272@twin.jikos.cz> <20180420121934.GP21272@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <6bb5f60f-0c22-a4e3-086c-f4a039875447@oracle.com>
Date: Fri, 20 Apr 2018 21:32:54 +0800
MIME-Version: 1.0
In-Reply-To: <20180420121934.GP21272@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

	



> Ok not that simple, the running status is checked outside of
> balance_mutex and there's one more assertion that does not expect the
> balance_ctl to exist:
> 
> @@ -4031,16 +4032,16 @@ int btrfs_pause_balance(struct btrfs_fs_info *fs_info)
>                  return -ENOTCONN;
>          }
> 
> -       if (atomic_read(&fs_info->balance_running)) {
> +       if (test_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags)) {
>                  atomic_inc(&fs_info->balance_pause_req);
>                  mutex_unlock(&fs_info->balance_mutex);
> 
>                  wait_event(fs_info->balance_wait_q,
> -                          atomic_read(&fs_info->balance_running) == 0);
> +                          !test_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags));
> 
> here it's unlocked
> 
>                  mutex_lock(&fs_info->balance_mutex);
>                  /* we are good with balance_ctl ripped off from under us */
> -               BUG_ON(atomic_read(&fs_info->balance_running));
> +               BUG_ON(test_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags));
> 
> and rewriting the code so this could be checked the same way is not a simple
> fixup as I expected.
> 
> As there's still the extra balance mutex lock/unlock after the volume
> mutex removal, I'll have a look how this could be cleaned up further.
> 
>                  atomic_dec(&fs_info->balance_pause_req);
>          } else {
>                  ret = -ENOTCONN;

  Makes sense.

Thanks, Anand

