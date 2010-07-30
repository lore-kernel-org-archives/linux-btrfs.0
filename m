From: "Adi" <adalbert.b@gmx.de>
Subject: Re: wanted X found X-1 but you got X-2
Date: Fri, 30 Jul 2010 09:13:54 +0200
Message-ID: <20100730071354.257500@gmx.net>
References: <20100729131103.323870@gmx.net> <4C526516.30709@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C526516.30709@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

hi,

i used a current stable gentoo with a 2.6.34-r2 gentoo-kernel. the btrfs filesystem is on a lvm, which is on a luks-partition.
i think i corrupted the filesystem with a 2.6.34 tuxonice kernel, witch ran fine without suspend-to-disk, but after suspending i couldn't reboot anymore.
this debug is made on a sysrescuecd 1.5.8, after i try to btrfsck it. if i try to mount it, the terminal hangs, but i can switch to another.
would it help if i copy some data off the filesystem?

ciao, adi

> On 07/29/2010 09:11 PM, Adi wrote:
> > hi,
> > i have a problem with mounting a btrfspartition. i think it corrupted
> somehow. btrfsck also didn't work.
> > here is the demesg output, if i try to btrfsck it:
> >
> >   
> 
> Hi, Adi
> 
> can you give us some steps with which the bug can be reproduced?
> 
> Thanks,
> liubo
> 
> 
> > ***********************************
> >
> > device-mapper: ioctl: unable to remove open device
> temporary-cryptsetup-2466
> > device fsid 184f65b363e9d585-fc67ce9a295b44a3 devid 1 transid 103380
> /dev/dm-1
> > end_request: I/O error, dev fd0, sector 0
> > device fsid 184f65b363e9d585-fc67ce9a295b44a3 devid 1 transid 103380
> /dev/mapper/vg2-root
> > parent transid verify failed on 5403553792 wanted 103380 found 103378
> > ------------[ cut here ]------------
> > kernel BUG at fs/btrfs/async-thread.c:602!
> > invalid opcode: 0000 [#1] SMP 
> > last sysfs file: /sys/devices/virtual/bdi/btrfs-1/uevent
> > Modules linked in: sha256_generic serpent dm_crypt ipv6 arc4 ecb ath5k
> cm4000_cs ppdev mac80211 iTCO_wdt iTCO_vendor_support parport_pc ath video
> thinkpad_acpi yenta_socket parport i2c_i801 output rsrc_nonstatic cfg80211
> joydev i2c_core pcspkr rfkill raid10 raid456 async_raid6_recov async_pq
> raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear e100
> mii floppy
> >
> > Pid: 2501, comm: kcryptd Not tainted 2.6.34.01-alt158-i386 #2
> 2373189/2373189
> > EIP: 0060:[<c06cee9a>] EFLAGS: 00010046 CPU: 0
> > EIP is at btrfs_queue_worker+0xe7/0x1f8
> > EAX: 00000000 EBX: f53ea04c ECX: 00000000 EDX: 00000000
> > ESI: 00000000 EDI: f63bc5c0 EBP: f51e7e34 ESP: f51e7e14
> >  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> > Process kcryptd (pid: 2501, ti=f51e6000 task=f51e9520 task.ti=f51e6000)
> > Stack:
> >  00000206 f53ea070 00000246 f53ea068 f53ea088 f53e8000 f516cd60 00000000
> > <0> f51e7e40 c06abcc1 f520b850 f51e7e48 c04e804e f51e7e64 c0851a40
> 00000000
> > <0> f526df80 f526dc80 00000000 f5365790 f51e7e84 c0851bb5 f520b850
> f5214000
> > Call Trace:
> >  [<c06abcc1>] ? end_workqueue_bio+0x56/0x59
> >  [<c04e804e>] ? bio_endio+0x22/0x24
> >  [<c0851a40>] ? dec_pending+0x124/0x12b
> >  [<c0851bb5>] ? clone_endio+0x96/0x9e
> >  [<c04e804e>] ? bio_endio+0x22/0x24
> >  [<c0851a40>] ? dec_pending+0x124/0x12b
> >  [<c0851bb5>] ? clone_endio+0x96/0x9e
> >  [<c04e804e>] ? bio_endio+0x22/0x24
> >  [<fa376677>] ? 0xfa376677
> >  [<fa376ece>] ? 0xfa376ece
> >  [<c0448c51>] ? worker_thread+0x14c/0x251
> >  [<c0448c93>] ? worker_thread+0x18e/0x251
> >  [<c0448c51>] ? worker_thread+0x14c/0x251
> >  [<fa376c12>] ? 0xfa376c12
> >  [<c044c1c1>] ? autoremove_wake_function+0x0/0x2f
> >  [<c0448b05>] ? worker_thread+0x0/0x251
> >  [<c044be5e>] ? kthread+0x6a/0x6f
> >  [<c044bdf4>] ? kthread+0x0/0x6f
> >  [<c0403abe>] ? kernel_thread_helper+0x6/0x10
> > Code: 00 00 89 d8 e8 0e fe ff ff e9 65 ff ff ff 8b 43 1c 31 d2 3b 45 ec
> 8b 73 24 0f 95 c2 f7 da 21 d0 3b 75 e4 75 02 89 c6 85 f6 75 04 <0f> 0b eb
> fe 83 ee 14 3e ff 46 20 8b 55 e8 8b 45 f0 e8 81 ef 24 
> > EIP: [<c06cee9a>] btrfs_queue_worker+0xe7/0x1f8 SS:ESP 0068:f51e7e14
> > ---[ end trace 2d2977bc6fb46ae8 ]---
> >
> > ***********************************
> >
> > that was on a sysrescuecd 1.5.8.
> > i'll try the new git-version, lets see what happens.
> >
> > ciao, adi
> >   

-- 
Neu: GMX De-Mail - Einfach wie E-Mail, sicher wie ein Brief!  
Jetzt De-Mail-Adresse reservieren: http://portal.gmx.net/de/go/demail
