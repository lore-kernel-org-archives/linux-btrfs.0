From: Chris Mason <chris.mason@oracle.com>
Subject: new (dangerous) subvol listing branch
Date: Sun, 28 Feb 2010 20:29:23 -0500
Message-ID: <20100301012923.GA11667@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I've integrated Josef's work to allow switching the subvolume used
during mount with a new subvolume listing ioctl.

The end result is in a new branch of the kernel and progs git repository
called subvol.  It may be rebased and is only meant for development and
testing.

Changing the default subvol used for a mount (via a new ioctl)
allows you to force the kernel to use a snapshot or subvolume other than
the default.

If the default subvol for mount is changed (via btrfstctl -m), an
incompat flag gets set on the FS and older kernels will not be able to
mount the FS.

This only happens when you specifically run the ioctl (btrfsctl -m) to
change the default subvolume.

It doesn't happen when you use the new listing ioctl (btrfs-list) or if
you mount an existing FS with the new code.

A new program has been added (btrfs-list) which will give you a list of
all subvolumes and snapshots along with their paths.  It is based on
TARUISI Hiroaki's subvolume listing work, but I wanted to extend things a
little.

The subvolume listing happens via two new ioctls.  The first one is a
very generic btree search, allowing userland to do almost any search
through the btree done by the kernel.  Some day we can use this to find
recently changed files and other important features.

The second ioctl finds the pathname of a directory inside its parent
subvol.  The btrfs-list program combines them to produce a list of all
the subvolumes and the path to find them.

Example output:

# btrfs-list /mnt
ID 256 top level 5 path vol1
ID 257 top level 5 path vol1/vol2
ID 258 top level 5 path vol1/vol2/vol3
ID 259 top level 5 path vol1/vol2/vol3/vol4

ID is the object id of the subvolume.  This is what you'd pass into the
mount -o subvol=NN mount option or the new btrfsctl -m command.

top level (5 in all of these) is basically the disconnected head of the
directory chain.  We could have more than one of them if a subvolume was
unlinked from its directory.  It is a root id, and 5 is the id of the
default subvolume created during mount.

In this case, mount -o subvol=5 will find all of these subvolumes in a
single directory tree.

I'm headed off to vacation this week, but I'll be checking email from
time to time.  Just let me know if there are questions or problems.

-chris

