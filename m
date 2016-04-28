Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbcD1QSL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 12:18:11 -0400
Date: Thu, 28 Apr 2016 18:17:57 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: do not return EBUSY on concurrent subvolume mounts
Message-ID: <20160428161757.GV29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1461770076-13000-1-git-send-email-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1461770076-13000-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 27, 2016 at 05:14:36PM +0200, David Sterba wrote:
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1588,8 +1588,6 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
>  	if (s->s_root) {
>  		btrfs_close_devices(fs_devices);
>  		free_fs_info(fs_info);
> -		if ((flags ^ s->s_flags) & MS_RDONLY)
> -			error = -EBUSY;

And this is a wrong fix. It will break the existing semantics of mixed
ro/rw mounts. With this change, it's not possible to mount the first
subvol ro and the rest with rw. The mount succeeds, but does not lead to
the right result.

At least now I have a better idea where the race happens, btrfs_subvol
between vfs_kern_mount and the remount.
