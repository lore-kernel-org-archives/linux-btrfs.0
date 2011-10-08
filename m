From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: btrfs corruption after cp --reflink
Date: Sat, 8 Oct 2011 20:55:44 +0200
Message-ID: <CAMthOuNb=MGQNz8X=OA0G_ApWWxBA8HnuHv_MPt7sQZ-tB8n_Q@mail.gmail.com>
References: <CAMthOuMwb-ibGGzve_ntoqBcdK73UgjFP92AgCyGDu9jyX0bog@mail.gmail.com>
	<CAMthOuNb=EO5QiXUzK5DN3oc5JTrv=NUwRbSQsy0fSa0QAxQLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAMthOuNb=EO5QiXUzK5DN3oc5JTrv=NUwRbSQsy0fSa0QAxQLw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello again!

2011/10/8 Kai Krakow <hurikhan77+btrfs@gmail.com>:
> I tried to "cp --reflink" a huge file (about 80G, a VMware disk
> image). It took maybe about 1 minute when my PC started thrashing the
> hard disk, some minutes later the command returned with an out of
> memory message.
[...]
> So I'd love to
> get rid of the problems scrub complains about. I don't mind if I would
> have to delete some files which I can probably recover easily. But I
> can simply find no way to identify these files. Is there a way to map
> the above error messages to file system pathes?

I figured out that most of the affected files are located in the
Google Chromium cache. Trying to "cat" all files there showed up the
csum errors in dmesg but the system stays stable. I decided to simply
delete the cache, however that makes "rm" becoming killed. Here's the
dmesg output from the "rm -Rf .cache/chromium/*" session:

