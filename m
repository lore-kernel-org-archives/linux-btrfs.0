Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36604 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751743AbdEOAYI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 May 2017 20:24:08 -0400
Received: by mail-wm0-f65.google.com with SMTP id u65so24443728wmu.3
        for <linux-btrfs@vger.kernel.org>; Sun, 14 May 2017 17:24:08 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: Btrfs/SSD
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
In-Reply-To: <CAK5rZE7MKrqNSuJXTYe=H_T6WbYJgcGhV9VUHH0pQ689-tKiAg@mail.gmail.com>
Date: Mon, 15 May 2017 01:24:05 +0100
Cc: Chris Murphy <lists@colorremedies.com>, Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <D9491068-A906-4B75-9ED3-B98960FFBF14@gmail.com>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
 <CAK5rZE7WHeTknmQdjX7vianEj4RmdLU+ocTLhbAxYenRjLegaA@mail.gmail.com>
 <20170512202756.16bd785f@jupiter.sol.kaishome.de>
 <pan$3384$13ad2b1f$3febf76a$c09fcbd7@cox.net>
 <CAJCQCtQnM21-JPs+6+YeykTj-s1J43E8rNCkHHyk+AjvzZEddg@mail.gmail.com>
 <250FCE39-0DAE-4AF2-B378-E56BE044F2E7@gmail.com>
 <CAK5rZE7MKrqNSuJXTYe=H_T6WbYJgcGhV9VUHH0pQ689-tKiAg@mail.gmail.com>
To: Imran Geriskovan <imran.geriskovan@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Theoretically all sectors in over provision are erased - practically they are either erased or waiting to be erased or broken.

What you have to understand is that sectors on SSD are not where you really think they are - they can swap place with sectors with over provisioning are, they can swap place with each other ect … stuff you see as a disk from 0 to MAX does not have to be arranged in sequence on SSD (and mostly never is) 

If you never trim - when your device is 100% full - you need to start overwrite data to keep writing - this is where over provisioning shines: ssd fakes that you write to a sector while really you write to a sector in over provisioning area and those magically swap places without you knowing -> the sector that was occupied ends up in over provisioning pool and SSD hardware performs a slow errase on it to make it free for the future. This mechanism is simple, and transparent for users -> you don’t know that it happens and SSD does all heavy lifting. 

Over provisioned area does have more uses than that. For example if you have a 1TB drive where you store 500GB of data that you never modify -> SSD will copy part of that data to over provisioned area -> free sectors that were unwritten for a while -> free sectors that were continuously hammered by writes and write a static data there. This mechanism is wear levelling - it means that SSD internals make sure that sectors on SSD have an equal use over time. Despite of some thinking that it’s pointless imagine situation where you’ve got a 1TB drive with 1GB free and you keep writing and modifying data in this 1GB free … those sectors will quickly die due to short flash life expectancy ( some as short as 1k erases !!!!! ).

So again, buy a good quality drives (not a hardcore enterprise drives, just good customer ones) and leave stuff to a drive + use OS that gives you trim and you should be golden !!!!

> On 15 May 2017, at 00:01, Imran Geriskovan <imran.geriskovan@gmail.com> wrote:
> 
> On 5/14/17, Tomasz Kusmierz <tom.kusmierz@gmail.com> wrote:
>> In terms of over provisioning of SSD it’s a give and take relationship … on
>> good drive there is enough over provisioning to allow a normal operation on
>> systems without TRIM … now if you would use a 1TB drive daily without TRIM
>> and have only 30GB stored on it you will have fantastic performance but if
>> you will want to store 500GB at roughly 200GB you will hit a brick wall and
>> you writes will slow dow to megabytes / s … this is symptom of drive running
>> out of over provisioning space …
> 
> What exactly happens on a non-trimmed drive?
> Does it begin to forge certain erase-blocks? If so
> which are those? What happens when you never
> trim and continue dumping data on it?

