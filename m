Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:35801 "EHLO
	mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbcFASaD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jun 2016 14:30:03 -0400
Received: by mail-vk0-f67.google.com with SMTP id f62so4678118vkc.2
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jun 2016 11:30:02 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 1 Jun 2016 20:30:00 +0200
Message-ID: <CAE8gLhm0-+kkwFv1-+t+tWLrZrzh4B9cJUDRrgPpwfvB_obVCA@mail.gmail.com>
Subject: "No space left on device" and balance doesn't work
From: MegaBrutal <megabrutal@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I have a 20 GB file system and df says I have about 2,6 GB free space,
yet I can't do anything on the file system because I get "No space
left on device" errors. I read that balance may help to remedy the
situation, but it actually doesn't.


Some data about the FS:


root@ReThinkCentre:~# df -h /
Fájlrendszer                Méret Fogl. Szab. Fo.% Csatol. pont
/dev/mapper/centrevg-rootlv   20G   18G  2,6G  88% /

root@ReThinkCentre:~# btrfs fi show /
Label: 'RootFS'  uuid: 3f002b8d-8a1f-41df-ad05-e3c91d7603fb
        Total devices 1 FS bytes used 15.42GiB
        devid    1 size 20.00GiB used 20.00GiB path /dev/mapper/centrevg-rootlv

root@ReThinkCentre:~# btrfs fi df /
Data, single: total=16.69GiB, used=14.14GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=1.62GiB, used=1.28GiB
GlobalReserve, single: total=352.00MiB, used=0.00B

root@ReThinkCentre:~# btrfs version
btrfs-progs v4.4


This happens when I try to balance:

root@ReThinkCentre:~# btrfs fi balance start -dusage=66 /
Done, had to relocate 0 out of 33 chunks
root@ReThinkCentre:~# btrfs fi balance start -dusage=67 /
ERROR: error during balancing '/': No space left on device
There may be more info in syslog - try dmesg | tail


"dmesg | tail" does not show anything related to this.

It is important to note that the file system currently has 32
snapshots of / at the moment, and snapshots taking up all the free
space is a plausible explanation. Maybe deleting some of the oldest
snapshots or just increasing the file system would help the situation.
However, I'm still interested, if the file system is full, why does df
show there is free space, and how could I show the situation without
having the mentioned options? I actually have an alert set up which
triggers when the FS usage reaches 90%, so then I know I have to
delete some old snapshots. It worked so far, I cleaned the snapshots
at 90%, FS usage fell back, everyone was happy. But now the alert
didn't even trigger because the FS is at 88% usage, so it shouldn't be
full yet.


Best regards and kecske,
MegaBrutal
