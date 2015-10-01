Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45767 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756531AbbJAL6P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Oct 2015 07:58:15 -0400
Date: Thu, 1 Oct 2015 13:57:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, jbacik@fb.com, clm@fb.com,
        chandan@mykolab.com
Subject: Re: [PATCH] Btrfs: create_subvol: Commit the current transaction if
 stale root entry exists.
Message-ID: <20151001115712.GA5885@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1443696595-20641-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443696595-20641-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 01, 2015 at 04:19:55PM +0530, Chandan Rajendra wrote:
> This occurs because,
> 
> Mount filesystem
> Create subvol with ID 257
> Unmount filesystem
> Mount filesystem
> Delete subvol with ID 257
>   btrfs_drop_snapshot()
>     Add root corresponding to subvol 257 into
>     btrfs_transaction->dropped_roots list
> Create new subvol (i.e. create_subvol())
>   257 is returned as the next free objectid

How is this possible? We do not intentionally reuse the subvol ids so
this means that the bug is in the id assignment code.

>   btrfs_read_fs_root_no_name()
>     Finds the btrfs_root instance corresponding to the old subvol with ID 257
>     in btrfs_fs_info->fs_roots_radix.
>     Returns error since btrfs_root_item->refs has the value of 0.
