Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:33027 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbcIOQaQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 12:30:16 -0400
Received: by mail-qt0-f181.google.com with SMTP id 11so29999750qtc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 09:30:15 -0700 (PDT)
From: Alexandre Poux <pums974@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Subject: Re: multi-device btrfs with single data mode and disk failure
References: <1634818f-ff1d-722c-6d73-747ed7203a13@gmail.com>
 <CAJCQCtQHBkx8kjcAdSbmgYcHCo_w3VPj8jvgby3cE-S6rLAPdw@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <ecac8c64-8ed4-7c8d-29ad-5b3687981a33@gmail.com>
Date: Thu, 15 Sep 2016 18:30:12 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQHBkx8kjcAdSbmgYcHCo_w3VPj8jvgby3cE-S6rLAPdw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you very much for your answers

Le 15/09/2016 à 17:38, Chris Murphy a écrit :
> On Thu, Sep 15, 2016 at 1:44 AM, Alexandre Poux <pums974@gmail.com> wrote:
>>     Is it possible to do some king of a "btrfs delete missing" on this
>>     kind of setup, in order to recover access in rw to my other data, or
>>     I must copy all my data on a new partition
> That *should* work :) Except that your file system with 6 drives is
> too full to be shrunk to 5 drives. Btrfs will either refuse, or get
> confused, about how to shrink a nearly full 6 drive volume into 5.
>
> So you'll have to do one of three things:
>
> 1. Add a 2+TB drive, then remove the missing one; OR
> 2. btrfs replace is faster and is raid10 reliable; OR
> 3. Read only scrub to get a file listing of bad files, then remount
> read-write degraded and delete them all. Now you maybe can do a device
> delete missing. But it's still a tight fit, it basically has to
> balance things out to get it to fit on an odd number of drives, it may
> actually not work even though there seems to be enough total space,
> there has to be enough space on FOUR drives.
>
Are you sure you are talking about data in single mode ?
I don't understand why you are talking about raid10,
or the fact that it will have to rebalance everything.

Moreover, even in degraded mode I cannot mount it in rw
It tells me
"too many missing devices, writeable remount is not allowed"
due to the fact I'm in single mode.

And as far as as know, btrfs replace and btrfs delete, are not supposed
to work in read only...

I would like to tell him forgot about the missing data, and give me back
my partition.

In fact I'm pretty sure, there was no data at all on the dead device,
only metadata in raid1.
I'm currently scrubing to be absolutely sure

