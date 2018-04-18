Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43778 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751407AbeDRWHF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 18:07:05 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BA4D9AB3C
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 22:07:03 +0000 (UTC)
Date: Thu, 19 Apr 2018 00:04:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: Do super block verification before writing it
 to disk
Message-ID: <20180418220432.GV21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180417014719.3799-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180417014719.3799-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 17, 2018 at 09:47:19AM +0800, Qu Wenruo wrote:
> @@ -2680,7 +2681,7 @@ int open_ctree(struct super_block *sb,
>  
>  	memcpy(fs_info->fsid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
>  
> -	ret = btrfs_check_super_valid(fs_info);
> +	ret = btrfs_check_super_valid(fs_info, fs_info->super_copy);
>  	if (ret) {
>  		btrfs_err(fs_info, "superblock contains fatal errors");
>  		err = -EINVAL;
> @@ -3310,6 +3311,27 @@ static int write_dev_supers(struct btrfs_device *device,

This is in write_dev_supers, so the superblock is checked
number-of-devices times. The caller write_all_supers rewrites the device
item so it matches the device it's going to write to. But,
btrfs_check_super_valid does not validate the dev_item so all the
validation does not bring much benefit, as it repeatedly checks the same
data.

So, what if the validation is done only once in write_all_supers? Lock
the devices, validate, if it fails, report that and unlock devices and
go readonly.

There's a differnce to what you implemented: if the in-memory superblock
corruption happens between writing to the devices, there are some left
with the new superblock and some with the old.

Although this sounds quite improbable, I think that doing the check in
advance would save some trouble if that happens. The superblocks on all
devices will match.
