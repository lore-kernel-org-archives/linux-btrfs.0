Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout1.freenet.de ([195.4.92.91]:52418 "EHLO mout1.freenet.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751318AbdJELnG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Oct 2017 07:43:06 -0400
Received: from [195.4.92.21] (helo=mx11.freenet.de)
        by mout1.freenet.de with esmtpsa (ID g6094199@freenet.de) (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256) (port 25) (Exim 4.89 #1)
        id 1e04Ta-0001Qe-Tz
        for linux-btrfs@vger.kernel.org; Thu, 05 Oct 2017 13:38:02 +0200
Received: from web8.emo.freenet-rz.de ([194.97.107.144]:44832)
        by mx11.freenet.de with esmtpa (ID g6094199@freenet.de) (port 587) (Exim 4.89 #1)
        id 1e04Ta-0005h5-Q2
        for linux-btrfs@vger.kernel.org; Thu, 05 Oct 2017 13:38:02 +0200
Received: from localhost ([127.0.0.1] helo=emo.freenet.de)
        by web8.emo.freenet-rz.de with esmtpa (Exim 4.84_2 2 (Panther_1))
        id 1e04Ta-00066x-Nt
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Oct 2017 13:38:02 +0200
Date: Thu, 05 Oct 2017 13:38:02 +0200
From: g6094199@freenet.de
Subject: How to get Super_num_devices in sync with num_devices again?!
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Message-Id: <1bf24e337599ff54dc3d851ba3fbf913@email.freenet.de>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

He Guys!I have an ubuntu 16.04 machine (K4.4 and K4.11, btrfs-progs v4.5.2) running / on btrfs raid1 and for somemonth (after i had to replace a / disk) super_numdevices and num_devices are out of sync peventing me to bootKernels newer than around 4.7 (ifaik), where the kernels began the be more restictive on checking valid btrfsdisks.I tried to remove the raid and converted to single with several balances after that so that there are no raidchunks left.Label: 'System'  uuid: 35fdbfd4-5809-4a30-94c1-5e3ca206ca4d    Total devices 1 FS bytes used 14.86GiB    devid    6 size 50.00GiB used 17.31GiB path /dev/nvme0n1p1Data, single: total=15.00GiB, used=13.84GiBSystem, single: total=64.00MiB, used=16.00KiBMetadata, single: total=2.25GiB, used=1.02GiBGlobalReserve, single: total=336.00MiB, used=0.00B/dev/nvme0n1p1, ID: 6   Device size:            50.00GiB   Data,single:            15.00GiB   Metadata,single:         2.25GiB   System,single:          6400MiB   Unallocated:            32.69GiBOverall:    Device size:          50.00GiB    Device allocated:          17.31GiB    Device unallocated:          32.69GiB    Device missing:             0.00B    Used:              1486GiB    Free (estimated):          33.85GiB    (min: 33.85GiB)    Data ratio:                  1.00    Metadata ratio:              1.00    Global reserve:         336.00MiB    (used: 0.00B)Data,single: Size:15.00GiB, Used:13.84GiB   /dev/nvme0n1p1      15.00GiBMetadata,single: Size:2.25GiB, Used:1.02GiB   /dev/nvme0n1p1       2.25GiBSystem,single: Size:64.00MiB, Used:1600KiB   /dev/nvme0n1p1      64.00MiBUnallocated:   /dev/nvme0n1p1      32.69GiBBut again newer kernels refuse to boot with tlling me: "BTRFS error....: super_num_devices 2 missmatchwith num_devices 1 found here".So the the two counters are alwasy off by one, dont matter what i try.Question: how do i get thouse two counters in sync again so that my system acts again as expected?!regardsSash

MIT TRAVELXTRA PROFITIEREN SIE VON 5% RÜCKVERGÜTUNG AUF DEN
REISEPREIS ? bekannte dt. Reiseanbieter und ein umfangreiches
Reiseangebot wie im Reisebüro!
https://email.freenet.de/reisen/index.html
[https://email.freenet.de/reisen/index.html?utm_medium=Text&utm_source=Footersatz&utm_campaign=Footersatz_Reisen07082017&epid=e9900000699&utm_content=Text]

