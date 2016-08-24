Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40076 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754771AbcHXMX6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Aug 2016 08:23:58 -0400
Date: Wed, 24 Aug 2016 14:11:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v4] Btrfs: remove BUG() in raid56
Message-ID: <20160824121134.GP16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1469645807-16370-1-git-send-email-bo.li.liu@oracle.com>
 <1469815075-5945-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1469815075-5945-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 29, 2016 at 10:57:55AM -0700, Liu Bo wrote:
> This BUG() has been triggered by a fuzz testing image, which contains
> an invalid chunk type, ie. a single stripe chunk has the raid6 type.
> 
> Btrfs can handle this gracefully by returning -EIO, so besides using
> btrfs_warn to give us more debugging information rather than a single
> BUG(), we can return error properly.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
