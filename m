Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:45382 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbeGaTpR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jul 2018 15:45:17 -0400
Received: by mail-ua0-f174.google.com with SMTP id k8-v6so10886828uaq.12
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2018 11:03:48 -0700 (PDT)
MIME-Version: 1.0
From: Cerem Cem ASLAN <ceremcem@ceremcem.net>
Date: Tue, 31 Jul 2018 21:03:47 +0300
Message-ID: <CAN4oSBc8zM+OZEXAGygwf3RMoyEKLmrk--_HqwMsG1HVGJCf2Q@mail.gmail.com>
Subject: Unmountable root partition
To: linux-btrfs@vger.kernel.org
Content-Type: multipart/alternative; boundary="00000000000050f68b05724f662b"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--00000000000050f68b05724f662b
Content-Type: text/plain; charset="UTF-8"

Hi,

I'm having trouble with my server setup, which contains a BTRFS root
partition on top of LVM on top of LUKS partition.

Yesterday server was shut down unexpectedly. I booted the system with a
pendrive which contains Debian 4.9.18 and tried to mount the BTRFS root
partition manually.

1. cryptsetup luksOpen /dev/sda5

Seems to decrypt the partition (there are no errors)

2. /dev/mapper/foo--vg-root and /dev/mapper/foo--vg-swap_1 is created
automatically, so I suppose LVM works correctly.

3. mount -t btrfs /dev/mapper/foo--vg-root /mnt/foo
Gives the following error:

mount: wrong fs type, bad option, bad superblock on ...

4. dmesg | tail
Outputs the following:


[17755.840916] sd 3:0:0:0: [sda] tag#0 FAILED Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[17755.840919] sd 3:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 07 c0 02 00
00 02 00
[17755.840921] blk_update_request: I/O error, dev sda, sector 507906
[17755.840941] EXT4-fs (dm-4): unable to read superblock
[18140.052300] sd 3:0:0:0: [sda] tag#0 FAILED Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[18140.052305] sd 3:0:0:0: [sda] tag#0 CDB: ATA command pass through(16) 85
06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[18142.991851] sd 3:0:0:0: [sda] tag#0 FAILED Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[18142.991856] sd 3:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 07 c0 80 00
00 08 00
[18142.991860] blk_update_request: I/O error, dev sda, sector 508032
[18142.991869] Buffer I/O error on dev dm-4, logical block 16, async page
read


4.

# btrfs restore -i -D /dev/mapper/foo--vg-root /dev/null
No valid Btrfs found on /dev/mapper/foo--vg-root
Could not open root, trying backup super
No valid Btrfs found on /dev/mapper/foo--vg-root
Could not open root, trying backup super
No valid Btrfs found on /dev/mapper/foo--vg-root
Could not open root, trying backup super

We are pretty sure that no unexpected electric cuts has been happened.

At this point I don't know what information I should supply.

--00000000000050f68b05724f662b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,=C2=A0<div><br></div><div>I&#39;m having trouble with m=
y server setup, which contains a BTRFS root partition on top of LVM on top =
of LUKS partition.=C2=A0</div><div><br></div><div>Yesterday server was shut=
 down unexpectedly. I booted the system with a pendrive which contains Debi=
an 4.9.18 and tried to mount the BTRFS root partition manually.=C2=A0</div>=
<div><br></div><div>1. cryptsetup luksOpen /dev/sda5=C2=A0</div><div><br></=
div><div>Seems to decrypt the partition (there are no errors)=C2=A0</div><d=
iv><br></div><div>2. /dev/mapper/foo--vg-root and /dev/mapper/foo--vg-swap_=
1 is created automatically, so I suppose LVM works correctly.=C2=A0</div><d=
iv><br></div><div>3. mount -t btrfs /dev/mapper/foo--vg-root /mnt/foo=C2=A0=
</div><div>Gives the following error:=C2=A0</div><div><br></div><blockquote=
 style=3D"margin:0px 0px 0px 40px;border:none;padding:0px"><div>mount: wron=
g fs type, bad option, bad superblock on ...</div><div><br></div></blockquo=
te>4. dmesg | tail=C2=A0<div>Outputs the following:=C2=A0</div><div><blockq=
uote style=3D"margin:0px 0px 0px 40px;border:none;padding:0px"><div><br></d=
iv><div><div>[17755.840916] sd 3:0:0:0: [sda] tag#0 FAILED Result: hostbyte=
=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK</div></div><div><div>[17755.840919=
] sd 3:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 07 c0 02 00 00 02 00</div>=
</div><div><div>[17755.840921] blk_update_request: I/O error, dev sda, sect=
or 507906</div></div><div><div>[17755.840941] EXT4-fs (dm-4): unable to rea=
d superblock</div></div><div><div>[18140.052300] sd 3:0:0:0: [sda] tag#0 FA=
ILED Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK</div></div><d=
iv><div>[18140.052305] sd 3:0:0:0: [sda] tag#0 CDB: ATA command pass throug=
h(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00</div></div><div><div>=
[18142.991851] sd 3:0:0:0: [sda] tag#0 FAILED Result: hostbyte=3DDID_BAD_TA=
RGET driverbyte=3DDRIVER_OK</div></div><div><div>[18142.991856] sd 3:0:0:0:=
 [sda] tag#0 CDB: Read(10) 28 00 00 07 c0 80 00 00 08 00</div></div><div><d=
iv>[18142.991860] blk_update_request: I/O error, dev sda, sector 508032</di=
v></div><div><div>[18142.991869] Buffer I/O error on dev dm-4, logical bloc=
k 16, async page read</div></div></blockquote></div><div><br></div><div>4.=
=C2=A0</div><div><br></div><blockquote style=3D"margin:0 0 0 40px;border:no=
ne;padding:0px"><div><div># btrfs restore -i -D /dev/mapper/foo--vg-root /d=
ev/null</div></div><div><div>No valid Btrfs found on /dev/mapper/foo--vg-ro=
ot</div></div><div><div>Could not open root, trying backup super</div></div=
><div><div>No valid Btrfs found on /dev/mapper/foo--vg-root</div></div><div=
><div>Could not open root, trying backup super</div></div><div><div>No vali=
d Btrfs found on /dev/mapper/foo--vg-root</div></div><div><div>Could not op=
en root, trying backup super</div></div><div><br></div></blockquote>We are =
pretty sure that no unexpected electric cuts has been happened.=C2=A0<div><=
br></div>At this point I don&#39;t know what information I should supply.=
=C2=A0<br><div><div><br></div></div></div>

--00000000000050f68b05724f662b--
