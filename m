Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-me1aus01on0050.outbound.protection.outlook.com ([104.47.116.50]:51840
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754908AbcH0DU1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Aug 2016 23:20:27 -0400
From: Paul Jones <paul@pauljones.id.au>
To: E V <eliventer@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: RE: linux 4.7.2 & btrfs & rsync & OOM gone crazy
Date: Sat, 27 Aug 2016 02:46:15 +0000
Message-ID: <SY3PR01MB138602A6BA37AC81902B7BF59EEF0@SY3PR01MB1386.ausprd01.prod.outlook.com>
References: <CAJtFHUSSEd0ABBRi1-Ko4ciu+-tr62KvkBDVRc4zYf8PF_g4cA@mail.gmail.com>
In-Reply-To: <CAJtFHUSSEd0ABBRi1-Ko4ciu+-tr62KvkBDVRc4zYf8PF_g4cA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of E V
> Sent: Saturday, 27 August 2016 5:01 AM
> To: linux-btrfs <linux-btrfs@vger.kernel.org>
> Subject: linux 4.7.2 & btrfs & rsync & OOM gone crazy
> 
> Just upgraded from 4.6.5 to 4.7.2 for my btrfs backup server with 32GB of
> ram. Only thing that run's on it is an rsync of an NFS filesystem to the local
> btrfs. Cached mem tends to hang out around 26-30GB, but with 4.7.2 the
> OOM is now going crazy and trying to kill whatever it can including my ssh and
> rsync process. Anyone seen anything similar?
> Trying it again with /proc/sys/vm/swappiness at 0 will see if that makes a
> difference.


Yes, I had the same issue on a backup VM that only has 1G ram - rsync constantly is killed by OOM. Doesn't happen on the main machine with 24G ram.

Paul.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
