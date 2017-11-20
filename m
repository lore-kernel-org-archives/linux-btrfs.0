Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zougloub.eu ([69.70.16.42]:40908 "EHLO zougloub.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751086AbdKTGvH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 01:51:07 -0500
Received: from Vantage.cJ (exmakhina.com [69.70.16.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by zougloub.eu (Postfix) with ESMTPSA id E5ECDF0AB43
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2017 01:37:18 -0500 (EST)
Date: Mon, 20 Nov 2017 01:43:44 -0500
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: linux-btrfs@vger.kernel.org
Subject: Issues while doing btrfs delete missing in raid6
Message-ID: <20171120014344.7a5d8bd2@Vantage.cJ>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,


While doing a test (to evaluate drives), where I'm filling a bunch of
drives in RAID6, one of the disks failed in the process.
(System with v4.14 / ECC).
I remounted the array in degraded, launched a "btrfs delete missing"
as I have no replacement device.

The command (takes ages and) fails with:
 ERROR: error removing device 'missing': Input/output error

and klog says:

 [631517.263313] BTRFS info (device dm-18): relocating block group 1411883335680 flags data|raid6
 [631547.556527] btrfs_print_data_csum_error: 151 callbacks suppressed
 [631547.556530] BTRFS warning (device dm-18): csum failed root -9 ino 1177 off 3559653376 csum 0x2e827bb4 expected csum 0xda9c34d6 mirror 2
 [631547.562727] BTRFS warning (device dm-18): csum failed root -9 ino 1177 off 3559657472 csum 0x6722cd32 expected csum 0x3ca2ce6f mirror 2
 [631547.562730] BTRFS warning (device dm-18): csum failed root -9 ino 1177 off 3559661568 csum 0x90368636 expected csum 0xf55a0410 mirror 2
 [631547.562732] BTRFS warning (device dm-18): csum failed root -9 ino 1177 off 3559665664 csum 0x3e38aeb2 expected csum 0x6c80a970 mirror 2
 [631547.562746] BTRFS warning (device dm-18): csum failed root -9 ino 1177 off 3559669760 csum 0x77d73f2d expected csum 0xe62cfbe8 mirror 2
 [631547.562747] BTRFS warning (device dm-18): csum failed root -9 ino 1177 off 3559673856 csum 0xb03d1632 expected csum 0xe9a3f0e6 mirror 2
 [631547.562756] BTRFS warning (device dm-18): csum failed root -9 ino 1177 off 3559677952 csum 0xeea04377 expected csum 0x8819aaf7 mirror 2
 [631547.562758] BTRFS warning (device dm-18): csum failed root -9 ino 1177 off 3559682048 csum 0xe46ab546 expected csum 0xacc16686 mirror 2
 [631547.562775] BTRFS warning (device dm-18): csum failed root -9 ino 1177 off 3559690240 csum 0x956a74d7 expected csum 0x99e29858 mirror 2
 [631547.562788] BTRFS warning (device dm-18): csum failed root -9 ino 1177 off 3559686144 csum 0xb09a35ae expected csum 0x5f61fa99 mirror 2

Since this is RAID6, I wasn't expecting to not be able to recover
from a checksum issue, also it's not very practical to bail out on the first
error of this kind during a delete... the offending blocks could be
left as is.

I then try to work around the issue by removing the offending file
(yes it's a test, but filling the drives takes a lot of time),
finding it with "btrfs inspect-internal inode-resolve 1177", and somehow:
 ERROR: ino paths ioctl: No such file or directory


Regards,

-- 
Jérôme
