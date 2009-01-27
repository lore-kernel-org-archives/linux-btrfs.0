From: Paul Mundt <lethal@linux-sh.org>
Subject: BUG on btrfs_update_extent_ref() retval
Date: Tue, 27 Jan 2009 18:53:26 +0900
Message-ID: <20090127095325.GB7407@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-sh@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Trying out btrfs on sh (using the latest btrfs-progs from git) results in
the following oops when doing a simple untar:

------------[ cut here ]------------
kernel BUG at fs/btrfs/ctree.c:1948!
Kernel BUG: 003e [#1]
Modules linked in:

Pid : 4337, Comm:               tar
CPU : 0                 Not tainted  (2.6.29-rc2-00357-g97a2112-dirty #986)

PC is at insert_new_root+0x528/0x57c
PR is at insert_new_root+0x522/0x57c
PC  : 8817f360 SP  : 8c809c7c SR  : 40008000 TEA : 296639e0
R0  : fffffffe R1  : 00000000 R2  : 40008000 R3  : 00000003
R4  : 89c2c660 R5  : 00000068 R6  : 0000000d R7  : 00000000
R8  : 89817004 R9  : 89c29380 R10 : 89c29f20 R11 : 00130b80
R12 : 89817000 R13 : 89c29380 R14 : 8c809c7c
MACH: 000008d3 MACL: 00000048 GBR : 29719450 PR  : 8817f35a

Call trace:
[<8817fe00>] split_node+0x878/0x8f8
[<88181456>] split_leaf+0x92/0xd74
[<8817ff50>] leaf_space_used+0xd0/0x114
[<8818002e>] btrfs_leaf_free_space+0x9a/0xfc
[<88011d0c>] add_preempt_count+0x0/0x74
[<88182afa>] btrfs_search_slot+0x9c2/0xa48
[<88011d0c>] add_preempt_count+0x0/0x74
[<88011c90>] sub_preempt_count+0x0/0x7c
[<88186e54>] btrfs_find_block_group+0x13c/0x1f0
[<88182be6>] btrfs_insert_empty_items+0x66/0x698
[<881a8e8e>] btrfs_new_inode+0xae/0x398
[<881a8f84>] btrfs_new_inode+0x1a4/0x398
[<88310000>] gss_mech_get_by_name+0x1c/0xdc
[<881a956e>] btrfs_create+0xae/0x1d8
[<881ac94e>] btrfs_permission+0x26/0x38
[<88076b2e>] vfs_create+0x52/0xb4
[<88076ec2>] do_filp_open+0x182/0x61c
[<88034d84>] lock_release+0x11a/0x17a
[<8808061c>] alloc_fd+0xd0/0x104
[<8831bdc2>] _spin_unlock+0x1a/0x4c
[<8831bdc8>] _spin_unlock+0x20/0x4c
[<8806da1a>] do_sys_open+0x42/0xe8
[<8806dad6>] sys_open+0x16/0x24
[<8806dac0>] sys_open+0x0/0x24
[<88007236>] syscall_call+0xc/0x10

3 locks held by tar/4337:
 #0:  (&sb->s_type->i_mutex_key#9){....}, at: [<88076e50>] do_filp_open+0x110/0x61c
 #1:  (&eb->mutex){....}, at: [<881cc806>] btrfs_tree_lock+0x1a/0xbc
 #2:  (&eb->mutex){....}, at: [<881cc806>] btrfs_tree_lock+0x1a/0xbc

Code:
  8817f35a:  tst       r0, r0
  8817f35c:  bt.s      8817f362
  8817f35e:  add       #40, r15
->8817f360:  trapa     #62
  8817f362:  mov.l     8817f3ac <insert_new_root+0x574/0x57c>, r1  ! 881c1188 <free_extent_buffer+0x0/0x26>
  8817f364:  jsr       @r1
  8817f366:  mov       r9, r4
  8817f368:  mov.l     8817f3b0 <insert_new_root+0x578/0x57c>, r1  ! 88179b30 <add_root_to_dirty_list+0x0/0x3a>
  8817f36a:  jsr       @r1

Process: tar (pid: 4337, stack limit = 8c808001)
Stack: (0x8c809c7c to 0x8c80a000)
9c60:                                                                00000100
9c80: 00000000 00000001 00000000 8817fe00 89c33400 89c2c6c8 00000001 88181456
9ca0: 8c809cbc 89c2c6c8 887b2d8c 8c809df0 00000001 00000000 89c29380 00001000
9cc0: 8985b000 00000000 8817ff50 8c809ce0 89c33400 89817000 00000019 00000065
9ce0: 0000002e 8818002e 00000000 88011d0c 00000000 89c29380 88182afa 8c809d20
9d00: 88011d0c 887b2d8c 88011c90 00000001 00000000 89c29380 000000e2 00000000
9d20: 00000000 00000000 00000000 00000000 00000000 89c29380 0000002e 89c33400
9d40: 89817000 8c809df0 89c2c6c8 00000001 00000001 00000000 8c809d74 00000000
9d60: 89c2c708 00000000 88186e54 88182be6 8c809d94 00000000 0000010a 8c809df0
9d80: 89817000 000000e2 00000000 000000e2 00000001 8c809d9c 00000000 89817000
9da0: 00000000 00000000 89c33400 89817000 89c2c6c8 00000002 000000b0 8e42122c
9dc0: 00800000 881a8e8e 881a8f84 8c809df0 00000000 0000010a 89c3728c 89817000
9de0: 89c37244 89c37284 8c809e14 00000002 0000010a 00000000 00000001 00000000
9e00: 00010a00 00000000 01010c00 00000000 88310000 000000a0 00000010 89c33400
9e20: 89817000 89c2822c 89c30400 89c2c6c8 00000000 00000000 881a956e 8c809e7c
9e40: 89c3038c 89c2822c 00000000 89817000 89c33400 ffffffe4 00000006 00000101
9e60: 00000000 0000010a 00000000 00400000 00000000 000081c0 8c809e84 0000010a
9e80: 00000000 0000000a 00000000 000081c0 00000000 00000000 89c28224 881ac94e
9ea0: 8c809eb4 88076b2e 8c809ec4 000080c2 8c809ee0 000001c0 89c3038c 89c30908
9ec0: 89c2822c 88076ec2 8c809ee0 fffff000 000001c0 ffffff9c 89c30908 00000000
9ee0: 8f80fca0 89c30908 c265fd91 00000006 8c800006 00000700 00000000 00000000
9f00: 000001c0 00000000 88034d84 8c809f28 8ee249c0 00000001 00000000 8808061c
9f20: 8f819094 000080c2 000001c0 8ee8fa80 8f80fca0 89c3038c 8831bdc2 8831bdc8
9f40: 000080c1 000001c0 00000022 00000000 00000080 8f819084 8806da1a 8c809f78
9f60: 8c800000 fffff000 000001c0 ffffff9c 000080c1 00000004 8806dad6 8c809f98
9f80: 00000030 296ec7c4 00000000 00000071 0000007f 8806dac0 88007236 7bce14cc
9fa0: fffffbb0 00008000 7bce14f0 00000005 004566d0 000080c1 000001c0 000001ed
9fc0: 000001c0 000000c1 004566d0 7bce1538 296ec7c4 00000030 7bce14cc 7bce14cc
9fe0: 29663a4c 0040eea8 00000001 29719450 2710763a 00000000 0000004c 00000160
---[ end trace 1d089ae5b8ae7652 ]---
Segmentation fault

Anyone else run in to something similar? Ideas?
