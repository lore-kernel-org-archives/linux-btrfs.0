From: Dave <dave@thekilempire.com>
Subject: Re: disk-io.c:416: find_and_setup_root: Assertion `!(!root->node)'
 failed.
Date: Wed, 3 Aug 2011 09:26:48 -0400
Message-ID: <20110803132646.GA9784@hendrix.borisch.local>
References: <20110802144452.GA15647@hendrix.borisch.local>
 <20110802181630.GA5026@hendrix.borisch.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110802181630.GA5026@hendrix.borisch.local>
List-ID: <linux-btrfs.vger.kernel.org>

OK so I have recovered all of my data.  This was sort of a nerve wrecking
experience.  I'll share what I've done in case others are experiencing the same
problem (I've seen other threads appear complaining of the same assertion which
draw no response).

So, I filled open_ctree_fd with printf statements to find exactly where it was
failing.  I found (per my previous mail to this list) that the assertion was
happening in the following call:

ret = find_and_setup_root(tree_root, fs_info, BTRFS_CSUM_TREE_OBJECTID, csum_root);

I also found that the fs would mount read-only on an older kernel but 85% of the
files read reported I/O errors.  It looks like the b-tree which stores checksums
was broken.  The breakage is likely high up on the tree and thus affects most,
but not all files.  Trying to determine how to get btrfs to ignore checksums
lead me here:

http://kerneltrap.org/mailarchive/linux-btrfs/2010/2/25/6806053/thread#mid-6806053

So I grabbed a copy of 2.6.32.10 and patched compression.c and inode.c.  I'm now
able to read ALL of the data when mounting read-only.

This whole process has left a bit of bad taste in my mouth.  A checksum tree
seems like a great way to add fault tolerance but in this case it was another
point of failure, rendering perfectly uncorrupted data unaccessible.  I suppose
this would have to be something a proper fsck would have to contend with.  My
questions for the developers are:

1. Would repairing or rebuilding a broken checksum tree be a trivial task for a
functional fsck?

2. Does a mount option which ignores the checksum tree altogether make sense?
Strictly for recovery purposes of course.  Not everyone is inclined to hack the
kernel to get access to their data.

Either way I've kept the dump of the broken filesystem.  If fsck ever makes it
out of development purgatory I'll definitely be running it against this as a
test case.  I saw an email to this list earlier today asking about the status of
fsck.  It seems like an it would be reasonable to know approximately when
something will be released to the public.  Not asking for a specific day, more
like which quarter of which year.
