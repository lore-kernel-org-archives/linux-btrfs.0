Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:44607 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757449AbdJMLWb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 07:22:31 -0400
Received: by mail-io0-f179.google.com with SMTP id m16so8626340iod.1
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Oct 2017 04:22:31 -0700 (PDT)
Subject: Re: USB upgrade fun
To: Kai Hendry <hendry@iki.fi>, Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1507456690.745489.1131538472.25270157@webmail.messagingengine.com>
 <CAJCQCtRnbz5WGqZEO3b8a+3B2gDbG_zioqWEVoJz_dD0SB=6Ww@mail.gmail.com>
 <0a3e71f7-1a8e-9a4f-7470-4c5cc2fb11a0@gmail.com>
 <1507858974.1236555.1137202920.267B449B@webmail.messagingengine.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d8ef3dde-553e-d8b5-6d8f-8a6e4929d739@gmail.com>
Date: Fri, 13 Oct 2017 07:22:28 -0400
MIME-Version: 1.0
In-Reply-To: <1507858974.1236555.1137202920.267B449B@webmail.messagingengine.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-12 21:42, Kai Hendry wrote:
> Thank you Austin & Chris for your replies!
> 
> On Fri, 13 Oct 2017, at 01:19 AM, Austin S. Hemmelgarn wrote:
>> Same here on a pair of 3 year old NUC's.  Based on the traces and the
>> other information, I'd be willing to bet this is probably the root cause
>> of the issues.
> 
> It probably is... since when I remove my new 4TB USB disk from the
> front, I am at least able to mount my two 2x2TB in degraded mode and see
> my data!
Given this, I think I know exactly what's wrong (although confirmation 
from a developer that what I think is going on can actually happen would 
be nice).  Based on what you're saying, the metadata on the two 2TB 
drives says they're the only ones in the array, while the metadata on 
the 4TB drive says all three are in the array, but is missing almost all 
other data and is out of sync with the 2TB drives.
> 
> So I am not quite sure what to do now.
> I don't trust USB hubs.
Yeah, I don't trust USB in general for permanently attached storage. 
Not just because of power problems like this, but because all kinds of 
things can cause random disconnects, which in turn cause issues with any 
filesystem (BTRFS just makes it easier to notice them).
> 
> On a different NUC I've noticed I can't charge my iPhone anymore!
> https://mail-archive.com/linux-usb@vger.kernel.org/msg95231.html So...
> is there any end in sight for the "USB power" problem? Does USB-C /
> Thunderbolt address this issue? :(
In theory, yes, but I'm not sure if the NUC's that include it properly 
support the USB Power Delivery specification (if not, then they can't 
safely source more than 500mA, which is too little for a traditional 
hard drive).
> 
> Try return my new 4TB to Amazon and find an externally powered one
> 
>>> merely the Btrfs signature is wiped from the deleted device(s). So you
>>> could restore that signature and the device would be valid again;
> 
> Wonder how would you do that, in order to have a working snapshot that I
> can put in cold storage?
In practice, it's too much work to be practical.  It requires rebuilding 
the metadata tree from scratch, which is pretty much impossible with the 
current tools (and even then you likely wouldn't have all the data, 
because some may have been overwritten during the device removal).
> 
> Nonetheless I hope the btrfs developers can make it possible to remove a
> RAID1 drive, to put in cold storage use case, without any pfaffing.
 From a practical perspective, you're almost certainly better off 
creating a copy for cold storage without involving BTRFS.  As an 
alternative, I would suggest one of the following approaches:

1. Take a snapshot of the filesystem, and use send/receive to transfer 
that to another device which you then remove and store somewhere.
2. Use rsync to copy things to another device which you then remove and 
store somewhere.

Both these options are safer, less likely to screw up your existing 
filesystem, and produce copies that can safely be connected to the 
original system at the same time as the original filesystem.
