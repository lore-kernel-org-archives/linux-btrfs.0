Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36684 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932385AbcIUOPW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 10:15:22 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 90609AB9F
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Sep 2016 14:15:20 +0000 (UTC)
Date: Wed, 21 Sep 2016 16:13:21 +0200
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: clean the old superblocks before freeing the
 device
Message-ID: <20160921141321.GH16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1474375821-3163-1-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1474375821-3163-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 20, 2016 at 08:50:21AM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> btrfs_rm_device frees the block device but then re-opens it using
> the saved device name.  A race exists between the close and the
> re-open that allows the block size to be changed.  The result
> is getting stuck forever in the reclaim loop in __getblk_slow.
> 
> This patch moves the superblock cleanup before closing the block
> device, which is also consistent with other callers.  We also don't
> need a private copy of dev_name as the whole routine operates under
> the uuid_mutex.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
