From: Jeremy Atkins <antrat@gmail.com>
Subject: 'filesystem resize max' tries to use devid 1
Date: Sun, 22 Apr 2012 23:03:06 -0400
Message-ID: <CAJwq8q6Dd-Z6z=1H5h8m9TE8aBioY9x99ZBsGWa7pRdbVtDZOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Back story:
I started my pool with a 200gb partition at the end of my drive (sdc5)
, until I was able to clear out the data at the beginning of my drive.
 When I was ready, I ran `btrfs dev add /dev/sdc4 /` then `btrfs dev
del /dev/sdc5 /`,

$ sudo btrfs fi resize max /
Resize '/' of 'max'
ERROR: unable to resize '/' - Invalid argument

in dmesg i see:
[ =A0 72.729685] btrfs: resizer unable to find device 1

$ sudo btrfs fi df /
Data: total=3D34.00GB, used=3D17.79GB
System, DUP: total=3D64.00MB, used=3D20.00KB
Metadata, DUP: total=3D33.50GB, used=3D394.93MB

$ sudo btrfs fi sh
Label: none =A0uuid: b0ad55e2-09e0-4658-8cab-d2e11ba03753
=A0 =A0 =A0 =A0 Total devices 1 FS bytes used 17.18GB
=A0 =A0 =A0 =A0 devid =A0 =A02 size 1.62TB used 101.12GB path /dev/sdc4


$ uname -r
3.3.2-1.fc16.x86_64

btrfs-progs version is current git master ( commit 1957076 )

After writing this email, and searching around the wiki some, I
discovered the command to resize specific devids,

[antrat@tbox ~]$ sudo btrfs fi resize 2:max /
Resize '/' of '2:max'

and in dmesg:
[ 1661.933884] btrfs: resizing devid 2
[ 1661.933895] btrfs: new size for /dev/sdc4 is 1995564908544
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
