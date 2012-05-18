Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54954 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab2ERLWA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 May 2012 07:22:00 -0400
Received: by obbtb18 with SMTP id tb18so3832729obb.19
        for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2012 04:22:00 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 18 May 2012 14:21:59 +0300
Message-ID: <CAHf9xvbp=FQwY1Pn9FDaMPdGqe-G4aSMeBK8kUAq-5Kry0YaTA@mail.gmail.com>
Subject: Newbie questions on some of btrfs code...
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings everybody,
I have been studying some of the btrfs code and the developer
documentation on the wiki. My primary interest at this point, is to be
able to search within fs tree of a btrfs subvolume, which was created
as a snapshot of another subvolume. For that I have been using the
debug-tree tool plus the References.png diagram on the wiki. I realize
that my knowledge of btrfs is very rudimentary at this point, so
please bear with me.

# How can I navigate from EXTENT_DATA within the fs tree to
appropriate CHUNK_ITEM in the chunk tree? I am basically trying to
find where the file data resides on disk. For example, I have an
EXTENT_DATA like this:
        item 30 key (265 EXTENT_DATA 0) itemoff 888 itemsize 53
                extent data disk byte 12648448 nr 8192
                extent data offset 0 nr 8192 ram 8192
                extent compression 0
I can navigate from here to EXTENT_ITEM within the extent tree, using
btrfs_file_extent_item::disk_bytenr/disk_num_bytes as key for search:
        item 3 key (12648448 EXTENT_ITEM 8192) itemoff 3870 itemsize 53
                extent refs 1 gen 8 flags 1
                extent data backref root 5 objectid 265 offset 0 count 1
But from there how can I reach the relevant CHUNK_ITEM?

# Once I have reached the CHUNK_ITEM, I assume that
btrfs_file_extent_item::offset/num_bytes fields will provide the exact
location of the data on disk. Is that correct? For now I assume that
btrfs was created on a single device and raid0 is used for data, so I
totally ignore mirroring/striping at this point.

# I have been trying to follow btrfs_fiemap(), which seems to do the
job, but it looks like it returns the disk_bytenr/disk_num_bytes
fields without following to CHUNK_ITEMs. Maybe I am wrong.

Some general questions on the ctree code.

# I saw that slot==0 is special. My understanding is that btrfs
maintains the property that the parent of each node/leaf has a key
pointing to that node/leaf, which must be equal to the key in the
slot==0 of this node/leaf. That's what fixup_low_keys() tries to
maintain. Is this correct?

# If my understanding in the previous bullet is correct: Is that the
reason that in btrfs_prev_leaf() it is assumed that if there is a
lesser key, btrfs_search_slot() will never bring us to the slot==0 of
the current leaf?

# btrfs_search_slot(): how can it happen that b becomes NULL, and we
exit the while loop? (and set ret=1)

# btrfs_insert_empty_items(): if nr>1, then an array of keys is
expected to be passed. But btrfs_search_slot() is searching only for
the first key. What happens if the first key does not exist (as
expected), but the next key in the array exists?

# Do my questions make sense?

Thanks!
Alex.
