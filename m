Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:42660 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbaKRSWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 13:22:53 -0500
Received: by mail-pa0-f51.google.com with SMTP id ey11so8131342pad.24
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Nov 2014 10:22:53 -0800 (PST)
Received: from hobbes.nimgs.com (wsip-184-188-181-148.sd.sd.cox.net. [184.188.181.148])
        by mx.google.com with ESMTPSA id tm3sm9576421pac.12.2014.11.18.10.22.52
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 18 Nov 2014 10:22:52 -0800 (PST)
From: Craig Yoshioka <craigyk@gmail.com>
Content-Type: text/plain; charset=utf-8
Subject: raid 10 drive replacement on old raid6 btrfs volume
Message-Id: <52C9C8E2-8618-44FE-85E0-E8FE499268B7@gmail.com>
Date: Tue, 18 Nov 2014 10:22:51 -0800
To: BTRFS Mailing List <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I started experimenting with an 8 drive BTRFS RAID6, but rebalanced it a while ago as RAID10.  Recently though I’ve run into problems when trying to replace a drive.

> Nov 18 10:18:44 ganymede kernel: BTRFS warning (device sdk): dev_replace cannot yet handle RAID5/RAID6

Even though df shows RAID10:

> Data, RAID10: total=4.65TiB, used=4.62TiB
> System, RAID10: total=64.00MiB, used=432.00KiB
> Metadata, RAID10: total=34.00GiB, used=31.36GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B

Am I out of luck and need to copy everything off and start over?

Thanks,
-Craig

