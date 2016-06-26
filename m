Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36176 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbcFZQn4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jun 2016 12:43:56 -0400
Received: by mail-oi0-f68.google.com with SMTP id x6so26653189oif.3
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jun 2016 09:43:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a291b1c0-fadf-da85-fc46-657884ec38bc@inwind.it>
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
 <CAJCQCtTXJhgKsmQGUXrppntYj8u6vk3jzP9Q4UMBomJ255QTQw@mail.gmail.com>
 <CAJCQCtSF3WTxOkrgdWL78DqxYf-kLzXr4vnKPLoe2mhURhqkOA@mail.gmail.com>
 <268f4f78-c277-43e9-a621-fc32d5fad172@inwind.it> <CAJCQCtRWfWXruAJTbCsh7dKc=2iRk6CHMOMTUBbh7JGH6SaXtA@mail.gmail.com>
 <a291b1c0-fadf-da85-fc46-657884ec38bc@inwind.it>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 26 Jun 2016 10:43:54 -0600
Message-ID: <CAJCQCtTMqHEjA0cvt_YbmB1eqRhtn+0Pbq6iMgxx0h0TNSYp2Q@mail.gmail.com>
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
To: kreijack@inwind.it
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 26, 2016 at 3:20 AM, Goffredo Baroncelli <kreijack@inwind.it> wrote:
> On 2016-06-26 00:33, Chris Murphy wrote:
>> On Sat, Jun 25, 2016 at 12:42 PM, Goffredo Baroncelli
>> <kreijack@inwind.it> wrote:
>>> On 2016-06-25 19:58, Chris Murphy wrote:
>>> [...]
>>>>> Wow. So it sees the data strip corruption, uses good parity on disk to
>>>>> fix it, writes the fix to disk, recomputes parity for some reason but
>>>>> does it wrongly, and then overwrites good parity with bad parity?
>>>>
>>>> The wrong parity, is it valid for the data strips that includes the
>>>> (intentionally) corrupt data?
>>>>
>>>> Can parity computation happen before the csum check? Where sometimes you get:
>>>>
>>>> read data strips > computer parity > check csum fails > read good
>>>> parity from disk > fix up the bad data chunk > write wrong parity
>>>> (based on wrong data)?
>>>>
>>>> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/fs/btrfs/raid56.c?id=refs/tags/v4.6.3
>>>>
>>>> 2371-2383 suggest that there's a parity check, it's not always being
>>>> rewritten to disk if it's already correct. But it doesn't know it's
>>>> not correct, it thinks it's wrong so writes out the wrongly computed
>>>> parity?
>>>
>>> The parity is not valid for both the corrected data and the corrupted data. It seems that the scrub process copy the contents of the disk2 to disk3. It could happens only if the contents of disk1 is zero.
>>
>> I'm not sure what it takes to hit this exactly. I just tested 3x
>> raid5, where two files 128KiB "a" and 128KiB "b", so that's a full
>> stripe write for each. I corrupted devid 1 64KiB of "a" and devid2
>> 64KiB of "b" did a scrub, error is detected, and corrected, and parity
>> is still correct.
>
> How many time tried this corruption test ? I was unable to raise the bug systematically; in average every three tests I got 1 bug....

Once.

I just did it a 2nd time and both file's parity are wrong now. So I
did it several more times. Sometimes both files' parity is bad.
Sometimes just one file's parity is bad. Sometimes neither file's
parity is bad.

It's a very bad bug, because it is a form of silent data corruption
and it's induced by Btrfs. And it's apparently non-deterministically
hit. Is this some form of race condition?

Somewhat orthogonal to this, is that while Btrfs is subject to the
write hole problem where parity can be wrong, this is detected and
warned. Bad data doesn't propagate up to user space.

This might explain how users are getting hit with corrupt files only
after they have a degraded volume. They did a scrub where some fixups
happen, but behind the scene possibly parity was corrupted even though
their data was fixed. Later they have a failed device, and the bad
parity is needed, and now there are a bunch of scary checksum errors
with piles of files listed as unrecoverable. And in fact they are
unrecoverable because the bad parity means bad reconstruction, so even
scraping it off with btrfs restore won't work.


-- 
Chris Murphy
