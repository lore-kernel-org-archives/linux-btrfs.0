Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:38020 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1757942AbdEVJpE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 May 2017 05:45:04 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dCjtY-00007s-F0
        for linux-btrfs@vger.kernel.org; Mon, 22 May 2017 11:44:56 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v2 2/2] Btrfs: compression must free at least PAGE_SIZE
Date: Mon, 22 May 2017 09:44:48 +0000 (UTC)
Message-ID: <pan$82fa9$cf229f14$ada082b4$d148da0c@cox.net>
References: <20170520164953.7344-1-nefelim4ag@gmail.com>
        <20170520164953.7344-3-nefelim4ag@gmail.com>
        <20170520191400.25202d75@jupiter.sol.kaishome.de>
        <CAGqmi76cLmXOj=P7qeR58n1aHNB-6e1R0yo+PjuMVLLgnWaryg@mail.gmail.com>
        <pan$42cee$29ae88fa$3ea3d443$c10a99e5@cox.net>
        <CAGqmi77_iaZC0f0BsGWVAzgZnNRvWTHkxvnP=risHa33NGPhGA@mail.gmail.com>
        <20170521223041.4aa7d0f6@natsu>
        <CAGqmi76reKuyeOmmkjqpJdekjySN8rkE332aC5A4BgD0WHnJUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Timofey Titovets posted on Mon, 22 May 2017 01:32:21 +0300 as excerpted:

> 2017-05-21 20:30 GMT+03:00 Roman Mamedov <rm@romanrm.net>:
>> On Sun, 21 May 2017 19:54:05 +0300 Timofey Titovets
>> <nefelim4ag@gmail.com> wrote:
>>
>>> Sorry, but i know about subpagesize-blocksize patch set, but i don't
>>> understand where you see conflict?
>>>
>>> Can you explain what you mean?
>>>
>>> By PAGE_SIZE i mean fs cluster size in my patch set.
>>
>> This appears to be exactly the conflict. Subpagesize blocksize patchset
>> would make it possible to use e.g. Btrfs with 4K block (cluster) size
>> on a MIPS machine with 64K-sized pages. Would your checking for
>> PAGE_SIZE still be correct then?
> 
> Nope

>> I guess Duncan's question was why not compare against block size from
>> the get go, rather than create more places for Chandan to scour through
>> to eliminate all "blocksize = pagesize" assumptions...

> - If I try to export sector size to compression code, [...]
>   it's convert small patch in a big patch series, and you know whats
> happens with big patch series...

Good point...

> - AFAIK in V21 subpage patch set compression on machines with 64KiB
> doesn't work as expected [1].
>   So, subpage patch series for compression code should reworked,
> doesn't matter will my patches merged or not.

I guess I'd just like to have Chandan's input here too.  It sounds like 
it shouldn't be too much more to deal with given the size and complexity 
of that set already, but just to know that he's aware of the it and that 
it's coordinated there so as not to just be making that journey 
unnecessarily harder than it is already.

[Not that I as a non-dev can really say anything, but it can't /hurt/ to 
already have his ack, when this gets reviewed by those whose decision 
/does/ count.]

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

