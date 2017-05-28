Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:48506 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbdE1Dy0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 May 2017 23:54:26 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dEpHX-0007Vu-AL
        for linux-btrfs@vger.kernel.org; Sun, 28 May 2017 05:54:19 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: About free space fragmentation, metadata write amplification and
 (no)ssd
Date: Sun, 28 May 2017 03:54:13 +0000 (UTC)
Message-ID: <pan$190df$2ad31a2b$6071471$3fd0fb2c@cox.net>
References: <5e11b988-05ea-c468-21ef-589c71058436@mendix.com>
        <d5ebd421-52a1-5b91-72a3-f97a2fb9628f@mendix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hans van Kranenburg posted on Sun, 28 May 2017 02:59:57 +0200 as
excerpted:

>> Note that our metadata is still DUP, and it doesn't have skinny extent
>> tree metadata yet. It was originally created with btrfs-progs 3.17, and
>> when we realized we should have single it was too late. I want to
>> change that and see if I can convert on a NetApp clone. This should
>> reduce extent tree metadata size by maybe more than 60% and
>> whoknowswhat will happen to the abhorrent write traffic.
> 
> Yeah, blabla... Converting metadata from DUP to single is a big no go
> with btrfs balance, that's what I clearly got figured out now.

Umm... Did you try -f (force)?  See the manpage.

OTOH, I'd have thought that was obvious enough you'd have tried it which 
would make the problem here something not so simple, but then again, I'd 
have thought you'd mention trying it too, if you did, to prevent exactly 
this sort of followup.  So I don't know what to think, except I think 
it's worth covering the possibility just in case.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

