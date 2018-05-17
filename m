Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56133 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752073AbeEQQwS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 12:52:18 -0400
Date: Thu, 17 May 2018 18:49:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 2/2] btrfs: sysfs: Add entry which shows rmdir(2) can
 work for subvolume
Message-ID: <20180517164932.GL6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1526457206.git.misono.tomohiro@jp.fujitsu.com>
 <2eb3880232f74bb884a269264058e6d5f5337ffc.1526457206.git.misono.tomohiro@jp.fujitsu.com>
 <20180516151914.GD6649@twin.jikos.cz>
 <20e797cb-2f49-3248-768e-57afe175bad4@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20e797cb-2f49-3248-768e-57afe175bad4@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 17, 2018 at 02:24:51PM +0900, Misono Tomohiro wrote:
> Deletion of a subvolume by rmdir(2) has become allowed by the
> 'commit cd2decf640b1 ("btrfs: Allow rmdir(2) to delete an empty
> subvolume")'.
> 
> It is a kind of new feature and this commits add a sysfs entry
>   /sys/fs/btrfs/features/rmdir_subvol
> to indicate the availability of the feature so that a user program
> (e.g. xfstests) can detect it.
> 
> Prior to this commit, all entry in /sys/fs/btrfs/features is a feature
> which depends on feature bits of superblock (i.e. each feature affects
> on-disk format) and managed by attribute_group "btrfs_feature_attr_group".
> For each fs, entries in /sys/fs/btrfs/UUID/features indicate which
> features are enabled (or can be changed online) for the fs.
> 
> However, rmdir_subvol feature only depends on kernel modules. Therefore
> new attribute_group "btrfs_static_feature_attr_group" is introduced and
> sysfs_merge_group() is used to share /sys/fs/btrfs/features directory.
> Features in "btrfs_static_feature_attr_group" won't be listed in each
> /sys/fs/btrfs/UUID/features.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
> Hi David,
> 
> Sorry for the misunderstanding.

No problem.

> How about this version which uses /sys/fs/btrfs/features
> while using different attribute_group for static features.

Perfect, that's what I had in mind, added to misc-next, thanks.

Reviewed-by: David Sterba <dsterba@suse.com>
