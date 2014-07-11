Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44788 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbaGKLnB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jul 2014 07:43:01 -0400
Received: by mail-vc0-f174.google.com with SMTP id hy4so1756724vcb.33
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Jul 2014 04:43:00 -0700 (PDT)
MIME-Version: 1.0
From: constantine <costas.magnuse@gmail.com>
Date: Fri, 11 Jul 2014 13:42:40 +0200
Message-ID: <CANcfdL3ZUwOGPf2YQpyXYSd8ZoNntyaX8rdQXdciSADGCsb-Sg@mail.gmail.com>
Subject: Btrfs and LBA errors
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everybody!

Btrfs filesystem could not be mounted because /dev/sdc1 had unreadable sectors.
It is/was  a single filesystem (not raid1 or raid0) over /dev/sda1 and
/dev/sdc1.
I wrote the unreadable sectors with hdparm but filesystem still cannot
be mounted (sectors were too early perhaps).

What should be my next step  for recovering the btrfs filesystem?


#### Analytically:

After
# smartctl -t long /dev/sdc
I got
"Extended offline   Completed: read failure   90%   19662   2176"

So LBA_of_first_error: 2176

With
# hdparm --read-sector
I found out that 2176-2183 LBA sectors were unreadable.

I wrote them with
# hdparm --write-sector
and now smartctl does not report any error.

However when I run
# btrfs fi show
I get:

Label: 'partition'  uuid: c1eb1aaf-665a-4337-9d04-3c3921aa67e0
        Total devices 2 FS bytes used 1.53TiB
        devid    2 size 1.37TiB used 195.00GiB path /dev/sda1
        *** Some devices missing


#### Complementary Information
# uname -a
Linux hostname 3.15.5-031505-generic #201407091543 SMP Wed Jul 9
19:44:36 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

#   btrfs --version
Btrfs v3.12

#   btrfs fi show
Label: 'partition'  uuid: c1eb1aaf-665a-4337-9d04-3c3921aa67e0
        Total devices 2 FS bytes used 1.53TiB
        devid    2 size 1.37TiB used 195.00GiB path /dev/sda1
        *** Some devices missing

Btrfs v3.12

# btrfs fi df /mnt/partition
ERROR: couldn't get space info - Inappropriate ioctl for device
ERROR: get_df failed Inappropriate ioctl for device
