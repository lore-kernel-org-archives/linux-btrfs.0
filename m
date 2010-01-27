From: Josef Bacik <josef@redhat.com>
Subject: Re: bug when replacing device in RAID-1 fs
Date: Tue, 26 Jan 2010 21:36:49 -0500
Message-ID: <20100127023648.GF11767@dhcp231-156.rdu.redhat.com>
References: <d955a26e1001221000m5e688d61w9ecbb3b17f82ff2b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Mattias =?iso-8859-1?Q?S=E4teri?= <mattias.sateri@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <d955a26e1001221000m5e688d61w9ecbb3b17f82ff2b@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 22, 2010 at 07:00:29PM +0100, Mattias S=E4teri wrote:
> Hi,
>=20
> I ran into a bug when trying to replace a failed device in a RAID-1
> configuration. I did the following:
>=20
> 1. Create raid1 fs following the description on the btrfs wiki
> (http://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Dev=
ices).
> 2. Mount fs and copy some data to it.
> 3. Unmount fs and overwrite one of the partitions with junk.
> 4. Rescan for btrfs volumes with btrfsctl -a (as expected, finds only
> one volume).
> 5. Try to add the device resulting in a crash, see below:
>=20
> ---------------------------------------------------------------------=
-------
>=20
> # mount -o degraded /dev/sda4 btrfs/
> # btrfs-vol -a /dev/hda1 btrfs/
> Segmentation fault
>=20
> Message from syslogd@bamse at Jan 15 22:14:59 ...
>  kernel:[11517.740084] ------------[ cut here ]------------
>=20
> Message from syslogd@bamse at Jan 15 22:14:59 ...
>  kernel:[11517.740089] last sysfs file: /sys/block/sdc/size
>=20
> Message from syslogd@bamse at Jan 15 22:14:59 ...
>  kernel:[11517.740087] invalid opcode: 0000 [#1] SMP
>=20
> Message from syslogd@bamse at Jan 15 22:14:59 ...
>  kernel:[11517.740170] Stack:
>=20
> Message from syslogd@bamse at Jan 15 22:14:59 ...
>  kernel:[11517.740179] Call Trace:
>=20
> Message from syslogd@bamse at Jan 15 22:14:59 ...
>  kernel:[11517.740228] Code: 44 5e 04 e1 e9 98 fe ff ff be d9 03 00 0=
0
> 48 c7 c7 de 86 35 a0 e8 7e a7 d2 e0 e9 ca fa ff ff 0f 0b eb fe 0f 0b
> eb fe 0f 0b eb fe <0f> 0b eb fe 0f 0b eb fe 0f 0b eb fe be 05 04 00 0=
0
> 48 c7 c7 de
>=20
> bamse:/mnt# btrfs-vol -a /dev/hda1 btrfs
> failed to zero device end -5
>=20
> ---------------------------------------------------------------------=
---------
>=20
> Output from dmesg below:
>=20
> [11467.229110] btrfs: allowing degraded mounts
> [11517.734662] btrfs allocation failed flags 18, wanted 4096
> [11517.734666] space_info has 8376320 free, is not full
> [11517.734667] space_info total=3D8388608, pinned=3D0, delalloc=3D0, =
may_use=3D0, used=3D1
> 2288, root=3D0, super=3D0, reserved=3D0
> [11517.734670] block group 20971520 has 8388608 bytes, 12288 used 0 p=
inned 0 res
> erved
> [11517.734671] block group has cluster?: no
> [11517.734673] 0 blocks of free space at or bigger than bytes is
> [11517.740040] btrfs allocation failed flags 20, wanted 4096
> [11517.740042] space_info has 1012105216 free, is not full
> [11517.740044] space_info total=3D1073741824, pinned=3D0, delalloc=3D=
0, may_use=3D0, use
> d=3D61636608, root=3D0, super=3D0, reserved=3D0
> [11517.740046] block group 29360128 has 1073741824 bytes, 61636608 us=
ed 0 pinned
>  0 reserved
> [11517.740048] block group has cluster?: no
> [11517.740049] 0 blocks of free space at or bigger than bytes is
> [11517.740085] kernel BUG at fs/btrfs/transaction.c:1047!
> [11517.740087] invalid opcode: 0000 [#1] SMP
> [11517.740089] last sysfs file: /sys/block/sdc/size
> [11517.740091] CPU 0
> [11517.740092] Modules linked in: nfnetlink_queue nfnetlink nvidia(P)=
 xt_multipo
> rt nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT xt_tcpudp iptable_filt=
er ip_table
> s xt_iprange xt_state nf_conntrack xt_mark xt_NFQUEUE x_tables
> dvbloopback ppdev lp ipv6 nfs reiserfs fuse usb_storage btrfs
> zlib_deflate crc32c libcrc32c dvb_usb_dib0700 dib7000p dib7000m
> dib0070 dvb_usb mt2266 tuner_xc2028 dib8000 dib3000mc dibx000_common
> mxl5007t xc5000 s5h1411 mt2060 lgdt3305 dvb_core nfsd lockd nfs_acl
> auth_rpcgss sunrpc exportfs loop snd_hda_codec_realtek snd_hda_intel
> snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy
> snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq
> snd_timer snd_seq_device i2c_i801 r8169 thermal psmouse snd parport_p=
c
> parport iTCO_wdt jmicron button mii i2c_core evdev ehci_hcd processor
> soundcore serio_raw floppy uhci_hcd thermal_sys snd_page_alloc pcspkr
> sr_mod
> [11517.740134] Pid: 4582, comm: btrfs-vol Tainted: P
> 2.6.32.3 #3 EP43-S3L
> [11517.740136] RIP: 0010:[<ffffffffa031b903>]  [<ffffffffa031b903>]
> btrfs_commit_transaction+0x693/0x6c0 [btrfs]
> [11517.740147] RSP: 0018:ffff8801b5063c68  EFLAGS: 00010286
> [11517.740149] RAX: 00000000ffffffe4 RBX: ffff8801b5b3fe10 RCX: 00000=
00000000016
> [11517.740151] RDX: 0000000000000000 RSI: ffff8801b5063be8 RDI: ffff8=
800af168060
> [11517.740152] RBP: ffff8801b5b3fe10 R08: 0000000000000000 R09: ffff8=
80235063727
> [11517.740154] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8=
800ae211800
> [11517.740155] R13: ffff8801b5b3feb0 R14: 0000000000000001 R15: 00000=
00000000001
> [11517.740157] FS:  00007f40569a2730(0000) GS:ffff880028200000(0000)
> knlGS:0000000000000000
> [11517.740159] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [11517.740161] CR2: 00007f405632e000 CR3: 00000001b5495000 CR4: 00000=
000000406f0
> [11517.740162] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> [11517.740164] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000=
00000000400
> [11517.740169] Process btrfs-vol (pid: 4582, threadinfo
> ffff8801b5062000, task ffff8800bf1e6c90)
> [11517.740170] Stack:
> [11517.740171]  ffff8801c27534e0 ffff8801b5b3fe80 0000000000000000
> 00000000a033dedc
> [11517.740173] <0> 0000000000000000 ffff8800bf1e6c90 ffffffff8105c170
> ffff8801b5063ca0
> [11517.740176] <0> ffff8801b5063ca0 0000006200000100 ffff8800aea54800
> ffff88022ba4ab40
> [11517.740179] Call Trace:
> [11517.740184]  [<ffffffff8105c170>] ? autoremove_wake_function+0x0/0=
x30
> [11517.740197]  [<ffffffffa0342509>] ? btrfs_init_new_device+0x6e9/0x=
b50 [btrfs]
> [11517.740201]  [<ffffffff8108f852>] ? __generic_file_aio_write+0x292=
/0x490
> [11517.740204]  [<ffffffff8108d92b>] ? find_get_page+0x1b/0xb0
> [11517.740206]  [<ffffffff8108f1b8>] ? filemap_fault+0xb8/0x400
> [11517.740212]  [<ffffffffa0345aea>] ? btrfs_ioctl+0x66a/0xa80 [btrfs=
]
> [11517.740216]  [<ffffffff810d0cbf>] ? vfs_ioctl+0x2f/0xb0
> [11517.740218]  [<ffffffff810d0e70>] ? do_vfs_ioctl+0x90/0x5d0
> [11517.740221]  [<ffffffff810d13f9>] ? sys_ioctl+0x49/0x80
> [11517.740224]  [<ffffffff81362ebf>] ? page_fault+0x1f/0x30
> [11517.740227]  [<ffffffff8100b52b>] ? system_call_fastpath+0x16/0x1b
> [11517.740228] Code: 44 5e 04 e1 e9 98 fe ff ff be d9 03 00 00 48 c7
> c7 de 86 35 a0 e8 7e a7 d2 e0 e9 ca fa ff ff 0f 0b eb fe 0f 0b eb fe
> 0f 0b eb fe <0f> 0b eb fe 0f 0b eb fe 0f 0b eb fe be 05 04 00 00 48 c=
7
> c7 de
> [11517.740250] RIP  [<ffffffffa031b903>]
> btrfs_commit_transaction+0x693/0x6c0 [btrfs]
> [11517.740258]  RSP <ffff8801b5063c68>
> [11517.740260] ---[ end trace 272159a0659829e1 ]---
>=20
>=20
> I use a 2.6.32.3 kernel and btrfs claims to be v0.19-4-gab8fb4c. A
> very similar bug was reported on 2.6.30 a while back, so I wonder if
> anyone is looking at this already? Is this supposed to work or is it =
a
> known problem?
>=20
> BTW I also tried to remove the device from the array with btrfs-vol
> -r, but it refuses to go below two devices on raid 1.
>

Thanks for the report, I've just posted 3 patches to resolve various is=
sues,
including this problem you've posted.  Please give them a try and let m=
e know if
you have any problems.  Thanks,

Josef=20
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
