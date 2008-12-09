From: Chris Mason <chris.mason@oracle.com>
Subject: New disk format pushed out
Date: Mon, 08 Dec 2008 19:13:16 -0500
Message-ID: <1228781596.3962.22.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I've pushed out most of the pending patches, including a few big disk
format changes.  It includes Yan Zheng's super block duplication code
(with a few small mods for performance) and all new data checksumming
code.

The data checksumming is a big change, so I'll paste in the changeset
description here.

Btrfs stores checksums for each data block.  Until now, they have
been stored in the subvolume trees, indexed by the inode that is
referencing the data block.  This means that when we read the inode,
we've probably read in at least some checksums as well.

But, this has a few problems:

* The checksums are indexed by logical offset in the file.  When
compression is on, this means we have to do the expensive checksumming
on the uncompressed data.  It would be faster if we could checksum
the compressed data instead.

* If we implement encryption, we'll be checksumming the plain text and
storing that on disk.  This is significantly less secure.

* For either compression or encryption, we have to get the plain text
back before we can verify the checksum as correct.  This makes the raid
layer balancing and extent moving much more expensive.

* It makes the front end caching code more complex, as we have touch
the subvolume and inodes as we cache extents.

* There is potentitally one copy of the checksum in each subvolume
referencing an extent.

The solution used here is to store the extent checksums in a dedicated
tree.  This allows us to index the checksums by phyiscal extent
start and length.  It means:

* The checksum is against the data stored on disk, after any compression
or encryption is done.

* The checksum is stored in a central location, and can be verified without
following back references, or reading inodes.

This makes compression significantly faster by reducing the amount of
data that needs to be checksummed.  It will also allow much faster
raid management code in general.

The checksums are indexed by a key with a fixed objectid (a magic value
in ctree.h) and offset set to the starting byte of the extent.  This
allows us to copy the checksum items into the fsync log tree directly (or
any other tree), without having to invent a second format for them.

-chris


