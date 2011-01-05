From: Josef Bacik <josef@redhat.com>
Subject: Offline Deduplication for Btrfs
Date: Wed,  5 Jan 2011 11:36:48 -0500
Message-ID: <1294245410-4739-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Here are patches to do offline deduplication for Btrfs.  It works well for the
cases it's expected to, I'm looking for feedback on the ioctl interface and
such, I'm well aware there are missing features for the userspace app (like
being able to set a different blocksize).  If this interface is acceptable I
will flesh out the userspace app a little more, but I believe the kernel side is
ready to go.

Basically I think online dedup is huge waste of time and completely useless.
You are going to want to do different things with different data.  For example,
for a mailserver you are going to want to have very small blocksizes, but for
say a virtualization image store you are going to want much larger blocksizes.
And lets not get into heterogeneous environments, those just get much too
complicated.  So my solution is batched dedup, where a user just runs this
command and it dedups everything at this point.  This avoids the very costly
overhead of having to hash and lookup for duplicate extents online and lets us
be _much_ more flexible about what we want to deduplicate and how we want to do
it.

For the userspace app it only does 64k blocks, or whatever the largest area it
can read out of a file.  I'm going to extend this to do the following things in
the near future

1) Take the blocksize as an argument so we can have bigger/smaller blocks
2) Have an option to _only_ honor the blocksize, don't try and dedup smaller
blocks
3) Use fiemap to try and dedup extents as a whole and just ignore specific
blocksizes
4) Use fiemap to determine what would be the most optimal blocksize for the data
you want to dedup.

I've tested this out on my setup and it seems to work well.  I appreciate any
feedback you may have.  Thanks,

Josef
