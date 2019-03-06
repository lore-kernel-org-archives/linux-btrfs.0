Return-Path: <SRS0=mVxD=RJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5948BC43381
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Mar 2019 14:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31C8120684
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Mar 2019 14:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfCFO3V convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Mar 2019 09:29:21 -0500
Received: from mta02.intility.com ([137.221.26.8]:19507 "EHLO
        mta02.intility.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfCFO3V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Mar 2019 09:29:21 -0500
X-Greylist: delayed 608 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Mar 2019 09:29:20 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2GRAABn1X9c/3ENAQpkHgEGBwaBUwc?=
 =?us-ascii?q?LAYJmgUWyEoF7DAGJQjYHDQEBAwEBAwEDAgICgQYLhWAsDR4mAT5CJgEEG7F?=
 =?us-ascii?q?RgyyCGIRmgS+NAD+DAW2KdSICihaZeQmSeAgZky+DOoc1kjECBAIEBQIUgU4?=
 =?us-ascii?q?LT4EuMxojgz2CEgMXjh6NaIEfAQE?=
X-IronPort-AV: E=Sophos;i="5.58,448,1544482800"; 
   d="scan'208";a="8472746"
Received: from i2v-ex16-013.i04.local ([10.1.13.113])
  by mta02.intility.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2019 15:19:09 +0100
Received: from I2V-EX16-015.i04.local (10.3.13.115) by I2V-EX16-013.i04.local
 (10.1.13.247) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1531.3; Wed, 6 Mar 2019
 15:19:05 +0100
Received: from I2V-EX16-015.i04.local ([fe80::fd58:203f:928c:b7b6]) by
 I2V-EX16-015.i04.local ([fe80::fd58:203f:928c:b7b6%6]) with mapi id
 15.01.1531.010; Wed, 6 Mar 2019 15:19:05 +0100
From:   Michael Firth <MFirth@nevion.com>
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: btrfs filesystem failing with 'No space left on device' after 4 hours
Thread-Topic: btrfs filesystem failing with 'No space left on device' after 4
 hours
Thread-Index: AdTUJZNcHX8zyu3mQ+elNqF+cG3TCg==
Date:   Wed, 6 Mar 2019 14:19:05 +0000
Message-ID: <3ac57b0b1d8a4060b7411b4b3db5c52f@nevion.com>
Accept-Language: en-GB, nb-NO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.73.12.2]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

I have a BTRFS filesystem that seems to have become very ill. After 4 hours of being mounted, it will fail with every write attempt saying "No space left on device".

Unmounting and remounting the filesystem clears the issue for another 4 hours

From every check I have done, no messages are logged at the point of the failure to "dmesg" or any system log.

I'm over 99% sure there is not a space issue on the filesystem - it has over 100GB free, and I've run a full "balance" which has not changed the behaviour. A "scrub" on the filesystem hasn't reported any issues.

The output of the three (why on earth are there three?) disk space commands on the filesystem are:

--------------------------------------------------------------------------------------------------------------------------------------
$ sudo btrfs filesystem usage /home
Overall:
    Device size:                                    450.00GiB
    Device allocated:                         319.06GiB
    Device unallocated:                    130.94GiB
    Device missing:                                  0.00B
    Used:                                                305.95GiB
    Free (estimated):                        131.77GiB           (min: 66.30GiB)
    Data ratio:                                            1.00
    Metadata ratio:                                  2.00
    Global reserve:                             512.00MiB          (used: 0.00B)

Data,single: Size:299.00GiB, Used:298.16GiB
   /dev/mapper/VG-HomeVol              299.00GiB

Metadata,DUP: Size:10.00GiB, Used:3.89GiB
   /dev/mapper/VG-HomeVol                20.00GiB

System,DUP: Size:32.00MiB, Used:80.00KiB
   /dev/mapper/VG-HomeVol                64.00MiB

Unallocated:
   /dev/mapper/VG-HomeVol              130.94GiB

$ sudo btrfs filesystem df /home
Data, single: total=299.00GiB, used=298.16GiB
System, DUP: total=32.00MiB, used=80.00KiB
Metadata, DUP: total=10.00GiB, used=3.89GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

$ sudo btrfs filesystem show /home
Label: none  uuid: 550e6e7c-d669-4128-9b0d-b61ef4f3f1c1
                Total devices 1 FS bytes used 302.07GiB
                devid    1 size 450.00GiB used 319.06GiB path /dev/mapper/VG-HomeVol
--------------------------------------------------------------------------------------------------------------------------------------

From my understanding of the output in this, there don't seem to be any areas that are even close to full. And if it was a genuine full condition, even due to running out of metadata or something, then I wouldn't expect unmounting and remounting to clear the issue.

Is there any known issue that may cause this behaviour?

Is there any way to get more debugging from what is going on?

My initial thought was that it might be related to snapshots, as I was generating regular snapshots (for a 'previous versions' feature), and many of the failures were just after a snapshot was created. However, I have now disabled the snapshot creation and I am still seeing regular failures.

The system is running stock Debian 9 (Stretch). It was running their latest 4.9 kernel (Rev 4.9.144-3.1) when the problem first occurred. After two instances of the problem, I rolled back to their previous kernel (Rev 4.9.130-2), which the system had been running error free for several months, but the failures have continued.

I'm happy to get any other information that would be needed to debug this, if someone can point me to how to do it.

Currently my faith in BTRFS is approaching zero (it was knocked after a data loss in October, but had grown again). It has a lot of nice features, but (despite comments on the Wiki) really does not seem stable, at least not in Debian.

Thanks

Michael

