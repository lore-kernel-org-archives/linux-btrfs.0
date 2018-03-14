Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58577 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751470AbeCNSnA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 14:43:00 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6FE3EAFAE
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Mar 2018 18:42:59 +0000 (UTC)
Date: Wed, 14 Mar 2018 19:40:37 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Handle error from btrfs_uuid_tree_rem call in
 _btrfs_ioctl_set_received_subvol
Message-ID: <20180314184037.GQ32007@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1520858889-17729-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1520858889-17729-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 12, 2018 at 02:48:09PM +0200, Nikolay Borisov wrote:
> As with every function which deals with modifying the btree
> btrfs_uuid_tree_rem can fail for any number of reasons (ie. EIO/ENOMEM).
> Handle return error value from this function gracefully by aborting the
> transaction.
> 
> Fixes: dd5f9615fc5c ("Btrfs: maintain subvolume items in the UUID tree")
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
