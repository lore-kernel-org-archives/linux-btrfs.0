From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Subject: Re: BTRFS Linux kernel BUG
Date: Thu, 12 May 2011 17:53:11 +0200
Message-ID: <1305215591.3072.8.camel@tethys>
References: <1305211122.3072.3.camel@tethys>
	 <20110512154013.GB19041@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110512154013.GB19041@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Le jeudi 12 mai 2011 =C3=A0 11:40 -0400, Josef Bacik a =C3=A9crit :
> Did you happen to get dmesg from that?  It seems that you got disk
> errors while writing out the supers, which points to a hardware
> problem, but having the full dmesg would be good to say for sure.
> Thanks,=20

What I got in syslog is below. Note this machine has been converted to
BTRFS 2 days ago and never suffered any HW issue before. I know
coincidences happen, but...

At the time the BTRFS spit the error out, I was just opening an (ext3)
encrypted volume that resides on my HD, i.e. (script)

losetup file =3D> loopback device
cryptsetup luksOpen loopback device
Mount.

I'd done it several times before without issue, but as BTRFS spit BUG a=
t
the exact same time...

Here's from my syslog at the time the error happened :

May 12 15:44:34 tethys kernel: [22017.035070]
btrfs_end_buffer_write_sync: 15 callbacks suppressed
May 12 15:44:34 tethys kernel: [22017.035074] lost page write due to I/=
O
error on dm-3
May 12 15:44:34 tethys kernel: [22017.035162] lost page write due to I/=
O
error on dm-3
May 12 15:44:34 tethys kernel: [22017.035235] lost page write due to I/=
O
error on dm-3
May 12 15:44:34 tethys kernel: [22017.035240] btrfs: 1 errors while
writing supers
May 12 15:44:34 tethys kernel: [22017.035272] ------------[ cut here
]------------
May 12 15:44:34 tethys kernel: [22017.035308] kernel BUG
at /build/buildd/linux-2.6.38/fs/btrfs/disk-io.c:2349!
May 12 15:44:34 tethys kernel: [22017.035353] invalid opcode: 0000 [#1]
SMP=20
May 12 15:44:34 tethys kernel: [22017.035387] last sysfs
file: /sys/devices/virtual/block/loop0/queue/rotational
May 12 15:44:34 tethys kernel: [22017.035433] Modules linked in: cdc_ac=
m
binfmt_misc rfcomm sco bnep l2cap vboxnetadp
 vboxnetflt vboxdrv kvm_intel kvm parport_pc ppdev arc4 joydev iwl3945
r852 sm_common uvcvideo iwlcore nand nand_ids=20
nand_ecc psmouse coretemp mtd snd_hda_codec_hdmi videodev dell_laptop
btusb snd_hda_codec_idt snd_hda_intel snd_hda_c
odec dell_wmi lp snd_hwdep mac80211 serio_raw snd_pcm snd_seq_midi
snd_rawmidi snd_seq_midi_event snd_seq cfg80211 bl
uetooth dcdbas snd_timer snd_seq_device snd parport soundcore
snd_page_alloc sparse_keymap btrfs zlib_deflate libcrc3
2c nls_iso8859_1 nls_cp437 vfat fat dm_crypt sha256_generic aes_i586
aes_generic usb_storage usbhid hid mmc_block i91
5 drm_kms_helper drm firewire_ohci ahci sdhci_pci sdhci tg3 i2c_algo_bi=
t
video firewire_core crc_itu_t libahci
May 12 15:44:34 tethys kernel: [22017.036081]=20
May 12 15:44:34 tethys kernel: [22017.036095] Pid: 19975, comm: sync No=
t
tainted 2.6.38-8-generic #42-Ubuntu Dell Inc
=2E XPS M1330                       /0N6705
May 12 15:44:34 tethys kernel: [22017.036178] EIP: 0060:[<f8cad9f0>]
EFLAGS: 00010292 CPU: 0
May 12 15:44:34 tethys kernel: [22017.036229] EIP is at write_all_super=
s
+0x280/0x290 [btrfs]
May 12 15:44:34 tethys kernel: [22017.036265] EAX: 0000003a EBX:
d7684720 ECX: c1739ba8 EDX: 00000000
May 12 15:44:34 tethys kernel: [22017.036306] ESI: 00000001 EDI:
d7684720 EBP: c5e77f08 ESP: c5e77ed4
May 12 15:44:34 tethys kernel: [22017.036345]  DS: 007b ES: 007b FS:
00d8 GS: 00e0 SS: 0068
May 12 15:44:34 tethys kernel: [22017.036380] Process sync (pid: 19975,
ti=3Dc5e76000 task=3Df6ace500 task.ti=3Dc5e76000)
May 12 15:44:34 tethys kernel: [22017.036426] Stack:
May 12 15:44:34 tethys kernel: [22017.036441]  f8cfddac 00000001
00000003 00000000 00000000 e2a4ad77 00000001 dae38000
May 12 15:44:34 tethys kernel: [22017.036511]  d76846c0 00000000
effa3390 f3886a80 e2a4b8a0 c5e77f10 f8cada11 c5e77f54
May 12 15:44:34 tethys kernel: [22017.036581]  f8cb1840 00000000
00000001 dae38000 00000000 00000000 f3886a80 00000000
May 12 15:44:34 tethys kernel: [22017.036651] Call Trace:
May 12 15:44:34 tethys kernel: [22017.036687]  [<f8cada11>]
write_ctree_super+0x11/0x20 [btrfs]
May 12 15:44:34 tethys kernel: [22017.036740]  [<f8cb1840>]
btrfs_commit_transaction+0x540/0x700 [btrfs]
May 12 15:44:34 tethys kernel: [22017.036787]  [<c106d370>] ?
autoremove_wake_function+0x0/0x50
May 12 15:44:34 tethys kernel: [22017.036838]  [<f8c8f87e>]
btrfs_sync_fs+0x3e/0x70 [btrfs]
May 12 15:44:34 tethys kernel: [22017.036875]  [<c114c63c>]
__sync_filesystem+0x5c/0x90
May 12 15:44:34 tethys kernel: [22017.036908]  [<c114c687>] sync_one_sb
+0x17/0x20
May 12 15:44:34 tethys kernel: [22017.036939]  [<c1129cfc>]
iterate_supers+0x6c/0xb0
May 12 15:44:34 tethys kernel: [22017.036972]  [<c114c670>] ?
sync_one_sb+0x0/0x20
May 12 15:44:34 tethys kernel: [22017.037004]  [<c114c59b>]
sync_filesystems+0x1b/0x20
May 12 15:44:34 tethys kernel: [22017.037038]  [<c114c700>] sys_sync
+0x20/0x40
May 12 15:44:34 tethys kernel: [22017.037069]  [<c1509bf4>] syscall_cal=
l
+0x7/0xb
May 12 15:44:34 tethys kernel: [22017.037098] Code: c4 28 31 c0 5b 5e 5=
f
5d c3 89 44 24 04 c7 04 24 ac dd cf f8 e8 71 97 85 c8 0f 0b 89 74 24 04
c7 04 24 ac dd cf f8 e8 5f 97 85 c8 <0f> 0b 8d b4 26 00 00 00 00 8d bc
27 00 00 00 00 55 89 e5 3e 8d=20
May 12 15:44:34 tethys kernel: [22017.037410] EIP: [<f8cad9f0>]
write_all_supers+0x280/0x290 [btrfs] SS:ESP 0068:c5e77ed4
May 12 15:44:34 tethys kernel: [22017.066355] ---[ end trace
280ae79e021f9d49 ]---


TIA.

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
