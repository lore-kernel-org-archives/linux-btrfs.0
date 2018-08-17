Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53420 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726356AbeHQRIM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Aug 2018 13:08:12 -0400
Date: Fri, 17 Aug 2018 16:04:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: btrfs_shrink_device should call commit
 transaction
Message-ID: <20180817140432.GV24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180725132727.642-1-anand.jain@oracle.com>
 <20180806101237.20507-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180806101237.20507-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 06, 2018 at 06:12:37PM +0800, Anand Jain wrote:
> test case btrfs/164 reported UAF..
> 
> [ 6712.084324] general protection fault: 0000 [#1] PREEMPT SMP
> ::
> [ 6712.195423]  btrfs_update_commit_device_size+0x75/0xf0 [btrfs]
> [ 6712.201424]  btrfs_commit_transaction+0x57d/0xa90 [btrfs]
> [ 6712.206999]  btrfs_rm_device+0x627/0x850 [btrfs]
> [ 6712.211800]  btrfs_ioctl+0x2b03/0x3120 [btrfs]
> ::
> 
> reason for this is that btrfs_shrink_device() adds the device resized to
> the fs_devices::resized_devices after it has called the last commit
> transaction.
> So the list fs_devices::resized_devices is not empty when
> btrfs_shrink_device() returns.
> Now the parent function btrfs_rm_device() calls
>         btrfs_close_bdev(device);
>         call_rcu(&device->rcu, free_device_rcu);
> and then does the commit transaction.
> The commit transaction goes through the fs_devices::resized_devices
> in btrfs_update_commit_device_size() and leads to UAF.
> 
> Fix this by making sure btrfs_shrink_device() calls the last needed
> btrfs_commit_transaction() before the return.
> 
> Reported-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Tested-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

The transaction commit makes more sense here, also is consistent with
what grow does.

Reviewed-by: David Sterba <dsterba@suse.com>
