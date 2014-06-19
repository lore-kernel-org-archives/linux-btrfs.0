Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:50556 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbaFSKr2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 06:47:28 -0400
Received: by mail-ve0-f171.google.com with SMTP id jz11so2113589veb.16
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 03:47:27 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 19 Jun 2014 06:47:27 -0400
Message-ID: <CAA8KC9+qMhSw9dLPZDpr=RtkodCTgh8c31Uj20mSUegCum_LwA@mail.gmail.com>
Subject: Made a RAID1, now Fail to recover the chunk tree.
From: Zack Coffey <clickwir@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I tried to create a simple RAID1 for metadata and somehow lost access
to everything on the drive. The RAID1 for just metadata created just
fine, everything was fine for a day, so I turned off the drive that
was just holding the RAID1 of the metadata, it's an external USB hard
drive. Everything seemed to be moving along fine, the data was still
accessible and RAID1 worked. I then swapped the USB hard drive for a
different drive and btrfs had a fit.

Right now it is not mounted, I can't get it to mount. Everything I do
ends with an error. I can't understand what went wrong and why it
won't mount.


So dmesg shows me it had trouble reading chunk root. Running a
chunk-recover shows some problems but errors out and fixes nothing.
btrfsck --repair --init-extent-tree gives similar errors that it
cannot read chunk root. From what I've found online, I'm stuck in a
loop, I can't fix the first error until I fix the second. But I can't
fix the second till the first is fixed.


uname -a
Linux mach 3.13.0-29-generic #53-Ubuntu SMP Wed Jun 4 21:00:20 UTC
2014 x86_64 x86_64 x86_64 GNU/Linux

sudo btrfs version
Btrfs v3.12

sudo btrfs fi show
Label: none  uuid: 184fecb1-3016-4fe4-b41b-f3b1b6654e84
        Total devices 1 FS bytes used 112.00KiB
        devid    1 size 465.76GiB used 2.04GiB path /dev/sdh1

Label: none  uuid: bd78815a-802b-43e2-8387-fc6ab4237d67
        Total devices 2 FS bytes used 299.73GiB
        devid    1 size 573.47GiB used 302.00GiB path /dev/sdc1
        *** Some devices missing

Btrfs v3.12

sudo mount /dev/sdc1 /media/Data/
mount: wrong fs type, bad option, bad superblock on /dev/sdc1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so
Note: Adding -o degraded or -o recovery still fails.

dmesg | tail
[43757.059275] btrfs: device fsid 184fecb1-3016-4fe4-b41b-
f3b1b6654e84 devid 1 transid 6 /dev/sdh1
[43808.758821] btrfs: device fsid bd78815a-802b-43e2-8387-fc6ab4237d67
devid 1 transid 60944 /dev/sdc1
[43808.759837] btrfs: disk space caching is enabled
[43808.761932] btrfs: failed to read chunk root on sdc1
[43808.780698] btrfs: open_ctree failed
[43911.602169] btrfs: device fsid bd78815a-802b-43e2-8387-fc6ab4237d67
devid 1 transid 60944 /dev/sdc1
[43911.611280] btrfs: device fsid 3a1173cd-77a9-4076-8a1e-5cc782bd18a5
devid 1 transid 4 /dev/sdh
[43911.612189] btrfs: device fsid 184fecb1-3016-4fe4-b41b-f3b1b6654e84
devid 1 transid 6 /dev/sdh1
[43911.633946] btrfs: device fsid bd78815a-802b-43e2-8387-fc6ab4237d67
devid 1 transid 60944 /dev/sdc1
[43911.645625] btrfs: device fsid bd78815a-802b-43e2-8387-fc6ab4237d67
devid 1 transid 60944 /dev/sdc1



Chunk: start = 655016067072, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 272763977728
      Block Group: start = 655016067072, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 272763977728, len =
1073741824, chunk offset = 655016067072
  Chunk: start = 656089808896, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 271690235904
      Block Group: start = 656089808896, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 271690235904, len =
