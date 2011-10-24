From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: Re: Kernel BUG unable to handle kernel NULL pointer dereference
Date: Mon, 24 Oct 2011 13:10:04 +0100
Message-ID: <CAAeznTrWWD97De=dtbBNRTpwMZ5mipp_E31Yx-h52vr-zcj6+A@mail.gmail.com>
References: <CAAeznTqh1W0W743WxTO+iUfajgsMw-A6abwr1fAZ6hWOJOnw2Q@mail.gmail.com>
	<CAKcLGm-+g9xy_aL2Z_F2VYG8qFsXonB7nutM1VSs5sqLZz2PGA@mail.gmail.com>
	<CAAeznTpDmT7NgZdAHh7uVPBnKtitr=SmLRvfFKrd_exG6XLE9w@mail.gmail.com>
	<20111024112259.GE26547@ds.suse.cz>
	<CAAeznTpSsKSMe7udHH1kZmFNg6ROf4czxriNpPh_Trb_PHbtzg@mail.gmail.com>
	<20111024115110.GG26547@ds.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>,
	linux-btrfs@vger.kernel.org
To: dsterba@suse.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111024115110.GG26547@ds.suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 24, 2011 at 12:51 PM, David Sterba <dsterba@suse.cz> wrote:
> On Mon, Oct 24, 2011 at 12:33:05PM +0100, Leonidas Spyropoulos wrote:
>> Here is it, it's big and contains usless information..
>>
>> http://paste.pocoo.org/show/497299/
>
> not all that useless ... I saw another BUG earlier than the one you'v=
e
> reported:
>
> [31653.267742] ------------[ cut here ]------------
> [31653.267764] kernel BUG at fs/btrfs/extent-tree.c:5510!
> [31653.267773] invalid opcode: 0000 [#1] PREEMPT SMP
> [31653.267785] CPU 1
> [31653.267790] Modules linked in: vboxdrv ipv6 loop fuse adt7475 hwmo=
n_vid nouveau evdev uvcvideo hid_apple ttm videodev drm_kms_helper medi=
a v4l2_compat_ioctl32 drm snd_emu10k1 i2c_algo_bit mxm_wmi wmi pcspkr s=
nd_rawmidi snd_seq_device firewire_ohci emu10k1_gp edac_core psmouse sn=
d_util_mem edac_mce_amd k8temp firewire_core gameport snd_hwdep video s=
erio_raw crc_itu_t sg snd_intel8x0 snd_ac97_codec usbhid ac97_bus snd_p=
cm snd_timer hid snd floppy i2c_nforce2 thermal processor fan button so=
undcore i2c_core snd_page_alloc forcedeth btrfs zlib_deflate crc32c lib=
crc32c ext4 jbd2 crc16 ext3 jbd mbcache ohci_hcd ehci_hcd usbcore sr_mo=
d sd_mod cdrom sata_nv pata_amd libata scsi_mod
> [31653.267989]
> [31653.267995] Pid: 726, comm: btrfs-transacti Not tainted 3.0-ARCH #=
1 =A0 =A0/LP UT NF4 Expert
> [31653.268011] RIP: 0010:[<ffffffffa01a6263>] =A0[<ffffffffa01a6263>]=
 run_clustered_refs+0x813/0x830 [btrfs]
> [31653.268045] RSP: 0018:ffff88013469bc70 =A0EFLAGS: 00010286
> [31653.268286] RAX: 00000000ffffffe4 RBX: ffff88012e406900 RCX: ffff8=
801378a6100
> [31653.268296] RDX: ffff88011513a0f0 RSI: 0000000000000000 RDI: 00000=
00000000000
> [31653.268306] RBP: ffff88013469bd50 R08: ffffffffffffffff R09: 00000=
00000000000
> [31653.268315] R10: ffff8801346f9800 R11: ffff88013735d3f0 R12: ffff8=
800a9bc7f00
> [31653.268325] R13: ffff88007b1d7e40 R14: ffff88011bd1e4b0 R15: 00000=
00000000000
> [31653.268341] FS: =A000007f8dcc527880(0000) GS:ffff88013fd00000(0000=
) knlGS:00000000f67567f0
> [31653.268367] CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [31653.268380] CR2: 00007f9059631550 CR3: 00000000a499c000 CR4: 00000=
000000006e0
> [31653.268394] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> [31653.268409] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000=
00000000400
> [31653.268424] Process btrfs-transacti (pid: 726, threadinfo ffff8801=
3469a000, task ffff880136c140b0)
> [31653.268443] Stack:
> [31653.268449] =A00000000000000000 0000000000000000 ffff880100000001 =
0000000000000000
> [31653.268473] =A00000000000000c2e 00000000a01dc529 0000000000000000 =
0000000000000002
> [31653.268495] =A00000000000000b9f 0000000000000c04 0000000000000000 =
ffff88013469bd90
> [31653.268515] Call Trace:
> [31653.268531] =A0[<ffffffffa01a6348>] btrfs_run_delayed_refs+0xc8/0x=
220 [btrfs]
> [31653.268549] =A0[<ffffffffa019421a>] ? btrfs_free_path+0x2a/0x40 [b=
trfs]
> [31653.268568] =A0[<ffffffffa01b86c3>] btrfs_commit_transaction+0x3c3=
/0x8a0 [btrfs]
> [31653.268581] =A0[<ffffffff8107f790>] ? abort_exclusive_wait+0xb0/0x=
b0
> [31653.268598] =A0[<ffffffffa01b13ed>] transaction_kthread+0x26d/0x29=
0 [btrfs]
> [31653.268617] =A0[<ffffffffa01b1180>] ? btrfs_congested_fn+0xd0/0xd0=
 [btrfs]
> [31653.268627] =A0[<ffffffff8107ee3c>] kthread+0x8c/0xa0
> [31653.268638] =A0[<ffffffff813f5d64>] kernel_thread_helper+0x4/0x10
> [31653.268647] =A0[<ffffffff8107edb0>] ? kthread_worker_fn+0x190/0x19=
0
> [31653.268657] =A0[<ffffffff813f5d60>] ? gs_change+0x13/0x13
> [31653.268673] Code: e0 e9 12 f9 ff ff 0f 0b 80 fa b2 0f 84 bc f9 ff =
ff 0f 0b be 95 00 00 00 48 c7 c7 37 d0 20 a0 e8 54 65 eb e0 e9 04 f9 ff=
 ff 0f 0b <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 66 66 66 66 66 66=
 2e
> [31653.268928] RIP =A0[<ffffffffa01a6263>] run_clustered_refs+0x813/0=
x830 [btrfs]
> [31653.268956] =A0RSP <ffff88013469bc70>
> [31653.284196] ---[ end trace d5d8ee7634d1c36e ]---
>
> and it looks related to the print_leaf bug later (eg. mentiones same =
functions
> in the stacktrace and happens during commit).
>
> And judging from the rest of BUG's in the paste, the filesystem is in=
 a bad
> shape. Some BUG_ON's seem to be triggered by ENOSPC (RAX containing 0=
xfff..e4).
>
>
> david
>

I am doing a backup of my current data as I write this mail (hopefully
it will finish without IO errors).
Will it help if I print the btrfs tree and post it somewhere?

I mean, since the system is funcionable, it could be useful to track
down the bug, no?

Regards
Leonidas



--=20
Caution: breathing may be hazardous to your health.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
