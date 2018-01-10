Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54293 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965925AbeAJQ2U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 11:28:20 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 06A7FACAE
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 16:28:19 +0000 (UTC)
Date: Wed, 10 Jan 2018 17:26:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] Finally remove userspace transaction support
Message-ID: <20180110162611.GU13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1515590477-22878-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1515590477-22878-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 10, 2018 at 03:21:13PM +0200, Nikolay Borisov wrote:
> Userspace transaction were initially added to he benefit of Ceph, however 
> in recent times it became clear that btrfs is not suitable for Ceph's workload
> and has even been actively discoured. Additionaly, the userspace transaction
> mechanism has always been a sort of a hack, which could easily lead to a 
> deadlock unless care is taken. 
> 
> All things considered there is no point in keeping the code around. Userspace
> transaction interface was deprecated in kernel version 4.14. Now it's time to 
> completely remove it in 4.17. 
> 
> The first patch removes the ioctl-related code. Following patches just deal 
> with unused functions/values following ioctl removal. 
> 
> Nikolay Borisov (4):
>   btrfs: Remove userspace transaction ioctls
>   btrfs: Remove code referencing unused TRANS_USERSPACE
>   btrfs: Remove transaction handle from btrfs_file_private
>   btrfs: Remove btrfs_fs_info::open_ioctl_trans

Please resend and add the missing Signed-off-by lines.
