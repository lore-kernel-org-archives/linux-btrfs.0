Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:56149 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751587AbeEBXej (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 May 2018 19:34:39 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fE1EY-0006Xr-ML
        for linux-btrfs@vger.kernel.org; Thu, 03 May 2018 01:32:26 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID56 - 6 parity raid
Date: Wed, 2 May 2018 23:32:20 +0000 (UTC)
Message-ID: <pan$8e6d9$374a25c9$565659d8$ffe562b1@cox.net>
References: <CAJH6TXi96F=kwZS4imACiOrkeoHz2LVjPpi2W0fWw781Fba3hA@mail.gmail.com>
        <pan$13d50$86fb3347$db26ba71$62968586@cox.net>
        <0931730f-be41-e63b-f7f9-85fd111d0470@libero.it>
        <bf58f92b-4d38-91dc-e515-eef5ab969dde@dirtcellar.net>
        <66dceb8e-7a43-10cc-2ec6-e477a55b4deb@inwind.it>
        <99e79113-39ac-e67e-ff22-bfcfcdac00bc@gmail.com>
        <432bd25d-b823-9661-a408-11864df43425@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli posted on Wed, 02 May 2018 22:40:27 +0200 as
excerpted:

> Anyway, my "rant" started when Ducan put near the missing of parity
> checksum and the write hole. The first might be a performance problem.
> Instead the write hole could lead to a loosing data. My intention was to
> highlight that the parity-checksum is not related to the reliability and
> safety of raid5/6.

Thanks for making that point... and to everyone else for the vigorous 
thread debating it, as I'm learning quite a lot! =:^)

>From your first reply:

>> Why the fact that the parity is not checksummed is a problem ?
>> I read several times that this is a problem. However each time the
>> thread reached the conclusion that... it is not a problem.

I must have missed those threads, or at least, missed that conclusion 
from them (maybe believing they were about something rather narrower, or 
conflating... for instance), because AFAICT, this is the first time I've 
seen the practical merits of checksummed parity actually debated, at 
least in terms I as a non-dev can reasonably understand.  To my mind it 
was settled (or I'd have worded my original claim rather differently) and 
only now am I learning different.

And... to my credit... given the healthy vigor of the debate, it seems 
I'm not the only one that missed them...

But I'm surely learning of it now, and indeed, I had somewhat conflated 
parity-checksumming with the in-place-stripe-read-modify-write atomicity 
issue.  I'll leave the parity-checksumming debate (now that I know it at 
least remains debatable) to those more knowledgeable than myself, but in 
addition to what I've learned of it, I've definitely learned that I can't 
properly conflate it with the in-place stripe-rmw atomicity issue, so 
thanks!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

