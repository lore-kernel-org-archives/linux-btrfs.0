Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44242 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933685AbcIEQcw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Sep 2016 12:32:52 -0400
Date: Mon, 5 Sep 2016 18:31:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/7] Kill the btree inode
Message-ID: <20160905163120.GY16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1472845206-22870-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1472845206-22870-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 02, 2016 at 03:39:59PM -0400, Josef Bacik wrote:
> In order to provide a better way to do subpage blocksizes we need to stop
> allocating pages from a per fs btree inode and instead allocate our own pages.
> This work depends on 3 generic patches that I've sent previously
> 
> remove mapping from balance_dirty_pages*()
> writeback: allow for dirty metadata accounting
> writeback: introduce super_operations->write_metadata

What's the status of the patches? I don't see them in current
linux-next. I can put them to our for-next for the time being so we can
test the btree_inode removal.

> This is a pretty big change but ultimately makes extent_buffer reclaim much
> cleaner and will make the sub-pagesize blocksize work significantly cleaner.
> I've been hammering on this for a few weeks now and seems to be pretty solid.

The preparatory patches are ok. The core patch is quite large, although
there are simple transformations to the new eb_info, the remaining
changes are still quite big for a review. But I don't see a way how to
split it, it's basically an all-or-nothing change. Overall it looks ok
so I'll put it to for-next.
