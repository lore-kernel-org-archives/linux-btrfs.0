Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:49213 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539Ab3CTSTU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Mar 2013 14:19:20 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: How to recover uncorrectable errors ?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <3160822.Hx5D6eTo7L@athlonxp>
Date: Wed, 20 Mar 2013 12:19:18 -0600
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
Message-Id: <4B672F76-FAF9-4198-988D-440B6326A275@colorremedies.com>
References: <6033676.gK0GbPgrpE@athlonxp> <201303161916.55185.Martin@lichtvoll.de> <3160822.Hx5D6eTo7L@athlonxp>
To: =?iso-8859-1?Q?Fr=E9d=E9ric_COIFFIER?= <frederic.coiffier@free.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 20, 2013, at 7:33 AM, Frédéric COIFFIER <frederic.coiffier@free.fr> wrote:

> 
> 195 Hardware_ECC_Recovered  0x001a   057   055   000    Old_age   Always       -       63508940
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
> 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       1
> 200 Multi_Zone_Error_Rate   0x0000   100   253   000    Old_age   Offline      -       0
> 202 Data_Address_Mark_Errs  0x0032   100   253   000    Old_age   Always       -       0

With such high ECC recovered events, I suspect SDC. The value is in manufacturer's tolerance to not fail the drive outright, but the ECC in a consumer SATA drive isn't fool proof. It will fail to detect some errors, and report bad data back to the file system. It will detect and incorrectly "correct" others. Even if most error is detected and correctly corrected, bottom line is you have a file system that knows better and it's saying something is significantly wrong.

If you're going to continue to use the drive, I would at least use hdparm to issue ATA enhanced security erase unit. Then I'd take a smartctl -x capture for reference. Then do an extended offline smart test with -t long, which this drive has never had in its lifetime. And another smartctl -x to compare to the reference and see if either the test completed or failed, and whether any of the attributes changed appreciably during the offline test. Otherwise get a replacement.

The one off UDMA error isn't a media error, but communication between drive and controller, I wouldn't be overly concerned with that.

> The most annoying thing is that we can't delete these files. So, the only way to solve these problems is to replace the filesystem.

The storage media isn't reliable. Replacing the file system eventually will get you right back where you are now, except in a case of multiple devices with a reliable 2nd device.


Chris Murphy