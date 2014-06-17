Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:36318 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaFQBNZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 21:13:25 -0400
Received: by mail-ie0-f169.google.com with SMTP id at1so5883682iec.28
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jun 2014 18:13:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <lnnht8$f3j$1@ger.gmane.org>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost>
	<539BFF47.8060006@libero.it>
	<20140615221307.GE24386@tango.0pointer.de>
	<1709025.rRUgx5gMp1@xev>
	<20140616101448.GB18016@tango.0pointer.de>
	<539F15DC.4010600@fb.com>
	<lnnht8$f3j$1@ger.gmane.org>
Date: Mon, 16 Jun 2014 19:13:24 -0600
Message-ID: <CAE5mzvj6yA3FhZ-bpR29XLuuk8BbuOfW4HP9BKnxuuYN8L8_kw@mail.gmail.com>
Subject: Re: [systemd-devel] Slow startup of systemd-journal on BTRFS
From: cwillu <cwillu@cwillu.com>
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        systemd-devel@lists.freedesktop.org, clm@fb.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's not a mmap problem, it's a small writes with an msync or fsync
after each one problem.

For the case of sequential writes (via write or mmap), padding writes
to page boundaries would help, if the wasted space isn't an issue.
Another approach, again assuming all other writes are appends, would
be to periodically (but frequently enough that the pages are still in
cache) read a chunk of the file and write it back in-place, with or
without an fsync. On the other hand, if you can afford to lose some
logs on a crash, not fsyncing/msyncing after each write will also
eliminate the fragmentation.

(Worth pointing out that none of that is conjecture, I just spent 30
minutes testing those cases while composing this ;p)

Josef has mentioned in irc that a piece of Chris' raid5/6 work will
also fix this when it lands.

On Mon, Jun 16, 2014 at 1:52 PM, Martin <m_btrfs@ml1.co.uk> wrote:
> On 16/06/14 17:05, Josef Bacik wrote:
>>
>> On 06/16/2014 03:14 AM, Lennart Poettering wrote:
>>> On Mon, 16.06.14 10:17, Russell Coker (russell@coker.com.au) wrote:
>>>
>>>>> I am not really following though why this trips up btrfs though. I am
>>>>> not sure I understand why this breaks btrfs COW behaviour. I mean,
>
>>>> I don't believe that fallocate() makes any difference to
>>>> fragmentation on
>>>> BTRFS.  Blocks will be allocated when writes occur so regardless of an
>>>> fallocate() call the usage pattern in systemd-journald will cause
>>>> fragmentation.
>>>
>>> journald's write pattern looks something like this: append something to
>>> the end, make sure it is written, then update a few offsets stored at
>>> the beginning of the file to point to the newly appended data. This is
>>> of course not easy to handle for COW file systems. But then again, it's
>>> probably not too different from access patterns of other database or
>>> database-like engines...
>
> Even though this appears to be a problem case for btrfs/COW, is there a
> more favourable write/access sequence possible that is easily
> implemented that is favourable for both ext4-like fs /and/ COW fs?
>
> Database-like writing is known 'difficult' for filesystems: Can a data
> log can be a simpler case?
>
>
>> Was waiting for you to show up before I said anything since most systemd
>> related emails always devolve into how evil you are rather than what is
>> actually happening.
>
> Ouch! Hope you two know each other!! :-P :-)
>
>
> [...]
>> since we shouldn't be fragmenting this badly.
>>
>> Like I said what you guys are doing is fine, if btrfs falls on it's face
>> then its not your fault.  I'd just like an exact idea of when you guys
>> are fsync'ing so I can replicate in a smaller way.  Thanks,
>
> Good if COW can be so resilient. I have about 2GBytes of data logging
> files and I must defrag those as part of my backups to stop the system
> fragmenting to a stop (I use "cp -a" to defrag the files to a new area
> and restart the data software logger on that).
>
>
> Random thoughts:
>
> Would using a second small file just for the mmap-ed pointers help avoid
> repeated rewriting of random offsets in the log file causing excessive
> fragmentation?
>
> Align the data writes to 16kByte or 64kByte boundaries/chunks?
>
> Are mmap-ed files a similar problem to using a swap file and so should
> the same "btrfs file swap" code be used for both?
>
>
> Not looked over the code so all random guesses...
>
> Regards,
> Martin
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
