Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f171.google.com ([74.125.82.171]:42718 "EHLO
        mail-ot0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754121AbeE1JV7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 05:21:59 -0400
Received: by mail-ot0-f171.google.com with SMTP id l13-v6so12799427otk.9
        for <linux-btrfs@vger.kernel.org>; Mon, 28 May 2018 02:21:59 -0700 (PDT)
MIME-Version: 1.0
From: james harvey <jamespharvey20@gmail.com>
Date: Mon, 28 May 2018 05:21:58 -0400
Message-ID: <CA+X5Wn6yTE5+U16fXZZHFrAeybXUDrwjk3DdOJU+OG9qXgFPEw@mail.gmail.com>
Subject: Questions from aspiring btrfs mini-debugger/mini-developer
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm tracking down some more bugs.

Useful information for you to track down these bugs isn't in this
email.  This is more about an aspiring btrfs
mini-debugger/mini-developer asking for some guidance, to be able to
get the more useful information.

I ran across some mirrored files that are nodatacow/nodatasum, with
differing mirrored extents.  UNLIKE BEFORE, these are uncompressed.
Mostly /var/cache/samba and /var/lib/mysql files.  This also happened
during my recent btrfs replace.  Luckily for me, I had the unmodified
original images, so when I re-did this with a btrfs device add /
remove, the new ones are fine.

I'm almost positive I have extents with checksums, where its inode is
marked nodatacow.  This would be a bug, right?  (Confirming before I
look into this much more.)



I've spent a few days familiarizing myself with btrfs (kernel and
-progs) internals and source.

I've made some additions to btrfs-progs, that I'll submit once
finished.  One of them compares mirrored extents, looking for
differences.  If I have it check all extents, it brings up every
problematic file I've found, and the few I mentioned above that I
wasn't aware of because they were uncompressed.  I'll give more on
this once I have the details.  I think this must mean scrub doesn't
verify extents with checksums that are marked nodatacow, since it's
not expecting them to have checksums.



I have a few questions that would greatly help having answered.

Am I right that an inode has a single set of btrfs flags (things like
nodatacow, nodatasum, etc) accessable through btrfs_inode_flags()?  I
want to make sure extents within the same file can't have any varying
flags, and that a file and its extents across multiple snapshots all
share the same.

What about deduplicated extents?  If there's a file whose inode says
it has checksums, and another file whose inode has nodatasum, and
there's duplicate blocks, are they deduplicated, or does deduplication
see this and skip it because of the mismatch?

I have files that have some extents compressed, and others without.
Is this allowed?  This might just be on nodatacow files defragmented
and compressed, so maybe that process left some extents uncompressed.
Wondering if this is allowed before I dig more to see if it's on files
that haven't been through that process.



extent_offset isn't making sense to me.  I have a file whose filefrag includes:

  28:      896..     919:     596954..    596977:     24:     596978:
encoded,shared
  29:      920..    1023:     580304..    580407:    104:     596978: shared
  30:     1024..    1055:     596961..    596992:     32:     580408:
encoded,shared

#29, through btrfs-tree-debug, is:

        item 49 key (71469 EXTENT_DATA 3768320) itemoff 13232 itemsize 53
                generation 218 type 1 (regular)
                extent data disk byte 2373160960 nr 8384512
                extent data offset 3764224 nr 425984 ram 8384512
                extent compression 0 (none)

