Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:48339 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751975AbdKHT3y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Nov 2017 14:29:54 -0500
Received: by mail-it0-f44.google.com with SMTP id c3so8232796itc.3
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Nov 2017 11:29:53 -0800 (PST)
Subject: Re: Problem with file system
To: Chris Murphy <lists@colorremedies.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <CAJyZh6RxKuMukM-vCd=_u_8y38MJO_oUG1nYFpaxBroeK8xpAQ@mail.gmail.com>
 <CAH=dxU4OV6tQ0hCy_0Ug7eqkOM7HTUWTKjAr4qg+uO2gVxk2Jw@mail.gmail.com>
 <CAJCQCtS9BPZn-hnS+wP7Eu3oHQP_tS8EEM4j4FQDwRmzcFH+_A@mail.gmail.com>
 <CAH=dxU4MOWGZ0JSZ-ZV004p5EnH_aOnZ7XEo2rSOmbXJZJmwBA@mail.gmail.com>
 <CAJCQCtTOefBfRpfb0h1H6SQxzGd9j-7ZSM07iA37xhy3+Lm=fw@mail.gmail.com>
 <CAH=dxU61J94HCnr+UUokBsxqNMjKQBdz8xE2WNbWAHOtKP4w0w@mail.gmail.com>
 <2164b4b2-1447-3670-73ae-465404754b87@gmail.com>
 <CAJCQCtQk4tZ7hVD-1T+TiFKQ9uX5eyBJvwkJoZ+Sxpo=gq3tHQ@mail.gmail.com>
 <e590a036-f5ba-d8d5-7b7f-c14e15b0b5ee@gmail.com>
 <CAJCQCtRq783s=KgF6XPySva=OvhgLDfmsP_VFCtygmhe2Pr-tg@mail.gmail.com>
 <20171108172217.GH27985@carfax.org.uk>
 <CAJCQCtSPe7cc_48Fhyhyd6zEmcvW41SGXddkGVOP-Z2sHLfRdA@mail.gmail.com>
 <ff4dc32d-bc9e-d1ee-5acb-938d204d4d4a@gmail.com>
 <CAJCQCtRnPX9Y1en606O2pmGeqPoW0jPW1QKUBtMMjf2Qx3H=MQ@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <1b8ce6db-b048-8758-0e98-85aa337a581d@gmail.com>
