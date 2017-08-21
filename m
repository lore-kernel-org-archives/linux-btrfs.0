Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54390 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753206AbdHUPB6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 11:01:58 -0400
Date: Mon, 21 Aug 2017 17:00:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v3 7/7] Btrfs: add one more sanity check for shared ref
 type
Message-ID: <20170821150034.GJ2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170818211524.31325-1-bo.li.liu@oracle.com>
 <20170818211524.31325-8-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170818211524.31325-8-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 18, 2017 at 03:15:24PM -0600, Liu Bo wrote:
> Every shared ref has a parent tree block, which can be get from
> btrfs_extent_inline_ref_offset().  And the tree block must be aligned
> to the nodesize, so we'd know this inline ref is not valid if this
> block's bytenr is not aligned to the nodesize, in which case, most
> likely the ref type has been misused.
> 
> This adds the above mentioned check and also updates
> print_extent_item() called by btrfs_print_leaf() to point out the
> invalid ref while printing the tree structure.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