1073741824, chunk offset = 656089808896
  Chunk: start = 657163550720, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 275985203200
      Block Group: start = 657163550720, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 275985203200, len =
1073741824, chunk offset = 657163550720
  Chunk: start = 658237292544, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 277058945024
      Block Group: start = 658237292544, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 277058945024, len =
1073741824, chunk offset = 658237292544
  Chunk: start = 659311034368, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 278132686848
      Block Group: start = 659311034368, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 278132686848, len =
1073741824, chunk offset = 659311034368
  Chunk: start = 660384776192, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 279206428672
      Block Group: start = 660384776192, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 279206428672, len =
1073741824, chunk offset = 660384776192
  Chunk: start = 661458518016, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 265247784960
      Block Group: start = 661458518016, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 265247784960, len =
1073741824, chunk offset = 661458518016
  Chunk: start = 662532259840, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 264174043136
      Block Group: start = 662532259840, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 264174043136, len =
1073741824, chunk offset = 662532259840
  Chunk: start = 663606001664, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 266321526784
      Block Group: start = 663606001664, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 266321526784, len =
1073741824, chunk offset = 663606001664
  Chunk: start = 664679743488, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 267395268608
      Block Group: start = 664679743488, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 267395268608, len =
1073741824, chunk offset = 664679743488
  Chunk: start = 665753485312, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 268469010432
      Block Group: start = 665753485312, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 268469010432, len =
1073741824, chunk offset = 665753485312
  Chunk: start = 666827227136, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 269542752256
      Block Group: start = 666827227136, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 269542752256, len =
1073741824, chunk offset = 666827227136
  Chunk: start = 667900968960, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 255584108544
      Block Group: start = 667900968960, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 255584108544, len =
1073741824, chunk offset = 667900968960
  Chunk: start = 668974710784, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 256657850368
      Block Group: start = 668974710784, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 256657850368, len =
1073741824, chunk offset = 668974710784
  Chunk: start = 670048452608, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 257731592192
      Block Group: start = 670048452608, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 257731592192, len =
1073741824, chunk offset = 670048452608
  Chunk: start = 671122194432, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 258805334016
      Block Group: start = 671122194432, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 258805334016, len =
1073741824, chunk offset = 671122194432
  Chunk: start = 672195936256, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 259879075840
      Block Group: start = 672195936256, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 259879075840, len =
1073741824, chunk offset = 672195936256
  Chunk: start = 673269678080, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 248067915776
      Block Group: start = 673269678080, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 248067915776, len =
1073741824, chunk offset = 673269678080
  Chunk: start = 674343419904, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 249141657600
      Block Group: start = 674343419904, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 249141657600, len =
1073741824, chunk offset = 674343419904
  Chunk: start = 675417161728, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 250215399424
      Block Group: start = 675417161728, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 250215399424, len =
1073741824, chunk offset = 675417161728
  Chunk: start = 676490903552, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 251289141248
      Block Group: start = 676490903552, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 251289141248, len =
1073741824, chunk offset = 676490903552
  Chunk: start = 677564645376, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 252362883072
      Block Group: start = 677564645376, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 252362883072, len =
1073741824, chunk offset = 677564645376
  Chunk: start = 678638387200, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 239477981184
      Block Group: start = 678638387200, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 239477981184, len =
1073741824, chunk offset = 678638387200
  Chunk: start = 679712129024, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 240551723008
      Block Group: start = 679712129024, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 240551723008, len =
1073741824, chunk offset = 679712129024
  Chunk: start = 680785870848, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 241625464832
      Block Group: start = 680785870848, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 241625464832, len =
1073741824, chunk offset = 680785870848
  Chunk: start = 681859612672, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 242699206656
      Block Group: start = 681859612672, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 242699206656, len =
1073741824, chunk offset = 681859612672
  Chunk: start = 682933354496, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 243772948480
      Block Group: start = 682933354496, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 243772948480, len =
