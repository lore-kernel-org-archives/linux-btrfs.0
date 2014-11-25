Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47021 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbaKYRTc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 12:19:32 -0500
Date: Tue, 25 Nov 2014 18:19:27 +0100
From: Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 2/4] vfs: add support for a lazytime mount option
Message-ID: <20141125171927.GC3228@quack.suse.cz>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
 <1416599964-21892-3-git-send-email-tytso@mit.edu>
 <20141125015239.GD27262@dastard>
 <20141125043335.GF31339@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141125043335.GF31339@thunk.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon 24-11-14 23:33:35, Ted Tso wrote:
> On Tue, Nov 25, 2014 at 12:52:39PM +1100, Dave Chinner wrote:
> > Eviction is too late for this. I'm pretty sure that it won't get
> > this far as iput_final() should catch the I_DIRTY_TIME in the !drop
> > case via write_inode_now().
> 
> Actually, the tracepoint for fs_lazytime_evict() does get triggered
> from time to time; but only when the inode is evicted due to memory
> pressure, i.e., via the evict_inodes() path.
> 
> I thought about possibly doing this in iput_final(), but that would
> mean that whenever we closed the last fd on the file, we would push
> the inode out to disk.  For files that we are writing, that's not so
> bad; but if we enable strictatime with lazytime, then we would be
> updating the atime for inodes that had been only been read on every
> close --- which in the case of say, all of the files in the kernel
> tree, would be a little unfortunate.
  Actually, I'd also prefer to do the writing from iput_final(). My main
reason is that shrinker starts behaving very differently when you put
inodes with I_DIRTY_TIME to the LRU. See inode_lru_isolate() and in
particular:
        /*
         * Referenced or dirty inodes are still in use. Give them another
         * pass
         * through the LRU as we canot reclaim them now.
         */
        if (atomic_read(&inode->i_count) ||
            (inode->i_state & ~I_REFERENCED)) {
                list_del_init(&inode->i_lru);
                spin_unlock(&inode->i_lock);
                this_cpu_dec(nr_unused);
                return LRU_REMOVED;
        }

Regarding your concern that we'd write the inode when file is closed -
that's not true. We'll write the inode only after corresponding dentry is
evicted and thus drops inode reference. That doesn't seem too bad to me.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
