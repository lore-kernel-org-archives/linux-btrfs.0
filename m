Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49200 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750858AbeDSPZ2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 11:25:28 -0400
Date: Thu, 19 Apr 2018 17:22:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/15] Review uuid_mutex usage
Message-ID: <20180419152254.GI21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180412022938.8257-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180412022938.8257-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 12, 2018 at 10:29:23AM +0800, Anand Jain wrote:
> uuid_mutex lock is not a per-fs lock but a global lock. The main aim of
> this patch-set is to critically review the usage of this lock, and delete
> the unnecessary once. By doing this we improve the concurrency of
> device operations across multiple btrfs filesystems is in the system.
> 
> patch 1: Was sent before, I am including it here, as its about uuid_mutex.
> 
> patch 2-9: Are cleanup and or preparatory patches.
> 
> patch 10-14: Drops the uuid_mutex and makes sure there is enough lock,
> as discussed in the patch change log.
> 
> patch 15: A generic cleanup patch around functions in the same context.
> 
> These patches are on top of
>   https://github.com/kdave/btrfs-devel.git remove-volume-mutex
> And it will be a good idea to go along with the kill-volume-mutex patches.
> 
> This is tested with xfstests and there are no _new_ regression. And I am
> trying to understand the old regressions, and notice that they are
> inconsistent.
> 
> Anand Jain (15):
>   btrfs: optimize move uuid_mutex closer to the critical section

FYI, the patches:

>   btrfs: rename struct btrfs_fs_devices::list
>   btrfs: cleanup __btrfs_open_devices() drop head pointer
>   btrfs: rename __btrfs_close_devices to close_fs_devices
>   btrfs: rename __btrfs_open_devices to open_fs_devices
>   btrfs: cleanup find_device() drop list_head pointer
>   btrfs: cleanup btrfs_rm_device() promote fs_devices pointer

have been added to misc-next as they're independent cleanups. The rest
is still under review.
