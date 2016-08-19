Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55277 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753471AbcHSLbB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Aug 2016 07:31:01 -0400
Date: Fri, 19 Aug 2016 13:28:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] Btrfs: fix memory leak of block group cache
Message-ID: <20160819112823.GG16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1469061234-15337-1-git-send-email-bo.li.liu@oracle.com>
 <1469061852-21185-1-git-send-email-bo.li.liu@oracle.com>
 <9300daf6-000a-7bfa-f7a8-c0b418cbd6ba@fb.com>
 <20160721190342.GA22835@localhost.localdomain>
 <0ee2835c-17e4-08d3-69ef-280dc9e188ad@fb.com>
 <20160721213319.GC22835@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160721213319.GC22835@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 21, 2016 at 02:33:19PM -0700, Liu Bo wrote:
> > > update_block_group() is the only producer to add block group cache to
> > > dirty_bgs list, and if btrfs_run_delayed_refs() aborts, the transaction
> > > is aborted, so seems that there won't be anyone manipulating dirty_bgs
> > > list, am I missing?
> > > 
> > 
> > No, the dirty_bgs processing is safe I think.  My concern is with the cache
> > inode which we iput()
> 
> I think iput() is OK, we're doing iput() on block group cache on the io_bgs
> list, where all block groups's inodes has been igrab()'d.  If others are
> messing around with our cache inode, they should have their own igrab,
> too.
> 
> > 
> > > Another point is that when we fail on btrfs_start_dirty_block_groups(),
> > > btrfs_commit_transaction() won't get to cleanup_transaction error
> > > handling,
> > 
> > Right, because we don't actually finish the commit.  Someone will eventually
> > though ;)
> 
> Hmm yes, it's possible that there's a concurrent commit transaction
> running.  If that's not true, we may still resort to
> btrfs_error_commit_super(), other than that, I don't see who could
> commit/cleanup the transaction after entering into BTRFS_FS_STATE_ERROR
> state.

What's the resume of this patch? I don't see a followup patch or a (to
me) clear yes/no whether to merge it. Please let me know, thanks.
