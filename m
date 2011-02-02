From: "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: Re: btrfs bug in 2.6.37
Date: Wed, 2 Feb 2011 16:35:15 +0100
Message-ID: <20110202153515.GA4010@Pilar.site>
References: <20110201215159.GA1897@Pilar.site>
 <AANLkTik2+wcPgPx28Mnh4yQuLww0N-CRPc2KtJrbeVph@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTik2+wcPgPx28Mnh4yQuLww0N-CRPc2KtJrbeVph@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Di  1.Feb'11 at 16:25:11 -0600, cwillu wrote:
> On Tue, Feb 1, 2011 at 3:51 PM, Carlos R. Mafra <crmafra2@gmail.com> =
wrote:
> >
> > I am running 2.6.37 plus the revert of bf9dc102e284 (which is relat=
ed to drm).
> >
> > My /home is on btrfs as well as a 1TB external USB hard-disk.
> >
> > I was compiling 2.6.38-rc3 from /home/mafra/linux2.6 using
> > the external hd as the destination of the compiled files:
> >
> > make -j4 O=3D/mnt/wd/kernel-compile
> >
> > So after some time I got this bug and I was dropped out of X
> >
> > [ 2730.943101] BUG: unable to handle kernel NULL pointer dereferenc=
e at 0000000000000030
> > [ 2730.943159] IP: [<ffffffff811ba3e5>] btrfs_print_leaf+0x25/0x820
> > [ 2730.943217] PGD 2248f067 PUD 5adc8067 PMD 0
> > [ 2730.943256] Oops: 0000 [#1] SMP
> > [ 2730.943285] last sysfs file: /sys/devices/system/cpu/cpu0/cpufre=
q/scaling_cur_freq
> > [ 2730.943331] CPU 0
> > [ 2730.943346] Modules linked in: ppp_deflate ppp_async ppp_generic=
 slhc snd_seq snd_seq_device vfat fat option usb_wwan usbserial snd_hda=
_codec_idt snd_hda_intel iwlagn snd_hda_codec sky2 uvcvideo i2c_i801 sn=
d_hwdep evdev
> > [ 2730.943526]
> > [ 2730.943541] Pid: 15437, comm: as Not tainted 2.6.37-xrandr-00001=
-g1d95a75 #16 VAIO/VGN-FZ240E
> > [ 2730.943581] RIP: 0010:[<ffffffff811ba3e5>] =C2=A0[<ffffffff811ba=
3e5>] btrfs_print_leaf+0x25/0x820
> > [ 2730.943629] RSP: 0000:ffff88005a771ad8 =C2=A0EFLAGS: 00010287
> > [ 2730.943661] RAX: 00000000fffffffb RBX: ffff88005b048d90 RCX: fff=
f880037f49d38
> > [ 2730.943695] RDX: 0000000000000000 RSI: 0000000000000000 RDI: fff=
f88004d456000
> > [ 2730.943729] RBP: ffff88005a771b58 R08: 00000000fffffffb R09: 000=
0000000000000
> > [ 2730.943763] R10: 0000000000000001 R11: 00000000ffffffff R12: 000=
0000000000005
> > [ 2730.943797] R13: ffff88005a771fd8 R14: 0000000000000000 R15: 000=
0000000000000
> > [ 2730.943831] FS: =C2=A000002b01b9f88000(0000) GS:ffff88007f400000=
(0000) knlGS:0000000000000000
> > [ 2730.943872] CS: =C2=A00010 DS: 0000 ES: 0000 CR0: 00000000800500=
3b
> > [ 2730.943901] CR2: 0000000000000030 CR3: 000000006161c000 CR4: 000=
00000000006f0
> > [ 2730.943934] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000=
0000000000000
> > [ 2730.943968] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000=
0000000000400
> > [ 2730.944002] Process as (pid: 15437, threadinfo ffff88005a770000,=
 task ffff88002ffea680)
> > [ 2730.944009] Stack:
> > [ 2730.944009] =C2=A00000001cc7d27000 ffffffff811e4724 ffff88004d45=
6000 0000001cc7784000
> > [ 2730.944009] =C2=A0ffff88005a771b58 ffff88005b048d90 0000001cc7d2=
7000 00000000005000a8
> > [ 2730.944009] =C2=A0ffff8800491a0e00 ffff88006c2de6c0 000000000000=
0005 ffff88005b048d90
> > [ 2730.944009] Call Trace:
> > [ 2730.944009] =C2=A0[<ffffffff811e4724>] ? set_extent_dirty+0x24/0=
x30
> > [ 2730.944009] =C2=A0[<ffffffff811b30dd>] __btrfs_free_extent+0x61d=
/0x6e0
> > [ 2730.944009] =C2=A0[<ffffffff811b635b>] run_clustered_refs+0x1fb/=
0x810
> > [ 2730.944009] =C2=A0[<ffffffff811e7bda>] ? set_extent_buffer_dirty=
+0x4a/0xa0
> > [ 2730.944009] =C2=A0[<ffffffff811c342f>] ? btrfs_mark_buffer_dirty=
+0xaf/0x130
> > [ 2730.944009] =C2=A0[<ffffffff81201100>] ? btrfs_find_ref_cluster+=
0x60/0x190
> > [ 2730.944009] =C2=A0[<ffffffff811b6a30>] btrfs_run_delayed_refs+0x=
c0/0x210
> > [ 2730.944009] =C2=A0[<ffffffff811c55b8>] __btrfs_end_transaction+0=
x68/0x240
> > [ 2730.944009] =C2=A0[<ffffffff811c57d0>] btrfs_end_transaction+0x1=
0/0x20
> > [ 2730.944009] =C2=A0[<ffffffff811ced57>] btrfs_evict_inode+0x1c7/0=
x1e0
> > [ 2730.944009] =C2=A0[<ffffffff810fa8c2>] evict+0x22/0xb0
> > [ 2730.944009] =C2=A0[<ffffffff810fb141>] iput+0x1b1/0x290
> > [ 2730.944009] =C2=A0[<ffffffff810f14f5>] do_unlinkat+0x115/0x1c0
> > [ 2730.944009] =C2=A0[<ffffffff810e94ae>] ? sys_newlstat+0x2e/0x40
> > [ 2730.944009] =C2=A0[<ffffffff810f2af1>] sys_unlink+0x11/0x20
> > [ 2730.944009] =C2=A0[<ffffffff81002cfb>] system_call_fastpath+0x16=
/0x1b
> > [ 2730.944009] Code: 84 00 00 00 00 00 55 48 89 e5 48 83 c4 80 48 8=
9 5d d8 4c 89 6d e8 4c 89 65 e0 4c 89 75 f0 4c 89 7d f8 65 4c 8b 2c 25 =
88 b5 00 00 <48> 8b 46 30 49 81 ed d8 1f 00 00 48 89 f3 41 ff 45 1c 48 =
ba 00
> > [ 2730.944009] RIP =C2=A0[<ffffffff811ba3e5>] btrfs_print_leaf+0x25=
/0x820
> > [ 2730.944009] =C2=A0RSP <ffff88005a771ad8>
> > [ 2730.944009] CR2: 0000000000000030
> > [ 2730.950886] ---[ end trace 3c2d14569018819f ]---
> > [ 2731.229129] BUG: unable to handle kernel NULL pointer dereferenc=
e at 0000000000000030
> > [ 2731.230010] IP: [<ffffffff811ba3e5>] btrfs_print_leaf+0x25/0x820
> > [ 2731.230010] PGD 22623067 PUD 2278d067 PMD 0
> > [ 2731.230010] Oops: 0000 [#2] SMP
> > [ 2731.230010] last sysfs file: /sys/devices/system/cpu/cpu0/cpufre=
q/scaling_cur_freq
> > [ 2731.230010] CPU 1
> > [ 2731.230010] Modules linked in: ppp_deflate ppp_async ppp_generic=
 slhc snd_seq snd_seq_device vfat fat option usb_wwan usbserial snd_hda=
_codec_idt snd_hda_intel iwlagn snd_hda_codec sky2 uvcvideo i2c_i801 sn=
d_hwdep evdev
> > [ 2731.230010]
> > [ 2731.230010] Pid: 15444, comm: as Tainted: G =C2=A0 =C2=A0 =C2=A0=
D =C2=A0 =C2=A0 2.6.37-xrandr-00001-g1d95a75 #16 VAIO/VGN-FZ240E
> > [ 2731.230010] RIP: 0010:[<ffffffff811ba3e5>] =C2=A0[<ffffffff811ba=
3e5>] btrfs_print_leaf+0x25/0x820
> > [ 2731.230010] RSP: 0000:ffff88004d42dad8 =C2=A0EFLAGS: 00010287
> > [ 2731.230010] RAX: 00000000fffffffb RBX: ffff88005b048b50 RCX: fff=
f880037f49d38
> > [ 2731.230010] RDX: 0000000000000000 RSI: 0000000000000000 RDI: fff=
f88004d456000
> > [ 2731.230010] RBP: ffff88004d42db58 R08: 00000000fffffffb R09: 000=
0000000000000
> > [ 2731.230010] R10: 0000000000000001 R11: 00000000ffffffff R12: 000=
0000000000005
> > [ 2731.230010] R13: ffff88004d42dfd8 R14: 0000000000000000 R15: 000=
0000000000000
> > [ 2731.230010] FS: =C2=A000002aac5cec6000(0000) GS:ffff88007f500000=
(0000) knlGS:0000000000000000
> > [ 2731.230010] CS: =C2=A00010 DS: 0000 ES: 0000 CR0: 00000000800500=
3b
> > [ 2731.230010] CR2: 0000000000000030 CR3: 00000000226af000 CR4: 000=
00000000006e0
> > [ 2731.230010] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000=
0000000000000
> > [ 2731.230010] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000=
0000000000400
> > [ 2731.230010] Process as (pid: 15444, threadinfo ffff88004d42c000,=
 task ffff88007b69e280)
> > [ 2731.230010] Stack:
> > [ 2731.230010] =C2=A00000001cc7d2c000 ffffffff811dd7c5 ffff88004d45=
6000 ffff8800218b8898
> > [ 2731.230010] =C2=A0ffff88004d42dba8 ffff88005b048b50 0000001cc7d2=
c000 00000000005000a8
> > [ 2731.230010] =C2=A0ffff88004d42db00 ffff88005a5e5cc0 000000000000=
0005 ffff88005b048b50
> > [ 2731.230010] Call Trace:
> > [ 2731.230010] =C2=A0[<ffffffff811dd7c5>] ? btrfs_key_generation+0x=
e5/0xf0
> > [ 2731.230010] =C2=A0[<ffffffff811b30dd>] __btrfs_free_extent+0x61d=
/0x6e0
> > [ 2731.230010] =C2=A0[<ffffffff811e7bda>] ? set_extent_buffer_dirty=
+0x4a/0xa0
> > [ 2731.230010] =C2=A0[<ffffffff811c342f>] ? btrfs_mark_buffer_dirty=
+0xaf/0x130
> > [ 2731.230010] =C2=A0[<ffffffff811b635b>] run_clustered_refs+0x1fb/=
0x810
> > [ 2731.230010] =C2=A0[<ffffffff81201100>] ? btrfs_find_ref_cluster+=
0x60/0x190
> > [ 2731.230010] =C2=A0[<ffffffff811b6a30>] btrfs_run_delayed_refs+0x=
c0/0x210
> > [ 2731.230010] =C2=A0[<ffffffff811c55b8>] __btrfs_end_transaction+0=
x68/0x240
> > [ 2731.230010] =C2=A0[<ffffffff811c57d0>] btrfs_end_transaction+0x1=
0/0x20
> > [ 2731.230010] =C2=A0[<ffffffff811ced1f>] btrfs_evict_inode+0x18f/0=
x1e0
> > [ 2731.230010] =C2=A0[<ffffffff810fa8c2>] evict+0x22/0xb0
> > [ 2731.230010] =C2=A0[<ffffffff810fb141>] iput+0x1b1/0x290
> > [ 2731.230010] =C2=A0[<ffffffff810f14f5>] do_unlinkat+0x115/0x1c0
> > [ 2731.230010] =C2=A0[<ffffffff810e94ae>] ? sys_newlstat+0x2e/0x40
> > [ 2731.230010] =C2=A0[<ffffffff810f2af1>] sys_unlink+0x11/0x20
> > [ 2731.230010] =C2=A0[<ffffffff81002cfb>] system_call_fastpath+0x16=
/0x1b
> > [ 2731.230010] Code: 84 00 00 00 00 00 55 48 89 e5 48 83 c4 80 48 8=
9 5d d8 4c 89 6d e8 4c 89 65 e0 4c 89 75 f0 4c 89 7d f8 65 4c 8b 2c 25 =
88 b5 00 00 <48> 8b 46 30 49 81 ed d8 1f 00 00 48 89 f3 41 ff 45 1c 48 =
ba 00
> > [ 2731.230010] RIP =C2=A0[<ffffffff811ba3e5>] btrfs_print_leaf+0x25=
/0x820
> > [ 2731.230010] =C2=A0RSP <ffff88004d42dad8>
> > [ 2731.230010] CR2: 0000000000000030
> > [ 2731.304076] ---[ end trace 3c2d1456901881a0 ]---
> > [ 2731.778512] BUG: unable to handle kernel NULL pointer dereferenc=
e at 0000000000000030
> > [ 2731.779007] IP: [<ffffffff811ba3e5>] btrfs_print_leaf+0x25/0x820
> > [ 2731.779007] PGD 2ffa8067 PUD 5a93d067 PMD 0
> > [ 2731.779007] Oops: 0000 [#3] SMP
> > [ 2731.779007] last sysfs file: /sys/devices/system/cpu/cpu0/cpufre=
q/scaling_cur_freq
> > [ 2731.779007] CPU 0
> > [ 2731.779007] Modules linked in: ppp_deflate ppp_async ppp_generic=
 slhc snd_seq snd_seq_device vfat fat option usb_wwan usbserial snd_hda=
_codec_idt snd_hda_intel iwlagn snd_hda_codec sky2 uvcvideo i2c_i801 sn=
d_hwdep evdev
> > [ 2731.779007]
> > [ 2731.779007] Pid: 15448, comm: as Tainted: G =C2=A0 =C2=A0 =C2=A0=
D =C2=A0 =C2=A0 2.6.37-xrandr-00001-g1d95a75 #16 VAIO/VGN-FZ240E
> > [ 2731.779007] RIP: 0010:[<ffffffff811ba3e5>] =C2=A0[<ffffffff811ba=
3e5>] btrfs_print_leaf+0x25/0x820
> > [ 2731.779007] RSP: 0018:ffff8800227c5ad8 =C2=A0EFLAGS: 00010287
> > [ 2731.779007] RAX: 00000000fffffffb RBX: ffff88005b048c70 RCX: fff=
f880021f9fd38
> > [ 2731.779007] RDX: 0000000000000000 RSI: 0000000000000000 RDI: fff=
f88004d456000
> > [ 2731.779007] RBP: ffff8800227c5b58 R08: 00000000fffffffb R09: 000=
0000000000000
> > [ 2731.779007] R10: 0000000000000001 R11: 00000000ffffffff R12: 000=
0000000000005
> > [ 2731.779007] R13: ffff8800227c5fd8 R14: 0000000000000000 R15: 000=
0000000000000
> > [ 2731.779007] FS: =C2=A000002b0f18c8e000(0000) GS:ffff88007f400000=
(0000) knlGS:0000000000000000
> > [ 2731.779007] CS: =C2=A00010 DS: 0000 ES: 0000 CR0: 00000000800500=
3b
> > [ 2731.779007] CR2: 0000000000000030 CR3: 000000006c0b5000 CR4: 000=
00000000006f0
> > [ 2731.779007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000=
0000000000000
> > [ 2731.779007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000=
0000000000400
> > [ 2731.779007] Process as (pid: 15448, threadinfo ffff8800227c4000,=
 task ffff88003acfc5c0)
> > [ 2731.779007] Stack:
> > [ 2731.779007] =C2=A00000001cc7d3c000 ffffffff811dd7c5 ffff88004d45=
6000 ffff8800218b21f0
> > [ 2731.779007] =C2=A0ffff8800227c5ba8 ffff88005b048c70 0000001cc7d3=
c000 00000000005000a8
> > [ 2731.779007] =C2=A0ffff8800227c5b00 ffff88007229ea40 000000000000=
0005 ffff88005b048c70
> > [ 2731.779007] Call Trace:
> > [ 2731.779007] =C2=A0[<ffffffff811dd7c5>] ? btrfs_key_generation+0x=
e5/0xf0
> > [ 2731.779007] =C2=A0[<ffffffff811b30dd>] __btrfs_free_extent+0x61d=
/0x6e0
> > [ 2731.779007] =C2=A0[<ffffffff811dd9b4>] ? btrfs_item_offset+0xe4/=
0xf0
> > [ 2731.779007] =C2=A0[<ffffffff811b635b>] run_clustered_refs+0x1fb/=
0x810
> > [ 2731.779007] =C2=A0[<ffffffff811e7bda>] ? set_extent_buffer_dirty=
+0x4a/0xa0
> > [ 2731.779007] =C2=A0[<ffffffff811c342f>] ? btrfs_mark_buffer_dirty=
+0xaf/0x130
> > [ 2731.779007] =C2=A0[<ffffffff81201100>] ? btrfs_find_ref_cluster+=
0x60/0x190
> > [ 2731.779007] =C2=A0[<ffffffff811b6a30>] btrfs_run_delayed_refs+0x=
c0/0x210
> > [ 2731.779007] =C2=A0[<ffffffff811c55b8>] __btrfs_end_transaction+0=
x68/0x240
> > [ 2731.779007] =C2=A0[<ffffffff811c57d0>] btrfs_end_transaction+0x1=
0/0x20
> > [ 2731.779007] =C2=A0[<ffffffff811ced57>] btrfs_evict_inode+0x1c7/0=
x1e0
> > [ 2731.779007] =C2=A0[<ffffffff810fa8c2>] evict+0x22/0xb0
> > [ 2731.779007] =C2=A0[<ffffffff810fb141>] iput+0x1b1/0x290
> > [ 2731.779007] =C2=A0[<ffffffff810f14f5>] do_unlinkat+0x115/0x1c0
> > [ 2731.779007] =C2=A0[<ffffffff810e94ae>] ? sys_newlstat+0x2e/0x40
> > [ 2731.779007] =C2=A0[<ffffffff810f2af1>] sys_unlink+0x11/0x20
> > [ 2731.779007] =C2=A0[<ffffffff81002cfb>] system_call_fastpath+0x16=
/0x1b
> > [ 2731.779007] Code: 84 00 00 00 00 00 55 48 89 e5 48 83 c4 80 48 8=
9 5d d8 4c 89 6d e8 4c 89 65 e0 4c 89 75 f0 4c 89 7d f8 65 4c 8b 2c 25 =
88 b5 00 00 <48> 8b 46 30 49 81 ed d8 1f 00 00 48 89 f3 41 ff 45 1c 48 =
ba 00
> > [ 2731.779007] RIP =C2=A0[<ffffffff811ba3e5>] btrfs_print_leaf+0x25=
/0x820
> > [ 2731.779007] =C2=A0RSP <ffff8800227c5ad8>
> > [ 2731.779007] CR2: 0000000000000030
> > [ 2731.855520] ---[ end trace 3c2d1456901881a1 ]---
> > [ 2732.101887] btrfs csum failed ino 244904 extent 124692799488 csu=
m 4201110721 wanted 126609361 mirror 0
> > [ 2732.102064] btrfs csum failed ino 244904 extent 124692799488 csu=
m 2566472073 wanted 126609361 mirror 1
> > [ 2732.102084] btrfs csum failed ino 244904 extent 124692799488 csu=
m 2566472073 wanted 126609361 mirror 1
> > [ 2732.102102] btrfs csum failed ino 244904 extent 124692799488 csu=
m 2566472073 wanted 126609361 mirror 1
> > [ 2732.102121] btrfs csum failed ino 244904 extent 124692799488 csu=
m 2566472073 wanted 126609361 mirror 1
> > [ 2732.102139] btrfs csum failed ino 244904 extent 124692799488 csu=
m 2566472073 wanted 126609361 mirror 1
> > [ 2732.102158] btrfs csum failed ino 244904 extent 124692799488 csu=
m 2566472073 wanted 126609361 mirror 1
> > [ 2732.102176] btrfs csum failed ino 244904 extent 124692799488 csu=
m 2566472073 wanted 126609361 mirror 1
> > [ 2732.102195] btrfs csum failed ino 244904 extent 124692799488 csu=
m 2566472073 wanted 126609361 mirror 1
> > [ 2732.102213] btrfs csum failed ino 244904 extent 124692799488 csu=
m 2566472073 wanted 126609361 mirror 1
> > [ 2732.102231] btrfs csum failed ino 244904 extent 124692799488 csu=
m 2566472073 wanted 126609361 mirror 1
> > [ 2732.102250] btrfs csum failed ino 244904 extent 124692799488 csu=
m 2566472073 wanted 126609361 mirror 1
> > [ 2732.103048] btrfs csum failed ino 244904 extent 124692799488 csu=
m 2566472073 wanted 126609361 mirror 0
> > [ 2732.103086] btrfs csum failed ino 244904 extent 124692799488 csu=
m 2566472073 wanted 126609361 mirror 1
> > [ 2738.344564] btrfs csum failed ino 244835 extent 124686446592 csu=
m 4201110721 wanted 3023272677 mirror 0
> > [ 2738.344662] btrfs csum failed ino 244835 extent 124686446592 csu=
m 2566472073 wanted 3023272677 mirror 1
> > [ 2738.344683] btrfs csum failed ino 244835 extent 124686446592 csu=
m 4201110721 wanted 3023272677 mirror 1
> > [ 2738.344702] btrfs csum failed ino 244835 extent 124686446592 csu=
m 2566472073 wanted 3023272677 mirror 1
> > [ 2738.344729] btrfs csum failed ino 244835 extent 124686446592 csu=
m 2566472073 wanted 3023272677 mirror 1
> > [ 2738.344748] btrfs csum failed ino 244835 extent 124686446592 csu=
m 2566472073 wanted 3023272677 mirror 1
> > [ 2738.344752] btrfs csum failed ino 244835 extent 124686446592 csu=
m 2566472073 wanted 3023272677 mirror 1
> > [ 2738.344768] btrfs csum failed ino 244835 extent 124686446592 csu=
m 2566472073 wanted 3023272677 mirror 1
> > [ 2738.344772] btrfs csum failed ino 244835 extent 124686446592 csu=
m 2566472073 wanted 3023272677 mirror 1
> > [ 2738.344792] btrfs csum failed ino 244835 extent 124686446592 csu=
m 2566472073 wanted 3023272677 mirror 1
> > [ 2738.344823] btrfs csum failed ino 244835 extent 124686446592 csu=
m 2566472073 wanted 3023272677 mirror 1
> > [ 2738.344843] btrfs csum failed ino 244835 extent 124686446592 csu=
m 2566472073 wanted 3023272677 mirror 1
> > [ 2738.344862] btrfs csum failed ino 244835 extent 124686446592 csu=
m 2566472073 wanted 3023272677 mirror 1
> > [ 2738.344884] btrfs csum failed ino 244835 extent 124686446592 csu=
m 2566472073 wanted 3023272677 mirror 0
> > [ 2738.344932] btrfs csum failed ino 244835 extent 124686446592 csu=
m 2566472073 wanted 3023272677 mirror 1
> >
> >
> > Is this problem already known?
>=20
> Was there anything else before the first bug in dmesg?  I would
> predict there to have been some additional debugging info, and
> probably a USB device disconnect or similar.

Thanks a lot, cwillu!

Indeed there were USB-related errors a bit before the BUG. I thought th=
ey
were related to the usb surfstick I was using, which was quite unstable=
 and
disconnecting.

[ 2725.465125] usb 2-2: reset high speed USB device using ehci_hcd and =
address 23
[ 2725.589040] usb 2-2: device descriptor read/64, error -71
[ 2725.964048] usb 2-2: device descriptor read/64, error -71
[ 2726.167037] usb 2-2: reset high speed USB device using ehci_hcd and =
address 23
[ 2726.680029] usb 2-2: device not accepting address 23, error -71
[ 2726.782042] usb 2-2: reset high speed USB device using ehci_hcd and =
address 23
[ 2727.192028] usb 2-2: device not accepting address 23, error -71
[ 2727.294050] usb 2-2: reset high speed USB device using ehci_hcd and =
address 23
[ 2727.704034] usb 2-2: device not accepting address 23, error -71
[ 2727.704074] usb 2-2: USB disconnect, address 23
[ 2727.704120] sd 18:0:0:0: [sdc] Unhandled error code
[ 2727.704123] sd 18:0:0:0: [sdc]  Result: hostbyte=3D0x07 driverbyte=3D=
0x00
[ 2727.704126] sd 18:0:0:0: [sdc] CDB: cdb[0]=3D0x2a: 2a 00 18 db 83 a0=
 00 00 20 00
[ 2727.704135] end_request: I/O error, dev sdc, sector 417039264
[ 2727.704154] sd 18:0:0:0: [sdc] Unhandled error code
[ 2727.704156] sd 18:0:0:0: [sdc]  Result: hostbyte=3D0x01 driverbyte=3D=
0x00
[ 2727.704159] sd 18:0:0:0: [sdc] CDB: cdb[0]=3D0x2a: 2a 00 18 db 83 c0=
 00 00 38 00
[ 2727.704167] end_request: I/O error, dev sdc, sector 417039296
[ 2727.812050] usb 2-2: new high speed USB device using ehci_hcd and ad=
dress 24
[ 2727.926040] usb 2-2: device descriptor read/64, error -71
[ 2728.154579] scsi19 : usb-storage 2-2:1.0
[ 2729.167448] scsi 19:0:0:0: Direct-Access     WD       Elements 1023 =
   2005 PQ: 0 ANSI: 4
[ 2729.167769] sd 19:0:0:0: Attached scsi generic sg4 type 0
[ 2729.169305] sd 19:0:0:0: [sdd] 1953519616 512-byte logical blocks: (=
1.00 TB/931 GiB)
[ 2729.170174] sd 19:0:0:0: [sdd] Test WP failed, assume Write Enabled
[ 2729.170179] sd 19:0:0:0: [sdd] Assuming drive cache: write through
[ 2729.171920] sd 19:0:0:0: [sdd] Test WP failed, assume Write Enabled
[ 2729.171923] sd 19:0:0:0: [sdd] Assuming drive cache: write through
[ 2729.200964]  sdd: sdd1
[ 2729.203180] sd 19:0:0:0: [sdd] Test WP failed, assume Write Enabled
[ 2729.203185] sd 19:0:0:0: [sdd] Assuming drive cache: write through
[ 2729.203189] sd 19:0:0:0: [sdd] Attached SCSI disk
[ 2730.943101] BUG: unable to handle kernel NULL pointer dereference at=
 0000000000000030
[ 2730.943159] IP: [<ffffffff811ba3e5>] btrfs_print_leaf+0x25/0x820

> If I'm correct, there was an io error while writing to the external
> device, which as of 2.6.37 isn't handled terribly well (and errors in
> general; in that sense, it's known).

Ok, now I am moving to 2.6.38-rc3 and I'll pay attention to usb failure=
s
before reporting anything.

Thanks again!
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
