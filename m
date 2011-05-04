From: Geoff Ritter <geoff.ritter@gmail.com>
Subject: btrfs seed with luks encrypted devices
Date: Tue, 03 May 2011 18:32:14 -0700
Message-ID: <4DC0AC9E.1030607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Not sure where to report bugs or even find a coherent list of them.  
Sorry if this is already well known.

When attempting to use an unlocked encrypted device as either a seed 
device or the writeable device, a kernel bug will be displayed at 
fs/btrfs/volumes.c:2402 after attempting to add the writeable device to 
the mounted read-only seed.

STR:
1.  cryptsetup luksFormat /dev/sdx1
2.  cryptsetup luksOpen /dev/sdx1 luksSeed
3.  mkfs.btrfs /dev/mapper/luksSeed
4.  mount and add files if you want, then unmount
5.  btrfstune -S 1 /dev/mapper/luksSeed
6.  mount /dev/mapper/luksSeed /mnt/luksSeed
7.  btrfs device add /dev/sdx2 /mnt/luksSeed
8.  Observe kernel BUG.

I would hope to expect to see an error message if this is never intended 
to be possible.  But normal btrfs file systems appear to function 
normally under both encrypted and lvm partitions.

This attached kernel message was from two LVM logical volumes on a luks 
encrypted partition.  However, I also tested this with two regular 
partitions between endrypted-seed/unencrypted-rw,  
endrypted-rw/unencrypted-seed, and both encrypted.

------------[ cut here ]------------
  kernel BUG at fs/btrfs/volumes.c:2402!
  invalid opcode: 0000 [#1] SMP
  last sysfs file: 
/sys/devices/pci0000:00/0000:00:05.0/host0/target0:0:0/0:0:0:0/block/sda/dev
  CPU 0
  Modules linked in: usbhid parport_pc hid firewire_ohci i2c_nforce2 
firewire_core i2c_core forcedeth parport
  Pid: 1845, comm: btrfs Not tainted 2.6.37.6 #3 System manufacturer 
System Product Name/M2N-SLI DELUXE
  RIP: 0010:[<ffffffff8149cdba>]  [<ffffffff8149cdba>] 
__finish_chunk_alloc+0x21a/0x220
  RSP: 0018:ffff880175533668  EFLAGS: 00010286
  RAX: 00000000ffffffe4 RBX: ffff880176004500 RCX: 0000000000000040
  RDX: 0000000000000000 RSI: ffffea000523aff0 RDI: ffff88017788df00
  RBP: ffff8801755336e8 R08: 000000000000bda5 R09: 0000000000000000
  R10: 0000000000000000 R11: 00000000ffffffe4 R12: ffff880177e8e000
  R13: ffff880176956b00 R14: ffff8801773cb000 R15: 0000000000000070
  FS:  00007fe05f784760(0000) GS:ffff8800bfc00000(0000) 
knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
  CR2: 0000000000683a10 CR3: 000000017549c000 CR4: 00000000000006f0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
  Process btrfs (pid: 1845, threadinfo ffff880175532000, task 
ffff88017547ed00)
  Stack:
   0000000010000000 ffff880100000000 0000000008000000 000000030a400000
   ffff8801773cc000 0000000008000000 ffff8801770ef810 ffff8801770ef810
   0000000019100000 0000000000000000 ffff8800bfd119ff ffff8801773cb000
  Call Trace:
   [<ffffffff8149f18e>] btrfs_alloc_chunk+0x8e/0xa0
   [<ffffffff814647ee>] do_chunk_alloc+0x14e/0x2a0
   [<ffffffff814685f2>] btrfs_reserve_extent+0xd2/0x180
   [<ffffffff81468bb1>] btrfs_alloc_free_block+0xc1/0x330
   [<ffffffff8145696d>] __btrfs_cow_block+0x14d/0x610
   [<ffffffff81456f3f>] btrfs_cow_block+0x10f/0x200
   [<ffffffff8145bfaa>] btrfs_search_slot+0x50a/0x880
   [<ffffffff81455f5a>] ? btrfs_free_path+0x2a/0x40
   [<ffffffff8145d38e>] btrfs_insert_empty_items+0x7e/0xe0
   [<ffffffff8146efa7>] btrfs_insert_empty_inode+0x37/0x40
   [<ffffffff814b554f>] create_reloc_inode.clone.41+0x9f/0x230
   [<ffffffff81113257>] ? kmem_cache_alloc+0xb7/0x110
   [<ffffffff814bb91b>] btrfs_relocate_block_group+0x14b/0x2e0
   [<ffffffff8149bf03>] btrfs_relocate_chunk.clone.41+0x83/0x5b0
   [<ffffffff8149a180>] ? map_extent_buffer+0xb0/0xc0
   [<ffffffff814890f5>] ? btrfs_chunk_type+0xe5/0xf0
   [<ffffffff814a0b6b>] btrfs_init_new_device+0xaeb/0xd00
   [<ffffffff814a6476>] ? btrfs_ioctl+0x496/0x9d0
   [<ffffffff814a6498>] btrfs_ioctl+0x4b8/0x9d0
   [<ffffffff8102a0a4>] ? do_page_fault+0x1a4/0x3d0
   [<ffffffff8113002d>] do_vfs_ioctl+0x9d/0x580
   [<ffffffff811339fe>] ? dput+0x7e/0x160
   [<ffffffff811211a2>] ? fput+0x192/0x250
   [<ffffffff81130591>] sys_ioctl+0x81/0xa0
   [<ffffffff81002a2b>] system_call_fastpath+0x16/0x1b
  Code: ef e8 eb 5e c7 ff 48 83 c4 58 31 c0 5b 41 5c 41 5d 41 5e 41 5f 
c9 c3 48 83 c4 58 b8 f4 ff ff ff 5b 41 5c 41 5d 41 5e 41 5f c9 c3 <0f> 
0b 0f 0b 0f 0b 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83
  RIP  [<ffffffff8149cdba>] __finish_chunk_alloc+0x21a/0x220
   RSP <ffff880175533668>
  ---[ end trace 8fa94cbaf8bdef31 ]---

