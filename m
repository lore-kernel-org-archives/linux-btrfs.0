From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: btrfs corruption after cp --reflink
Date: Sat, 8 Oct 2011 22:22:20 +0200
Message-ID: <CAMthOuMfOvUXikMw9ZoBDcSDpX2jrPgzm5ZU7Ddjv8gRkcRDVg@mail.gmail.com>
References: <CAMthOuMwb-ibGGzve_ntoqBcdK73UgjFP92AgCyGDu9jyX0bog@mail.gmail.com>
	<CAMthOuNb=EO5QiXUzK5DN3oc5JTrv=NUwRbSQsy0fSa0QAxQLw@mail.gmail.com>
	<CAMthOuNb=MGQNz8X=OA0G_ApWWxBA8HnuHv_MPt7sQZ-tB8n_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAMthOuNb=MGQNz8X=OA0G_ApWWxBA8HnuHv_MPt7sQZ-tB8n_Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello again!

> [ 637.345296] BUG: unable to handle kernel NULL pointer dereference at 0000001c
> [ 637.345306] IP: [<c1142c2f>] btrfs_print_leaf+0xd/0x886

I tried to fix this by returning from this function when "l" is null
like this guy did:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg10697.html

But now I get:

[  397.416733] parent transid verify failed on 641086169088 wanted
43863 found 43873
[  397.417015] parent transid verify failed on 641086169088 wanted
43863 found 43873
[  397.417289] parent transid verify failed on 641086169088 wanted
43863 found 43873
[  397.424886] parent transid verify failed on 641086169088 wanted
43863 found 43873
[  397.424895] parent transid verify failed on 641086169088 wanted
43863 found 43873
[  397.424900] ------------[ cut here ]------------
[  397.424910] WARNING: at fs/btrfs/extent-tree.c:4462
__btrfs_free_extent+0x3a6/0x7e3()
[  397.424913] Hardware name:
[  397.424915] Modules linked in: af_packet vmnet vmblock vsock vmci
vmmon lm90 it87 hwmon_vid hwmon fuse bnep rfcomm snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
reiserfs zram(C) mperf loop emu10k1_gp sidewinder joydev nfs lockd
auth_rpcgss nfs_acl sunrpc ipv6 tcp_cubic nvidia(P) snd_usb_audio
snd_usbmidi_lib usb_storage gspca_sonixj usbhid sr_mod gspca_main hid
cdrom videodev uas sg 8250_pnp btusb firewire_ohci i82875p_edac
ne2k_pci 8390 bluetooth analog e1000 firewire_core ns558 gameport 8250
serial_core parport_pc i2c_i801 pcspkr snd_mpu401 floppy edac_core
crc_itu_t crc16 evdev fan intel_agp processor button thermal parport
snd_mpu401_uart intel_gtt agpgart unix [last unloaded: microcode]
[  397.424997] Pid: 3873, comm: rm Tainted: P       A C  3.0.6-gentoo #2
[  397.425000] Call Trace:
[  397.425008]  [<c1028cec>] ? warn_slowpath_common+0x7c/0x8f
[  397.425012]  [<c113b7f0>] ? __btrfs_free_extent+0x3a6/0x7e3
[  397.425016]  [<c113b7f0>] ? __btrfs_free_extent+0x3a6/0x7e3
[  397.425021]  [<c1028d1a>] ? warn_slowpath_null+0x1b/0x1f
[  397.425025]  [<c113b7f0>] ? __btrfs_free_extent+0x3a6/0x7e3
[  397.425031]  [<c1096332>] ? kfree+0x13/0x90
[  397.425035]  [<c11857d0>] ? btrfs_delayed_ref_lock+0x2c/0x74
[  397.425040]  [<c113e805>] ? run_clustered_refs+0x826/0x869
[  397.425046]  [<c113681b>] ? btrfs_del_items+0x2f2/0x2fc
[  397.425050]  [<c113e909>] ? btrfs_run_delayed_refs+0xc1/0x144
[  397.425055]  [<c114d8a8>] ? __btrfs_end_transaction+0x70/0x19b
[  397.425059]  [<c114da29>] ? btrfs_end_transaction+0x11/0x15
[  397.425064]  [<c115756d>] ? btrfs_evict_inode+0x1ce/0x1e5
[  397.425068]  [<c10ac392>] ? evict+0x52/0xe1
[  397.425073]  [<c10a580c>] ? do_unlinkat+0xca/0x10a
[  397.425078]  [<c10c0e00>] ? fsnotify_find_inode_mark+0x17/0x1d
[  397.425083]  [<c109aa57>] ? filp_close+0x56/0x5f
[  397.425089]  [<c1352093>] ? sysenter_do_call+0x12/0x22
[  397.425092] ---[ end trace b71c480eb63758b5 ]---
[  397.425096] btrfs unable to find ref byte nr 1271613026304 parent 0
root 256  owner 445125 offset 2097152
[  397.425108] BUG: unable to handle kernel NULL pointer dereference at 0000000c
[  397.425114] IP: [<c1164530>] btrfs_item_size+0xe/0xb0
[  397.425122] *pde = 00000000
[  397.425125] Oops: 0000 [#1] SMP
[  397.425129] Modules linked in: af_packet vmnet vmblock vsock vmci
vmmon lm90 it87 hwmon_vid hwmon fuse bnep rfcomm snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
reiserfs zram(C) mperf loop emu10k1_gp sidewinder joydev nfs lockd
auth_rpcgss nfs_acl sunrpc ipv6 tcp_cubic nvidia(P) snd_usb_audio
snd_usbmidi_lib usb_storage gspca_sonixj usbhid sr_mod gspca_main hid
cdrom videodev uas sg 8250_pnp btusb firewire_ohci i82875p_edac
ne2k_pci 8390 bluetooth analog e1000 firewire_core ns558 gameport 8250
serial_core parport_pc i2c_i801 pcspkr snd_mpu401 floppy edac_core
crc_itu_t crc16 evdev fan intel_agp processor button thermal parport
snd_mpu401_uart intel_gtt agpgart unix [last unloaded: microcode]
[  397.425200]
[  397.425204] Pid: 3873, comm: rm Tainted: P       AWC  3.0.6-gentoo
#2    /8KNXP
[  397.425210] EIP: 0060:[<c1164530>] EFLAGS: 00010292 CPU: 1
[  397.425214] EIP is at btrfs_item_size+0xe/0xb0
[  397.425217] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000065
[  397.425221] ESI: 00000065 EDI: f4c3dd90 EBP: 0000007a ESP: f4a75d1c
[  397.425224]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  397.425228] Process rm (pid: 3873, ti=f4a74000 task=f4b06000
task.ti=f4a74000)
[  397.425230] Stack:
[  397.425232]  b71c480e c1028cf1 c13eb382 c1554038 0000116e c113b7f0
a88f56d4 00000000
[  397.425241]  00000000 f4c3dd90 00000000 00000000 f4c3dd90 fffffffb
c113b883 c13fcf0d
[  397.425250]  120af000 00000128 00000000 00000000 00000100 00000000
0006cac5 00000000
[  397.425259] Call Trace:
[  397.425264]  [<c1028cf1>] ? warn_slowpath_common+0x81/0x8f
[  397.425269]  [<c113b7f0>] ? __btrfs_free_extent+0x3a6/0x7e3
[  397.425273]  [<c113b883>] ? __btrfs_free_extent+0x439/0x7e3
[  397.425278]  [<c1096332>] ? kfree+0x13/0x90
[  397.425282]  [<c11857d0>] ? btrfs_delayed_ref_lock+0x2c/0x74
[  397.425286]  [<c113e805>] ? run_clustered_refs+0x826/0x869
[  397.425292]  [<c113681b>] ? btrfs_del_items+0x2f2/0x2fc
[  397.425297]  [<c113e909>] ? btrfs_run_delayed_refs+0xc1/0x144
[  397.425301]  [<c114d8a8>] ? __btrfs_end_transaction+0x70/0x19b
[  397.425306]  [<c114da29>] ? btrfs_end_transaction+0x11/0x15
[  397.425310]  [<c115756d>] ? btrfs_evict_inode+0x1ce/0x1e5
[  397.425314]  [<c10ac392>] ? evict+0x52/0xe1
[  397.425318]  [<c10a580c>] ? do_unlinkat+0xca/0x10a
[  397.425322]  [<c10c0e00>] ? fsnotify_find_inode_mark+0x17/0x1d
[  397.425326]  [<c109aa57>] ? filp_close+0x56/0x5f
[  397.425331]  [<c1352093>] ? sysenter_do_call+0x12/0x22
[  397.425333] Code: 11 85 ed 75 10 b9 04 00 00 00 8b 54 24 28 89 d8
e8 11 9b 00 00 83 c4 2c 5b 5e 5f 5d c3 55 57 56 53 83 ec 28 89 c3 89
d6 8d 6a 15 <8b> 78 0c 85 ff 74 1e 8b 40 14 39 c5 72 17 8d 4a 19 8b 53
18 01
[  397.425382] EIP: [<c1164530>] btrfs_item_size+0xe/0xb0 SS:ESP 0068:f4a75d1c
[  397.425388] CR2: 000000000000000c
[  397.425392] ---[ end trace b71c480eb63758b6 ]---

This makes me think the problem is buried much deeper because
path->nodes[0] is null. :-(

Please advice.

Greetings,
Kai
