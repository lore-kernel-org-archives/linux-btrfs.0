Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46563 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965408AbeBMSHW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 13:07:22 -0500
Date: Tue, 13 Feb 2018 19:05:06 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: Remove invalid null checks from
 btrfs_cleanup_dirty_bgs
Message-ID: <20180213180506.GC3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1518107118-15137-1-git-send-email-nborisov@suse.com>
 <20180208185710.GB9008@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180208185710.GB9008@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 08, 2018 at 10:57:11AM -0800, Liu Bo wrote:
> On Thu, Feb 08, 2018 at 06:25:17PM +0200, Nikolay Borisov wrote:
> > list_first_entry is essentially a wrapper over cotnainer_of. The latter
> > can never return null even if it's working on inconsistent list since it
> > will either crash or return some offset in the wrong struct.
> > Additionally, for the dirty_bgs list the iteration is done under
> > dirty_bgs_lock which ensures consistency of the list.
> > 
> 
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Added to next, thanks.
