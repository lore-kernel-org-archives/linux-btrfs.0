Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34215 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750872AbeDRTat (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 15:30:49 -0400
Date: Wed, 18 Apr 2018 21:28:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v5 0/3] Allow rmdir(2) to delete a subvolume
Message-ID: <20180418192817.GT21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <558a949c-ceb5-115d-744f-80fac2620f7d@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <558a949c-ceb5-115d-744f-80fac2620f7d@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 18, 2018 at 11:32:57AM +0900, Misono Tomohiro wrote:
> cangelog:
>   v4 -> v5 ... Merge 2nd and 3rd patches and update commit log
>                No code change in total
>   v3 -> v4 ... Reorganize patches and update commit log
>                No code change in total
>   v2 -> v3 ... Use if-else block instead of two if blocks and
>                add Tested-by tag in 2nd patch
>   v1 -> v2 ... Split the patch to hopefully make review easier
> 
> Note: I will send a xfstest if this series is merged.
> 
> This series changes the behavior of rmdir(2) and allow it to delete an
> empty subvolume.
> 
> In order so that, 1st and 2nd patch refactor btrfs_ioctl_snap_destroy()
> and extract the actual deletion process as btrfs_delete_subvolume()
> (remaining part in btrfs_ioctl_snap_destroy() is mainly permission checks).
> 
> Then, 3rd patch changes btrfs_rmdir() to call this function. The
> required permission check is already done in vfs layer.
> 
> Tomohiro Misono (3):
>   btrfs: Move may_destroy_subvol() from ioctl.c to inode.c
>   btrfs: Factor out the main deletion process from btrfs_ioctl_snap_destroy()
>   btrfs: Allow rmdir(2) to delete an empty subvolume

Looks good to me now, thanks. I'll add it to next for more testing. The
3rd patch may need some updates in the changelog about the change in
behaviour, but this can be added later.

Tests should cover the common usage like rm -rf /path/to/subvol,
removing the empty subvol (the subvol stub), snapshots and rw
subvolumes, nested in a nontrivial way.
