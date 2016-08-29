Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-me1aus01on0084.outbound.protection.outlook.com ([104.47.116.84]:18464
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756135AbcH2LdM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 07:33:12 -0400
From: Paul Jones <paul@pauljones.id.au>
To: Imran Geriskovan <imran.geriskovan@gmail.com>,
        "Stefan Priebe - Profihost AG" <s.priebe@profihost.ag>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: btrfs and systemd
Date: Mon, 29 Aug 2016 11:33:06 +0000
Message-ID: <SY3PR01MB13867F23DA1E0590A181CC5D9EE10@SY3PR01MB1386.ausprd01.prod.outlook.com>
References: <47ee55de-a77b-185a-1a01-b8b39899b188@profihost.ag>
 <0fa90a35-587e-7bfc-9418-ea8416b8f02e@cn.fujitsu.com>
 <f3a27bf7-fecd-e295-991a-8b69c3b92f12@profihost.ag>
 <CAK5rZE6-JKpNEo2zf8jmHqNTPZcPNSMNRJhb9Lbntn11=tzbmA@mail.gmail.com>
In-Reply-To: <CAK5rZE6-JKpNEo2zf8jmHqNTPZcPNSMNRJhb9Lbntn11=tzbmA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Imran Geriskovan
> Sent: Monday, 29 August 2016 9:19 PM
> To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
> Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>; linux-btrfs@vger.kernel.org
> Subject: Re: btrfs and systemd
> 
> >>> I can't find any fstab setting for systemd to higher this timeout.
> >>> There's just  the x-systemd.device-timeout but this controls how
> >>> long to wait for the device and not for the mount command.
> >>> Is there any solution for big btrfs volumes and systemd?
> >>> Stefan
> 
> Switch to Runit.
> 
> First time I seriously consider another init on my notebook is when I have a
> problem like yours.
> 
> Even when / (root) is mounted just fine, if there is any problem with any
> other fstab entry, you'll get into such a situation on systemd.
> 
> Give it a try, appending "init=/usr/bin/runit-init"
> to your kernel command line on your bootloader.
> You dont need to uninstall any package until getting Runit behave "exactly"
> as you like.

Why not just create a Systemd unit (or whatever the proper term is) that runs on boot and runs the mount command manually and doesn't wait for it to return? Seems easier than messing with init systems.


Paul.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