1073741824, chunk offset = 682933354496
  Chunk: start = 684007096320, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 234109272064
      Block Group: start = 684007096320, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 234109272064, len =
1073741824, chunk offset = 684007096320
  Chunk: start = 685080838144, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 233035530240
      Block Group: start = 685080838144, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 233035530240, len =
1073741824, chunk offset = 685080838144
  Chunk: start = 686154579968, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 231961788416
      Block Group: start = 686154579968, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 231961788416, len =
1073741824, chunk offset = 686154579968
  Chunk: start = 687228321792, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 235183013888
      Block Group: start = 687228321792, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 235183013888, len =
1073741824, chunk offset = 687228321792
  Chunk: start = 688302063616, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 236256755712
      Block Group: start = 688302063616, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 236256755712, len =
1073741824, chunk offset = 688302063616
  Chunk: start = 689375805440, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 237330497536
      Block Group: start = 689375805440, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 237330497536, len =
1073741824, chunk offset = 689375805440
  Chunk: start = 690449547264, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 238404239360
      Block Group: start = 690449547264, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 238404239360, len =
1073741824, chunk offset = 690449547264
  Chunk: start = 691523289088, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 223371853824
      Block Group: start = 691523289088, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 223371853824, len =
1073741824, chunk offset = 691523289088
  Chunk: start = 692597030912, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 224445595648
      Block Group: start = 692597030912, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 224445595648, len =
1073741824, chunk offset = 692597030912
  Chunk: start = 693670772736, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 225519337472
      Block Group: start = 693670772736, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 225519337472, len =
1073741824, chunk offset = 693670772736
  Chunk: start = 694744514560, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 226593079296
      Block Group: start = 694744514560, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 226593079296, len =
1073741824, chunk offset = 694744514560
  Chunk: start = 695818256384, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 227666821120
      Block Group: start = 695818256384, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 227666821120, len =
1073741824, chunk offset = 695818256384
  Chunk: start = 696891998208, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 216929402880
      Block Group: start = 696891998208, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 216929402880, len =
1073741824, chunk offset = 696891998208
  Chunk: start = 697965740032, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 215855661056
      Block Group: start = 697965740032, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 215855661056, len =
1073741824, chunk offset = 697965740032
  Chunk: start = 699039481856, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 218003144704
      Block Group: start = 699039481856, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 218003144704, len =
1073741824, chunk offset = 699039481856
  Chunk: start = 700113223680, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 219076886528
      Block Group: start = 700113223680, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 219076886528, len =
1073741824, chunk offset = 700113223680
  Chunk: start = 701186965504, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 220150628352
      Block Group: start = 701186965504, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 220150628352, len =
1073741824, chunk offset = 701186965504
  Chunk: start = 702260707328, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 221224370176
      Block Group: start = 702260707328, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 221224370176, len =
1073741824, chunk offset = 702260707328
  Chunk: start = 703334449152, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 207265726464
      Block Group: start = 703334449152, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 207265726464, len =
1073741824, chunk offset = 703334449152
  Chunk: start = 704408190976, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 208339468288
      Block Group: start = 704408190976, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 208339468288, len =
1073741824, chunk offset = 704408190976
  Chunk: start = 705481932800, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 209413210112
      Block Group: start = 705481932800, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 209413210112, len =
1073741824, chunk offset = 705481932800
  Chunk: start = 706555674624, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 210486951936
      Block Group: start = 706555674624, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 210486951936, len =
1073741824, chunk offset = 706555674624
  Chunk: start = 707629416448, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 211560693760
      Block Group: start = 707629416448, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 211560693760, len =
1073741824, chunk offset = 707629416448
  Chunk: start = 708703158272, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 199749533696
      Block Group: start = 708703158272, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 199749533696, len =
1073741824, chunk offset = 708703158272
  Chunk: start = 709776900096, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 200823275520
      Block Group: start = 709776900096, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 200823275520, len =
