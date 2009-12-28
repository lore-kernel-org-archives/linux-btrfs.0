From: Adrian von Bidder <avbidder@fortytwo.ch>
Subject: slow umount + btrfs-show odditiy
Date: Mon, 28 Dec 2009 15:59:46 +0100
Message-ID: <200912281559.52522@fortytwo.ch>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3737049.XsUg3xOSzW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart3737049.XsUg3xOSzW
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Heyho!

Running btrfs on a QNAP (ARM Platform), 1.8T Filesystem on most of 4 x 500G=
=20
disks, raid 1 for data + metadata.  Filled with 300G files (dirvish trees,=
=20
so lots of hardlinks.  Files are backups of "normal" user + root filesystem=
s=20
of a few PCs, so quite a mix in filesizes.)

[[[ Eventually I'll want to replace dirvish by plain rsync and use btrfs=20
timestamps to get snapshots.  Got to prove stability first. ]]]

After copying the files from the prvevious location onto this filesystem,=20
btrfs-show shows only 450G used on one disk and 30G or so on the other thre=
e=20
disks (sorry, didn't preserve the output.)  In any case, the other three=20
disks didn't have enough to contain all the data duplicated in raid1=20
fashion.

"btrfs-vol -b" (obviously took quite some hours), now I have:

+++
Label: none  uuid: 9a41b0eb-3f9b-4f56-852e-13068829f8aa
        Total devices 4 FS bytes used 393.45GB
        devid    3 size 450.49GB used 389.00GB path /dev/sdc2
        devid    4 size 450.49GB used 396.01GB path /dev/sdd2
        devid    1 size 450.49GB used 396.01GB path /dev/sda2
        devid    5 size 450.49GB used 253.00GB path /dev/sdb2

Btrfs v0.19-4-gab8fb4c-dirty
+++

Which is strange as well.  Given that the real data is ~400G, I'd have=20
expected the disks to be fileed with 4 x 200G plus some metadata, but this=
=20
looks like almost twice as much as I'd expect.

I'm no fs debugger, so it might be anything of
 -> btrfs-show is far off
 -> metadata on btrfs is quite big
 -> I don't have raid1 (data + metadata mirrored inn two places) but the=20
stuff is being mirrored on more disks than necessary.
 -> or something completely different...


And after that, umount took about 5min (the machine has only 512M, and I=20
waited a few hours after "btrfs-vol -b" has completed before I unmounted,=20
but I did not issue a sync first.)

The kernel triggered twice or so with the following:


Dec 28 15:45:08 syydelaervli kernel: [97580.340641] INFO: task umount:12765=
 blocked for more than 120 seconds.
Dec 28 15:45:08 syydelaervli kernel: [97580.340674] "echo 0 > /proc/sys/ker=
nel/hung_task_timeout_secs" disables this message.
Dec 28 15:45:08 syydelaervli kernel: [97580.340699] umount        D c02b080=
c     0 12765  12681 0x00000000
Dec 28 15:45:08 syydelaervli kernel: [97580.340749] [<c02b080c>] (schedule+=
0x424/0x488) from [<c00e719c>] (bdi_sched_wait+0xc/0x18)
Dec 28 15:45:08 syydelaervli kernel: [97580.340787] [<c00e719c>] (bdi_sched=
_wait+0xc/0x18) from [<c02b0f68>] (__wait_on_bit+0x5c/0xa8)
Dec 28 15:45:08 syydelaervli kernel: [97580.340821] [<c02b0f68>] (__wait_on=
_bit+0x5c/0xa8) from [<c02b1060>]=20
(out_of_line_wait_on_bit+0xac/0xc4)
Dec 28 15:45:08 syydelaervli kernel: [97580.340857] [<c02b1060>] (out_of_li=
ne_wait_on_bit+0xac/0xc4) from [<c00e7210>]=20
(sync_inodes_sb+0x68/0x100)
Dec 28 15:45:08 syydelaervli kernel: [97580.340894] [<c00e7210>] (sync_inod=
es_sb+0x68/0x100) from [<c00eb340>] (__sync_filesystem+0x64/0x94)
Dec 28 15:45:08 syydelaervli kernel: [97580.340932] [<c00eb340>] (__sync_fi=
lesystem+0x64/0x94) from [<c00cdc74>]=20
(generic_shutdown_super+0x28/0x110)
Dec 28 15:45:08 syydelaervli kernel: [97580.340970] [<c00cdc74>] (generic_s=
hutdown_super+0x28/0x110) from [<c00cdda8>]=20
(kill_anon_super+0x14/0x3c)
Dec 28 15:45:08 syydelaervli kernel: [97580.341008] [<c00cdda8>] (kill_anon=
_super+0x14/0x3c) from [<c00ce46c>] (deactivate_super+0x6c/0x90)
Dec 28 15:45:08 syydelaervli kernel: [97580.341044] [<c00ce46c>] (deactivat=
e_super+0x6c/0x90) from [<c00e2310>] (sys_umount+0x2bc/0x2e8)
Dec 28 15:45:08 syydelaervli kernel: [97580.341079] [<c00e2310>] (sys_umoun=
t+0x2bc/0x2e8) from [<c0026ea0>] (ret_fast_syscall+0x0/0x28)

Other than that, the umount succeeded, I can mount the fs again and work on=
 that fs.

This all with btrfs as it comes in 2.6.32.

Ok, I guess that's it for now.

cheers
=2D- vbi




=2D-=20
Leute, die immer nur mitfahren, sind stolz darauf, keine Unf=E4lle zu
verschulden.
		-- Gabriel Laub

--nextPart3737049.XsUg3xOSzW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: get my key from http://fortytwo.ch/gpg/92082481

iKcEABECAGcFAks4x+NgGmh0dHA6Ly9mb3J0eXR3by5jaC9sZWdhbC9ncGcvZW1h
aWwuMjAwMjA4MjI/dmVyc2lvbj0xLjUmbWQ1c3VtPTVkZmY4NjhkMTE4NDMyNzYw
NzFiMjVlYjcwMDZkYTNlAAoJECqqZti935l6joYAn1Xqw1SxqFUIuOUUjGBmhtUV
RAtlAJ9IXPAtQnqE7nuPMF+99+PGnY9oqQ==
=6Bz3
-----END PGP SIGNATURE-----

--nextPart3737049.XsUg3xOSzW--
