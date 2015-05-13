Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:35300 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933668AbbEMKr7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 06:47:59 -0400
Received: by obcus9 with SMTP id us9so26478935obc.2
        for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2015 03:47:59 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 13 May 2015 18:47:59 +0800
Message-ID: <CALq5X_g0jOkeS-R0ah0zyV8tQ8AH38skV_os2_JOo3hYNQ+H9A@mail.gmail.com>
Subject: Failed RAID0=> RAID1 Conversion
From: David Alcorn <nroclaed@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I run Debian Jessie with a kernel upgrade to 4.0.0 from the Debian
experimental repository.  My BTRFS-Tools remain at 3.17.-1  I wanted
to convert a RAID0 array on /dev/sdb3 and /dev sdc3  from RAID0  to
RAID1 so I ran the commands:

	mount /dev/sdb3 /mnt
	btrfs device add -f /dev/sdc3 /mnt
	btrfs balance start -dconvert=raid1 -mconvert=raid1 /mnt

All appeared well with output similar to "395 of 395 chunks converted"
but I think nothing happened.  The array contains a subvolume @export
with size (per "du -sh @export") of  442G.  The pertinent output from
"btrfs filesystem show" reports:

	Label: none  uuid: 647eb0f8-7732-40bc-a4a4-0d1b31a8ae16	
		Total devices 2 FS bytes used 443.05GiB
		devid    1 size 1.36TiB used 223.03GiB path /dev/sdb3
		devid    2 size 1.36TiB used 223.03GiB path /dev/sdc3

My array remains RAID0 if I understand the above output correctly.
This output persist through a reboot and no data was lost.  Where did
I err?
