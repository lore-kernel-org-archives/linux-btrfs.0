Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57286 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751585AbeEVQa5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 12:30:57 -0400
Date: Tue, 22 May 2018 18:28:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Ethan Lien <ethanlien@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: balance dirty metadata pages in
 btrfs_finish_ordered_io
Message-ID: <20180522162810.GV6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180427070524.12188-1-ethanlien@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180427070524.12188-1-ethanlien@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 27, 2018 at 03:05:24PM +0800, Ethan Lien wrote:
> We should balance dirty metadata pages at the end of
> btrfs_finish_ordered_io, since a small, unmergeable random write can
> potentially produce dirty metadata which is multiple times larger than
> the data itself. For example, a small, unmergeable 4KiB write may
> produce:
> 
>     16KiB dirty leaf (and possibly 16KiB dirty node) in subvolume tree
>     16KiB dirty leaf (and possibly 16KiB dirty node) in checksum tree
>     16KiB dirty leaf (and possibly 16KiB dirty node) in extent tree
> 
> Although we do call balance dirty pages in write side, but in the
> buffered write path, most metadata are dirtied only after we reach the
> dirty background limit (which by far onlys counts dirty data pages) and
> wakeup the flusher thread. If there are many small, unmergeable random
> writes spread in a large btree, we'll find a burst of dirty pages
> exceeds the dirty_bytes limit after we wakeup the flusher thread - which
> is not what we expect. In our machine, it caused out-of-memory problem
> since a page cannot be dropped if it is marked dirty.
> 
> Someone may worry about we may sleep in btrfs_btree_balance_dirty(), but
> since we do btrfs_finish_ordered_io in a separate worker, it will not
> stop the flusher consuming dirty pages. Also, we use different worker for
> metadata writeback endio, sleep in btrfs_finish_ordered_io help us
> throttle the size of dirty metadata pages.

The described scenario sounds interesting. Do you have some scripted
steps to reproduce it?

btrfs_btree_balance_dirty detects congestion and can skip the balancing
eventually, so the case when it actually does something and waits is the
point where things can go bad. From the last paragraph, it is clear that
you have considered that, that's good.

Have you also considered calling __btrfs_btree_balance_dirty with
flush_delayed=0 ? This would avoid the waiting and I'm not sure if it's
really required here to get out of the situation.

Anyway, I'll add the patch to for-next for more testing.
