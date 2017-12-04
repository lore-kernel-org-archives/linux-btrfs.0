Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:39061 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753907AbdLDOaJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Dec 2017 09:30:09 -0500
Received: by mail-it0-f53.google.com with SMTP id 68so7009935ite.4
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Dec 2017 06:30:09 -0800 (PST)
Received: from [191.9.212.201] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id m31sm3929570iti.3.2017.12.04.06.30.06
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Dec 2017 06:30:06 -0800 (PST)
Subject: Re: btrfs-transacti hammering the system
To: linux-btrfs@vger.kernel.org
References: <bb2cfbcb-31dd-715c-114f-59d574a2012b@techsquare.com>
 <9703c200-28af-f26d-b3b2-6982fb289ac8@mendix.com>
 <1d11e03c-7d02-3f66-8b97-4c1b857566fa@techsquare.com>
 <b52265f9-2703-7f25-b1b9-6e84bc7db62e@mendix.com>
 <c9e5ef0a-e60b-b892-272c-1594d47f0657@techsquare.com>
 <5ecddad2-bb6a-2991-c8d0-be97a4541b0d@mendix.com>
 <pan$6609d$15863533$48f08c08$b3eb21f1@cox.net>
 <113cba02-2557-d1e8-193f-fab4437f1199@techsquare.com>
 <96e81cad-1024-aa9e-c3fe-d884a710b130@gmail.com>
 <pan$72fcb$25444603$d7f3231e$e556c8d5@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <2974d0e0-0a43-3c6b-4414-b828c8480d0a@gmail.com>
Date: Mon, 4 Dec 2017 09:30:05 -0500
MIME-Version: 1.0
In-Reply-To: <pan$72fcb$25444603$d7f3231e$e556c8d5@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-12-04 09:10, Duncan wrote:
> Austin S. Hemmelgarn posted on Mon, 04 Dec 2017 07:18:11 -0500 as
> excerpted:
> 
>> On 2017-12-01 16:50, Matt McKinnon wrote:
>>> Well, it's at zero now...
>>>
>>> # btrfs fi df /export/
>>> Data, single: total=30.45TiB, used=30.25TiB
>>> System, DUP: total=32.00MiB, used=3.62MiB
>>> Metadata, DUP: total=66.50GiB, used=65.16GiB
>>> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
>> GlobalReserve seems to be used temporarily for certain cases of metadata
>> COW regardless of how full the FS actually is, I'm betting that it just so
>> happened that such a case was in progress when you got the info
>> previously.  If you aren't seeing it regularly used, it's (probably) not
>> an issue.
>>
>> Duncan is correct though when dealing with long-term usage.  If you see
>> GlobalReserve usage that persists for an extended period of time,
>> something is almost certainly wrong, especially if the FS isn't close to
>> being full.
> 
> Thanks.  I wasn't aware global reserve was routinely temporarily used.
> 
I don't know that it's 'routinely' used, but I've seen it used 
temporarily during balance and defrag runs, and on rare occasion when 
snapshotting very subvolumes.

I'm pretty certain that all those cases are not 'supposed' to happen, 
they just do as a consequence of how the code is written.
