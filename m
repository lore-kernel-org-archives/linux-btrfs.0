From: Josef Bacik <jbacik@redhat.com>
Subject: Question about the extent root
Date: Tue, 14 Oct 2008 08:50:18 -0400
Message-ID: <20081014125017.GB2864@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm having problems wrapping my head around the purpose of the extent root.  It
seems we can allocate space from the main root, and the extent objects are
inserted into that tree, but we can also make allocations out of the extent
root, and the extent objects are inserted into that tree.  What is the purpose
of the extent tree?  The inserts/deletions from the extent tree only happen via
del_pending_extents and finish_current_insert, but it seems I end up with
extents that are being deleted from the extent_tree and inserted onto the normal
root (I'm killing alloc_mutex so I'm getting weird problems).  I figure instead
of screwing around with the locking until it works its probably best I
understand what exactly we're doing with allocations on both trees, and
hopefully then I can fix this weirdness.  Thank you,

Josef
