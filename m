From: Jonathan Yip <helkaluin@gmail.com>
Subject: kernel BUG at fs/btrfs/inode.c:794!
Date: Mon, 08 Aug 2011 14:50:04 +0800
Message-ID: <4E3F871C.2070101@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF8D5E046D6557A6D9ED47A69"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF8D5E046D6557A6D9ED47A69
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi all,

Previous e-mail was sent without any reply, and was filed erroneously as
a reply to another e-mail on the list, thus re-sending.

Running on kernel 3.0 without patches.  Mount options for the btrfs
partition in question were `defaults, noatime, compress=3Dlzo,
space_cache, autodefrag, inoce_cache'.  Partition cannot be mounted
again with a  3.0 kernel after reboot.  Partition can, however, be
mounted successfully with a 2.6.38 kernel (stock Ubuntu patches) without
options, and afterwards successfully with the 3.0 kernel.

> Aug  1 11:12:22 Eve kernel: [  154.594512] ------------[ cut here ]----=
--------
> Aug  1 11:12:22 Eve kernel: [  154.594541] kernel BUG at fs/btrfs/inode=
=2Ec:794!
> Aug  1 11:12:22 Eve kernel: [  154.594554] invalid opcode: 0000 [#1] PR=
EEMPT SMP=20
> Aug  1 11:12:22 Eve kernel: [  154.594573] CPU 0=20
> Aug  1 11:12:22 Eve kernel: [  154.594586] Modules linked in: cryptd ae=
s_x86_64 aes_generic vboxnetadp vboxnetflt vboxdrv binfmt_misc parport_pc=
 ppdev snd_hda_codec_realtek uvcvideo snd_hda_intel dell_wmi snd_hda_code=
c videodev dell_laptop joydev arc4 v4l2_compat_ioctl32 coretemp snd_hwdep=
 snd_pcm snd_seq_midi lp psmouse serio_raw snd_rawmidi snd_seq_midi_event=
 iwl4965 iwl_legacy r8169 mac80211 snd_seq snd_timer snd_seq_device spars=
e_keymap snd cfg80211 dcdbas parport soundcore snd_page_alloc nouveau ahc=
i libahci ttm drm_kms_helper drm i2c_algo_bit mxm_wmi video btrfs zlib_de=
flate libcrc32c
> Aug  1 11:12:22 Eve kernel: [  154.594740]=20
> Aug  1 11:12:22 Eve kernel: [  154.594745] Pid: 801, comm: btrfs-transa=
cti Not tainted 3.0.0-vanilla #1 Dell Inc. Vostro1310/0G930C
> Aug  1 11:12:22 Eve kernel: [  154.594762] RIP: 0010:[<ffffffffa004604c=
>]  [<ffffffffa004604c>] cow_file_range+0x37c/0x390 [btrfs]
> Aug  1 11:12:22 Eve kernel: [  154.594793] RSP: 0018:ffff880132c63550  =
EFLAGS: 00010246
> Aug  1 11:12:22 Eve kernel: [  154.594801] RAX: ffff88013628c000 RBX: 0=
000000000001000 RCX: 00000000000a5fff
> Aug  1 11:12:22 Eve kernel: [  154.594811] RDX: ffff8801362dd000 RSI: f=
fffea0003a25100 RDI: ffff88012894d158
> Aug  1 11:12:22 Eve kernel: [  154.594820] RBP: ffff880132c63600 R08: f=
fff880132c6389c R09: ffff880132c63880
> Aug  1 11:12:22 Eve kernel: [  154.594829] R10: 0000000000000002 R11: 0=
000000000000000 R12: 0000000000000000
> Aug  1 11:12:22 Eve kernel: [  154.594948] R13: 00000000000a5fff R14: f=
fff88012894cfc0 R15: ffff88012894d158
> Aug  1 11:12:22 Eve kernel: [  154.594959] FS:  0000000000000000(0000) =
GS:ffff88013fc00000(0000) knlGS:0000000000000000
> Aug  1 11:12:22 Eve kernel: [  154.594969] CS:  0010 DS: 0000 ES: 0000 =
CR0: 000000008005003b
> Aug  1 11:12:22 Eve kernel: [  154.594978] CR2: 00007fe916cb3000 CR3: 0=
00000000174b000 CR4: 00000000000006f0
> Aug  1 11:12:22 Eve kernel: [  154.594987] DR0: 0000000000000000 DR1: 0=
000000000000000 DR2: 0000000000000000
> Aug  1 11:12:22 Eve kernel: [  154.594998] DR3: 0000000000000000 DR6: 0=
0000000ffff0ff0 DR7: 0000000000000400
> Aug  1 11:12:22 Eve kernel: [  154.595008] Process btrfs-transacti (pid=
: 801, threadinfo ffff880132c62000, task ffff880137d0c020)
> Aug  1 11:12:22 Eve kernel: [  154.595019] Stack:
> Aug  1 11:12:22 Eve kernel: [  154.595024]  ffff880136dbac60 ffff880137=
f3c000 fffffffffffffff6 00001d21f1800080
> Aug  1 11:12:22 Eve kernel: [  154.595042]  0000000000000000 0000001d21=
e9a000 ffffea0003a25100 00001d21f1800080
> Aug  1 11:12:22 Eve kernel: [  154.595060]  ffff8801362dd000 ffff880132=
c6389c ffff880132c63880 ffff88012894cfe0
> Aug  1 11:12:22 Eve kernel: [  154.595078] Call Trace:
> Aug  1 11:12:22 Eve kernel: [  154.595097]  [<ffffffffa00463af>] run_de=
lalloc_nocow+0x34f/0x830 [btrfs]
> Aug  1 11:12:22 Eve kernel: [  154.595119]  [<ffffffffa005eae7>] ? free=
_extent_state+0x37/0x60 [btrfs]
> Aug  1 11:12:22 Eve kernel: [  154.595143]  [<ffffffffa0046c0c>] run_de=
lalloc_range+0x37c/0x380 [btrfs]
> Aug  1 11:12:22 Eve kernel: [  154.595158]  [<ffffffff81106cd9>] ? zone=
_statistics+0x99/0xc0
> Aug  1 11:12:22 Eve kernel: [  154.595178]  [<ffffffffa0061d25>] __exte=
nt_writepage+0x5d5/0x730 [btrfs]
> Aug  1 11:12:22 Eve kernel: [  154.595191]  [<ffffffff812c8b8d>] ? radi=
x_tree_gang_lookup_tag_slot+0x8d/0xd0
> Aug  1 11:12:22 Eve kernel: [  154.595212]  [<ffffffffa00620ca>] extent=
_write_cache_pages.clone.18.clone.25+0x24a/0x300 [btrfs]
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffffa0062425>] extent=
_writepages+0x45/0x60 [btrfs]
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffffa0042d30>] ? btrf=
s_real_readdir+0x650/0x650 [btrfs]
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffffa005eae6>] ? free=
_extent_state+0x36/0x60 [btrfs]
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffffa00414c7>] btrfs_=
writepages+0x27/0x30 [btrfs]
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffff810f41f1>] do_wri=
tepages+0x21/0x40
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffff810ea51b>] __file=
map_fdatawrite_range+0x5b/0x60
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffff810eb39f>] filema=
p_fdatawrite+0x1f/0x30
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffff810eb3e5>] filema=
p_write_and_wait+0x35/0x60
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffffa007b2cb>] __btrf=
s_write_out_cache+0xa6b/0xc90 [btrfs]
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffffa0044f16>] ? __bt=
rfs_prealloc_file_range+0x196/0x220 [btrfs]
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffff81160e5a>] ? igra=
b+0x3a/0x70
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffffa007d679>] btrfs_=
write_out_ino_cache+0x99/0xd0 [btrfs]
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffffa00362fe>] btrfs_=
save_ino_cache+0x16e/0x260 [btrfs]
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffffa003daf2>] commit=
_fs_roots.clone.21+0xc2/0x1a0 [btrfs]
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffffa001a60a>] ? btrf=
s_free_path+0x2a/0x40 [btrfs]
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffffa003ead1>] btrfs_=
commit_transaction+0x471/0x900 [btrfs]
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffffa003dd1c>] ? join=
_transaction.clone.23+0x5c/0x230 [btrfs]
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffffa003f2f9>] ? star=
t_transaction+0x99/0x2e0 [btrfs]
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffff8106eea0>] ? wake=
_up_bit+0x40/0x40
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffffa0037563>] transa=
ction_kthread+0x273/0x290 [btrfs]
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffffa00372f0>] ? btrf=
s_congested_fn+0xc0/0xc0 [btrfs]
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffff8106e896>] kthrea=
d+0x96/0xa0
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffff81580494>] kernel=
_thread_helper+0x4/0x10
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffff8106e800>] ? kthr=
ead_worker_fn+0x190/0x190
> Aug  1 11:12:22 Eve kernel: [  154.595435]  [<ffffffff81580490>] ? gs_c=
hange+0xb/0xb
> Aug  1 11:12:22 Eve kernel: [  154.595435] Code: c0 5b 41 5c 41 5d 41 5=
e 41 5f c9 c3 4c 89 95 70 ff ff ff 4c 89 fe 48 8b 7d 88 e8 10 7b 00 00 4c=
 8b 95 70 ff ff ff e9 55 fd ff ff <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 0=
f 1f 84 00 00 00 00 00 55=20
> Aug  1 11:12:22 Eve kernel: [  154.595435] RIP  [<ffffffffa004604c>] co=
w_file_range+0x37c/0x390 [btrfs]
> Aug  1 11:12:22 Eve kernel: [  154.595435]  RSP <ffff880132c63550>
> Aug  1 11:12:22 Eve kernel: [  154.636938] ---[ end trace b93d3aede1096=
51a ]---

Please tell if you need anything else,
Jonathan Yip


--------------enigF8D5E046D6557A6D9ED47A69
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOP4ccAAoJEBlAWad2kOVYJCEP/31Xsn5Ll7bELqf1Yt5H+OHp
2en9dEeFgMyihu1FSSgh0zbjEchqBRoiwUPSY/yEoNX13bwx6/IUhOtDSB9MtVkS
EhNdu0xHD0pX+N1n5TK47MsDqIsb/gGdrByctRWJj6a8bJzmhlq32GGvOVcep6tG
z/1duutli8hPlyf7ZjCEYrrQL73yfrpex2dSm4IViKG4UgJklxEYYnw4VZFbM/T2
xnGfee1at6lj7BaAxxLNGdXw9b/5r/wIf5EbDdfx6iZgcb24Eh3qka/BLO94WVTD
4n07mhDL8/v/mGBEBf4ukRVbrltx4tDrLyXM8GEuSMnSLTXXjXHOgZzQLIv6m1dD
M7I8pgt/1Hvx4ibs0jK70N1oIGbce8M97PtFSAT9735cxKuAj72IL5FLre0JhU7H
P86JG+2XK50MADnPwzE2K+HPftGV+obA9cmr8DfLIm4+DNGYRVdWwGLPQ0Il9Owp
5H+qFw8dhxUm2vX7M0EHGuqDQ6WyzUbbVQFAJ1h7R5vaysyymRBkY+P2ix4VNG5v
R3/LzSrvx+IiISmfWns68L4arZXat0JvwIHUAmqxffuCwqbebEZEeqRfkU1mtBtR
Yb+dawQJHE4pD0B4P2fNWqS5RGaUnaotei5zQZcwCeUTa4PioFuEHDD83A6P6zJc
kyMuwVOo2yZWkhuPPdiv
=JZWq
-----END PGP SIGNATURE-----

--------------enigF8D5E046D6557A6D9ED47A69--
