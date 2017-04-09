Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-sy3aus01on0071.outbound.protection.outlook.com ([104.47.117.71]:62048
        "EHLO AUS01-SY3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751211AbdDIGi5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 9 Apr 2017 02:38:57 -0400
From: Paul Jones <paul@pauljones.id.au>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: RE: About free space fragmentation, metadata write amplification and
 (no)ssd
Date: Sun, 9 Apr 2017 06:38:54 +0000
Message-ID: <SY3PR01MB0971BB9CC9DE8501D2132CD19E0E0@SY3PR01MB0971.ausprd01.prod.outlook.com>
References: <5e11b988-05ea-c468-21ef-589c71058436@mendix.com>
In-Reply-To: <5e11b988-05ea-c468-21ef-589c71058436@mendix.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----Original Message-----
From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Hans van Kranenburg
Sent: Sunday, 9 April 2017 6:19 AM
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: About free space fragmentation, metadata write amplification and (no)ssd

> So... today a real life story / btrfs use case example from the trenches at work...

Snip!!

Great read. I do the same thing for backups on a much smaller scale and it works brilliantly.  Two 4T drives in btrfs raid1.
I will mention that I recently setup caching using LLVM (1 x 300G ssd for each 4T drive), and it's extraordinary how much of a difference it makes. Especially when running deduplication. If it's feasible perhaps you could try it with a nvme drive.

Paul.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
