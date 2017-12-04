Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:43080 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751980AbdLDOKi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Dec 2017 09:10:38 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eLrRw-0001gW-Ko
        for linux-btrfs@vger.kernel.org; Mon, 04 Dec 2017 15:10:24 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-transacti hammering the system
Date: Mon, 4 Dec 2017 14:10:05 +0000 (UTC)
Message-ID: <pan$72fcb$25444603$d7f3231e$e556c8d5@cox.net>
References: <bb2cfbcb-31dd-715c-114f-59d574a2012b@techsquare.com>
        <9703c200-28af-f26d-b3b2-6982fb289ac8@mendix.com>
        <1d11e03c-7d02-3f66-8b97-4c1b857566fa@techsquare.com>
        <b52265f9-2703-7f25-b1b9-6e84bc7db62e@mendix.com>
        <c9e5ef0a-e60b-b892-272c-1594d47f0657@techsquare.com>
        <5ecddad2-bb6a-2991-c8d0-be97a4541b0d@mendix.com>
        <pan$6609d$15863533$48f08c08$b3eb21f1@cox.net>
        <113cba02-2557-d1e8-193f-fab4437f1199@techsquare.com>
        <96e81cad-1024-aa9e-c3fe-d884a710b130@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Mon, 04 Dec 2017 07:18:11 -0500 as
excerpted:

> On 2017-12-01 16:50, Matt McKinnon wrote:
>> Well, it's at zero now...
>> 
>> # btrfs fi df /export/
>> Data, single: total=30.45TiB, used=30.25TiB
>> System, DUP: total=32.00MiB, used=3.62MiB
>> Metadata, DUP: total=66.50GiB, used=65.16GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B

> GlobalReserve seems to be used temporarily for certain cases of metadata
> COW regardless of how full the FS actually is, I'm betting that it just so
> happened that such a case was in progress when you got the info
> previously.  If you aren't seeing it regularly used, it's (probably) not
> an issue.
> 
> Duncan is correct though when dealing with long-term usage.  If you see
> GlobalReserve usage that persists for an extended period of time,
> something is almost certainly wrong, especially if the FS isn't close to
> being full.

Thanks.  I wasn't aware global reserve was routinely temporarily used.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

