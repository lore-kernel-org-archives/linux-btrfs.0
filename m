From: Chris Mason <chris.mason@oracle.com>
Subject: New disk format in -unstable (compression!)
Date: Wed, 29 Oct 2008 14:55:56 -0400
Message-ID: <1225306556.6448.277.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I've pushed out the compression code along with a new disk format to the
unstable branches.  A while back I also created a stand alone btrfs repo
that is automatically generated from the unstable git repo (with some
help from David Woodhouse's script).

You can find the standalone repo here:

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable-standalone.git;a=summary

And the full kernel repo here:

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=summary

I managed to miss the guilt refresh on the compression patch (it was
missing a good description in the commit log) and had to do a quick
rebase of the last few commits on the kernel-unstable repos.  There was
only a 10 minute window where the mistake was in there.

Compression is off by default and enabled by mount -o compress.  Even
when the -o compress mount option is not used, it is possible to read
compressed extents off the disk.

If compression for a given set of pages fails to make them smaller, the
file is flagged to avoid future compression attempts later.

I made some big changes to the writeback paths:

* While finding delalloc extents, the pages are locked before being sent down
to the delalloc handler.  This allows the delalloc handler to do complex things
such as cleaning the pages, marking them writeback and starting IO on their
behalf.

* Inline extents are inserted at delalloc time now.  This allows us to compress
the data before inserting the inline extent, and it allows us to insert
an inline extent that spans multiple pages.

* All of the in-memory extent representations (extent_map.c, ordered-data.c etc)
are changed to record both an in-memory size and an on disk size, as well
as a flag for compression.

>From a disk format point of view, the extent pointers in the file are changed
to record the on disk size of a given extent and some encoding flags.
Space in the disk format is allocated for compression encoding, as well
as encryption and a generic 'other' field.  Neither the encryption or the
'other' field are currently used.

In order to limit the amount of data read for a single random read in the
file, the size of a compressed extent is limited to 128k.  This is a
software only limit, the disk format supports u64 sized compressed extents.

In order to limit the ram consumed while processing extents, the uncompressed
size of a compressed extent is limited to 256k.  This is a software only limit
and will be subject to tuning later.

Checksumming is still done on compressed extents, and it is done on the
uncompressed version of the data.  This way additional encodings can be
layered on without having to figure out which encoding to checksum.

Compression happens at delalloc time, which is basically singled threaded because
it is usually done by a single pdflush thread.  This makes it tricky to
spread the compression load across all the cpus on the box.  We'll have to
look at parallel pdflush walks of dirty inodes at a later time.

Decompression is hooked into readpages and it does spread across CPUs nicely.

-chris




