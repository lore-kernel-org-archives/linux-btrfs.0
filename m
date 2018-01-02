Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:37786 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751505AbeABOp6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Jan 2018 09:45:58 -0500
Received: by mail-lf0-f41.google.com with SMTP id f3so19737567lfe.4
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Jan 2018 06:45:58 -0800 (PST)
Received: from [10.1.1.2] (89-69-130-4.dynamic.chello.pl. [89.69.130.4])
        by smtp.gmail.com with ESMTPSA id u23sm8868862lje.79.2018.01.02.06.45.55
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jan 2018 06:45:56 -0800 (PST)
Message-ID: <5A4B9B23.7080902@gmail.com>
Date: Tue, 02 Jan 2018 15:45:55 +0100
From: ein <ein.net@gmail.com>
MIME-Version: 1.0
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: A Big Thank You, and some Notes on Current Recovery Tools.
References: <CAJt7KB9UuW5Zg35VJ+fNV8RVZk_kAukmcgyK8GH4d1M286DkXA@mail.gmail.com> <c3d54bf6-20a8-0b98-baef-d2353b97849e@gmx.com> <1clphe-a7q.ln1@hurikhan77.spdns.de> <CAJt7KB-sq0sxHe_3LSC5kzU0CG8ABk4baDnGP138vNaLK0KN-Q@mail.gmail.com> <5A4B58BF.1090804@gmail.com> <MEXPR01MB216862D183D39368072481CE9E190@MEXPR01MB2168.ausprd01.prod.outlook.com> <095B13AF-A31F-485B-A335-3040E076A965@rqc.ru>
In-Reply-To: <095B13AF-A31F-485B-A335-3040E076A965@rqc.ru>
Content-Type: text/plain; charset=utf-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/02/2018 01:45 PM, Marat Khalili wrote:
>> I think the 1-3TB Seagate drives are garbage.
> 
> There are known problems with ST3000DM001, but first of all you should not put PC-oriented disks in RAID, they are not designed for it on multiple levels (vibration tolerance, error reporting...) There are similar horror stories about people filling whole cases with WD Greens and observing their (non-BTRFS) RAID 6 fail. 
> 
> 

Same with ST2000DM001, lenovo and seagate did that for instance. How the
hell user may know...

>
> (Sorry for OT.)

m2

-- 
PGP Public Key (RSA/4096b):
ID: 0xF2C6EA10
SHA-1: 51DA 40EE 832A 0572 5AD8 B3C0 7AFF 69E1 F2C6 EA10
