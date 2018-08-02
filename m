Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ed1-f52.google.com ([209.85.208.52]:39837 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727189AbeHBM0X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2018 08:26:23 -0400
Received: by mail-ed1-f52.google.com with SMTP id h4-v6so761714edi.6
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Aug 2018 03:35:50 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: BTRFS and databases
From: Andrei Borzenkov <arvidjaar@gmail.com>
In-Reply-To: <2861903.YXSMuvecdq@merkaba>
Date: Thu, 2 Aug 2018 13:35:47 +0300
Cc: Hugo Mills <hugo@carfax.org.uk>, MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <F4227CB0-E722-4CCA-A353-F911BF72CA3B@gmail.com>
References: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com> <20180801085602.GC7524@carfax.org.uk> <2861903.YXSMuvecdq@merkaba>
To: Martin Steigerwald <martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Отправлено с iPhone

> 2 авг. 2018 г., в 12:16, Martin Steigerwald <martin@lichtvoll.de> написал(а):
> 
> Hugo Mills - 01.08.18, 10:56:
>>> On Wed, Aug 01, 2018 at 05:45:15AM +0200, MegaBrutal wrote:
>>> I know it's a decade-old question, but I'd like to hear your
>>> thoughts
>>> of today. By now, I became a heavy BTRFS user. Almost everywhere I
>>> use BTRFS, except in situations when it is obvious there is no
>>> benefit (e.g. /var/log, /boot). At home, all my desktop, laptop and
>>> server computers are mainly running on BTRFS with only a few file
>>> systems on ext4. I even installed BTRFS in corporate productive
>>> systems (in those cases, the systems were mainly on ext4; but there
>>> were some specific file systems those exploited BTRFS features).
>>> 
>>> But there is still one question that I can't get over: if you store
>>> a
>>> database (e.g. MySQL), would you prefer having a BTRFS volume
>>> mounted
>>> with nodatacow, or would you just simply use ext4?
>> 
>>   Personally, I'd start with btrfs with autodefrag. It has some
>> degree of I/O overhead, but if the database isn't performance-critical
>> and already near the limits of the hardware, it's unlikely to make
>> much difference. Autodefrag should keep the fragmentation down to a
>> minimum.
> 
> I read that autodefrag would only help with small databases.
> 

I wonder if anyone actually 

a) quantified performance impact
b) analyzed the cause

I work with NetApp for a long time and I can say from first hand experience that fragmentation had zero impact on OLTP workload. It did affect backup performance as was expected, but this could be fixed by periodic reallocation (defragmentation).

And even that needed quite some time to observe (years) on pretty high  load database with regular backup and replication snapshots.

If btrfs is so susceptible to fragmentation, what is the reason for it?

