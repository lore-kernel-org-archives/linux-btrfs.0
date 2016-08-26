Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:34662 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbcHZL7W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Aug 2016 07:59:22 -0400
Received: by mail-it0-f50.google.com with SMTP id e63so3224195ith.1
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Aug 2016 04:58:25 -0700 (PDT)
Subject: Re: Switch raid mode without rebalance?
To: Gert Menke <gert@menke.ac>, Justin Kilpatrick <jkilpatr@redhat.com>
References: <efe09b37f04cbc7754f6c6d84c9070f0@durkon.lan>
 <CANhjow-uihWAQ-MREsT9oAHWoFSHgqi=bXJwV8FJOStyMpC6sw@mail.gmail.com>
 <0981faee57e9de5b29a7150dc89c4092@durkon.lan>
Cc: linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <456dc4ab-f6ae-48d6-94d6-782e56e284e0@gmail.com>
Date: Fri, 26 Aug 2016 07:52:57 -0400
MIME-Version: 1.0
In-Reply-To: <0981faee57e9de5b29a7150dc89c4092@durkon.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-25 18:32, Gert Menke wrote:
> Hi,
>
> On 2016-08-25 20:26, Justin Kilpatrick wrote:
>
>> I'm not sure why you want to avoid a balance,
> I didn't check, but I imagined it would slow down my rsync significantly.
It will slow it down, but I can't tell you exactly how much (there are 
too many variables to give a good answer in this case).
>
>> Once you start this command all the new data should follow the new rules.
> Ah, now that's interesting.
> When the balance is running, df shows 4TB free space; when I cancel the
> balance, the free space goes back to a few 100GB.
Regular 'df' isn't to be trusted when dealing with BTRFS, the only 
reason we report anything there is because many things break horribly if 
we don't.
>
> But if the balancing only happens when the disk would otherwise be idle,
> and the mere fact that there is a balance process running will cause the
> new data to be written in single mode, I'm all set. I would not even
> have to wait for the balance to finish after the rsync is done; I could
> just cancel it and unmount the disks. A bit hacky, but in this case
> totally acceptable.
The balancing operation runs in the foreground (unless you daemonize it 
in a new enough btrfs-progs), it isn't restricted to just using idle 
time, and as explained by Chris Murphy in the other branch of this 
thread, it's not flipping some binary switch telling the FS to write all 
new data in the new profile.

Additionally, while running with multiple profiles while not balancing 
should work, it's pretty much untested, and any number of things may 
break.  Assuming your two disks have similar latency and transfer speed, 
you're almost certainly better off just converting completely to single 
mode (which works like raid0, just at the chunk level instead of the 
block level).  Doing so will likely have near zero impact on 
performance, will also be easier to recover data from if one disk dies, 
and will avoid the mostly untested situation of running with multiple 
chunk profiles.

On a slightly separate note, if your doing backups more frequently than 
once a week, your probably better off just leaving the disks connected 
and running.  Regular load/unload cycles are generally harder on the 
mechanical components in modern disks than just leaving them running 24/7.
