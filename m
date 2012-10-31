Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35579 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935108Ab2JaIsv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 04:48:51 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so1696789iea.19
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2012 01:48:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE5mzvgMskhBgH506BageXREifs63Zn_HKDaWBMuesS8Np66SQ@mail.gmail.com>
References: <508FB45B.9040101@gmail.com>
	<508FC26A.1010206@pepinghege.net>
	<CAE5mzvhkrV9XD3_X_w_eLk7R4jrf4PxhEBJYTU7Hr6YtFDDd6Q@mail.gmail.com>
	<50904949.8010603@gmail.com>
	<20121030221412.GB11422@carfax.org.uk>
	<20121030221947.GC11422@carfax.org.uk>
	<50906702.1010608@gmail.com>
	<CAE5mzvgMskhBgH506BageXREifs63Zn_HKDaWBMuesS8Np66SQ@mail.gmail.com>
Date: Wed, 31 Oct 2012 09:48:51 +0100
Message-ID: <CAFDW0j+1wx2_ZewQ69W7fyLuMyYxq29g62FGH5uX9kAFv-H3eQ@mail.gmail.com>
Subject: Re: Why btrfs inline small file by default?
From: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
To: cwillu <cwillu@cwillu.com>
Cc: ching <lsching17@gmail.com>, Hugo Mills <hugo@carfax.org.uk>,
        Felix Pepinghege <postfach@pepinghege.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

i also dont see any benefit from inlining small files:

this example is me doing a fully fledged prebuilt
gentoo system installation on a fresh HDD from
squashfs image on usb key in under 5 minutes:

with defaults (inlining small files):

# mount -o noatime,compress=lzo /dev/sda2 /mnt/point
# time unsquashfs -f -d /mnt/point/ /dev/sdb2
real    4m39.253s
user    1m37.854s
sys     1m1.433s

# btrfs filesystem show
Label: 'root'  uuid: 6fb7104d-8f4a-4f3a-aff8-fdad0a39f569
        Total devices 1 FS bytes used 10.05GB
        devid    1 size 232.63GB used 14.04GB path /dev/sda2

Btrfs v0.20-rc1

# btrfs filesystem df /mnt/point/
Data: total=10.01GB, used=9.08GB
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=2.00GB, used=992.48MB
Metadata: total=8.00MB, used=0.00

without inline:

# mount -o max_inline=0,noatime,compress=lzo /dev/sda2 /mnt/point
# time unsquashfs -f -d /mnt/point/ /dev/sdb2
real    4m42.085s
user    1m36.894s
sys     1m1.583s

# btrfs filesystem show
failed to read /dev/sr0
Label: 'root'  uuid: 97ad3c97-ab03-4197-86d3-72869604b368
        Total devices 1 FS bytes used 11.36GB
        devid    1 size 232.63GB used 13.04GB path /dev/sda2

Btrfs v0.20-rc1

# btrfs filesystem df /mnt/point/
Data: total=11.01GB, used=10.85GB
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.00GB, used=518.59MB
Metadata: total=8.00MB, used=0.00

i will test "no inlining" for some more time though.

Ahmet
