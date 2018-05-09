Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57471 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934976AbeEINH1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 09:07:27 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C9F75AC69
        for <linux-btrfs@vger.kernel.org>; Wed,  9 May 2018 13:07:25 +0000 (UTC)
Date: Wed, 9 May 2018 15:04:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: qgroup: Search commit root for rescan to avoid
 missing extent
Message-ID: <20180509130448.GZ6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180503072052.22002-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180503072052.22002-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 03, 2018 at 03:20:52PM +0800, Qu Wenruo wrote:
> When doing qgroup rescan using the following script (modified from
> btrfs/017 test case), we can sometimes hit qgroup corruption.
> 
> ------
> umount $dev &> /dev/null
> umount $mnt &> /dev/null
> 
> mkfs.btrfs -f -n 64k $dev
> mount $dev $mnt
> 
> extent_size=8192
> 
> xfs_io -f -d -c "pwrite 0 $extent_size" $mnt/foo > /dev/null
> btrfs subvolume snapshot $mnt $mnt/snap
> 
> xfs_io -f -c "reflink $mnt/foo" $mnt/foo-reflink > /dev/null
> xfs_io -f -c "reflink $mnt/foo" $mnt/snap/foo-reflink > /dev/null
> xfs_io -f -c "reflink $mnt/foo" $mnt/snap/foo-reflink2 > /dev/unll
> btrfs quota enable $mnt
> 
>  # -W is the new option to only wait rescan while not starting new one
> btrfs quota rescan -W $mnt
> btrfs qgroup show -prce $mnt
> 
>  # Need to patch btrfs-progs to report qgroup mismatch as error
> btrfs check $dev || _fail
> ------
> 
> For fast machine, we can hit some corruption which missed accounting
> tree blocks:
> ------
> qgroupid         rfer         excl     max_rfer     max_excl parent  child
> --------         ----         ----     --------     -------- ------  -----
> 0/5           8.00KiB        0.00B         none         none ---     ---
> 0/257         8.00KiB        0.00B         none         none ---     ---
> ------
> 
> This is due to the fact that we're always searching commit root for
> btrfs_find_all_roots() at qgroup_rescan_leaf(), but the leaf we get is
> from current transaction, not commit root.
> 
> And if our tree blocks get modified in current transaction, we won't
> find any owner in commit root, thus causing the corruption.
> 
> Fix it by searching commit root for extent tree for
> qgroup_rescan_leaf().
> 
> Reported-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to misc-next, thanks.

> ---
> 
> Please keep in mind that it is possible to hit another type of race
> which double accounting tree blocks:
> ------
> qgroupid         rfer         excl     max_rfer     max_excl parent  child
> --------         ----         ----     --------     -------- ------  -----
> 0/5          136.00KiB     128.00KiB         none         none ---     ---
> 0/257        136.00KiB     128.00KiB         none         none ---     ---
> ------
> For this type of corruption, this patch could reduce the possibility,
> but the root cause is race between transaction commit and qgroup rescan,
> which needs to be addressed in another patch.

Both patches are now in misc-next, I saw the btrfs/017 failures
occasionally so will watch if it's all ok now.
