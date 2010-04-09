From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: kernel BUG at /home/mafra/linux-2.6/fs/btrfs/volumes.c:2828!
Date: Fri, 9 Apr 2010 08:53:14 +0800
Message-ID: <u2g3d0408631004081753ua2f9667bzc84650876819686e@mail.gmail.com>
References: <20100408222352.GA4485@Pilar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100408222352.GA4485@Pilar>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 9, 2010 at 6:23 AM, Carlos R. Mafra <crmafra2@gmail.com> wr=
ote:
> I've just got this bug in the latest 2.6.34-rc3-00388 kernel.
>
> I wasn't doing anything fancy, just doing some 'git log' in a small w=
maker
> repo I have here. After I got this bug the cpu went to 100% and I had=
 to
> reboot with the button because the laptop was not responding to any c=
ommands
> (but the mouse was moving and X seemed ok)
>
> I have the full dmesg (64 KB) which I can upload somewhere if needed.=
 But
> for now I just would like to know if this bug is known to people in t=
he list.
>
> [ 8150.547096] ------------[ cut here ]------------
> [ 8150.547101] kernel BUG at /home/mafra/linux-2.6/fs/btrfs/volumes.c=
:2828!
> [ 8150.547103] invalid opcode: 0000 [#1] SMP
> [ 8150.547107] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/=
scaling_cur_freq
> [ 8150.547109] CPU 1
> [ 8150.547111] Modules linked in: ppp_deflate ppp_async ppp_generic s=
lhc option usbserial snd_seq snd_seq_device uvcvideo snd_hda_codec_idt =
snd_hda_in =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tel iwlagn sky2 snd_hda_c=
odec ehci_hcd snd_hwdep i2c_i801 evdev
> [ 8150.547125]
> [ 8150.547128] Pid: 1606, comm: btrfs-delalloc- Not tainted 2.6.34-rc=
3-00388-gf5284e7 #48 VAIO/VGN-FZ240E
> [ 8150.547131] RIP: 0010:[<ffffffff811b39a9>] =A0[<ffffffff811b39a9>]=
 btrfs_rmap_block+0x2c9/0x2d0
> [ 8150.547139] RSP: 0018:ffff88007aeab7f0 =A0EFLAGS: 00010246
> [ 8150.547142] RAX: 0000000000000000 RBX: 0000000000010000 RCX: fffff=
fffffffffff
> [ 8150.547144] RDX: 0000001e821d0000 RSI: 0000001e821d0000 RDI: ffff8=
8007ef1fa28
> [ 8150.547147] RBP: ffff88007aeab870 R08: 0000000000000000 R09: ffff8=
8007aeab8a8
> [ 8150.547149] R10: 0000000000000000 R11: ffff88005ae73580 R12: 00000=
00000000000
> [ 8150.547151] R13: ffff88007ae9c0e8 R14: ffff88007aeab8ac R15: ffff8=
8007aeab8a8
> [ 8150.547154] FS: =A00000000000000000(0000) GS:ffff880001b00000(0000=
) knlGS:0000000000000000
> [ 8150.547157] CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 8150.547159] CR2: 00007f4adf3d9000 CR3: 0000000001812000 CR4: 00000=
000000006e0
> [ 8150.547161] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> [ 8150.547164] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000=
00000000400
> [ 8150.547166] Process btrfs-delalloc- (pid: 1606, threadinfo ffff880=
07aeaa000, task ffff88007f330280)
> [ 8150.547168] Stack:
> [ 8150.547170] =A000000000000009b8 ffff880000000001 ffff88007acf7000 =
00ffffff811a0eb5
> [ 8150.547173] <0> 0000000000000001 00002202400000cc ffff88007aeaa000=
 ffff88007aeab8a8
> [ 8150.547178] <0> ffff88007aeab8a0 0000001e821d0000 ffff88007aeab860=
 ffff88007ae6fd80
> [ 8150.547182] Call Trace:
> [ 8150.547188] =A0[<ffffffff8117bdb1>] exclude_super_stripes+0x61/0x1=
10
> [ 8150.547193] =A0[<ffffffff8119dc30>] ? __tree_search+0x90/0x120
> [ 8150.547196] =A0[<ffffffff8117c906>] btrfs_make_block_group+0x136/0=
x320
> [ 8150.547200] =A0[<ffffffff811b6fd6>] __btrfs_alloc_chunk+0x616/0x74=
0
> [ 8150.547203] =A0[<ffffffff811b716f>] btrfs_alloc_chunk+0x6f/0xa0
> [ 8150.547207] =A0[<ffffffff8117d546>] do_chunk_alloc+0x166/0x230
> [ 8150.547210] =A0[<ffffffff8117f7d9>] find_free_extent+0x939/0x9f0
> [ 8150.547214] =A0[<ffffffff8117fab5>] btrfs_reserve_extent+0xc5/0x1b=
0
> [ 8150.547218] =A0[<ffffffff814f3559>] ? mutex_lock+0x19/0x50
> [ 8150.547227] =A0[<ffffffff8119572d>] submit_compressed_extents+0x10=
d/0x3f0
> [ 8150.547231] =A0[<ffffffff81195a8f>] async_cow_submit+0x7f/0x90
> [ 8150.547234] =A0[<ffffffff811b80c6>] run_ordered_completions+0x76/0=
xe0
> [ 8150.547237] =A0[<ffffffff811b898a>] worker_loop+0x15a/0x580
> [ 8150.547240] =A0[<ffffffff811b8830>] ? worker_loop+0x0/0x580
> [ 8150.547243] =A0[<ffffffff8105b6ce>] kthread+0x8e/0xa0
> [ 8150.547248] =A0[<ffffffff81003ad4>] kernel_thread_helper+0x4/0x10
> [ 8150.547250] =A0[<ffffffff8105b640>] ? kthread+0x0/0xa0
> [ 8150.547259] =A0[<ffffffff81003ad0>] ? kernel_thread_helper+0x0/0x1=
0
> [ 8150.547261] Code: 00 00 48 c7 c7 68 ce 75 81 e8 34 ab e8 ff 4c 8b =
5d 90 4c 8b 55 98 4c 8b 4d b0 48 8b 4d a0 48 8b 45 a8 e9 af fe ff ff 0f=
 0b eb fe =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 <0f> 0b eb fe 0f 1f 00 55=
 48 89 e5 41 55 49 89 d5 41 54 49 89 f4
> [ 8150.547292] RIP =A0[<ffffffff811b39a9>] btrfs_rmap_block+0x2c9/0x2=
d0
> [ 8150.547296] =A0RSP <ffff88007aeab7f0>
> [ 8150.547310] ---[ end trace 6c5e0e4f829c2aeb ]---

This has been fixed by commit
http://git.kernel.org/?p=3Dlinux/kernel/git/mason/btrfs-unstable.git;a=3D=
commit;h=3D9f680ce04ea19dabbbafe01b57b61930a9b70741

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
