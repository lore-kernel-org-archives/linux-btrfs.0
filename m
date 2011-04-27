From: Brian Parma <freecode@cox.net>
Subject: btrfs-convert crashes
Date: Tue, 26 Apr 2011 22:20:22 -0700
Message-ID: <4DB7A796.90800@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have a 1.5 TB (1,475,720,773,632) partition that I wanted to convert 
from ext4 to btrfs.  It is currently used as / for ubuntu 10.10.

I booted into 11.04 beta2 and tried a 'btrfs-convert /dev/sdc1', but 
after about 20 minutes it segfaulted.

I performed a:

sck.ext4 -cDfty -C 0 /dev/sdc1


After everything was clean, I downloaded the debugging symbols for btrfs-convert and tried again.  Below is the 'bt full' output.  I don't have enough free space to copy all the data off, create a fresh btrfs partition, and copy everything back on (I have backups of important stuff).  Is there something else I can try to get this to work?

Brian

at: http://pastebin.com/NEwJNzuP


#0  0x00007ffff7444d05 in raise () from /lib/x86_64-linux-gnu/libc.so.6
No symbol table info available.
#1  0x00007ffff7448ab6 in abort () from /lib/x86_64-linux-gnu/libc.so.6
No symbol table info available.
#2  0x000000000040502c in btrfs_extend_item (trans=<value optimized out>, root=0x633920, path=<value optimized out>, data_size=27) at ctree.c:2525
         slot =<value optimized out>
         slot_orig =<value optimized out>
         leaf = 0x1955250
         nritems = 1
         data_end =<value optimized out>
         old_data =<value optimized out>
         i =<value optimized out>
         __PRETTY_FUNCTION__ = "btrfs_extend_item"
#3  0x000000000040e32d in btrfs_insert_inode_ref (trans=0xc9ef10, root=0x633920, name=0xcfa314 "gtfntf.f.svn-base", name_len=17,
     inode_objectid=<value optimized out>, ref_objectid=<value optimized out>, index=150) at inode-item.c:135
         old_size = 3945
         path = 0x1639aa0
         key = {objectid = 37361107, type = 12 '\f', offset = 37359706}
         ref =<value optimized out>
         ptr =<value optimized out>
         ret =<value optimized out>
         ins_len = 27
         __PRETTY_FUNCTION__ = "btrfs_insert_inode_ref"
#4  0x0000000000413fff in dir_iterate_proc (dir=<value optimized out>, entry=<value optimized out>, old=0xcfa30c, offset=<value optimized out>,
     blocksize=<value optimized out>, buf=<value optimized out>, priv_data=0x7fffffffe370) at convert.c:289
         ret =<value optimized out>
         file_type =<value optimized out>
         objectid = 37361107
         dotdot = ".."
         location = {objectid = 37361107, type = 1 '\001', offset = 0}
         dirent = 0xcfa30c
         idata = 0x7fffffffe370
         __PRETTY_FUNCTION__ = "dir_iterate_proc"
#5  0x00007ffff7bbdc13 in ext2fs_process_dir_block () from /lib/x86_64-linux-gnu/libext2fs.so.2
No symbol table info available.
#6  0x00007ffff7bbac02 in ext2fs_block_iterate2 () from /lib/x86_64-linux-gnu/libext2fs.so.2
No symbol table info available.
#7  0x00007ffff7bbdfb8 in ext2fs_dir_iterate2 () from /lib/x86_64-linux-gnu/libext2fs.so.2
No symbol table info available.
#8  0x000000000041689d in create_dir_entries (devname=0x7fffffffe897 "/dev/sdc1", datacsum=1, packing=1, noxattr=0) at convert.c:322
         err =<value optimized out>
         data = {trans = 0xc9ef10, root = 0x633920, inode = 0x7fffffffe1c0, objectid = 37359706, index_cnt = 150, parent = 37359705, errcode = 0}
         ret =<value optimized out>
#9  copy_single_inode (devname=0x7fffffffe897 "/dev/sdc1", datacsum=1, packing=1, noxattr=0) at convert.c:1072
         ret =<value optimized out>
         btrfs_inode = {generation = 1, transid = 140737354044640, size = 4994, nbytes = 0, block_group = 0, nlink = 1, uid = 1000, gid = 1000, mode = 16877,
           rdev = 0, flags = 0, sequence = 140737351933932, reserved = {0, 140737354040256, 140733193388033, 0}, atime = {sec = 1303466526, nsec = 0}, ctime = {
             sec = 1296464377, nsec = 0}, mtime = {sec = 1296464377, nsec = 0}, otime = {sec = 0, nsec = 0}}
#10 copy_inodes (devname=0x7fffffffe897 "/dev/sdc1", datacsum=1, packing=1, noxattr=0) at convert.c:1154
         ret =<value optimized out>
         err =<value optimized out>
         ext2_scan = 0xce2300
         ext2_ino = 37359452
         objectid = 37359706
         ext2_inode = {i_mode = 16877, i_uid = 1000, i_size = 16384, i_atime = 1303466526, i_ctime = 1296464377, i_mtime = 1296464377, i_dtime = 0, i_gid = 1000,
           i_links_count = 2, i_blocks = 32, i_flags = 528384, osd1 = {linux1 = {l_i_version = 1981}, hurd1 = {h_i_translator = 1981}}, i_block = {193290, 4, 0,
             0, 1, 149430439, 1, 3, 149430464, 0, 0, 0, 0, 0, 0}, i_generation = 2854948622, i_file_acl = 0, i_dir_acl = 0, i_faddr = 0, osd2 = {linux2 = {
               l_i_blocks_hi = 0, l_i_file_acl_high = 0, l_i_uid_high = 0, l_i_gid_high = 0, l_i_reserved2 = 0}, hurd2 = {h_i_frag = 0 '\000',
               h_i_fsize = 0 '\000', h_i_mode_high = 0, h_i_uid_high = 0, h_i_gid_high = 0, h_i_author = 0}}}
         trans = 0xc9ef10
#11 do_convert (devname=0x7fffffffe897 "/dev/sdc1", datacsum=1, packing=1, noxattr=0) at convert.c:2411
         i =<value optimized out>
         fd = 6
         ret =<value optimized out>
         blocksize = 4096
         blocks = {9258, 9259, 9260, 9261, 9284, 9285, 9286}
         total_bytes =<value optimized out>
         super_bytenr = 37920768
         ext2_fs = 0x622010
         root = 0x633920
         ext2_root =<value optimized out>
#12 0x0000000000418333 in main (argc=<value optimized out>, argv=<value optimized out>) at convert.c:2867
         ret =<value optimized out>
         packing = 1
         noxattr = 0
         datacsum = 1
         rollback = 0
         file = 0x7fffffffe897 "/dev/sdc1"



