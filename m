Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:57416 "EHLO
        smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751525AbeABMpz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Jan 2018 07:45:55 -0500
Date: Tue, 02 Jan 2018 15:45:46 +0300
In-Reply-To: <MEXPR01MB216862D183D39368072481CE9E190@MEXPR01MB2168.ausprd01.prod.outlook.com>
References: <CAJt7KB9UuW5Zg35VJ+fNV8RVZk_kAukmcgyK8GH4d1M286DkXA@mail.gmail.com> <c3d54bf6-20a8-0b98-baef-d2353b97849e@gmx.com> <1clphe-a7q.ln1@hurikhan77.spdns.de> <CAJt7KB-sq0sxHe_3LSC5kzU0CG8ABk4baDnGP138vNaLK0KN-Q@mail.gmail.com> <5A4B58BF.1090804@gmail.com> <MEXPR01MB216862D183D39368072481CE9E190@MEXPR01MB2168.ausprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: RE: A Big Thank You, and some Notes on Current Recovery Tools.
To: Paul Jones <paul@pauljones.id.au>, ein.net@gmail.com
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <095B13AF-A31F-485B-A335-3040E076A965@rqc.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I think the 1-3TB Seagate drives are garbage.

There are known problems with ST3000DM001, but first of all you should not put PC-oriented disks in RAID, they are not designed for it on multiple levels (vibration tolerance, error reporting...) There are similar horror stories about people filling whole cases with WD Greens and observing their (non-BTRFS) RAID 6 fail. 

(Sorry for OT.)
-- 

With Best Regards,
Marat Khalili
