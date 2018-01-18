Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43824 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755732AbeARPMF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Jan 2018 10:12:05 -0500
Date: Thu, 18 Jan 2018 16:09:53 +0100
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH 1/2] btrfs: fix the bug of device scan/ready for mounted,
 filesystem
Message-ID: <20180118150952.GL13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <7fba2dc9-44a9-4317-b9fd-263b2a687e9a@jp.fujitsu.com>
 <923e5500-d6d8-b4b5-eb0b-30b80760a3f1@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <923e5500-d6d8-b4b5-eb0b-30b80760a3f1@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 17, 2018 at 05:37:39PM +0900, Misono, Tomohiro wrote:
> commit ae3acc5fc0bf ("btrfs: cleanup btrfs_mount() using
> btrfs_mount_root()") introduces a bug that "btrfs device scan/ready" for
> mounted filesystem fails.
> 
> This is because fs_info->bdev_holder has been changed to hold
> btrfs_root_fs_type instead of btrfs_fs_type by this commit, but ioctl
> for device scan/ready still uses btrfs_fs_type to call
> btrfs_scan_one_device(). This leads to failiure of blkdev_get_by_path()
> for mounted filesystem because of different holder type.
> 
> Fix this by specifying btrfs_root_fs_type for btrfs_scan_one_device() in
> the path of device ready/scan ioctl.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Thanks. I'd rather fold that in to "btrfs: cleanup btrfs_mount() using
btrfs_mount_root()" where the semantics of holder actually changes.
