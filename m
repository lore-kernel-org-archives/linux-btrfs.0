Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58105 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbaBRVU1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 16:20:27 -0500
Received: from [192.168.178.21] ([85.177.16.242]) by mail.gmx.com (mrgmx003)
 with ESMTPSA (Nemesis) id 0LaoHI-1WzxLs3Xwm-00kOir for
 <linux-btrfs@vger.kernel.org>; Tue, 18 Feb 2014 22:20:25 +0100
Message-ID: <5303CE96.4070302@gmx.de>
Date: Tue, 18 Feb 2014 22:20:22 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: fuzz testing a BTFRS file system hangs
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

I do fuzzy testing a 32 bit user mode linux guest (v3.14-rc3-43-g805937c) with trinity and use a BTRFS file created on a ram disk within the UML and loop mounted onto a mount point within the UML for victim files for trinity (all inside the UML guest).

Since few hours the test script hangs. When I try at the host try to get a back trace of the hanging "linux" process I do get back traces like the following :



$ date; sudo gdb /home/tfoerste/devel/linux/linux 25083 -n -batch -ex 'bt'
Tue Feb 18 22:12:19 CET 2014                                                                                                                                          
                                                                                                                                                                      
warning: Could not load shared library symbols for linux-gate.so.1.                                                                                                   
Do you need "set solib-search-path" or "set sysroot"?                                                                                                                 
check_valid_pointer (object=<optimized out>, page=<optimized out>, s=<optimized out>) at mm/slub.c:250                                                                
250             if (object < base || object >= base + page->objects * s->size ||                                                                                      
#0  check_valid_pointer (object=<optimized out>, page=<optimized out>, s=<optimized out>) at mm/slub.c:250
#1  on_freelist (s=0x49c49e40, page=0xbc69a00, search=0x48e98800) at mm/slub.c:891
#2  0x084dfa85 in free_debug_processing (s=0x49c49e40, page=0xbc69a00, object=0x48e98800, addr=59, flags=0x36e77ddc) at mm/slub.c:1123
#3  0x084dfd47 in __slab_free (s=0x49c49e40, page=0xbc69a00, x=0x48e98800, addr=59) at mm/slub.c:2549
#4  0x080feff1 in slab_free (addr=<optimized out>, x=<optimized out>, page=<optimized out>, s=<optimized out>) at mm/slub.c:2695
#5  kfree (x=0x48e98800) at mm/slub.c:3397
#6  0x0827aab8 in btrfs_delayed_refs_qgroup_accounting (trans=0x499cb2d0, fs_info=0x49c750f0) at fs/btrfs/extent-tree.c:2603
#7  0x08294c4f in __btrfs_end_transaction (trans=0x499cb2d0, root=0x48d525b0, throttle=0) at fs/btrfs/transaction.c:694
#8  0x08294f30 in btrfs_end_transaction (trans=0x499cb2d0, root=0x48d525b0) at fs/btrfs/transaction.c:780
#9  0x0829e850 in btrfs_finish_ordered_io (ordered_extent=0x40714840) at fs/btrfs/inode.c:2696
#10 0x0829e97e in finish_ordered_fn (work=0x407148bc) at fs/btrfs/inode.c:2753
#11 0x082c8984 in worker_loop (arg=0x40c77540) at fs/btrfs/async-thread.c:326
#12 0x08096266 in kthread (_create=0x36e58960) at kernel/kthread.c:207
#13 0x0805f7eb in new_thread_handler () at arch/um/kernel/process.c:129
#14 0x00000000 in ?? ()



$ date; sudo gdb /home/tfoerste/devel/linux/linux 25083 -n -batch -ex 'bt'
Tue Feb 18 22:12:35 CET 2014

warning: Could not load shared library symbols for linux-gate.so.1.
Do you need "set solib-search-path" or "set sysroot"?
check_valid_pointer (object=<optimized out>, page=<optimized out>, s=<optimized out>) at mm/slub.c:250
250             if (object < base || object >= base + page->objects * s->size ||
#0  check_valid_pointer (object=<optimized out>, page=<optimized out>, s=<optimized out>) at mm/slub.c:250
#1  on_freelist (s=0x49c49180, page=0xbb653c0, search=0x40c66af0) at mm/slub.c:891
#2  0x084dfa85 in free_debug_processing (s=0x49c49180, page=0xbb653c0, object=0x40c66af0, addr=29, flags=0x36c47a14) at mm/slub.c:1123
#3  0x084dfd47 in __slab_free (s=0x49c49180, page=0xbb653c0, x=0x40c66af0, addr=29) at mm/slub.c:2549
#4  0x080feff1 in slab_free (addr=<optimized out>, x=<optimized out>, page=<optimized out>, s=<optimized out>) at mm/slub.c:2695
#5  kfree (x=0x40c66af0) at mm/slub.c:3397
#6  0x082a8ccb in __btrfs_buffered_write (file=0x1d, i=0x36c47bb0, pos=12215744) at fs/btrfs/file.c:1624
#7  0x082a9105 in btrfs_file_aio_write (iocb=0x36c47bf4, iov=0x36c47bec, nr_segs=1, pos=12215743) at fs/btrfs/file.c:1773
#8  0x081051ce in do_sync_write (filp=0x36eee6c0, buf=0x1d <Address 0x1d out of bounds>, len=0, ppos=0x36c47c84) at fs/read_write.c:421
#9  0x08105271 in __kernel_write (file=0x36eee6c0, buf=0x3ca255be "", count=0, pos=0x36c47c84) at fs/read_write.c:445
#10 0x08129afd in write_pipe_buf (pipe=0x40d8c240, buf=0x49fece70, sd=0x36c47cf4) at fs/splice.c:1071
#11 0x0812ad70 in splice_from_pipe_feed (pipe=0x40d8c240, sd=0x36c47cf4, actor=0x8129aa0 <write_pipe_buf>) at fs/splice.c:833
#12 0x0812af1d in __splice_from_pipe (pipe=0x40d8c240, sd=0x36c47cf4, actor=0x8129aa0 <write_pipe_buf>) at fs/splice.c:954
#13 0x0812afa5 in splice_from_pipe (pipe=0x40d8c240, out=0x1d, ppos=0x1d, len=29, flags=29, actor=0x1d) at fs/splice.c:989
#14 0x0812affb in default_file_splice_write (pipe=0x1d, out=0x1d, ppos=0x36c47e60, len=29, flags=29) at fs/splice.c:1083
#15 0x081293c5 in do_splice_from (flags=<optimized out>, len=<optimized out>, ppos=<optimized out>, out=<optimized out>, pipe=<optimized out>) at fs/splice.c:1125
#16 direct_splice_actor (pipe=0x0, sd=0x1d) at fs/splice.c:1281
#17 0x0812b2e1 in splice_direct_to_actor (in=0x36eee6c0, sd=0x36c47dc8, actor=0x8129380 <direct_splice_actor>) at fs/splice.c:1234
#18 0x0812b475 in do_splice_direct (in=0x1d, ppos=0x36c47e58, out=0x0, opos=0x36c47e60, len=268435456, flags=29) at fs/splice.c:1324
#19 0x08104df9 in do_sendfile (out_fd=921626304, in_fd=0, ppos=0x36c47e90, count=29, max=8796093022207) at fs/read_write.c:1152
#20 0x0810611a in SYSC_sendfile64 (count=<optimized out>, offset=<optimized out>, in_fd=<optimized out>, out_fd=<optimized out>) at fs/read_write.c:1207
#21 SyS_sendfile64 (out_fd=215, in_fd=215, offset=135081984, count=268435456) at fs/read_write.c:1199
#22 0x08062ab4 in handle_syscall (r=0x49c970c8) at arch/um/kernel/skas/syscall.c:35
#23 0x08074905 in handle_trap (local_using_sysemu=<optimized out>, regs=<optimized out>, pid=<optimized out>) at arch/um/os-Linux/skas/process.c:198
#24 userspace (regs=0x49c970c8) at arch/um/os-Linux/skas/process.c:431
#25 0x0805f770 in fork_handler () at arch/um/kernel/process.c:149
#26 0x00000000 in ?? ()


$ date; sudo gdb /home/tfoerste/devel/linux/linux 25083 -n -batch -ex 'bt'
Tue Feb 18 22:15:52 CET 2014

warning: Could not load shared library symbols for linux-gate.so.1.
Do you need "set solib-search-path" or "set sysroot"?
0x080fd18a in init_object (s=0x49f43300, object=0x4085c8d3, val=187 '\273') at mm/slub.c:670
670                     p[s->object_size - 1] = POISON_END;
#0  0x080fd18a in init_object (s=0x49f43300, object=0x4085c8d3, val=187 '\273') at mm/slub.c:670
#1  0x084dfa34 in free_debug_processing (s=0x49f43300, page=0xbb5d280, object=0x4085c880, addr=84, flags=0x36e77b44) at mm/slub.c:1149
#2  0x084dfd47 in __slab_free (s=0x49f43300, page=0xbb5d280, x=0x4085c880, addr=84) at mm/slub.c:2549
#3  0x080fec98 in slab_free (addr=<optimized out>, x=<optimized out>, page=<optimized out>, s=<optimized out>) at mm/slub.c:2695
#4  kmem_cache_free (s=0x49f43300, x=0x4085c880) at mm/slub.c:2704
#5  0x082e3f8f in add_delayed_ref_head (ref=0x4097c080, bytenr=59682816, num_bytes=4096, action=84, is_data=0, trans=<optimized out>, trans=<optimized out>, fs_info=<optimized out>) at fs/btrfs/delayed-ref.c:631
#6  0x082e4891 in btrfs_add_delayed_tree_ref (fs_info=0x49c750f0, trans=0x499cb2d0, bytenr=59682816, num_bytes=4096, parent=0, ref_root=7, level=1082509523, action=2, extent_op=0x0, for_cow=0) at fs/btrfs/delayed-ref.c:804
#7  0x0827e092 in btrfs_free_tree_block (trans=0x499cb2d0, root=0x48d51920, buf=0x407da0d8, parent=4649342998893559892, last_ref=1) at fs/btrfs/extent-tree.c:5962
#8  0x0826aab5 in __btrfs_cow_block (trans=0x499cb2d0, root=0x48d51920, buf=0x407da0d8, parent=0x0, parent_slot=0, cow_ret=0x36e77d94, search_start=0, empty_size=0) at fs/btrfs/ctree.c:1214
#9  0x0826af35 in btrfs_cow_block (trans=0x499cb2d0, root=0x48d51920, buf=0x407da0d8, parent=0x0, parent_slot=84, cow_ret=0x36e77d94) at fs/btrfs/ctree.c:1597
#10 0x0826f166 in btrfs_search_slot (trans=0x499cb2d0, root=0x48d51920, key=0x36e77de2, p=0x499ca1c8, ins_len=0, cow=1) at fs/btrfs/ctree.c:2834
#11 0x08287441 in btrfs_lookup_csum (trans=0x54, root=0x48d51920, path=0x499ca1c8, bytenr=75964416, cow=1082509523) at fs/btrfs/file-item.c:104
#12 0x08288e82 in btrfs_csum_file_blocks (trans=0x499cb2d0, root=0x48d51920, sums=0x40c66c80) at fs/btrfs/file-item.c:725
#13 0x08298705 in add_pending_csums (trans=0x499cb2d0, inode=0x49c2b130, list=0x40714578, file_offset=<optimized out>) at fs/btrfs/inode.c:1734
#14 0x0829e72d in btrfs_finish_ordered_io (ordered_extent=0x40714528) at fs/btrfs/inode.c:2678
#15 0x0829e97e in finish_ordered_fn (work=0x407145a4) at fs/btrfs/inode.c:2753
#16 0x082c8984 in worker_loop (arg=0x40c77540) at fs/btrfs/async-thread.c:326
#17 0x08096266 in kthread (_create=0x36e58960) at kernel/kthread.c:207
#18 0x0805f7eb in new_thread_handler () at arch/um/kernel/process.c:129


Well, this  might be just an expected behaviour of the used fuzzing tool, but from my experiences with fuzz testings in the past (with NFSv4) this might indicate a BTRFS issue instead.

- -- 
MfG/Sincerely
Toralf Förster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlMDzpYACgkQxOrN3gB26U4ZqgD/eAhQoh8YuXdsYCOLduxbHTSS
AssxQ69VlOGqtZuzOtUA/3ko6jYyMCZ7VpOzOafURXLfkRHdYqdVfmDo5oQ7g1mV
=/xSL
-----END PGP SIGNATURE-----