1073741824, chunk offset = 709776900096
  Chunk: start = 710850641920, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 201897017344
      Block Group: start = 710850641920, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 201897017344, len =
1073741824, chunk offset = 710850641920
  Chunk: start = 711924383744, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 202970759168
      Block Group: start = 711924383744, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 202970759168, len =
1073741824, chunk offset = 711924383744
  Chunk: start = 712998125568, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 204044500992
      Block Group: start = 712998125568, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 204044500992, len =
1073741824, chunk offset = 712998125568
  Chunk: start = 714071867392, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 191159599104
      Block Group: start = 714071867392, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 191159599104, len =
1073741824, chunk offset = 714071867392
  Chunk: start = 715145609216, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 192233340928
      Block Group: start = 715145609216, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 192233340928, len =
1073741824, chunk offset = 715145609216
  Chunk: start = 716219351040, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 193307082752
      Block Group: start = 716219351040, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 193307082752, len =
1073741824, chunk offset = 716219351040
  Chunk: start = 717293092864, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 194380824576
      Block Group: start = 717293092864, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 194380824576, len =
1073741824, chunk offset = 717293092864
  Chunk: start = 718366834688, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 195454566400
      Block Group: start = 718366834688, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 195454566400, len =
1073741824, chunk offset = 718366834688
  Chunk: start = 719440576512, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 183643406336
      Block Group: start = 719440576512, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 183643406336, len =
1073741824, chunk offset = 719440576512
  Chunk: start = 720514318336, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 184717148160
      Block Group: start = 720514318336, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 184717148160, len =
1073741824, chunk offset = 720514318336
  Chunk: start = 721588060160, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 185790889984
      Block Group: start = 721588060160, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 185790889984, len =
1073741824, chunk offset = 721588060160
  Chunk: start = 722661801984, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 186864631808
      Block Group: start = 722661801984, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 186864631808, len =
1073741824, chunk offset = 722661801984
  Chunk: start = 723735543808, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 187938373632
      Block Group: start = 723735543808, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 187938373632, len =
1073741824, chunk offset = 723735543808
  Chunk: start = 724809285632, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 175053471744
      Block Group: start = 724809285632, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 175053471744, len =
1073741824, chunk offset = 724809285632
  Chunk: start = 725883027456, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 176127213568
      Block Group: start = 725883027456, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 176127213568, len =
1073741824, chunk offset = 725883027456
  Chunk: start = 726956769280, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 177200955392
      Block Group: start = 726956769280, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 177200955392, len =
1073741824, chunk offset = 726956769280
  Chunk: start = 728030511104, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 178274697216
      Block Group: start = 728030511104, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 178274697216, len =
1073741824, chunk offset = 728030511104
  Chunk: start = 729104252928, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 179348439040
      Block Group: start = 729104252928, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 179348439040, len =
1073741824, chunk offset = 729104252928
  Chunk: start = 730177994752, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 167537278976
      Block Group: start = 730177994752, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 167537278976, len =
1073741824, chunk offset = 730177994752
  Chunk: start = 731251736576, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 168611020800
      Block Group: start = 731251736576, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 168611020800, len =
1073741824, chunk offset = 731251736576
  Chunk: start = 732325478400, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 169684762624
      Block Group: start = 732325478400, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 169684762624, len =
1073741824, chunk offset = 732325478400
  Chunk: start = 733399220224, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 170758504448
      Block Group: start = 733399220224, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 170758504448, len =
1073741824, chunk offset = 733399220224
  Chunk: start = 734472962048, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 171832246272
      Block Group: start = 734472962048, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 171832246272, len =
1073741824, chunk offset = 734472962048
  Chunk: start = 735546703872, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 162168569856
      Block Group: start = 735546703872, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 162168569856, len =
1073741824, chunk offset = 735546703872
  Chunk: start = 736620445696, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 161094828032
      Block Group: start = 736620445696, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 161094828032, len =
