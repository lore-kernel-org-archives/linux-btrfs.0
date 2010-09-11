From: Simon Kirby <sim@hostway.ca>
Subject: btrfs-debug-image crash
Date: Fri, 10 Sep 2010 17:53:30 -0700
Message-ID: <20100911005330.GB14444@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I was running this while the fs was mounted, which is probably not what
was expected, but here's a crash report anyway. :)

Simon-

[/usr/src/btrfs-tools/btrfs-tools-0.19+20100601]# gdb --args ./btrfs-debug-tree /dev/etherd/e14.0
GNU gdb 6.8-debian
Copyright (C) 2008 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu"...
(gdb) r
Starting program: /usr/src/btrfs-tools/btrfs-tools-0.19+20100601/btrfs-debug-tree /dev/etherd/e14.0
failed to read /dev/sr0
parent transid verify failed on 20992000 wanted 2666 found 2562
parent transid verify failed on 20992000 wanted 2666 found 2562
parent transid verify failed on 20992000 wanted 2666 found 2562

Program received signal SIGSEGV, Segmentation fault.
0x000000000041d92e in btrfs_header_nritems (eb=0x0) at ctree.h:1416
1416    BTRFS_SETGET_HEADER_FUNCS(header_nritems, struct btrfs_header, nritems, 32);
(gdb) bt
#0  0x000000000041d92e in btrfs_header_nritems (eb=0x0) at ctree.h:1416
#1  0x0000000000420eb8 in btrfs_read_chunk_tree (root=0x13e5350) at volumes.c:1408
#2  0x000000000040a65f in open_ctree_fd (fp=3, path=0x7fff769b8795 "/dev/etherd/e14.0", sb_bytenr=65536, writes=0) at disk-io.c:730
#3  0x000000000040a094 in open_ctree (filename=0x7fff769b8795 "/dev/etherd/e14.0", sb_bytenr=0, writes=0) at disk-io.c:587
#4  0x000000000042597d in main (ac=1, av=0x7fff769b7f58) at debug-tree.c:144
(gdb) list
1411    /* struct btrfs_header */
1412    BTRFS_SETGET_HEADER_FUNCS(header_bytenr, struct btrfs_header, bytenr, 64);
1413    BTRFS_SETGET_HEADER_FUNCS(header_generation, struct btrfs_header,
1414                              generation, 64);
1415    BTRFS_SETGET_HEADER_FUNCS(header_owner, struct btrfs_header, owner, 64);
1416    BTRFS_SETGET_HEADER_FUNCS(header_nritems, struct btrfs_header, nritems, 32);
1417    BTRFS_SETGET_HEADER_FUNCS(header_flags, struct btrfs_header, flags, 64);
1418    BTRFS_SETGET_HEADER_FUNCS(header_level, struct btrfs_header, level, 8);
1419
1420    static inline int btrfs_header_flag(struct extent_buffer *eb, u64 flag)
(gdb) up
#1  0x0000000000420eb8 in btrfs_read_chunk_tree (root=0x13e5350) at volumes.c:1408
1408                    if (slot >= btrfs_header_nritems(leaf)) {
(gdb) list
1403    again:
1404            ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
1405            while(1) {
1406                    leaf = path->nodes[0];
1407                    slot = path->slots[0];
1408                    if (slot >= btrfs_header_nritems(leaf)) {
1409                            ret = btrfs_next_leaf(root, path);
1410                            if (ret == 0)
1411                                    continue;
1412                            if (ret < 0)
(gdb) print slot
$1 = 0
(gdb) print leaf
$2 = (struct extent_buffer *) 0x0
(gdb) print btrfs_header_nritems
$3 = {u32 (struct extent_buffer *)} 0x41d916 <btrfs_header_nritems>
(gdb) set print pretty
(gdb) print *path
$5 = {
  nodes = {0x0, 0x13f0040, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0},
  slots = {0, 11, 0, 0, 0, 0, 0, 0},
  locks = {0, 0, 0, 0, 0, 0, 0, 0},
  reada = 0,
  lowest_level = 0,
  search_for_split = 0,
  keep_locks = 0,
  skip_locking = 0,
  leave_spinning = 0
}
