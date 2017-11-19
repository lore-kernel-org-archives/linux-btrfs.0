Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:42825 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbdKSTby (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 Nov 2017 14:31:54 -0500
Received: by mail-wm0-f53.google.com with SMTP id 5so13815397wmk.1
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Nov 2017 11:31:54 -0800 (PST)
Received: from [192.168.2.191] (x4e370f23.dyn.telefonica.de. [78.55.15.35])
        by smtp.googlemail.com with ESMTPSA id s6sm6588202edc.2.2017.11.19.11.31.52
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 Nov 2017 11:31:52 -0800 (PST)
To: linux-btrfs@vger.kernel.org
From: Steffen Sindzinski <stesind@gmail.com>
Subject: uncorrectable errors in Raid 10
Message-ID: <a61eeda7-af07-e140-ccd9-d288931f07fb@gmail.com>
Date: Sun, 19 Nov 2017 20:31:51 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hello,

I have done a scrub on my Btrfs Raid 10 and have 2 uncorrectable errors. 
In fact I cannot access 2 directories, even as root, permission is 
denied and all directory attributes in ls -la are ????.

Before I have run this filesystem as Raid 1 with 3 disks without any 
problems for more than a year. Scrubbed regularily. A month ago I added 
a fouth HDD and balanced to Raid10. I am not sure if I did a scub 
afterwards, but I usualy do. Now it found that errors. Smart status of 
HDDs is healthy. The 2 directories were read-only for some years and not 
even read in the last month.

What can I do now? Should I do a btrfs rescue? Which device, it is a 
raid 10? Probably my files are OK, only the directories I cannot access. 
How to recover the files?

Thanks in advance!

Steffen


Here is my data:


Linux bigbox 4.13.0-17-generic #20-Ubuntu SMP Mon Nov 6 10:04:08 UTC 
2017 x86_64 x86_64 x86_64 GNU/Linux

btrfs-progs v4.12

Label: 'Videos'  uuid: 4fafd0d4-7dd9-4dcc-9a33-5f1ad9555358
     Total devices 4 FS bytes used 1.44TiB
     devid    3 size 1.82TiB used 785.56GiB path /dev/sdc2
     devid    4 size 1.82TiB used 785.56GiB path /dev/sde2
     devid    5 size 1.82TiB used 785.56GiB path /dev/sdd2
     devid    6 size 1.36TiB used 785.56GiB path /dev/sdf1

Data, RAID10: total=1.51TiB, used=1.43TiB
System, RAID10: total=128.00MiB, used=192.00KiB
Metadata, RAID10: total=21.00GiB, used=17.76GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


  % sudo btrfs scrub start -Bd /
scrub device /dev/sdc2 (id 3) canceled
     scrub started at Sun Nov 19 08:43:21 2017 and was aborted after 
01:58:27
     total bytes scrubbed: 568.86GiB with 0 errors
scrub device /dev/sde2 (id 4) canceled
     scrub started at Sun Nov 19 08:43:21 2017 and was aborted after 
01:58:28
     total bytes scrubbed: 702.88GiB with 1 errors
     error details: verify=1
     corrected errors: 0, uncorrectable errors: 1, unverified errors: 0
scrub device /dev/sdd2 (id 5) done
     scrub started at Sun Nov 19 08:43:21 2017 and finished after 01:48:00
     total bytes scrubbed: 737.74GiB with 1 errors
     error details: verify=1
     corrected errors: 0, uncorrectable errors: 1, unverified errors: 0
scrub device /dev/sdf1 (id 6) canceled
     scrub started at Sun Nov 19 08:43:21 2017 and was aborted after 
01:58:28
     total bytes scrubbed: 506.02GiB with 0 errors




[    4.985712] BTRFS: device label Videos devid 6 transid 772463 /dev/sdf1
[    4.985882] BTRFS: device label Videos devid 4 transid 772463 /dev/sde2
[    4.986541] BTRFS: device label Videos devid 5 transid 772463 /dev/sdd2
[    4.986713] BTRFS: device label Videos devid 3 transid 772463 /dev/sdc2
[    5.007986] BTRFS info (device sdc2): disk space caching is enabled
[    5.007988] BTRFS info (device sdc2): has skinny extents
[    5.149910] BTRFS info (device sdc2): bdev /dev/sdd2 errs: wr 0, rd 
0, flush 0, corrupt 0, gen 3
[    5.149916] BTRFS info (device sdc2): bdev /dev/sde2 errs: wr 0, rd 
0, flush 0, corrupt 0, gen 3
[   25.482987] BTRFS info (device sdc2): use lzo compression
[   25.482990] BTRFS info (device sdc2): disk space caching is enabled
[57830.611730] BTRFS warning (device sdc2): checksum/header error at 
logical 17478699876352 on dev /dev/sdd2, sector 338986176: metadata leaf 
(level 0) in tree 318
[57830.611732] BTRFS warning (device sdc2): checksum/header error at 
logical 17478699876352 on dev /dev/sdd2, sector 338986176: metadata leaf 
(level 0) in tree 318
[57830.611734] BTRFS error (device sdc2): bdev /dev/sdd2 errs: wr 0, rd 
0, flush 0, corrupt 0, gen 4
[57832.688689] BTRFS error (device sdc2): unable to fixup (regular) 
error at logical 17478699876352 on dev /dev/sdd2
[57870.488081] BTRFS warning (device sdc2): checksum/header error at 
logical 17478699876352 on dev /dev/sde2, sector 348423360: metadata leaf 
(level 0) in tree 318
[57870.488083] BTRFS warning (device sdc2): checksum/header error at 
logical 17478699876352 on dev /dev/sde2, sector 348423360: metadata leaf 
(level 0) in tree 318
[57870.488085] BTRFS error (device sdc2): bdev /dev/sde2 errs: wr 0, rd 
0, flush 0, corrupt 0, gen 4
[57870.500114] BTRFS error (device sdc2): unable to fixup (regular) 
error at logical 17478699876352 on dev /dev/sde2
[88979.005712] BTRFS warning (device sdc2): checksum/header error at 
logical 17478699876352 on dev /dev/sdd2, sector 338986176: metadata leaf 
(level 0) in tree 318
[88979.005718] BTRFS warning (device sdc2): checksum/header error at 
logical 17478699876352 on dev /dev/sdd2, sector 338986176: metadata leaf 
(level 0) in tree 318
[88979.005720] BTRFS error (device sdc2): bdev /dev/sdd2 errs: wr 0, rd 
0, flush 0, corrupt 0, gen 5
[88979.036670] BTRFS error (device sdc2): unable to fixup (regular) 
error at logical 17478699876352 on dev /dev/sdd2
[89026.609561] BTRFS warning (device sdc2): checksum/header error at 
logical 17478699876352 on dev /dev/sde2, sector 348423360: metadata leaf 
(level 0) in tree 318
[89026.609563] BTRFS warning (device sdc2): checksum/header error at 
logical 17478699876352 on dev /dev/sde2, sector 348423360: metadata leaf 
(level 0) in tree 318
[89026.609566] BTRFS error (device sdc2): bdev /dev/sde2 errs: wr 0, rd 
0, flush 0, corrupt 0, gen 5
[89026.617423] BTRFS error (device sdc2): unable to fixup (regular) 
error at logical 17478699876352 on dev /dev/sde2
[97765.699866] BTRFS warning (device sdc2): checksum/header error at 
logical 17478699876352 on dev /dev/sdd2, sector 338986176: metadata leaf 
(level 0) in tree 318
[97765.699869] BTRFS warning (device sdc2): checksum/header error at 
logical 17478699876352 on dev /dev/sdd2, sector 338986176: metadata leaf 
(level 0) in tree 318
[97765.699871] BTRFS error (device sdc2): bdev /dev/sdd2 errs: wr 0, rd 
0, flush 0, corrupt 0, gen 6
[97765.735887] BTRFS error (device sdc2): unable to fixup (regular) 
error at logical 17478699876352 on dev /dev/sdd2
[97789.909036] BTRFS warning (device sdc2): checksum/header error at 
logical 17478699876352 on dev /dev/sde2, sector 348423360: metadata leaf 
(level 0) in tree 318
[97789.909039] BTRFS warning (device sdc2): checksum/header error at 
logical 17478699876352 on dev /dev/sde2, sector 348423360: metadata leaf 
(level 0) in tree 318
[97789.909041] BTRFS error (device sdc2): bdev /dev/sde2 errs: wr 0, rd 
0, flush 0, corrupt 0, gen 6
[97789.918254] BTRFS error (device sdc2): unable to fixup (regular) 
error at logical 17478699876352 on dev /dev/sde2
[104087.660640] BTRFS warning (device sdc2): checksum/header error at 
logical 17478699876352 on dev /dev/sdd2, sector 338986176: metadata leaf 
(level 0) in tree 318
[104087.660643] BTRFS warning (device sdc2): checksum/header error at 
logical 17478699876352 on dev /dev/sdd2, sector 338986176: metadata leaf 
(level 0) in tree 318
[104087.660645] BTRFS error (device sdc2): bdev /dev/sdd2 errs: wr 0, rd 
0, flush 0, corrupt 0, gen 7
[104087.696248] BTRFS error (device sdc2): unable to fixup (regular) 
error at logical 17478699876352 on dev /dev/sdd2
[104126.980483] BTRFS warning (device sdc2): checksum/header error at 
logical 17478699876352 on dev /dev/sde2, sector 348423360: metadata leaf 
(level 0) in tree 318
[104126.980486] BTRFS warning (device sdc2): checksum/header error at 
logical 17478699876352 on dev /dev/sde2, sector 348423360: metadata leaf 
(level 0) in tree 318
[104126.980488] BTRFS error (device sdc2): bdev /dev/sde2 errs: wr 0, rd 
0, flush 0, corrupt 0, gen 7
[104126.995705] BTRFS error (device sdc2): unable to fixup (regular) 
error at logical 17478699876352 on dev /dev/sde2


steffen@bigbox ~ % sudo btrfs device stats /
[/dev/sdc2].write_io_errs    0
[/dev/sdc2].read_io_errs     0
[/dev/sdc2].flush_io_errs    0
[/dev/sdc2].corruption_errs  0
[/dev/sdc2].generation_errs  0
[/dev/sde2].write_io_errs    0
[/dev/sde2].read_io_errs     0
[/dev/sde2].flush_io_errs    0
[/dev/sde2].corruption_errs  0
[/dev/sde2].generation_errs  7
[/dev/sdd2].write_io_errs    0
[/dev/sdd2].read_io_errs     0
[/dev/sdd2].flush_io_errs    0
[/dev/sdd2].corruption_errs  0
[/dev/sdd2].generation_errs  7
[/dev/sdf1].write_io_errs    0
[/dev/sdf1].read_io_errs     0
[/dev/sdf1].flush_io_errs    0
[/dev/sdf1].corruption_errs  0
[/dev/sdf1].generation_errs  0

