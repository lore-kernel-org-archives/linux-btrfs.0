Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mehl.schokokeks.org ([46.4.40.247]:49071 "EHLO
	mehl.schokokeks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaKKQCQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Nov 2014 11:02:16 -0500
Date: Tue, 11 Nov 2014 16:51:53 +0100
From: Florian Bruhin <me@the-compiler.org>
To: linux-btrfs@vger.kernel.org
Subject: open_ctree failed after ATA errors
Message-ID: <20141111155153.GZ5944@lupin>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_mehl.schokokeks.org-2872-1415721114-0001-2"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_mehl.schokokeks.org-2872-1415721114-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I have the following setup:

- Two harddisks
    - Both individually encrypted using LUKS
    - Both combined into a btrfs using the btrfs raid1 feature

- The above duplicated twice:
    - /dev/mapper/data1 and /dev/mapper/data2 -> /mnt/data
    - /dev/mapper/secdata1 and /dev/mapper/secdata2 -> /mnt/secdata

Recently, I saw the following messages in my kernel logs all few days:

    ata6.00: exception Emask 0x10 SAct 0x40000 SErr 0x400000 action 0x6 fro=
zen
    ata6.00: irq_stat 0x08000000, interface fatal error
    ata6: SError: { Handshk }
    ata6.00: failed command: WRITE FPDMA QUEUED
    ata6.00: cmd 61/08:90:e8:29:85/01:00:03:00:00/40 tag 18 ncq 135168 out
             res 40/00:94:e8:29:85/00:00:03:00:00/40 Emask 0x10 (ATA bus er=
ror)
    ata6.00: status: { DRDY }
    ata6: hard resetting link
    ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
    ata6.00: configured for UDMA/133
    ata6: EH complete
    ata6.00: exception Emask 0x10 SAct 0x800000 SErr 0x400000 action 0x6 fr=
ozen
    ata6.00: irq_stat 0x08000000, interface fatal error
    ata6: SError: { Handshk }
    ata6.00: failed command: WRITE FPDMA QUEUED
    ata6.00: cmd 61/00:b8:f0:2a:85/02:00:03:00:00/40 tag 23 ncq 262144 out
             res 40/00:bc:f0:2a:85/00:00:03:00:00/40 Emask 0x10 (ATA bus er=
ror)
    ata6.00: status: { DRDY }
    ata6: hard resetting link
    ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
    ata6.00: configured for UDMA/133
    ata6: EH complete

I thought maybe it was just a temporary problem or related to
upgrading the kernel recently (3.17.1 -> 3.17.2) and not rebooting
yet, so I rebooted.

Since then, I could run cryptsetup luksOpen without problems, but
mounting the devices hanged for ~15 seconds and then returned without
error, but didn't mount anything.

When strace'ing mount, it hanged here:

    mount("/dev/mapper/data1", "/mnt/data", "btrfs", MS_MGC_VAL, NULL)

(which then returned 0). I didn't see anything in the kernel logs.

I then tried the following:

    # cryptsetup luksClose ... # for all 4 disks
    # cryptsetup luksOpen ...  # for all 4 disks
    # btrfs device scan --all-devices
    # mount /dev/mapper/data1 /mnt/data
    # mount /dev/mapper/secdata1 /mnt/data

The same thing happened, and I then saw this in the kernel logs:

    [Nov11 15:33] BTRFS info (device dm-3): disk space caching is enabled
    [Nov11 15:34] BTRFS info (device dm-3): disk space caching is enabled
    [Nov11 15:35] BTRFS info (device dm-3): disk space caching is enabled
    [Nov11 15:36] BTRFS info (device dm-3): disk space caching is enabled
    [Nov11 15:37] BTRFS info (device dm-3): disk space caching is enabled
    [ +16.054127] BTRFS: open_ctree failed
    [Nov11 15:38] BTRFS info (device dm-3): disk space caching is enabled
    [Nov11 16:02] BTRFS info (device dm-2): disk space caching is enabled

How could I mount these volumes again? Is it a good idea to use
btrfs-zero-log as described in [1]?

Some other information:

- Distribution: Archlinux
- uname -a: Linux moody 3.17.2-1-ARCH #1 SMP PREEMPT Thu Oct 30 20:49:39 CE=
T 2014 x86_64 GNU/Linux
- btrfs --version: Btrfs v3.17
- btrfs fi show:

    Label: 'secdata2'  uuid: 38267260-b656-4c66-a123-5f9214066ae1
            Total devices 2 FS bytes used 2.06TiB
            devid    1 size 3.64TiB used 2.06TiB path /dev/mapper/secdata2
            devid    2 size 3.64TiB used 2.06TiB path /dev/mapper/secdata1

    Label: 'data2'  uuid: b67ca50d-dbde-445d-922a-3479849b5499
            Total devices 2 FS bytes used 2.35TiB
            devid    1 size 2.73TiB used 2.69TiB path /dev/mapper/data1
            devid    3 size 2.73TiB used 2.69TiB path /dev/mapper/data2

- btrfs fi df /mnt/data:

    Data, single: total=3D58.42GiB, used=3D14.48GiB
    System, single: total=3D4.00MiB, used=3D12.00KiB
    Metadata, single: total=3D1.01GiB, used=3D471.80MiB
    GlobalReserve, single: total=3D160.00MiB, used=3D0.00B

- btrfs fi df /mnt/secdata

    Data, single: total=3D58.42GiB, used=3D14.48GiB
    System, single: total=3D4.00MiB, used=3D12.00KiB
    Metadata, single: total=3D1.01GiB, used=3D471.80MiB
    GlobalReserve, single: total=3D160.00MiB, used=3D0.00B

If there's anything else I can provide please let me know. Please Cc
me on replies, as I'm not on the list. Thanks in advance!

Florian

[1] https://btrfs.wiki.kernel.org/index.php/Btrfs-zero-log

--=20
http://www.the-compiler.org | me@the-compiler.org (Mail/XMPP)
             GPG 0xFD55A072 | http://the-compiler.org/pubkey.asc
         I love long mails! | http://email.is-not-s.ms/

--=_mehl.schokokeks.org-2872-1415721114-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUYjCZAAoJEJFusMj9VaByAhoQAIH8unlyo/9oOaHFkevqOiJd
eWalu6rNiA2zhFoBzr32g0S+ZlKATWbtCiicePjQuYnybf/27okV7OG7nFard/4A
VGPN41sDAuZ3tzhaCWfTK4jFiLytXmYv+mxyqEtEdJJrjenzr390a/YncErrZ9In
QXagjEBGAe/AB+N1QcbP8RyFFa0ES7pvFYveEPy0OvWN7CoWlFmbfqgKjAMImB4+
1m7wjIr3iHkhQ85YuQOa8cBzW9/8pBigOqq0zfHQ/cJ2cJ2/ZbOCwKTp79qdEGG3
2Rwmw8iE2PyIhDz9CZgsIL8ueoz9v8Wbv6+CTuYvAV6JyPBVggvjDjVN8GmVXNqp
n7Wo9bENBkrUj1Xk2YCpst9kJSHLjjoyCQmHCdQdexldcXis8K9wFktGz/E3R+6F
mIJp/ThptpVjgCdmJIarNcX4ZZNfM4T/Q15j4/nPkCd5QVIuVtkqLiaAeJyg611q
lGCcJOr2bqTllGKtzoFfV6PXcDB64xCEZL35ieETh3EUfNxxWKY6TOESIzUTmQ81
kEbbez/ri97U+2ko/9unROT/cVOJhnMtP9YuLfivn535pgR3gpuMDpI6GvBAmVeW
RvLRtQ40IYvP1rR2S15a88qnkXExbHvn7cb5xBRVgfqJ2fkQcryog1Hd6DPqtexJ
tClo+X999fMh+HG91bdL
=ZbwP
-----END PGP SIGNATURE-----

--=_mehl.schokokeks.org-2872-1415721114-0001-2--
