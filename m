Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50818 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936709AbeE1QUE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 12:20:04 -0400
Date: Mon, 28 May 2018 18:17:18 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Liu Bo <bo.liu@linux.alibaba.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/6] btrfs_search_slot cleanups
Message-ID: <20180528161718.GF6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
 <20180528144028.GC6649@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180528144028.GC6649@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 28, 2018 at 04:40:28PM +0200, David Sterba wrote:
> On Fri, May 18, 2018 at 11:00:18AM +0800, Liu Bo wrote:
> > Here are a collection of patches I did for btrfs_search_slot().
> > 
> > v2: more explicit commit log for each patch.
> > 
> > Liu Bo (6):
> >   Btrfs: remove superfluous free_extent_buffer
> >   Btrfs: use more straightforward extent_buffer_uptodate
> >   Btrfs: move get root of btrfs_search_slot to a helper
> >   Btrfs: remove unused check of skip_locking
> >   Btrfs: grab write lock directly if write_lock_level is the max level
> >   Btrfs: remove always true check in unlock_up
> 
> 1,2,4,5,6 merged. Please update patch 3 and add the ASSERT. Thanks.

Sorry, it's the 4/6 that's not merged and I'm awaiting an updated
versino. Thanks.
