Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36648 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755392Ab2FGXED (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jun 2012 19:04:03 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Cc: chris.mason@oracle.com
Subject: [PATCH 0/3] btrfs-progs: Support for extended inode refs
Date: Thu,  7 Jun 2012 16:00:53 -0700
Message-Id: <1339110056-21484-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   The following three patches add support to btrfs-progs for extended inode
refs.  The kernel patch set can be found:

http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg16567.html

the userspace patches have been tested alongside the kernel patches and seem
to be in pretty good order. These patches get us support for mkfs,
btrfs-debug-tree and importantly, fsck. The mkfs patch is last so that it
can easily be taken in and out of the patch series in case we wish to test
these changes without actually enabling the disk feature yet.
	--Mark

 
** For reference, I will include my description of the extended inode ref
design:

Currently btrfs has a limitation on the maximum number of hard links an
inode can have. Specifically, links are stored in an array of ref
items:

struct btrfs_inode_ref {
        __le64 index;
        __le16 name_len;
        /* name goes here */
} __attribute__ ((__packed__));

The ref arrays are found via key triple:

(inode objectid, BTRFS_INODE_EXTREF_KEY, parent dir objectid)

Since items can not exceed the size of a leaf, the total number of links
that can be stored for a given inode / parent dir pair is limited to under
4k. This works fine for the most common case of few to only a handful of
links. Once the link count gets higher however, we begin to return EMLINK.


The following patches fix this situation by introducing a new ref item:

struct btrfs_inode_extref {
        __le64 parent_objectid;
        __le64 index;
        __le16 name_len;
        __u8   name[0];
        /* name goes here */
} __attribute__ ((__packed__));

Extended refs use a different addressing scheme. Extended ref keys look
like:

(inode objectid, BTRFS_INODE_EXTREF_KEY, hash)

Where hash is defined as a function of the parent objectid and link name.

This effectively fixes the limitation, though we have a slightly less
efficient packing of link data. To keep the best of both worlds then, I
implemented the following behavior:

Extended refs don't replace the existing ref array. An inode gets an
extended ref for a given link _only_ after the ref array has been filled. 
So the most common cases shouldn't actually see any difference in
performance or disk usage as they'll never get to the point where we're
using an extended ref.

It's important while reading the patches however that there's still the
possibility that we can have a set of operations that grow out an inode ref
array (adding some extended refs) and then remove only the refs in the
array.  I don't really see this being common but it's a case we always have
to consider when coding these changes.

Extended refs handle the case of a hash collision by storing items with the
same key in an array just like the dir item code. This means we have to
search an array on rare occasion.

--
Mark Fasheh
