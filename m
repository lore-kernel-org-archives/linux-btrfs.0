From: cwillu <cwillu@cwillu.com>
Subject: Re: btrfs seed with luks encrypted devices
Date: Tue, 3 May 2011 19:50:53 -0600
Message-ID: <BANLkTim013vB+PicvYCziBoyMctX2_jreQ@mail.gmail.com>
References: <4DC0AC9E.1030607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Geoff Ritter <geoff.ritter@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DC0AC9E.1030607@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 3, 2011 at 7:32 PM, Geoff Ritter <geoff.ritter@gmail.com> w=
rote:
> Not sure where to report bugs or even find a coherent list of them. =C2=
=A0Sorry
> if this is already well known.
>
> When attempting to use an unlocked encrypted device as either a seed =
device
> or the writeable device, a kernel bug will be displayed at
> fs/btrfs/volumes.c:2402 after attempting to add the writeable device =
to the
> mounted read-only seed.
>
> STR:
> 1. =C2=A0cryptsetup luksFormat /dev/sdx1
> 2. =C2=A0cryptsetup luksOpen /dev/sdx1 luksSeed
> 3. =C2=A0mkfs.btrfs /dev/mapper/luksSeed
> 4. =C2=A0mount and add files if you want, then unmount
> 5. =C2=A0btrfstune -S 1 /dev/mapper/luksSeed
> 6. =C2=A0mount /dev/mapper/luksSeed /mnt/luksSeed
> 7. =C2=A0btrfs device add /dev/sdx2 /mnt/luksSeed
> 8. =C2=A0Observe kernel BUG.
>
> I would hope to expect to see an error message if this is never inten=
ded to
> be possible. =C2=A0But normal btrfs file systems appear to function n=
ormally
> under both encrypted and lvm partitions.
>
> This attached kernel message was from two LVM logical volumes on a lu=
ks
> encrypted partition. =C2=A0However, I also tested this with two regul=
ar
> partitions between endrypted-seed/unencrypted-rw,
> =C2=A0endrypted-rw/unencrypted-seed, and both encrypted.
>
> ------------[ cut here ]------------
> =C2=A0kernel BUG at fs/btrfs/volumes.c:2402!
> =C2=A0invalid opcode: 0000 [#1] SMP
> =C2=A0last sysfs file:
> /sys/devices/pci0000:00/0000:00:05.0/host0/target0:0:0/0:0:0:0/block/=
sda/dev
> =C2=A0CPU 0
> =C2=A0Modules linked in: usbhid parport_pc hid firewire_ohci i2c_nfor=
ce2
> firewire_core i2c_core forcedeth parport
> =C2=A0Pid: 1845, comm: btrfs Not tainted 2.6.37.6 #3 System manufactu=
rer System
> Product Name/M2N-SLI DELUXE
> =C2=A0RIP: 0010:[<ffffffff8149cdba>] =C2=A0[<ffffffff8149cdba>]
> __finish_chunk_alloc+0x21a/0x220
> =C2=A0RSP: 0018:ffff880175533668 =C2=A0EFLAGS: 00010286
> =C2=A0RAX: 00000000ffffffe4 RBX: ffff880176004500 RCX: 00000000000000=
40
> =C2=A0RDX: 0000000000000000 RSI: ffffea000523aff0 RDI: ffff88017788df=
00
> =C2=A0RBP: ffff8801755336e8 R08: 000000000000bda5 R09: 00000000000000=
00
> =C2=A0R10: 0000000000000000 R11: 00000000ffffffe4 R12: ffff880177e8e0=
00
> =C2=A0R13: ffff880176956b00 R14: ffff8801773cb000 R15: 00000000000000=
70
> =C2=A0FS: =C2=A000007fe05f784760(0000) GS:ffff8800bfc00000(0000)
> knlGS:0000000000000000
> =C2=A0CS: =C2=A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
> =C2=A0CR2: 0000000000683a10 CR3: 000000017549c000 CR4: 00000000000006=
f0
> =C2=A0DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000000=
00
> =C2=A0DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000004=
00
> =C2=A0Process btrfs (pid: 1845, threadinfo ffff880175532000, task
> ffff88017547ed00)
> =C2=A0Stack:
> =C2=A00000000010000000 ffff880100000000 0000000008000000 000000030a40=
0000
> =C2=A0ffff8801773cc000 0000000008000000 ffff8801770ef810 ffff8801770e=
f810
> =C2=A00000000019100000 0000000000000000 ffff8800bfd119ff ffff8801773c=
b000
> =C2=A0Call Trace:
> =C2=A0[<ffffffff8149f18e>] btrfs_alloc_chunk+0x8e/0xa0
> =C2=A0[<ffffffff814647ee>] do_chunk_alloc+0x14e/0x2a0
> =C2=A0[<ffffffff814685f2>] btrfs_reserve_extent+0xd2/0x180
> =C2=A0[<ffffffff81468bb1>] btrfs_alloc_free_block+0xc1/0x330
> =C2=A0[<ffffffff8145696d>] __btrfs_cow_block+0x14d/0x610
> =C2=A0[<ffffffff81456f3f>] btrfs_cow_block+0x10f/0x200
> =C2=A0[<ffffffff8145bfaa>] btrfs_search_slot+0x50a/0x880
> =C2=A0[<ffffffff81455f5a>] ? btrfs_free_path+0x2a/0x40
> =C2=A0[<ffffffff8145d38e>] btrfs_insert_empty_items+0x7e/0xe0
> =C2=A0[<ffffffff8146efa7>] btrfs_insert_empty_inode+0x37/0x40
> =C2=A0[<ffffffff814b554f>] create_reloc_inode.clone.41+0x9f/0x230
> =C2=A0[<ffffffff81113257>] ? kmem_cache_alloc+0xb7/0x110
> =C2=A0[<ffffffff814bb91b>] btrfs_relocate_block_group+0x14b/0x2e0
> =C2=A0[<ffffffff8149bf03>] btrfs_relocate_chunk.clone.41+0x83/0x5b0
> =C2=A0[<ffffffff8149a180>] ? map_extent_buffer+0xb0/0xc0
> =C2=A0[<ffffffff814890f5>] ? btrfs_chunk_type+0xe5/0xf0
> =C2=A0[<ffffffff814a0b6b>] btrfs_init_new_device+0xaeb/0xd00
> =C2=A0[<ffffffff814a6476>] ? btrfs_ioctl+0x496/0x9d0
> =C2=A0[<ffffffff814a6498>] btrfs_ioctl+0x4b8/0x9d0
> =C2=A0[<ffffffff8102a0a4>] ? do_page_fault+0x1a4/0x3d0
> =C2=A0[<ffffffff8113002d>] do_vfs_ioctl+0x9d/0x580
> =C2=A0[<ffffffff811339fe>] ? dput+0x7e/0x160
> =C2=A0[<ffffffff811211a2>] ? fput+0x192/0x250
> =C2=A0[<ffffffff81130591>] sys_ioctl+0x81/0xa0
> =C2=A0[<ffffffff81002a2b>] system_call_fastpath+0x16/0x1b
> =C2=A0Code: ef e8 eb 5e c7 ff 48 83 c4 58 31 c0 5b 41 5c 41 5d 41 5e =
41 5f c9 c3
> 48 83 c4 58 b8 f4 ff ff ff 5b 41 5c 41 5d 41 5e 41 5f c9 c3 <0f> 0b 0=
f 0b 0f
> 0b 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83
> =C2=A0RIP =C2=A0[<ffffffff8149cdba>] __finish_chunk_alloc+0x21a/0x220
> =C2=A0RSP <ffff880175533668>
> =C2=A0---[ end trace 8fa94cbaf8bdef31 ]---

Can you try again using the latest 2.6.39rc?  This is a enospc-related
error (RAX: 00000000ffffffe4), and a bunch of those have been fixed
since 2.6.37.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