Its extents without a data offset (i.e. filefrag #30) look like:

        item 50 key (71469 EXTENT_DATA 4194304) itemoff 13179 itemsize 53
                generation 310 type 1 (regular)
                extent data disk byte 2445152256 nr 49152
                extent data offset 0 nr 131072 ram 131072
                extent compression 2 (lzo)

So, item 49 is saying there's 8,384,512 bytes on disk, but for this
file extent, only read starting 3,764,224 into the extent_data, and
only read 425,984 bytes?  This is a snapshotted file.  At first, I was
thinking this might mean most of this extent had changed, but 425,984
bytes in the "middle" were the same, so btrfs was re-using that
portion.  Is that's why data_offset is used?  In this case, there is
the file in its normal location plus 43 older snapshots.  All of the
files are completely identical.  It's always possible there could have
been a deleted snapshot that was different, so maybe that's why I'm
not seeing a difference, and maybe it made sense in this way when it
was done.



extent_offset on prealloc data makes even less sense to me, like:

        item 47 key (71469 EXTENT_DATA 42098688) itemoff 13739 itemsize 53
                generation 293 type 2 (prealloc)
                prealloc data disk byte 2426286080 nr 8388608
                prealloc data offset 155648 nr 8232960

Am I right that preallocated means no data has actually been written
there?  Why does it even have a disk byte then, isn't that taking up
disk space?  And, why would it have a data offset of 155648 after that
disk byte location if there's no data there?



In the context of uncompressed extents, what's the difference between
extent num_bytes and extent_ram_bytes?  They're usually the same, but
sometimes different:

        item 126 key (275 EXTENT_DATA 12288) itemoff 9867 itemsize 53
                generation 98 type 1 (regular)
                extent data disk byte 1656295424 nr 8192
                extent data offset 0 nr 4096 ram 8192
                extent compression 0 (none)

I understand for compressed extents, the disk byte line nr is showing
size on disk, offset line nr is showing uncompressed size and ram is
showing uncompressed size.  But, this one's uncompressed and still
showing a data offset line nr value half the size (4096) of the ram
and disk byte line nr values (8192.)



Given an extent_buffer, btrfs_item, slot, and btrfs_file_extent_item,
if the extent type is BTRFS_FILE_EXTENT_INLINE, how would one get the
on-disk (so if compressed, in compressed format) data?  With
non-inline, non-prealloc extents, I'm using bytenr as location and
num_bytes as length, and code based off btrfs-map-logical, which winds
up using read_extent_data with a mirror number argument, which uses
btrfs_map_block() on that logical address and mirror and pread64() to
do the read.  For inline data, there's no logical address.



I'm going to be writing and submitting useful things I'll submit, like
a "btrfs inspect-internal lsattr" which will show btrfs attributes
lsattr doesn't.  List all files marked nodatasum or nodatacow, etc.
I'm starting simpler by writing a non-useful thing, my own version of
inspect-internal inode-resolve-mine.  (Actual version uses a totally
different way.)  I'm not getting btrfs_search_slot() to work as
expected.  I wrote mine first, but after not getting it working, found
the only btrfs-progs place a BTRFS_INODE_REF_KEY is used for
btrfs_search_slot is in inode-item.c::btrfs_lookup_inode_ref.  Calling
this function (code to do so not shown below) doesn't work, either.
It still returns 1, indicating not found.

First, can you have btrfs_search_slot() look for a specified type, and
either a specified objectid or offset field?  Like, for
BTRFS_INODE_REF_KEY, could you have it search for an inode (putting
that in objectid) but telling it you don't know and don't care about
the parent inode (putting something like 0 in offset?)  Neither way
works for me, just wondering if you can do this.



# mount /dev/lvm/btrfs /mnt/btrfs
# ls -la /mnt/btrfs
total 2136
drwxr-xr-x 1 root root      84 May 23 23:44 .
drwxr-xr-x 1 root root     140 May 28 01:50 ..
-rw-r--r-- 1 root root      11 May 23 23:05 compressed
-rw-r--r-- 1 root root 1048576 May 23 23:44 nocow
-rw-r--r-- 1 root root      13 May 23 23:05 uncompressed
-rw-r--r-- 1 root root 1048576 May 23 23:43 urandom.1m
-rw-r--r-- 1 root root   65536 May 23 23:29 zeros
# /usr/bin/btrfs inspect-internal dump-tree /dev/lvm/btrfs
...
        item 2 key (256 DIR_ITEM 1378320618) itemoff 16076 itemsize 35
                location key (259 INODE_ITEM 0) type FILE
                transid 10 data_len 0 name_len 5
                name: zeros
...
        item 9 key (256 DIR_INDEX 4) itemoff 15802 itemsize 35
                location key (259 INODE_ITEM 0) type FILE
                transid 10 data_len 0 name_len 5
                name: zeros
...
        item 19 key (259 INODE_REF 256) itemoff 15124 itemsize 15
                index 4 namelen 5 name: zeros
...
# # so, there's a BTRFS_INODE_REF_KEY with objectid 259 (inode) and
offset 256 (parent inode.)
# ./btrfs inspect-internal inode-resolve-mine 259 /dev/lvm/btrfs
Looking for inode 259
At dev /dev/lvm/btrfs
ERROR: Did not find inode 259
extent buffer leak: start 30457856 len 16384



diff --git a/cmds-inspect.c b/cmds-inspect.c
index afd7fe48..01c69fd0 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -122,6 +122,68 @@ static int cmd_inspect_inode_resolve(int argc, char **argv)

 }

