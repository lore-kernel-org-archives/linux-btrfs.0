Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:42629 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753385AbdLHNJn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Dec 2017 08:09:43 -0500
Received: by mail-it0-f67.google.com with SMTP id p139so4737211itb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Dec 2017 05:09:42 -0800 (PST)
Received: from [191.9.212.201] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id l34sm3570585ioi.16.2017.12.08.05.09.40
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Dec 2017 05:09:40 -0800 (PST)
Subject: Re: [PATCH v5 0/3] Add cli and ioctl to deregister devices
To: linux-btrfs@vger.kernel.org
References: <20171207143623.26710-1-anand.jain@oracle.com>
 <2ff368d4-a38a-59c9-565a-8c55702217ae@gmail.com>
 <2eb9cb20-e972-f642-d116-2d7dc4417fe8@oracle.com>
 <pan$e67bd$548c1a2e$2d7222f9$63f69c71@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <66dbfd9a-08a4-0c1f-ce10-e085ed99e712@gmail.com>
Date: Fri, 8 Dec 2017 08:09:39 -0500
MIME-Version: 1.0
In-Reply-To: <pan$e67bd$548c1a2e$2d7222f9$63f69c71@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-12-07 21:17, Duncan wrote:
> Anand Jain posted on Fri, 08 Dec 2017 08:51:43 +0800 as excerpted:
> 
>> On 12/07/2017 10:52 PM, Austin S. Hemmelgarn wrote:
>>> On 2017-12-07 09:36, Anand Jain wrote:
>>>> Add ability to deregister a or all devices. I have named this sub cmd
>>>> as deregister, but I am open to your suggestions.
>>> Being a bit picky here, but from the perspective of a native speaker of
>>> American English, I would say that 'deregister' sounds rather synthetic
>>> and somewhat harsh and alien.
>>>
>>> Given that, as odd as it sounds, I think 'ignore' might be a more user
>>> friendly name for the sub-command.  It accurately describes what the
>>> command is doing (telling the kernel to ignore the device), and it's a
>>> lot less alien sounding than 'deregister'.
>>>
>>> If you're set on having it be based on the word 'register', I would
>>> suggest changing it to 'unregister', as I think that sounds more
>>> natural than 'deregister'.
>>>
>>> Additionally, if you do continue with 'deregister' or go with
>>> 'unregister' as the name though, I would suggest adding 'register' as a
>>> synonym for the 'scan' sub-command to keep things reasonably
>>> symmetrical.
>>
>>    A look up on unregister lead me to use deregister as more appropriate.
>>    Anyway I won't bother much, I will be go be suggestions, and how about
>>    unscan, since scan is already there. OR how about purge.
> 
> This is a bikeshed I think I have a beautiful color suggestion for! =:^)
> 
> Seriously, the normal purpose of scanning is to record particular details
> of what was seen during the scan, based on some desired scanning criteria.
> 
> So what do you call it when you need to "forget" the information you
> scanned for?
> 
> What about simply "forget", btrfs device forget ?  That sounds the most
> natural to me, certainly far more so than the apparently freshly created
> word "unscan", tho that would certainly deliver the meaning.
I actually like forget even better than ignore, it's more descriptive 
and a bit more obvious.  'purge' might make sense if you're always 
dumping the entire list, but sounds very absolute and dangerous (and 
almost universally has a very negative connotation).
> 
> And FWIW, "deregister", just.. no.  (I too would vote unregister if we're
> sticking with the register root-word, but I have a feeling that may be a
> regional/en-US preference and some other English regional variants may
> find deregister is the less terrible to their ear.  That may explain
> whatever commentary under unregister led you to go with deregister.)
> "Deregister" sounds like something a computer programmer might say to
> describe the process, but I can't imagine a "normal" person using the
> word, except possibly in the context of removing someone from the voter
> rolls (where one "registers" to vote, so "deregister" could be a a
> reasonably natural term for reversing that) or the like.
Actually, in that case it's usually 'unregister' as well, at least in 
American English.  'deregister' is indeed largely a programming term, 
but even then it's not unusual for people to just use 'unregister' (the 
distinction that I usually use myself is that 'unregister' refers to a 
voluntary process initiated by the entity that initially registered 
whatever it was (which is the common case, and technically what this 
is), whereas 'deregister' is usually an involuntary process triggered by 
a third party (which is rare outside of things like forced kernel module 
removal or crashes)).  It's probably worth noting that both uses are 
uncommon enough that the standard American English dictionaries in 
Thunderbird and aspell lack both words (though Thunderbird does have 
'unregistered').

As far as regional variance, I've checked with a couple of friends from 
Australia, Canada, Denmark, and the UK, and all of them also felt that 
'deregister' sounded less natural than 'unregister'.  The reality is 
that pretty much regardless of the particular regional dialect, usage 
patterns for a given negation prefix tend to be reasonably consistent, 
namely:
* de- is usually used in technical verbs and not much else (desensitize, 
desaturate, deauthorize, delineate, etc)
* un- is usually used in generic terms, including verbs, adverbs, and 
adjectives, and is often the most common choice for creating 'new' words 
by negating an existing verb, adverb, or adjective (unknown, unsightly, 
unfriendly, etc)
* anti- is used exclusively for negating nouns, traditionally for 
concepts, but more recently for any noun (antithesis, antimatter, 
antidisestablishmentarianism, etc)
* dis- is used for a handful of very specific cases usually referring to 
behavior or personality, and sometimes culture (dishonest, disingenuous, 
etc)
* non- is used almost exclusively for adjectives and adverbs, but is 
less frequent than un- (nonsensical, nonplussed, etc)
* il- rarely used, typically only used for negating something describing 
the state of an action, and almost exclusively with words that begin 
with 'l', sometimes extended to ill to add a negative connotation to an 
existing word (illogical, illegal, etc).
