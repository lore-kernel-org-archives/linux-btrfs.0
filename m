Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53284 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752221AbeEPPVz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 11:21:55 -0400
Date: Wed, 16 May 2018 17:19:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] btrfs: sysfs: Add entry which shows rmdir(2) can
 work for subvolume
Message-ID: <20180516151914.GD6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1526457206.git.misono.tomohiro@jp.fujitsu.com>
 <2eb3880232f74bb884a269264058e6d5f5337ffc.1526457206.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2eb3880232f74bb884a269264058e6d5f5337ffc.1526457206.git.misono.tomohiro@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 16, 2018 at 05:09:27PM +0900, Tomohiro Misono wrote:
> Deletion of a subvolume by rmdir(2) has become allowed by the
> 'commit cd2decf640b1 ("btrfs: Allow rmdir(2) to delete an empty
> subvolume")'.
> 
> It is a kind of new feature and this commits add a sysfs entry
>   /sys/fs/btrfs/static_features/rmdir_subvol

> to indicate the availability of feature so that a user program
> (e.g. xfstests) can detect it.
> 
> Note that new sysfs directory "static_features" is created since a entry
> in /sys/fs/btrfs/features depends on feature bits of superblock (in other
> words, they may be different between each fs) and is not suitable to hold
> the features which only depend on kernel version. New attribute_group
> "btrfs_static_feature_attr_group" is created for this purpose.

No, we don't want to add another directory for that, please use
'/sys/fs/btrfs/features'. Listing in this directory reflects
capabilities of the kernel module, the filesystem specific features are
in the /sys/fs/btrfs/UUID/features directory.
