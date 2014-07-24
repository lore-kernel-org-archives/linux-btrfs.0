Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758825AbaGXNJa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 09:09:30 -0400
Date: Thu, 24 Jul 2014 15:09:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Add show_path function for btrfs_super_ops.
Message-ID: <20140724130928.GY1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1405933349-6215-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1405933349-6215-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 21, 2014 at 05:02:29PM +0800, Qu Wenruo wrote:
> show_path() function in struct super_operations is used to output
> subtree mount info for mountinfo.
> Without the implement of show_path() function, user can not found where
> each subvolume is mounted if using 'subvolid=' mount option.
> (When mounted with 'subvol=' mount option, vfs is aware of subtree mount
> and can to the path resolve by vfs itself)

Your previous patches unify both to call mount_subtree, then the default
vfs implementation of show_path will do the right thing, ie
seq_dentry(...), and the path will be resolved for free.

Means this patch is not needed, so I'll skip commenting it.

> With this patch, end users will be able to use findmnt(8) or other
> programs reading mountinfo to find which btrfs subvolume is mounted.
> 
> Though we use fs_info->subvol_sem to protect show_path() from subvolume
> destroying/creating, if user renames/moves the parent non-subvolume
> dir of a subvolume, it is still possible that concurrency may happen and
> cause btrfs_search_slot() fails to find the desired key.
> In that case, we just return -EBUSY and info user to try again since
> extra locking like locking the whole subvolume tree is too expensive for
> such usage.

And the subvolume renames will be handled as well.
