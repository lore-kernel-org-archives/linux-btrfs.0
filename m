Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56683 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1761530AbdEZPvI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 11:51:08 -0400
Date: Fri, 26 May 2017 17:50:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: let btrfs_print_leaf print more about block group
Message-ID: <20170526155006.GB30842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170526000812.31337-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170526000812.31337-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 25, 2017 at 06:08:12PM -0600, Liu Bo wrote:
> This adds chunk_objectid and flags, with flags we can recognize whether
> the block group is about data or metadata.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
