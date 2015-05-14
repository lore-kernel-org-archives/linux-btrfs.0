Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34251 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030221AbbENVNK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 May 2015 17:13:10 -0400
Received: by obfe9 with SMTP id e9so62613608obf.1
        for <linux-btrfs@vger.kernel.org>; Thu, 14 May 2015 14:13:09 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 14 May 2015 17:13:09 -0400
Message-ID: <CABEfQpnp4fs+7tVw8Y=g_bzuusuL9c2b0iFNt0Nd+GALMvtOfA@mail.gmail.com>
Subject: BTRFS Cancel/Resume + Scrub (Large FS)
From: Izzy Condie <icondie@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Good day all,

I've been happily using BTRFS for awhile on my home NAS server.  A few
months ago I switched from an underlying MDADM raid with BTRFS ontop,
to a native BTRFS w/ RAID6 Profile.  While I normally have 8 drives, I
am currently in process of RMA'ing a bad drive so you will see only 7
in my current setup.

root@maizy /media/Linux # uname -a
Linux maizy 4.0.0-trunk-amd64 #1 SMP Debian 4.0-1~exp1 (2015-04-21)
x86_64 GNU/Linux
root@maizy /media/Linux # btrfs --version
btrfs-progs v4.0
root@maizy /media/Linux # btrfs fi show .
Label: 'maizy:media'  uuid: e878553f-888f-425d-bf75-97ffeb6e0d0d
        Total devices 7 FS bytes used 11.02TiB
        devid    1 size 5.46TiB used 2.21TiB path /dev/sdb
        devid    2 size 5.46TiB used 2.21TiB path /dev/sdc
        devid    3 size 5.46TiB used 2.21TiB path /dev/sdd
        devid    4 size 5.46TiB used 2.21TiB path /dev/sde
        devid    6 size 5.46TiB used 2.21TiB path /dev/sdf
        devid    7 size 5.46TiB used 2.21TiB path /dev/sdh
        devid    8 size 5.46TiB used 2.21TiB path /dev/sdg

btrfs-progs v4.0
root@maizy /media/Linux # btrfs fi df .
Data, single: total=8.00MiB, used=0.00B
Data, RAID6: total=11.03TiB, used=11.01TiB
System, single: total=4.00MiB, used=0.00B
System, RAID6: total=80.00MiB, used=720.00KiB
Metadata, single: total=8.00MiB, used=0.00B
Metadata, RAID6: total=13.20GiB, used=11.64GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

The problem(s) I'm seeing all come from a root problem:  scrub takes
over a week to finish.  Because scrub takes so long I have tried to
setup a cancel and resume operation until it finishes.  I've noted
that after a resume, a btrfs scrub will do some "seeming" arbitrary
amount more of scrubbing then exit clean.  It doesn't seem to ever
finish whats actually leftover to scrub.  I don't know if this is by
design or if I'm missing something.

A point that I see often is that scrubbing daily or weekly is
recommended, but I can't do that as a single scrub takes over a week.
It doesn't seem logical to assume that my FS should be in constant
scrub (starting another as soon as it finishes).  I am under the
assumption that RAID improvements to BTRFS will speed this up over
time, however cancel and resume seems broken to me.  I didn't see a
bug open or closed regarding this on bugzilla so I wanted to open a
dialog here before opening one myself (I have to remember my bugzilla
accnt info).

Regards all,
Izzy Condie
