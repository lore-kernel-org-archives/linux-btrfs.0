From: Nathan Caza <mastercactapus@gmail.com>
Subject: The Missing Device
Date: Fri, 8 Oct 2010 03:12:56 -0500
Message-ID: <AANLkTi==AG4UrOTYF6c++qdddCj9a3rwYXGf5ufJHAm9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In short here's what I know:
 -When running out of free space i partitioned some free space on the
same device as the btrfs, and used 'btrfs add device'
 -Everything worked ok
 -Resized an ext2 filesystem and used fdisk to resize the partition
 -Created a new partition with that free space (all occurring after
the 'new/added' space
 -at some point i messed up the partition table


so at this point ive restored the partition table to the values i had
backed up (although the backup was on the lost partition so it was a
string search)
tried adjusting the table so the second 'device' partition is aligned
so the superblock that IS there is lined up at exactly 64MiB

The super block at 64kib is not there; all zeros; but the one at 64MiB
is there and the fs uuid matches the one on the original partition
 All that i know is what I've been able to compare and deduce from
creating btrfs file systems and comparing the files..

it doesn't seem like anything was overwritten (all zeros at the
beginning); nothing should have been anyways only the partition table
was changed; no formatting/fs creation took place

I'm not sure if i can give any useful information but btrfs-debug-tree gives:
warning devid 2 not found already
btrfs-debug-tree: disk-io.c:741: open_ctree_fd: Assertion
`!(!tree_root->node)' failed.

btrfs fi sh:
Label: none  uuid: 1a1297df-be3e-454e-a6b9-709397c803ff
        Total devices 2 FS bytes used 14.37GB
        devid    1 size 7.82GB used 7.82GB path /dev/sda7
        *** Some devices missing

Btrfs Btrfs v0.19

Also: using ubuntu maverick RC
Linux nathan-laptop 2.6.35-22-generic #33-Ubuntu SMP Sun Sep 19
20:32:27 UTC 2010 x86_64 GNU/Linux

im assuming part of the tree is on the 2nd device that it cannot find;

I'm not at all sure what data would be useful or not; I'm not sure
what i did or if there was a bug; but ill try to get whatever would
help if anything;
as far as my data though I've been trying to make a dirty script to
recover files but as far as I've gotten was
 figuring out where the super block is and finding uuid's;
using this as a chance to learn, albeit from a mistake
any place to start for building a recovery tool for btrfs would be
appreciated (technical disk format details); i need the experience
anyways

Any type of help, suggestions, or requests appreciated!
