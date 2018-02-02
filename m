Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60801 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752970AbeBBRm0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Feb 2018 12:42:26 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 51F50AE07
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Feb 2018 17:42:25 +0000 (UTC)
Date: Fri, 2 Feb 2018 18:40:13 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND 2/4] btrfs: Remove code referencing unused
 TRANS_USERSPACE
Message-ID: <20180202174013.GW18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1515590477-22878-1-git-send-email-nborisov@suse.com>
 <1515601933-27331-1-git-send-email-nborisov@suse.com>
 <1515601933-27331-2-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1515601933-27331-2-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 10, 2018 at 06:32:11PM +0200, Nikolay Borisov wrote:
> Now that the userspace transaction ioctls have been removed,
> TRANS_USERSPACE is no longer used hence we can remove it.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

> -struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *root)

The declaration removal from transaction.h is missing, I'll fix that.
