Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48540 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752453AbeEONZU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 09:25:20 -0400
Date: Tue, 15 May 2018 15:22:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] btrfs: sysfs: Add entry which shows rmdir(2) can
 work for subvolume
Message-ID: <20180515132239.GQ6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <a8c4cc11-99f4-2390-b489-340bdc941464@jp.fujitsu.com>
 <428b7ee1-bc44-2f2d-1117-6a031759039a@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <428b7ee1-bc44-2f2d-1117-6a031759039a@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 15, 2018 at 04:33:12PM +0900, Misono Tomohiro wrote:
> Deletion of a subvolume by rmdir(2) has become allowed by the
> 'commit cd2decf640b1 ("btrfs: Allow rmdir(2) to delete an empty
> subvolume")'.
> 
> It is a kind of new feature and this commits add new sysfs entry
>   /sys/fs/btrfs/features/rmdir_subvol
> to indicate the feature.
> 
> Since the behavior is independent of feature bits of superblock,
> new type FEAT_KERNEL is added to struct btrfs_feature_set.
> Features of FEAT_KERNEL is supposed to be visible only in /sys/fs/features
> and not in /sys/fs/UUID/features.

As the rmdir_subvol is a static feature, depending only on the kernel
version, it's not needed to use the same infrastructure as the optional
features. It also makes it unnecesarily complicated, to distinguish the
on-disk and kernel-only features and it's not a per-filesystem feature.

It should be exported among btrfs_feature_attr_group and
btrfs_supported_feature_attrs, possibly adding a new type of helpers if
needed.
