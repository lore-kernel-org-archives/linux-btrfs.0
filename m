Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43146 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752518AbdATQDu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jan 2017 11:03:50 -0500
Date: Fri, 20 Jan 2017 16:50:09 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] Btrfs: fix btrfs_ordered_update_i_size to update
 disk_i_size properly
Message-ID: <20170120155009.GB11951@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1484237606-17576-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1484237606-17576-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 12, 2017 at 08:13:26AM -0800, Liu Bo wrote:
> btrfs_ordered_update_i_size can be called by truncate and endio, but only endio
> takes ordered_extent which contains the completed IO.
> 
> while truncating down a file, if there are some in-flight IOs,
> btrfs_ordered_update_i_size in endio will set disk_i_size to @orig_offset that
> is zero.  If truncating-down fails somehow, we try to recover in memory isize
> with this zero'd disk_i_size.
> 
> Fix it by only updating disk_i_size with @orig_offset when
> btrfs_ordered_update_i_size is not called from endio while truncating down and
> waiting for in-flight IOs completing their work before recover in-memory size.
> 
> Besides fixing the above issue, add an assertion for last_size to double check
> we truncate down to the desired size.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Looks good to me, added to 4.11 queue.
