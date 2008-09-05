From: Chris Mason <chris.mason@oracle.com>
Subject: New disk format and fsync optimizations pushed out
Date: Fri, 05 Sep 2008 16:35:41 -0400
Message-ID: <1220646941.8075.98.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I've pushed out my work to optimize file and directory fsyncs (as well
as O_SYNC writes).  It includes a new disk format.

I'll post some benchmarks next week, but in general this should be much
more usable in mail server workloads.  Details on how it all works can
be found in tree-log.c comments.

The short version is that instead of an fsync doing a full FS commit,
items for a given file or directory that have been changed by the
current transaction are copied into a log tree.

This log tree uses the same copy on write code as all the other trees in
the FS, but the super block has pointers to a tree of log tree roots,
and synchronous FS ops are changed to write an updated super block with
just the pointer to the log trees modified.

After a crash, items and extent pointers are copied out of the log tree
back into the main FS.

The end result is that fsyncs don't commit the extent tree or force a
recow of any subvolume tree blocks, which is what made them so expensive
in the old code.

fsyncs in one subvolume don't force other subvolumes to flush all of
their blocks to disk.  fsyncs in one file don't force any other files or
directories down to disk.  In other words, it makes the impact of an
fsync much smaller in every workload.

Blocks for the log tree come out of the metadata block groups.  So they
have the same raid levels and duplication rules as the rest of the
metadata.

-chris


