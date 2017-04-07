Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46351 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750705AbdDGLFf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Apr 2017 07:05:35 -0400
Date: Fri, 7 Apr 2017 13:05:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 3/9] btrfs: qgroup: Fix qgroup corruption caused by
 inode_cache mount option
Message-ID: <20170407110533.GS4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170313075216.5125-1-quwenruo@cn.fujitsu.com>
 <20170313075216.5125-4-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170313075216.5125-4-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 13, 2017 at 03:52:10PM +0800, Qu Wenruo wrote:
> [BUG]
> The easist way to reproduce the bug is:
> ------
>  # mkfs.btrfs -f $dev -n 16K
>  # mount $dev $mnt -o inode_cache
>  # btrfs quota enable $mnt
>  # btrfs quota rescan -w $mnt
>  # btrfs qgroup show $mnt
> qgroupid         rfer         excl
> --------         ----         ----
> 0/5          32.00KiB     32.00KiB
>              ^^ Twice the correct value
> ------
> 
> And fstests/btrfs qgroup test group can easily detect them with
> inode_cache mount option.
> Although some of them are false alerts since old test cases are using
> fixed golden output.
> While new test cases will use "btrfs check" to detect qgroup mismatch.
> 
> [CAUSE]
> Inode_cache mount option will make commit_fs_roots() to call
> btrfs_save_ino_cache() to update fs/subvol trees, and generate new
> delayed refs.
> 
> However we call btrfs_qgroup_prepare_account_extents() too early, before
> commit_fs_roots().
> This makes the "old_roots" for newly generated extents are always NULL.
> For freeing extent case, this makes both new_roots and old_roots to be
> empty, while correct old_roots should not be empty.
> This causing qgroup numbers not decreased correctly.
> 
> [FIX]
> Modify the timing of calling btrfs_qgroup_prepare_account_extents() to
> just before btrfs_qgroup_account_extents(), and add needed delayed_refs
> handler.
> So qgroup can handle inode_map mount options correctly.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Patch added to 4.12 queue.