1073741824, chunk offset = 736620445696
  Chunk: start = 737694187520, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 160021086208
      Block Group: start = 737694187520, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 160021086208, len =
1073741824, chunk offset = 737694187520
  Chunk: start = 738767929344, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 158947344384
      Block Group: start = 738767929344, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 158947344384, len =
1073741824, chunk offset = 738767929344
  Chunk: start = 739841671168, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 163242311680
      Block Group: start = 739841671168, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 163242311680, len =
1073741824, chunk offset = 739841671168
  Chunk: start = 740915412992, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 164316053504
      Block Group: start = 740915412992, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 164316053504, len =
1073741824, chunk offset = 740915412992
  Chunk: start = 741989154816, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 165389795328
      Block Group: start = 741989154816, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 165389795328, len =
1073741824, chunk offset = 741989154816
  Chunk: start = 808561147904, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 87006642176
      Block Group: start = 808561147904, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 87006642176, len =
1073741824, chunk offset = 808561147904
  Chunk: start = 809634889728, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 90227867648
      Block Group: start = 809634889728, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 90227867648, len =
1073741824, chunk offset = 809634889728
  Chunk: start = 810708631552, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 91301609472
      Block Group: start = 810708631552, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 91301609472, len =
1073741824, chunk offset = 810708631552
  Chunk: start = 811782373376, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 92375351296
      Block Group: start = 811782373376, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 92375351296, len =
1073741824, chunk offset = 811782373376
  Chunk: start = 813929857024, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 78416707584
      Block Group: start = 813929857024, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 78416707584, len =
1073741824, chunk offset = 813929857024
  Chunk: start = 815003598848, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 79490449408
      Block Group: start = 815003598848, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 79490449408, len =
1073741824, chunk offset = 815003598848
  Chunk: start = 816077340672, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 80564191232
      Block Group: start = 816077340672, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 80564191232, len =
1073741824, chunk offset = 816077340672
  Chunk: start = 818224824320, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 82711674880
      Block Group: start = 818224824320, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 82711674880, len =
1073741824, chunk offset = 818224824320
  Chunk: start = 819298566144, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 70900514816
      Block Group: start = 819298566144, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 70900514816, len =
1073741824, chunk offset = 819298566144
  Chunk: start = 820372307968, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 71974256640
      Block Group: start = 820372307968, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 71974256640, len =
1073741824, chunk offset = 820372307968
  Chunk: start = 821446049792, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 73047998464
      Block Group: start = 821446049792, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 73047998464, len =
1073741824, chunk offset = 821446049792
  Chunk: start = 822519791616, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 74121740288
      Block Group: start = 822519791616, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 74121740288, len =
1073741824, chunk offset = 822519791616
  Chunk: start = 823593533440, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 75195482112
      Block Group: start = 823593533440, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 75195482112, len =
1073741824, chunk offset = 823593533440
  Chunk: start = 825741017088, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 62310580224
      Block Group: start = 825741017088, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 62310580224, len =
1073741824, chunk offset = 825741017088
  Chunk: start = 826814758912, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 63384322048
      Block Group: start = 826814758912, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 63384322048, len =
1073741824, chunk offset = 826814758912
  Chunk: start = 831109726208, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 55868129280
      Block Group: start = 831109726208, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 55868129280, len =
1073741824, chunk offset = 831109726208
  Chunk: start = 832183468032, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 54794387456
      Block Group: start = 832183468032, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 54794387456, len =
1073741824, chunk offset = 832183468032
  Chunk: start = 847215853568, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 42983227392
      Block Group: start = 847215853568, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 42983227392, len =
1073741824, chunk offset = 847215853568
  Chunk: start = 848289595392, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 44056969216
      Block Group: start = 848289595392, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 44056969216, len =
1073741824, chunk offset = 848289595392
  Chunk: start = 851510820864, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 31172067328
      Block Group: start = 851510820864, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 31172067328, len =
1073741824, chunk offset = 851510820864
  Chunk: start = 852584562688, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 32245809152
      Block Group: start = 852584562688, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 32245809152, len =
