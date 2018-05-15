Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37147 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753125AbeEOQfo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 12:35:44 -0400
Date: Tue, 15 May 2018 18:33:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/15] Review uuid_mutex usage
Message-ID: <20180515163303.GV6649@twin.jikos.cz>
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
>   btrfs: rename struct btrfs_fs_devices::list
>   btrfs: cleanup __btrfs_open_devices() drop head pointer
>   btrfs: rename __btrfs_close_devices to close_fs_devices
>   btrfs: rename __btrfs_open_devices to open_fs_devices
>   btrfs: cleanup find_device() drop list_head pointer
>   btrfs: cleanup btrfs_rm_device() promote fs_devices pointer
>   btrfs: cleanup btrfs_rm_device() use cur_devices
>   btrfs: uuid_mutex in read_chunk_tree, add a comment
>   btrfs: drop uuid_mutex in btrfs_free_extra_devids()
>   btrfs: drop uuid_mutex in btrfs_open_devices()
>   btrfs: drop uuid_mutex in close_fs_devices()
>   btrfs: drop uuid_mutex in btrfs_dev_replace_finishing()
>   btrfs: drop uuid_mutex in btrfs_destroy_dev_replace_tgtdev()
>   btrfs: cleanup btrfs_destroy_dev_replace_tgtdev() localize
>     btrfs_fs_devices

Patches 10 and 12 haven't been merged, the rest is now in misc-next.
Testing hasn't revealed any problems related to the uuid/device locks
but as said before we don't have stress tests.
