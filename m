Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49939 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbcCIQzh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Mar 2016 11:55:37 -0500
Date: Wed, 9 Mar 2016 17:55:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V4 2/2] btrfs-progs: Introduce device delete by devid
Message-ID: <20160309165515.GA18908@suse.cz>
Reply-To: dsterba@suse.cz
References: <1444123990-8832-1-git-send-email-anand.jain@oracle.com>
 <1457518226-601-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1457518226-601-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 09, 2016 at 06:10:26PM +0800, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> This patch introduces new option <devid> for the command
> 
>   btrfs device delete <device_path|devid>[..]  <mnt>
> 
> In a user reported issue on a 3-disk-RAID1, one disk failed with its SB
> unreadable. Now with this patch user will have a choice to delete the
> device using devid.
> 
> The other method we could do, is to match the input device_path to the
> available device_paths with in the kernel. But that won't work in all the
> cases, like what if user provided mapper path when the path within the
> kernel is a non-mapper path.
> 
> This patch depends on the below kernel patch for the new feature to work,
> however it will fail-back to the old interface for the kernel without the
> patch
> 
>   Btrfs: Introduce device delete by devid
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> [ coding style fixes ]
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
> v4: a. For future benefit we should check for EOPNOTSUPP as well.
>     b. Update the changes to be inline with kernel that is
>        BTRFS_DEVICE_SPEC_BY_ID and BTRFS_VOL_ARG_V2_FLAGS_SUPPORTED
>        naming changes. and
>     (c. As I didn't see progs patch matching with the kernel naming
>        changes in the ML.)

I did these changes and updated the patch in devel, mentioned in the
changelog as

    [ refresh on top of current code, sync with latest kernel patches, other
      minor changes ]

Please send any followup changes on top of the current devel patch.
