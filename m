From: Arne Jansen <sensille@gmx.net>
Subject: [RFC] Tree fragmentation and prefetching
Date: Wed, 23 Mar 2011 14:06:02 +0100
Message-ID: <4D89F03A.9050306@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

While looking into the performance of scrub I noticed that a significant
amount of time is being used for loading the extent tree and the csum
tree. While this is no surprise I did some prototyping on how to improve
on it.
The main idea is to load the tree (or parts of it) top-down, order the
needed blocks and distribute it over all disks.
To keep you interested, some results first.

a) by tree enumeration with reada=2
   reading extent tree: 242s
   reading csum tree: 140s
   reading both trees: 324s

b) prefetch prototype
   reading extent tree: 23.5s
   reading csum tree: 20.4s
   reading both trees: 25.7s

The test setup consists of a 7 Seagate ES.2 1TB disks filesystem, filled
28%. It is created with the current git tree + the round robin patch and
filled with

fs_mark -D 512 -t 16 -n 4096 -F -S0

The 'normal' read is done by enumerating the leaves by btrfs_next_leaf()
with path->reada=2. Both trees are being enumerated one after the other.
The prototype currently just uses raw bios, does not make use of the
page cache and does not enter the read pages into the cache. This will
probably add some overhead. It also does not check the crcs.

While it is very promising to implement it for scrub, I think a more
general interface which can be used for every enumeration would be
beneficial. Use cases that come to mind are rebalance, reflink, deletion
of large files, listing of large directories etc..

I'd imagine an interface along the lines of

int btrfs_readahead_init(struct btrfs_reada_ctx *reada);
int btrfs_readahead_add(struct btrfs_root *root,
                        struct btrfs_key *start,
                        struct btrfs_key *end,
                        struct btrfs_reada_ctx *reada);
void btrfs_readahead_wait(struct btrfs_reada_ctx *reada);

to trigger the readahead of parts of a tree. Multiple readahead
requests can be given before waiting. This would enable the very
beneficial folding seen above for 'reading both trees'.

Also it would be possible to add a cascading readahead, where the
content of leaves would trigger readaheads in other trees, maybe by
giving a callback for the decisions what to read instead of the fixed
start/end range.

For the implementation I'd need an interface which I haven't been able
to find yet. Currently I can trigger the read of several pages / tree
blocks and wait for the completion of each of them. What I'd need would
be an interface that gives me a callback on each completion or a waiting
function that wakes up on each completion with the information which
pages just completed.
One way to achieve this would be to add a hook, but I gladly take any
implementation hints.

--
Arne


