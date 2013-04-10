Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33319 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964961Ab3DJQro (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Apr 2013 12:47:44 -0400
Date: Wed, 10 Apr 2013 18:47:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: rescan for qgroups
Message-ID: <20130410164741.GS18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1365161897-19448-1-git-send-email-list.btrfs@jan-o-sch.net>
 <1365161897-19448-2-git-send-email-list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1365161897-19448-2-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 05, 2013 at 01:38:16PM +0200, Jan Schmidt wrote:
> +	if (root->fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {

I was wondering if merging qgroup_flags with fs_state would make sense
to you. There are currently 3 bits for qgroups, and it's a whole
filesystem state anyway.

> +	pr_debug("current progress key (%llu %u %llu), search_slot ret %d\n",
> +		 fs_info->qgroup_rescan_progress.objectid,
> +		 fs_info->qgroup_rescan_progress.type,
> +		 fs_info->qgroup_rescan_progress.offset, ret);

Please use (unsigned long long) for u64 types (objectid, offset).

> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -376,12 +376,17 @@ struct btrfs_ioctl_get_dev_stats {
>  
>  #define BTRFS_QUOTA_CTL_ENABLE	1
>  #define BTRFS_QUOTA_CTL_DISABLE	2
> -#define BTRFS_QUOTA_CTL_RESCAN	3
> +/* 3 has formerly been reserved for BTRFS_QUOTA_CTL_RESCAN */

It's not clear if 3 can be reused or not. If yes, there's no need for
the comment, if not, a #define should be left in place to capture the
value.

>  struct btrfs_ioctl_quota_ctl_args {
>  	__u64 cmd;
>  	__u64 status;
>  };
>  
> +struct btrfs_ioctl_quota_rescan_args {
> +	__u64	flags;
> +	__u64   progress;

Like I'm always worried about future etensions, adding a few reserved[]
does not hurt.

david
