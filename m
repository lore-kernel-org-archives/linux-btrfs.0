Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:36466 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab3EFJMs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 May 2013 05:12:48 -0400
Received: by mail-lb0-f171.google.com with SMTP id u10so3200092lbi.30
        for <linux-btrfs@vger.kernel.org>; Mon, 06 May 2013 02:12:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5187700F.20807@jan-o-sch.net>
References: <6moh5a-knf.ln1@hurikhan.ath.cx> <2sci5a-n8p.ln1@hurikhan.ath.cx> <5187700F.20807@jan-o-sch.net>
From: Harald Glatt <mail@hachre.de>
Date: Mon, 6 May 2013 11:12:25 +0200
Message-ID: <CAFWF=amCXg0_G4-_c1UU_hJpv3M-FjozA-7ougxJkd=t2iFG6Q@mail.gmail.com>
Subject: Re: hard freezes with 3.9.0 during io-intensive loads
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: Kai Krakow <hurikhan77+btrfs@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have this problem too, and I cannot reproduce it properly... When is
that patch in btrfs-next going to be in the mainline kernel?

On Mon, May 6, 2013 at 10:55 AM, Jan Schmidt <list.btrfs@jan-o-sch.net> wrote:
> On Sun, May 05, 2013 at 18:10 (+0200), Kai Krakow wrote:
>> Hello list,
>>
>> Kai Krakow <hurikhan77+btrfs@gmail.com> schrieb:
>>
>>> I've upgraded to 3.9.0 mainly for the snapshot-aware defragging patches.
>>> I'm running bedup[1] on a regular basis and it is now the third time that
>>> I got back to my PC just to find it hard-frozen and I needed to use the
>>> reset button.
>>>
>>> It looks like this happens only while running bedup on my two btrfs
>>> filesystems but I'm not sure if it happens for any of the filesystems or
>>> only one. This is my setup:
>>>
>>> # cat /etc/fstab (shortened)
>>> UUID=d2bb232a-2e8f-4951-8bcc-97e237f1b536 / btrfs
>>> compress=lzo,subvol=root64 0 1 # /dev/sd{a,b,c}3
>>> LABEL=usb-backup /mnt/private/usb-backup btrfs noauto,compress-
>>> force=zlib,subvolid=0,autodefrag,comment=systemd.automount 0 0 # external
>>> usb3 disk
>>>
>>> # btrfs filesystem show
>>> Label: 'usb-backup'  uuid: 7038c8fa-4293-49e9-b493-a9c46e5663ca
>>>         Total devices 1 FS bytes used 1.13TB
>>>         devid    1 size 1.82TB used 1.75TB path /dev/sdd1
>>>
>>> Label: 'system'  uuid: d2bb232a-2e8f-4951-8bcc-97e237f1b536
>>>         Total devices 3 FS bytes used 914.43GB
>>>         devid    3 size 927.26GB used 426.03GB path /dev/sdc3
>>>         devid    2 size 927.26GB used 426.03GB path /dev/sdb3
>>>         devid    1 size 927.26GB used 427.07GB path /dev/sda3
>>>
>>> Btrfs v0.20-rc1
>>>
>>> Since the system hard-freezes I have no messages from dmesg. But I suspect
>>> it to be related to the defragmentation option in bedup (I've switched to
>>> bedub with --defrag since 3.9.0, and autodefrag for the backup drive).
>>> Just in case, I'm going to try without this option now and see if it won't
>>> freeze.
>>>
>>> I was able to take a "physical" screenshot with a real camera of a kernel
>>> backtrace one time when the freeze happened. I wonder if it is useful to
>>> you and where to send it. I just don't want to upload jpegs right here to
>>> the list without asking first.
>>>
>>> The big plus is: Altough I had to hard-reset the frozen system several
>>> times now, btrfs survived the procedure without any impact (just boot
>>> times increases noticeably, probably due to log-replays or something). So
>>> thumbs up for the developers on that point.
>>
>> Thanks to the great cwillu netcat service here's my backtrace:
>
> That one should be fixed in btrfs-next. If you can reliably reproduce the bug
> I'd be glad to get a confirmation - you can probably even save putting it on
> bugzilla then ;-)
>
> -Jan
>
>> 4,1072,17508258745,-;------------[ cut here ]------------
>> 2,1073,17508258772,-;kernel BUG at fs/btrfs/ctree.c:1144!
>> 4,1074,17508258791,-;invalid opcode: 0000 [#1] SMP
>> 4,1075,17508258811,-;Modules linked in: bnep bluetooth af_packet vmci(O)
>> vmmon(O) vmblock(O) vmnet(O) vsock reiserfs snd_usb_audio snd_usbmidi_lib
>> snd_rawmidi snd_seq_device gspca_sonixj gpio_ich gspca_main videodev
>> coretemp hwmon kvm_intel kvm crc32_pclmul crc32c_intel 8250 serial_core
>> lpc_ich microcode mfd_core i2c_i801 pcspkr evdev usb_storage zram(C) unix
>> 4,1076,17508258966,-;CPU 0
>> 4,1077,17508258977,-;Pid: 7212, comm: btrfs-endio-wri Tainted: G         C O
>> 3.9.0-gentoo #2 To Be Filled By O.E.M. To Be Filled By O.E.M./Z68 Pro3
>> 4,1078,17508259023,-;RIP: 0010:[<ffffffff81161d12>]  [<ffffffff81161d12>]
>> __tree_mod_log_rewind+0x4c/0x121
>> 4,1079,17508259064,-;RSP: 0018:ffff8801966718e8  EFLAGS: 00010293
>> 4,1080,17508259085,-;RAX: 0000000000000003 RBX: ffff8801ee8d33b0 RCX:
>> ffff880196671888
>> 4,1081,17508259112,-;RDX: 000000000a4596a4 RSI: 0000000000000eee RDI:
>> ffff8804087be700
>> 4,1082,17508259138,-;RBP: 0000000000000071 R08: 0000000000001000 R09:
>> ffff880196671898
>> 4,1083,17508259165,-;R10: 0000000000000000 R11: 0000000000000000 R12:
>> ffff880406c2e000
>> 4,1084,17508259191,-;R13: 0000000000008a11 R14: ffff8803b5aa1200 R15:
>> 0000000000000001
>> 4,1085,17508259218,-;FS:  0000000000000000(0000) GS:ffff88041f200000(0000)
>> knlGS:0000000000000000
>> 4,1086,17508259248,-;CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> 4,1087,17508259270,-;CR2: 00000000026f0390 CR3: 0000000001a0b000 CR4:
>> 00000000000407f0
>> 4,1088,17508259297,-;DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>> 0000000000000000
>> 4,1089,17508259323,-;DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>> 0000000000000400
>> 4,1090,17508259350,-;Process btrfs-endio-wri (pid: 7212, threadinfo
>> ffff880196670000, task ffff8801b82e5400)
>> 4,1091,17508259383,-;Stack:
>> 4,1092,17508259391,-; ffff8801ee8d38f0 ffff880021b6f360 ffff88013a5b2000
>> 0000000000008a11
>> 4,1093,17508259423,-; ffff8802d0a14000 ffffffff81167606 0000000000000246
>> ffff8801ee8d33b0
>> 4,1094,17508259455,-; ffff880406c2e000 ffff8801966719bf ffff880021b6f360
>> 0000000000000000
>> 4,1095,17508259488,-;Call Trace:
>> 4,1096,17508259500,-; [<ffffffff81167606>] ?
>> btrfs_search_old_slot+0x543/0x61e
>> 4,1097,17508259526,-; [<ffffffff811692de>] ? btrfs_next_old_leaf+0x8a/0x332
>> 4,1098,17508259552,-; [<ffffffff811c484a>] ?
>> __resolve_indirect_refs+0x2d8/0x408
>> 4,1099,17508259578,-; [<ffffffff811c533b>] ? find_parent_nodes+0x9c1/0xcec
>> 4,1100,17508259602,-; [<ffffffff811c5e06>] ?
>> iterate_extent_inodes+0xf1/0x23c
>> 4,1101,17508259628,-; [<ffffffff811837b9>] ? btrfs_real_readdir+0x482/0x482
>> 4,1102,17508259652,-; [<ffffffff81194db7>] ?
>> release_extent_buffer.isra.19+0x27/0x88
>> 4,1103,17508259679,-; [<ffffffff811837b9>] ? btrfs_real_readdir+0x482/0x482
>> 4,1104,17508259703,-; [<ffffffff811c5fda>] ?
>> iterate_inodes_from_logical+0x89/0x96
>> 4,1105,17508259729,-; [<ffffffff811822fc>] ?
>> record_extent_backrefs+0x4d/0x8e
>> 4,1106,17508259755,-; [<ffffffff8118a8af>] ?
>> btrfs_finish_ordered_io+0x671/0x798
>> 4,1107,17508259781,-; [<ffffffff811a33cf>] ? worker_loop+0x176/0x493
>> 4,1108,17508259803,-; [<ffffffff811a3259>] ? btrfs_queue_worker+0x272/0x272
>> 4,1109,17508259827,-; [<ffffffff811a3259>] ? btrfs_queue_worker+0x272/0x272
>> 4,1110,17508259852,-; [<ffffffff810496d2>] ? kthread+0x81/0x89
>> 4,1111,17508259873,-; [<ffffffff81050000>] ? free_sched_groups+0x32/0x50
>> 4,1112,17508259896,-; [<ffffffff81049651>] ?
>> kthread_freezable_should_stop+0x36/0x36
>> 4,1113,17508259924,-; [<ffffffff8151c66c>] ? ret_from_fork+0x7c/0xb0
>> 4,1114,17508259947,-; [<ffffffff81049651>] ?
>> kthread_freezable_should_stop+0x36/0x36
>> 4,1115,17508259974,-;Code: 85 e4 89 c5 0f 85 d6 00 00 00 e9 db 00 00 00 41
>> 83 7e 28 05 0f 87 ab 00 00 00 41 8b 46 28 ff 24 c5 20 78 62 81 41 39 6e 2c
>> 73 02 <0f> 0b 41 8b 56 2c 49 8d 76 38 48 89 df ff c5 e8 7c fb ff ff 49
>> 1,1116,17508260117,-;RIP  [<ffffffff81161d12>]
>> __tree_mod_log_rewind+0x4c/0x121
>> 4,1117,17508260144,-; RSP <ffff8801966718e8>
>> 4,1118,17508446926,-;---[ end trace e7a8cddfc052e9e9 ]---
>>
>> Regards,
>> Kai
>>
>>> [1]: https://github.com/g2p/bedup
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
