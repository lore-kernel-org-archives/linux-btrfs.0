From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: balancing metadata fails with no space left on device
Date: Fri, 4 May 2012 18:35:39 +0200
Message-ID: <201205041835.39441.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

merkaba:~> btrfs balance start -m /
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail
merkaba:~#19> dmesg | tail -22
[   62.918734] CPU0: Package power limit normal
[  525.229976] btrfs: relocating block group 20422066176 flags 1
[  526.940452] btrfs: found 3048 extents
[  528.803778] btrfs: found 3048 extents
[  528.988440] btrfs: relocating block group 17746100224 flags 34
[  529.116424] btrfs: found 1 extents
[  529.247866] btrfs: relocating block group 17611882496 flags 36
[  536.003596] btrfs: found 14716 extents
[  536.170073] btrfs: relocating block group 17477664768 flags 36
[  542.230713] btrfs: found 13170 extents
[  542.353089] btrfs: relocating block group 17343447040 flags 36
[  547.446369] btrfs: found 9809 extents
[  547.663141] btrfs: 1 enospc errors during balance
[  629.238168] btrfs: relocating block group 21894266880 flags 34
[  629.359284] btrfs: found 1 extents
[  629.520614] btrfs: 1 enospc errors during balance
[  630.715766] btrfs: relocating block group 21927821312 flags 34
[  630.749973] btrfs: found 1 extents
[  630.899621] btrfs: 1 enospc errors during balance
[  635.872857] btrfs: relocating block group 21961375744 flags 34
[  635.906517] btrfs: found 1 extents
[  636.038096] btrfs: 1 enospc errors during balance


merkaba:~> btrfs filesystem show
failed to read /dev/sr0
Label: 'debian'  uuid: [=E2=80=A6]
        Total devices 1 FS bytes used 7.89GB
        devid    1 size 18.62GB used 17.58GB path /dev/dm-0


Btrfs Btrfs v0.19
merkaba:~> btrfs filesystem df /
Data: total=3D15.52GB, used=3D7.31GB
System, DUP: total=3D32.00MB, used=3D4.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, DUP: total=3D1.00GB, used=3D587.83MB


This is repeatable.

martin@merkaba:~> cat /proc/version
Linux version 3.3.0-trunk-amd64 (Debian 3.3.4-1~experimental.1) (debian=
-
kernel  AT  lists.debian.org) (gcc version 4.6.3 (Debian 4.6.3-1) ) #1 =
SMP=20
Wed May 2 06:54:24 UTC 2012


Which is Debian=C2=B4s variant of 3.3.4 with

commit bfe050c8857bbc0cd6832c8bf978422573c439f5
Author: Chris Mason <chris.mason  AT  oracle.com>
Date:   Thu Apr 12 13:46:48 2012 -0400

    Revert "Btrfs: increase the global block reserve estimates"
   =20
    commit 8e62c2de6e23e5c1fee04f59de51b54cc2868ca5 upstream.
   =20
    This reverts commit 5500cdbe14d7435e04f66ff3cfb8ecd8b8e44ebf.
   =20
    We've had a number of complaints of early enospc that bisect down
    to this patch.  We'll hae to fix the reservations differently.
   =20
    Signed-off-by: Chris Mason <chris.mason  AT  oracle.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh  AT  linuxfoundation.org>

from 3.3.3.

May I need to wait for a proper fix to global block reserve for the bal=
ance=20
to succeed or do I see a different issue?


Since scrubbing still works I take it that balancing was aborted=20
gracefully and thus the filesystem is still intact. This is on a ThinkP=
ad=20
T520 with Intel SSD 320. I only wanted to reorder metadata trees, I do =
not=20
think it makes much sense to relocate data blocks on a SSD. Maybe the=20
reordering metadata blocks may not make much sense also, but I thought =
I=20
still report this.

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
