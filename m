Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:51761 "EHLO
        smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751869AbdGYCXJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 22:23:09 -0400
Date: Tue, 25 Jul 2017 05:22:57 +0300
In-Reply-To: <CAJCQCtTnShjzumppLPYWzc3nXfKoTads91dtfLk8UoQ3w4_P+Q@mail.gmail.com>
References: <1500895655.2781.6.camel@cloud.haefemeier.eu> <CAJCQCtT3nEaHox7jiO-jf6hCjpUSRz=AahrapgZDajJdeYr1Rw@mail.gmail.com> <aac851d3-4187-fc94-bdcb-e79b83b74da8@dirtcellar.net> <CAJCQCtTnShjzumppLPYWzc3nXfKoTads91dtfLk8UoQ3w4_P+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: Best Practice: Add new device to RAID1 pool
To: Chris Murphy <lists@colorremedies.com>, waxhead <waxhead@dirtcellar.net>
CC: Cloud Admin <admin@cloud.haefemeier.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <1A5C2685-62A7-4976-8345-B7F25E35B998@rqc.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> This may be a stupid question , but are your pool of butter (or BTRFS pool) 
>> by any chance hooked up via USB? If this is USB2.0 at 480mitb/s then it is 
>> about 57MB/s / 4 drives = roughly 14.25 or about 11MB/s if you shave off 
>> some overhead.
>
>Nope, USB 3. Typically on scrubs I get 110MB/s that winds down to 
>60MB/s as it progresses to the slow parts of the disk.

It could have degraded to USB2 due to bad connection/loose electrical contacts. You know USB3 needs extra wires, and if it lost some it'd connect (or reconnect) in USB2 mode. I'd check historical kernel messages just in case, and/or unmount and reconnect to be sure.
-- 

With Best Regards,
Marat Khalili
