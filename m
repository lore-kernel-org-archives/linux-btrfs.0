Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35473 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757812AbdJMBm5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 21:42:57 -0400
Message-Id: <1507858974.1236555.1137202920.267B449B@webmail.messagingengine.com>
From: Kai Hendry <hendry@iki.fi>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
References: <1507456690.745489.1131538472.25270157@webmail.messagingengine.com>
 <CAJCQCtRnbz5WGqZEO3b8a+3B2gDbG_zioqWEVoJz_dD0SB=6Ww@mail.gmail.com>
 <0a3e71f7-1a8e-9a4f-7470-4c5cc2fb11a0@gmail.com>
Date: Fri, 13 Oct 2017 09:42:54 +0800
Subject: Re: USB upgrade fun
In-Reply-To: <0a3e71f7-1a8e-9a4f-7470-4c5cc2fb11a0@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you Austin & Chris for your replies!

On Fri, 13 Oct 2017, at 01:19 AM, Austin S. Hemmelgarn wrote:
> Same here on a pair of 3 year old NUC's.  Based on the traces and the 
> other information, I'd be willing to bet this is probably the root cause 
> of the issues.

It probably is... since when I remove my new 4TB USB disk from the
front, I am at least able to mount my two 2x2TB in degraded mode and see
my data!

So I am not quite sure what to do now. 
I don't trust USB hubs. 

On a different NUC I've noticed I can't charge my iPhone anymore!
https://mail-archive.com/linux-usb@vger.kernel.org/msg95231.html So...
is there any end in sight for the "USB power" problem? Does USB-C /
Thunderbolt address this issue? :(

Try return my new 4TB to Amazon and find an externally powered one


> > merely the Btrfs signature is wiped from the deleted device(s). So you
> > could restore that signature and the device would be valid again;

Wonder how would you do that, in order to have a working snapshot that I
can put in cold storage?

Nonetheless I hope the btrfs developers can make it possible to remove a
RAID1 drive, to put in cold storage use case, without any pfaffing.

I ran that debug info: https://s.natalian.org/2017-10-13/btrfs-reply.txt
To summarise:
* sdb - new 4TB disk that makes my raid1 unmountable atm when connected
* sd{c,d} - old 2tb

Here's the accompanying dmesg.txt
https://s.natalian.org/2017-10-13/dmesg.txt sorry, it might be difficult
to follow since I was moving the 4TB between the front ports and such.

Kind regards,


