Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:46542 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab3JaOv3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Oct 2013 10:51:29 -0400
Received: by mail-vc0-f179.google.com with SMTP id hz11so2006883vcb.38
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Oct 2013 07:51:29 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 31 Oct 2013 10:51:28 -0400
Message-ID: <CAC4gV=4Y-Yn4Wc=VSXTONPaaxA1t_GSN6JR2ZPzh59mOWNPy4A@mail.gmail.com>
Subject: Balance empty filesystem loses raid profile for data
From: Frank Holton <fholton@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So I just noticed this while running some tests and am not sure if
this is the expected behavior but it doesn't seem right to me.

If you run a balance on an empty filesystem, it removes all of the
data chunks. Writing files to the fs results in a new data chunk being
allocated of type single completely ignoring what the filesystem was
created with.

./btrfs version
Btrfs v0.20-rc1-548-g4597c6d-dirty (newest btrfs-progs-integration)

Tested on kernels 3.11 and 3.12rc6

Results of df after sudo mkfs.btrfs -m raid1 -d raid0 -L test
/dev/loop0 /dev/loop1
Data, RAID0: total=2.00GiB, used=0.00
Data, single: total=8.00MiB, used=0.00
System, RAID1: total=8.00MiB, used=4.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, RAID1: total=1.00GiB, used=24.00KiB
Metadata, single: total=8.00MiB, used=0.00

After sudo btrfs balance start /test/
System, RAID1: total=32.00MiB, used=4.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, RAID1: total=256.00MiB, used=24.00KiB

And after writing new files to the fs
Data, single: total=1.00GiB, used=10.31MiB
System, RAID1: total=32.00MiB, used=4.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, RAID1: total=256.00MiB, used=40.00KiB

Now it has reverted to single for data raid type. Also is btrfs.mkfs
supposed to make all of those single chunks?

Thanks for reading,
Frank
