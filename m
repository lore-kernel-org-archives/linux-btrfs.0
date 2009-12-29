From: Ted Phelps <phelps@gnusto.com>
Subject: btrfsck core dump
Date: Tue, 29 Dec 2009 14:26:49 +1000
Message-ID: <200912290426.nBT4QnfQ012260@laika.gnusto.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Summary:

My btrfs test partition started failing btrfsck (0.19) today, which may
be of interest.  What's probably more interesting is that git head
version of btrfsck reliably crashes when pointed at the filesystem.
What's more interesting still is that, after unmounting the filesystem,
btrfsck (both 0.19 and git head) finds no errors.  I have to admit that
I find this a bit confusing.  Is this expected behavior?


Details:

Today I ran btrfsck-0.19 and it ran to completion without errors.  I
then deleted a large number of files from the btrfs filesystem, ran
sync, and then re-ran btrfsck-0.19.  This time it reported a large
number of errors.

Its output ended thusly:

    ...
    Extent back ref already exists for 63434379264 parent 0 root 2 
    Extent back ref already exists for 48350736384 parent 0 root 2 
    Extent back ref already exists for 48365748224 parent 0 root 2 
    leaf 63447334912 items 52 free space 43 generation 1754 owner 2
    fs uuid cc48abf1-0be4-4163-bde6-f8a5264ffa46
    chunk uuid ffbb5c4b-3848-4154-b7f7-ece63fefde52
            item 0 key (63453257728 EXTENT_ITEM 4096) itemoff 3944 itemsize 51
                    extent refs 1 gen 1753 flags 2
                    tree block key (4128112 54 564550111) level 0
                    tree block backref root 5
    ...
            item 50 key (63454093312 EXTENT_ITEM 4096) itemoff 1394 itemsize 51
                    extent refs 1 gen 1754 flags 2
                    tree block key (4123891 c 4123493) level 0
                    tree block backref root 5
            item 51 key (63454117888 EXTENT_ITEM 4096) itemoff 1343 itemsize 51
                    extent refs 1 gen 1745 flags 2
                    tree block key (4121053 60 24) level 0
                    tree block backref root 5
    failed to find block number 63453356032
    Abort

A second run produced different output and crashed at a different location:

    parent transid verify failed on 63451648000 wanted 1764 found 1740
    parent transid verify failed on 63451648000 wanted 1764 found 1740
    parent transid verify failed on 63452520448 wanted 1764 found 1740
    ...
    leaf parent key incorrect 63453581312
    bad block 63453581312
    parent transid verify failed on 63453335552 wanted 1764 found 1739
    parent transid verify failed on 63453335552 wanted 1764 found 1739
    parent transid verify failed on 63453335552 wanted 1764 found 1739
    warning, start mismatch 61248888832 61248884736
    warning, start mismatch 61248942080 61248937984
    warning, start mismatch 61249093632 61249077248
    block 61249077248 rec extent_item_refs 1, passed 1
    warning, start mismatch 61249105920 61249110016
    block 61249110016 rec extent_item_refs 1, passed 1
    Abort

Unfortunately, the beginning of the first run scrolled off the top of my
scrollback buffer, but the entirety of what I do have is here:

    http://www.gnusto.com/btrfs/dump-20091229.txt


I then tried running btrfsck from git head (ab8fb4c9) and it crashed:

    parent transid verify failed on 63447986176 wanted 1765 found 1742
    parent transid verify failed on 63447986176 wanted 1765 found 1742
    parent transid verify failed on 63447531520 wanted 1765 found 1736
    ...
    parent transid verify failed on 63447908352 wanted 1765 found 1742
    parent transid verify failed on 63447908352 wanted 1765 found 1742
    parent transid verify failed on 63447908352 wanted 1765 found 1763
    Segmentation fault (core dumped)

The core file shows the following stack:

(gdb) bt
    #0  0x000000000041e242 in btrfs_header_nritems (eb=0x0) at ctree.h:1411
    #1  0x000000000041f87c in btrfs_print_leaf (root=0x1e2e200, l=0x0) at print-tree.c:454
    #2  0x00000000004197e4 in btrfs_lookup_extent_info (trans=0x0, root=0x1e2e200, bytenr=63447326720, num_bytes=4096, refs=0x0, flags=0x7fff58a1f5c0) at extent-tree.c:1450
    #3  0x0000000000408582 in run_next_block (root=0x1e2e200, bits=0x1e2f410, bits_nr=1024, last=0x7fff58a1f798, pending=0x7fff58a1f890, seen=0x7fff58a1f8a0, reada=0x7fff58a1f880, nodes=0x7fff58a1f870, extent_cache=0x7fff58a1f8b0) at btrfsck.c:2509
    #4  0x000000000040942f in check_extents (root=0x1e2e200) at btrfsck.c:2797
    #5  0x000000000040951c in main (ac=2, av=0x7fff58a1fa28) at btrfsck.c:2829

At this point, I copied all of the files to another partition.  No
errors were logged to syslog, which I thought a little odd/impressive.
At this point I ran btrfs-image (also from git head).  It complained
about various transid verify failures but produced the following 90MB
image:

    http://www.gnusto.com/btrfs/btrfs-image-20091229.img

The partition was mounted with compress and noatime options only.  I
then unmounted the file system and re-ran btrfsck-0.19 and it reported
no errors.  Ditto for btrfsck from git head.

Thanks,
-Ted
