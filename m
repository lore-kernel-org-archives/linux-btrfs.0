From: Mathieu Chouquet-Stringer <mathieu@csetco.com>
Subject: Btrfs bug with g38867a2 and a question
Date: Wed, 21 Sep 2011 20:53:50 +0200
Message-ID: <20110921185350.GA6618@kashmir>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

	Hello all,

I've been using BTRFS for quite some time on this laptop and I just
recompiled the latest kernel from git (3.1.0-rc6-00247-g38867a2).  After
a couple minutes, I hit this bug twice (this a hand written transcript,
pics here [1]) kernel BUG at fs/btrfs/inode.c:785!

stack being:

_raw_spin_unlock_irqrestore
__wake_up
btrfs_tree_read_unlock_blocking
free_extent_buffer
run_delalloc_nocow
run_dellaloc_range
free_extent_state
find_lock_delalloc_range.constrpop
__extent_writepage
...

Note the stack trace is exactly the same in these two crashes.  Since
google found nothing, I'm asking for your help!

Looking at the source, line 785 is function cow_file_range, code:
BUG_ON(btrfs_is_free_space_inode(root, inode));

My fs (a simple partition on a OCZ-VERTEX2 ssd) is mounted with the
following options:
ssd,discard,autodefrag

with disk space caching as it had been added earlier:
btrfs: disk space caching is enabled
Btrfs detected SSD devices, enabling SSD mode

Anything I could do to help debug this one?

Moreover, I've been experiencing long lags when my computer seems to be
just busy doing writes (right now I'm on 3.1.0-rc6-00067-gf1fcd9f): it's
not hung or anything except all IOs are blocked (hence I can start
anything to see what's going on but I have a gauge on my xfce panel that
goes 100% with writes).  After some point, it just recovers and
everything is back to normal.  I've tried capturing something with
sysrq-t but I haven't been able to find anything striking.  Should I
just submit something similar to this mailing list?

[1] http://mathieu.csetco.com/btrfs-crash1.jpg
    http://mathieu.csetco.com/btrfs-crash2.jpg

-- 
Mathieu Chouquet-Stringer                         mathieu@csetco.com
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
