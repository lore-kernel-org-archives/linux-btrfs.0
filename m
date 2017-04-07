Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-dispatcher03.hrz.tu-darmstadt.de ([130.83.156.242]:45870
        "EHLO lnx141.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933873AbdDGOzF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Apr 2017 10:55:05 -0400
Received: from lnx500.hrz.tu-darmstadt.de (lnx500.hrz.tu-darmstadt.de [130.83.156.225])
        by lnx141.hrz.tu-darmstadt.de (8.14.4/8.13.8) with ESMTP id v37EI2iJ016153
        for <linux-btrfs@vger.kernel.org>; Fri, 7 Apr 2017 16:18:02 +0200
        (envelope-from Markus.Baier@bcs.tu-darmstadt.de)
Received: from smtp.tu-darmstadt.de (lnx504.hrz.tu-darmstadt.de [130.83.156.233])
        by lnx500.hrz.tu-darmstadt.de (8.14.4/8.14.4/HRZ/PMX) with ESMTP id v37EHAQG005305
        for <linux-btrfs@vger.kernel.org>; Fri, 7 Apr 2017 16:17:10 +0200
        (envelope-from Markus.Baier@bcs.tu-darmstadt.de)
Received: from [130.83.213.42] (helo=PROMETHEUS.bcs.e-technik.tu-darmstadt.de)
        by smtp.tu-darmstadt.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.69)
        (envelope-from <Markus.Baier@bcs.tu-darmstadt.de>)
        id 1cwUhK-00069o-MS
        for linux-btrfs@vger.kernel.org; Fri, 07 Apr 2017 16:17:10 +0200
From: Markus Baier <Markus.Baier@bcs.tu-darmstadt.de>
Subject: During a btrfs balance nearly all quotas of the subvolumes became
 exceeded
To: linux-btrfs@vger.kernel.org
Message-ID: <9221e88f-4a4b-de8f-e1dc-aff90c732ded@bcs.tu-darmstadt.de>
Date: Fri, 7 Apr 2017 16:17:10 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello btrfs-list,

today a strange behaviour appered during the btrfs balance process.

I started a btrfs balance operation on the /home subvolume
that contains, as childs, all the subvolumes for the home directories
of the users, every subvolume with it's own quota.

A short time after the start of the balance process no user
was able to write into his homedirectory anymore.
All users got the "your disc quota exceeded" message.

The I checked the qgroups and got the following result:

btrfs qgroup show -r /home/
qgroupid        rfer        excl     max_rfer
--------        ----        ----     --------
0/5	    16.00KiB    16.00KiB    none
0/257	    16.00KiB    16.00KiB    none
0/258	    16.00EiB    16.00EiB    200.00GiB
0/259	    16.00EiB    16.00EiB    200.00GiB
0/260	    16.00EiB    16.00EiB    200.00GiB
0/261	    16.00EiB    16.00EiB    200.00GiB
0/267	    28.00KiB    28.00KiB    200.00GiB
....
1/1	    16.00EiB    16.00EiB    900.00GiB

For most of the subvolumes btrfs calculated 16.00EiB
(I think this is the maximum possible size of the filesystem)
as the amount of used space.
A few subvolumes, all of them are nearly empty like the 0/267,
were not afected and showed the normal size of 28.00KiB

I was able to fix the problem with the:
btrfs quota rescan /home
command.
But my question is, is this a already known bug and what can
I do to prevent this problem during the next balance run?

uname -a
Linux condor-control 4.4.39-gentoo #1 SMP Fri Jan 27 19:16:30 CET 2017
x86_64 Intel Core Processor (Hasswell, no TSX) GenuineIntel GNU/Linux

btrfs --version
btrfs-progs v4.6.1

btrfs fi show
Label: none    uuid: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
     Total devices 1 FS bytes used 3.03GiB
     devid    1 size 31.98GiB used 6.12GiB path /dev/vda2

Label: none    uuid: yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy
     Total devices 1 FS bytes used 106.33GiB
     devid    1 size 1024.00GiB used 108.06GiB path /dev/vda2


Thanks,
Markus
