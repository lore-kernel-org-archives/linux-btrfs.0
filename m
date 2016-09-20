Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40639 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752092AbcITNYP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 09:24:15 -0400
Date: Tue, 20 Sep 2016 15:22:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: add error handling for extent buffer in print tree
Message-ID: <20160920132217.GZ16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1473899019-29882-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1473899019-29882-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 14, 2016 at 05:23:39PM -0700, Liu Bo wrote:
> Somehow we missed btrfs_print_tree when last time we
> updated error handling for read_extent_block().
> 
> This keeps us from getting a NULL pointer panic when
> btrfs_print_tree's read_extent_block() fails.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
