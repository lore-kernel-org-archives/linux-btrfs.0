Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:56818 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab3CUPEn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 11:04:43 -0400
Received: by mail-ob0-f172.google.com with SMTP id tb18so2964864obb.31
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 08:04:43 -0700 (PDT)
MIME-Version: 1.0
From: Jon Nelson <jnelson@jamponi.net>
Date: Thu, 21 Mar 2013 10:04:22 -0500
Message-ID: <CAKuK5J05iXaDd7Q4fLby9vJyPXBURx06xb0_--WmgTpJ0j2RoA@mail.gmail.com>
Subject: btrfs-show vs. btrfs different output
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm running openSUSE 12.3 x86_64 which has an unknown git version, but
reports v0.19.
I'm also supplying the output from git which reports itself as:
v0.20-rc1-253-g7854c8b

The problem is that btrfs-show (git) and btrfs fi show (git) give
/different/ output from each other which is also different from the
(older) btrfs.

First btrfs-show (git):

**
** WARNING: this program is considered deprecated
** Please consider to switch to the btrfs utility
**
Label: none  uuid: b5dc52bd-21bf-4173-8049-d54d88c82240
        Total devices 2 FS bytes used 230.34GB
        devid    1 size 298.09GB used 298.09GB path /dev/sda
        *** Some devices missing

Label: none  uuid: 7feedf1e-9711-4900-af9c-92738ea8aace
        Total devices 4 FS bytes used 348.21GB
        devid    4 size 460.76GB used 444.23GB path /dev/sdb3
        devid    3 size 460.76GB used 444.23GB path /dev/sda3
        devid    6 size 298.09GB used 282.53GB path /dev/sdc
        devid    5 size 298.09GB used 282.53GB path /dev/sdd

Btrfs v0.20-rc1-253-g7854c8b


Now btrfs fi show (git):

failed to open /dev/sr0: No medium found
Label: none  uuid: 7feedf1e-9711-4900-af9c-92738ea8aace
        Total devices 4 FS bytes used 348.21GB
        devid    5 size 298.09GB used 282.53GB path /dev/sdd
        devid    6 size 298.09GB used 282.53GB path /dev/sdc
        devid    4 size 460.76GB used 444.23GB path /dev/sdb3
        devid    3 size 460.76GB used 444.23GB path /dev/sda3

Label: none  uuid: b5dc52bd-21bf-4173-8049-d54d88c82240
        Total devices 2 FS bytes used 230.34GB
        devid    1 size 298.09GB used 298.09GB path /dev/sdb
        *** Some devices missing

Btrfs v0.20-rc1-253-g7854c8b


And now the (older) btrfs fi show:

failed to read /dev/sr0
Label: none  uuid: 7feedf1e-9711-4900-af9c-92738ea8aace
        Total devices 4 FS bytes used 348.21GB
        devid    5 size 298.09GB used 282.53GB path /dev/sdd
        devid    6 size 298.09GB used 282.53GB path /dev/sdc
        devid    4 size 460.76GB used 444.23GB path /dev/sdb3
        devid    3 size 460.76GB used 444.23GB path /dev/sda3

Btrfs v0.19+

which has similar output to the (older) btrfs-show.


The differences are:

1. the order of devices varies (not a big deal)
2. the current git btrfs-show and btrfs fi show both output
*different* devices for device with UUID
b5dc52bd-21bf-4173-8049-d54d88c82240, and they're both wrong.

Somewhat confusingly, /dev/disk/by-uuid/ only shows three devices:

bd40cb4e-93bb-4600-8455-ca1185aa8abe -> ../../md3
7feedf1e-9711-4900-af9c-92738ea8aace -> ../../sda3
4f0b27a5-5f5b-413c-a71b-b5a3bec5482c -> ../../md2

What's going on with the varied output from (git) btrfs-show vs.
'btrfs fi show' (vs. the older, as-shipped btrfs)?


-- 
Jon
Software Blacksmith
