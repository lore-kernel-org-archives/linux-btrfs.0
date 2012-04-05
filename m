From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 0/3] btrfs: extended inode refs
Date: Thu,  5 Apr 2012 13:09:00 -0700
Message-ID: <1333656543-4843-1-git-send-email-mfasheh@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

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

Extended refs behave differently from ref arrays in several key areas.

Each extended refs is it's own item so there is no ref array (and
therefore no limit on size).

As a result, we must use a different addressing scheme. Extended ref keys
look like:

(inode objectid, BTRFS_INODE_EXTREF_KEY, hash)

Where hash is defined as a function of the parent objectid and link name.

This effectively fixes the limitation, though we have a slightly less
efficient packing of link data. To keep the best of both worlds then, I
implemented the following behavior:

Extended refs don't replace the existing ref array. An inode gets an
extended ref for a given link _only_ after the ref array has been filled.  So
the most common cases shouldn't actually see any difference in performance
or disk usage as they'll never get to the point where we're using an
extended ref.

It's important while reading the patches however that there's still the
possibility that we can have a set of operations that grow out an inode ref
array (adding some extended refs) and then remove only the refs in the
array.  I don't really see this being common but it's a case we always have
to consider when coding these changes.

Right now there is a limitation for extrefs in that we're not handling the
possibility of a hash collision. There are two ways I see we can deal with
this:

We can use a 56-bit hash and keep a generation counter in the lower 8
bits of the offset field.  The cost would be an additional tree search
(between offset <hash>00 and <hash>FF) if we don't find exactly the name we
were looking for.

An alternative solution to dealing with collisions could be to emulate the
dir-item insertion code - specifically something like insert_with_overflow()
which will stuff multiple items under one key. I tend to prefer the idea of
simply including a generation in the key offset however since it maintains
the 1:1 relationship of keys to names which turns out to be much nicer to
code for in my honest opinion. Also none of the code which iterates the tree
looking for refs would have to change as the only difference is in the key
offset and not in the actual item structure.


Testing wise, the patches are in an intermediate state. I've debugged a fair
bit but I'm certain there's gremlins lurking in there.  The basic namespace
operations work well enough (link, unlink, etc).  I've done light testing of
my changes in backref.c by exercising BTRFS_IOC_INO_PATHS.  The changes in
tree-log.c need the most review and testing - I haven't really figured out a
great way to exercise the code in tree-log yet (suggestions would be
great!).


Finally, these patches are based off Linux v3.3.
	--Mark
