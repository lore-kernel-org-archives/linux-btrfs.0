Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35198 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966464AbeEYP6Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 May 2018 11:58:16 -0400
Date: Fri, 25 May 2018 17:55:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: drop uuid_mutex in btrfs_free_extra_devids()
Message-ID: <20180525155530.GP6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180412022938.8257-11-anand.jain@oracle.com>
 <20180523025422.32572-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180523025422.32572-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 23, 2018 at 10:54:22AM +0800, Anand Jain wrote:
> btrfs_free_extra_devids() is called only in the mount context which
> traverses through the fs_devices::devices and frees the orphan devices
> devices in the given %fs_devices if any. As the search for the orphan
> device is limited to fs_devices::devices so we don't need the global
> uuid_mutex.
> 
> There can't be any mount-point based ioctl threads in this context as
> the mount thread is not yet returned. But there can be the btrfs-control
> based scan ioctls thread which calls device_list_add().
> 
> Here in the mount thread the fs_devices::opened is incremented way before
> btrfs_free_extra_devids() is called and in the scan context the fs_devices
> which are already opened neither be freed or alloc-able at
> device_list_add().
> 
> But lets say you change the device-path and call the scan again, then scan
> would update the new device path and this operation could race against the
> btrfs_free_extra_devids() thread, which might be in the process of
> free-ing the same device. So synchronize it by using the
> device_list_mutex.
> 
> This scenario is a very corner case, and practically the scan and mount
> are anyway serialized by the usage so unless the race is instrumented its
> very difficult to achieve.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Thanks, this explanation is much better and addresses the questions I
have while reading the code.

Reviewed-by: David Sterba <dsterba@suse.com>

> ---
> Currently device_list_add() is very lean on its device_list_mutex usage,
> a cleanup and fix is wip.

I also have a WIP patch to rewrite device_list_add. There were quite
some changes around the device locking so I'd need to refresh it on top
of current code first, it's not in a shape to be posted yet.
