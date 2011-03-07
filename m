From: "D.S. Ljungmark" <spider@skuggor.se>
Subject: Crash and burn
Date: Mon, 07 Mar 2011 23:47:28 +0100
Message-ID: <1299538048.5596.4.camel@Waves.darkmere>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256"; protocol="application/pgp-signature"; boundary="=-q6anNShTbwAg/LZOzfEa"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--=-q6anNShTbwAg/LZOzfEa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I've managed to get a corrupted filesystem that's bad enough off that I
get fun and interesting kernel BUG()'s from it:

[    0.000000] Linux version 2.6.35.3-10.3-netbook (abuild@build25) (gcc
version 4.5.0 20100414 (MeeGo 4.5.0-1) (GCC) ) #1 SMP PREEMPT Fri Oct 15
17:53:05 UTC 2010


[  385.669060] device fsid cc4f66a85c124274-f6e4e4033873ff83 devid 1
transid 11793 /dev/sda2
[  385.942423] ------------[ cut here ]------------
[  385.942442] kernel BUG at fs/btrfs/tree-log.c:813!
[  385.942455] invalid opcode: 0000 [#1] PREEMPT SMP=20
[  385.942471] last sysfs file: /sys/devices/virtual/bdi/btrfs-1/uevent
[  385.942481] Modules linked in: battery uvcvideo serio_raw joydev
dm_snapshot dm_mod
[  385.942510]=20
[  385.942524] Pid: 1089, comm: mount Not tainted 2.6.35.3-10.3-netbook
#1         /AOA110
[  385.942539] EIP: 0060:[<c1156613>] EFLAGS: 00010246 CPU: 1
[  385.942559] EIP is at add_inode_ref+0x43/0x342
[  385.942571] EAX: 00000000 EBX: ccfe2628 ECX: ffffffff EDX: 00000005
[  385.942584] ESI: c6f3e800 EDI: e2065cd3 EBP: e2065c8c ESP: e2065c48
[  385.942596]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  385.942611] Process mount (pid: 1089, ti=3De2064000 task=3Df6709270
task.ti=3De2064000)
[  385.942621] Stack:
[  385.942628]  f3062000 ee566720 00000097 00000000 e2065c98 c114206e
ee566720 e2065c6c
[  385.942657] <0> c114aa7a c52ea400 00000000 000000ac ccfd7da4 00001000
e2065d74 ee566720
[  385.942688] <0> 00000002 e2065cf0 c11574b9 ccfe2628 ee566720 00000002
e2065cd3 c1c37800
[  385.942721] Call Trace:
[  385.942740]  [<c114206e>] ? btrfs_item_size+0x5b/0x9e
[  385.942759]  [<c114aa7a>] ? unmap_extent_buffer+0xc/0xe
[  385.942777]  [<c11574b9>] ? replay_one_buffer+0x1ba/0x22e
[  385.942796]  [<c1155064>] ? walk_up_log_tree+0x102/0x1b0
[  385.942813]  [<c11572ff>] ? replay_one_buffer+0x0/0x22e
[  385.942829]  [<c11554db>] ? walk_log_tree+0x8f/0x18b
[  385.942847]  [<c1158cab>] ? btrfs_recover_log_trees+0x166/0x241
[  385.942864]  [<c11572ff>] ? replay_one_buffer+0x0/0x22e
[  385.942883]  [<c112d2d9>] ? open_ctree+0x1081/0x12ec
[  385.942904]  [<c1191986>] ? snprintf+0x15/0x17
[  385.942922]  [<c1114cd3>] ? btrfs_fill_super+0x4e/0xed
[  385.942937]  [<c118fbb0>] ? strlcpy+0x13/0x2f
[  385.942953]  [<c11151d2>] ? btrfs_get_sb+0x142/0x25f
[  385.942973]  [<c10a4069>] ? __alloc_percpu+0xa/0xc
[  385.942989]  [<c10a6e74>] ? vfs_kern_mount+0x49/0xdb
[  385.943004]  [<c10a6f4c>] ? do_kern_mount+0x34/0xc0
[  385.943022]  [<c10b9e14>] ? do_mount+0x244/0x286
[  385.943039]  [<c108e5f2>] ? strndup_user+0x3f/0x65
[  385.943055]  [<c10b9eea>] ? sys_mount+0x62/0x95
[  385.943072]  [<c1002857>] ? sysenter_do_call+0x12/0x26
[  385.943076] Code: 5d 08 8b 57 09 8b 4f 0d e8 99 f0 ff ff 85 c0 89 45
ec 0f 84 05 03 00 00 8b 17 8b 4f 04 89 f0 e8 82 f0 ff ff 85 c0 89 45 e4
75 02 <0f> 0b 6b 45 10 19 83 c0 65 89 c2 89 45 f0 8b 45 0c e8 a9 b8 fe=20
[  385.943076] EIP: [<c1156613>] add_inode_ref+0x43/0x342 SS:ESP
0068:e2065c48
[  385.943329] ---[ end trace 690c5378e1aae040 ]---

I'm currently trying to get an image out of the machine,  can probably
put it online somewhere if there is real need.=20



Not subscribed, so please CC me.

//Spider

--=-q6anNShTbwAg/LZOzfEa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABCAAGBQJNdWBpAAoJEIAXXkJ+kSkUC58H/0CyKvk2iefoZYNWwaBe1d1b
SjRwMqiPYpCEMR796t9CL4h6oPVZ/XGpaTzKR60T+nVaOxrhSy98wGtSJQgacv9Z
ePeXHqWacoZRQ+jJQLk/F09zuovj3/vCOOlX0z4At8CzK4aVTZwSkxRoZRsMvIHr
yU6e4ZqgzbMWnfNwI+XAYtmJGlCWZ7hvaVNLCvkLZT2txz3ZS/AzTNAMw6xc4+o6
4YtBRTxcH+Pfjm2hJqKt6FzoNz+Ze2dprJmtlKhSQ97j3l9aLLmmVyO6I/x+J16R
/8A5zNmgTahIbR9b2bXssEG1AEtNOtt6dIPXoz0NPNMNCk46w/mlZ1jWifuVlJw=
=IzZd
-----END PGP SIGNATURE-----

--=-q6anNShTbwAg/LZOzfEa--

