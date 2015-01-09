Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:57340 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbbAIPNr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Jan 2015 10:13:47 -0500
Received: from [192.168.178.40] ([94.219.210.74]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0MaaOf-1YOfIW3BoP-00K7Cq for
 <linux-btrfs@vger.kernel.org>; Fri, 09 Jan 2015 16:13:45 +0100
Message-ID: <1420816425.4982.7.camel@AMD>
Subject: btrfs scrub and kernel parent transid
From: Lars Callenbach <lars.callenbach@gmx.de>
To: linux-btrfs@vger.kernel.org
Date: Fri, 09 Jan 2015 16:13:45 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

in kernel logs I get an error message of the type 'parent transid verify
failed' but 'btrfs scrub ...' does not show any errors/inconsistencies.
Do I have to worry about these kernel error messages?

Best regards,
   Lars

~ # uname -a
Linux 3.17.8-MYVERSION #1 SMP PREEMPT Thu Jan 8 23:29:09 CET 2015
x86_64 x86_64 x86_64 GNU/Linux
~ #   btrfs --version
Btrfs v3.18+20141230
~ #   btrfs fi show
Label: none  uuid: 1436cbe7-2bb2-418a-8426-8c3267e0b207
	Total devices 2 FS bytes used 156.14GiB
	devid    1 size 200.00GiB used 79.02GiB path /dev/sdc1
	devid    2 size 200.00GiB used 80.00GiB path /dev/sdb1

Btrfs v3.18+20141230
~ #   btrfs fi df /
Data, single: total=155.01GiB, used=153.17GiB
System, single: total=4.00MiB, used=24.00KiB
Metadata, single: total=4.01GiB, used=2.97GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

~ # dmesg | less
[    2.632199] Btrfs loaded
[    2.775988] BTRFS: device fsid 1436cbe7-2bb2-418a-8426-8c3267e0b207
devid 1 transid 35348 /dev/sdc1
[    2.776216] BTRFS: device fsid 1436cbe7-2bb2-418a-8426-8c3267e0b207
devid 2 transid 35348 /dev/sdb1
[    2.893536] BTRFS info (device sdb1): use ssd allocation scheme
[    2.893576] BTRFS info (device sdb1): disk space caching is enabled
[    2.966782] BTRFS info (device sdb1): disk space caching is enabled
[    3.301071] BTRFS info (device sdb1): disk space caching is enabled
[    3.405363] parent transid verify failed on 1514311680 wanted 21004
found 35043
[    3.406370] parent transid verify failed on 17290989568 wanted 21054
found 32893
[    3.407234] parent transid verify failed on 17290989568 wanted 21054
found 32893
[    3.409509] parent transid verify failed on 1514311680 wanted 21004
found 35043
[    3.410150] parent transid verify failed on 17290989568 wanted 21054
found 32893
[    3.429175] parent transid verify failed on 1514311680 wanted 21004
found 35043
[    8.855751] verify_parent_transid: 210 callbacks suppressed
[    8.855758] parent transid verify failed on 17290989568 wanted 21054
found 32893
[    8.879863] parent transid verify failed on 17290989568 wanted 21054
found 32893
[    8.881082] parent transid verify failed on 17290989568 wanted 21054
found 32893
[    8.910707] parent transid verify failed on 17290989568 wanted 21054
found 32893
[    8.943407] parent transid verify failed on 17290989568 wanted 21054
found 32893
[    8.948028] parent transid verify failed on 17290989568 wanted 21054
found 32893
[    8.996504] parent transid verify failed on 17290989568 wanted 21054
found 32893
[    9.038146] parent transid verify failed on 17290989568 wanted 21054
found 32893
[    9.047055] parent transid verify failed on 17290989568 wanted 21054
found 32893
[    9.055749] parent transid verify failed on 17290989568 wanted 21054
found 32893