+static const char * const cmd_inspect_inode_resolve_mine_usage[] = {
+       "btrfs inspect-internal inode-resolve-mine <inode> <device>",
+       "Get file system paths for the given inode, my way",
+       NULL
+};
+
+static int cmd_inspect_inode_resolve_mine(int argc, char **argv)
+{
+       u64 inode;
+       char *dev;
+       struct btrfs_fs_info *info;
+       unsigned open_ctree_flags;
+       int ret;
+       struct btrfs_key key;
+       struct btrfs_path path;
+
+       open_ctree_flags = OPEN_CTREE_PARTIAL | OPEN_CTREE_NO_BLOCK_GROUPS;
+
+       if (check_argc_exact(argc - optind, 2))
+               usage(cmd_inspect_inode_resolve_mine_usage);
+
+       inode = arg_strtou64(argv[optind]);
+       dev = argv[optind+1];
+
+       printf("Looking for inode %llu\n", inode);
+       printf("At dev %s\n", dev);
+
+       ret = check_arg_type(dev);
+       if (ret != BTRFS_ARG_BLKDEV && ret != BTRFS_ARG_REG) {
+               error("not a block device or regular file: %s", dev);
+               goto out;
+       }
+
+       info = open_ctree_fs_info(dev, 0, 0, 0, open_ctree_flags);
+       if (!info) {
+               error("unable to open %s", dev);
+               goto out;
+       }
+
+       key.objectid = inode;
+       key.type = BTRFS_INODE_REF_KEY; // have also tried
BTRFS_INODE_ITEM_KEY, and BTRFS_EXTENT_DATA_KEY
+       key.offset = 0; // I'm hoping you can have search ignore this
field, so parent id can be unknown, but I've also tried 256 here
+       btrfs_init_path(&path);
+       ret = btrfs_search_slot(NULL, info->tree_root, &key, &path, 0,
0); // also tried info->fs_root
+       if (ret < 0) {
+               error("Error looking for inode %llu", inode);
+               goto close_root;
+       } else if (ret == 1) {
+               error("Did not find inode %llu", inode);
+               goto release_path;
+       }
+
+       printf("Success!\n");
+
+release_path:
+       btrfs_release_path(&path);
+close_root:
+       ret = close_ctree(info->fs_root);
+out:
+       return !!ret;
+}
+
 static const char * const cmd_inspect_logical_resolve_usage[] = {
        "btrfs inspect-internal logical-resolve [-Pv] [-s bufsize]
<logical> <path>",
        "Get file system paths for the given logical address",
@@ -633,6 +695,8 @@ const struct cmd_group inspect_cmd_group = {
        inspect_cmd_group_usage, inspect_cmd_group_info, {
                { "inode-resolve", cmd_inspect_inode_resolve,
                        cmd_inspect_inode_resolve_usage, NULL, 0 },
+               { "inode-resolve-mine", cmd_inspect_inode_resolve_mine,
+                       cmd_inspect_inode_resolve_mine_usage, NULL, 0 },
                { "logical-resolve", cmd_inspect_logical_resolve,
                        cmd_inspect_logical_resolve_usage, NULL, 0 },
                { "subvolid-resolve", cmd_inspect_subvolid_resolve,
