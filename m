Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-me1aus01on0043.outbound.protection.outlook.com ([104.47.116.43]:23661
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752008AbcIAHHg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Sep 2016 03:07:36 -0400
From: Paul Jones <paul@pauljones.id.au>
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: RE: btrfs-progs 4.7, check reports many "incorrect local backref
 count" messages
Date: Thu, 1 Sep 2016 06:51:15 +0000
Message-ID: <SY3PR01MB13864A03DC2503EF7E0381A49EE20@SY3PR01MB1386.ausprd01.prod.outlook.com>
References: <CAJCQCtT5YA9EMq1ZC-qeZcNLUeg1GocBm3nT2nZFEBigmV4BxQ@mail.gmail.com>
 <CAJCQCtQjX+0nAWRNPK2gYNoi8wvHxTMEzm6v84PZKXnTLxc50Q@mail.gmail.com>
 <CAJCQCtT0=gEwBerYXYnyueMk3JnmGZp71qBJFB5N4qR4ASF7cg@mail.gmail.com>
 <CAJCQCtRZNNTZ5ymH-X9Cq=h+_aaATym40W42BJ-xM5ECJOQnDg@mail.gmail.com>
 <CAJCQCtTo7nS7grh-9XWTKXX_h2pXPXCbLMRGmTfa=NzHq2Aa6g@mail.gmail.com>
 <CAJCQCtS374FCEqSx0qBdF1oa6=y48A4p0pMN0u456adQETyS_Q@mail.gmail.com>
In-Reply-To: <CAJCQCtS374FCEqSx0qBdF1oa6=y48A4p0pMN0u456adQETyS_Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Chris Murphy
> Sent: Thursday, 1 September 2016 7:59 AM
> To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
> Subject: Re: btrfs-progs 4.7, check reports many "incorrect local backref
> count" messages
> 
> This is still happening with btrfs-progs 4.7.1 and there is zero information in
> the long result what to do about the problem, and whether it's sane to try
> have --repair fix it, let alone what the original cause of the problem was.

I just potentially damaged a perfectly good filesystem because of this. I was getting hundreds of "Incorrect local backref count" so I decided to try repair, which seemed to complete ok. I then rescanned without repair and btrfs check eventually crashed with an assertion. That's when I figured something may be wrong.

Thankfully I have an offsite backup (this was the onsite backup), but what a pain....

Paul.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
