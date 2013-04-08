Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:45789 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933969Ab3DHHtR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Apr 2013 03:49:17 -0400
Received: by mail-la0-f47.google.com with SMTP id fj20so5010998lab.6
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Apr 2013 00:49:16 -0700 (PDT)
MIME-Version: 1.0
From: Harald Glatt <mail@hachre.de>
Date: Mon, 8 Apr 2013 09:48:55 +0200
Message-ID: <CAFWF=ameE9p4W5XT-yLoU2H=by0Y4yp3VUmiLOXSOtOzBHaYwQ@mail.gmail.com>
Subject: btrfs can't complete balance
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I've managed to ruin my btrfs filesystem, but I don't know how. I
basically have it split up into two subvolumes, one for the root and
one for home both of which are creating hourly snapshots.

I've 'btrfs send' some of those to an external machine every now and
then. (At least once a day)

At some point 'btrfs send' stopped working but gave no better error
message than invalid argument.

I did a balance on the drive which resulted in a kernel panic after a
while of working. It then repeated the balance automatically on the
next bootup until it finally said 'balance failed' when I checked with
btrfs fi balance status.

I'm running a funky setup here where two partitions on the same drive
are both added into the same btrfs volume resulting in this setup:

Label: none  uuid: 4e74fa05-4bf2-40da-946b-8cd53ce92242
Total devices 2 FS bytes used 54.60GB
devid    1 size 60.52GB used 52.04GB path /dev/sda7
devid    2 size 16.32GB used 8.03GB path /dev/sda5

Data: total=54.00GB, used=53.51GB
System, RAID1: total=32.00MB, used=12.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=3.00GB, used=1.11GB

The state that I'm in is that everything is working, I haven't found
any data corruption, scrubs work and confirm that there are no errors
but I can no longer use 'btrfs send' to create differential images and
I can also no longer complete a balance.

I tried running balance start -dconvert=single to get rid of my second
partition but that also failed (without a panic though)

I have backed up the newest state of the filesystem via rsync and am
about to wipe and restore from backup with a new fs.

Is anyone interested in a btrfs-image to debug this state? If so
please tell me what command to run since I have never done this
before...

Thanks
Harald
