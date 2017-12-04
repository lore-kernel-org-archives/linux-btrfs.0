Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34878 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753827AbdLDNfS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Dec 2017 08:35:18 -0500
Date: Mon, 4 Dec 2017 14:33:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, lakshmipathi.g@gmail.com
Subject: Re: [PATCH RESEND] btrfs: ignore return from btrfs_open_one_device()
Message-ID: <20171204133318.GU3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171130230230.10185-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171130230230.10185-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 01, 2017 at 07:02:30AM +0800, Anand Jain wrote:
> Test case like btrfs-progs test-misc/012 can recreate the same fsid with
> different number of struct btrfs_fs_devices::total_devices. And the
> previous device which is in the kernel device list is stale now, but as
> we don't clean the kernel device list, and in the mount context, it really
> ends up reading the device to find its zeroed SB. And thus return the fail
> to mount.
> 
> The long term fix for this should be to create a new kernel device list,
> for the mount context.
> 
> Though the patch
>   btrfs: factor __btrfs_open_devices() to create btrfs_open_one_device()
> did tried to skip the failed open, but it forgot to reset the ret value.
> Thus returning the error up the stack in the mount context.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Fixes:
>   btrfs: factor __btrfs_open_devices() to create btrfs_open_one_device()
> ---
> Hi David,
> 
>  My bad. The above patch introduced a regression. Can you kindly squash
>  this patch to it.

Done. Thank you both.
