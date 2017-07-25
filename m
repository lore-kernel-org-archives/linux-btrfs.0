Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36810 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750824AbdGYINK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 04:13:10 -0400
Received: by mail-wm0-f44.google.com with SMTP id t201so38643758wmt.1
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Jul 2017 01:13:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1A5C2685-62A7-4976-8345-B7F25E35B998@rqc.ru>
References: <1500895655.2781.6.camel@cloud.haefemeier.eu> <CAJCQCtT3nEaHox7jiO-jf6hCjpUSRz=AahrapgZDajJdeYr1Rw@mail.gmail.com>
 <aac851d3-4187-fc94-bdcb-e79b83b74da8@dirtcellar.net> <CAJCQCtTnShjzumppLPYWzc3nXfKoTads91dtfLk8UoQ3w4_P+Q@mail.gmail.com>
 <1A5C2685-62A7-4976-8345-B7F25E35B998@rqc.ru>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 25 Jul 2017 02:13:08 -0600
Message-ID: <CAJCQCtRkqPf2BHnynLeyOEkjV+9fVYdZ_xCHfQ2AxyhdGpD2ag@mail.gmail.com>
Subject: Re: Best Practice: Add new device to RAID1 pool
To: Marat Khalili <mkh@rqc.ru>
Cc: Chris Murphy <lists@colorremedies.com>, waxhead <waxhead@dirtcellar.net>,
        Cloud Admin <admin@cloud.haefemeier.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 24, 2017 at 8:22 PM, Marat Khalili <mkh@rqc.ru> wrote:
>>> This may be a stupid question , but are your pool of butter (or BTRFS pool)
>>> by any chance hooked up via USB? If this is USB2.0 at 480mitb/s then it is
>>> about 57MB/s / 4 drives = roughly 14.25 or about 11MB/s if you shave off
>>> some overhead.
>>
>>Nope, USB 3. Typically on scrubs I get 110MB/s that winds down to
>>60MB/s as it progresses to the slow parts of the disk.
>
> It could have degraded to USB2 due to bad connection/loose electrical contacts. You know USB3 needs extra wires, and if it lost some it'd connect (or reconnect) in USB2 mode. I'd check historical kernel messages just in case, and/or unmount and reconnect to be sure.

Actually I'm wrong, the device I was testing for this thread is SATA.
What confused me is the thread is about raid1 and my Btrfs raid1 is
USB 3. But anyway all devices scrub at 100+MB/s but balance is much
slower than even 1/2.


-- 
Chris Murphy