Date: Wed, 8 Nov 2017 14:29:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRnPX9Y1en606O2pmGeqPoW0jPW1QKUBtMMjf2Qx3H=MQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-08 13:31, Chris Murphy wrote:
> On Wed, Nov 8, 2017 at 11:10 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2017-11-08 12:54, Chris Murphy wrote:
>>>
>>> On Wed, Nov 8, 2017 at 10:22 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>>>
>>>> On Wed, Nov 08, 2017 at 10:17:28AM -0700, Chris Murphy wrote:
>>>>>
>>>>> On Wed, Nov 8, 2017 at 5:13 AM, Austin S. Hemmelgarn
>>>>> <ahferroin7@gmail.com> wrote:
>>>>>
>>>>>>> It definitely does fix ups during normal operations. During reads, if
>>>>>>> there's a UNC or there's corruption detected, Btrfs gets the good
>>>>>>> copy, and does a (I think it's an overwrite, not COW) fixup. Fixups
>>>>>>> don't just happen with scrubbing. Even raid56 supports these kinds of
>>>>>>> passive fixups back to disk.
>>>>>>
>>>>>>
>>>>>> I could have sworn it didn't rewrite the data on-disk during normal
>>>>>> usage.
>>>>>> I mean, I know for certain that it will return the correct data to
>>>>>> userspace
>>>>>> if at all possible, but I was under the impression it will just log the
>>>>>> error during normal operation.
>>>>>
>>>>>
>>>>> No, everything except raid56 has had it since a long time, I can't
>>>>> even think how far back, maybe even before 3.0. Whereas raid56 got it
>>>>> in 4.12.
>>>>
>>>>
>>>>      Yes, I'm pretty sure it's been like that ever since I've been using
>>>> btrfs (somewhere around the early neolithic).
>>>>
>>>
>>> Yeah, around the original code for multiple devices I think. Anyway,
>>> this is what the fixups look like between scrub and normal read on
>>> raid1. Hilariously the error reporting is radically different.
>>>
>>> This is kernel messages of what a scrub finding data file corruption
>>> detection and repair looks like. This was 5120 bytes corrupted so all
>>> of one block and partial of anther.
>>>
>>>
>>> [244964.589522] BTRFS warning (device dm-6): checksum error at logical
>>> 1103626240 on dev /dev/mapper/vg-2, sector 2116608, root 5, inode 257,
>>> offset 0, length 4096, links 1 (path: test.bin)
>>> [244964.589685] BTRFS error (device dm-6): bdev /dev/mapper/vg-2 errs:
>>> wr 0, rd 0, flush 0, corrupt 1, gen 0
>>> [244964.650239] BTRFS error (device dm-6): fixed up error at logical
>>> 1103626240 on dev /dev/mapper/vg-2
>>> [244964.650612] BTRFS warning (device dm-6): checksum error at logical
>>> 1103630336 on dev /dev/mapper/vg-2, sector 2116616, root 5, inode 257,
>>> offset 4096, length 4096, links 1 (path: test.bin)
>>> [244964.650757] BTRFS error (device dm-6): bdev /dev/mapper/vg-2 errs:
>>> wr 0, rd 0, flush 0, corrupt 2, gen 0
>>> [244964.683586] BTRFS error (device dm-6): fixed up error at logical
>>> 1103630336 on dev /dev/mapper/vg-2
>>> [root@f26s test]#
>>>
>>>
>>> Exact same corruption (same device and offset), but normal read of the
>>> file.
>>>
>>> [245721.613806] BTRFS warning (device dm-6): csum failed root 5 ino
>>> 257 off 0 csum 0x98f94189 expected csum 0xd8be3813 mirror 1
>>> [245721.614416] BTRFS warning (device dm-6): csum failed root 5 ino
>>> 257 off 4096 csum 0x05a1017f expected csum 0xef2302b4 mirror 1
>>> [245721.630131] BTRFS warning (device dm-6): csum failed root 5 ino
>>> 257 off 0 csum 0x98f94189 expected csum 0xd8be3813 mirror 1
>>> [245721.630656] BTRFS warning (device dm-6): csum failed root 5 ino
>>> 257 off 4096 csum 0x05a1017f expected csum 0xef2302b4 mirror 1
>>> [245721.638901] BTRFS info (device dm-6): read error corrected: ino
>>> 257 off 0 (dev /dev/mapper/vg-2 sector 2116608)
>>> [245721.639608] BTRFS info (device dm-6): read error corrected: ino
>>> 257 off 4096 (dev /dev/mapper/vg-2 sector 2116616)
>>> [245747.280718]
>>>
>>>
>>> scrub considers the fixup an error, normal read considers it info; but
>>> there's more useful information in the scrub output I think. I'd
>>> really like to see the warning make it clear whether this is metadata
>>> or data corruption though. From the above you have to infer it,
>>> because of the inode reference.
>>
>> OK, that actually explains why I had this incorrect assumption.  I've not
>> delved all that deep into that code, so I have no reference there, but
>> looking at the two messages, the scrub message makes it very clear that the
>> error was fixed, whereas the phrasing in the case of a normal read is kind
>> of ambiguous (as I see it, 'read error corrected' could mean that it was
>> actually repaired (fixed as scrub says), or that the error was corrected in
>> BTRFS by falling back to the old copy, and I assumed the second case given
>> the context).
>>
>> As far as the whole warning versus info versus error thing, I actually think
>> _that_ makes some sense.  If things got fixed, it's not exactly an error,
>> even though it would be nice to have some consistency there.  For scrub
>> however, it makes sense to have it all be labeled as an 'error' because
>> otherwise the log entries will be incomplete if dmesg is not set to report
>> anything less than an error (and the three lines are functionally _one_
>> entry).  I can also kind of understand scrub reporting error counts, but
>> regular reads not doing so (scrub is a diagnostic and repair tool, regular
>> reads aren't).
> 
> 
> I just did those corruptions as a test, and following the normal read
> fixup, a subsequent scrub finds no problems. And in both cases
> debug-tree shows pretty much identical metadata, at least the same
> chunks are intact and the tree the file is located in has the same
> logical address for the file in question. So this is not a COW fix up,
> it's an overwrite. (Something tells me that raid56 fixes corruptions
> differently, they may be cow).
> 
I would think that this is the only case it makes sense to 
unconditionally _not_ do a COW update.  In the event that the write gets 
interrupted, we're no worse off than we already were (the checksum will 
still fail), so there's not much point in incurring the overhead of a 
COW operation, except possibly with parity involved (because you might 
run the risk of both bogus parity _and_ a bogus checksum).
