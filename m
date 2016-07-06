Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35047 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbcGFRMm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 13:12:42 -0400
Received: by mail-wm0-f51.google.com with SMTP id z126so119554895wme.0
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 10:12:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFDLS-CtnVDtD8d=Wtp0tVokKJ6pjptpX7MR862dThBJvSPC5g@mail.gmail.com>
References: <CAFDLS-CtnVDtD8d=Wtp0tVokKJ6pjptpX7MR862dThBJvSPC5g@mail.gmail.com>
From: Gonzalo Gomez-Arrue Azpiazu <ggomarr@gmail.com>
Date: Wed, 6 Jul 2016 20:12:20 +0300
Message-ID: <CAFDLS-AA6nYJy6BBRPhqAL-7PpA-TTEUqpjLR2+cZ05A+5kx7A@mail.gmail.com>
Subject: Fwd: Unable to mount degraded RAID5
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I had a RAID5 with 3 disks and one failed; now the filesystem cannot be mounted.

None of the recommendations that I found seem to work. The situation
seems to be similar to this one:
http://www.spinics.net/lists/linux-btrfs/msg56825.html

Any suggestion on what to try next?

Thanks a lot beforehand!

sudo btrfs version
btrfs-progs v4.4

uname -a
Linux ubuntu 4.4.0-21-generic #37-Ubuntu SMP Mon Apr 18 18:33:37 UTC
2016 x86_64 x86_64 x86_64 GNU/Linux

sudo btrfs fi show
warning, device 2 is missing
checksum verify failed on 2339175972864 found A781ADC2 wanted 43621074
checksum verify failed on 2339175972864 found A781ADC2 wanted 43621074
bytenr mismatch, want=2339175972864, have=65536
Couldn't read chunk root
Label: none  uuid: 495efbc6-2f62-4cd7-962b-7ae3d0e929f1
Total devices 3 FS bytes used 1.29TiB
devid    1 size 2.73TiB used 674.03GiB path /dev/sdc1
devid    3 size 2.73TiB used 674.03GiB path /dev/sdd1
*** Some devices missing

sudo mount -t btrfs -o ro,degraded,recovery /dev/sdc1 /btrfs
mount: wrong fs type, bad option, bad superblock on /dev/sdc1,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

dmesg | tail
[ 2440.036368] BTRFS info (device sdd1): allowing degraded mounts
[ 2440.036383] BTRFS info (device sdd1): enabling auto recovery
[ 2440.036390] BTRFS info (device sdd1): disk space caching is enabled
[ 2440.037928] BTRFS warning (device sdd1): devid 2 uuid
0c7d7db2-6a27-4b19-937b-b6266ba81257 is missing
[ 2440.652085] BTRFS info (device sdd1): bdev (null) errs: wr 1413, rd
362, flush 471, corrupt 0, gen 0
[ 2441.359066] BTRFS error (device sdd1): bad tree block start 0 833766391808
[ 2441.359306] BTRFS error (device sdd1): bad tree block start 0 833766391808
[ 2441.359330] BTRFS: Failed to read block groups: -5
[ 2441.383793] BTRFS: open_ctree failed

sudo btrfs restore /dev/sdc1 /bkp
warning, device 2 is missing
checksum verify failed on 2339175972864 found A781ADC2 wanted 43621074
checksum verify failed on 2339175972864 found A781ADC2 wanted 43621074
bytenr mismatch, want=2339175972864, have=65536
Couldn't read chunk root
Could not open root, trying backup super
warning, device 2 is missing
warning, device 3 is missing
checksum verify failed on 2339175972864 found A781ADC2 wanted 43621074
checksum verify failed on 2339175972864 found A781ADC2 wanted 43621074
bytenr mismatch, want=2339175972864, have=65536
Couldn't read chunk root
Could not open root, trying backup super
warning, device 2 is missing
warning, device 3 is missing
checksum verify failed on 2339175972864 found A781ADC2 wanted 43621074
checksum verify failed on 2339175972864 found A781ADC2 wanted 43621074
bytenr mismatch, want=2339175972864, have=65536
Couldn't read chunk root
Could not open root, trying backup super

sudo btrfs-show-super -fa /dev/sdc1
http://sebsauvage.net/paste/?d79e9e9c385cf1a5#fNwoEj5o2aQ6T7nDl4vjrFqEJG0SHeVpmGknbbCVnd0=

sudo btrfs-find-root /dev/sdc1
warning, device 2 is missing
Couldn't read chunk root
Open ctree failed