1073741824, chunk offset = 852584562688
  Chunk: start = 853658304512, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 33319550976
      Block Group: start = 853658304512, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 33319550976, len =
1073741824, chunk offset = 853658304512
  Chunk: start = 856879529984, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 22582132736
      Block Group: start = 856879529984, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 22582132736, len =
1073741824, chunk offset = 856879529984
  Chunk: start = 857953271808, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 23655874560
      Block Group: start = 857953271808, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 23655874560, len =
1073741824, chunk offset = 857953271808
  Chunk: start = 859027013632, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 25803358208
      Block Group: start = 859027013632, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 25803358208, len =
1073741824, chunk offset = 859027013632
  Chunk: start = 865469464576, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 15065939968
      Block Group: start = 865469464576, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 15065939968, len =
1073741824, chunk offset = 865469464576
  Chunk: start = 866543206400, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 18287165440
      Block Group: start = 866543206400, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 18287165440, len =
1073741824, chunk offset = 866543206400
  Chunk: start = 867616948224, len = 1073741824, type = 4, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 33554432
      Block Group: start = 867616948224, len = 1073741824, flag = 4
      Device extent list:
          [ 0]Device extent: devid = 1, start = 33554432, len =
1073741824, chunk offset = 867616948224
  Chunk: start = 868690690048, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 1107296256
      Block Group: start = 868690690048, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 1107296256, len =
1073741824, chunk offset = 868690690048
  Chunk: start = 869764431872, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 2181038080
      Block Group: start = 869764431872, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 2181038080, len =
1073741824, chunk offset = 869764431872
  Chunk: start = 870838173696, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 3254779904
      Block Group: start = 870838173696, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 3254779904, len =
1073741824, chunk offset = 870838173696
  Chunk: start = 871911915520, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 4328521728
      Block Group: start = 871911915520, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 4328521728, len =
1073741824, chunk offset = 871911915520
  Chunk: start = 874059399168, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 6476005376
      Block Group: start = 874059399168, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 6476005376, len =
1073741824, chunk offset = 874059399168
  Chunk: start = 875133140992, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 16139681792
      Block Group: start = 875133140992, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 16139681792, len =
1073741824, chunk offset = 875133140992
  Chunk: start = 876206882816, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 19360907264
      Block Group: start = 876206882816, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 19360907264, len =
1073741824, chunk offset = 876206882816
  Chunk: start = 877280624640, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 7549747200
      Block Group: start = 877280624640, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 7549747200, len =
1073741824, chunk offset = 877280624640
  Chunk: start = 878354366464, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 8623489024
      Block Group: start = 878354366464, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 8623489024, len =
1073741824, chunk offset = 878354366464
  Chunk: start = 879428108288, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 9697230848
      Block Group: start = 879428108288, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 9697230848, len =
1073741824, chunk offset = 879428108288
  Chunk: start = 880501850112, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 10770972672
      Block Group: start = 880501850112, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 10770972672, len =
1073741824, chunk offset = 880501850112
  Chunk: start = 881575591936, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 11844714496
      Block Group: start = 881575591936, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 11844714496, len =
1073741824, chunk offset = 881575591936
  Chunk: start = 882649333760, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 12918456320
      Block Group: start = 882649333760, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 12918456320, len =
1073741824, chunk offset = 882649333760
  Chunk: start = 883723075584, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 17213423616
      Block Group: start = 883723075584, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 17213423616, len =
1073741824, chunk offset = 883723075584
  Chunk: start = 884796817408, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 13992198144
      Block Group: start = 884796817408, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 13992198144, len =
1073741824, chunk offset = 884796817408
  Chunk: start = 885870559232, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 20434649088
      Block Group: start = 885870559232, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 20434649088, len =
1073741824, chunk offset = 885870559232
  Chunk: start = 886944301056, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 21508390912
      Block Group: start = 886944301056, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 21508390912, len =
