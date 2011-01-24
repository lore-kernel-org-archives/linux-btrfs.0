From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Defragmentation Not Working with Directory as Argument
Date: Mon, 24 Jan 2011 12:11:07 -0600
Message-ID: <AANLkTi=AtFgMoES1z7jXwwXkZynbBjYbPTJK_4_iULSF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Defragmentation is not working when a directory is supplied as the
argument.  When a file name is supplied as the argument,
defragmentation works well.

This can be demonstrated as follows:

# mount /dev/sdb2 /mnt/btrfs
# cd /mnt/btrfs/
# cp /usr/src/linux/fs/btrfs/zlib.c  .    (any suitable file will do,
small text files seemed appropriate)
# cp zlib.c fragmented-zlib.c
# btrfs fi sync /mnt/btrfs
# cat zlib.c >> fragmented-zlib.c
# btrfs fi sync /mnt/btrfs
# filefrag zlib.c fragmented-zlib.c
zlib.c: 1 extent found
fragmented-zlib.c: 2 extents found
# btrfs filesystem defragment /mnt/btrfs/
# btrfs fi sync /mnt/btrfs
# filefrag zlib.c fragmented-zlib.c
zlib.c: 1 extent found
fragmented-zlib.c: 2 extents found

Now, supply a filename as the argument

# btrfs filesystem defragment /mnt/btrfs/fragmented-zlib.c
# btrfs fi sync /mnt/btrfs
# filefrag zlib.c fragmented-zlib.c
zlib.c: 1 extent found
fragmented-zlib.c: 1 extent found

I've also tested defragmentation on my normal btrfs filesystems, and
have seen the same results.  I've never seen a file defragmented when
using a directory as the argument.

Also, I was wondering if one of the Btrfs developers could clarify the
intended scope of defragmentation when a directory is supplied as the
argument.

I have seen comments on the mailing list indicating that only the
directory supplied is intended to be defragmented, and defragmentation
will not recurse to subdirectories below.

However, if I look at the code, and read the documentation for the
older btrfsctl command (which seems to be the basis for the current
btrfs command), it seems like the intention is to recursively
defragment the entire tree below the directory supplied in the
argument.
