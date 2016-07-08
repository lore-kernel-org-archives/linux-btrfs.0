Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:34320 "EHLO
	mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609AbcGHSQN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jul 2016 14:16:13 -0400
Received: by mail-vk0-f52.google.com with SMTP id d67so64887753vkh.1
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jul 2016 11:16:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8cfbbe33-86da-7199-1b4e-cf13fa8e0f1b@gmail.com>
References: <0120508a-b9e7-b9e7-4f27-79f982ee07fe@fastmail.fm>
 <CAJCQCtRV2Eis8h9u_Mpum_pFoLzOQe+LjooO0Y4_AYqwsVBiMA@mail.gmail.com>
 <c8c5564e-623a-f1ca-b1c2-521e18de714c@fastmail.fm> <8cfbbe33-86da-7199-1b4e-cf13fa8e0f1b@gmail.com>
From: Henk Slager <eye1tm@gmail.com>
Date: Fri, 8 Jul 2016 20:16:11 +0200
Message-ID: <CAPmG0japRHX7_BBAHGAh=uwPTOOYDvAcAXmvT60VGabYHsr2iw@mail.gmail.com>
Subject: Re: Frequent btrfs corruption on a USB flash drive
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Francesco Turco <fturco@fastmail.fm>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> Device is GOOD
>>
>> I also created a big file with dd using /dev/urandom with the same size
>> as my flash drive, copied it once and read it three times. The SHA-1
>> checksum is always the same and matches the original one on the hard disk.
>>
>> So after much testing I feel I can conclude that my USB flash drive is
>> not fake and it is not defective.
>>
> For what it's worth, there's multiple other things that could cause similar
> issues.  I've had a number of cases where bad USB hubs or poorly designed
> (or just buggy or failing) USB controllers caused similar data corruption,
> the most recent one being an issue with both a bad USB 2.0 hub (which did
> not properly implement the USB standard, counterfeit USB devices come in all
> types) and a malfunctioning USB 3.0 controller (which did not properly
> account for things that didn't properly implement the standard and had no
> recovery code to handle this in the drivers).  I ended up in most cases
> checking the ports using other USB devices (at least a keyboard, a mouse,
> and a USB serial adapter).

Similar as Austin, I also want to note that there might be USB related
issues that only pop-up after some time and not in tests.

For example, this weekend I connected a 2.5inch 500G drive with its
Y-cable to a H87M-Pro board that is fed by a 80+Gold PSU, despite its
many 'bad sectors' I remembered from 2 years ago in a btrfs raid1
setup. This 500G disk has worked well for almost 2 years connected to
a 7-inch eeepc4G, XFS formatted. But with the H87M-Pro I just now saw
that it dropped off the USB every now and then, causing trouble for
Btrfs.

For connecting harddisks to phones, I once bought an external powered
hub, and I put that between the board the the 500G disk => that made
it all stable, no disconnects and Btrfs works fine as expected. I had
similar issues on another PC with a Sandisk Extreme 64G USB3 stick,
but that was likely a protocol issue.

So maybe try to use the stick with your use case in another HW setup,
hopefully then it is stable for a longer time than the few days now.
