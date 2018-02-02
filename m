Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51192 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751567AbeBBQFg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Feb 2018 11:05:36 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3E2EDABD0
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Feb 2018 16:05:35 +0000 (UTC)
Date: Fri, 2 Feb 2018 17:03:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [RESEND PATCH] btrfs: Fix UAF when cleaning up fs_devs with a
 single stale device
Message-ID: <20180202160322.GP18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1516972827-1481-1-git-send-email-nborisov@suse.com>
 <1517321257-314-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1517321257-314-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 30, 2018 at 04:07:37PM +0200, Nikolay Borisov wrote:
> Commit 4fde46f0cc71 ("Btrfs: free the stale device") introduced
> btrfs_free_stale_device which iterates the device lists for all
> registered btrfs filesystems and deletes those devices which aren't
> mounted. In a btrfs_devices structure has only 1 device attached to it
> and it is unused then btrfs_free_stale_devices will proceed to also
> free the btrfs_fs_devices struct itself. Currently this leads to a UAF
> since list_for_each_entry will try to perform a check on the already-
> freed memory to see if it has to terminated the loop.
> 
> The fix is to use 'break' when we know we are freeing the current
> fs_devs.
> 
> Fixes: 4fde46f0cc71 ("Btrfs: free the stale device")
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Added to next, thanks.
