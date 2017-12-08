Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:46138 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751904AbdLHCSP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Dec 2017 21:18:15 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eN8Em-0001o0-7c
        for linux-btrfs@vger.kernel.org; Fri, 08 Dec 2017 03:18:04 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v5 0/3] Add cli and ioctl to deregister devices
Date: Fri, 8 Dec 2017 02:17:57 +0000 (UTC)
Message-ID: <pan$e67bd$548c1a2e$2d7222f9$63f69c71@cox.net>
References: <20171207143623.26710-1-anand.jain@oracle.com>
        <2ff368d4-a38a-59c9-565a-8c55702217ae@gmail.com>
        <2eb9cb20-e972-f642-d116-2d7dc4417fe8@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anand Jain posted on Fri, 08 Dec 2017 08:51:43 +0800 as excerpted:

> On 12/07/2017 10:52 PM, Austin S. Hemmelgarn wrote:
>> On 2017-12-07 09:36, Anand Jain wrote:
>>> Add ability to deregister a or all devices. I have named this sub cmd
>>> as deregister, but I am open to your suggestions.
>> Being a bit picky here, but from the perspective of a native speaker of
>> American English, I would say that 'deregister' sounds rather synthetic
>> and somewhat harsh and alien.
>> 
>> Given that, as odd as it sounds, I think 'ignore' might be a more user
>> friendly name for the sub-command.  It accurately describes what the
>> command is doing (telling the kernel to ignore the device), and it's a
>> lot less alien sounding than 'deregister'.
>> 
>> If you're set on having it be based on the word 'register', I would
>> suggest changing it to 'unregister', as I think that sounds more
>> natural than 'deregister'.
>> 
>> Additionally, if you do continue with 'deregister' or go with
>> 'unregister' as the name though, I would suggest adding 'register' as a
>> synonym for the 'scan' sub-command to keep things reasonably
>> symmetrical.
> 
>   A look up on unregister lead me to use deregister as more appropriate.
>   Anyway I won't bother much, I will be go be suggestions, and how about
>   unscan, since scan is already there. OR how about purge.

This is a bikeshed I think I have a beautiful color suggestion for! =:^)

Seriously, the normal purpose of scanning is to record particular details 
of what was seen during the scan, based on some desired scanning criteria.

So what do you call it when you need to "forget" the information you 
scanned for?

What about simply "forget", btrfs device forget ?  That sounds the most 
natural to me, certainly far more so than the apparently freshly created 
word "unscan", tho that would certainly deliver the meaning.

And FWIW, "deregister", just.. no.  (I too would vote unregister if we're 
sticking with the register root-word, but I have a feeling that may be a 
regional/en-US preference and some other English regional variants may 
find deregister is the less terrible to their ear.  That may explain 
whatever commentary under unregister led you to go with deregister.)  
"Deregister" sounds like something a computer programmer might say to 
describe the process, but I can't imagine a "normal" person using the 
word, except possibly in the context of removing someone from the voter 
rolls (where one "registers" to vote, so "deregister" could be a a 
reasonably natural term for reversing that) or the like.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

