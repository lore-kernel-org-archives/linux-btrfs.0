Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38319 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751199AbaHWRhf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Aug 2014 13:37:35 -0400
Date: Sat, 23 Aug 2014 13:37:33 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: backtrace for segfault in btrfs-convert
Message-ID: <20140823173733.GB9149@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This came from trying to convert a ~1.8T ext4 filesystem with btrfs-progs
master (24cf4d8c3ee924b474f68514e0167cc2e602a48d) on Debian.  e2fsck -f
reports no errors on the source filesystem.

I've done several ext4 conversions before this one, so I'm pretty sure
the tool works most of the time.  ;)

Options are:

	btrfs-convert -n -d /dev/mapper/testsnap

It segfaults without the -n and -d options too, but takes much longer to
run get to this point.

(gdb) bt full
#0  __memcpy_sse2_unaligned () at ../sysdeps/x86_64/multiarch/memcpy-sse2-unaligned.S:156
No locals.
#1  0x0000000000415c86 in memcpy (__len=<optimized out>, __src=<optimized out>, __dest=<optimized out>) at /usr/include/x86_64-linux-gnu/bits/string3.h:51
No locals.
#2  copy_extent_buffer (dst=dst@entry=0x2235210, src=src@entry=0x22330f0, dst_offset=<optimized out>, src_offset=<optimized out>, len=len@entry=18446744073709551563) at extent_io.c:910
No locals.
#3  0x00000000004056c4 in copy_for_split (nritems=0, mid=1, slot=0, right=0x2235210, l=0x22330f0, path=0x674ca0, root=0x63dc00, trans=0x11105c0) at ctree.c:1912
        data_copy_size = -53
        i = <optimized out>
        ret = 0
        wret = <optimized out>
        rt_data_off = <optimized out>
        disk_key = {objectid = 6544384, type = 160 '\240', offset = 26444}
#4  split_leaf (trans=trans@entry=0x11105c0, root=root@entry=0x63dc00, ins_key=ins_key@entry=0x7fffffffde40, path=path@entry=0x674ca0, data_size=data_size@entry=52, extend=extend@entry=1) at ctree.c:2096
        disk_key = {objectid = 0, type = 0 '\000', offset = 0}
        l = 0x22330f0
        nritems = 0
        mid = 1
        slot = 0
        right = 0x2235210
        ret = <optimized out>
        wret = <optimized out>
        split = <optimized out>
        num_doubles = 0
        __PRETTY_FUNCTION__ = "split_leaf"
#5  0x0000000000407283 in btrfs_search_slot (trans=0x11105c0, root=root@entry=0x63dc00, key=key@entry=0x7fffffffde40, p=p@entry=0x674ca0, ins_len=ins_len@entry=52, cow=cow@entry=1) at ctree.c:1120
        sret = <optimized out>
        b = 0x22330f0
        slot = 0
        ret = <optimized out>
        level = <optimized out>
        should_reada = 0
        lowest_level = 0 '\000'
        __PRETTY_FUNCTION__ = "btrfs_search_slot"
#6  0x0000000000407416 in btrfs_insert_empty_items (trans=trans@entry=0x11105c0, root=root@entry=0x63dc00, path=path@entry=0x674ca0, cpu_key=cpu_key@entry=0x7fffffffde40, data_size=data_size@entry=0x7fffffffde3c, nr=nr@entry=1) at ctree.c:2412
        leaf = <optimized out>
        ret = 0
        slot = <optimized out>
        i = <optimized out>
        nritems = 32767
        total_size = 52
        total_data = <optimized out>
        data_end = <optimized out>
        disk_key = {objectid = 144, type = 240 '\360', offset = 18158513697557980219}
        __PRETTY_FUNCTION__ = "btrfs_insert_empty_items"
#7  0x0000000000414256 in btrfs_insert_empty_item (data_size=27, key=0x7fffffffde40, path=0x674ca0, root=0x63dc00, trans=0x11105c0) at ctree.h:2305
No locals.
#8  btrfs_insert_inode_ref (trans=0x11105c0, root=0x63dc00, name=name@entry=0x16604fc "", name_len=name_len@entry=17, inode_objectid=inode_objectid@entry=96847738, ref_objectid=<optimized out>, index=1915) at inode-item.c:72
        path = 0x674ca0
        key = {objectid = 96847738, type = 12 '\f', offset = 38723926}
        ref = <optimized out>
        ptr = <optimized out>
        ret = <optimized out>
        ins_len = 27
        __PRETTY_FUNCTION__ = "btrfs_insert_inode_ref"
