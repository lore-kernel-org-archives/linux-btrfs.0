Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-me1aus01on0056.outbound.protection.outlook.com ([104.47.116.56]:5584
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752085AbeABLPZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Jan 2018 06:15:25 -0500
From: Paul Jones <paul@pauljones.id.au>
To: ein <ein.net@gmail.com>, "swestrup@gmail.com" <swestrup@gmail.com>,
        "Kai Krakow" <hurikhan77@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: A Big Thank You, and some Notes on Current Recovery Tools.
Date: Tue, 2 Jan 2018 11:15:18 +0000
Message-ID: <MEXPR01MB216862D183D39368072481CE9E190@MEXPR01MB2168.ausprd01.prod.outlook.com>
References: <CAJt7KB9UuW5Zg35VJ+fNV8RVZk_kAukmcgyK8GH4d1M286DkXA@mail.gmail.com>
 <c3d54bf6-20a8-0b98-baef-d2353b97849e@gmx.com>
 <1clphe-a7q.ln1@hurikhan77.spdns.de>
 <CAJt7KB-sq0sxHe_3LSC5kzU0CG8ABk4baDnGP138vNaLK0KN-Q@mail.gmail.com>
 <5A4B58BF.1090804@gmail.com>
In-Reply-To: <5A4B58BF.1090804@gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of ein
> Sent: Tuesday, 2 January 2018 9:03 PM
> To: swestrup@gmail.com; Kai Krakow <hurikhan77@gmail.com>
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: A Big Thank You, and some Notes on Current Recovery Tools.


> Forgive me if it's not relevant, but I own quite a few disks from that series,
> like:
> 
> root@iomega-ordo:~# hdparm -i /dev/sda
> /dev/sda:
>  Model=ST2000DM001-1CH164, FwRev=CC27, SerialNo=Z1E6EV85  Config={
> HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs RotSpdTol>.5% }
> 
> root@iomega-acm:~# smartctl -d sat -a /dev/sda === START OF
> INFORMATION SECTION ===
> Device Model:     ST3000DM001-9YN166
> Serial Number:    S1F0PGQJ
> LU WWN Device Id: 5 000c50 0516fce00
> Firmware Version: CC4B
> 
> root@iomega-europol:~# smartctl -d sat -a /dev/sda smartctl 5.41 2011-06-09
> r3365 [armv5tel-linux-2.6.31.8] (local build) === START OF INFORMATION
> SECTION ===
> Device Model:     ST3000DM001-9YN166
> Serial Number:    Z1F1H5KA
> LU WWN Device Id: 5 000c50 04ec18fda
> 
> Different locations, different environments, different boards one more
> stable (the power) than others.
> 
> I replaced at least three four in the past 3 years. All of them died because
> heavy random wirte workload. (rsnapshot, massive cp -al of millions of files
> every day). In my case every time bad sectors occurred too, but I didn't
> analyze where exactly, it was just a backup destination drive. I pretty
> convinced it could be ext2 supers too though.

I think the 1-3TB Seagate drives are garbage. Out of 6 drives I replaced all under warranty due to bad sectors, 2 of them were replaced twice! As the replacements failed out of warranty they were replaced with 3-4TB HGST drives and I've had no problems ever since. My workload was just a daily backup store, so they sat there idling about 22 hours a day.
I hear the 4+TB Seagate drives are much better quality but I have no experience with them.

Paul.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
