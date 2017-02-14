Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50424 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752222AbdBNPxk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 10:53:40 -0500
Date: Tue, 14 Feb 2017 16:53:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: try to avoid acquiring free space ctl's lock
Message-ID: <20170214155308.GN16928@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1487029350-13037-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1487029350-13037-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 03:42:30PM -0800, Liu Bo wrote:
> We don't need to take the lock if the block group has not been cached.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
