Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36199 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752733AbdGXXSV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 19:18:21 -0400
Received: by mail-wm0-f43.google.com with SMTP id t201so31511026wmt.1
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 16:18:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170724211758.zhgzyk5p2zzkcbog@angband.pl>
References: <1500895655.2781.6.camel@cloud.haefemeier.eu> <CAJCQCtT3nEaHox7jiO-jf6hCjpUSRz=AahrapgZDajJdeYr1Rw@mail.gmail.com>
 <20170724204257.GJ7140@carfax.org.uk> <CAJCQCtTpdn0zNmogkbDr0h4RjNvb8u21w7Sj3xjUrj77A+ss8w@mail.gmail.com>
 <20170724211758.zhgzyk5p2zzkcbog@angband.pl>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 24 Jul 2017 17:18:19 -0600
Message-ID: <CAJCQCtRN7+qZLvvPTBTht+3oAAsBZStJOtnR4Hh0a8+83iN1iw@mail.gmail.com>
Subject: Re: Best Practice: Add new device to RAID1 pool
To: Adam Borowski <kilobyte@angband.pl>
Cc: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        Cloud Admin <admin@cloud.haefemeier.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 24, 2017 at 3:17 PM, Adam Borowski <kilobyte@angband.pl> wrote:
> On Mon, Jul 24, 2017 at 02:55:00PM -0600, Chris Murphy wrote:
>> Egads.
>>
>> Maybe Cloud Admin ought to consider using a filter to just balance the
>> data chunks across the three devices, and just leave the metadata on
>> the original two disks?
>
> Balancing when adding a new disk isn't that important unless the two old
> disks are almost full.
>
>> Maybe
>> sudo btrfs balance start -dusage=100 <mp>
>
> Note that this doesn't mean "all data", merely "all data chunks < 100%
> full".  It's a strictly-lesser-than comparison.
>
> You'd want "-dusage=101" which is illegal, the right one is "-d".  I used to
> believe -dusage=100 does that, myself.


Yeah they could even go with 50% because the balance isn't strictly
necessary anyway if the two originals aren't close to full and b.

-- 
Chris Murphy