#9  0x0000000000421d68 in dir_iterate_proc (dir=<optimized out>, entry=<optimized out>, dirent=0x16604f4, offset=<optimized out>, blocksize=<optimized out>, buf=<optimized out>, priv_data=0x7fffffffe3a0) at btrfs-convert.c:290
        ret = <optimized out>
        file_type = 0
        objectid = 96847738
        inode_size = <optimized out>
        dotdot = ".."
        location = {objectid = 96847738, type = 1 '\001', offset = 0}
        idata = 0x7fffffffe3a0
        name_len = 17
        __PRETTY_FUNCTION__ = "dir_iterate_proc"
#10 0x00007ffff704b6f3 in ext2fs_process_dir_block () from /lib/x86_64-linux-gnu/libext2fs.so.2
No symbol table info available.
#11 0x00007ffff7047cfc in ?? () from /lib/x86_64-linux-gnu/libext2fs.so.2
No symbol table info available.
#12 0x00007ffff704ba1b in ext2fs_dir_iterate2 () from /lib/x86_64-linux-gnu/libext2fs.so.2
No symbol table info available.
#13 0x00000000004248ae in create_dir_entries (ext2_ino=38723672, ext2_fs=0x632010, btrfs_inode=0x7fffffffe430, objectid=38723926, root=0x63dc00, trans=0x11105c0) at btrfs-convert.c:323
        ret = <optimized out>
        err = <optimized out>
        data = {trans = 0x11105c0, root = 0x63dc00, inode = 0x7fffffffe430, objectid = 38723926, index_cnt = 1915, parent = 38723925, errcode = 0}
#14 copy_single_inode (noxattr=0, packing=0, datacsum=0, ext2_inode=0x7fffffffe320, ext2_ino=38723672, ext2_fs=0x632010, objectid=38723926, root=0x63dc00, trans=0x11105c0) at btrfs-convert.c:985
        ret = <optimized out>
        btrfs_inode = {generation = 1, transid = 18446744073709551492, size = 53920, nbytes = 0, block_group = 0, nlink = 1, uid = 0, gid = 0, mode = 16877, rdev = 0, flags = 0, sequence = 0, reserved = {0, 0, 0, 0}, atime = {sec = 1408667056, nsec = 0}, ctime = {sec = 1408667056, nsec = 0}, mtime = {sec = 1408667056, nsec = 0}, otime = {sec = 0, nsec = 0}}
#15 copy_inodes (noxattr=0, packing=0, datacsum=0, ext2_fs=0x632010, root=0x63dc00) at btrfs-convert.c:1067
        ret = <optimized out>
        err = <optimized out>
        ext2_scan = 0x63e220
        ext2_ino = 38723672
        objectid = 38723926
        ext2_inode = {i_mode = 16877, i_uid = 0, i_size = 192512, i_atime = 1408667056, i_ctime = 1408667056, i_mtime = 1408667056, i_dtime = 0, i_gid = 0, i_links_count = 2, i_blocks = 376, i_flags = 528384, osd1 = {linux1 = {l_i_version = 4040}, hurd1 = {h_i_translator = 4040}}, i_block = {193290, 4, 0, 0, 16, 157918112, 16, 31, 158255041, 0, 0, 0, 0, 0, 0}, i_generation = 1366646, i_file_acl = 0, i_size_high = 0, i_faddr = 0, osd2 = {linux2 = {l_i_blocks_hi = 0, l_i_file_acl_high = 0, l_i_uid_high = 0, l_i_gid_high = 0, l_i_checksum_lo = 0, l_i_reserved = 0}, hurd2 = {h_i_frag = 0 '\000', h_i_fsize = 0 '\000', h_i_mode_high = 0, h_i_uid_high = 0, h_i_gid_high = 0, h_i_author = 0}}}
        trans = 0x11105c0
#16 do_convert (noxattr=-7352, packing=0, datacsum=0, devname=0x7fffffffe8ab "/dev/mapper/testsnap") at btrfs-convert.c:2278
        ext2_fs = 0x632010
        root = 0x63dc00
        ret = <optimized out>
        fd = <optimized out>
        blocks = {5277888, 5277889, 5277909, 5277956, 5277957, 5277958, 5277959}
        total_bytes = <optimized out>
        super_bytenr = 21618229248
        ext2_root = 0x0
        i = <optimized out>
        blocksize = 4096
#17 main (argc=<optimized out>, argv=<optimized out>) at btrfs-convert.c:2745
        ret = 0
        packing = 0
        noxattr = -7352
        datacsum = 0
        rollback = <optimized out>
        file = 0x7fffffffe8ab "/dev/mapper/testsnap"
(gdb)