[  637.297845] verify_parent_transid: 470 callbacks suppressed
[  637.297852] parent transid verify failed on 641086160896 wanted
43863 found 43873
[  637.298833] parent transid verify failed on 641086160896 wanted
43863 found 43873
[  637.315081] parent transid verify failed on 641086160896 wanted
43863 found 43873
[  637.345259] parent transid verify failed on 641086160896 wanted
43863 found 43873
[  637.345269] parent transid verify failed on 641086160896 wanted
43863 found 43873
[  637.345296] BUG: unable to handle kernel NULL pointer dereference at 0000001c
[  637.345306] IP: [<c1142c2f>] btrfs_print_leaf+0xd/0x886
[  637.345319] *pde = 00000000
[  637.345324] Oops: 0000 [#1] SMP
[  637.345330] Modules linked in: af_packet vmnet vmblock vsock vmci
vmmon lm90 it87 hwmon_vid hwmon fuse rfcomm bnep snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
reiserfs zram(C) mperf loop emu10k1_gp sidewinder joydev nfs lockd
auth_rpcgss nfs_acl sunrpc ipv6 tcp_cubic nvidia(P) snd_usb_audio
snd_usbmidi_lib i82875p_edac usb_storage usbhid 8250_pnp gspca_sonixj
gspca_main videodev firewire_ohci edac_core uas hid firewire_core
sr_mod cdrom sg ns558 btusb analog evdev pcspkr ne2k_pci 8390 floppy
gameport i2c_i801 8250 parport_pc serial_core parport e1000 intel_agp
snd_mpu401 snd_mpu401_uart thermal bluetooth crc16 crc_itu_t fan
processor button intel_gtt agpgart unix [last unloaded: microcode]
[  637.345434]
[  637.345439] Pid: 2465, comm: btrfs-delayed-m Tainted: P       A C
3.0.6-gentoo #1    /8KNXP
[  637.345446] EIP: 0060:[<c1142c2f>] EFLAGS: 00010286 CPU: 1
[  637.345450] EIP is at btrfs_print_leaf+0xd/0x886
[  637.345454] EAX: f506a800 EBX: f506a800 ECX: 00418335 EDX: 00000000
[  637.345457] ESI: 00000000 EDI: f4c40850 EBP: fffffffb ESP: f49d7d30
[  637.345460]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  637.345464] Process btrfs-delayed-m (pid: 2465, ti=f49d6000
task=f4707800 task.ti=f49d6000)
[  637.345467] Stack:
[  637.345469]  f499e840 f505e000 000000b2 00000000 00000000 ffffffff
00000000 00000000
[  637.345478]  00000100 00000000 0006cac6 00000000 c113b1ec c101e917
f506a800 c1350707
[  637.345487]  11d22000 00000128 00060000 00008050 2811d220 a8000001
00040000 00000000
[  637.345496] Call Trace:
[  637.345502]  [<c113b1ec>] ? update_block_group.clone.51+0x2b3/0x2e4
[  637.345508]  [<c101e917>] ? need_resched+0x11/0x1a
[  637.345513]  [<c1350707>] ? _cond_resched+0x5/0x18
[  637.345518]  [<c113b7e1>] ? __btrfs_free_extent+0x397/0x7e3
[  637.345523]  [<c113e818>] ? run_clustered_refs+0x839/0x869
[  637.345528]  [<c11b66f8>] ? rb_erase+0x14d/0x1f0
[  637.345532]  [<c113e805>] ? run_clustered_refs+0x826/0x869
[  637.345537]  [<c101d84e>] ? kmap_atomic_prot+0x23/0x96
[  637.345542]  [<c11356fc>] ? btrfs_search_slot+0x3e8/0x452
[  637.345547]  [<c113e909>] ? btrfs_run_delayed_refs+0xc1/0x144
[  637.345552]  [<c114d8a0>] ? __btrfs_end_transaction+0x70/0x19b
[  637.345556]  [<c114d9df>] ? btrfs_end_transaction_dmeta+0x14/0x18
[  637.345561]  [<c118d3dd>] ? btrfs_async_run_delayed_node_done+0x14d/0x1a0
[  637.345567]  [<c1174d3f>] ? worker_loop+0x10a/0x393
[  637.345571]  [<c1174c35>] ? btrfs_queue_worker+0x1f1/0x1f1
[  637.345576]  [<c103b98a>] ? kthread+0x63/0x68
[  637.345580]  [<c103b927>] ? kthread_worker_fn+0x10f/0x10f
[  637.345585]  [<c135263e>] ? kernel_thread_helper+0x6/0xd
[  637.345588] Code: da d4 20 00 83 c4 2c 5b 5e 5f 5d c3 53 e8 ab ac
ed ff 8a 58 64 e8 58 ab ed ff 88 d8 5b c3 55 57 56 53 83 ec 60 89 c3
89 54 24 2c <8b> 42 1c e8 8a ac ed ff 8b 50 60 89 54 24 48 e8 33 ab ed
ff 8b
[  637.345633] EIP: [<c1142c2f>] btrfs_print_leaf+0xd/0x886 SS:ESP 0068:f49d7d30
[  637.345640] CR2: 000000000000001c
[  637.345647] ---[ end trace 640af837f79e8469 ]---
[  639.058404] parent transid verify failed on 641086160896 wanted
43863 found 43873
[  639.058670] parent transid verify failed on 641086160896 wanted
43863 found 43873
[  639.059074] parent transid verify failed on 641086160896 wanted
43863 found 43873
[  639.067414] parent transid verify failed on 641086160896 wanted
43863 found 43873
[  639.067423] parent transid verify failed on 641086160896 wanted
43863 found 43873
[  639.067453] BUG: unable to handle kernel NULL pointer dereference at 0000001c
[  639.067462] IP: [<c1142c2f>] btrfs_print_leaf+0xd/0x886
[  639.067476] *pde = 00000000
[  639.067481] Oops: 0000 [#2] SMP
[  639.067487] Modules linked in: af_packet vmnet vmblock vsock vmci
vmmon lm90 it87 hwmon_vid hwmon fuse rfcomm bnep snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
reiserfs zram(C) mperf loop emu10k1_gp sidewinder joydev nfs lockd
auth_rpcgss nfs_acl sunrpc ipv6 tcp_cubic nvidia(P) snd_usb_audio
snd_usbmidi_lib i82875p_edac usb_storage usbhid 8250_pnp gspca_sonixj
gspca_main videodev firewire_ohci edac_core uas hid firewire_core
sr_mod cdrom sg ns558 btusb analog evdev pcspkr ne2k_pci 8390 floppy
gameport i2c_i801 8250 parport_pc serial_core parport e1000 intel_agp
snd_mpu401 snd_mpu401_uart thermal bluetooth crc16 crc_itu_t fan
processor button intel_gtt agpgart unix [last unloaded: microcode]
[  639.067584]
[  639.067590] Pid: 4241, comm: rm Tainted: P      DA C  3.0.6-gentoo
#1    /8KNXP
[  639.067596] EIP: 0060:[<c1142c2f>] EFLAGS: 00010286 CPU: 1
[  639.067600] EIP is at btrfs_print_leaf+0xd/0x886
[  639.067604] EAX: f506a800 EBX: f506a800 ECX: 0042f40d EDX: 00000000
[  639.067607] ESI: 00000000 EDI: f4c400e0 EBP: fffffffb ESP: ec6c5ce4
[  639.067610]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  639.067614] Process rm (pid: 4241, ti=ec6c4000 task=f3731c00
task.ti=ec6c4000)
[  639.067616] Stack:
[  639.067618]  f49f9780 f505e000 000000b2 00000000 00000000 ffffffff
00000000 00000000
[  639.067627]  00000100 00000000 0006cac7 00000000 c113b1ec c101e917
f506a800 c1350707
[  639.067636]  11d6c000 00000128 00001000 00008050 2811d6c0 a8000001
00040000 00000000
[  639.067645] Call Trace:
[  639.067651]  [<c113b1ec>] ? update_block_group.clone.51+0x2b3/0x2e4
[  639.067657]  [<c101e917>] ? need_resched+0x11/0x1a
[  639.067662]  [<c1350707>] ? _cond_resched+0x5/0x18
[  639.067667]  [<c113b7e1>] ? __btrfs_free_extent+0x397/0x7e3
[  639.067672]  [<c113e818>] ? run_clustered_refs+0x839/0x869
[  639.067676]  [<c113e818>] ? run_clustered_refs+0x839/0x869
[  639.067681]  [<c10963a7>] ? kfree+0x88/0x90
[  639.067685]  [<c113e818>] ? run_clustered_refs+0x839/0x869
[  639.067690]  [<c11857c8>] ? btrfs_delayed_ref_lock+0x2c/0x74
[  639.067694]  [<c113e805>] ? run_clustered_refs+0x826/0x869
[  639.067700]  [<c113e909>] ? btrfs_run_delayed_refs+0xc1/0x144
[  639.067704]  [<c1350707>] ? _cond_resched+0x5/0x18
[  639.067709]  [<c114d8a0>] ? __btrfs_end_transaction+0x70/0x19b
[  639.067713]  [<c114da21>] ? btrfs_end_transaction+0x11/0x15
[  639.067718]  [<c1157509>] ? btrfs_evict_inode+0x172/0x1e5
[  639.067723]  [<c10ac392>] ? evict+0x52/0xe1
[  639.067727]  [<c10a580c>] ? do_unlinkat+0xca/0x10a
[  639.067733]  [<c10c0e00>] ? fsnotify_find_inode_mark+0x17/0x1d
[  639.067737]  [<c109aa57>] ? filp_close+0x56/0x5f
[  639.067743]  [<c1352093>] ? sysenter_do_call+0x12/0x22
[  639.067745] Code: da d4 20 00 83 c4 2c 5b 5e 5f 5d c3 53 e8 ab ac
ed ff 8a 58 64 e8 58 ab ed ff 88 d8 5b c3 55 57 56 53 83 ec 60 89 c3
89 54 24 2c <8b> 42 1c e8 8a ac ed ff 8b 50 60 89 54 24 48 e8 33 ab ed
ff 8b
[  639.067791] EIP: [<c1142c2f>] btrfs_print_leaf+0xd/0x886 SS:ESP 0068:ec6c5ce4
[  639.067797] CR2: 000000000000001c
[  639.067805] ---[ end trace 640af837f79e846a ]---

Now every file access (no matter where in the file system) makes the
shell freeze and the process cannot be killed. So, effectively my
system is frozen again. :-(

Any fix for this?

Greetings,
Kai
