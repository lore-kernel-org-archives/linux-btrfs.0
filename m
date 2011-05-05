From: Geoff Ritter <geoff.ritter@gmail.com>
Subject: Re: btrfs seed with luks encrypted devices
Date: Thu, 05 May 2011 15:13:51 -0700
Message-ID: <1304633636.9253.0.camel@quintos.origo>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/03/2011 06:50 PM, cwillu wrote:
> On Tue, May 3, 2011 at 7:32 PM, Geoff Ritter<geoff.ritter@gmail.com>  wrote:
>> Not sure where to report bugs or even find a coherent list of them.  Sorry
>> if this is already well known.
>>
>> When attempting to use an unlocked encrypted device as either a seed device
>> or the writeable device, a kernel bug will be displayed at
>> fs/btrfs/volumes.c:2402 after attempting to add the writeable device to the
>> mounted read-only seed.
>>
>> STR:
>> 1.  cryptsetup luksFormat /dev/sdx1
>> 2.  cryptsetup luksOpen /dev/sdx1 luksSeed
>> 3.  mkfs.btrfs /dev/mapper/luksSeed
>> 4.  mount and add files if you want, then unmount
>> 5.  btrfstune -S 1 /dev/mapper/luksSeed
>> 6.  mount /dev/mapper/luksSeed /mnt/luksSeed
>> 7.  btrfs device add /dev/sdx2 /mnt/luksSeed
>> 8.  Observe kernel BUG.
>>
>> I would hope to expect to see an error message if this is never intended to
>> be possible.  But normal btrfs file systems appear to function normally
>> under both encrypted and lvm partitions.
>>
>> This attached kernel message was from two LVM logical volumes on a luks
>> encrypted partition.  However, I also tested this with two regular
>> partitions between endrypted-seed/unencrypted-rw,
>>   endrypted-rw/unencrypted-seed, and both encrypted.
>>
>> ------------[ cut here ]------------
>>   kernel BUG at fs/btrfs/volumes.c:2402!
>>   invalid opcode: 0000 [#1] SMP
>>   last sysfs file:
>> /sys/devices/pci0000:00/0000:00:05.0/host0/target0:0:0/0:0:0:0/block/sda/dev
>>   CPU 0
>>   Modules linked in: usbhid parport_pc hid firewire_ohci i2c_nforce2
>> firewire_core i2c_core forcedeth parport
>>   Pid: 1845, comm: btrfs Not tainted 2.6.37.6 #3 System manufacturer System
>> Product Name/M2N-SLI DELUXE
>>   RIP: 0010:[<ffffffff8149cdba>]  [<ffffffff8149cdba>]
>> __finish_chunk_alloc+0x21a/0x220
>>   RSP: 0018:ffff880175533668  EFLAGS: 00010286
>>   RAX: 00000000ffffffe4 RBX: ffff880176004500 RCX: 0000000000000040
>>   RDX: 0000000000000000 RSI: ffffea000523aff0 RDI: ffff88017788df00
>>   RBP: ffff8801755336e8 R08: 000000000000bda5 R09: 0000000000000000
>>   R10: 0000000000000000 R11: 00000000ffffffe4 R12: ffff880177e8e000
>>   R13: ffff880176956b00 R14: ffff8801773cb000 R15: 0000000000000070
>>   FS:  00007fe05f784760(0000) GS:ffff8800bfc00000(0000)
>> knlGS:0000000000000000
>>   CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>   CR2: 0000000000683a10 CR3: 000000017549c000 CR4: 00000000000006f0
>>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>   DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>   Process btrfs (pid: 1845, threadinfo ffff880175532000, task
>> ffff88017547ed00)
>>   Stack:
>>   0000000010000000 ffff880100000000 0000000008000000 000000030a400000
>>   ffff8801773cc000 0000000008000000 ffff8801770ef810 ffff8801770ef810
>>   0000000019100000 0000000000000000 ffff8800bfd119ff ffff8801773cb000
>>   Call Trace:
>>   [<ffffffff8149f18e>] btrfs_alloc_chunk+0x8e/0xa0
>>   [<ffffffff814647ee>] do_chunk_alloc+0x14e/0x2a0
>>   [<ffffffff814685f2>] btrfs_reserve_extent+0xd2/0x180
>>   [<ffffffff81468bb1>] btrfs_alloc_free_block+0xc1/0x330
>>   [<ffffffff8145696d>] __btrfs_cow_block+0x14d/0x610
>>   [<ffffffff81456f3f>] btrfs_cow_block+0x10f/0x200
>>   [<ffffffff8145bfaa>] btrfs_search_slot+0x50a/0x880
>>   [<ffffffff81455f5a>] ? btrfs_free_path+0x2a/0x40
>>   [<ffffffff8145d38e>] btrfs_insert_empty_items+0x7e/0xe0
>>   [<ffffffff8146efa7>] btrfs_insert_empty_inode+0x37/0x40
>>   [<ffffffff814b554f>] create_reloc_inode.clone.41+0x9f/0x230
>>   [<ffffffff81113257>] ? kmem_cache_alloc+0xb7/0x110
>>   [<ffffffff814bb91b>] btrfs_relocate_block_group+0x14b/0x2e0
>>   [<ffffffff8149bf03>] btrfs_relocate_chunk.clone.41+0x83/0x5b0
>>   [<ffffffff8149a180>] ? map_extent_buffer+0xb0/0xc0
>>   [<ffffffff814890f5>] ? btrfs_chunk_type+0xe5/0xf0
>>   [<ffffffff814a0b6b>] btrfs_init_new_device+0xaeb/0xd00
>>   [<ffffffff814a6476>] ? btrfs_ioctl+0x496/0x9d0
>>   [<ffffffff814a6498>] btrfs_ioctl+0x4b8/0x9d0
>>   [<ffffffff8102a0a4>] ? do_page_fault+0x1a4/0x3d0
>>   [<ffffffff8113002d>] do_vfs_ioctl+0x9d/0x580
>>   [<ffffffff811339fe>] ? dput+0x7e/0x160
>>   [<ffffffff811211a2>] ? fput+0x192/0x250
>>   [<ffffffff81130591>] sys_ioctl+0x81/0xa0
>>   [<ffffffff81002a2b>] system_call_fastpath+0x16/0x1b
>>   Code: ef e8 eb 5e c7 ff 48 83 c4 58 31 c0 5b 41 5c 41 5d 41 5e 41 5f c9 c3
>> 48 83 c4 58 b8 f4 ff ff ff 5b 41 5c 41 5d 41 5e 41 5f c9 c3<0f>  0b 0f 0b 0f
>> 0b 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83
>>   RIP  [<ffffffff8149cdba>] __finish_chunk_alloc+0x21a/0x220
>>   RSP<ffff880175533668>
>>   ---[ end trace 8fa94cbaf8bdef31 ]---
> Can you try again using the latest 2.6.39rc?  This is a enospc-related
> error (RAX: 00000000ffffffe4), and a bunch of those have been fixed
> since 2.6.37.
>


2.6.39-rc5 - unpatched apparently just before they took down the 'full 
source' link
and a get of the btrfs-progs source from today 20110503.

Still produces an issue and fails... However, the issue appears to be 
somewhere else.  I might have to re run the tests on the encrypted lvms 
and other combination.

Here are the results for an unencrypted normal Seed partition with 
encrypted rewritable partition.

------------[ cut here ]------------
  kernel BUG at fs/btrfs/volumes.c:1657!
  invalid opcode: 0000 [#1] SMP
  last sysfs file: /sys/devices/virtual/block/dm-6/size
  CPU 1
  Modules linked in: hidp snd_seq_dummy snd_seq_oss snd_seq_midi_event 
snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss rfcomm bnep ipv6 
reiserfs ext4 jbd2 lp fuse btusb bluetooth rfkill joydev nv_tco 
snd_hda_codec_analog nouveau ttm drm_kms_helper drm agpgart forcedeth 
i2c_algo_bit processor video thermal fan thermal_sys ppdev firewire_ohci 
firewire_core i2c_nforce2 i2c_core ohci_hcd asus_atk0110 k8temp 
snd_hda_intel snd_hda_codec rtc_cmos rtc_core snd_hwdep parport_pc 
parport rtc_lib button snd_pcm hwmon evdev snd_timer snd soundcore 
snd_page_alloc sg nls_iso8859_1 nls_cp437 ssb pcmcia pcmcia_core 
sdio_uart mmc_block mmc_core msdos vfat fat usb_storage uhci_hcd 
ehci_hcd usbhid hid btrfs ext3 jbd mbcache

  Pid: 3583, comm: btrfs Tainted: G        W   2.6.39-rc5test #1 System 
manufacturer System Product Name/M2N-SLI DELUXE
  RIP: 0010:[<ffffffffa0099c5e>]  [<ffffffffa0099c5e>] 
btrfs_init_new_device+0xb2e/0xc50 [btrfs]
  RSP: 0018:ffff880177cf9d18  EFLAGS: 00010296
  RAX: ffff88017c244701 RBX: 0000000000000001 RCX: 000000000001d572
  RDX: 000000000001d571 RSI: 000060fe80001a80 RDI: ffffea0005327ee0
  RBP: ffff880177cf9e08 R08: ffffffffa004cbdf R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000001 R12: ffff88017c244750
  R13: ffff880165999800 R14: 0000000000000000 R15: 00000000003fffff
  FS:  00007f5fb7381760(0000) GS:ffff88017fd00000(0000) 
knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
  CR2: 00007f5fb6cde1f0 CR3: 00000001659a3000 CR4: 00000000000006e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
  Process btrfs (pid: 3583, threadinfo ffff880177cf8000, task 
ffff88016bab73d0)
  Stack:
   ffff880164d6d740 ffff880164d6d6c0 ffff8801648f4000 0000000000000002
   ffff880165306800 ffff880177cf9fd8 ffff880165306800 ffff880165999801
   0000000000000000 0000000000000100 0000000000000100 00000000400000e4
  Call Trace:
   [<ffffffff810e828d>] ? __free_pages+0x2d/0x40
   [<ffffffffa009f85a>] btrfs_ioctl+0x5aa/0xa60 [btrfs]
   [<ffffffff81027d5c>] ? do_page_fault+0x19c/0x3d0
   [<ffffffff8113c057>] do_vfs_ioctl+0x97/0x4f0
   [<ffffffff81147faf>] ? mntput+0x1f/0x30
   [<ffffffff8112c92f>] ? fput+0x16f/0x210
   [<ffffffff8113c541>] sys_ioctl+0x91/0xa0
   [<ffffffff814d356b>] system_call_fastpath+0x16/0x1b
  Code: ac ff ff 83 f8 e4 74 25 85 c0 0f 84 0d ff ff ff 0f 0b be b4 07 
00 00 48 c7 c7 e1 b6 0b a0 e8 9a 6f fb e0 4c 89 e7 e8 52 2f fb ff <0f> 
0b 83 c3 01 e9 e8 fe ff ff 85 db 0f 84 83 00 00 00 80 bd 48
  RIP  [<ffffffffa0099c5e>] btrfs_init_new_device+0xb2e/0xc50 [btrfs]
   RSP <ffff880177cf9d18>
---[ end trace a9ff0c6879f02131 ]---