1073741824, chunk offset = 886944301056
  Chunk: start = 888018042880, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 24729616384
      Block Group: start = 888018042880, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 24729616384, len =
1073741824, chunk offset = 888018042880
  Chunk: start = 889091784704, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 26877100032
      Block Group: start = 889091784704, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 26877100032, len =
1073741824, chunk offset = 889091784704
  Chunk: start = 890165526528, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 27950841856
      Block Group: start = 890165526528, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 27950841856, len =
1073741824, chunk offset = 890165526528
  Chunk: start = 891239268352, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 29024583680
      Block Group: start = 891239268352, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 29024583680, len =
1073741824, chunk offset = 891239268352
  Chunk: start = 892313010176, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 30098325504
      Block Group: start = 892313010176, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 30098325504, len =
1073741824, chunk offset = 892313010176
  Chunk: start = 893386752000, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 34393292800
      Block Group: start = 893386752000, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 34393292800, len =
1073741824, chunk offset = 893386752000
  Chunk: start = 894460493824, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 35467034624
      Block Group: start = 894460493824, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 35467034624, len =
1073741824, chunk offset = 894460493824
  Chunk: start = 895534235648, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 36540776448
      Block Group: start = 895534235648, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 36540776448, len =
1073741824, chunk offset = 895534235648
  Chunk: start = 896607977472, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 37614518272
      Block Group: start = 896607977472, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 37614518272, len =
1073741824, chunk offset = 896607977472
  Chunk: start = 897681719296, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 38688260096
      Block Group: start = 897681719296, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 38688260096, len =
1073741824, chunk offset = 897681719296
  Chunk: start = 898755461120, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 39762001920
      Block Group: start = 898755461120, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 39762001920, len =
1073741824, chunk offset = 898755461120
  Chunk: start = 899829202944, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 40835743744
      Block Group: start = 899829202944, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 40835743744, len =
1073741824, chunk offset = 899829202944
  Chunk: start = 900902944768, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 41909485568
      Block Group: start = 900902944768, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 41909485568, len =
1073741824, chunk offset = 900902944768
  Chunk: start = 901976686592, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 45130711040
      Block Group: start = 901976686592, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 45130711040, len =
1073741824, chunk offset = 901976686592
  Chunk: start = 903050428416, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 46204452864
      Block Group: start = 903050428416, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 46204452864, len =
1073741824, chunk offset = 903050428416
  Chunk: start = 904124170240, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 56941871104
      Block Group: start = 904124170240, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 56941871104, len =
1073741824, chunk offset = 904124170240
  Chunk: start = 905197912064, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 64458063872
      Block Group: start = 905197912064, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 64458063872, len =
1073741824, chunk offset = 905197912064
  Chunk: start = 906271653888, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 47278194688
      Block Group: start = 906271653888, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 47278194688, len =
1073741824, chunk offset = 906271653888
  Chunk: start = 907345395712, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 48351936512
      Block Group: start = 907345395712, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 48351936512, len =
1073741824, chunk offset = 907345395712
  Chunk: start = 908419137536, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 49425678336
      Block Group: start = 908419137536, len = 1073741824, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 49425678336, len =
1073741824, chunk offset = 908419137536
  Chunk: start = 909492879360, len = 1073741824, type = 14, num_stripes = 2
      Stripes list:
      [ 0] Stripe: devid = 2, offset = 1048576
      [ 1] Stripe: devid = 1, offset = 50499420160
      Block Group: start = 909492879360, len = 1073741824, flag = 14
      Device extent list:
          [ 0]Device extent: devid = 1, start = 50499420160, len =
1073741824, chunk offset = 909492879360
          [ 1]Device extent: devid = 2, start = 1048576, len =
1073741824, chunk offset = 909492879360
  Chunk: start = 910566621184, len = 1073741824, type = 14, num_stripes = 2
      Stripes list:
      [ 0] Stripe: devid = 2, offset = 1074790400
      [ 1] Stripe: devid = 1, offset = 51573161984
      Block Group: start = 910566621184, len = 1073741824, flag = 14
      Device extent list:
          [ 0]Device extent: devid = 1, start = 51573161984, len =
