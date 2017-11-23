Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-eopbgr10061.outbound.protection.outlook.com ([40.107.1.61]:36416
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753333AbdKWXui (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Nov 2017 18:50:38 -0500
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: python-btrfs release v9
To: linux-btrfs@vger.kernel.org
Message-ID: <3b270813-08c7-1f36-8da9-c01b19245c67@mendix.com>
Date: Fri, 24 Nov 2017 00:50:31 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just tagged v9 of the python btrfs library.

https://github.com/knorrie/python-btrfs

Q: What is python-btrfs?
A: python-btrfs is a python3 implementation of the data structures for
btrfs metadata, and an implementation of the kernel API (via ioctl
calls) that btrfs provides to userland.

Q: Ok, whatever, dude, but what would I need that for?
A: You probably won't need this.

Q: I'm a btrfs developer, what is this?
A: It provides quick hackable ways to inspect a running filesystem. You
can look up things in the current kernel metadata memory, play around
with ioctls, and quickly cobble up scripts for that.

Here's the summary of changes:

python-btrfs v9, Nov 23 2017
  * IOCTLs: IOC_SET_RECEIVED_SUBVOL, IOC_LOGICAL_INO_V2
  * Add crc32c checksum function for data, thanks Nikolay Borisov
  * Recognize zstd compression type
  * Add a tree object pretty printer to dump data for any tree item
  * Examples added:
    - Show default subvolume id
    - Lookup a block checksum in the checksum tree
    - Determine bad free space fragmentation score for block groups
    - Set the received_uuid e.a. of a subvolume
    - Dump an entire metadata tree using the pretty printer
  * Fixes:
    - crc32c: add implicit seed truncation to 32 bits value
  * Small fixes and cosmetic changes

Note: the IOC_SET_RECEIVED_SUBVOL is added 'because we can'. It's not
added because it's a very good to mess around with it except for
educational purpose in a test environment.

As usual, detailed explanations of all changes are in the git commit
messages.

Feedback from Nikolay Borisov pushed me to have a look at how the
checksum storage is done.

My favorite one for this release is the tree object pretty printer,
which allows us to dump a single tree object displaying all its
attributes, but also allows us to stream a search query into it to
output a full dump of a metadata tree. See the examples/dump_tree.py
about this!

Tomorrow I'll update pypi and will prepare debian packages for unstable
and stretch-backports.

-- 
Have fun,
Hans van Kranenburg
