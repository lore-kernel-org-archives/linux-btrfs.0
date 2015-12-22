Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbbLVMkO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Dec 2015 07:40:14 -0500
Date: Tue, 22 Dec 2015 20:40:10 +0800
From: Eryu Guan <eguan@redhat.com>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 1/2] fstests: fix btrfs test failures after commit
 27d077ec0bda
Message-ID: <20151222124010.GB2535@eguan.usersys.redhat.com>
References: <1450750960-5172-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1450750960-5172-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 22, 2015 at 02:22:40AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Commit 27d077ec0bda (common: use mount/umount helpers everywhere) made
> a few btrfs test fail for 2 different reasons:
> 
> 1) Some tests (btrfs/029 and btrfs/031) use $SCRATCH_MNT as a mount
>    point for some subvolume created in $TEST_DEV, therefore calling
>    _scratch_unmount does not work as it passes $SCRATCH_DEV as the
>    argument to the umount program. This is intentional to test reflinks
>    accross different mountpoints of the same filesystem but for different
>    subvolumes;
> 
> 2) For multiple devices filesystems (btrfs/003 and btrfs/011) that test
>    the device replace feature, we need to unmount using the mount path
>    ($SCRATCH_MNT) because unmounting using one of the devices as an
>    argument ($SCRATCH_DEV) does not always work - after replace operations
>    we get in /proc/mounts a device other than $SCRATCH_DEV associated
>    with the mount point $SCRATCH_MNT (this is mentioned in a comment at
>    btrfs/011 for example), so we need to pass that other device to the
>    umount program or pass it the mount point.
> 
> Using $SCRATCH_MNT as a mountpoint for a device other than $SCRATCH_DEV is
> misleading, but that's a different problem that existed long before and
> this change attempts only to fix the regression from 27d077ec0bda.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Thanks for fixing this! And sorry for the trouble..

Reviewed-by: Eryu Guan <eguan@redhat.com>
