Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:36785 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbbFKAFj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jun 2015 20:05:39 -0400
Received: by igbpi8 with SMTP id pi8so46409060igb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2015 17:05:38 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 10 Jun 2015 21:05:38 -0300
Message-ID: <CAEko1BmP0Rrf5ng5Gqo56SzRhGdJzBE7w=-x--T2EBv81iaT6w@mail.gmail.com>
Subject: Does raid56 work on latest kernel?
From: =?UTF-8?Q?Guilherme_Gon=C3=A7alves?= <agamennon@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!,  use arch linux with the latest kernel, i am trying to do raid
5 on 3 devices, but i get this on
btfs fi usage:

"WARNING: RAID56 detected, not implemented"

what is not implemented?

full output:

WARNING: RAID56 detected, not implemented
WARNING: RAID56 detected, not implemented
WARNING: RAID56 detected, not implemented
Overall:
    Device size:   8.19TiB
    Device allocated:  20.00MiB
    Device unallocated:   8.19TiB
    Device missing:     0.00B
    Used:     0.00B
    Free (estimated):   2.05PiB (min: 8.19TiB)
    Data ratio:      0.00
    Metadata ratio:      0.00
    Global reserve:  16.00MiB (used: 0.00B)

Data,single: Size:8.00MiB, Used:0.00B
   /dev/sdc   8.00MiB

Data,RAID5: Size:2.00GiB, Used:1.00MiB
   /dev/sdc   1.00GiB
   /dev/sde   1.00GiB
   /dev/sdf   1.00GiB

Metadata,single: Size:8.00MiB, Used:0.00B
   /dev/sdc   8.00MiB

Metadata,RAID5: Size:2.00GiB, Used:112.00KiB
   /dev/sdc   1.00GiB
   /dev/sde   1.00GiB
   /dev/sdf   1.00GiB

System,single: Size:4.00MiB, Used:0.00B
   /dev/sdc   4.00MiB

System,RAID5: Size:16.00MiB, Used:16.00KiB
   /dev/sdc   8.00MiB
   /dev/sde   8.00MiB
   /dev/sdf   8.00MiB

Unallocated:
   /dev/sdc   2.73TiB
   /dev/sde   2.73TiB
   /dev/sdf   2.73TiB


Output of btrfs fi show

Label: 'NAS'  uuid: a34ffd88-54b8-42d7-b9f0-fc67c98af3c9
Total devices 3 FS bytes used 1.12MiB
devid    1 size 2.73TiB used 2.03GiB path /dev/sdc
devid    2 size 2.73TiB used 2.01GiB path /dev/sde
devid    3 size 2.73TiB used 2.01GiB path /dev/sdf

Label: 'bkpd'  uuid: 41699e82-8e9b-41d6-a03d-373fde1a6230
Total devices 1 FS bytes used 828.34GiB
devid    1 size 2.73TiB used 832.04GiB path /dev/sdd

btrfs-progs v4.0.1

does it work on my kernel (4.0.5-1-ARCH), i know it was incomplete
before, but now on 4.0 does it work despite it being new? what is "not
implemented" on the message mean?
