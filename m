Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:38978 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaE1SjL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 14:39:11 -0400
Received: by mail-ig0-f176.google.com with SMTP id hl10so2786505igb.15
        for <linux-btrfs@vger.kernel.org>; Wed, 28 May 2014 11:39:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKZK7ux1Cm0tQFqFJtTPbL089DQR+4Ekv5Ef8L3BgUkyY+bLQA@mail.gmail.com>
References: <CAKZK7uwZOZEjQ-T9z-KGSRpW1xpY911_QoDM26SBdmSViRtrZA@mail.gmail.com>
	<08C16AE5-02A8-413B-B95C-EC2B5A1D32EC@colorremedies.com>
	<CAKZK7ux1Cm0tQFqFJtTPbL089DQR+4Ekv5Ef8L3BgUkyY+bLQA@mail.gmail.com>
Date: Wed, 28 May 2014 13:39:10 -0500
Message-ID: <CAKZK7uy6Y7_+JQGrZp5yTpZ2kCsH8wGDhz+Oq4oGidYkQNcq1g@mail.gmail.com>
Subject: Fwd: Failed Disk RAID10 Problems
From: Justin Brown <justin.brown@fandingo.org>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

Thanks for the tip. I was able to mount the drive as degraded and
recovery. Then, I deleted the faulty drive, leaving me with the
following array:


Label: media  uuid: 7b7afc82-f77c-44c0-b315-669ebd82f0c5

Total devices 6 FS bytes used 2.40TiB

devid    1 size 931.51GiB used 919.88GiB path
/dev/mapper/SAMSUNG_HD103SI_499431FS734755p1

devid    2 size 931.51GiB used 919.38GiB path /dev/dm-8

devid    3 size 1.82TiB used 1.19TiB path /dev/dm-6

devid    4 size 931.51GiB used 919.88GiB path /dev/dm-5

devid    5 size 0.00 used 918.38GiB path /dev/dm-11

devid    6 size 1.82TiB used 3.88GiB path /dev/dm-9


/dev/dm-11 is the failed drive. I take it that size 0 is a good sign.
I'm not really sure where to go from here. I tried rebooting the
system with the failed drive attached, and Btrfs re-adds it to the
array. Should I physically remove the drive now? Is a balance
recommended?


Thanks,

Justin
