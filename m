Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64771 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaCVABM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Mar 2014 20:01:12 -0400
Received: by mail-oa0-f46.google.com with SMTP id i7so3367458oag.33
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Mar 2014 17:01:12 -0700 (PDT)
MIME-Version: 1.0
From: Jon Nelson <jnelson@jamponi.net>
Date: Fri, 21 Mar 2014 19:00:51 -0500
Message-ID: <CAKuK5J0LyagDYro6Yq7h-p-VjbwrbeuFf9AdNwRNg0jv3bq9QQ@mail.gmail.com>
Subject: fresh btrfs filesystem, out of disk space, hundreds of gigs free
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Using openSUSE 13.1 on x86_64 which - as of this writing - is 3.11.10,
I tried to copy a bunch of files over to a btrfs filesystem (which was
mounted as /, in fact).

After some time, things ground to a halt and I got out of disk space errors.
btrfs fi df /   showed about 1TB of *data* free, and 500MB of metadata free.

Below are the btrfs fi df /    and   btrfs fi show.
I ended up having to reboot the machine. I was not able to get the
machine to boot again after that, and ended up having to resort to a
rescue environment, at which point I copied everything over to an ext4
filesystem.

This is this first time I have tried btrfs since I experienced
(unfixable) corruption a year or so back, with 3.7 and up. I was led
to believe that the ENOSPC errors had been resolved.

Would a more recent kernel than 3.11 have done me any good?


turnip:~ # btrfs fi df /
Data, single: total=1.80TiB, used=832.22GiB
System, DUP: total=8.00MiB, used=204.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=5.50GiB, used=5.00GiB
Metadata, single: total=8.00MiB, used=0.00
turnip:~ # btrfs fi show
Label: none  uuid: 9379c138-b309-4556-8835-
0f156b863d29
        Total devices 1 FS bytes used 837.22GiB
        devid    1 size 1.81TiB used 1.81TiB path /dev/sda3

Btrfs v3.12+20131125


-- 
Jon
Software Blacksmith