1073741824, chunk offset = 910566621184
          [ 1]Device extent: devid = 2, start = 1074790400, len =
1073741824, chunk offset = 910566621184
  Chunk: start = 911640363008, len = 33554432, type = 12, num_stripes = 2
      Stripes list:
      [ 0] Stripe: devid = 2, offset = 2148532224
      [ 1] Stripe: devid = 1, offset = 5402263552
      Block Group: start = 911640363008, len = 33554432, flag = 12
      Device extent list:
          [ 0]Device extent: devid = 1, start = 5402263552, len =
33554432, chunk offset = 911640363008
          [ 1]Device extent: devid = 2, start = 2148532224, len =
33554432, chunk offset = 911640363008
Bad Chunks:
  Chunk: start = 743062896640, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 166463537152
      No block group.
      No device extent.
  Chunk: start = 744136638464, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 153578635264
      No block group.
      No device extent.
  Chunk: start = 745210380288, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 152504893440
      No block group.
      No device extent.
  Chunk: start = 746284122112, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 151431151616
      No block group.
      No device extent.
  Chunk: start = 747357863936, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 154652377088
      No block group.
      No device extent.
  Chunk: start = 748431605760, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 155726118912
      No block group.
      No device extent.
  Chunk: start = 775275151360, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 121366380544
      No block group.
      No device extent.
  Chunk: start = 776348893184, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 120292638720
      No block group.
      No device extent.
  Chunk: start = 777422635008, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 119218896896
      No block group.
      No device extent.
  Chunk: start = 778496376832, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 122440122368
      No block group.
      No device extent.
  Chunk: start = 779570118656, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 123513864192
      No block group.
      No device extent.
  Chunk: start = 780643860480, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 124587606016
      No block group.
      No device extent.
  Chunk: start = 836478435328, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 60163096576
      No block group.
      No device extent.
  Chunk: start = 837552177152, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 46204452864
      No block group.
      No device extent.
  Chunk: start = 838625918976, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 47278194688
      No block group.
      No device extent.
  Chunk: start = 839699660800, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 48351936512
      No block group.
      No device extent.
  Chunk: start = 840773402624, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 49425678336
      No block group.
      No device extent.
  Chunk: start = 841847144448, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 50499420160
      No block group.
      No device extent.
  Chunk: start = 842920886272, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 40835743744
      No block group.
      No device extent.
  Chunk: start = 843994628096, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 39762001920
      No block group.
      No device extent.
  Chunk: start = 845068369920, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 38688260096
      No block group.
      No device extent.
  Chunk: start = 846142111744, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 41909485568
      No block group.
      No device extent.
  Chunk: start = 849363337216, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 45130711040
      No block group.
      No device extent.
  Chunk: start = 850437079040, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 30098325504
      No block group.
      No device extent.
  Chunk: start = 854732046336, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 34393292800
      No block group.
      No device extent.
  Chunk: start = 855805788160, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 24729616384
      No block group.
      No device extent.
  Chunk: start = 860100755456, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 26877100032
      No block group.
      No device extent.
  Chunk: start = 861174497280, len = 1073741824, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 27950841856
      No block group.
      No device extent.

Total Chunks:   333
  Heathy:       305
  Bad:  28

Orphan Block Groups:
  Block Group: start = 872985657344, len = 1073741824, flag = 4
  Block Group: start = 911673917440, len = 33554432, flag = 2
  Block Group: start = 911707471872, len = 1073741824, flag = 4

Orphan Device Extents:
  Device extent: devid = 2, start = 2182086656, len = 33554432, chunk
offset = 911673917440
  Device extent: devid = 2, start = 2215641088, len = 1073741824,
chunk offset = 911707471872
open with broken chunk error
Fail to recover the chunk tree.
