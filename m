Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:44169 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbdKMD3E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Nov 2017 22:29:04 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eE5QY-0004mo-Ne
        for linux-btrfs@vger.kernel.org; Mon, 13 Nov 2017 04:28:50 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-image hash collision option, super slow
Date: Mon, 13 Nov 2017 03:28:43 +0000 (UTC)
Message-ID: <pan$df360$39f930a0$8666bf35$41b193fc@cox.net>
References: <CAJCQCtTJXpoSExk7aVKCZKk5YCpV6V31zUpLgQSxa+k4V8+x+w@mail.gmail.com>
        <20171112004230.GJ27985@carfax.org.uk>
        <CAJCQCtR5oqOT2JdO_-gSgVCnBpYz_53eBOeF32G6+ZfX6RK7Kw@mail.gmail.com>
        <4bc2caf5-6f4c-4012-2bab-4daaa766d202@siedziba.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Piotr Pawłow posted on Sun, 12 Nov 2017 15:05:44 +0100 as excerpted:

>> The other part I'm not groking is that some filenames fail with:
>>
>> WARNING: cannot find a hash collision for 'Tool', generating garbage,
>> it won't match indexes
> 
> Unfortunately there are no CRC32 collisions for any file name having 4
> or less characters when you have to keep the same file name length, and
> there may be no collisions for longer file names when you limit the
> result to ASCII only.

Hmm...  Sounds reasonable, tho I hadn't thought/read of it before.  But 
now that I am...

What's the statistical collision spread as the number of characters 
increases?

More worrying than not having /any/ collisions might be having only one, 
or for that matter, some known small number less than say 1024, and 
certainly less than 64 or so, since for the only one collision 
possibility, once you know it wasn't the one you have, you know which one 
it actually was, and chances are, with a bit of information about the 
target in question, such as a suspected crime or the department at a 
competing company the filesystem was from, 64 or even something like 1024 
possibilities are trivial to look up in some rainbow table somewhere and 
see which possibilities look interesting.   Get a few of those and pretty 
soon you can start putting a story together.

So it might make sense to (at least have an option to, maybe -sss) force 
garbage for anything under say 6 chars or whatever, depending on how fast 
the number of collisions rise, to avoid the information leak due to too 
few collisions issue, particularly given that once we assume people 
consider it worth going to the trouble in the first place, they likely 
/are/ going to be concerned about such low number of collisions 
information leakage.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

