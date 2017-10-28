Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59433 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750788AbdJ1HDQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Oct 2017 03:03:16 -0400
Message-Id: <1509174195.600847.1153723936.0D8751F2@webmail.messagingengine.com>
From: Kai Hendry <hendry@iki.fi>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
References: <1507456690.745489.1131538472.25270157@webmail.messagingengine.com>
 <CAJCQCtRnbz5WGqZEO3b8a+3B2gDbG_zioqWEVoJz_dD0SB=6Ww@mail.gmail.com>
 <0a3e71f7-1a8e-9a4f-7470-4c5cc2fb11a0@gmail.com>
 <1507858974.1236555.1137202920.267B449B@webmail.messagingengine.com>
Date: Sat, 28 Oct 2017 15:03:15 +0800
In-Reply-To: <1507858974.1236555.1137202920.267B449B@webmail.messagingengine.com>
Subject: Re: USB upgrade fun
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 13 Oct 2017, at 09:42 AM, Kai Hendry wrote:
> It probably is... since when I remove my new 4TB USB disk from the
> front, I am at least able to mount my two 2x2TB in degraded mode and see
> my data!

Just a follow up. I have not been of late been able to mount my data,
even in degraded mode.

However someone on #btrfs suggested I try an older Linux kernel & I also
found https://www.spinics.net/lists/linux-btrfs/msg69905.html to
reaffirm my suspicions.

Low and behold I can mount with an older kernel
(linux-4.4.3-1-x86_64.pkg.tar.xz) !! But if I reboot into 4.13.9-1-ARCH,
no worky:

[  489.139903] BTRFS warning (device sdb1): devid 3 uuid
e5f03f81-35e7-4a29-9608-bd78864cc0ad is missing
[  489.524334] BTRFS info (device sdb1): bdev (null) errs: wr 0, rd 1,
flush 0, corrupt 0, gen 0
[  489.524367] BTRFS info (device sdb1): bdev /dev/sdb1 errs: wr 13361,
rd 31990017, flush 155, corrupt 0, gen 0
[  502.934069] BTRFS warning (device sdb1): missing devices (1) exceeds
the limit (0), writeable mount is not allowed
[  502.980748] BTRFS error (device sdb1): open_ctree failed


Does anyone know how I can track the progress of "--fix-dev-size"? It
doesn't seem part of btrfs-progs 4.13-1...
